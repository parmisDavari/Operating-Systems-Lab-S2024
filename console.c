// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
// #include "ctype.h"

static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;


static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  }
  else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}

#define INPUT_BUF 128
struct {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
  uint iterator; // iterator index
} input;

#define HIST_SIZE 10
struct {
  uint queue_idx;
  char cmd_buf[HIST_SIZE][INPUT_BUF];
  uint last_used_idx;

  int is_suggestion_used;
  char original_cmd[INPUT_BUF];
  uint original_cmd_size;
} hist;


#define K 7
char cachebuf [K + 1];

static void
consputs(char *s) //this prints out the string on the console
{
  uint i;
  for( i = 0; s[i] != '\0'; i++)
  {
    consputc(s[i]);
  }

}

#define R 0x52
static void 
copychars()
{
  uint i;
  int idx = input.e - K;
  if(idx == ((int) input.w))
  {
    idx = input.w;
  }

  for( i = 0; i < K && idx < input.e; i++, idx++)
  {
    cachebuf[i] = input.buf[idx];
    // consputc(R);
  }
  
  cachebuf[K] = '\0';

}

static void
cutchars()
{
  copychars();
  for (uint i = 0; i < K && (cachebuf[i]); i++)
  {
    consputc(BACKSPACE);
  }

}

static void
pastechars()
{
  consputs(cachebuf);
}

static void
multiplychars()
{
  uint i;
  uint j = 0;
  char cmd[INPUT_BUF] = {0};
  
  for(i = input.w; i < input.e && input.buf[i]; i++)
  {
    char c = input.buf[i];
    if(c >= '1' && c <= '9')
    {
      c = c + K;
      if(c > '9')
      {
        c += 'A' - 'a';
      }
      cmd[j++] = c;
    }
    else if(c >= 'a' && c <= 'z')
    {
      c += 'A' - 'a';
      cmd[j++] = c;
    }
    else if(c >= 'A' && c <= 'Z')
    {
      c += 'a' - 'A';
      cmd[j++] = c;
    }
  }
   while(input.e != input.w &&
    input.buf[(input.e-1) % INPUT_BUF] != '\n')
    {
      input.e--;
      consputc(BACKSPACE);
    }
  consputs(cmd);
}

static int
get_suggestion(const char* cmd, uint cmd_size)
{
  for(int i = HIST_SIZE - 1; i >= 0; i--){
    int idx = (i + hist.last_used_idx) % HIST_SIZE;
    if(strncmp(cmd, hist.cmd_buf[idx], cmd_size) == 0){
      return idx;
    }
  }
  return -1;
}

static void
completecommand()
{
  if(!hist.is_suggestion_used){
    hist.original_cmd_size = input.e - input.w;
    memmove(hist.original_cmd, input.buf + input.w, hist.original_cmd_size);
  }
  int suggested_cmd = get_suggestion(hist.original_cmd, hist.original_cmd_size);
  if(suggested_cmd >= 0){
    hist.is_suggestion_used = 1;
    hist.last_used_idx = suggested_cmd + 1;
    while(input.e != input.w &&
    input.buf[(input.e-1) % INPUT_BUF] != '\n')
    {
      input.e--;
      consputc(BACKSPACE);
    }
    consputs(hist.cmd_buf[suggested_cmd]);
  }
  else // beep
    consputc('\a');
}
#define C(x)  ((x)-'@')  // Control-x
// #define S(x) ((x) + ' ') // Shift-x (x is an arbitrary character)
#define TAB        '\t'

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;

    case ('C'): // copy seven characters back
      copychars();
      break;
    
    case ('X'): //cut
      cutchars();
      break;

    case ('V'): //paste
      pastechars();
      break;

    case C('E'):
      multiplychars();
      break;

    case TAB:
      completecommand();
      break;

    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}

