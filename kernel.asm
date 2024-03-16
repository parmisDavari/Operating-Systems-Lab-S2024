
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 90 5a 11 80       	mov    $0x80115a90,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 34 10 80       	mov    $0x80103410,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 75 10 80       	push   $0x80107540
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 25 47 00 00       	call   80104780 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 75 10 80       	push   $0x80107547
80100097:	50                   	push   %eax
80100098:	e8 b3 45 00 00       	call   80104650 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 67 48 00 00       	call   80104950 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 89 47 00 00       	call   801048f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 45 00 00       	call   80104690 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 24 00 00       	call   80102690 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 75 10 80       	push   $0x8010754e
801001a6:	e8 15 02 00 00       	call   801003c0 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 45 00 00       	call   80104730 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 b7 24 00 00       	jmp    80102690 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 75 10 80       	push   $0x8010755f
801001e1:	e8 da 01 00 00       	call   801003c0 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 45 00 00       	call   80104730 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 44 00 00       	call   801046f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 30 47 00 00       	call   80104950 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 7f 46 00 00       	jmp    801048f0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 75 10 80       	push   $0x80107566
80100279:	e8 42 01 00 00       	call   801003c0 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <copychars>:
}

#define R 0x52
static void 
copychars()
{
80100280:	55                   	push   %ebp
  uint i;
  int idx = input.e - K;
80100281:	8b 15 c8 f4 10 80    	mov    0x8010f4c8,%edx
  if(idx == ((int) input.w))
80100287:	8d 42 f9             	lea    -0x7(%edx),%eax
{
8010028a:	89 e5                	mov    %esp,%ebp
8010028c:	53                   	push   %ebx
    idx = input.w;
  }

  for( i = 0; i < K && idx < input.e; i++, idx++)
  {
    cachebuf[i] = input.buf[idx];
8010028d:	89 c3                	mov    %eax,%ebx
8010028f:	f7 db                	neg    %ebx
80100291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for( i = 0; i < K && idx < input.e; i++, idx++)
80100298:	39 c2                	cmp    %eax,%edx
8010029a:	76 15                	jbe    801002b1 <copychars+0x31>
    cachebuf[i] = input.buf[idx];
8010029c:	0f b6 88 40 f4 10 80 	movzbl -0x7fef0bc0(%eax),%ecx
801002a3:	88 8c 03 80 ee 10 80 	mov    %cl,-0x7fef1180(%ebx,%eax,1)
  for( i = 0; i < K && idx < input.e; i++, idx++)
801002aa:	83 c0 01             	add    $0x1,%eax
801002ad:	39 d0                	cmp    %edx,%eax
801002af:	75 e7                	jne    80100298 <copychars+0x18>
    // consputc(R);
  }
  
  cachebuf[K] = '\0';
801002b1:	c6 05 87 ee 10 80 00 	movb   $0x0,0x8010ee87

}
801002b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801002bb:	c9                   	leave  
801002bc:	c3                   	ret    
801002bd:	8d 76 00             	lea    0x0(%esi),%esi

801002c0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002c0:	55                   	push   %ebp
801002c1:	89 e5                	mov    %esp,%ebp
801002c3:	57                   	push   %edi
801002c4:	56                   	push   %esi
801002c5:	53                   	push   %ebx
801002c6:	83 ec 18             	sub    $0x18,%esp
801002c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002cf:	ff 75 08             	push   0x8(%ebp)
  target = n;
801002d2:	89 df                	mov    %ebx,%edi
  iunlock(ip);
801002d4:	e8 37 19 00 00       	call   80101c10 <iunlock>
  acquire(&cons.lock);
801002d9:	c7 04 24 e0 f4 10 80 	movl   $0x8010f4e0,(%esp)
801002e0:	e8 6b 46 00 00       	call   80104950 <acquire>
  while(n > 0){
801002e5:	83 c4 10             	add    $0x10,%esp
801002e8:	85 db                	test   %ebx,%ebx
801002ea:	0f 8e 94 00 00 00    	jle    80100384 <consoleread+0xc4>
    while(input.r == input.w){
801002f0:	a1 c0 f4 10 80       	mov    0x8010f4c0,%eax
801002f5:	3b 05 c4 f4 10 80    	cmp    0x8010f4c4,%eax
801002fb:	74 25                	je     80100322 <consoleread+0x62>
801002fd:	eb 59                	jmp    80100358 <consoleread+0x98>
801002ff:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100300:	83 ec 08             	sub    $0x8,%esp
80100303:	68 e0 f4 10 80       	push   $0x8010f4e0
80100308:	68 c0 f4 10 80       	push   $0x8010f4c0
8010030d:	e8 de 40 00 00       	call   801043f0 <sleep>
    while(input.r == input.w){
80100312:	a1 c0 f4 10 80       	mov    0x8010f4c0,%eax
80100317:	83 c4 10             	add    $0x10,%esp
8010031a:	3b 05 c4 f4 10 80    	cmp    0x8010f4c4,%eax
80100320:	75 36                	jne    80100358 <consoleread+0x98>
      if(myproc()->killed){
80100322:	e8 f9 39 00 00       	call   80103d20 <myproc>
80100327:	8b 48 24             	mov    0x24(%eax),%ecx
8010032a:	85 c9                	test   %ecx,%ecx
8010032c:	74 d2                	je     80100300 <consoleread+0x40>
        release(&cons.lock);
8010032e:	83 ec 0c             	sub    $0xc,%esp
80100331:	68 e0 f4 10 80       	push   $0x8010f4e0
80100336:	e8 b5 45 00 00       	call   801048f0 <release>
        ilock(ip);
8010033b:	5a                   	pop    %edx
8010033c:	ff 75 08             	push   0x8(%ebp)
8010033f:	e8 ec 17 00 00       	call   80101b30 <ilock>
        return -1;
80100344:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100347:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010034a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010034f:	5b                   	pop    %ebx
80100350:	5e                   	pop    %esi
80100351:	5f                   	pop    %edi
80100352:	5d                   	pop    %ebp
80100353:	c3                   	ret    
80100354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100358:	8d 50 01             	lea    0x1(%eax),%edx
8010035b:	89 15 c0 f4 10 80    	mov    %edx,0x8010f4c0
80100361:	89 c2                	mov    %eax,%edx
80100363:	83 e2 7f             	and    $0x7f,%edx
80100366:	0f be 8a 40 f4 10 80 	movsbl -0x7fef0bc0(%edx),%ecx
    if(c == C('D')){  // EOF
8010036d:	80 f9 04             	cmp    $0x4,%cl
80100370:	74 37                	je     801003a9 <consoleread+0xe9>
    *dst++ = c;
80100372:	83 c6 01             	add    $0x1,%esi
    --n;
80100375:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100378:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010037b:	83 f9 0a             	cmp    $0xa,%ecx
8010037e:	0f 85 64 ff ff ff    	jne    801002e8 <consoleread+0x28>
  release(&cons.lock);
80100384:	83 ec 0c             	sub    $0xc,%esp
80100387:	68 e0 f4 10 80       	push   $0x8010f4e0
8010038c:	e8 5f 45 00 00       	call   801048f0 <release>
  ilock(ip);
80100391:	58                   	pop    %eax
80100392:	ff 75 08             	push   0x8(%ebp)
80100395:	e8 96 17 00 00       	call   80101b30 <ilock>
  return target - n;
8010039a:	89 f8                	mov    %edi,%eax
8010039c:	83 c4 10             	add    $0x10,%esp
}
8010039f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
801003a2:	29 d8                	sub    %ebx,%eax
}
801003a4:	5b                   	pop    %ebx
801003a5:	5e                   	pop    %esi
801003a6:	5f                   	pop    %edi
801003a7:	5d                   	pop    %ebp
801003a8:	c3                   	ret    
      if(n < target){
801003a9:	39 fb                	cmp    %edi,%ebx
801003ab:	73 d7                	jae    80100384 <consoleread+0xc4>
        input.r--;
801003ad:	a3 c0 f4 10 80       	mov    %eax,0x8010f4c0
801003b2:	eb d0                	jmp    80100384 <consoleread+0xc4>
801003b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003bf:	90                   	nop

801003c0 <panic>:
{
801003c0:	55                   	push   %ebp
801003c1:	89 e5                	mov    %esp,%ebp
801003c3:	56                   	push   %esi
801003c4:	53                   	push   %ebx
801003c5:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003c8:	fa                   	cli    
  cons.locking = 0;
801003c9:	c7 05 14 f5 10 80 00 	movl   $0x0,0x8010f514
801003d0:	00 00 00 
  getcallerpcs(&s, pcs);
801003d3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003d6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003d9:	e8 c2 28 00 00       	call   80102ca0 <lapicid>
801003de:	83 ec 08             	sub    $0x8,%esp
801003e1:	50                   	push   %eax
801003e2:	68 6d 75 10 80       	push   $0x8010756d
801003e7:	e8 f4 02 00 00       	call   801006e0 <cprintf>
  cprintf(s);
801003ec:	58                   	pop    %eax
801003ed:	ff 75 08             	push   0x8(%ebp)
801003f0:	e8 eb 02 00 00       	call   801006e0 <cprintf>
  cprintf("\n");
801003f5:	c7 04 24 d7 7e 10 80 	movl   $0x80107ed7,(%esp)
801003fc:	e8 df 02 00 00       	call   801006e0 <cprintf>
  getcallerpcs(&s, pcs);
80100401:	8d 45 08             	lea    0x8(%ebp),%eax
80100404:	5a                   	pop    %edx
80100405:	59                   	pop    %ecx
80100406:	53                   	push   %ebx
80100407:	50                   	push   %eax
80100408:	e8 93 43 00 00       	call   801047a0 <getcallerpcs>
  for(i=0; i<10; i++)
8010040d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100410:	83 ec 08             	sub    $0x8,%esp
80100413:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
80100415:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
80100418:	68 81 75 10 80       	push   $0x80107581
8010041d:	e8 be 02 00 00       	call   801006e0 <cprintf>
  for(i=0; i<10; i++)
80100422:	83 c4 10             	add    $0x10,%esp
80100425:	39 f3                	cmp    %esi,%ebx
80100427:	75 e7                	jne    80100410 <panic+0x50>
  panicked = 1; // freeze other CPU
80100429:	c7 05 18 f5 10 80 01 	movl   $0x1,0x8010f518
80100430:	00 00 00 
  for(;;)
80100433:	eb fe                	jmp    80100433 <panic+0x73>
80100435:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010043c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100440 <consputc.part.0>:
consputc(int c)
80100440:	55                   	push   %ebp
80100441:	89 e5                	mov    %esp,%ebp
80100443:	57                   	push   %edi
80100444:	56                   	push   %esi
80100445:	53                   	push   %ebx
80100446:	89 c3                	mov    %eax,%ebx
80100448:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010044b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100450:	0f 84 ea 00 00 00    	je     80100540 <consputc.part.0+0x100>
    uartputc(c);
80100456:	83 ec 0c             	sub    $0xc,%esp
80100459:	50                   	push   %eax
8010045a:	e8 01 5c 00 00       	call   80106060 <uartputc>
8010045f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100462:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100467:	b8 0e 00 00 00       	mov    $0xe,%eax
8010046c:	89 fa                	mov    %edi,%edx
8010046e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010046f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100474:	89 f2                	mov    %esi,%edx
80100476:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100477:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010047a:	89 fa                	mov    %edi,%edx
8010047c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100481:	c1 e1 08             	shl    $0x8,%ecx
80100484:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100485:	89 f2                	mov    %esi,%edx
80100487:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100488:	0f b6 c0             	movzbl %al,%eax
8010048b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010048d:	83 fb 0a             	cmp    $0xa,%ebx
80100490:	0f 84 92 00 00 00    	je     80100528 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100496:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010049c:	74 72                	je     80100510 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010049e:	0f b6 db             	movzbl %bl,%ebx
801004a1:	8d 70 01             	lea    0x1(%eax),%esi
801004a4:	80 cf 07             	or     $0x7,%bh
801004a7:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004ae:	80 
  if(pos < 0 || pos > 25*80)
801004af:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
801004b5:	0f 8f fb 00 00 00    	jg     801005b6 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
801004bb:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
801004c1:	0f 8f a9 00 00 00    	jg     80100570 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
801004c7:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
801004c9:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
801004d0:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
801004d3:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004d6:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004db:	b8 0e 00 00 00       	mov    $0xe,%eax
801004e0:	89 da                	mov    %ebx,%edx
801004e2:	ee                   	out    %al,(%dx)
801004e3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004e8:	89 f8                	mov    %edi,%eax
801004ea:	89 ca                	mov    %ecx,%edx
801004ec:	ee                   	out    %al,(%dx)
801004ed:	b8 0f 00 00 00       	mov    $0xf,%eax
801004f2:	89 da                	mov    %ebx,%edx
801004f4:	ee                   	out    %al,(%dx)
801004f5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004f9:	89 ca                	mov    %ecx,%edx
801004fb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004fc:	b8 20 07 00 00       	mov    $0x720,%eax
80100501:	66 89 06             	mov    %ax,(%esi)
}
80100504:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100507:	5b                   	pop    %ebx
80100508:	5e                   	pop    %esi
80100509:	5f                   	pop    %edi
8010050a:	5d                   	pop    %ebp
8010050b:	c3                   	ret    
8010050c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
80100510:	8d 70 ff             	lea    -0x1(%eax),%esi
80100513:	85 c0                	test   %eax,%eax
80100515:	75 98                	jne    801004af <consputc.part.0+0x6f>
80100517:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
8010051b:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100520:	31 ff                	xor    %edi,%edi
80100522:	eb b2                	jmp    801004d6 <consputc.part.0+0x96>
80100524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100528:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010052d:	f7 e2                	mul    %edx
8010052f:	c1 ea 06             	shr    $0x6,%edx
80100532:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100535:	c1 e0 04             	shl    $0x4,%eax
80100538:	8d 70 50             	lea    0x50(%eax),%esi
8010053b:	e9 6f ff ff ff       	jmp    801004af <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100540:	83 ec 0c             	sub    $0xc,%esp
80100543:	6a 08                	push   $0x8
80100545:	e8 16 5b 00 00       	call   80106060 <uartputc>
8010054a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100551:	e8 0a 5b 00 00       	call   80106060 <uartputc>
80100556:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010055d:	e8 fe 5a 00 00       	call   80106060 <uartputc>
80100562:	83 c4 10             	add    $0x10,%esp
80100565:	e9 f8 fe ff ff       	jmp    80100462 <consputc.part.0+0x22>
8010056a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100570:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100573:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100576:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010057d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100582:	68 60 0e 00 00       	push   $0xe60
80100587:	68 a0 80 0b 80       	push   $0x800b80a0
8010058c:	68 00 80 0b 80       	push   $0x800b8000
80100591:	e8 1a 45 00 00       	call   80104ab0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100596:	b8 80 07 00 00       	mov    $0x780,%eax
8010059b:	83 c4 0c             	add    $0xc,%esp
8010059e:	29 d8                	sub    %ebx,%eax
801005a0:	01 c0                	add    %eax,%eax
801005a2:	50                   	push   %eax
801005a3:	6a 00                	push   $0x0
801005a5:	56                   	push   %esi
801005a6:	e8 65 44 00 00       	call   80104a10 <memset>
  outb(CRTPORT+1, pos);
801005ab:	88 5d e7             	mov    %bl,-0x19(%ebp)
801005ae:	83 c4 10             	add    $0x10,%esp
801005b1:	e9 20 ff ff ff       	jmp    801004d6 <consputc.part.0+0x96>
    panic("pos under/overflow");
801005b6:	83 ec 0c             	sub    $0xc,%esp
801005b9:	68 85 75 10 80       	push   $0x80107585
801005be:	e8 fd fd ff ff       	call   801003c0 <panic>
801005c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005d0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801005d9:	ff 75 08             	push   0x8(%ebp)
{
801005dc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005df:	e8 2c 16 00 00       	call   80101c10 <iunlock>
  acquire(&cons.lock);
801005e4:	c7 04 24 e0 f4 10 80 	movl   $0x8010f4e0,(%esp)
801005eb:	e8 60 43 00 00       	call   80104950 <acquire>
  for(i = 0; i < n; i++)
801005f0:	83 c4 10             	add    $0x10,%esp
801005f3:	85 f6                	test   %esi,%esi
801005f5:	7e 25                	jle    8010061c <consolewrite+0x4c>
801005f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005fa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005fd:	8b 15 18 f5 10 80    	mov    0x8010f518,%edx
    consputc(buf[i] & 0xff);
80100603:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100606:	85 d2                	test   %edx,%edx
80100608:	74 06                	je     80100610 <consolewrite+0x40>
  asm volatile("cli");
8010060a:	fa                   	cli    
    for(;;)
8010060b:	eb fe                	jmp    8010060b <consolewrite+0x3b>
8010060d:	8d 76 00             	lea    0x0(%esi),%esi
80100610:	e8 2b fe ff ff       	call   80100440 <consputc.part.0>
  for(i = 0; i < n; i++)
80100615:	83 c3 01             	add    $0x1,%ebx
80100618:	39 df                	cmp    %ebx,%edi
8010061a:	75 e1                	jne    801005fd <consolewrite+0x2d>
  release(&cons.lock);
8010061c:	83 ec 0c             	sub    $0xc,%esp
8010061f:	68 e0 f4 10 80       	push   $0x8010f4e0
80100624:	e8 c7 42 00 00       	call   801048f0 <release>
  ilock(ip);
80100629:	58                   	pop    %eax
8010062a:	ff 75 08             	push   0x8(%ebp)
8010062d:	e8 fe 14 00 00       	call   80101b30 <ilock>

  return n;
}
80100632:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100635:	89 f0                	mov    %esi,%eax
80100637:	5b                   	pop    %ebx
80100638:	5e                   	pop    %esi
80100639:	5f                   	pop    %edi
8010063a:	5d                   	pop    %ebp
8010063b:	c3                   	ret    
8010063c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100640 <printint>:
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	83 ec 2c             	sub    $0x2c,%esp
80100649:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010064c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010064f:	85 c9                	test   %ecx,%ecx
80100651:	74 04                	je     80100657 <printint+0x17>
80100653:	85 c0                	test   %eax,%eax
80100655:	78 6d                	js     801006c4 <printint+0x84>
    x = xx;
80100657:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010065e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100660:	31 db                	xor    %ebx,%ebx
80100662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100668:	89 c8                	mov    %ecx,%eax
8010066a:	31 d2                	xor    %edx,%edx
8010066c:	89 de                	mov    %ebx,%esi
8010066e:	89 cf                	mov    %ecx,%edi
80100670:	f7 75 d4             	divl   -0x2c(%ebp)
80100673:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100676:	0f b6 92 f4 75 10 80 	movzbl -0x7fef8a0c(%edx),%edx
  }while((x /= base) != 0);
8010067d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010067f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100683:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100686:	73 e0                	jae    80100668 <printint+0x28>
  if(sign)
80100688:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010068b:	85 c9                	test   %ecx,%ecx
8010068d:	74 0c                	je     8010069b <printint+0x5b>
    buf[i++] = '-';
8010068f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100694:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100696:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010069b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010069f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
801006a2:	8b 15 18 f5 10 80    	mov    0x8010f518,%edx
801006a8:	85 d2                	test   %edx,%edx
801006aa:	74 04                	je     801006b0 <printint+0x70>
801006ac:	fa                   	cli    
    for(;;)
801006ad:	eb fe                	jmp    801006ad <printint+0x6d>
801006af:	90                   	nop
801006b0:	e8 8b fd ff ff       	call   80100440 <consputc.part.0>
  while(--i >= 0)
801006b5:	8d 45 d7             	lea    -0x29(%ebp),%eax
801006b8:	39 c3                	cmp    %eax,%ebx
801006ba:	74 0e                	je     801006ca <printint+0x8a>
    consputc(buf[i]);
801006bc:	0f be 03             	movsbl (%ebx),%eax
801006bf:	83 eb 01             	sub    $0x1,%ebx
801006c2:	eb de                	jmp    801006a2 <printint+0x62>
    x = -xx;
801006c4:	f7 d8                	neg    %eax
801006c6:	89 c1                	mov    %eax,%ecx
801006c8:	eb 96                	jmp    80100660 <printint+0x20>
}
801006ca:	83 c4 2c             	add    $0x2c,%esp
801006cd:	5b                   	pop    %ebx
801006ce:	5e                   	pop    %esi
801006cf:	5f                   	pop    %edi
801006d0:	5d                   	pop    %ebp
801006d1:	c3                   	ret    
801006d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006e0 <cprintf>:
{
801006e0:	55                   	push   %ebp
801006e1:	89 e5                	mov    %esp,%ebp
801006e3:	57                   	push   %edi
801006e4:	56                   	push   %esi
801006e5:	53                   	push   %ebx
801006e6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006e9:	a1 14 f5 10 80       	mov    0x8010f514,%eax
801006ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006f1:	85 c0                	test   %eax,%eax
801006f3:	0f 85 27 01 00 00    	jne    80100820 <cprintf+0x140>
  if (fmt == 0)
801006f9:	8b 75 08             	mov    0x8(%ebp),%esi
801006fc:	85 f6                	test   %esi,%esi
801006fe:	0f 84 ac 01 00 00    	je     801008b0 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100704:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100707:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	31 db                	xor    %ebx,%ebx
8010070c:	85 c0                	test   %eax,%eax
8010070e:	74 56                	je     80100766 <cprintf+0x86>
    if(c != '%'){
80100710:	83 f8 25             	cmp    $0x25,%eax
80100713:	0f 85 cf 00 00 00    	jne    801007e8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
80100719:	83 c3 01             	add    $0x1,%ebx
8010071c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100720:	85 d2                	test   %edx,%edx
80100722:	74 42                	je     80100766 <cprintf+0x86>
    switch(c){
80100724:	83 fa 70             	cmp    $0x70,%edx
80100727:	0f 84 90 00 00 00    	je     801007bd <cprintf+0xdd>
8010072d:	7f 51                	jg     80100780 <cprintf+0xa0>
8010072f:	83 fa 25             	cmp    $0x25,%edx
80100732:	0f 84 c0 00 00 00    	je     801007f8 <cprintf+0x118>
80100738:	83 fa 64             	cmp    $0x64,%edx
8010073b:	0f 85 f4 00 00 00    	jne    80100835 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100741:	8d 47 04             	lea    0x4(%edi),%eax
80100744:	b9 01 00 00 00       	mov    $0x1,%ecx
80100749:	ba 0a 00 00 00       	mov    $0xa,%edx
8010074e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100751:	8b 07                	mov    (%edi),%eax
80100753:	e8 e8 fe ff ff       	call   80100640 <printint>
80100758:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010075b:	83 c3 01             	add    $0x1,%ebx
8010075e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100762:	85 c0                	test   %eax,%eax
80100764:	75 aa                	jne    80100710 <cprintf+0x30>
  if(locking)
80100766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100769:	85 c0                	test   %eax,%eax
8010076b:	0f 85 22 01 00 00    	jne    80100893 <cprintf+0x1b3>
}
80100771:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100774:	5b                   	pop    %ebx
80100775:	5e                   	pop    %esi
80100776:	5f                   	pop    %edi
80100777:	5d                   	pop    %ebp
80100778:	c3                   	ret    
80100779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100780:	83 fa 73             	cmp    $0x73,%edx
80100783:	75 33                	jne    801007b8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100785:	8d 47 04             	lea    0x4(%edi),%eax
80100788:	8b 3f                	mov    (%edi),%edi
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	85 ff                	test   %edi,%edi
8010078f:	0f 84 e3 00 00 00    	je     80100878 <cprintf+0x198>
      for(; *s; s++)
80100795:	0f be 07             	movsbl (%edi),%eax
80100798:	84 c0                	test   %al,%al
8010079a:	0f 84 08 01 00 00    	je     801008a8 <cprintf+0x1c8>
  if(panicked){
801007a0:	8b 15 18 f5 10 80    	mov    0x8010f518,%edx
801007a6:	85 d2                	test   %edx,%edx
801007a8:	0f 84 b2 00 00 00    	je     80100860 <cprintf+0x180>
801007ae:	fa                   	cli    
    for(;;)
801007af:	eb fe                	jmp    801007af <cprintf+0xcf>
801007b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801007b8:	83 fa 78             	cmp    $0x78,%edx
801007bb:	75 78                	jne    80100835 <cprintf+0x155>
      printint(*argp++, 16, 0);
801007bd:	8d 47 04             	lea    0x4(%edi),%eax
801007c0:	31 c9                	xor    %ecx,%ecx
801007c2:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007c7:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007cd:	8b 07                	mov    (%edi),%eax
801007cf:	e8 6c fe ff ff       	call   80100640 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007d4:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007db:	85 c0                	test   %eax,%eax
801007dd:	0f 85 2d ff ff ff    	jne    80100710 <cprintf+0x30>
801007e3:	eb 81                	jmp    80100766 <cprintf+0x86>
801007e5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007e8:	8b 0d 18 f5 10 80    	mov    0x8010f518,%ecx
801007ee:	85 c9                	test   %ecx,%ecx
801007f0:	74 14                	je     80100806 <cprintf+0x126>
801007f2:	fa                   	cli    
    for(;;)
801007f3:	eb fe                	jmp    801007f3 <cprintf+0x113>
801007f5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007f8:	a1 18 f5 10 80       	mov    0x8010f518,%eax
801007fd:	85 c0                	test   %eax,%eax
801007ff:	75 6c                	jne    8010086d <cprintf+0x18d>
80100801:	b8 25 00 00 00       	mov    $0x25,%eax
80100806:	e8 35 fc ff ff       	call   80100440 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010080b:	83 c3 01             	add    $0x1,%ebx
8010080e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100812:	85 c0                	test   %eax,%eax
80100814:	0f 85 f6 fe ff ff    	jne    80100710 <cprintf+0x30>
8010081a:	e9 47 ff ff ff       	jmp    80100766 <cprintf+0x86>
8010081f:	90                   	nop
    acquire(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 e0 f4 10 80       	push   $0x8010f4e0
80100828:	e8 23 41 00 00       	call   80104950 <acquire>
8010082d:	83 c4 10             	add    $0x10,%esp
80100830:	e9 c4 fe ff ff       	jmp    801006f9 <cprintf+0x19>
  if(panicked){
80100835:	8b 0d 18 f5 10 80    	mov    0x8010f518,%ecx
8010083b:	85 c9                	test   %ecx,%ecx
8010083d:	75 31                	jne    80100870 <cprintf+0x190>
8010083f:	b8 25 00 00 00       	mov    $0x25,%eax
80100844:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100847:	e8 f4 fb ff ff       	call   80100440 <consputc.part.0>
8010084c:	8b 15 18 f5 10 80    	mov    0x8010f518,%edx
80100852:	85 d2                	test   %edx,%edx
80100854:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100857:	74 2e                	je     80100887 <cprintf+0x1a7>
80100859:	fa                   	cli    
    for(;;)
8010085a:	eb fe                	jmp    8010085a <cprintf+0x17a>
8010085c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100860:	e8 db fb ff ff       	call   80100440 <consputc.part.0>
      for(; *s; s++)
80100865:	83 c7 01             	add    $0x1,%edi
80100868:	e9 28 ff ff ff       	jmp    80100795 <cprintf+0xb5>
8010086d:	fa                   	cli    
    for(;;)
8010086e:	eb fe                	jmp    8010086e <cprintf+0x18e>
80100870:	fa                   	cli    
80100871:	eb fe                	jmp    80100871 <cprintf+0x191>
80100873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100877:	90                   	nop
        s = "(null)";
80100878:	bf 98 75 10 80       	mov    $0x80107598,%edi
      for(; *s; s++)
8010087d:	b8 28 00 00 00       	mov    $0x28,%eax
80100882:	e9 19 ff ff ff       	jmp    801007a0 <cprintf+0xc0>
80100887:	89 d0                	mov    %edx,%eax
80100889:	e8 b2 fb ff ff       	call   80100440 <consputc.part.0>
8010088e:	e9 c8 fe ff ff       	jmp    8010075b <cprintf+0x7b>
    release(&cons.lock);
80100893:	83 ec 0c             	sub    $0xc,%esp
80100896:	68 e0 f4 10 80       	push   $0x8010f4e0
8010089b:	e8 50 40 00 00       	call   801048f0 <release>
801008a0:	83 c4 10             	add    $0x10,%esp
}
801008a3:	e9 c9 fe ff ff       	jmp    80100771 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008ab:	e9 ab fe ff ff       	jmp    8010075b <cprintf+0x7b>
    panic("null fmt");
801008b0:	83 ec 0c             	sub    $0xc,%esp
801008b3:	68 9f 75 10 80       	push   $0x8010759f
801008b8:	e8 03 fb ff ff       	call   801003c0 <panic>
801008bd:	8d 76 00             	lea    0x0(%esi),%esi

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
801008c4:	56                   	push   %esi
801008c5:	53                   	push   %ebx
801008c6:	81 ec a8 00 00 00    	sub    $0xa8,%esp
801008cc:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008cf:	68 e0 f4 10 80       	push   $0x8010f4e0
801008d4:	e8 77 40 00 00       	call   80104950 <acquire>
  while((c = getc()) >= 0){
801008d9:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
801008dc:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
801008e3:	00 00 00 
  while((c = getc()) >= 0){
801008e6:	ff d6                	call   *%esi
801008e8:	89 c1                	mov    %eax,%ecx
801008ea:	85 c0                	test   %eax,%eax
801008ec:	78 72                	js     80100960 <consoleintr+0xa0>
    switch(c){
801008ee:	83 f9 15             	cmp    $0x15,%ecx
801008f1:	7f 1d                	jg     80100910 <consoleintr+0x50>
801008f3:	83 f9 04             	cmp    $0x4,%ecx
801008f6:	0f 8e 0c 01 00 00    	jle    80100a08 <consoleintr+0x148>
801008fc:	8d 41 fb             	lea    -0x5(%ecx),%eax
801008ff:	83 f8 10             	cmp    $0x10,%eax
80100902:	0f 87 00 01 00 00    	ja     80100a08 <consoleintr+0x148>
80100908:	ff 24 85 b0 75 10 80 	jmp    *-0x7fef8a50(,%eax,4)
8010090f:	90                   	nop
80100910:	83 f9 56             	cmp    $0x56,%ecx
80100913:	0f 84 37 03 00 00    	je     80100c50 <consoleintr+0x390>
80100919:	7e 25                	jle    80100940 <consoleintr+0x80>
8010091b:	83 f9 58             	cmp    $0x58,%ecx
8010091e:	75 70                	jne    80100990 <consoleintr+0xd0>
  copychars();
80100920:	e8 5b f9 ff ff       	call   80100280 <copychars>
  for (uint i = 0; i < K && (cachebuf[i]); i++)
80100925:	31 db                	xor    %ebx,%ebx
80100927:	80 bb 80 ee 10 80 00 	cmpb   $0x0,-0x7fef1180(%ebx)
8010092e:	74 b6                	je     801008e6 <consoleintr+0x26>
  if(panicked){
80100930:	a1 18 f5 10 80       	mov    0x8010f518,%eax
80100935:	85 c0                	test   %eax,%eax
80100937:	0f 84 6b 01 00 00    	je     80100aa8 <consoleintr+0x1e8>
8010093d:	fa                   	cli    
    for(;;)
8010093e:	eb fe                	jmp    8010093e <consoleintr+0x7e>
    switch(c){
80100940:	83 f9 43             	cmp    $0x43,%ecx
80100943:	0f 85 c7 00 00 00    	jne    80100a10 <consoleintr+0x150>
      copychars();
80100949:	e8 32 f9 ff ff       	call   80100280 <copychars>
  while((c = getc()) >= 0){
8010094e:	ff d6                	call   *%esi
80100950:	89 c1                	mov    %eax,%ecx
80100952:	85 c0                	test   %eax,%eax
80100954:	79 98                	jns    801008ee <consoleintr+0x2e>
80100956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100960:	83 ec 0c             	sub    $0xc,%esp
80100963:	68 e0 f4 10 80       	push   $0x8010f4e0
80100968:	e8 83 3f 00 00       	call   801048f0 <release>
  if(doprocdump) {
8010096d:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
80100973:	83 c4 10             	add    $0x10,%esp
80100976:	85 d2                	test   %edx,%edx
80100978:	0f 85 92 03 00 00    	jne    80100d10 <consoleintr+0x450>
}
8010097e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100981:	5b                   	pop    %ebx
80100982:	5e                   	pop    %esi
80100983:	5f                   	pop    %edi
80100984:	5d                   	pop    %ebp
80100985:	c3                   	ret    
80100986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010098d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100990:	83 f9 7f             	cmp    $0x7f,%ecx
80100993:	75 7b                	jne    80100a10 <consoleintr+0x150>
      if(input.e != input.w){
80100995:	a1 c8 f4 10 80       	mov    0x8010f4c8,%eax
8010099a:	3b 05 c4 f4 10 80    	cmp    0x8010f4c4,%eax
801009a0:	0f 84 40 ff ff ff    	je     801008e6 <consoleintr+0x26>
        input.e--;
801009a6:	83 e8 01             	sub    $0x1,%eax
801009a9:	a3 c8 f4 10 80       	mov    %eax,0x8010f4c8
  if(panicked){
801009ae:	a1 18 f5 10 80       	mov    0x8010f518,%eax
801009b3:	85 c0                	test   %eax,%eax
801009b5:	0f 84 9c 03 00 00    	je     80100d57 <consoleintr+0x497>
801009bb:	fa                   	cli    
    for(;;)
801009bc:	eb fe                	jmp    801009bc <consoleintr+0xfc>
801009be:	66 90                	xchg   %ax,%ax
801009c0:	b8 00 01 00 00       	mov    $0x100,%eax
801009c5:	e8 76 fa ff ff       	call   80100440 <consputc.part.0>
      while(input.e != input.w &&
801009ca:	a1 c8 f4 10 80       	mov    0x8010f4c8,%eax
801009cf:	3b 05 c4 f4 10 80    	cmp    0x8010f4c4,%eax
801009d5:	0f 84 0b ff ff ff    	je     801008e6 <consoleintr+0x26>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009db:	83 e8 01             	sub    $0x1,%eax
801009de:	89 c2                	mov    %eax,%edx
801009e0:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009e3:	80 ba 40 f4 10 80 0a 	cmpb   $0xa,-0x7fef0bc0(%edx)
801009ea:	0f 84 f6 fe ff ff    	je     801008e6 <consoleintr+0x26>
        input.e--;
801009f0:	a3 c8 f4 10 80       	mov    %eax,0x8010f4c8
  if(panicked){
801009f5:	a1 18 f5 10 80       	mov    0x8010f518,%eax
801009fa:	85 c0                	test   %eax,%eax
801009fc:	74 c2                	je     801009c0 <consoleintr+0x100>
801009fe:	fa                   	cli    
    for(;;)
801009ff:	eb fe                	jmp    801009ff <consoleintr+0x13f>
80100a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a08:	85 c9                	test   %ecx,%ecx
80100a0a:	0f 84 d6 fe ff ff    	je     801008e6 <consoleintr+0x26>
80100a10:	a1 c8 f4 10 80       	mov    0x8010f4c8,%eax
80100a15:	89 c2                	mov    %eax,%edx
80100a17:	2b 15 c0 f4 10 80    	sub    0x8010f4c0,%edx
80100a1d:	83 fa 7f             	cmp    $0x7f,%edx
80100a20:	0f 87 c0 fe ff ff    	ja     801008e6 <consoleintr+0x26>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a26:	8d 58 01             	lea    0x1(%eax),%ebx
  if(panicked){
80100a29:	8b 15 18 f5 10 80    	mov    0x8010f518,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a2f:	83 e0 7f             	and    $0x7f,%eax
80100a32:	89 1d c8 f4 10 80    	mov    %ebx,0x8010f4c8
        c = (c == '\r') ? '\n' : c;
80100a38:	83 f9 0d             	cmp    $0xd,%ecx
80100a3b:	0f 84 97 03 00 00    	je     80100dd8 <consoleintr+0x518>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a41:	88 88 40 f4 10 80    	mov    %cl,-0x7fef0bc0(%eax)
  if(panicked){
80100a47:	85 d2                	test   %edx,%edx
80100a49:	0f 85 64 03 00 00    	jne    80100db3 <consoleintr+0x4f3>
80100a4f:	89 c8                	mov    %ecx,%eax
80100a51:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
80100a57:	e8 e4 f9 ff ff       	call   80100440 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a5c:	8b 8d 60 ff ff ff    	mov    -0xa0(%ebp),%ecx
80100a62:	83 f9 0a             	cmp    $0xa,%ecx
80100a65:	0f 84 82 03 00 00    	je     80100ded <consoleintr+0x52d>
80100a6b:	83 f9 04             	cmp    $0x4,%ecx
80100a6e:	0f 84 79 03 00 00    	je     80100ded <consoleintr+0x52d>
80100a74:	a1 c0 f4 10 80       	mov    0x8010f4c0,%eax
80100a79:	83 e8 80             	sub    $0xffffff80,%eax
80100a7c:	39 05 c8 f4 10 80    	cmp    %eax,0x8010f4c8
80100a82:	0f 85 5e fe ff ff    	jne    801008e6 <consoleintr+0x26>
          wakeup(&input.r);
80100a88:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a8b:	a3 c4 f4 10 80       	mov    %eax,0x8010f4c4
          wakeup(&input.r);
80100a90:	68 c0 f4 10 80       	push   $0x8010f4c0
80100a95:	e8 16 3a 00 00       	call   801044b0 <wakeup>
80100a9a:	83 c4 10             	add    $0x10,%esp
80100a9d:	e9 44 fe ff ff       	jmp    801008e6 <consoleintr+0x26>
80100aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100aa8:	b8 00 01 00 00       	mov    $0x100,%eax
  for (uint i = 0; i < K && (cachebuf[i]); i++)
80100aad:	83 c3 01             	add    $0x1,%ebx
80100ab0:	e8 8b f9 ff ff       	call   80100440 <consputc.part.0>
80100ab5:	83 fb 07             	cmp    $0x7,%ebx
80100ab8:	0f 85 69 fe ff ff    	jne    80100927 <consoleintr+0x67>
80100abe:	e9 23 fe ff ff       	jmp    801008e6 <consoleintr+0x26>
  char cmd[INPUT_BUF] = {0};
80100ac3:	8d bd 6c ff ff ff    	lea    -0x94(%ebp),%edi
80100ac9:	b9 1f 00 00 00       	mov    $0x1f,%ecx
80100ace:	31 c0                	xor    %eax,%eax
  for(i = input.w; i < input.e && input.buf[i]; i++)
80100ad0:	8b 15 c4 f4 10 80    	mov    0x8010f4c4,%edx
  char cmd[INPUT_BUF] = {0};
80100ad6:	f3 ab                	rep stos %eax,%es:(%edi)
  for(i = input.w; i < input.e && input.buf[i]; i++)
80100ad8:	8b 3d c8 f4 10 80    	mov    0x8010f4c8,%edi
  char cmd[INPUT_BUF] = {0};
80100ade:	c7 85 68 ff ff ff 00 	movl   $0x0,-0x98(%ebp)
80100ae5:	00 00 00 
  for(i = input.w; i < input.e && input.buf[i]; i++)
80100ae8:	39 fa                	cmp    %edi,%edx
80100aea:	72 29                	jb     80100b15 <consoleintr+0x255>
80100aec:	e9 06 03 00 00       	jmp    80100df7 <consoleintr+0x537>
80100af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      c = c + K;
80100af8:	8d 58 07             	lea    0x7(%eax),%ebx
        c += 'A' - 'a';
80100afb:	83 e8 19             	sub    $0x19,%eax
80100afe:	80 fb 39             	cmp    $0x39,%bl
80100b01:	0f 47 d8             	cmova  %eax,%ebx
      cmd[j++] = c;
80100b04:	88 9c 0d 68 ff ff ff 	mov    %bl,-0x98(%ebp,%ecx,1)
80100b0b:	83 c1 01             	add    $0x1,%ecx
  for(i = input.w; i < input.e && input.buf[i]; i++)
80100b0e:	83 c2 01             	add    $0x1,%edx
80100b11:	39 fa                	cmp    %edi,%edx
80100b13:	74 4a                	je     80100b5f <consoleintr+0x29f>
80100b15:	0f b6 82 40 f4 10 80 	movzbl -0x7fef0bc0(%edx),%eax
80100b1c:	84 c0                	test   %al,%al
80100b1e:	74 3f                	je     80100b5f <consoleintr+0x29f>
    if(c >= '1' && c <= '9')
80100b20:	8d 58 cf             	lea    -0x31(%eax),%ebx
80100b23:	80 fb 08             	cmp    $0x8,%bl
80100b26:	76 d0                	jbe    80100af8 <consoleintr+0x238>
    else if(c >= 'a' && c <= 'z')
80100b28:	8d 58 9f             	lea    -0x61(%eax),%ebx
80100b2b:	80 fb 19             	cmp    $0x19,%bl
80100b2e:	0f 87 fc 00 00 00    	ja     80100c30 <consoleintr+0x370>
      c += 'A' - 'a';
80100b34:	83 e8 20             	sub    $0x20,%eax
80100b37:	88 84 0d 68 ff ff ff 	mov    %al,-0x98(%ebp,%ecx,1)
      cmd[j++] = c;
80100b3e:	83 c1 01             	add    $0x1,%ecx
80100b41:	eb cb                	jmp    80100b0e <consoleintr+0x24e>
80100b43:	b8 00 01 00 00       	mov    $0x100,%eax
80100b48:	e8 f3 f8 ff ff       	call   80100440 <consputc.part.0>
   while(input.e != input.w &&
80100b4d:	8b 3d c8 f4 10 80    	mov    0x8010f4c8,%edi
80100b53:	3b 3d c4 f4 10 80    	cmp    0x8010f4c4,%edi
80100b59:	0f 84 07 02 00 00    	je     80100d66 <consoleintr+0x4a6>
    input.buf[(input.e-1) % INPUT_BUF] != '\n')
80100b5f:	8d 47 ff             	lea    -0x1(%edi),%eax
80100b62:	89 c2                	mov    %eax,%edx
80100b64:	83 e2 7f             	and    $0x7f,%edx
   while(input.e != input.w &&
80100b67:	80 ba 40 f4 10 80 0a 	cmpb   $0xa,-0x7fef0bc0(%edx)
80100b6e:	0f 84 f2 01 00 00    	je     80100d66 <consoleintr+0x4a6>
  if(panicked){
80100b74:	8b 0d 18 f5 10 80    	mov    0x8010f518,%ecx
      input.e--;
80100b7a:	a3 c8 f4 10 80       	mov    %eax,0x8010f4c8
  if(panicked){
80100b7f:	85 c9                	test   %ecx,%ecx
80100b81:	74 c0                	je     80100b43 <consoleintr+0x283>
80100b83:	fa                   	cli    
    for(;;)
80100b84:	eb fe                	jmp    80100b84 <consoleintr+0x2c4>
80100b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b8d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!hist.is_suggestion_used){
80100b90:	a1 a8 f3 10 80       	mov    0x8010f3a8,%eax
80100b95:	85 c0                	test   %eax,%eax
80100b97:	0f 84 7f 01 00 00    	je     80100d1c <consoleintr+0x45c>
  int suggested_cmd = get_suggestion(hist.original_cmd, hist.original_cmd_size);
80100b9d:	a1 2c f4 10 80       	mov    0x8010f42c,%eax
80100ba2:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
80100ba8:	89 ce                	mov    %ecx,%esi
80100baa:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
    int idx = (i + hist.last_used_idx) % HIST_SIZE;
80100bb0:	8b 1d a4 f3 10 80    	mov    0x8010f3a4,%ebx
80100bb6:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
    if(strncmp(cmd, hist.cmd_buf[idx], cmd_size) == 0){
80100bbb:	83 ec 04             	sub    $0x4,%esp
80100bbe:	ff b5 60 ff ff ff    	push   -0xa0(%ebp)
    int idx = (i + hist.last_used_idx) % HIST_SIZE;
80100bc4:	01 f3                	add    %esi,%ebx
80100bc6:	f7 e3                	mul    %ebx
80100bc8:	89 d7                	mov    %edx,%edi
80100bca:	c1 ef 03             	shr    $0x3,%edi
80100bcd:	8d 04 bf             	lea    (%edi,%edi,4),%eax
80100bd0:	89 df                	mov    %ebx,%edi
80100bd2:	01 c0                	add    %eax,%eax
80100bd4:	29 c7                	sub    %eax,%edi
    if(strncmp(cmd, hist.cmd_buf[idx], cmd_size) == 0){
80100bd6:	89 fb                	mov    %edi,%ebx
80100bd8:	c1 e3 07             	shl    $0x7,%ebx
80100bdb:	81 c3 a4 ee 10 80    	add    $0x8010eea4,%ebx
80100be1:	53                   	push   %ebx
80100be2:	68 ac f3 10 80       	push   $0x8010f3ac
80100be7:	e8 34 3f 00 00       	call   80104b20 <strncmp>
80100bec:	83 c4 10             	add    $0x10,%esp
80100bef:	85 c0                	test   %eax,%eax
80100bf1:	0f 84 91 00 00 00    	je     80100c88 <consoleintr+0x3c8>
  for(int i = HIST_SIZE - 1; i >= 0; i--){
80100bf7:	83 ee 01             	sub    $0x1,%esi
80100bfa:	73 b4                	jae    80100bb0 <consoleintr+0x2f0>
  if(panicked){
80100bfc:	a1 18 f5 10 80       	mov    0x8010f518,%eax
80100c01:	8b b5 5c ff ff ff    	mov    -0xa4(%ebp),%esi
80100c07:	85 c0                	test   %eax,%eax
80100c09:	0f 84 95 01 00 00    	je     80100da4 <consoleintr+0x4e4>
80100c0f:	fa                   	cli    
    for(;;)
80100c10:	eb fe                	jmp    80100c10 <consoleintr+0x350>
80100c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100c18:	c7 85 64 ff ff ff 01 	movl   $0x1,-0x9c(%ebp)
80100c1f:	00 00 00 
80100c22:	e9 bf fc ff ff       	jmp    801008e6 <consoleintr+0x26>
80100c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2e:	66 90                	xchg   %ax,%ax
    else if(c >= 'A' && c <= 'Z')
80100c30:	8d 58 bf             	lea    -0x41(%eax),%ebx
80100c33:	80 fb 19             	cmp    $0x19,%bl
80100c36:	0f 87 d2 fe ff ff    	ja     80100b0e <consoleintr+0x24e>
      c += 'a' - 'A';
80100c3c:	83 c0 20             	add    $0x20,%eax
80100c3f:	88 84 0d 68 ff ff ff 	mov    %al,-0x98(%ebp,%ecx,1)
      cmd[j++] = c;
80100c46:	83 c1 01             	add    $0x1,%ecx
80100c49:	e9 c0 fe ff ff       	jmp    80100b0e <consoleintr+0x24e>
80100c4e:	66 90                	xchg   %ax,%ax
  for( i = 0; s[i] != '\0'; i++)
80100c50:	0f be 05 80 ee 10 80 	movsbl 0x8010ee80,%eax
80100c57:	31 db                	xor    %ebx,%ebx
80100c59:	84 c0                	test   %al,%al
80100c5b:	0f 84 85 fc ff ff    	je     801008e6 <consoleintr+0x26>
  if(panicked){
80100c61:	8b 3d 18 f5 10 80    	mov    0x8010f518,%edi
80100c67:	85 ff                	test   %edi,%edi
80100c69:	74 05                	je     80100c70 <consoleintr+0x3b0>
80100c6b:	fa                   	cli    
    for(;;)
80100c6c:	eb fe                	jmp    80100c6c <consoleintr+0x3ac>
80100c6e:	66 90                	xchg   %ax,%ax
80100c70:	e8 cb f7 ff ff       	call   80100440 <consputc.part.0>
  for( i = 0; s[i] != '\0'; i++)
80100c75:	0f be 83 81 ee 10 80 	movsbl -0x7fef117f(%ebx),%eax
80100c7c:	83 c3 01             	add    $0x1,%ebx
80100c7f:	84 c0                	test   %al,%al
80100c81:	75 de                	jne    80100c61 <consoleintr+0x3a1>
80100c83:	e9 5e fc ff ff       	jmp    801008e6 <consoleintr+0x26>
    hist.last_used_idx = suggested_cmd + 1;
80100c88:	8d 57 01             	lea    0x1(%edi),%edx
    hist.is_suggestion_used = 1;
80100c8b:	8b b5 5c ff ff ff    	mov    -0xa4(%ebp),%esi
80100c91:	c7 05 a8 f3 10 80 01 	movl   $0x1,0x8010f3a8
80100c98:	00 00 00 
    hist.last_used_idx = suggested_cmd + 1;
80100c9b:	89 15 a4 f3 10 80    	mov    %edx,0x8010f3a4
    while(input.e != input.w &&
80100ca1:	a1 c8 f4 10 80       	mov    0x8010f4c8,%eax
80100ca6:	39 05 c4 f4 10 80    	cmp    %eax,0x8010f4c4
80100cac:	74 41                	je     80100cef <consoleintr+0x42f>
    input.buf[(input.e-1) % INPUT_BUF] != '\n')
80100cae:	83 e8 01             	sub    $0x1,%eax
80100cb1:	89 c2                	mov    %eax,%edx
80100cb3:	83 e2 7f             	and    $0x7f,%edx
    while(input.e != input.w &&
80100cb6:	80 ba 40 f4 10 80 0a 	cmpb   $0xa,-0x7fef0bc0(%edx)
80100cbd:	74 30                	je     80100cef <consoleintr+0x42f>
  if(panicked){
80100cbf:	8b 3d 18 f5 10 80    	mov    0x8010f518,%edi
      input.e--;
80100cc5:	a3 c8 f4 10 80       	mov    %eax,0x8010f4c8
  if(panicked){
80100cca:	85 ff                	test   %edi,%edi
80100ccc:	74 0a                	je     80100cd8 <consoleintr+0x418>
80100cce:	fa                   	cli    
    for(;;)
80100ccf:	eb fe                	jmp    80100ccf <consoleintr+0x40f>
80100cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cd8:	b8 00 01 00 00       	mov    $0x100,%eax
80100cdd:	e8 5e f7 ff ff       	call   80100440 <consputc.part.0>
    while(input.e != input.w &&
80100ce2:	a1 c8 f4 10 80       	mov    0x8010f4c8,%eax
80100ce7:	3b 05 c4 f4 10 80    	cmp    0x8010f4c4,%eax
80100ced:	75 bf                	jne    80100cae <consoleintr+0x3ee>
  for( i = 0; s[i] != '\0'; i++)
80100cef:	0f be 03             	movsbl (%ebx),%eax
80100cf2:	83 c3 01             	add    $0x1,%ebx
80100cf5:	84 c0                	test   %al,%al
80100cf7:	0f 84 e9 fb ff ff    	je     801008e6 <consoleintr+0x26>
  if(panicked){
80100cfd:	8b 0d 18 f5 10 80    	mov    0x8010f518,%ecx
80100d03:	85 c9                	test   %ecx,%ecx
80100d05:	0f 84 b5 00 00 00    	je     80100dc0 <consoleintr+0x500>
80100d0b:	fa                   	cli    
    for(;;)
80100d0c:	eb fe                	jmp    80100d0c <consoleintr+0x44c>
80100d0e:	66 90                	xchg   %ax,%ax
}
80100d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d13:	5b                   	pop    %ebx
80100d14:	5e                   	pop    %esi
80100d15:	5f                   	pop    %edi
80100d16:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100d17:	e9 74 38 00 00       	jmp    80104590 <procdump>
    hist.original_cmd_size = input.e - input.w;
80100d1c:	a1 c4 f4 10 80       	mov    0x8010f4c4,%eax
80100d21:	8b 15 c8 f4 10 80    	mov    0x8010f4c8,%edx
    memmove(hist.original_cmd, input.buf + input.w, hist.original_cmd_size);
80100d27:	83 ec 04             	sub    $0x4,%esp
80100d2a:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
    hist.original_cmd_size = input.e - input.w;
80100d30:	29 c2                	sub    %eax,%edx
    memmove(hist.original_cmd, input.buf + input.w, hist.original_cmd_size);
80100d32:	05 40 f4 10 80       	add    $0x8010f440,%eax
80100d37:	52                   	push   %edx
80100d38:	50                   	push   %eax
80100d39:	68 ac f3 10 80       	push   $0x8010f3ac
    hist.original_cmd_size = input.e - input.w;
80100d3e:	89 15 2c f4 10 80    	mov    %edx,0x8010f42c
    memmove(hist.original_cmd, input.buf + input.w, hist.original_cmd_size);
80100d44:	e8 67 3d 00 00       	call   80104ab0 <memmove>
80100d49:	8b 8d 60 ff ff ff    	mov    -0xa0(%ebp),%ecx
80100d4f:	83 c4 10             	add    $0x10,%esp
80100d52:	e9 46 fe ff ff       	jmp    80100b9d <consoleintr+0x2dd>
80100d57:	b8 00 01 00 00       	mov    $0x100,%eax
80100d5c:	e8 df f6 ff ff       	call   80100440 <consputc.part.0>
80100d61:	e9 80 fb ff ff       	jmp    801008e6 <consoleintr+0x26>
  for( i = 0; s[i] != '\0'; i++)
80100d66:	0f be 85 68 ff ff ff 	movsbl -0x98(%ebp),%eax
80100d6d:	8d 9d 69 ff ff ff    	lea    -0x97(%ebp),%ebx
80100d73:	84 c0                	test   %al,%al
80100d75:	0f 84 6b fb ff ff    	je     801008e6 <consoleintr+0x26>
  if(panicked){
80100d7b:	8b 15 18 f5 10 80    	mov    0x8010f518,%edx
80100d81:	85 d2                	test   %edx,%edx
80100d83:	74 0b                	je     80100d90 <consoleintr+0x4d0>
80100d85:	fa                   	cli    
    for(;;)
80100d86:	eb fe                	jmp    80100d86 <consoleintr+0x4c6>
80100d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d8f:	90                   	nop
80100d90:	e8 ab f6 ff ff       	call   80100440 <consputc.part.0>
  for( i = 0; s[i] != '\0'; i++)
80100d95:	0f be 03             	movsbl (%ebx),%eax
80100d98:	83 c3 01             	add    $0x1,%ebx
80100d9b:	84 c0                	test   %al,%al
80100d9d:	75 dc                	jne    80100d7b <consoleintr+0x4bb>
80100d9f:	e9 42 fb ff ff       	jmp    801008e6 <consoleintr+0x26>
80100da4:	b8 07 00 00 00       	mov    $0x7,%eax
80100da9:	e8 92 f6 ff ff       	call   80100440 <consputc.part.0>
80100dae:	e9 33 fb ff ff       	jmp    801008e6 <consoleintr+0x26>
80100db3:	fa                   	cli    
    for(;;)
80100db4:	eb fe                	jmp    80100db4 <consoleintr+0x4f4>
80100db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
80100dc0:	e8 7b f6 ff ff       	call   80100440 <consputc.part.0>
  for( i = 0; s[i] != '\0'; i++)
80100dc5:	0f be 03             	movsbl (%ebx),%eax
80100dc8:	83 c3 01             	add    $0x1,%ebx
80100dcb:	84 c0                	test   %al,%al
80100dcd:	0f 85 2a ff ff ff    	jne    80100cfd <consoleintr+0x43d>
80100dd3:	e9 0e fb ff ff       	jmp    801008e6 <consoleintr+0x26>
        input.buf[input.e++ % INPUT_BUF] = c;
80100dd8:	c6 80 40 f4 10 80 0a 	movb   $0xa,-0x7fef0bc0(%eax)
  if(panicked){
80100ddf:	85 d2                	test   %edx,%edx
80100de1:	75 d0                	jne    80100db3 <consoleintr+0x4f3>
80100de3:	b8 0a 00 00 00       	mov    $0xa,%eax
80100de8:	e8 53 f6 ff ff       	call   80100440 <consputc.part.0>
          input.w = input.e;
80100ded:	a1 c8 f4 10 80       	mov    0x8010f4c8,%eax
80100df2:	e9 91 fc ff ff       	jmp    80100a88 <consoleintr+0x1c8>
   while(input.e != input.w &&
80100df7:	0f 84 e9 fa ff ff    	je     801008e6 <consoleintr+0x26>
80100dfd:	e9 5d fd ff ff       	jmp    80100b5f <consoleintr+0x29f>
80100e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e10 <consoleinit>:

void
consoleinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100e16:	68 a8 75 10 80       	push   $0x801075a8
80100e1b:	68 e0 f4 10 80       	push   $0x8010f4e0
80100e20:	e8 5b 39 00 00       	call   80104780 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100e25:	58                   	pop    %eax
80100e26:	5a                   	pop    %edx
80100e27:	6a 00                	push   $0x0
80100e29:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100e2b:	c7 05 cc fe 10 80 d0 	movl   $0x801005d0,0x8010fecc
80100e32:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100e35:	c7 05 c8 fe 10 80 c0 	movl   $0x801002c0,0x8010fec8
80100e3c:	02 10 80 
  cons.locking = 1;
80100e3f:	c7 05 14 f5 10 80 01 	movl   $0x1,0x8010f514
80100e46:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100e49:	e8 e2 19 00 00       	call   80102830 <ioapicenable>
}
80100e4e:	83 c4 10             	add    $0x10,%esp
80100e51:	c9                   	leave  
80100e52:	c3                   	ret    
80100e53:	66 90                	xchg   %ax,%ax
80100e55:	66 90                	xchg   %ax,%ax
80100e57:	66 90                	xchg   %ax,%ax
80100e59:	66 90                	xchg   %ax,%ax
80100e5b:	66 90                	xchg   %ax,%ax
80100e5d:	66 90                	xchg   %ax,%ax
80100e5f:	90                   	nop

80100e60 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100e6c:	e8 af 2e 00 00       	call   80103d20 <myproc>
80100e71:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100e77:	e8 94 22 00 00       	call   80103110 <begin_op>

  if((ip = namei(path)) == 0){
80100e7c:	83 ec 0c             	sub    $0xc,%esp
80100e7f:	ff 75 08             	push   0x8(%ebp)
80100e82:	e8 c9 15 00 00       	call   80102450 <namei>
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	0f 84 02 03 00 00    	je     80101194 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100e92:	83 ec 0c             	sub    $0xc,%esp
80100e95:	89 c3                	mov    %eax,%ebx
80100e97:	50                   	push   %eax
80100e98:	e8 93 0c 00 00       	call   80101b30 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100e9d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ea3:	6a 34                	push   $0x34
80100ea5:	6a 00                	push   $0x0
80100ea7:	50                   	push   %eax
80100ea8:	53                   	push   %ebx
80100ea9:	e8 92 0f 00 00       	call   80101e40 <readi>
80100eae:	83 c4 20             	add    $0x20,%esp
80100eb1:	83 f8 34             	cmp    $0x34,%eax
80100eb4:	74 22                	je     80100ed8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100eb6:	83 ec 0c             	sub    $0xc,%esp
80100eb9:	53                   	push   %ebx
80100eba:	e8 01 0f 00 00       	call   80101dc0 <iunlockput>
    end_op();
80100ebf:	e8 bc 22 00 00       	call   80103180 <end_op>
80100ec4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ec7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ecf:	5b                   	pop    %ebx
80100ed0:	5e                   	pop    %esi
80100ed1:	5f                   	pop    %edi
80100ed2:	5d                   	pop    %ebp
80100ed3:	c3                   	ret    
80100ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100ed8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100edf:	45 4c 46 
80100ee2:	75 d2                	jne    80100eb6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100ee4:	e8 07 63 00 00       	call   801071f0 <setupkvm>
80100ee9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100eef:	85 c0                	test   %eax,%eax
80100ef1:	74 c3                	je     80100eb6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ef3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100efa:	00 
80100efb:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100f01:	0f 84 ac 02 00 00    	je     801011b3 <exec+0x353>
  sz = 0;
80100f07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100f0e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f11:	31 ff                	xor    %edi,%edi
80100f13:	e9 8e 00 00 00       	jmp    80100fa6 <exec+0x146>
80100f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f1f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100f20:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100f27:	75 6c                	jne    80100f95 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100f29:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100f2f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100f35:	0f 82 87 00 00 00    	jb     80100fc2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100f3b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100f41:	72 7f                	jb     80100fc2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100f43:	83 ec 04             	sub    $0x4,%esp
80100f46:	50                   	push   %eax
80100f47:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100f4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f53:	e8 b8 60 00 00       	call   80107010 <allocuvm>
80100f58:	83 c4 10             	add    $0x10,%esp
80100f5b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f61:	85 c0                	test   %eax,%eax
80100f63:	74 5d                	je     80100fc2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100f65:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100f6b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f70:	75 50                	jne    80100fc2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f72:	83 ec 0c             	sub    $0xc,%esp
80100f75:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100f7b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100f81:	53                   	push   %ebx
80100f82:	50                   	push   %eax
80100f83:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f89:	e8 92 5f 00 00       	call   80106f20 <loaduvm>
80100f8e:	83 c4 20             	add    $0x20,%esp
80100f91:	85 c0                	test   %eax,%eax
80100f93:	78 2d                	js     80100fc2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f95:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100f9c:	83 c7 01             	add    $0x1,%edi
80100f9f:	83 c6 20             	add    $0x20,%esi
80100fa2:	39 f8                	cmp    %edi,%eax
80100fa4:	7e 3a                	jle    80100fe0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100fa6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100fac:	6a 20                	push   $0x20
80100fae:	56                   	push   %esi
80100faf:	50                   	push   %eax
80100fb0:	53                   	push   %ebx
80100fb1:	e8 8a 0e 00 00       	call   80101e40 <readi>
80100fb6:	83 c4 10             	add    $0x10,%esp
80100fb9:	83 f8 20             	cmp    $0x20,%eax
80100fbc:	0f 84 5e ff ff ff    	je     80100f20 <exec+0xc0>
    freevm(pgdir);
80100fc2:	83 ec 0c             	sub    $0xc,%esp
80100fc5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100fcb:	e8 a0 61 00 00       	call   80107170 <freevm>
  if(ip){
80100fd0:	83 c4 10             	add    $0x10,%esp
80100fd3:	e9 de fe ff ff       	jmp    80100eb6 <exec+0x56>
80100fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdf:	90                   	nop
  sz = PGROUNDUP(sz);
80100fe0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100fe6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100fec:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ff2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	53                   	push   %ebx
80100ffc:	e8 bf 0d 00 00       	call   80101dc0 <iunlockput>
  end_op();
80101001:	e8 7a 21 00 00       	call   80103180 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101006:	83 c4 0c             	add    $0xc,%esp
80101009:	56                   	push   %esi
8010100a:	57                   	push   %edi
8010100b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101011:	57                   	push   %edi
80101012:	e8 f9 5f 00 00       	call   80107010 <allocuvm>
80101017:	83 c4 10             	add    $0x10,%esp
8010101a:	89 c6                	mov    %eax,%esi
8010101c:	85 c0                	test   %eax,%eax
8010101e:	0f 84 94 00 00 00    	je     801010b8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101024:	83 ec 08             	sub    $0x8,%esp
80101027:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010102d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010102f:	50                   	push   %eax
80101030:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101031:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101033:	e8 58 62 00 00       	call   80107290 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101038:	8b 45 0c             	mov    0xc(%ebp),%eax
8010103b:	83 c4 10             	add    $0x10,%esp
8010103e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101044:	8b 00                	mov    (%eax),%eax
80101046:	85 c0                	test   %eax,%eax
80101048:	0f 84 8b 00 00 00    	je     801010d9 <exec+0x279>
8010104e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101054:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010105a:	eb 23                	jmp    8010107f <exec+0x21f>
8010105c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101060:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101063:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010106a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010106d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101073:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101076:	85 c0                	test   %eax,%eax
80101078:	74 59                	je     801010d3 <exec+0x273>
    if(argc >= MAXARG)
8010107a:	83 ff 20             	cmp    $0x20,%edi
8010107d:	74 39                	je     801010b8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	50                   	push   %eax
80101083:	e8 88 3b 00 00       	call   80104c10 <strlen>
80101088:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010108a:	58                   	pop    %eax
8010108b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010108e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101091:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101094:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101097:	e8 74 3b 00 00       	call   80104c10 <strlen>
8010109c:	83 c0 01             	add    $0x1,%eax
8010109f:	50                   	push   %eax
801010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a3:	ff 34 b8             	push   (%eax,%edi,4)
801010a6:	53                   	push   %ebx
801010a7:	56                   	push   %esi
801010a8:	e8 b3 63 00 00       	call   80107460 <copyout>
801010ad:	83 c4 20             	add    $0x20,%esp
801010b0:	85 c0                	test   %eax,%eax
801010b2:	79 ac                	jns    80101060 <exec+0x200>
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010c1:	e8 aa 60 00 00       	call   80107170 <freevm>
801010c6:	83 c4 10             	add    $0x10,%esp
  return -1;
801010c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010ce:	e9 f9 fd ff ff       	jmp    80100ecc <exec+0x6c>
801010d3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010d9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801010e0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801010e2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801010e9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010ed:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801010ef:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801010f2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801010f8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010fa:	50                   	push   %eax
801010fb:	52                   	push   %edx
801010fc:	53                   	push   %ebx
801010fd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101103:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010110a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010110d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101113:	e8 48 63 00 00       	call   80107460 <copyout>
80101118:	83 c4 10             	add    $0x10,%esp
8010111b:	85 c0                	test   %eax,%eax
8010111d:	78 99                	js     801010b8 <exec+0x258>
  for(last=s=path; *s; s++)
8010111f:	8b 45 08             	mov    0x8(%ebp),%eax
80101122:	8b 55 08             	mov    0x8(%ebp),%edx
80101125:	0f b6 00             	movzbl (%eax),%eax
80101128:	84 c0                	test   %al,%al
8010112a:	74 13                	je     8010113f <exec+0x2df>
8010112c:	89 d1                	mov    %edx,%ecx
8010112e:	66 90                	xchg   %ax,%ax
      last = s+1;
80101130:	83 c1 01             	add    $0x1,%ecx
80101133:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101135:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101138:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010113b:	84 c0                	test   %al,%al
8010113d:	75 f1                	jne    80101130 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010113f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101145:	83 ec 04             	sub    $0x4,%esp
80101148:	6a 10                	push   $0x10
8010114a:	89 f8                	mov    %edi,%eax
8010114c:	52                   	push   %edx
8010114d:	83 c0 6c             	add    $0x6c,%eax
80101150:	50                   	push   %eax
80101151:	e8 7a 3a 00 00       	call   80104bd0 <safestrcpy>
  curproc->pgdir = pgdir;
80101156:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010115c:	89 f8                	mov    %edi,%eax
8010115e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101161:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101163:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101166:	89 c1                	mov    %eax,%ecx
80101168:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010116e:	8b 40 18             	mov    0x18(%eax),%eax
80101171:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101174:	8b 41 18             	mov    0x18(%ecx),%eax
80101177:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010117a:	89 0c 24             	mov    %ecx,(%esp)
8010117d:	e8 0e 5c 00 00       	call   80106d90 <switchuvm>
  freevm(oldpgdir);
80101182:	89 3c 24             	mov    %edi,(%esp)
80101185:	e8 e6 5f 00 00       	call   80107170 <freevm>
  return 0;
8010118a:	83 c4 10             	add    $0x10,%esp
8010118d:	31 c0                	xor    %eax,%eax
8010118f:	e9 38 fd ff ff       	jmp    80100ecc <exec+0x6c>
    end_op();
80101194:	e8 e7 1f 00 00       	call   80103180 <end_op>
    cprintf("exec: fail\n");
80101199:	83 ec 0c             	sub    $0xc,%esp
8010119c:	68 05 76 10 80       	push   $0x80107605
801011a1:	e8 3a f5 ff ff       	call   801006e0 <cprintf>
    return -1;
801011a6:	83 c4 10             	add    $0x10,%esp
801011a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ae:	e9 19 fd ff ff       	jmp    80100ecc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801011b3:	be 00 20 00 00       	mov    $0x2000,%esi
801011b8:	31 ff                	xor    %edi,%edi
801011ba:	e9 39 fe ff ff       	jmp    80100ff8 <exec+0x198>
801011bf:	90                   	nop

801011c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801011c6:	68 11 76 10 80       	push   $0x80107611
801011cb:	68 20 f5 10 80       	push   $0x8010f520
801011d0:	e8 ab 35 00 00       	call   80104780 <initlock>
}
801011d5:	83 c4 10             	add    $0x10,%esp
801011d8:	c9                   	leave  
801011d9:	c3                   	ret    
801011da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011e4:	bb 54 f5 10 80       	mov    $0x8010f554,%ebx
{
801011e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801011ec:	68 20 f5 10 80       	push   $0x8010f520
801011f1:	e8 5a 37 00 00       	call   80104950 <acquire>
801011f6:	83 c4 10             	add    $0x10,%esp
801011f9:	eb 10                	jmp    8010120b <filealloc+0x2b>
801011fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011ff:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101200:	83 c3 18             	add    $0x18,%ebx
80101203:	81 fb b4 fe 10 80    	cmp    $0x8010feb4,%ebx
80101209:	74 25                	je     80101230 <filealloc+0x50>
    if(f->ref == 0){
8010120b:	8b 43 04             	mov    0x4(%ebx),%eax
8010120e:	85 c0                	test   %eax,%eax
80101210:	75 ee                	jne    80101200 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101212:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101215:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010121c:	68 20 f5 10 80       	push   $0x8010f520
80101221:	e8 ca 36 00 00       	call   801048f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101226:	89 d8                	mov    %ebx,%eax
      return f;
80101228:	83 c4 10             	add    $0x10,%esp
}
8010122b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010122e:	c9                   	leave  
8010122f:	c3                   	ret    
  release(&ftable.lock);
80101230:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101233:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101235:	68 20 f5 10 80       	push   $0x8010f520
8010123a:	e8 b1 36 00 00       	call   801048f0 <release>
}
8010123f:	89 d8                	mov    %ebx,%eax
  return 0;
80101241:	83 c4 10             	add    $0x10,%esp
}
80101244:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101247:	c9                   	leave  
80101248:	c3                   	ret    
80101249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101250 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	53                   	push   %ebx
80101254:	83 ec 10             	sub    $0x10,%esp
80101257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010125a:	68 20 f5 10 80       	push   $0x8010f520
8010125f:	e8 ec 36 00 00       	call   80104950 <acquire>
  if(f->ref < 1)
80101264:	8b 43 04             	mov    0x4(%ebx),%eax
80101267:	83 c4 10             	add    $0x10,%esp
8010126a:	85 c0                	test   %eax,%eax
8010126c:	7e 1a                	jle    80101288 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010126e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101271:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101274:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101277:	68 20 f5 10 80       	push   $0x8010f520
8010127c:	e8 6f 36 00 00       	call   801048f0 <release>
  return f;
}
80101281:	89 d8                	mov    %ebx,%eax
80101283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101286:	c9                   	leave  
80101287:	c3                   	ret    
    panic("filedup");
80101288:	83 ec 0c             	sub    $0xc,%esp
8010128b:	68 18 76 10 80       	push   $0x80107618
80101290:	e8 2b f1 ff ff       	call   801003c0 <panic>
80101295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012a0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	83 ec 28             	sub    $0x28,%esp
801012a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801012ac:	68 20 f5 10 80       	push   $0x8010f520
801012b1:	e8 9a 36 00 00       	call   80104950 <acquire>
  if(f->ref < 1)
801012b6:	8b 53 04             	mov    0x4(%ebx),%edx
801012b9:	83 c4 10             	add    $0x10,%esp
801012bc:	85 d2                	test   %edx,%edx
801012be:	0f 8e a5 00 00 00    	jle    80101369 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801012c4:	83 ea 01             	sub    $0x1,%edx
801012c7:	89 53 04             	mov    %edx,0x4(%ebx)
801012ca:	75 44                	jne    80101310 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801012cc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801012d0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801012d3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801012d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801012db:	8b 73 0c             	mov    0xc(%ebx),%esi
801012de:	88 45 e7             	mov    %al,-0x19(%ebp)
801012e1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801012e4:	68 20 f5 10 80       	push   $0x8010f520
  ff = *f;
801012e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801012ec:	e8 ff 35 00 00       	call   801048f0 <release>

  if(ff.type == FD_PIPE)
801012f1:	83 c4 10             	add    $0x10,%esp
801012f4:	83 ff 01             	cmp    $0x1,%edi
801012f7:	74 57                	je     80101350 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801012f9:	83 ff 02             	cmp    $0x2,%edi
801012fc:	74 2a                	je     80101328 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101301:	5b                   	pop    %ebx
80101302:	5e                   	pop    %esi
80101303:	5f                   	pop    %edi
80101304:	5d                   	pop    %ebp
80101305:	c3                   	ret    
80101306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010130d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101310:	c7 45 08 20 f5 10 80 	movl   $0x8010f520,0x8(%ebp)
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	5b                   	pop    %ebx
8010131b:	5e                   	pop    %esi
8010131c:	5f                   	pop    %edi
8010131d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010131e:	e9 cd 35 00 00       	jmp    801048f0 <release>
80101323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101327:	90                   	nop
    begin_op();
80101328:	e8 e3 1d 00 00       	call   80103110 <begin_op>
    iput(ff.ip);
8010132d:	83 ec 0c             	sub    $0xc,%esp
80101330:	ff 75 e0             	push   -0x20(%ebp)
80101333:	e8 28 09 00 00       	call   80101c60 <iput>
    end_op();
80101338:	83 c4 10             	add    $0x10,%esp
}
8010133b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133e:	5b                   	pop    %ebx
8010133f:	5e                   	pop    %esi
80101340:	5f                   	pop    %edi
80101341:	5d                   	pop    %ebp
    end_op();
80101342:	e9 39 1e 00 00       	jmp    80103180 <end_op>
80101347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101350:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101354:	83 ec 08             	sub    $0x8,%esp
80101357:	53                   	push   %ebx
80101358:	56                   	push   %esi
80101359:	e8 82 25 00 00       	call   801038e0 <pipeclose>
8010135e:	83 c4 10             	add    $0x10,%esp
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101364:	5b                   	pop    %ebx
80101365:	5e                   	pop    %esi
80101366:	5f                   	pop    %edi
80101367:	5d                   	pop    %ebp
80101368:	c3                   	ret    
    panic("fileclose");
80101369:	83 ec 0c             	sub    $0xc,%esp
8010136c:	68 20 76 10 80       	push   $0x80107620
80101371:	e8 4a f0 ff ff       	call   801003c0 <panic>
80101376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137d:	8d 76 00             	lea    0x0(%esi),%esi

80101380 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	53                   	push   %ebx
80101384:	83 ec 04             	sub    $0x4,%esp
80101387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010138a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010138d:	75 31                	jne    801013c0 <filestat+0x40>
    ilock(f->ip);
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	ff 73 10             	push   0x10(%ebx)
80101395:	e8 96 07 00 00       	call   80101b30 <ilock>
    stati(f->ip, st);
8010139a:	58                   	pop    %eax
8010139b:	5a                   	pop    %edx
8010139c:	ff 75 0c             	push   0xc(%ebp)
8010139f:	ff 73 10             	push   0x10(%ebx)
801013a2:	e8 69 0a 00 00       	call   80101e10 <stati>
    iunlock(f->ip);
801013a7:	59                   	pop    %ecx
801013a8:	ff 73 10             	push   0x10(%ebx)
801013ab:	e8 60 08 00 00       	call   80101c10 <iunlock>
    return 0;
  }
  return -1;
}
801013b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801013b3:	83 c4 10             	add    $0x10,%esp
801013b6:	31 c0                	xor    %eax,%eax
}
801013b8:	c9                   	leave  
801013b9:	c3                   	ret    
801013ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801013c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801013c8:	c9                   	leave  
801013c9:	c3                   	ret    
801013ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013d0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	56                   	push   %esi
801013d5:	53                   	push   %ebx
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013dc:	8b 75 0c             	mov    0xc(%ebp),%esi
801013df:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801013e2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801013e6:	74 60                	je     80101448 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801013e8:	8b 03                	mov    (%ebx),%eax
801013ea:	83 f8 01             	cmp    $0x1,%eax
801013ed:	74 41                	je     80101430 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013ef:	83 f8 02             	cmp    $0x2,%eax
801013f2:	75 5b                	jne    8010144f <fileread+0x7f>
    ilock(f->ip);
801013f4:	83 ec 0c             	sub    $0xc,%esp
801013f7:	ff 73 10             	push   0x10(%ebx)
801013fa:	e8 31 07 00 00       	call   80101b30 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013ff:	57                   	push   %edi
80101400:	ff 73 14             	push   0x14(%ebx)
80101403:	56                   	push   %esi
80101404:	ff 73 10             	push   0x10(%ebx)
80101407:	e8 34 0a 00 00       	call   80101e40 <readi>
8010140c:	83 c4 20             	add    $0x20,%esp
8010140f:	89 c6                	mov    %eax,%esi
80101411:	85 c0                	test   %eax,%eax
80101413:	7e 03                	jle    80101418 <fileread+0x48>
      f->off += r;
80101415:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101418:	83 ec 0c             	sub    $0xc,%esp
8010141b:	ff 73 10             	push   0x10(%ebx)
8010141e:	e8 ed 07 00 00       	call   80101c10 <iunlock>
    return r;
80101423:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101429:	89 f0                	mov    %esi,%eax
8010142b:	5b                   	pop    %ebx
8010142c:	5e                   	pop    %esi
8010142d:	5f                   	pop    %edi
8010142e:	5d                   	pop    %ebp
8010142f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101430:	8b 43 0c             	mov    0xc(%ebx),%eax
80101433:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101436:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101439:	5b                   	pop    %ebx
8010143a:	5e                   	pop    %esi
8010143b:	5f                   	pop    %edi
8010143c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010143d:	e9 3e 26 00 00       	jmp    80103a80 <piperead>
80101442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101448:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010144d:	eb d7                	jmp    80101426 <fileread+0x56>
  panic("fileread");
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	68 2a 76 10 80       	push   $0x8010762a
80101457:	e8 64 ef ff ff       	call   801003c0 <panic>
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101460 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	53                   	push   %ebx
80101466:	83 ec 1c             	sub    $0x1c,%esp
80101469:	8b 45 0c             	mov    0xc(%ebp),%eax
8010146c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010146f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101472:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101475:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010147c:	0f 84 bd 00 00 00    	je     8010153f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101482:	8b 03                	mov    (%ebx),%eax
80101484:	83 f8 01             	cmp    $0x1,%eax
80101487:	0f 84 bf 00 00 00    	je     8010154c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010148d:	83 f8 02             	cmp    $0x2,%eax
80101490:	0f 85 c8 00 00 00    	jne    8010155e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101499:	31 f6                	xor    %esi,%esi
    while(i < n){
8010149b:	85 c0                	test   %eax,%eax
8010149d:	7f 30                	jg     801014cf <filewrite+0x6f>
8010149f:	e9 94 00 00 00       	jmp    80101538 <filewrite+0xd8>
801014a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801014a8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801014ab:	83 ec 0c             	sub    $0xc,%esp
801014ae:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801014b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801014b4:	e8 57 07 00 00       	call   80101c10 <iunlock>
      end_op();
801014b9:	e8 c2 1c 00 00       	call   80103180 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801014be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014c1:	83 c4 10             	add    $0x10,%esp
801014c4:	39 c7                	cmp    %eax,%edi
801014c6:	75 5c                	jne    80101524 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801014c8:	01 fe                	add    %edi,%esi
    while(i < n){
801014ca:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801014cd:	7e 69                	jle    80101538 <filewrite+0xd8>
      int n1 = n - i;
801014cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801014d2:	b8 00 06 00 00       	mov    $0x600,%eax
801014d7:	29 f7                	sub    %esi,%edi
801014d9:	39 c7                	cmp    %eax,%edi
801014db:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801014de:	e8 2d 1c 00 00       	call   80103110 <begin_op>
      ilock(f->ip);
801014e3:	83 ec 0c             	sub    $0xc,%esp
801014e6:	ff 73 10             	push   0x10(%ebx)
801014e9:	e8 42 06 00 00       	call   80101b30 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801014ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014f1:	57                   	push   %edi
801014f2:	ff 73 14             	push   0x14(%ebx)
801014f5:	01 f0                	add    %esi,%eax
801014f7:	50                   	push   %eax
801014f8:	ff 73 10             	push   0x10(%ebx)
801014fb:	e8 40 0a 00 00       	call   80101f40 <writei>
80101500:	83 c4 20             	add    $0x20,%esp
80101503:	85 c0                	test   %eax,%eax
80101505:	7f a1                	jg     801014a8 <filewrite+0x48>
      iunlock(f->ip);
80101507:	83 ec 0c             	sub    $0xc,%esp
8010150a:	ff 73 10             	push   0x10(%ebx)
8010150d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101510:	e8 fb 06 00 00       	call   80101c10 <iunlock>
      end_op();
80101515:	e8 66 1c 00 00       	call   80103180 <end_op>
      if(r < 0)
8010151a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	85 c0                	test   %eax,%eax
80101522:	75 1b                	jne    8010153f <filewrite+0xdf>
        panic("short filewrite");
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	68 33 76 10 80       	push   $0x80107633
8010152c:	e8 8f ee ff ff       	call   801003c0 <panic>
80101531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101538:	89 f0                	mov    %esi,%eax
8010153a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010153d:	74 05                	je     80101544 <filewrite+0xe4>
8010153f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101544:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101547:	5b                   	pop    %ebx
80101548:	5e                   	pop    %esi
80101549:	5f                   	pop    %edi
8010154a:	5d                   	pop    %ebp
8010154b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010154c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010154f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101552:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101555:	5b                   	pop    %ebx
80101556:	5e                   	pop    %esi
80101557:	5f                   	pop    %edi
80101558:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101559:	e9 22 24 00 00       	jmp    80103980 <pipewrite>
  panic("filewrite");
8010155e:	83 ec 0c             	sub    $0xc,%esp
80101561:	68 39 76 10 80       	push   $0x80107639
80101566:	e8 55 ee ff ff       	call   801003c0 <panic>
8010156b:	66 90                	xchg   %ax,%ax
8010156d:	66 90                	xchg   %ax,%ax
8010156f:	90                   	nop

80101570 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101570:	55                   	push   %ebp
80101571:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101573:	89 d0                	mov    %edx,%eax
80101575:	c1 e8 0c             	shr    $0xc,%eax
80101578:	03 05 8c 1b 11 80    	add    0x80111b8c,%eax
{
8010157e:	89 e5                	mov    %esp,%ebp
80101580:	56                   	push   %esi
80101581:	53                   	push   %ebx
80101582:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101584:	83 ec 08             	sub    $0x8,%esp
80101587:	50                   	push   %eax
80101588:	51                   	push   %ecx
80101589:	e8 42 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010158e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101590:	c1 fb 03             	sar    $0x3,%ebx
80101593:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101596:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101598:	83 e1 07             	and    $0x7,%ecx
8010159b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801015a0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801015a6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801015a8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801015ad:	85 c1                	test   %eax,%ecx
801015af:	74 23                	je     801015d4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801015b1:	f7 d0                	not    %eax
  log_write(bp);
801015b3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801015b6:	21 c8                	and    %ecx,%eax
801015b8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801015bc:	56                   	push   %esi
801015bd:	e8 2e 1d 00 00       	call   801032f0 <log_write>
  brelse(bp);
801015c2:	89 34 24             	mov    %esi,(%esp)
801015c5:	e8 26 ec ff ff       	call   801001f0 <brelse>
}
801015ca:	83 c4 10             	add    $0x10,%esp
801015cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015d0:	5b                   	pop    %ebx
801015d1:	5e                   	pop    %esi
801015d2:	5d                   	pop    %ebp
801015d3:	c3                   	ret    
    panic("freeing free block");
801015d4:	83 ec 0c             	sub    $0xc,%esp
801015d7:	68 43 76 10 80       	push   $0x80107643
801015dc:	e8 df ed ff ff       	call   801003c0 <panic>
801015e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ef:	90                   	nop

801015f0 <balloc>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	53                   	push   %ebx
801015f6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015f9:	8b 0d 74 1b 11 80    	mov    0x80111b74,%ecx
{
801015ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101602:	85 c9                	test   %ecx,%ecx
80101604:	0f 84 87 00 00 00    	je     80101691 <balloc+0xa1>
8010160a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101611:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101614:	83 ec 08             	sub    $0x8,%esp
80101617:	89 f0                	mov    %esi,%eax
80101619:	c1 f8 0c             	sar    $0xc,%eax
8010161c:	03 05 8c 1b 11 80    	add    0x80111b8c,%eax
80101622:	50                   	push   %eax
80101623:	ff 75 d8             	push   -0x28(%ebp)
80101626:	e8 a5 ea ff ff       	call   801000d0 <bread>
8010162b:	83 c4 10             	add    $0x10,%esp
8010162e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101631:	a1 74 1b 11 80       	mov    0x80111b74,%eax
80101636:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101639:	31 c0                	xor    %eax,%eax
8010163b:	eb 2f                	jmp    8010166c <balloc+0x7c>
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101640:	89 c1                	mov    %eax,%ecx
80101642:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101647:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010164a:	83 e1 07             	and    $0x7,%ecx
8010164d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010164f:	89 c1                	mov    %eax,%ecx
80101651:	c1 f9 03             	sar    $0x3,%ecx
80101654:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101659:	89 fa                	mov    %edi,%edx
8010165b:	85 df                	test   %ebx,%edi
8010165d:	74 41                	je     801016a0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010165f:	83 c0 01             	add    $0x1,%eax
80101662:	83 c6 01             	add    $0x1,%esi
80101665:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010166a:	74 05                	je     80101671 <balloc+0x81>
8010166c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010166f:	77 cf                	ja     80101640 <balloc+0x50>
    brelse(bp);
80101671:	83 ec 0c             	sub    $0xc,%esp
80101674:	ff 75 e4             	push   -0x1c(%ebp)
80101677:	e8 74 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010167c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101683:	83 c4 10             	add    $0x10,%esp
80101686:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101689:	39 05 74 1b 11 80    	cmp    %eax,0x80111b74
8010168f:	77 80                	ja     80101611 <balloc+0x21>
  panic("balloc: out of blocks");
80101691:	83 ec 0c             	sub    $0xc,%esp
80101694:	68 56 76 10 80       	push   $0x80107656
80101699:	e8 22 ed ff ff       	call   801003c0 <panic>
8010169e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801016a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801016a3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801016a6:	09 da                	or     %ebx,%edx
801016a8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801016ac:	57                   	push   %edi
801016ad:	e8 3e 1c 00 00       	call   801032f0 <log_write>
        brelse(bp);
801016b2:	89 3c 24             	mov    %edi,(%esp)
801016b5:	e8 36 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801016ba:	58                   	pop    %eax
801016bb:	5a                   	pop    %edx
801016bc:	56                   	push   %esi
801016bd:	ff 75 d8             	push   -0x28(%ebp)
801016c0:	e8 0b ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801016c5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801016c8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801016ca:	8d 40 5c             	lea    0x5c(%eax),%eax
801016cd:	68 00 02 00 00       	push   $0x200
801016d2:	6a 00                	push   $0x0
801016d4:	50                   	push   %eax
801016d5:	e8 36 33 00 00       	call   80104a10 <memset>
  log_write(bp);
801016da:	89 1c 24             	mov    %ebx,(%esp)
801016dd:	e8 0e 1c 00 00       	call   801032f0 <log_write>
  brelse(bp);
801016e2:	89 1c 24             	mov    %ebx,(%esp)
801016e5:	e8 06 eb ff ff       	call   801001f0 <brelse>
}
801016ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ed:	89 f0                	mov    %esi,%eax
801016ef:	5b                   	pop    %ebx
801016f0:	5e                   	pop    %esi
801016f1:	5f                   	pop    %edi
801016f2:	5d                   	pop    %ebp
801016f3:	c3                   	ret    
801016f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016ff:	90                   	nop

80101700 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	89 c7                	mov    %eax,%edi
80101706:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101707:	31 f6                	xor    %esi,%esi
{
80101709:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010170a:	bb 54 ff 10 80       	mov    $0x8010ff54,%ebx
{
8010170f:	83 ec 28             	sub    $0x28,%esp
80101712:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101715:	68 20 ff 10 80       	push   $0x8010ff20
8010171a:	e8 31 32 00 00       	call   80104950 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010171f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101722:	83 c4 10             	add    $0x10,%esp
80101725:	eb 1b                	jmp    80101742 <iget+0x42>
80101727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101730:	39 3b                	cmp    %edi,(%ebx)
80101732:	74 6c                	je     801017a0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101734:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010173a:	81 fb 74 1b 11 80    	cmp    $0x80111b74,%ebx
80101740:	73 26                	jae    80101768 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101742:	8b 43 08             	mov    0x8(%ebx),%eax
80101745:	85 c0                	test   %eax,%eax
80101747:	7f e7                	jg     80101730 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101749:	85 f6                	test   %esi,%esi
8010174b:	75 e7                	jne    80101734 <iget+0x34>
8010174d:	85 c0                	test   %eax,%eax
8010174f:	75 76                	jne    801017c7 <iget+0xc7>
80101751:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101753:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101759:	81 fb 74 1b 11 80    	cmp    $0x80111b74,%ebx
8010175f:	72 e1                	jb     80101742 <iget+0x42>
80101761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101768:	85 f6                	test   %esi,%esi
8010176a:	74 79                	je     801017e5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010176c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010176f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101771:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101774:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010177b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101782:	68 20 ff 10 80       	push   $0x8010ff20
80101787:	e8 64 31 00 00       	call   801048f0 <release>

  return ip;
8010178c:	83 c4 10             	add    $0x10,%esp
}
8010178f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101792:	89 f0                	mov    %esi,%eax
80101794:	5b                   	pop    %ebx
80101795:	5e                   	pop    %esi
80101796:	5f                   	pop    %edi
80101797:	5d                   	pop    %ebp
80101798:	c3                   	ret    
80101799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017a0:	39 53 04             	cmp    %edx,0x4(%ebx)
801017a3:	75 8f                	jne    80101734 <iget+0x34>
      release(&icache.lock);
801017a5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801017a8:	83 c0 01             	add    $0x1,%eax
      return ip;
801017ab:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801017ad:	68 20 ff 10 80       	push   $0x8010ff20
      ip->ref++;
801017b2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801017b5:	e8 36 31 00 00       	call   801048f0 <release>
      return ip;
801017ba:	83 c4 10             	add    $0x10,%esp
}
801017bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017c0:	89 f0                	mov    %esi,%eax
801017c2:	5b                   	pop    %ebx
801017c3:	5e                   	pop    %esi
801017c4:	5f                   	pop    %edi
801017c5:	5d                   	pop    %ebp
801017c6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017c7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801017cd:	81 fb 74 1b 11 80    	cmp    $0x80111b74,%ebx
801017d3:	73 10                	jae    801017e5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017d5:	8b 43 08             	mov    0x8(%ebx),%eax
801017d8:	85 c0                	test   %eax,%eax
801017da:	0f 8f 50 ff ff ff    	jg     80101730 <iget+0x30>
801017e0:	e9 68 ff ff ff       	jmp    8010174d <iget+0x4d>
    panic("iget: no inodes");
801017e5:	83 ec 0c             	sub    $0xc,%esp
801017e8:	68 6c 76 10 80       	push   $0x8010766c
801017ed:	e8 ce eb ff ff       	call   801003c0 <panic>
801017f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101800 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	89 c6                	mov    %eax,%esi
80101807:	53                   	push   %ebx
80101808:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010180b:	83 fa 0b             	cmp    $0xb,%edx
8010180e:	0f 86 8c 00 00 00    	jbe    801018a0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101814:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101817:	83 fb 7f             	cmp    $0x7f,%ebx
8010181a:	0f 87 a2 00 00 00    	ja     801018c2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101820:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101826:	85 c0                	test   %eax,%eax
80101828:	74 5e                	je     80101888 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010182a:	83 ec 08             	sub    $0x8,%esp
8010182d:	50                   	push   %eax
8010182e:	ff 36                	push   (%esi)
80101830:	e8 9b e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101835:	83 c4 10             	add    $0x10,%esp
80101838:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010183c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010183e:	8b 3b                	mov    (%ebx),%edi
80101840:	85 ff                	test   %edi,%edi
80101842:	74 1c                	je     80101860 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101844:	83 ec 0c             	sub    $0xc,%esp
80101847:	52                   	push   %edx
80101848:	e8 a3 e9 ff ff       	call   801001f0 <brelse>
8010184d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101850:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101853:	89 f8                	mov    %edi,%eax
80101855:	5b                   	pop    %ebx
80101856:	5e                   	pop    %esi
80101857:	5f                   	pop    %edi
80101858:	5d                   	pop    %ebp
80101859:	c3                   	ret    
8010185a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101860:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101863:	8b 06                	mov    (%esi),%eax
80101865:	e8 86 fd ff ff       	call   801015f0 <balloc>
      log_write(bp);
8010186a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010186d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101870:	89 03                	mov    %eax,(%ebx)
80101872:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101874:	52                   	push   %edx
80101875:	e8 76 1a 00 00       	call   801032f0 <log_write>
8010187a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010187d:	83 c4 10             	add    $0x10,%esp
80101880:	eb c2                	jmp    80101844 <bmap+0x44>
80101882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101888:	8b 06                	mov    (%esi),%eax
8010188a:	e8 61 fd ff ff       	call   801015f0 <balloc>
8010188f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101895:	eb 93                	jmp    8010182a <bmap+0x2a>
80101897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801018a0:	8d 5a 14             	lea    0x14(%edx),%ebx
801018a3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801018a7:	85 ff                	test   %edi,%edi
801018a9:	75 a5                	jne    80101850 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801018ab:	8b 00                	mov    (%eax),%eax
801018ad:	e8 3e fd ff ff       	call   801015f0 <balloc>
801018b2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801018b6:	89 c7                	mov    %eax,%edi
}
801018b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018bb:	5b                   	pop    %ebx
801018bc:	89 f8                	mov    %edi,%eax
801018be:	5e                   	pop    %esi
801018bf:	5f                   	pop    %edi
801018c0:	5d                   	pop    %ebp
801018c1:	c3                   	ret    
  panic("bmap: out of range");
801018c2:	83 ec 0c             	sub    $0xc,%esp
801018c5:	68 7c 76 10 80       	push   $0x8010767c
801018ca:	e8 f1 ea ff ff       	call   801003c0 <panic>
801018cf:	90                   	nop

801018d0 <readsb>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801018d8:	83 ec 08             	sub    $0x8,%esp
801018db:	6a 01                	push   $0x1
801018dd:	ff 75 08             	push   0x8(%ebp)
801018e0:	e8 eb e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801018e5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801018e8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801018ed:	6a 1c                	push   $0x1c
801018ef:	50                   	push   %eax
801018f0:	56                   	push   %esi
801018f1:	e8 ba 31 00 00       	call   80104ab0 <memmove>
  brelse(bp);
801018f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018f9:	83 c4 10             	add    $0x10,%esp
}
801018fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ff:	5b                   	pop    %ebx
80101900:	5e                   	pop    %esi
80101901:	5d                   	pop    %ebp
  brelse(bp);
80101902:	e9 e9 e8 ff ff       	jmp    801001f0 <brelse>
80101907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010190e:	66 90                	xchg   %ax,%ax

80101910 <iinit>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	bb 60 ff 10 80       	mov    $0x8010ff60,%ebx
80101919:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010191c:	68 8f 76 10 80       	push   $0x8010768f
80101921:	68 20 ff 10 80       	push   $0x8010ff20
80101926:	e8 55 2e 00 00       	call   80104780 <initlock>
  for(i = 0; i < NINODE; i++) {
8010192b:	83 c4 10             	add    $0x10,%esp
8010192e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101930:	83 ec 08             	sub    $0x8,%esp
80101933:	68 96 76 10 80       	push   $0x80107696
80101938:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101939:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010193f:	e8 0c 2d 00 00       	call   80104650 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	81 fb 80 1b 11 80    	cmp    $0x80111b80,%ebx
8010194d:	75 e1                	jne    80101930 <iinit+0x20>
  bp = bread(dev, 1);
8010194f:	83 ec 08             	sub    $0x8,%esp
80101952:	6a 01                	push   $0x1
80101954:	ff 75 08             	push   0x8(%ebp)
80101957:	e8 74 e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010195c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010195f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101961:	8d 40 5c             	lea    0x5c(%eax),%eax
80101964:	6a 1c                	push   $0x1c
80101966:	50                   	push   %eax
80101967:	68 74 1b 11 80       	push   $0x80111b74
8010196c:	e8 3f 31 00 00       	call   80104ab0 <memmove>
  brelse(bp);
80101971:	89 1c 24             	mov    %ebx,(%esp)
80101974:	e8 77 e8 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101979:	ff 35 8c 1b 11 80    	push   0x80111b8c
8010197f:	ff 35 88 1b 11 80    	push   0x80111b88
80101985:	ff 35 84 1b 11 80    	push   0x80111b84
8010198b:	ff 35 80 1b 11 80    	push   0x80111b80
80101991:	ff 35 7c 1b 11 80    	push   0x80111b7c
80101997:	ff 35 78 1b 11 80    	push   0x80111b78
8010199d:	ff 35 74 1b 11 80    	push   0x80111b74
801019a3:	68 fc 76 10 80       	push   $0x801076fc
801019a8:	e8 33 ed ff ff       	call   801006e0 <cprintf>
}
801019ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019b0:	83 c4 30             	add    $0x30,%esp
801019b3:	c9                   	leave  
801019b4:	c3                   	ret    
801019b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019c0 <ialloc>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	57                   	push   %edi
801019c4:	56                   	push   %esi
801019c5:	53                   	push   %ebx
801019c6:	83 ec 1c             	sub    $0x1c,%esp
801019c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801019cc:	83 3d 7c 1b 11 80 01 	cmpl   $0x1,0x80111b7c
{
801019d3:	8b 75 08             	mov    0x8(%ebp),%esi
801019d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801019d9:	0f 86 91 00 00 00    	jbe    80101a70 <ialloc+0xb0>
801019df:	bf 01 00 00 00       	mov    $0x1,%edi
801019e4:	eb 21                	jmp    80101a07 <ialloc+0x47>
801019e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ed:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019f0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801019f3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801019f6:	53                   	push   %ebx
801019f7:	e8 f4 e7 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801019fc:	83 c4 10             	add    $0x10,%esp
801019ff:	3b 3d 7c 1b 11 80    	cmp    0x80111b7c,%edi
80101a05:	73 69                	jae    80101a70 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101a07:	89 f8                	mov    %edi,%eax
80101a09:	83 ec 08             	sub    $0x8,%esp
80101a0c:	c1 e8 03             	shr    $0x3,%eax
80101a0f:	03 05 88 1b 11 80    	add    0x80111b88,%eax
80101a15:	50                   	push   %eax
80101a16:	56                   	push   %esi
80101a17:	e8 b4 e6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101a1c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101a1f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101a21:	89 f8                	mov    %edi,%eax
80101a23:	83 e0 07             	and    $0x7,%eax
80101a26:	c1 e0 06             	shl    $0x6,%eax
80101a29:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101a2d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101a31:	75 bd                	jne    801019f0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101a33:	83 ec 04             	sub    $0x4,%esp
80101a36:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a39:	6a 40                	push   $0x40
80101a3b:	6a 00                	push   $0x0
80101a3d:	51                   	push   %ecx
80101a3e:	e8 cd 2f 00 00       	call   80104a10 <memset>
      dip->type = type;
80101a43:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101a47:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a4a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101a4d:	89 1c 24             	mov    %ebx,(%esp)
80101a50:	e8 9b 18 00 00       	call   801032f0 <log_write>
      brelse(bp);
80101a55:	89 1c 24             	mov    %ebx,(%esp)
80101a58:	e8 93 e7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101a5d:	83 c4 10             	add    $0x10,%esp
}
80101a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101a63:	89 fa                	mov    %edi,%edx
}
80101a65:	5b                   	pop    %ebx
      return iget(dev, inum);
80101a66:	89 f0                	mov    %esi,%eax
}
80101a68:	5e                   	pop    %esi
80101a69:	5f                   	pop    %edi
80101a6a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101a6b:	e9 90 fc ff ff       	jmp    80101700 <iget>
  panic("ialloc: no inodes");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 9c 76 10 80       	push   $0x8010769c
80101a78:	e8 43 e9 ff ff       	call   801003c0 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <iupdate>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a88:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a8b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a8e:	83 ec 08             	sub    $0x8,%esp
80101a91:	c1 e8 03             	shr    $0x3,%eax
80101a94:	03 05 88 1b 11 80    	add    0x80111b88,%eax
80101a9a:	50                   	push   %eax
80101a9b:	ff 73 a4             	push   -0x5c(%ebx)
80101a9e:	e8 2d e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101aa3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101aa7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101aaa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101aac:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101aaf:	83 e0 07             	and    $0x7,%eax
80101ab2:	c1 e0 06             	shl    $0x6,%eax
80101ab5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101ab9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101abc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ac0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101ac3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101ac7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101acb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101acf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101ad3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101ad7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101ada:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101add:	6a 34                	push   $0x34
80101adf:	53                   	push   %ebx
80101ae0:	50                   	push   %eax
80101ae1:	e8 ca 2f 00 00       	call   80104ab0 <memmove>
  log_write(bp);
80101ae6:	89 34 24             	mov    %esi,(%esp)
80101ae9:	e8 02 18 00 00       	call   801032f0 <log_write>
  brelse(bp);
80101aee:	89 75 08             	mov    %esi,0x8(%ebp)
80101af1:	83 c4 10             	add    $0x10,%esp
}
80101af4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101af7:	5b                   	pop    %ebx
80101af8:	5e                   	pop    %esi
80101af9:	5d                   	pop    %ebp
  brelse(bp);
80101afa:	e9 f1 e6 ff ff       	jmp    801001f0 <brelse>
80101aff:	90                   	nop

80101b00 <idup>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	53                   	push   %ebx
80101b04:	83 ec 10             	sub    $0x10,%esp
80101b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101b0a:	68 20 ff 10 80       	push   $0x8010ff20
80101b0f:	e8 3c 2e 00 00       	call   80104950 <acquire>
  ip->ref++;
80101b14:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b18:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80101b1f:	e8 cc 2d 00 00       	call   801048f0 <release>
}
80101b24:	89 d8                	mov    %ebx,%eax
80101b26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b29:	c9                   	leave  
80101b2a:	c3                   	ret    
80101b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b2f:	90                   	nop

80101b30 <ilock>:
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	56                   	push   %esi
80101b34:	53                   	push   %ebx
80101b35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101b38:	85 db                	test   %ebx,%ebx
80101b3a:	0f 84 b7 00 00 00    	je     80101bf7 <ilock+0xc7>
80101b40:	8b 53 08             	mov    0x8(%ebx),%edx
80101b43:	85 d2                	test   %edx,%edx
80101b45:	0f 8e ac 00 00 00    	jle    80101bf7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
80101b4e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101b51:	50                   	push   %eax
80101b52:	e8 39 2b 00 00       	call   80104690 <acquiresleep>
  if(ip->valid == 0){
80101b57:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	85 c0                	test   %eax,%eax
80101b5f:	74 0f                	je     80101b70 <ilock+0x40>
}
80101b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b64:	5b                   	pop    %ebx
80101b65:	5e                   	pop    %esi
80101b66:	5d                   	pop    %ebp
80101b67:	c3                   	ret    
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b70:	8b 43 04             	mov    0x4(%ebx),%eax
80101b73:	83 ec 08             	sub    $0x8,%esp
80101b76:	c1 e8 03             	shr    $0x3,%eax
80101b79:	03 05 88 1b 11 80    	add    0x80111b88,%eax
80101b7f:	50                   	push   %eax
80101b80:	ff 33                	push   (%ebx)
80101b82:	e8 49 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b87:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b8a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b8c:	8b 43 04             	mov    0x4(%ebx),%eax
80101b8f:	83 e0 07             	and    $0x7,%eax
80101b92:	c1 e0 06             	shl    $0x6,%eax
80101b95:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b99:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b9c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b9f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101ba3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101ba7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101bab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101baf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101bb3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101bb7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101bbb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101bbe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bc1:	6a 34                	push   $0x34
80101bc3:	50                   	push   %eax
80101bc4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101bc7:	50                   	push   %eax
80101bc8:	e8 e3 2e 00 00       	call   80104ab0 <memmove>
    brelse(bp);
80101bcd:	89 34 24             	mov    %esi,(%esp)
80101bd0:	e8 1b e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101bd5:	83 c4 10             	add    $0x10,%esp
80101bd8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101bdd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101be4:	0f 85 77 ff ff ff    	jne    80101b61 <ilock+0x31>
      panic("ilock: no type");
80101bea:	83 ec 0c             	sub    $0xc,%esp
80101bed:	68 b4 76 10 80       	push   $0x801076b4
80101bf2:	e8 c9 e7 ff ff       	call   801003c0 <panic>
    panic("ilock");
80101bf7:	83 ec 0c             	sub    $0xc,%esp
80101bfa:	68 ae 76 10 80       	push   $0x801076ae
80101bff:	e8 bc e7 ff ff       	call   801003c0 <panic>
80101c04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c0f:	90                   	nop

80101c10 <iunlock>:
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	56                   	push   %esi
80101c14:	53                   	push   %ebx
80101c15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c18:	85 db                	test   %ebx,%ebx
80101c1a:	74 28                	je     80101c44 <iunlock+0x34>
80101c1c:	83 ec 0c             	sub    $0xc,%esp
80101c1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c22:	56                   	push   %esi
80101c23:	e8 08 2b 00 00       	call   80104730 <holdingsleep>
80101c28:	83 c4 10             	add    $0x10,%esp
80101c2b:	85 c0                	test   %eax,%eax
80101c2d:	74 15                	je     80101c44 <iunlock+0x34>
80101c2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101c32:	85 c0                	test   %eax,%eax
80101c34:	7e 0e                	jle    80101c44 <iunlock+0x34>
  releasesleep(&ip->lock);
80101c36:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c39:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c3c:	5b                   	pop    %ebx
80101c3d:	5e                   	pop    %esi
80101c3e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101c3f:	e9 ac 2a 00 00       	jmp    801046f0 <releasesleep>
    panic("iunlock");
80101c44:	83 ec 0c             	sub    $0xc,%esp
80101c47:	68 c3 76 10 80       	push   $0x801076c3
80101c4c:	e8 6f e7 ff ff       	call   801003c0 <panic>
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c5f:	90                   	nop

80101c60 <iput>:
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	83 ec 28             	sub    $0x28,%esp
80101c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101c6c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101c6f:	57                   	push   %edi
80101c70:	e8 1b 2a 00 00       	call   80104690 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c75:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c78:	83 c4 10             	add    $0x10,%esp
80101c7b:	85 d2                	test   %edx,%edx
80101c7d:	74 07                	je     80101c86 <iput+0x26>
80101c7f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c84:	74 32                	je     80101cb8 <iput+0x58>
  releasesleep(&ip->lock);
80101c86:	83 ec 0c             	sub    $0xc,%esp
80101c89:	57                   	push   %edi
80101c8a:	e8 61 2a 00 00       	call   801046f0 <releasesleep>
  acquire(&icache.lock);
80101c8f:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80101c96:	e8 b5 2c 00 00       	call   80104950 <acquire>
  ip->ref--;
80101c9b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c9f:	83 c4 10             	add    $0x10,%esp
80101ca2:	c7 45 08 20 ff 10 80 	movl   $0x8010ff20,0x8(%ebp)
}
80101ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cac:	5b                   	pop    %ebx
80101cad:	5e                   	pop    %esi
80101cae:	5f                   	pop    %edi
80101caf:	5d                   	pop    %ebp
  release(&icache.lock);
80101cb0:	e9 3b 2c 00 00       	jmp    801048f0 <release>
80101cb5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
80101cbb:	68 20 ff 10 80       	push   $0x8010ff20
80101cc0:	e8 8b 2c 00 00       	call   80104950 <acquire>
    int r = ip->ref;
80101cc5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101cc8:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80101ccf:	e8 1c 2c 00 00       	call   801048f0 <release>
    if(r == 1){
80101cd4:	83 c4 10             	add    $0x10,%esp
80101cd7:	83 fe 01             	cmp    $0x1,%esi
80101cda:	75 aa                	jne    80101c86 <iput+0x26>
80101cdc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101ce2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ce5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ce8:	89 cf                	mov    %ecx,%edi
80101cea:	eb 0b                	jmp    80101cf7 <iput+0x97>
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cf0:	83 c6 04             	add    $0x4,%esi
80101cf3:	39 fe                	cmp    %edi,%esi
80101cf5:	74 19                	je     80101d10 <iput+0xb0>
    if(ip->addrs[i]){
80101cf7:	8b 16                	mov    (%esi),%edx
80101cf9:	85 d2                	test   %edx,%edx
80101cfb:	74 f3                	je     80101cf0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101cfd:	8b 03                	mov    (%ebx),%eax
80101cff:	e8 6c f8 ff ff       	call   80101570 <bfree>
      ip->addrs[i] = 0;
80101d04:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101d0a:	eb e4                	jmp    80101cf0 <iput+0x90>
80101d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101d10:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101d16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d19:	85 c0                	test   %eax,%eax
80101d1b:	75 2d                	jne    80101d4a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101d1d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101d20:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101d27:	53                   	push   %ebx
80101d28:	e8 53 fd ff ff       	call   80101a80 <iupdate>
      ip->type = 0;
80101d2d:	31 c0                	xor    %eax,%eax
80101d2f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101d33:	89 1c 24             	mov    %ebx,(%esp)
80101d36:	e8 45 fd ff ff       	call   80101a80 <iupdate>
      ip->valid = 0;
80101d3b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	e9 3c ff ff ff       	jmp    80101c86 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d4a:	83 ec 08             	sub    $0x8,%esp
80101d4d:	50                   	push   %eax
80101d4e:	ff 33                	push   (%ebx)
80101d50:	e8 7b e3 ff ff       	call   801000d0 <bread>
80101d55:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d58:	83 c4 10             	add    $0x10,%esp
80101d5b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d64:	8d 70 5c             	lea    0x5c(%eax),%esi
80101d67:	89 cf                	mov    %ecx,%edi
80101d69:	eb 0c                	jmp    80101d77 <iput+0x117>
80101d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop
80101d70:	83 c6 04             	add    $0x4,%esi
80101d73:	39 f7                	cmp    %esi,%edi
80101d75:	74 0f                	je     80101d86 <iput+0x126>
      if(a[j])
80101d77:	8b 16                	mov    (%esi),%edx
80101d79:	85 d2                	test   %edx,%edx
80101d7b:	74 f3                	je     80101d70 <iput+0x110>
        bfree(ip->dev, a[j]);
80101d7d:	8b 03                	mov    (%ebx),%eax
80101d7f:	e8 ec f7 ff ff       	call   80101570 <bfree>
80101d84:	eb ea                	jmp    80101d70 <iput+0x110>
    brelse(bp);
80101d86:	83 ec 0c             	sub    $0xc,%esp
80101d89:	ff 75 e4             	push   -0x1c(%ebp)
80101d8c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d8f:	e8 5c e4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d94:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d9a:	8b 03                	mov    (%ebx),%eax
80101d9c:	e8 cf f7 ff ff       	call   80101570 <bfree>
    ip->addrs[NDIRECT] = 0;
80101da1:	83 c4 10             	add    $0x10,%esp
80101da4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101dab:	00 00 00 
80101dae:	e9 6a ff ff ff       	jmp    80101d1d <iput+0xbd>
80101db3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101dc0 <iunlockput>:
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	56                   	push   %esi
80101dc4:	53                   	push   %ebx
80101dc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101dc8:	85 db                	test   %ebx,%ebx
80101dca:	74 34                	je     80101e00 <iunlockput+0x40>
80101dcc:	83 ec 0c             	sub    $0xc,%esp
80101dcf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101dd2:	56                   	push   %esi
80101dd3:	e8 58 29 00 00       	call   80104730 <holdingsleep>
80101dd8:	83 c4 10             	add    $0x10,%esp
80101ddb:	85 c0                	test   %eax,%eax
80101ddd:	74 21                	je     80101e00 <iunlockput+0x40>
80101ddf:	8b 43 08             	mov    0x8(%ebx),%eax
80101de2:	85 c0                	test   %eax,%eax
80101de4:	7e 1a                	jle    80101e00 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101de6:	83 ec 0c             	sub    $0xc,%esp
80101de9:	56                   	push   %esi
80101dea:	e8 01 29 00 00       	call   801046f0 <releasesleep>
  iput(ip);
80101def:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101df2:	83 c4 10             	add    $0x10,%esp
}
80101df5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101df8:	5b                   	pop    %ebx
80101df9:	5e                   	pop    %esi
80101dfa:	5d                   	pop    %ebp
  iput(ip);
80101dfb:	e9 60 fe ff ff       	jmp    80101c60 <iput>
    panic("iunlock");
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	68 c3 76 10 80       	push   $0x801076c3
80101e08:	e8 b3 e5 ff ff       	call   801003c0 <panic>
80101e0d:	8d 76 00             	lea    0x0(%esi),%esi

80101e10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	8b 55 08             	mov    0x8(%ebp),%edx
80101e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101e19:	8b 0a                	mov    (%edx),%ecx
80101e1b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101e1e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101e21:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101e24:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101e28:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101e2b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101e2f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101e33:	8b 52 58             	mov    0x58(%edx),%edx
80101e36:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e39:	5d                   	pop    %ebp
80101e3a:	c3                   	ret    
80101e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e3f:	90                   	nop

80101e40 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 1c             	sub    $0x1c,%esp
80101e49:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4f:	8b 75 10             	mov    0x10(%ebp),%esi
80101e52:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e55:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e58:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e60:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101e63:	0f 84 a7 00 00 00    	je     80101f10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101e69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e6c:	8b 40 58             	mov    0x58(%eax),%eax
80101e6f:	39 c6                	cmp    %eax,%esi
80101e71:	0f 87 ba 00 00 00    	ja     80101f31 <readi+0xf1>
80101e77:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e7a:	31 c9                	xor    %ecx,%ecx
80101e7c:	89 da                	mov    %ebx,%edx
80101e7e:	01 f2                	add    %esi,%edx
80101e80:	0f 92 c1             	setb   %cl
80101e83:	89 cf                	mov    %ecx,%edi
80101e85:	0f 82 a6 00 00 00    	jb     80101f31 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101e8b:	89 c1                	mov    %eax,%ecx
80101e8d:	29 f1                	sub    %esi,%ecx
80101e8f:	39 d0                	cmp    %edx,%eax
80101e91:	0f 43 cb             	cmovae %ebx,%ecx
80101e94:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e97:	85 c9                	test   %ecx,%ecx
80101e99:	74 67                	je     80101f02 <readi+0xc2>
80101e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e9f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ea0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ea3:	89 f2                	mov    %esi,%edx
80101ea5:	c1 ea 09             	shr    $0x9,%edx
80101ea8:	89 d8                	mov    %ebx,%eax
80101eaa:	e8 51 f9 ff ff       	call   80101800 <bmap>
80101eaf:	83 ec 08             	sub    $0x8,%esp
80101eb2:	50                   	push   %eax
80101eb3:	ff 33                	push   (%ebx)
80101eb5:	e8 16 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101eba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ebd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ec2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ec4:	89 f0                	mov    %esi,%eax
80101ec6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ecb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ecd:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ed0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ed2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ed6:	39 d9                	cmp    %ebx,%ecx
80101ed8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101edb:	83 c4 0c             	add    $0xc,%esp
80101ede:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101edf:	01 df                	add    %ebx,%edi
80101ee1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ee3:	50                   	push   %eax
80101ee4:	ff 75 e0             	push   -0x20(%ebp)
80101ee7:	e8 c4 2b 00 00       	call   80104ab0 <memmove>
    brelse(bp);
80101eec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101eef:	89 14 24             	mov    %edx,(%esp)
80101ef2:	e8 f9 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ef7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101efa:	83 c4 10             	add    $0x10,%esp
80101efd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101f00:	77 9e                	ja     80101ea0 <readi+0x60>
  }
  return n;
80101f02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f08:	5b                   	pop    %ebx
80101f09:	5e                   	pop    %esi
80101f0a:	5f                   	pop    %edi
80101f0b:	5d                   	pop    %ebp
80101f0c:	c3                   	ret    
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f14:	66 83 f8 09          	cmp    $0x9,%ax
80101f18:	77 17                	ja     80101f31 <readi+0xf1>
80101f1a:	8b 04 c5 c0 fe 10 80 	mov    -0x7fef0140(,%eax,8),%eax
80101f21:	85 c0                	test   %eax,%eax
80101f23:	74 0c                	je     80101f31 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101f25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f2b:	5b                   	pop    %ebx
80101f2c:	5e                   	pop    %esi
80101f2d:	5f                   	pop    %edi
80101f2e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101f2f:	ff e0                	jmp    *%eax
      return -1;
80101f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f36:	eb cd                	jmp    80101f05 <readi+0xc5>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop

80101f40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	57                   	push   %edi
80101f44:	56                   	push   %esi
80101f45:	53                   	push   %ebx
80101f46:	83 ec 1c             	sub    $0x1c,%esp
80101f49:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f4f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101f5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101f60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101f63:	0f 84 b7 00 00 00    	je     80102020 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101f69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f6f:	0f 87 e7 00 00 00    	ja     8010205c <writei+0x11c>
80101f75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f78:	31 d2                	xor    %edx,%edx
80101f7a:	89 f8                	mov    %edi,%eax
80101f7c:	01 f0                	add    %esi,%eax
80101f7e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101f81:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f86:	0f 87 d0 00 00 00    	ja     8010205c <writei+0x11c>
80101f8c:	85 d2                	test   %edx,%edx
80101f8e:	0f 85 c8 00 00 00    	jne    8010205c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f9b:	85 ff                	test   %edi,%edi
80101f9d:	74 72                	je     80102011 <writei+0xd1>
80101f9f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fa0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101fa3:	89 f2                	mov    %esi,%edx
80101fa5:	c1 ea 09             	shr    $0x9,%edx
80101fa8:	89 f8                	mov    %edi,%eax
80101faa:	e8 51 f8 ff ff       	call   80101800 <bmap>
80101faf:	83 ec 08             	sub    $0x8,%esp
80101fb2:	50                   	push   %eax
80101fb3:	ff 37                	push   (%edi)
80101fb5:	e8 16 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101fba:	b9 00 02 00 00       	mov    $0x200,%ecx
80101fbf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101fc2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fc5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc7:	89 f0                	mov    %esi,%eax
80101fc9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fce:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101fd0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fd4:	39 d9                	cmp    %ebx,%ecx
80101fd6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101fd9:	83 c4 0c             	add    $0xc,%esp
80101fdc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fdd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101fdf:	ff 75 dc             	push   -0x24(%ebp)
80101fe2:	50                   	push   %eax
80101fe3:	e8 c8 2a 00 00       	call   80104ab0 <memmove>
    log_write(bp);
80101fe8:	89 3c 24             	mov    %edi,(%esp)
80101feb:	e8 00 13 00 00       	call   801032f0 <log_write>
    brelse(bp);
80101ff0:	89 3c 24             	mov    %edi,(%esp)
80101ff3:	e8 f8 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ff8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ffb:	83 c4 10             	add    $0x10,%esp
80101ffe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102001:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102004:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102007:	77 97                	ja     80101fa0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102009:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010200c:	3b 70 58             	cmp    0x58(%eax),%esi
8010200f:	77 37                	ja     80102048 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102011:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102017:	5b                   	pop    %ebx
80102018:	5e                   	pop    %esi
80102019:	5f                   	pop    %edi
8010201a:	5d                   	pop    %ebp
8010201b:	c3                   	ret    
8010201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102020:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102024:	66 83 f8 09          	cmp    $0x9,%ax
80102028:	77 32                	ja     8010205c <writei+0x11c>
8010202a:	8b 04 c5 c4 fe 10 80 	mov    -0x7fef013c(,%eax,8),%eax
80102031:	85 c0                	test   %eax,%eax
80102033:	74 27                	je     8010205c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102035:	89 55 10             	mov    %edx,0x10(%ebp)
}
80102038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010203b:	5b                   	pop    %ebx
8010203c:	5e                   	pop    %esi
8010203d:	5f                   	pop    %edi
8010203e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010203f:	ff e0                	jmp    *%eax
80102041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102048:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010204b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010204e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102051:	50                   	push   %eax
80102052:	e8 29 fa ff ff       	call   80101a80 <iupdate>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	eb b5                	jmp    80102011 <writei+0xd1>
      return -1;
8010205c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102061:	eb b1                	jmp    80102014 <writei+0xd4>
80102063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010206a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102070 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102076:	6a 0e                	push   $0xe
80102078:	ff 75 0c             	push   0xc(%ebp)
8010207b:	ff 75 08             	push   0x8(%ebp)
8010207e:	e8 9d 2a 00 00       	call   80104b20 <strncmp>
}
80102083:	c9                   	leave  
80102084:	c3                   	ret    
80102085:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010208c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102090 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
80102099:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010209c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020a1:	0f 85 85 00 00 00    	jne    8010212c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801020a7:	8b 53 58             	mov    0x58(%ebx),%edx
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020af:	85 d2                	test   %edx,%edx
801020b1:	74 3e                	je     801020f1 <dirlookup+0x61>
801020b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b8:	6a 10                	push   $0x10
801020ba:	57                   	push   %edi
801020bb:	56                   	push   %esi
801020bc:	53                   	push   %ebx
801020bd:	e8 7e fd ff ff       	call   80101e40 <readi>
801020c2:	83 c4 10             	add    $0x10,%esp
801020c5:	83 f8 10             	cmp    $0x10,%eax
801020c8:	75 55                	jne    8010211f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801020ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020cf:	74 18                	je     801020e9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801020d1:	83 ec 04             	sub    $0x4,%esp
801020d4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020d7:	6a 0e                	push   $0xe
801020d9:	50                   	push   %eax
801020da:	ff 75 0c             	push   0xc(%ebp)
801020dd:	e8 3e 2a 00 00       	call   80104b20 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801020e2:	83 c4 10             	add    $0x10,%esp
801020e5:	85 c0                	test   %eax,%eax
801020e7:	74 17                	je     80102100 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020e9:	83 c7 10             	add    $0x10,%edi
801020ec:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020ef:	72 c7                	jb     801020b8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801020f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801020f4:	31 c0                	xor    %eax,%eax
}
801020f6:	5b                   	pop    %ebx
801020f7:	5e                   	pop    %esi
801020f8:	5f                   	pop    %edi
801020f9:	5d                   	pop    %ebp
801020fa:	c3                   	ret    
801020fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020ff:	90                   	nop
      if(poff)
80102100:	8b 45 10             	mov    0x10(%ebp),%eax
80102103:	85 c0                	test   %eax,%eax
80102105:	74 05                	je     8010210c <dirlookup+0x7c>
        *poff = off;
80102107:	8b 45 10             	mov    0x10(%ebp),%eax
8010210a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010210c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102110:	8b 03                	mov    (%ebx),%eax
80102112:	e8 e9 f5 ff ff       	call   80101700 <iget>
}
80102117:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010211a:	5b                   	pop    %ebx
8010211b:	5e                   	pop    %esi
8010211c:	5f                   	pop    %edi
8010211d:	5d                   	pop    %ebp
8010211e:	c3                   	ret    
      panic("dirlookup read");
8010211f:	83 ec 0c             	sub    $0xc,%esp
80102122:	68 dd 76 10 80       	push   $0x801076dd
80102127:	e8 94 e2 ff ff       	call   801003c0 <panic>
    panic("dirlookup not DIR");
8010212c:	83 ec 0c             	sub    $0xc,%esp
8010212f:	68 cb 76 10 80       	push   $0x801076cb
80102134:	e8 87 e2 ff ff       	call   801003c0 <panic>
80102139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102140 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	89 c3                	mov    %eax,%ebx
80102148:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010214b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010214e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102151:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102154:	0f 84 64 01 00 00    	je     801022be <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010215a:	e8 c1 1b 00 00       	call   80103d20 <myproc>
  acquire(&icache.lock);
8010215f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102162:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102165:	68 20 ff 10 80       	push   $0x8010ff20
8010216a:	e8 e1 27 00 00       	call   80104950 <acquire>
  ip->ref++;
8010216f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102173:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010217a:	e8 71 27 00 00       	call   801048f0 <release>
8010217f:	83 c4 10             	add    $0x10,%esp
80102182:	eb 07                	jmp    8010218b <namex+0x4b>
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102188:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010218b:	0f b6 03             	movzbl (%ebx),%eax
8010218e:	3c 2f                	cmp    $0x2f,%al
80102190:	74 f6                	je     80102188 <namex+0x48>
  if(*path == 0)
80102192:	84 c0                	test   %al,%al
80102194:	0f 84 06 01 00 00    	je     801022a0 <namex+0x160>
  while(*path != '/' && *path != 0)
8010219a:	0f b6 03             	movzbl (%ebx),%eax
8010219d:	84 c0                	test   %al,%al
8010219f:	0f 84 10 01 00 00    	je     801022b5 <namex+0x175>
801021a5:	89 df                	mov    %ebx,%edi
801021a7:	3c 2f                	cmp    $0x2f,%al
801021a9:	0f 84 06 01 00 00    	je     801022b5 <namex+0x175>
801021af:	90                   	nop
801021b0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801021b4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801021b7:	3c 2f                	cmp    $0x2f,%al
801021b9:	74 04                	je     801021bf <namex+0x7f>
801021bb:	84 c0                	test   %al,%al
801021bd:	75 f1                	jne    801021b0 <namex+0x70>
  len = path - s;
801021bf:	89 f8                	mov    %edi,%eax
801021c1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801021c3:	83 f8 0d             	cmp    $0xd,%eax
801021c6:	0f 8e ac 00 00 00    	jle    80102278 <namex+0x138>
    memmove(name, s, DIRSIZ);
801021cc:	83 ec 04             	sub    $0x4,%esp
801021cf:	6a 0e                	push   $0xe
801021d1:	53                   	push   %ebx
    path++;
801021d2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
801021d4:	ff 75 e4             	push   -0x1c(%ebp)
801021d7:	e8 d4 28 00 00       	call   80104ab0 <memmove>
801021dc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801021df:	80 3f 2f             	cmpb   $0x2f,(%edi)
801021e2:	75 0c                	jne    801021f0 <namex+0xb0>
801021e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801021e8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801021eb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801021ee:	74 f8                	je     801021e8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801021f0:	83 ec 0c             	sub    $0xc,%esp
801021f3:	56                   	push   %esi
801021f4:	e8 37 f9 ff ff       	call   80101b30 <ilock>
    if(ip->type != T_DIR){
801021f9:	83 c4 10             	add    $0x10,%esp
801021fc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102201:	0f 85 cd 00 00 00    	jne    801022d4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102207:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010220a:	85 c0                	test   %eax,%eax
8010220c:	74 09                	je     80102217 <namex+0xd7>
8010220e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102211:	0f 84 22 01 00 00    	je     80102339 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102217:	83 ec 04             	sub    $0x4,%esp
8010221a:	6a 00                	push   $0x0
8010221c:	ff 75 e4             	push   -0x1c(%ebp)
8010221f:	56                   	push   %esi
80102220:	e8 6b fe ff ff       	call   80102090 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102225:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102228:	83 c4 10             	add    $0x10,%esp
8010222b:	89 c7                	mov    %eax,%edi
8010222d:	85 c0                	test   %eax,%eax
8010222f:	0f 84 e1 00 00 00    	je     80102316 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010223b:	52                   	push   %edx
8010223c:	e8 ef 24 00 00       	call   80104730 <holdingsleep>
80102241:	83 c4 10             	add    $0x10,%esp
80102244:	85 c0                	test   %eax,%eax
80102246:	0f 84 30 01 00 00    	je     8010237c <namex+0x23c>
8010224c:	8b 56 08             	mov    0x8(%esi),%edx
8010224f:	85 d2                	test   %edx,%edx
80102251:	0f 8e 25 01 00 00    	jle    8010237c <namex+0x23c>
  releasesleep(&ip->lock);
80102257:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010225a:	83 ec 0c             	sub    $0xc,%esp
8010225d:	52                   	push   %edx
8010225e:	e8 8d 24 00 00       	call   801046f0 <releasesleep>
  iput(ip);
80102263:	89 34 24             	mov    %esi,(%esp)
80102266:	89 fe                	mov    %edi,%esi
80102268:	e8 f3 f9 ff ff       	call   80101c60 <iput>
8010226d:	83 c4 10             	add    $0x10,%esp
80102270:	e9 16 ff ff ff       	jmp    8010218b <namex+0x4b>
80102275:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102278:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010227b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010227e:	83 ec 04             	sub    $0x4,%esp
80102281:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102284:	50                   	push   %eax
80102285:	53                   	push   %ebx
    name[len] = 0;
80102286:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102288:	ff 75 e4             	push   -0x1c(%ebp)
8010228b:	e8 20 28 00 00       	call   80104ab0 <memmove>
    name[len] = 0;
80102290:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102293:	83 c4 10             	add    $0x10,%esp
80102296:	c6 02 00             	movb   $0x0,(%edx)
80102299:	e9 41 ff ff ff       	jmp    801021df <namex+0x9f>
8010229e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801022a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801022a3:	85 c0                	test   %eax,%eax
801022a5:	0f 85 be 00 00 00    	jne    80102369 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801022ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022ae:	89 f0                	mov    %esi,%eax
801022b0:	5b                   	pop    %ebx
801022b1:	5e                   	pop    %esi
801022b2:	5f                   	pop    %edi
801022b3:	5d                   	pop    %ebp
801022b4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801022b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801022b8:	89 df                	mov    %ebx,%edi
801022ba:	31 c0                	xor    %eax,%eax
801022bc:	eb c0                	jmp    8010227e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801022be:	ba 01 00 00 00       	mov    $0x1,%edx
801022c3:	b8 01 00 00 00       	mov    $0x1,%eax
801022c8:	e8 33 f4 ff ff       	call   80101700 <iget>
801022cd:	89 c6                	mov    %eax,%esi
801022cf:	e9 b7 fe ff ff       	jmp    8010218b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801022da:	53                   	push   %ebx
801022db:	e8 50 24 00 00       	call   80104730 <holdingsleep>
801022e0:	83 c4 10             	add    $0x10,%esp
801022e3:	85 c0                	test   %eax,%eax
801022e5:	0f 84 91 00 00 00    	je     8010237c <namex+0x23c>
801022eb:	8b 46 08             	mov    0x8(%esi),%eax
801022ee:	85 c0                	test   %eax,%eax
801022f0:	0f 8e 86 00 00 00    	jle    8010237c <namex+0x23c>
  releasesleep(&ip->lock);
801022f6:	83 ec 0c             	sub    $0xc,%esp
801022f9:	53                   	push   %ebx
801022fa:	e8 f1 23 00 00       	call   801046f0 <releasesleep>
  iput(ip);
801022ff:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102302:	31 f6                	xor    %esi,%esi
  iput(ip);
80102304:	e8 57 f9 ff ff       	call   80101c60 <iput>
      return 0;
80102309:	83 c4 10             	add    $0x10,%esp
}
8010230c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010230f:	89 f0                	mov    %esi,%eax
80102311:	5b                   	pop    %ebx
80102312:	5e                   	pop    %esi
80102313:	5f                   	pop    %edi
80102314:	5d                   	pop    %ebp
80102315:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102316:	83 ec 0c             	sub    $0xc,%esp
80102319:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010231c:	52                   	push   %edx
8010231d:	e8 0e 24 00 00       	call   80104730 <holdingsleep>
80102322:	83 c4 10             	add    $0x10,%esp
80102325:	85 c0                	test   %eax,%eax
80102327:	74 53                	je     8010237c <namex+0x23c>
80102329:	8b 4e 08             	mov    0x8(%esi),%ecx
8010232c:	85 c9                	test   %ecx,%ecx
8010232e:	7e 4c                	jle    8010237c <namex+0x23c>
  releasesleep(&ip->lock);
80102330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102333:	83 ec 0c             	sub    $0xc,%esp
80102336:	52                   	push   %edx
80102337:	eb c1                	jmp    801022fa <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102339:	83 ec 0c             	sub    $0xc,%esp
8010233c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010233f:	53                   	push   %ebx
80102340:	e8 eb 23 00 00       	call   80104730 <holdingsleep>
80102345:	83 c4 10             	add    $0x10,%esp
80102348:	85 c0                	test   %eax,%eax
8010234a:	74 30                	je     8010237c <namex+0x23c>
8010234c:	8b 7e 08             	mov    0x8(%esi),%edi
8010234f:	85 ff                	test   %edi,%edi
80102351:	7e 29                	jle    8010237c <namex+0x23c>
  releasesleep(&ip->lock);
80102353:	83 ec 0c             	sub    $0xc,%esp
80102356:	53                   	push   %ebx
80102357:	e8 94 23 00 00       	call   801046f0 <releasesleep>
}
8010235c:	83 c4 10             	add    $0x10,%esp
}
8010235f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102362:	89 f0                	mov    %esi,%eax
80102364:	5b                   	pop    %ebx
80102365:	5e                   	pop    %esi
80102366:	5f                   	pop    %edi
80102367:	5d                   	pop    %ebp
80102368:	c3                   	ret    
    iput(ip);
80102369:	83 ec 0c             	sub    $0xc,%esp
8010236c:	56                   	push   %esi
    return 0;
8010236d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010236f:	e8 ec f8 ff ff       	call   80101c60 <iput>
    return 0;
80102374:	83 c4 10             	add    $0x10,%esp
80102377:	e9 2f ff ff ff       	jmp    801022ab <namex+0x16b>
    panic("iunlock");
8010237c:	83 ec 0c             	sub    $0xc,%esp
8010237f:	68 c3 76 10 80       	push   $0x801076c3
80102384:	e8 37 e0 ff ff       	call   801003c0 <panic>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102390 <dirlink>:
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	57                   	push   %edi
80102394:	56                   	push   %esi
80102395:	53                   	push   %ebx
80102396:	83 ec 20             	sub    $0x20,%esp
80102399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010239c:	6a 00                	push   $0x0
8010239e:	ff 75 0c             	push   0xc(%ebp)
801023a1:	53                   	push   %ebx
801023a2:	e8 e9 fc ff ff       	call   80102090 <dirlookup>
801023a7:	83 c4 10             	add    $0x10,%esp
801023aa:	85 c0                	test   %eax,%eax
801023ac:	75 67                	jne    80102415 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801023ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801023b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801023b4:	85 ff                	test   %edi,%edi
801023b6:	74 29                	je     801023e1 <dirlink+0x51>
801023b8:	31 ff                	xor    %edi,%edi
801023ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801023bd:	eb 09                	jmp    801023c8 <dirlink+0x38>
801023bf:	90                   	nop
801023c0:	83 c7 10             	add    $0x10,%edi
801023c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801023c6:	73 19                	jae    801023e1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023c8:	6a 10                	push   $0x10
801023ca:	57                   	push   %edi
801023cb:	56                   	push   %esi
801023cc:	53                   	push   %ebx
801023cd:	e8 6e fa ff ff       	call   80101e40 <readi>
801023d2:	83 c4 10             	add    $0x10,%esp
801023d5:	83 f8 10             	cmp    $0x10,%eax
801023d8:	75 4e                	jne    80102428 <dirlink+0x98>
    if(de.inum == 0)
801023da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801023df:	75 df                	jne    801023c0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801023e1:	83 ec 04             	sub    $0x4,%esp
801023e4:	8d 45 da             	lea    -0x26(%ebp),%eax
801023e7:	6a 0e                	push   $0xe
801023e9:	ff 75 0c             	push   0xc(%ebp)
801023ec:	50                   	push   %eax
801023ed:	e8 7e 27 00 00       	call   80104b70 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023f2:	6a 10                	push   $0x10
  de.inum = inum;
801023f4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023f7:	57                   	push   %edi
801023f8:	56                   	push   %esi
801023f9:	53                   	push   %ebx
  de.inum = inum;
801023fa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023fe:	e8 3d fb ff ff       	call   80101f40 <writei>
80102403:	83 c4 20             	add    $0x20,%esp
80102406:	83 f8 10             	cmp    $0x10,%eax
80102409:	75 2a                	jne    80102435 <dirlink+0xa5>
  return 0;
8010240b:	31 c0                	xor    %eax,%eax
}
8010240d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102410:	5b                   	pop    %ebx
80102411:	5e                   	pop    %esi
80102412:	5f                   	pop    %edi
80102413:	5d                   	pop    %ebp
80102414:	c3                   	ret    
    iput(ip);
80102415:	83 ec 0c             	sub    $0xc,%esp
80102418:	50                   	push   %eax
80102419:	e8 42 f8 ff ff       	call   80101c60 <iput>
    return -1;
8010241e:	83 c4 10             	add    $0x10,%esp
80102421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102426:	eb e5                	jmp    8010240d <dirlink+0x7d>
      panic("dirlink read");
80102428:	83 ec 0c             	sub    $0xc,%esp
8010242b:	68 ec 76 10 80       	push   $0x801076ec
80102430:	e8 8b df ff ff       	call   801003c0 <panic>
    panic("dirlink");
80102435:	83 ec 0c             	sub    $0xc,%esp
80102438:	68 be 7c 10 80       	push   $0x80107cbe
8010243d:	e8 7e df ff ff       	call   801003c0 <panic>
80102442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102450 <namei>:

struct inode*
namei(char *path)
{
80102450:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102451:	31 d2                	xor    %edx,%edx
{
80102453:	89 e5                	mov    %esp,%ebp
80102455:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
8010245b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010245e:	e8 dd fc ff ff       	call   80102140 <namex>
}
80102463:	c9                   	leave  
80102464:	c3                   	ret    
80102465:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102470 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102470:	55                   	push   %ebp
  return namex(path, 1, name);
80102471:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102476:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102478:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010247b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010247e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010247f:	e9 bc fc ff ff       	jmp    80102140 <namex>
80102484:	66 90                	xchg   %ax,%ax
80102486:	66 90                	xchg   %ax,%ax
80102488:	66 90                	xchg   %ax,%ax
8010248a:	66 90                	xchg   %ax,%ax
8010248c:	66 90                	xchg   %ax,%ax
8010248e:	66 90                	xchg   %ax,%ax

80102490 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	57                   	push   %edi
80102494:	56                   	push   %esi
80102495:	53                   	push   %ebx
80102496:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102499:	85 c0                	test   %eax,%eax
8010249b:	0f 84 b4 00 00 00    	je     80102555 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801024a1:	8b 70 08             	mov    0x8(%eax),%esi
801024a4:	89 c3                	mov    %eax,%ebx
801024a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801024ac:	0f 87 96 00 00 00    	ja     80102548 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801024b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024be:	66 90                	xchg   %ax,%ax
801024c0:	89 ca                	mov    %ecx,%edx
801024c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024c3:	83 e0 c0             	and    $0xffffffc0,%eax
801024c6:	3c 40                	cmp    $0x40,%al
801024c8:	75 f6                	jne    801024c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024ca:	31 ff                	xor    %edi,%edi
801024cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801024d1:	89 f8                	mov    %edi,%eax
801024d3:	ee                   	out    %al,(%dx)
801024d4:	b8 01 00 00 00       	mov    $0x1,%eax
801024d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801024de:	ee                   	out    %al,(%dx)
801024df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801024e4:	89 f0                	mov    %esi,%eax
801024e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801024e7:	89 f0                	mov    %esi,%eax
801024e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801024ee:	c1 f8 08             	sar    $0x8,%eax
801024f1:	ee                   	out    %al,(%dx)
801024f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801024f7:	89 f8                	mov    %edi,%eax
801024f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801024fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801024fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102503:	c1 e0 04             	shl    $0x4,%eax
80102506:	83 e0 10             	and    $0x10,%eax
80102509:	83 c8 e0             	or     $0xffffffe0,%eax
8010250c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010250d:	f6 03 04             	testb  $0x4,(%ebx)
80102510:	75 16                	jne    80102528 <idestart+0x98>
80102512:	b8 20 00 00 00       	mov    $0x20,%eax
80102517:	89 ca                	mov    %ecx,%edx
80102519:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010251a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010251d:	5b                   	pop    %ebx
8010251e:	5e                   	pop    %esi
8010251f:	5f                   	pop    %edi
80102520:	5d                   	pop    %ebp
80102521:	c3                   	ret    
80102522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102528:	b8 30 00 00 00       	mov    $0x30,%eax
8010252d:	89 ca                	mov    %ecx,%edx
8010252f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102530:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102535:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102538:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010253d:	fc                   	cld    
8010253e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102540:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102543:	5b                   	pop    %ebx
80102544:	5e                   	pop    %esi
80102545:	5f                   	pop    %edi
80102546:	5d                   	pop    %ebp
80102547:	c3                   	ret    
    panic("incorrect blockno");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 58 77 10 80       	push   $0x80107758
80102550:	e8 6b de ff ff       	call   801003c0 <panic>
    panic("idestart");
80102555:	83 ec 0c             	sub    $0xc,%esp
80102558:	68 4f 77 10 80       	push   $0x8010774f
8010255d:	e8 5e de ff ff       	call   801003c0 <panic>
80102562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102570 <ideinit>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102576:	68 6a 77 10 80       	push   $0x8010776a
8010257b:	68 c0 1b 11 80       	push   $0x80111bc0
80102580:	e8 fb 21 00 00       	call   80104780 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102585:	58                   	pop    %eax
80102586:	a1 44 1d 11 80       	mov    0x80111d44,%eax
8010258b:	5a                   	pop    %edx
8010258c:	83 e8 01             	sub    $0x1,%eax
8010258f:	50                   	push   %eax
80102590:	6a 0e                	push   $0xe
80102592:	e8 99 02 00 00       	call   80102830 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102597:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010259a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010259f:	90                   	nop
801025a0:	ec                   	in     (%dx),%al
801025a1:	83 e0 c0             	and    $0xffffffc0,%eax
801025a4:	3c 40                	cmp    $0x40,%al
801025a6:	75 f8                	jne    801025a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801025ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025b2:	ee                   	out    %al,(%dx)
801025b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025bd:	eb 06                	jmp    801025c5 <ideinit+0x55>
801025bf:	90                   	nop
  for(i=0; i<1000; i++){
801025c0:	83 e9 01             	sub    $0x1,%ecx
801025c3:	74 0f                	je     801025d4 <ideinit+0x64>
801025c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801025c6:	84 c0                	test   %al,%al
801025c8:	74 f6                	je     801025c0 <ideinit+0x50>
      havedisk1 = 1;
801025ca:	c7 05 a0 1b 11 80 01 	movl   $0x1,0x80111ba0
801025d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801025d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025de:	ee                   	out    %al,(%dx)
}
801025df:	c9                   	leave  
801025e0:	c3                   	ret    
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ef:	90                   	nop

801025f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	57                   	push   %edi
801025f4:	56                   	push   %esi
801025f5:	53                   	push   %ebx
801025f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801025f9:	68 c0 1b 11 80       	push   $0x80111bc0
801025fe:	e8 4d 23 00 00       	call   80104950 <acquire>

  if((b = idequeue) == 0){
80102603:	8b 1d a4 1b 11 80    	mov    0x80111ba4,%ebx
80102609:	83 c4 10             	add    $0x10,%esp
8010260c:	85 db                	test   %ebx,%ebx
8010260e:	74 63                	je     80102673 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102610:	8b 43 58             	mov    0x58(%ebx),%eax
80102613:	a3 a4 1b 11 80       	mov    %eax,0x80111ba4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102618:	8b 33                	mov    (%ebx),%esi
8010261a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102620:	75 2f                	jne    80102651 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102622:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262e:	66 90                	xchg   %ax,%ax
80102630:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102631:	89 c1                	mov    %eax,%ecx
80102633:	83 e1 c0             	and    $0xffffffc0,%ecx
80102636:	80 f9 40             	cmp    $0x40,%cl
80102639:	75 f5                	jne    80102630 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010263b:	a8 21                	test   $0x21,%al
8010263d:	75 12                	jne    80102651 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010263f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102642:	b9 80 00 00 00       	mov    $0x80,%ecx
80102647:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010264c:	fc                   	cld    
8010264d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010264f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102651:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102654:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102657:	83 ce 02             	or     $0x2,%esi
8010265a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010265c:	53                   	push   %ebx
8010265d:	e8 4e 1e 00 00       	call   801044b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102662:	a1 a4 1b 11 80       	mov    0x80111ba4,%eax
80102667:	83 c4 10             	add    $0x10,%esp
8010266a:	85 c0                	test   %eax,%eax
8010266c:	74 05                	je     80102673 <ideintr+0x83>
    idestart(idequeue);
8010266e:	e8 1d fe ff ff       	call   80102490 <idestart>
    release(&idelock);
80102673:	83 ec 0c             	sub    $0xc,%esp
80102676:	68 c0 1b 11 80       	push   $0x80111bc0
8010267b:	e8 70 22 00 00       	call   801048f0 <release>

  release(&idelock);
}
80102680:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102683:	5b                   	pop    %ebx
80102684:	5e                   	pop    %esi
80102685:	5f                   	pop    %edi
80102686:	5d                   	pop    %ebp
80102687:	c3                   	ret    
80102688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop

80102690 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	53                   	push   %ebx
80102694:	83 ec 10             	sub    $0x10,%esp
80102697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010269a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010269d:	50                   	push   %eax
8010269e:	e8 8d 20 00 00       	call   80104730 <holdingsleep>
801026a3:	83 c4 10             	add    $0x10,%esp
801026a6:	85 c0                	test   %eax,%eax
801026a8:	0f 84 c3 00 00 00    	je     80102771 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801026ae:	8b 03                	mov    (%ebx),%eax
801026b0:	83 e0 06             	and    $0x6,%eax
801026b3:	83 f8 02             	cmp    $0x2,%eax
801026b6:	0f 84 a8 00 00 00    	je     80102764 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801026bc:	8b 53 04             	mov    0x4(%ebx),%edx
801026bf:	85 d2                	test   %edx,%edx
801026c1:	74 0d                	je     801026d0 <iderw+0x40>
801026c3:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
801026c8:	85 c0                	test   %eax,%eax
801026ca:	0f 84 87 00 00 00    	je     80102757 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801026d0:	83 ec 0c             	sub    $0xc,%esp
801026d3:	68 c0 1b 11 80       	push   $0x80111bc0
801026d8:	e8 73 22 00 00       	call   80104950 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026dd:	a1 a4 1b 11 80       	mov    0x80111ba4,%eax
  b->qnext = 0;
801026e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026e9:	83 c4 10             	add    $0x10,%esp
801026ec:	85 c0                	test   %eax,%eax
801026ee:	74 60                	je     80102750 <iderw+0xc0>
801026f0:	89 c2                	mov    %eax,%edx
801026f2:	8b 40 58             	mov    0x58(%eax),%eax
801026f5:	85 c0                	test   %eax,%eax
801026f7:	75 f7                	jne    801026f0 <iderw+0x60>
801026f9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801026fc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801026fe:	39 1d a4 1b 11 80    	cmp    %ebx,0x80111ba4
80102704:	74 3a                	je     80102740 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102706:	8b 03                	mov    (%ebx),%eax
80102708:	83 e0 06             	and    $0x6,%eax
8010270b:	83 f8 02             	cmp    $0x2,%eax
8010270e:	74 1b                	je     8010272b <iderw+0x9b>
    sleep(b, &idelock);
80102710:	83 ec 08             	sub    $0x8,%esp
80102713:	68 c0 1b 11 80       	push   $0x80111bc0
80102718:	53                   	push   %ebx
80102719:	e8 d2 1c 00 00       	call   801043f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010271e:	8b 03                	mov    (%ebx),%eax
80102720:	83 c4 10             	add    $0x10,%esp
80102723:	83 e0 06             	and    $0x6,%eax
80102726:	83 f8 02             	cmp    $0x2,%eax
80102729:	75 e5                	jne    80102710 <iderw+0x80>
  }


  release(&idelock);
8010272b:	c7 45 08 c0 1b 11 80 	movl   $0x80111bc0,0x8(%ebp)
}
80102732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102735:	c9                   	leave  
  release(&idelock);
80102736:	e9 b5 21 00 00       	jmp    801048f0 <release>
8010273b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010273f:	90                   	nop
    idestart(b);
80102740:	89 d8                	mov    %ebx,%eax
80102742:	e8 49 fd ff ff       	call   80102490 <idestart>
80102747:	eb bd                	jmp    80102706 <iderw+0x76>
80102749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102750:	ba a4 1b 11 80       	mov    $0x80111ba4,%edx
80102755:	eb a5                	jmp    801026fc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102757:	83 ec 0c             	sub    $0xc,%esp
8010275a:	68 99 77 10 80       	push   $0x80107799
8010275f:	e8 5c dc ff ff       	call   801003c0 <panic>
    panic("iderw: nothing to do");
80102764:	83 ec 0c             	sub    $0xc,%esp
80102767:	68 84 77 10 80       	push   $0x80107784
8010276c:	e8 4f dc ff ff       	call   801003c0 <panic>
    panic("iderw: buf not locked");
80102771:	83 ec 0c             	sub    $0xc,%esp
80102774:	68 6e 77 10 80       	push   $0x8010776e
80102779:	e8 42 dc ff ff       	call   801003c0 <panic>
8010277e:	66 90                	xchg   %ax,%ax

80102780 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102780:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102781:	c7 05 f4 1b 11 80 00 	movl   $0xfec00000,0x80111bf4
80102788:	00 c0 fe 
{
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	56                   	push   %esi
8010278e:	53                   	push   %ebx
  ioapic->reg = reg;
8010278f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102796:	00 00 00 
  return ioapic->data;
80102799:	8b 15 f4 1b 11 80    	mov    0x80111bf4,%edx
8010279f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801027a2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801027a8:	8b 0d f4 1b 11 80    	mov    0x80111bf4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801027ae:	0f b6 15 40 1d 11 80 	movzbl 0x80111d40,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801027b5:	c1 ee 10             	shr    $0x10,%esi
801027b8:	89 f0                	mov    %esi,%eax
801027ba:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801027bd:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801027c0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801027c3:	39 c2                	cmp    %eax,%edx
801027c5:	74 16                	je     801027dd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801027c7:	83 ec 0c             	sub    $0xc,%esp
801027ca:	68 b8 77 10 80       	push   $0x801077b8
801027cf:	e8 0c df ff ff       	call   801006e0 <cprintf>
  ioapic->reg = reg;
801027d4:	8b 0d f4 1b 11 80    	mov    0x80111bf4,%ecx
801027da:	83 c4 10             	add    $0x10,%esp
801027dd:	83 c6 21             	add    $0x21,%esi
{
801027e0:	ba 10 00 00 00       	mov    $0x10,%edx
801027e5:	b8 20 00 00 00       	mov    $0x20,%eax
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801027f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801027f4:	8b 0d f4 1b 11 80    	mov    0x80111bf4,%ecx
  for(i = 0; i <= maxintr; i++){
801027fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102803:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102806:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102809:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010280c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010280e:	8b 0d f4 1b 11 80    	mov    0x80111bf4,%ecx
80102814:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010281b:	39 f0                	cmp    %esi,%eax
8010281d:	75 d1                	jne    801027f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010281f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102822:	5b                   	pop    %ebx
80102823:	5e                   	pop    %esi
80102824:	5d                   	pop    %ebp
80102825:	c3                   	ret    
80102826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102830:	55                   	push   %ebp
  ioapic->reg = reg;
80102831:	8b 0d f4 1b 11 80    	mov    0x80111bf4,%ecx
{
80102837:	89 e5                	mov    %esp,%ebp
80102839:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010283c:	8d 50 20             	lea    0x20(%eax),%edx
8010283f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102843:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102845:	8b 0d f4 1b 11 80    	mov    0x80111bf4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010284b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010284e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102851:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102854:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102856:	a1 f4 1b 11 80       	mov    0x80111bf4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010285b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010285e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102861:	5d                   	pop    %ebp
80102862:	c3                   	ret    
80102863:	66 90                	xchg   %ax,%ax
80102865:	66 90                	xchg   %ax,%ax
80102867:	66 90                	xchg   %ax,%ax
80102869:	66 90                	xchg   %ax,%ax
8010286b:	66 90                	xchg   %ax,%ax
8010286d:	66 90                	xchg   %ax,%ax
8010286f:	90                   	nop

80102870 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	53                   	push   %ebx
80102874:	83 ec 04             	sub    $0x4,%esp
80102877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010287a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102880:	75 76                	jne    801028f8 <kfree+0x88>
80102882:	81 fb 90 5a 11 80    	cmp    $0x80115a90,%ebx
80102888:	72 6e                	jb     801028f8 <kfree+0x88>
8010288a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102890:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102895:	77 61                	ja     801028f8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102897:	83 ec 04             	sub    $0x4,%esp
8010289a:	68 00 10 00 00       	push   $0x1000
8010289f:	6a 01                	push   $0x1
801028a1:	53                   	push   %ebx
801028a2:	e8 69 21 00 00       	call   80104a10 <memset>

  if(kmem.use_lock)
801028a7:	8b 15 34 1c 11 80    	mov    0x80111c34,%edx
801028ad:	83 c4 10             	add    $0x10,%esp
801028b0:	85 d2                	test   %edx,%edx
801028b2:	75 1c                	jne    801028d0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801028b4:	a1 38 1c 11 80       	mov    0x80111c38,%eax
801028b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801028bb:	a1 34 1c 11 80       	mov    0x80111c34,%eax
  kmem.freelist = r;
801028c0:	89 1d 38 1c 11 80    	mov    %ebx,0x80111c38
  if(kmem.use_lock)
801028c6:	85 c0                	test   %eax,%eax
801028c8:	75 1e                	jne    801028e8 <kfree+0x78>
    release(&kmem.lock);
}
801028ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028cd:	c9                   	leave  
801028ce:	c3                   	ret    
801028cf:	90                   	nop
    acquire(&kmem.lock);
801028d0:	83 ec 0c             	sub    $0xc,%esp
801028d3:	68 00 1c 11 80       	push   $0x80111c00
801028d8:	e8 73 20 00 00       	call   80104950 <acquire>
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	eb d2                	jmp    801028b4 <kfree+0x44>
801028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801028e8:	c7 45 08 00 1c 11 80 	movl   $0x80111c00,0x8(%ebp)
}
801028ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028f2:	c9                   	leave  
    release(&kmem.lock);
801028f3:	e9 f8 1f 00 00       	jmp    801048f0 <release>
    panic("kfree");
801028f8:	83 ec 0c             	sub    $0xc,%esp
801028fb:	68 ea 77 10 80       	push   $0x801077ea
80102900:	e8 bb da ff ff       	call   801003c0 <panic>
80102905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102910 <freerange>:
{
80102910:	55                   	push   %ebp
80102911:	89 e5                	mov    %esp,%ebp
80102913:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102914:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102917:	8b 75 0c             	mov    0xc(%ebp),%esi
8010291a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010291b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102921:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102927:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010292d:	39 de                	cmp    %ebx,%esi
8010292f:	72 23                	jb     80102954 <freerange+0x44>
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102938:	83 ec 0c             	sub    $0xc,%esp
8010293b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102941:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102947:	50                   	push   %eax
80102948:	e8 23 ff ff ff       	call   80102870 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010294d:	83 c4 10             	add    $0x10,%esp
80102950:	39 f3                	cmp    %esi,%ebx
80102952:	76 e4                	jbe    80102938 <freerange+0x28>
}
80102954:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102957:	5b                   	pop    %ebx
80102958:	5e                   	pop    %esi
80102959:	5d                   	pop    %ebp
8010295a:	c3                   	ret    
8010295b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop

80102960 <kinit2>:
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102964:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102967:	8b 75 0c             	mov    0xc(%ebp),%esi
8010296a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010296b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102971:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102977:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010297d:	39 de                	cmp    %ebx,%esi
8010297f:	72 23                	jb     801029a4 <kinit2+0x44>
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102988:	83 ec 0c             	sub    $0xc,%esp
8010298b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102991:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102997:	50                   	push   %eax
80102998:	e8 d3 fe ff ff       	call   80102870 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010299d:	83 c4 10             	add    $0x10,%esp
801029a0:	39 de                	cmp    %ebx,%esi
801029a2:	73 e4                	jae    80102988 <kinit2+0x28>
  kmem.use_lock = 1;
801029a4:	c7 05 34 1c 11 80 01 	movl   $0x1,0x80111c34
801029ab:	00 00 00 
}
801029ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029b1:	5b                   	pop    %ebx
801029b2:	5e                   	pop    %esi
801029b3:	5d                   	pop    %ebp
801029b4:	c3                   	ret    
801029b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029c0 <kinit1>:
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	56                   	push   %esi
801029c4:	53                   	push   %ebx
801029c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801029c8:	83 ec 08             	sub    $0x8,%esp
801029cb:	68 f0 77 10 80       	push   $0x801077f0
801029d0:	68 00 1c 11 80       	push   $0x80111c00
801029d5:	e8 a6 1d 00 00       	call   80104780 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801029da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801029e0:	c7 05 34 1c 11 80 00 	movl   $0x0,0x80111c34
801029e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801029ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029fc:	39 de                	cmp    %ebx,%esi
801029fe:	72 1c                	jb     80102a1c <kinit1+0x5c>
    kfree(p);
80102a00:	83 ec 0c             	sub    $0xc,%esp
80102a03:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a0f:	50                   	push   %eax
80102a10:	e8 5b fe ff ff       	call   80102870 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a15:	83 c4 10             	add    $0x10,%esp
80102a18:	39 de                	cmp    %ebx,%esi
80102a1a:	73 e4                	jae    80102a00 <kinit1+0x40>
}
80102a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a1f:	5b                   	pop    %ebx
80102a20:	5e                   	pop    %esi
80102a21:	5d                   	pop    %ebp
80102a22:	c3                   	ret    
80102a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a30 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102a30:	a1 34 1c 11 80       	mov    0x80111c34,%eax
80102a35:	85 c0                	test   %eax,%eax
80102a37:	75 1f                	jne    80102a58 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102a39:	a1 38 1c 11 80       	mov    0x80111c38,%eax
  if(r)
80102a3e:	85 c0                	test   %eax,%eax
80102a40:	74 0e                	je     80102a50 <kalloc+0x20>
    kmem.freelist = r->next;
80102a42:	8b 10                	mov    (%eax),%edx
80102a44:	89 15 38 1c 11 80    	mov    %edx,0x80111c38
  if(kmem.use_lock)
80102a4a:	c3                   	ret    
80102a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a4f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102a50:	c3                   	ret    
80102a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102a58:	55                   	push   %ebp
80102a59:	89 e5                	mov    %esp,%ebp
80102a5b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102a5e:	68 00 1c 11 80       	push   $0x80111c00
80102a63:	e8 e8 1e 00 00       	call   80104950 <acquire>
  r = kmem.freelist;
80102a68:	a1 38 1c 11 80       	mov    0x80111c38,%eax
  if(kmem.use_lock)
80102a6d:	8b 15 34 1c 11 80    	mov    0x80111c34,%edx
  if(r)
80102a73:	83 c4 10             	add    $0x10,%esp
80102a76:	85 c0                	test   %eax,%eax
80102a78:	74 08                	je     80102a82 <kalloc+0x52>
    kmem.freelist = r->next;
80102a7a:	8b 08                	mov    (%eax),%ecx
80102a7c:	89 0d 38 1c 11 80    	mov    %ecx,0x80111c38
  if(kmem.use_lock)
80102a82:	85 d2                	test   %edx,%edx
80102a84:	74 16                	je     80102a9c <kalloc+0x6c>
    release(&kmem.lock);
80102a86:	83 ec 0c             	sub    $0xc,%esp
80102a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a8c:	68 00 1c 11 80       	push   $0x80111c00
80102a91:	e8 5a 1e 00 00       	call   801048f0 <release>
  return (char*)r;
80102a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a99:	83 c4 10             	add    $0x10,%esp
}
80102a9c:	c9                   	leave  
80102a9d:	c3                   	ret    
80102a9e:	66 90                	xchg   %ax,%ax

80102aa0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa0:	ba 64 00 00 00       	mov    $0x64,%edx
80102aa5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102aa6:	a8 01                	test   $0x1,%al
80102aa8:	0f 84 c2 00 00 00    	je     80102b70 <kbdgetc+0xd0>
{
80102aae:	55                   	push   %ebp
80102aaf:	ba 60 00 00 00       	mov    $0x60,%edx
80102ab4:	89 e5                	mov    %esp,%ebp
80102ab6:	53                   	push   %ebx
80102ab7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102ab8:	8b 1d 3c 1c 11 80    	mov    0x80111c3c,%ebx
  data = inb(KBDATAP);
80102abe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102ac1:	3c e0                	cmp    $0xe0,%al
80102ac3:	74 5b                	je     80102b20 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102aca:	84 c0                	test   %al,%al
80102acc:	78 62                	js     80102b30 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ace:	85 d2                	test   %edx,%edx
80102ad0:	74 09                	je     80102adb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ad2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102ad5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102ad8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102adb:	0f b6 91 20 79 10 80 	movzbl -0x7fef86e0(%ecx),%edx
  shift ^= togglecode[data];
80102ae2:	0f b6 81 20 78 10 80 	movzbl -0x7fef87e0(%ecx),%eax
  shift |= shiftcode[data];
80102ae9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102aeb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102aed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102aef:	89 15 3c 1c 11 80    	mov    %edx,0x80111c3c
  c = charcode[shift & (CTL | SHIFT)][data];
80102af5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102af8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102afb:	8b 04 85 00 78 10 80 	mov    -0x7fef8800(,%eax,4),%eax
80102b02:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102b06:	74 0b                	je     80102b13 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102b08:	8d 50 9f             	lea    -0x61(%eax),%edx
80102b0b:	83 fa 19             	cmp    $0x19,%edx
80102b0e:	77 48                	ja     80102b58 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102b10:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102b13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b16:	c9                   	leave  
80102b17:	c3                   	ret    
80102b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1f:	90                   	nop
    shift |= E0ESC;
80102b20:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102b23:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102b25:	89 1d 3c 1c 11 80    	mov    %ebx,0x80111c3c
}
80102b2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b2e:	c9                   	leave  
80102b2f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102b30:	83 e0 7f             	and    $0x7f,%eax
80102b33:	85 d2                	test   %edx,%edx
80102b35:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102b38:	0f b6 81 20 79 10 80 	movzbl -0x7fef86e0(%ecx),%eax
80102b3f:	83 c8 40             	or     $0x40,%eax
80102b42:	0f b6 c0             	movzbl %al,%eax
80102b45:	f7 d0                	not    %eax
80102b47:	21 d8                	and    %ebx,%eax
}
80102b49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102b4c:	a3 3c 1c 11 80       	mov    %eax,0x80111c3c
    return 0;
80102b51:	31 c0                	xor    %eax,%eax
}
80102b53:	c9                   	leave  
80102b54:	c3                   	ret    
80102b55:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102b58:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102b5b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b61:	c9                   	leave  
      c += 'a' - 'A';
80102b62:	83 f9 1a             	cmp    $0x1a,%ecx
80102b65:	0f 42 c2             	cmovb  %edx,%eax
}
80102b68:	c3                   	ret    
80102b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b75:	c3                   	ret    
80102b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <kbdintr>:

void
kbdintr(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b86:	68 a0 2a 10 80       	push   $0x80102aa0
80102b8b:	e8 30 dd ff ff       	call   801008c0 <consoleintr>
}
80102b90:	83 c4 10             	add    $0x10,%esp
80102b93:	c9                   	leave  
80102b94:	c3                   	ret    
80102b95:	66 90                	xchg   %ax,%ax
80102b97:	66 90                	xchg   %ax,%ax
80102b99:	66 90                	xchg   %ax,%ax
80102b9b:	66 90                	xchg   %ax,%ax
80102b9d:	66 90                	xchg   %ax,%ax
80102b9f:	90                   	nop

80102ba0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ba0:	a1 40 1c 11 80       	mov    0x80111c40,%eax
80102ba5:	85 c0                	test   %eax,%eax
80102ba7:	0f 84 cb 00 00 00    	je     80102c78 <lapicinit+0xd8>
  lapic[index] = value;
80102bad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102bb4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102bc1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102bce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102bdb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102bde:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102be1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102be8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102beb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102bf5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102bfb:	8b 50 30             	mov    0x30(%eax),%edx
80102bfe:	c1 ea 10             	shr    $0x10,%edx
80102c01:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102c07:	75 77                	jne    80102c80 <lapicinit+0xe0>
  lapic[index] = value;
80102c09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102c10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c13:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c20:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c2d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102c44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102c51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102c54:	8b 50 20             	mov    0x20(%eax),%edx
80102c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102c60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102c66:	80 e6 10             	and    $0x10,%dh
80102c69:	75 f5                	jne    80102c60 <lapicinit+0xc0>
  lapic[index] = value;
80102c6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c75:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102c80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c8a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102c8d:	e9 77 ff ff ff       	jmp    80102c09 <lapicinit+0x69>
80102c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ca0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ca0:	a1 40 1c 11 80       	mov    0x80111c40,%eax
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	74 07                	je     80102cb0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102ca9:	8b 40 20             	mov    0x20(%eax),%eax
80102cac:	c1 e8 18             	shr    $0x18,%eax
80102caf:	c3                   	ret    
    return 0;
80102cb0:	31 c0                	xor    %eax,%eax
}
80102cb2:	c3                   	ret    
80102cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102cc0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102cc0:	a1 40 1c 11 80       	mov    0x80111c40,%eax
80102cc5:	85 c0                	test   %eax,%eax
80102cc7:	74 0d                	je     80102cd6 <lapiceoi+0x16>
  lapic[index] = value;
80102cc9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cd0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102cd6:	c3                   	ret    
80102cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cde:	66 90                	xchg   %ax,%ax

80102ce0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ce0:	c3                   	ret    
80102ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop

80102cf0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102cf0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102cf6:	ba 70 00 00 00       	mov    $0x70,%edx
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	53                   	push   %ebx
80102cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102d01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d04:	ee                   	out    %al,(%dx)
80102d05:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d0a:	ba 71 00 00 00       	mov    $0x71,%edx
80102d0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102d10:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102d12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102d15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102d1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d1d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102d20:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102d22:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102d28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102d2e:	a1 40 1c 11 80       	mov    0x80111c40,%eax
80102d33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102d43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102d50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d77:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102d7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d7d:	c9                   	leave  
80102d7e:	c3                   	ret    
80102d7f:	90                   	nop

80102d80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d80:	55                   	push   %ebp
80102d81:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d86:	ba 70 00 00 00       	mov    $0x70,%edx
80102d8b:	89 e5                	mov    %esp,%ebp
80102d8d:	57                   	push   %edi
80102d8e:	56                   	push   %esi
80102d8f:	53                   	push   %ebx
80102d90:	83 ec 4c             	sub    $0x4c,%esp
80102d93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d94:	ba 71 00 00 00       	mov    $0x71,%edx
80102d99:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102da2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
80102da8:	31 c0                	xor    %eax,%eax
80102daa:	89 da                	mov    %ebx,%edx
80102dac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dad:	b9 71 00 00 00       	mov    $0x71,%ecx
80102db2:	89 ca                	mov    %ecx,%edx
80102db4:	ec                   	in     (%dx),%al
80102db5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db8:	89 da                	mov    %ebx,%edx
80102dba:	b8 02 00 00 00       	mov    $0x2,%eax
80102dbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dc0:	89 ca                	mov    %ecx,%edx
80102dc2:	ec                   	in     (%dx),%al
80102dc3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc6:	89 da                	mov    %ebx,%edx
80102dc8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dce:	89 ca                	mov    %ecx,%edx
80102dd0:	ec                   	in     (%dx),%al
80102dd1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd4:	89 da                	mov    %ebx,%edx
80102dd6:	b8 07 00 00 00       	mov    $0x7,%eax
80102ddb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ddc:	89 ca                	mov    %ecx,%edx
80102dde:	ec                   	in     (%dx),%al
80102ddf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de2:	89 da                	mov    %ebx,%edx
80102de4:	b8 08 00 00 00       	mov    $0x8,%eax
80102de9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dea:	89 ca                	mov    %ecx,%edx
80102dec:	ec                   	in     (%dx),%al
80102ded:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102def:	89 da                	mov    %ebx,%edx
80102df1:	b8 09 00 00 00       	mov    $0x9,%eax
80102df6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df7:	89 ca                	mov    %ecx,%edx
80102df9:	ec                   	in     (%dx),%al
80102dfa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dfc:	89 da                	mov    %ebx,%edx
80102dfe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e04:	89 ca                	mov    %ecx,%edx
80102e06:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102e07:	84 c0                	test   %al,%al
80102e09:	78 9d                	js     80102da8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102e0b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102e0f:	89 fa                	mov    %edi,%edx
80102e11:	0f b6 fa             	movzbl %dl,%edi
80102e14:	89 f2                	mov    %esi,%edx
80102e16:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102e19:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102e1d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e20:	89 da                	mov    %ebx,%edx
80102e22:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102e25:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102e28:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102e2c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102e2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102e32:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102e36:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102e39:	31 c0                	xor    %eax,%eax
80102e3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e3c:	89 ca                	mov    %ecx,%edx
80102e3e:	ec                   	in     (%dx),%al
80102e3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e42:	89 da                	mov    %ebx,%edx
80102e44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102e47:	b8 02 00 00 00       	mov    $0x2,%eax
80102e4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e4d:	89 ca                	mov    %ecx,%edx
80102e4f:	ec                   	in     (%dx),%al
80102e50:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e53:	89 da                	mov    %ebx,%edx
80102e55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102e58:	b8 04 00 00 00       	mov    $0x4,%eax
80102e5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e5e:	89 ca                	mov    %ecx,%edx
80102e60:	ec                   	in     (%dx),%al
80102e61:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e64:	89 da                	mov    %ebx,%edx
80102e66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e69:	b8 07 00 00 00       	mov    $0x7,%eax
80102e6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6f:	89 ca                	mov    %ecx,%edx
80102e71:	ec                   	in     (%dx),%al
80102e72:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e75:	89 da                	mov    %ebx,%edx
80102e77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e80:	89 ca                	mov    %ecx,%edx
80102e82:	ec                   	in     (%dx),%al
80102e83:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e86:	89 da                	mov    %ebx,%edx
80102e88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e90:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e91:	89 ca                	mov    %ecx,%edx
80102e93:	ec                   	in     (%dx),%al
80102e94:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e97:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e9d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ea0:	6a 18                	push   $0x18
80102ea2:	50                   	push   %eax
80102ea3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ea6:	50                   	push   %eax
80102ea7:	e8 b4 1b 00 00       	call   80104a60 <memcmp>
80102eac:	83 c4 10             	add    $0x10,%esp
80102eaf:	85 c0                	test   %eax,%eax
80102eb1:	0f 85 f1 fe ff ff    	jne    80102da8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102eb7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ebb:	75 78                	jne    80102f35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ebd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ec0:	89 c2                	mov    %eax,%edx
80102ec2:	83 e0 0f             	and    $0xf,%eax
80102ec5:	c1 ea 04             	shr    $0x4,%edx
80102ec8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ecb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ece:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ed1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ed4:	89 c2                	mov    %eax,%edx
80102ed6:	83 e0 0f             	and    $0xf,%eax
80102ed9:	c1 ea 04             	shr    $0x4,%edx
80102edc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102edf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ee2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ee5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ee8:	89 c2                	mov    %eax,%edx
80102eea:	83 e0 0f             	and    $0xf,%eax
80102eed:	c1 ea 04             	shr    $0x4,%edx
80102ef0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ef3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ef6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ef9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102efc:	89 c2                	mov    %eax,%edx
80102efe:	83 e0 0f             	and    $0xf,%eax
80102f01:	c1 ea 04             	shr    $0x4,%edx
80102f04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102f0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f10:	89 c2                	mov    %eax,%edx
80102f12:	83 e0 0f             	and    $0xf,%eax
80102f15:	c1 ea 04             	shr    $0x4,%edx
80102f18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102f21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f24:	89 c2                	mov    %eax,%edx
80102f26:	83 e0 0f             	and    $0xf,%eax
80102f29:	c1 ea 04             	shr    $0x4,%edx
80102f2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102f35:	8b 75 08             	mov    0x8(%ebp),%esi
80102f38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f3b:	89 06                	mov    %eax,(%esi)
80102f3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f40:	89 46 04             	mov    %eax,0x4(%esi)
80102f43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102f46:	89 46 08             	mov    %eax,0x8(%esi)
80102f49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102f4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f52:	89 46 10             	mov    %eax,0x10(%esi)
80102f55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102f5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f65:	5b                   	pop    %ebx
80102f66:	5e                   	pop    %esi
80102f67:	5f                   	pop    %edi
80102f68:	5d                   	pop    %ebp
80102f69:	c3                   	ret    
80102f6a:	66 90                	xchg   %ax,%ax
80102f6c:	66 90                	xchg   %ax,%ax
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f70:	8b 0d a8 1c 11 80    	mov    0x80111ca8,%ecx
80102f76:	85 c9                	test   %ecx,%ecx
80102f78:	0f 8e 8a 00 00 00    	jle    80103008 <install_trans+0x98>
{
80102f7e:	55                   	push   %ebp
80102f7f:	89 e5                	mov    %esp,%ebp
80102f81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102f82:	31 ff                	xor    %edi,%edi
{
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 0c             	sub    $0xc,%esp
80102f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f90:	a1 94 1c 11 80       	mov    0x80111c94,%eax
80102f95:	83 ec 08             	sub    $0x8,%esp
80102f98:	01 f8                	add    %edi,%eax
80102f9a:	83 c0 01             	add    $0x1,%eax
80102f9d:	50                   	push   %eax
80102f9e:	ff 35 a4 1c 11 80    	push   0x80111ca4
80102fa4:	e8 27 d1 ff ff       	call   801000d0 <bread>
80102fa9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fab:	58                   	pop    %eax
80102fac:	5a                   	pop    %edx
80102fad:	ff 34 bd ac 1c 11 80 	push   -0x7feee354(,%edi,4)
80102fb4:	ff 35 a4 1c 11 80    	push   0x80111ca4
  for (tail = 0; tail < log.lh.n; tail++) {
80102fba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fbd:	e8 0e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fc2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fc5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fc7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fca:	68 00 02 00 00       	push   $0x200
80102fcf:	50                   	push   %eax
80102fd0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102fd3:	50                   	push   %eax
80102fd4:	e8 d7 1a 00 00       	call   80104ab0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102fd9:	89 1c 24             	mov    %ebx,(%esp)
80102fdc:	e8 cf d1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102fe1:	89 34 24             	mov    %esi,(%esp)
80102fe4:	e8 07 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102fe9:	89 1c 24             	mov    %ebx,(%esp)
80102fec:	e8 ff d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ff1:	83 c4 10             	add    $0x10,%esp
80102ff4:	39 3d a8 1c 11 80    	cmp    %edi,0x80111ca8
80102ffa:	7f 94                	jg     80102f90 <install_trans+0x20>
  }
}
80102ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fff:	5b                   	pop    %ebx
80103000:	5e                   	pop    %esi
80103001:	5f                   	pop    %edi
80103002:	5d                   	pop    %ebp
80103003:	c3                   	ret    
80103004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103008:	c3                   	ret    
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103010 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103017:	ff 35 94 1c 11 80    	push   0x80111c94
8010301d:	ff 35 a4 1c 11 80    	push   0x80111ca4
80103023:	e8 a8 d0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103028:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010302b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010302d:	a1 a8 1c 11 80       	mov    0x80111ca8,%eax
80103032:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103035:	85 c0                	test   %eax,%eax
80103037:	7e 19                	jle    80103052 <write_head+0x42>
80103039:	31 d2                	xor    %edx,%edx
8010303b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010303f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103040:	8b 0c 95 ac 1c 11 80 	mov    -0x7feee354(,%edx,4),%ecx
80103047:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010304b:	83 c2 01             	add    $0x1,%edx
8010304e:	39 d0                	cmp    %edx,%eax
80103050:	75 ee                	jne    80103040 <write_head+0x30>
  }
  bwrite(buf);
80103052:	83 ec 0c             	sub    $0xc,%esp
80103055:	53                   	push   %ebx
80103056:	e8 55 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010305b:	89 1c 24             	mov    %ebx,(%esp)
8010305e:	e8 8d d1 ff ff       	call   801001f0 <brelse>
}
80103063:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103066:	83 c4 10             	add    $0x10,%esp
80103069:	c9                   	leave  
8010306a:	c3                   	ret    
8010306b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010306f:	90                   	nop

80103070 <initlog>:
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 2c             	sub    $0x2c,%esp
80103077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010307a:	68 20 7a 10 80       	push   $0x80107a20
8010307f:	68 60 1c 11 80       	push   $0x80111c60
80103084:	e8 f7 16 00 00       	call   80104780 <initlock>
  readsb(dev, &sb);
80103089:	58                   	pop    %eax
8010308a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010308d:	5a                   	pop    %edx
8010308e:	50                   	push   %eax
8010308f:	53                   	push   %ebx
80103090:	e8 3b e8 ff ff       	call   801018d0 <readsb>
  log.start = sb.logstart;
80103095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103098:	59                   	pop    %ecx
  log.dev = dev;
80103099:	89 1d a4 1c 11 80    	mov    %ebx,0x80111ca4
  log.size = sb.nlog;
8010309f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801030a2:	a3 94 1c 11 80       	mov    %eax,0x80111c94
  log.size = sb.nlog;
801030a7:	89 15 98 1c 11 80    	mov    %edx,0x80111c98
  struct buf *buf = bread(log.dev, log.start);
801030ad:	5a                   	pop    %edx
801030ae:	50                   	push   %eax
801030af:	53                   	push   %ebx
801030b0:	e8 1b d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801030b5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801030b8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801030bb:	89 1d a8 1c 11 80    	mov    %ebx,0x80111ca8
  for (i = 0; i < log.lh.n; i++) {
801030c1:	85 db                	test   %ebx,%ebx
801030c3:	7e 1d                	jle    801030e2 <initlog+0x72>
801030c5:	31 d2                	xor    %edx,%edx
801030c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ce:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801030d0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801030d4:	89 0c 95 ac 1c 11 80 	mov    %ecx,-0x7feee354(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801030db:	83 c2 01             	add    $0x1,%edx
801030de:	39 d3                	cmp    %edx,%ebx
801030e0:	75 ee                	jne    801030d0 <initlog+0x60>
  brelse(buf);
801030e2:	83 ec 0c             	sub    $0xc,%esp
801030e5:	50                   	push   %eax
801030e6:	e8 05 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801030eb:	e8 80 fe ff ff       	call   80102f70 <install_trans>
  log.lh.n = 0;
801030f0:	c7 05 a8 1c 11 80 00 	movl   $0x0,0x80111ca8
801030f7:	00 00 00 
  write_head(); // clear the log
801030fa:	e8 11 ff ff ff       	call   80103010 <write_head>
}
801030ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103102:	83 c4 10             	add    $0x10,%esp
80103105:	c9                   	leave  
80103106:	c3                   	ret    
80103107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010310e:	66 90                	xchg   %ax,%ax

80103110 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103116:	68 60 1c 11 80       	push   $0x80111c60
8010311b:	e8 30 18 00 00       	call   80104950 <acquire>
80103120:	83 c4 10             	add    $0x10,%esp
80103123:	eb 18                	jmp    8010313d <begin_op+0x2d>
80103125:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103128:	83 ec 08             	sub    $0x8,%esp
8010312b:	68 60 1c 11 80       	push   $0x80111c60
80103130:	68 60 1c 11 80       	push   $0x80111c60
80103135:	e8 b6 12 00 00       	call   801043f0 <sleep>
8010313a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010313d:	a1 a0 1c 11 80       	mov    0x80111ca0,%eax
80103142:	85 c0                	test   %eax,%eax
80103144:	75 e2                	jne    80103128 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103146:	a1 9c 1c 11 80       	mov    0x80111c9c,%eax
8010314b:	8b 15 a8 1c 11 80    	mov    0x80111ca8,%edx
80103151:	83 c0 01             	add    $0x1,%eax
80103154:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103157:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010315a:	83 fa 1e             	cmp    $0x1e,%edx
8010315d:	7f c9                	jg     80103128 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010315f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103162:	a3 9c 1c 11 80       	mov    %eax,0x80111c9c
      release(&log.lock);
80103167:	68 60 1c 11 80       	push   $0x80111c60
8010316c:	e8 7f 17 00 00       	call   801048f0 <release>
      break;
    }
  }
}
80103171:	83 c4 10             	add    $0x10,%esp
80103174:	c9                   	leave  
80103175:	c3                   	ret    
80103176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010317d:	8d 76 00             	lea    0x0(%esi),%esi

80103180 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103189:	68 60 1c 11 80       	push   $0x80111c60
8010318e:	e8 bd 17 00 00       	call   80104950 <acquire>
  log.outstanding -= 1;
80103193:	a1 9c 1c 11 80       	mov    0x80111c9c,%eax
  if(log.committing)
80103198:	8b 35 a0 1c 11 80    	mov    0x80111ca0,%esi
8010319e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801031a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801031a4:	89 1d 9c 1c 11 80    	mov    %ebx,0x80111c9c
  if(log.committing)
801031aa:	85 f6                	test   %esi,%esi
801031ac:	0f 85 22 01 00 00    	jne    801032d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801031b2:	85 db                	test   %ebx,%ebx
801031b4:	0f 85 f6 00 00 00    	jne    801032b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801031ba:	c7 05 a0 1c 11 80 01 	movl   $0x1,0x80111ca0
801031c1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801031c4:	83 ec 0c             	sub    $0xc,%esp
801031c7:	68 60 1c 11 80       	push   $0x80111c60
801031cc:	e8 1f 17 00 00       	call   801048f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801031d1:	8b 0d a8 1c 11 80    	mov    0x80111ca8,%ecx
801031d7:	83 c4 10             	add    $0x10,%esp
801031da:	85 c9                	test   %ecx,%ecx
801031dc:	7f 42                	jg     80103220 <end_op+0xa0>
    acquire(&log.lock);
801031de:	83 ec 0c             	sub    $0xc,%esp
801031e1:	68 60 1c 11 80       	push   $0x80111c60
801031e6:	e8 65 17 00 00       	call   80104950 <acquire>
    wakeup(&log);
801031eb:	c7 04 24 60 1c 11 80 	movl   $0x80111c60,(%esp)
    log.committing = 0;
801031f2:	c7 05 a0 1c 11 80 00 	movl   $0x0,0x80111ca0
801031f9:	00 00 00 
    wakeup(&log);
801031fc:	e8 af 12 00 00       	call   801044b0 <wakeup>
    release(&log.lock);
80103201:	c7 04 24 60 1c 11 80 	movl   $0x80111c60,(%esp)
80103208:	e8 e3 16 00 00       	call   801048f0 <release>
8010320d:	83 c4 10             	add    $0x10,%esp
}
80103210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103213:	5b                   	pop    %ebx
80103214:	5e                   	pop    %esi
80103215:	5f                   	pop    %edi
80103216:	5d                   	pop    %ebp
80103217:	c3                   	ret    
80103218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103220:	a1 94 1c 11 80       	mov    0x80111c94,%eax
80103225:	83 ec 08             	sub    $0x8,%esp
80103228:	01 d8                	add    %ebx,%eax
8010322a:	83 c0 01             	add    $0x1,%eax
8010322d:	50                   	push   %eax
8010322e:	ff 35 a4 1c 11 80    	push   0x80111ca4
80103234:	e8 97 ce ff ff       	call   801000d0 <bread>
80103239:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010323b:	58                   	pop    %eax
8010323c:	5a                   	pop    %edx
8010323d:	ff 34 9d ac 1c 11 80 	push   -0x7feee354(,%ebx,4)
80103244:	ff 35 a4 1c 11 80    	push   0x80111ca4
  for (tail = 0; tail < log.lh.n; tail++) {
8010324a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010324d:	e8 7e ce ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103252:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103255:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010325a:	68 00 02 00 00       	push   $0x200
8010325f:	50                   	push   %eax
80103260:	8d 46 5c             	lea    0x5c(%esi),%eax
80103263:	50                   	push   %eax
80103264:	e8 47 18 00 00       	call   80104ab0 <memmove>
    bwrite(to);  // write the log
80103269:	89 34 24             	mov    %esi,(%esp)
8010326c:	e8 3f cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103271:	89 3c 24             	mov    %edi,(%esp)
80103274:	e8 77 cf ff ff       	call   801001f0 <brelse>
    brelse(to);
80103279:	89 34 24             	mov    %esi,(%esp)
8010327c:	e8 6f cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103281:	83 c4 10             	add    $0x10,%esp
80103284:	3b 1d a8 1c 11 80    	cmp    0x80111ca8,%ebx
8010328a:	7c 94                	jl     80103220 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010328c:	e8 7f fd ff ff       	call   80103010 <write_head>
    install_trans(); // Now install writes to home locations
80103291:	e8 da fc ff ff       	call   80102f70 <install_trans>
    log.lh.n = 0;
80103296:	c7 05 a8 1c 11 80 00 	movl   $0x0,0x80111ca8
8010329d:	00 00 00 
    write_head();    // Erase the transaction from the log
801032a0:	e8 6b fd ff ff       	call   80103010 <write_head>
801032a5:	e9 34 ff ff ff       	jmp    801031de <end_op+0x5e>
801032aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801032b0:	83 ec 0c             	sub    $0xc,%esp
801032b3:	68 60 1c 11 80       	push   $0x80111c60
801032b8:	e8 f3 11 00 00       	call   801044b0 <wakeup>
  release(&log.lock);
801032bd:	c7 04 24 60 1c 11 80 	movl   $0x80111c60,(%esp)
801032c4:	e8 27 16 00 00       	call   801048f0 <release>
801032c9:	83 c4 10             	add    $0x10,%esp
}
801032cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032cf:	5b                   	pop    %ebx
801032d0:	5e                   	pop    %esi
801032d1:	5f                   	pop    %edi
801032d2:	5d                   	pop    %ebp
801032d3:	c3                   	ret    
    panic("log.committing");
801032d4:	83 ec 0c             	sub    $0xc,%esp
801032d7:	68 24 7a 10 80       	push   $0x80107a24
801032dc:	e8 df d0 ff ff       	call   801003c0 <panic>
801032e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop

801032f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	53                   	push   %ebx
801032f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032f7:	8b 15 a8 1c 11 80    	mov    0x80111ca8,%edx
{
801032fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103300:	83 fa 1d             	cmp    $0x1d,%edx
80103303:	0f 8f 85 00 00 00    	jg     8010338e <log_write+0x9e>
80103309:	a1 98 1c 11 80       	mov    0x80111c98,%eax
8010330e:	83 e8 01             	sub    $0x1,%eax
80103311:	39 c2                	cmp    %eax,%edx
80103313:	7d 79                	jge    8010338e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103315:	a1 9c 1c 11 80       	mov    0x80111c9c,%eax
8010331a:	85 c0                	test   %eax,%eax
8010331c:	7e 7d                	jle    8010339b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010331e:	83 ec 0c             	sub    $0xc,%esp
80103321:	68 60 1c 11 80       	push   $0x80111c60
80103326:	e8 25 16 00 00       	call   80104950 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010332b:	8b 15 a8 1c 11 80    	mov    0x80111ca8,%edx
80103331:	83 c4 10             	add    $0x10,%esp
80103334:	85 d2                	test   %edx,%edx
80103336:	7e 4a                	jle    80103382 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103338:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010333b:	31 c0                	xor    %eax,%eax
8010333d:	eb 08                	jmp    80103347 <log_write+0x57>
8010333f:	90                   	nop
80103340:	83 c0 01             	add    $0x1,%eax
80103343:	39 c2                	cmp    %eax,%edx
80103345:	74 29                	je     80103370 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103347:	39 0c 85 ac 1c 11 80 	cmp    %ecx,-0x7feee354(,%eax,4)
8010334e:	75 f0                	jne    80103340 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103350:	89 0c 85 ac 1c 11 80 	mov    %ecx,-0x7feee354(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103357:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010335a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010335d:	c7 45 08 60 1c 11 80 	movl   $0x80111c60,0x8(%ebp)
}
80103364:	c9                   	leave  
  release(&log.lock);
80103365:	e9 86 15 00 00       	jmp    801048f0 <release>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103370:	89 0c 95 ac 1c 11 80 	mov    %ecx,-0x7feee354(,%edx,4)
    log.lh.n++;
80103377:	83 c2 01             	add    $0x1,%edx
8010337a:	89 15 a8 1c 11 80    	mov    %edx,0x80111ca8
80103380:	eb d5                	jmp    80103357 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103382:	8b 43 08             	mov    0x8(%ebx),%eax
80103385:	a3 ac 1c 11 80       	mov    %eax,0x80111cac
  if (i == log.lh.n)
8010338a:	75 cb                	jne    80103357 <log_write+0x67>
8010338c:	eb e9                	jmp    80103377 <log_write+0x87>
    panic("too big a transaction");
8010338e:	83 ec 0c             	sub    $0xc,%esp
80103391:	68 33 7a 10 80       	push   $0x80107a33
80103396:	e8 25 d0 ff ff       	call   801003c0 <panic>
    panic("log_write outside of trans");
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	68 49 7a 10 80       	push   $0x80107a49
801033a3:	e8 18 d0 ff ff       	call   801003c0 <panic>
801033a8:	66 90                	xchg   %ax,%ax
801033aa:	66 90                	xchg   %ax,%ax
801033ac:	66 90                	xchg   %ax,%ax
801033ae:	66 90                	xchg   %ax,%ax

801033b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	53                   	push   %ebx
801033b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801033b7:	e8 44 09 00 00       	call   80103d00 <cpuid>
801033bc:	89 c3                	mov    %eax,%ebx
801033be:	e8 3d 09 00 00       	call   80103d00 <cpuid>
801033c3:	83 ec 04             	sub    $0x4,%esp
801033c6:	53                   	push   %ebx
801033c7:	50                   	push   %eax
801033c8:	68 64 7a 10 80       	push   $0x80107a64
801033cd:	e8 0e d3 ff ff       	call   801006e0 <cprintf>
  idtinit();       // load idt register
801033d2:	e8 b9 28 00 00       	call   80105c90 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801033d7:	e8 c4 08 00 00       	call   80103ca0 <mycpu>
801033dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033de:	b8 01 00 00 00       	mov    $0x1,%eax
801033e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801033ea:	e8 f1 0b 00 00       	call   80103fe0 <scheduler>
801033ef:	90                   	nop

801033f0 <mpenter>:
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801033f6:	e8 85 39 00 00       	call   80106d80 <switchkvm>
  seginit();
801033fb:	e8 f0 38 00 00       	call   80106cf0 <seginit>
  lapicinit();
80103400:	e8 9b f7 ff ff       	call   80102ba0 <lapicinit>
  mpmain();
80103405:	e8 a6 ff ff ff       	call   801033b0 <mpmain>
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <main>:
{
80103410:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103414:	83 e4 f0             	and    $0xfffffff0,%esp
80103417:	ff 71 fc             	push   -0x4(%ecx)
8010341a:	55                   	push   %ebp
8010341b:	89 e5                	mov    %esp,%ebp
8010341d:	53                   	push   %ebx
8010341e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010341f:	83 ec 08             	sub    $0x8,%esp
80103422:	68 00 00 40 80       	push   $0x80400000
80103427:	68 90 5a 11 80       	push   $0x80115a90
8010342c:	e8 8f f5 ff ff       	call   801029c0 <kinit1>
  kvmalloc();      // kernel page table
80103431:	e8 3a 3e 00 00       	call   80107270 <kvmalloc>
  mpinit();        // detect other processors
80103436:	e8 85 01 00 00       	call   801035c0 <mpinit>
  lapicinit();     // interrupt controller
8010343b:	e8 60 f7 ff ff       	call   80102ba0 <lapicinit>
  seginit();       // segment descriptors
80103440:	e8 ab 38 00 00       	call   80106cf0 <seginit>
  picinit();       // disable pic
80103445:	e8 76 03 00 00       	call   801037c0 <picinit>
  ioapicinit();    // another interrupt controller
8010344a:	e8 31 f3 ff ff       	call   80102780 <ioapicinit>
  consoleinit();   // console hardware
8010344f:	e8 bc d9 ff ff       	call   80100e10 <consoleinit>
  uartinit();      // serial port
80103454:	e8 27 2b 00 00       	call   80105f80 <uartinit>
  pinit();         // process table
80103459:	e8 22 08 00 00       	call   80103c80 <pinit>
  tvinit();        // trap vectors
8010345e:	e8 ad 27 00 00       	call   80105c10 <tvinit>
  binit();         // buffer cache
80103463:	e8 d8 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103468:	e8 53 dd ff ff       	call   801011c0 <fileinit>
  ideinit();       // disk 
8010346d:	e8 fe f0 ff ff       	call   80102570 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103472:	83 c4 0c             	add    $0xc,%esp
80103475:	68 8a 00 00 00       	push   $0x8a
8010347a:	68 8c a4 10 80       	push   $0x8010a48c
8010347f:	68 00 70 00 80       	push   $0x80007000
80103484:	e8 27 16 00 00       	call   80104ab0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103489:	83 c4 10             	add    $0x10,%esp
8010348c:	69 05 44 1d 11 80 b0 	imul   $0xb0,0x80111d44,%eax
80103493:	00 00 00 
80103496:	05 60 1d 11 80       	add    $0x80111d60,%eax
8010349b:	3d 60 1d 11 80       	cmp    $0x80111d60,%eax
801034a0:	76 7e                	jbe    80103520 <main+0x110>
801034a2:	bb 60 1d 11 80       	mov    $0x80111d60,%ebx
801034a7:	eb 20                	jmp    801034c9 <main+0xb9>
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034b0:	69 05 44 1d 11 80 b0 	imul   $0xb0,0x80111d44,%eax
801034b7:	00 00 00 
801034ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801034c0:	05 60 1d 11 80       	add    $0x80111d60,%eax
801034c5:	39 c3                	cmp    %eax,%ebx
801034c7:	73 57                	jae    80103520 <main+0x110>
    if(c == mycpu())  // We've started already.
801034c9:	e8 d2 07 00 00       	call   80103ca0 <mycpu>
801034ce:	39 c3                	cmp    %eax,%ebx
801034d0:	74 de                	je     801034b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801034d2:	e8 59 f5 ff ff       	call   80102a30 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801034d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801034da:	c7 05 f8 6f 00 80 f0 	movl   $0x801033f0,0x80006ff8
801034e1:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034e4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801034eb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801034ee:	05 00 10 00 00       	add    $0x1000,%eax
801034f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801034f8:	0f b6 03             	movzbl (%ebx),%eax
801034fb:	68 00 70 00 00       	push   $0x7000
80103500:	50                   	push   %eax
80103501:	e8 ea f7 ff ff       	call   80102cf0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103506:	83 c4 10             	add    $0x10,%esp
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103510:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103516:	85 c0                	test   %eax,%eax
80103518:	74 f6                	je     80103510 <main+0x100>
8010351a:	eb 94                	jmp    801034b0 <main+0xa0>
8010351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103520:	83 ec 08             	sub    $0x8,%esp
80103523:	68 00 00 00 8e       	push   $0x8e000000
80103528:	68 00 00 40 80       	push   $0x80400000
8010352d:	e8 2e f4 ff ff       	call   80102960 <kinit2>
  userinit();      // first user process
80103532:	e8 19 08 00 00       	call   80103d50 <userinit>
  mpmain();        // finish this processor's setup
80103537:	e8 74 fe ff ff       	call   801033b0 <mpmain>
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103545:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010354b:	53                   	push   %ebx
  e = addr+len;
8010354c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010354f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103552:	39 de                	cmp    %ebx,%esi
80103554:	72 10                	jb     80103566 <mpsearch1+0x26>
80103556:	eb 50                	jmp    801035a8 <mpsearch1+0x68>
80103558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355f:	90                   	nop
80103560:	89 fe                	mov    %edi,%esi
80103562:	39 fb                	cmp    %edi,%ebx
80103564:	76 42                	jbe    801035a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103566:	83 ec 04             	sub    $0x4,%esp
80103569:	8d 7e 10             	lea    0x10(%esi),%edi
8010356c:	6a 04                	push   $0x4
8010356e:	68 78 7a 10 80       	push   $0x80107a78
80103573:	56                   	push   %esi
80103574:	e8 e7 14 00 00       	call   80104a60 <memcmp>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	85 c0                	test   %eax,%eax
8010357e:	75 e0                	jne    80103560 <mpsearch1+0x20>
80103580:	89 f2                	mov    %esi,%edx
80103582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103588:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010358b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010358e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103590:	39 fa                	cmp    %edi,%edx
80103592:	75 f4                	jne    80103588 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103594:	84 c0                	test   %al,%al
80103596:	75 c8                	jne    80103560 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010359b:	89 f0                	mov    %esi,%eax
8010359d:	5b                   	pop    %ebx
8010359e:	5e                   	pop    %esi
8010359f:	5f                   	pop    %edi
801035a0:	5d                   	pop    %ebp
801035a1:	c3                   	ret    
801035a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035ab:	31 f6                	xor    %esi,%esi
}
801035ad:	5b                   	pop    %ebx
801035ae:	89 f0                	mov    %esi,%eax
801035b0:	5e                   	pop    %esi
801035b1:	5f                   	pop    %edi
801035b2:	5d                   	pop    %ebp
801035b3:	c3                   	ret    
801035b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035bf:	90                   	nop

801035c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801035c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801035d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801035d7:	c1 e0 08             	shl    $0x8,%eax
801035da:	09 d0                	or     %edx,%eax
801035dc:	c1 e0 04             	shl    $0x4,%eax
801035df:	75 1b                	jne    801035fc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801035e1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801035e8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801035ef:	c1 e0 08             	shl    $0x8,%eax
801035f2:	09 d0                	or     %edx,%eax
801035f4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801035f7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801035fc:	ba 00 04 00 00       	mov    $0x400,%edx
80103601:	e8 3a ff ff ff       	call   80103540 <mpsearch1>
80103606:	89 c3                	mov    %eax,%ebx
80103608:	85 c0                	test   %eax,%eax
8010360a:	0f 84 40 01 00 00    	je     80103750 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103610:	8b 73 04             	mov    0x4(%ebx),%esi
80103613:	85 f6                	test   %esi,%esi
80103615:	0f 84 25 01 00 00    	je     80103740 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010361b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010361e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103624:	6a 04                	push   $0x4
80103626:	68 7d 7a 10 80       	push   $0x80107a7d
8010362b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010362c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010362f:	e8 2c 14 00 00       	call   80104a60 <memcmp>
80103634:	83 c4 10             	add    $0x10,%esp
80103637:	85 c0                	test   %eax,%eax
80103639:	0f 85 01 01 00 00    	jne    80103740 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010363f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103646:	3c 01                	cmp    $0x1,%al
80103648:	74 08                	je     80103652 <mpinit+0x92>
8010364a:	3c 04                	cmp    $0x4,%al
8010364c:	0f 85 ee 00 00 00    	jne    80103740 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103652:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103659:	66 85 d2             	test   %dx,%dx
8010365c:	74 22                	je     80103680 <mpinit+0xc0>
8010365e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103661:	89 f0                	mov    %esi,%eax
  sum = 0;
80103663:	31 d2                	xor    %edx,%edx
80103665:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103668:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010366f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103672:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103674:	39 c7                	cmp    %eax,%edi
80103676:	75 f0                	jne    80103668 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103678:	84 d2                	test   %dl,%dl
8010367a:	0f 85 c0 00 00 00    	jne    80103740 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103680:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103686:	a3 40 1c 11 80       	mov    %eax,0x80111c40
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010368b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103692:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103698:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010369d:	03 55 e4             	add    -0x1c(%ebp),%edx
801036a0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801036a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036a7:	90                   	nop
801036a8:	39 d0                	cmp    %edx,%eax
801036aa:	73 15                	jae    801036c1 <mpinit+0x101>
    switch(*p){
801036ac:	0f b6 08             	movzbl (%eax),%ecx
801036af:	80 f9 02             	cmp    $0x2,%cl
801036b2:	74 4c                	je     80103700 <mpinit+0x140>
801036b4:	77 3a                	ja     801036f0 <mpinit+0x130>
801036b6:	84 c9                	test   %cl,%cl
801036b8:	74 56                	je     80103710 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801036ba:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801036bd:	39 d0                	cmp    %edx,%eax
801036bf:	72 eb                	jb     801036ac <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801036c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801036c4:	85 f6                	test   %esi,%esi
801036c6:	0f 84 d9 00 00 00    	je     801037a5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801036cc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801036d0:	74 15                	je     801036e7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036d2:	b8 70 00 00 00       	mov    $0x70,%eax
801036d7:	ba 22 00 00 00       	mov    $0x22,%edx
801036dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036dd:	ba 23 00 00 00       	mov    $0x23,%edx
801036e2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801036e3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036e6:	ee                   	out    %al,(%dx)
  }
}
801036e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ea:	5b                   	pop    %ebx
801036eb:	5e                   	pop    %esi
801036ec:	5f                   	pop    %edi
801036ed:	5d                   	pop    %ebp
801036ee:	c3                   	ret    
801036ef:	90                   	nop
    switch(*p){
801036f0:	83 e9 03             	sub    $0x3,%ecx
801036f3:	80 f9 01             	cmp    $0x1,%cl
801036f6:	76 c2                	jbe    801036ba <mpinit+0xfa>
801036f8:	31 f6                	xor    %esi,%esi
801036fa:	eb ac                	jmp    801036a8 <mpinit+0xe8>
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103700:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103704:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103707:	88 0d 40 1d 11 80    	mov    %cl,0x80111d40
      continue;
8010370d:	eb 99                	jmp    801036a8 <mpinit+0xe8>
8010370f:	90                   	nop
      if(ncpu < NCPU) {
80103710:	8b 0d 44 1d 11 80    	mov    0x80111d44,%ecx
80103716:	83 f9 07             	cmp    $0x7,%ecx
80103719:	7f 19                	jg     80103734 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010371b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103721:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103725:	83 c1 01             	add    $0x1,%ecx
80103728:	89 0d 44 1d 11 80    	mov    %ecx,0x80111d44
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010372e:	88 9f 60 1d 11 80    	mov    %bl,-0x7feee2a0(%edi)
      p += sizeof(struct mpproc);
80103734:	83 c0 14             	add    $0x14,%eax
      continue;
80103737:	e9 6c ff ff ff       	jmp    801036a8 <mpinit+0xe8>
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	68 82 7a 10 80       	push   $0x80107a82
80103748:	e8 73 cc ff ff       	call   801003c0 <panic>
8010374d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103750:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103755:	eb 13                	jmp    8010376a <mpinit+0x1aa>
80103757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010375e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103760:	89 f3                	mov    %esi,%ebx
80103762:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103768:	74 d6                	je     80103740 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010376a:	83 ec 04             	sub    $0x4,%esp
8010376d:	8d 73 10             	lea    0x10(%ebx),%esi
80103770:	6a 04                	push   $0x4
80103772:	68 78 7a 10 80       	push   $0x80107a78
80103777:	53                   	push   %ebx
80103778:	e8 e3 12 00 00       	call   80104a60 <memcmp>
8010377d:	83 c4 10             	add    $0x10,%esp
80103780:	85 c0                	test   %eax,%eax
80103782:	75 dc                	jne    80103760 <mpinit+0x1a0>
80103784:	89 da                	mov    %ebx,%edx
80103786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010378d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103790:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103793:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103796:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103798:	39 d6                	cmp    %edx,%esi
8010379a:	75 f4                	jne    80103790 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010379c:	84 c0                	test   %al,%al
8010379e:	75 c0                	jne    80103760 <mpinit+0x1a0>
801037a0:	e9 6b fe ff ff       	jmp    80103610 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801037a5:	83 ec 0c             	sub    $0xc,%esp
801037a8:	68 9c 7a 10 80       	push   $0x80107a9c
801037ad:	e8 0e cc ff ff       	call   801003c0 <panic>
801037b2:	66 90                	xchg   %ax,%ax
801037b4:	66 90                	xchg   %ax,%ax
801037b6:	66 90                	xchg   %ax,%ax
801037b8:	66 90                	xchg   %ax,%ax
801037ba:	66 90                	xchg   %ax,%ax
801037bc:	66 90                	xchg   %ax,%ax
801037be:	66 90                	xchg   %ax,%ax

801037c0 <picinit>:
801037c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037c5:	ba 21 00 00 00       	mov    $0x21,%edx
801037ca:	ee                   	out    %al,(%dx)
801037cb:	ba a1 00 00 00       	mov    $0xa1,%edx
801037d0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801037d1:	c3                   	ret    
801037d2:	66 90                	xchg   %ax,%ax
801037d4:	66 90                	xchg   %ax,%ax
801037d6:	66 90                	xchg   %ax,%ax
801037d8:	66 90                	xchg   %ax,%ax
801037da:	66 90                	xchg   %ax,%ax
801037dc:	66 90                	xchg   %ax,%ax
801037de:	66 90                	xchg   %ax,%ax

801037e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 0c             	sub    $0xc,%esp
801037e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801037ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801037f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801037fb:	e8 e0 d9 ff ff       	call   801011e0 <filealloc>
80103800:	89 03                	mov    %eax,(%ebx)
80103802:	85 c0                	test   %eax,%eax
80103804:	0f 84 a8 00 00 00    	je     801038b2 <pipealloc+0xd2>
8010380a:	e8 d1 d9 ff ff       	call   801011e0 <filealloc>
8010380f:	89 06                	mov    %eax,(%esi)
80103811:	85 c0                	test   %eax,%eax
80103813:	0f 84 87 00 00 00    	je     801038a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103819:	e8 12 f2 ff ff       	call   80102a30 <kalloc>
8010381e:	89 c7                	mov    %eax,%edi
80103820:	85 c0                	test   %eax,%eax
80103822:	0f 84 b0 00 00 00    	je     801038d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103828:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010382f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103832:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103835:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010383c:	00 00 00 
  p->nwrite = 0;
8010383f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103846:	00 00 00 
  p->nread = 0;
80103849:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103850:	00 00 00 
  initlock(&p->lock, "pipe");
80103853:	68 bb 7a 10 80       	push   $0x80107abb
80103858:	50                   	push   %eax
80103859:	e8 22 0f 00 00       	call   80104780 <initlock>
  (*f0)->type = FD_PIPE;
8010385e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103860:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103863:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103869:	8b 03                	mov    (%ebx),%eax
8010386b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010386f:	8b 03                	mov    (%ebx),%eax
80103871:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103875:	8b 03                	mov    (%ebx),%eax
80103877:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010387a:	8b 06                	mov    (%esi),%eax
8010387c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103882:	8b 06                	mov    (%esi),%eax
80103884:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103888:	8b 06                	mov    (%esi),%eax
8010388a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010388e:	8b 06                	mov    (%esi),%eax
80103890:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103893:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103896:	31 c0                	xor    %eax,%eax
}
80103898:	5b                   	pop    %ebx
80103899:	5e                   	pop    %esi
8010389a:	5f                   	pop    %edi
8010389b:	5d                   	pop    %ebp
8010389c:	c3                   	ret    
8010389d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801038a0:	8b 03                	mov    (%ebx),%eax
801038a2:	85 c0                	test   %eax,%eax
801038a4:	74 1e                	je     801038c4 <pipealloc+0xe4>
    fileclose(*f0);
801038a6:	83 ec 0c             	sub    $0xc,%esp
801038a9:	50                   	push   %eax
801038aa:	e8 f1 d9 ff ff       	call   801012a0 <fileclose>
801038af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801038b2:	8b 06                	mov    (%esi),%eax
801038b4:	85 c0                	test   %eax,%eax
801038b6:	74 0c                	je     801038c4 <pipealloc+0xe4>
    fileclose(*f1);
801038b8:	83 ec 0c             	sub    $0xc,%esp
801038bb:	50                   	push   %eax
801038bc:	e8 df d9 ff ff       	call   801012a0 <fileclose>
801038c1:	83 c4 10             	add    $0x10,%esp
}
801038c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801038c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801038cc:	5b                   	pop    %ebx
801038cd:	5e                   	pop    %esi
801038ce:	5f                   	pop    %edi
801038cf:	5d                   	pop    %ebp
801038d0:	c3                   	ret    
801038d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801038d8:	8b 03                	mov    (%ebx),%eax
801038da:	85 c0                	test   %eax,%eax
801038dc:	75 c8                	jne    801038a6 <pipealloc+0xc6>
801038de:	eb d2                	jmp    801038b2 <pipealloc+0xd2>

801038e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
801038e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801038eb:	83 ec 0c             	sub    $0xc,%esp
801038ee:	53                   	push   %ebx
801038ef:	e8 5c 10 00 00       	call   80104950 <acquire>
  if(writable){
801038f4:	83 c4 10             	add    $0x10,%esp
801038f7:	85 f6                	test   %esi,%esi
801038f9:	74 65                	je     80103960 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801038fb:	83 ec 0c             	sub    $0xc,%esp
801038fe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103904:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010390b:	00 00 00 
    wakeup(&p->nread);
8010390e:	50                   	push   %eax
8010390f:	e8 9c 0b 00 00       	call   801044b0 <wakeup>
80103914:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103917:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010391d:	85 d2                	test   %edx,%edx
8010391f:	75 0a                	jne    8010392b <pipeclose+0x4b>
80103921:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103927:	85 c0                	test   %eax,%eax
80103929:	74 15                	je     80103940 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010392b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010392e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103931:	5b                   	pop    %ebx
80103932:	5e                   	pop    %esi
80103933:	5d                   	pop    %ebp
    release(&p->lock);
80103934:	e9 b7 0f 00 00       	jmp    801048f0 <release>
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
80103943:	53                   	push   %ebx
80103944:	e8 a7 0f 00 00       	call   801048f0 <release>
    kfree((char*)p);
80103949:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010394c:	83 c4 10             	add    $0x10,%esp
}
8010394f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103952:	5b                   	pop    %ebx
80103953:	5e                   	pop    %esi
80103954:	5d                   	pop    %ebp
    kfree((char*)p);
80103955:	e9 16 ef ff ff       	jmp    80102870 <kfree>
8010395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103969:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103970:	00 00 00 
    wakeup(&p->nwrite);
80103973:	50                   	push   %eax
80103974:	e8 37 0b 00 00       	call   801044b0 <wakeup>
80103979:	83 c4 10             	add    $0x10,%esp
8010397c:	eb 99                	jmp    80103917 <pipeclose+0x37>
8010397e:	66 90                	xchg   %ax,%ax

80103980 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 28             	sub    $0x28,%esp
80103989:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010398c:	53                   	push   %ebx
8010398d:	e8 be 0f 00 00       	call   80104950 <acquire>
  for(i = 0; i < n; i++){
80103992:	8b 45 10             	mov    0x10(%ebp),%eax
80103995:	83 c4 10             	add    $0x10,%esp
80103998:	85 c0                	test   %eax,%eax
8010399a:	0f 8e c0 00 00 00    	jle    80103a60 <pipewrite+0xe0>
801039a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039a3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801039a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801039af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039b2:	03 45 10             	add    0x10(%ebp),%eax
801039b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039b8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801039be:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039c4:	89 ca                	mov    %ecx,%edx
801039c6:	05 00 02 00 00       	add    $0x200,%eax
801039cb:	39 c1                	cmp    %eax,%ecx
801039cd:	74 3f                	je     80103a0e <pipewrite+0x8e>
801039cf:	eb 67                	jmp    80103a38 <pipewrite+0xb8>
801039d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801039d8:	e8 43 03 00 00       	call   80103d20 <myproc>
801039dd:	8b 48 24             	mov    0x24(%eax),%ecx
801039e0:	85 c9                	test   %ecx,%ecx
801039e2:	75 34                	jne    80103a18 <pipewrite+0x98>
      wakeup(&p->nread);
801039e4:	83 ec 0c             	sub    $0xc,%esp
801039e7:	57                   	push   %edi
801039e8:	e8 c3 0a 00 00       	call   801044b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801039ed:	58                   	pop    %eax
801039ee:	5a                   	pop    %edx
801039ef:	53                   	push   %ebx
801039f0:	56                   	push   %esi
801039f1:	e8 fa 09 00 00       	call   801043f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039f6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801039fc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103a02:	83 c4 10             	add    $0x10,%esp
80103a05:	05 00 02 00 00       	add    $0x200,%eax
80103a0a:	39 c2                	cmp    %eax,%edx
80103a0c:	75 2a                	jne    80103a38 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103a0e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a14:	85 c0                	test   %eax,%eax
80103a16:	75 c0                	jne    801039d8 <pipewrite+0x58>
        release(&p->lock);
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	53                   	push   %ebx
80103a1c:	e8 cf 0e 00 00       	call   801048f0 <release>
        return -1;
80103a21:	83 c4 10             	add    $0x10,%esp
80103a24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a2c:	5b                   	pop    %ebx
80103a2d:	5e                   	pop    %esi
80103a2e:	5f                   	pop    %edi
80103a2f:	5d                   	pop    %ebp
80103a30:	c3                   	ret    
80103a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a38:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103a3b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103a3e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103a44:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103a4a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103a4d:	83 c6 01             	add    $0x1,%esi
80103a50:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a53:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103a57:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103a5a:	0f 85 58 ff ff ff    	jne    801039b8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a69:	50                   	push   %eax
80103a6a:	e8 41 0a 00 00       	call   801044b0 <wakeup>
  release(&p->lock);
80103a6f:	89 1c 24             	mov    %ebx,(%esp)
80103a72:	e8 79 0e 00 00       	call   801048f0 <release>
  return n;
80103a77:	8b 45 10             	mov    0x10(%ebp),%eax
80103a7a:	83 c4 10             	add    $0x10,%esp
80103a7d:	eb aa                	jmp    80103a29 <pipewrite+0xa9>
80103a7f:	90                   	nop

80103a80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	57                   	push   %edi
80103a84:	56                   	push   %esi
80103a85:	53                   	push   %ebx
80103a86:	83 ec 18             	sub    $0x18,%esp
80103a89:	8b 75 08             	mov    0x8(%ebp),%esi
80103a8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a8f:	56                   	push   %esi
80103a90:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a96:	e8 b5 0e 00 00       	call   80104950 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a9b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103aa1:	83 c4 10             	add    $0x10,%esp
80103aa4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103aaa:	74 2f                	je     80103adb <piperead+0x5b>
80103aac:	eb 37                	jmp    80103ae5 <piperead+0x65>
80103aae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103ab0:	e8 6b 02 00 00       	call   80103d20 <myproc>
80103ab5:	8b 48 24             	mov    0x24(%eax),%ecx
80103ab8:	85 c9                	test   %ecx,%ecx
80103aba:	0f 85 80 00 00 00    	jne    80103b40 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ac0:	83 ec 08             	sub    $0x8,%esp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	e8 26 09 00 00       	call   801043f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103aca:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103ad9:	75 0a                	jne    80103ae5 <piperead+0x65>
80103adb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103ae1:	85 c0                	test   %eax,%eax
80103ae3:	75 cb                	jne    80103ab0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ae5:	8b 55 10             	mov    0x10(%ebp),%edx
80103ae8:	31 db                	xor    %ebx,%ebx
80103aea:	85 d2                	test   %edx,%edx
80103aec:	7f 20                	jg     80103b0e <piperead+0x8e>
80103aee:	eb 2c                	jmp    80103b1c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103af0:	8d 48 01             	lea    0x1(%eax),%ecx
80103af3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103af8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103afe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103b03:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b06:	83 c3 01             	add    $0x1,%ebx
80103b09:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103b0c:	74 0e                	je     80103b1c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103b0e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103b14:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103b1a:	75 d4                	jne    80103af0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103b1c:	83 ec 0c             	sub    $0xc,%esp
80103b1f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103b25:	50                   	push   %eax
80103b26:	e8 85 09 00 00       	call   801044b0 <wakeup>
  release(&p->lock);
80103b2b:	89 34 24             	mov    %esi,(%esp)
80103b2e:	e8 bd 0d 00 00       	call   801048f0 <release>
  return i;
80103b33:	83 c4 10             	add    $0x10,%esp
}
80103b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b39:	89 d8                	mov    %ebx,%eax
80103b3b:	5b                   	pop    %ebx
80103b3c:	5e                   	pop    %esi
80103b3d:	5f                   	pop    %edi
80103b3e:	5d                   	pop    %ebp
80103b3f:	c3                   	ret    
      release(&p->lock);
80103b40:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103b43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103b48:	56                   	push   %esi
80103b49:	e8 a2 0d 00 00       	call   801048f0 <release>
      return -1;
80103b4e:	83 c4 10             	add    $0x10,%esp
}
80103b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b54:	89 d8                	mov    %ebx,%eax
80103b56:	5b                   	pop    %ebx
80103b57:	5e                   	pop    %esi
80103b58:	5f                   	pop    %edi
80103b59:	5d                   	pop    %ebp
80103b5a:	c3                   	ret    
80103b5b:	66 90                	xchg   %ax,%ax
80103b5d:	66 90                	xchg   %ax,%ax
80103b5f:	90                   	nop

80103b60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b64:	bb 14 23 11 80       	mov    $0x80112314,%ebx
{
80103b69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103b6c:	68 e0 22 11 80       	push   $0x801122e0
80103b71:	e8 da 0d 00 00       	call   80104950 <acquire>
80103b76:	83 c4 10             	add    $0x10,%esp
80103b79:	eb 10                	jmp    80103b8b <allocproc+0x2b>
80103b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b80:	83 c3 7c             	add    $0x7c,%ebx
80103b83:	81 fb 14 42 11 80    	cmp    $0x80114214,%ebx
80103b89:	74 75                	je     80103c00 <allocproc+0xa0>
    if(p->state == UNUSED)
80103b8b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b8e:	85 c0                	test   %eax,%eax
80103b90:	75 ee                	jne    80103b80 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b92:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103b97:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b9a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103ba1:	89 43 10             	mov    %eax,0x10(%ebx)
80103ba4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103ba7:	68 e0 22 11 80       	push   $0x801122e0
  p->pid = nextpid++;
80103bac:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103bb2:	e8 39 0d 00 00       	call   801048f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103bb7:	e8 74 ee ff ff       	call   80102a30 <kalloc>
80103bbc:	83 c4 10             	add    $0x10,%esp
80103bbf:	89 43 08             	mov    %eax,0x8(%ebx)
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	74 53                	je     80103c19 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103bc6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103bcc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103bcf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103bd4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103bd7:	c7 40 14 02 5c 10 80 	movl   $0x80105c02,0x14(%eax)
  p->context = (struct context*)sp;
80103bde:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103be1:	6a 14                	push   $0x14
80103be3:	6a 00                	push   $0x0
80103be5:	50                   	push   %eax
80103be6:	e8 25 0e 00 00       	call   80104a10 <memset>
  p->context->eip = (uint)forkret;
80103beb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103bee:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103bf1:	c7 40 10 30 3c 10 80 	movl   $0x80103c30,0x10(%eax)
}
80103bf8:	89 d8                	mov    %ebx,%eax
80103bfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bfd:	c9                   	leave  
80103bfe:	c3                   	ret    
80103bff:	90                   	nop
  release(&ptable.lock);
80103c00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103c03:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103c05:	68 e0 22 11 80       	push   $0x801122e0
80103c0a:	e8 e1 0c 00 00       	call   801048f0 <release>
}
80103c0f:	89 d8                	mov    %ebx,%eax
  return 0;
80103c11:	83 c4 10             	add    $0x10,%esp
}
80103c14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c17:	c9                   	leave  
80103c18:	c3                   	ret    
    p->state = UNUSED;
80103c19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103c20:	31 db                	xor    %ebx,%ebx
}
80103c22:	89 d8                	mov    %ebx,%eax
80103c24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c27:	c9                   	leave  
80103c28:	c3                   	ret    
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c36:	68 e0 22 11 80       	push   $0x801122e0
80103c3b:	e8 b0 0c 00 00       	call   801048f0 <release>

  if (first) {
80103c40:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103c45:	83 c4 10             	add    $0x10,%esp
80103c48:	85 c0                	test   %eax,%eax
80103c4a:	75 04                	jne    80103c50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c4c:	c9                   	leave  
80103c4d:	c3                   	ret    
80103c4e:	66 90                	xchg   %ax,%ax
    first = 0;
80103c50:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103c57:	00 00 00 
    iinit(ROOTDEV);
80103c5a:	83 ec 0c             	sub    $0xc,%esp
80103c5d:	6a 01                	push   $0x1
80103c5f:	e8 ac dc ff ff       	call   80101910 <iinit>
    initlog(ROOTDEV);
80103c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c6b:	e8 00 f4 ff ff       	call   80103070 <initlog>
}
80103c70:	83 c4 10             	add    $0x10,%esp
80103c73:	c9                   	leave  
80103c74:	c3                   	ret    
80103c75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c80 <pinit>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c86:	68 c0 7a 10 80       	push   $0x80107ac0
80103c8b:	68 e0 22 11 80       	push   $0x801122e0
80103c90:	e8 eb 0a 00 00       	call   80104780 <initlock>
}
80103c95:	83 c4 10             	add    $0x10,%esp
80103c98:	c9                   	leave  
80103c99:	c3                   	ret    
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ca0 <mycpu>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	56                   	push   %esi
80103ca4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ca5:	9c                   	pushf  
80103ca6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ca7:	f6 c4 02             	test   $0x2,%ah
80103caa:	75 46                	jne    80103cf2 <mycpu+0x52>
  apicid = lapicid();
80103cac:	e8 ef ef ff ff       	call   80102ca0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103cb1:	8b 35 44 1d 11 80    	mov    0x80111d44,%esi
80103cb7:	85 f6                	test   %esi,%esi
80103cb9:	7e 2a                	jle    80103ce5 <mycpu+0x45>
80103cbb:	31 d2                	xor    %edx,%edx
80103cbd:	eb 08                	jmp    80103cc7 <mycpu+0x27>
80103cbf:	90                   	nop
80103cc0:	83 c2 01             	add    $0x1,%edx
80103cc3:	39 f2                	cmp    %esi,%edx
80103cc5:	74 1e                	je     80103ce5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103cc7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103ccd:	0f b6 99 60 1d 11 80 	movzbl -0x7feee2a0(%ecx),%ebx
80103cd4:	39 c3                	cmp    %eax,%ebx
80103cd6:	75 e8                	jne    80103cc0 <mycpu+0x20>
}
80103cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103cdb:	8d 81 60 1d 11 80    	lea    -0x7feee2a0(%ecx),%eax
}
80103ce1:	5b                   	pop    %ebx
80103ce2:	5e                   	pop    %esi
80103ce3:	5d                   	pop    %ebp
80103ce4:	c3                   	ret    
  panic("unknown apicid\n");
80103ce5:	83 ec 0c             	sub    $0xc,%esp
80103ce8:	68 c7 7a 10 80       	push   $0x80107ac7
80103ced:	e8 ce c6 ff ff       	call   801003c0 <panic>
    panic("mycpu called with interrupts enabled\n");
80103cf2:	83 ec 0c             	sub    $0xc,%esp
80103cf5:	68 a4 7b 10 80       	push   $0x80107ba4
80103cfa:	e8 c1 c6 ff ff       	call   801003c0 <panic>
80103cff:	90                   	nop

80103d00 <cpuid>:
cpuid() {
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103d06:	e8 95 ff ff ff       	call   80103ca0 <mycpu>
}
80103d0b:	c9                   	leave  
  return mycpu()-cpus;
80103d0c:	2d 60 1d 11 80       	sub    $0x80111d60,%eax
80103d11:	c1 f8 04             	sar    $0x4,%eax
80103d14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d1a:	c3                   	ret    
80103d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d1f:	90                   	nop

80103d20 <myproc>:
myproc(void) {
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	53                   	push   %ebx
80103d24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d27:	e8 d4 0a 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103d2c:	e8 6f ff ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80103d31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d37:	e8 14 0b 00 00       	call   80104850 <popcli>
}
80103d3c:	89 d8                	mov    %ebx,%eax
80103d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d41:	c9                   	leave  
80103d42:	c3                   	ret    
80103d43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d50 <userinit>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	53                   	push   %ebx
80103d54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d57:	e8 04 fe ff ff       	call   80103b60 <allocproc>
80103d5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d5e:	a3 14 42 11 80       	mov    %eax,0x80114214
  if((p->pgdir = setupkvm()) == 0)
80103d63:	e8 88 34 00 00       	call   801071f0 <setupkvm>
80103d68:	89 43 04             	mov    %eax,0x4(%ebx)
80103d6b:	85 c0                	test   %eax,%eax
80103d6d:	0f 84 bd 00 00 00    	je     80103e30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d73:	83 ec 04             	sub    $0x4,%esp
80103d76:	68 2c 00 00 00       	push   $0x2c
80103d7b:	68 60 a4 10 80       	push   $0x8010a460
80103d80:	50                   	push   %eax
80103d81:	e8 1a 31 00 00       	call   80106ea0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d8f:	6a 4c                	push   $0x4c
80103d91:	6a 00                	push   $0x0
80103d93:	ff 73 18             	push   0x18(%ebx)
80103d96:	e8 75 0c 00 00       	call   80104a10 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103da3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103da6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103dab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103daf:	8b 43 18             	mov    0x18(%ebx),%eax
80103db2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103db6:	8b 43 18             	mov    0x18(%ebx),%eax
80103db9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dbd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103dc1:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dc8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103dcc:	8b 43 18             	mov    0x18(%ebx),%eax
80103dcf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103dd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103dd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103de0:	8b 43 18             	mov    0x18(%ebx),%eax
80103de3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ded:	6a 10                	push   $0x10
80103def:	68 f0 7a 10 80       	push   $0x80107af0
80103df4:	50                   	push   %eax
80103df5:	e8 d6 0d 00 00       	call   80104bd0 <safestrcpy>
  p->cwd = namei("/");
80103dfa:	c7 04 24 f9 7a 10 80 	movl   $0x80107af9,(%esp)
80103e01:	e8 4a e6 ff ff       	call   80102450 <namei>
80103e06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103e09:	c7 04 24 e0 22 11 80 	movl   $0x801122e0,(%esp)
80103e10:	e8 3b 0b 00 00       	call   80104950 <acquire>
  p->state = RUNNABLE;
80103e15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103e1c:	c7 04 24 e0 22 11 80 	movl   $0x801122e0,(%esp)
80103e23:	e8 c8 0a 00 00       	call   801048f0 <release>
}
80103e28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e2b:	83 c4 10             	add    $0x10,%esp
80103e2e:	c9                   	leave  
80103e2f:	c3                   	ret    
    panic("userinit: out of memory?");
80103e30:	83 ec 0c             	sub    $0xc,%esp
80103e33:	68 d7 7a 10 80       	push   $0x80107ad7
80103e38:	e8 83 c5 ff ff       	call   801003c0 <panic>
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi

80103e40 <growproc>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	56                   	push   %esi
80103e44:	53                   	push   %ebx
80103e45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e48:	e8 b3 09 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103e4d:	e8 4e fe ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80103e52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e58:	e8 f3 09 00 00       	call   80104850 <popcli>
  sz = curproc->sz;
80103e5d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e5f:	85 f6                	test   %esi,%esi
80103e61:	7f 1d                	jg     80103e80 <growproc+0x40>
  } else if(n < 0){
80103e63:	75 3b                	jne    80103ea0 <growproc+0x60>
  switchuvm(curproc);
80103e65:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e68:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e6a:	53                   	push   %ebx
80103e6b:	e8 20 2f 00 00       	call   80106d90 <switchuvm>
  return 0;
80103e70:	83 c4 10             	add    $0x10,%esp
80103e73:	31 c0                	xor    %eax,%eax
}
80103e75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e78:	5b                   	pop    %ebx
80103e79:	5e                   	pop    %esi
80103e7a:	5d                   	pop    %ebp
80103e7b:	c3                   	ret    
80103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e80:	83 ec 04             	sub    $0x4,%esp
80103e83:	01 c6                	add    %eax,%esi
80103e85:	56                   	push   %esi
80103e86:	50                   	push   %eax
80103e87:	ff 73 04             	push   0x4(%ebx)
80103e8a:	e8 81 31 00 00       	call   80107010 <allocuvm>
80103e8f:	83 c4 10             	add    $0x10,%esp
80103e92:	85 c0                	test   %eax,%eax
80103e94:	75 cf                	jne    80103e65 <growproc+0x25>
      return -1;
80103e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e9b:	eb d8                	jmp    80103e75 <growproc+0x35>
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ea0:	83 ec 04             	sub    $0x4,%esp
80103ea3:	01 c6                	add    %eax,%esi
80103ea5:	56                   	push   %esi
80103ea6:	50                   	push   %eax
80103ea7:	ff 73 04             	push   0x4(%ebx)
80103eaa:	e8 91 32 00 00       	call   80107140 <deallocuvm>
80103eaf:	83 c4 10             	add    $0x10,%esp
80103eb2:	85 c0                	test   %eax,%eax
80103eb4:	75 af                	jne    80103e65 <growproc+0x25>
80103eb6:	eb de                	jmp    80103e96 <growproc+0x56>
80103eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebf:	90                   	nop

80103ec0 <fork>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ec9:	e8 32 09 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103ece:	e8 cd fd ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80103ed3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ed9:	e8 72 09 00 00       	call   80104850 <popcli>
  if((np = allocproc()) == 0){
80103ede:	e8 7d fc ff ff       	call   80103b60 <allocproc>
80103ee3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ee6:	85 c0                	test   %eax,%eax
80103ee8:	0f 84 b7 00 00 00    	je     80103fa5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103eee:	83 ec 08             	sub    $0x8,%esp
80103ef1:	ff 33                	push   (%ebx)
80103ef3:	89 c7                	mov    %eax,%edi
80103ef5:	ff 73 04             	push   0x4(%ebx)
80103ef8:	e8 e3 33 00 00       	call   801072e0 <copyuvm>
80103efd:	83 c4 10             	add    $0x10,%esp
80103f00:	89 47 04             	mov    %eax,0x4(%edi)
80103f03:	85 c0                	test   %eax,%eax
80103f05:	0f 84 a1 00 00 00    	je     80103fac <fork+0xec>
  np->sz = curproc->sz;
80103f0b:	8b 03                	mov    (%ebx),%eax
80103f0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f10:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103f12:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103f15:	89 c8                	mov    %ecx,%eax
80103f17:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103f1a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f1f:	8b 73 18             	mov    0x18(%ebx),%esi
80103f22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f26:	8b 40 18             	mov    0x18(%eax),%eax
80103f29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103f30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f34:	85 c0                	test   %eax,%eax
80103f36:	74 13                	je     80103f4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f38:	83 ec 0c             	sub    $0xc,%esp
80103f3b:	50                   	push   %eax
80103f3c:	e8 0f d3 ff ff       	call   80101250 <filedup>
80103f41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f44:	83 c4 10             	add    $0x10,%esp
80103f47:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f4b:	83 c6 01             	add    $0x1,%esi
80103f4e:	83 fe 10             	cmp    $0x10,%esi
80103f51:	75 dd                	jne    80103f30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f53:	83 ec 0c             	sub    $0xc,%esp
80103f56:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f59:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f5c:	e8 9f db ff ff       	call   80101b00 <idup>
80103f61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f67:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f6d:	6a 10                	push   $0x10
80103f6f:	53                   	push   %ebx
80103f70:	50                   	push   %eax
80103f71:	e8 5a 0c 00 00       	call   80104bd0 <safestrcpy>
  pid = np->pid;
80103f76:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f79:	c7 04 24 e0 22 11 80 	movl   $0x801122e0,(%esp)
80103f80:	e8 cb 09 00 00       	call   80104950 <acquire>
  np->state = RUNNABLE;
80103f85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f8c:	c7 04 24 e0 22 11 80 	movl   $0x801122e0,(%esp)
80103f93:	e8 58 09 00 00       	call   801048f0 <release>
  return pid;
80103f98:	83 c4 10             	add    $0x10,%esp
}
80103f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f9e:	89 d8                	mov    %ebx,%eax
80103fa0:	5b                   	pop    %ebx
80103fa1:	5e                   	pop    %esi
80103fa2:	5f                   	pop    %edi
80103fa3:	5d                   	pop    %ebp
80103fa4:	c3                   	ret    
    return -1;
80103fa5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103faa:	eb ef                	jmp    80103f9b <fork+0xdb>
    kfree(np->kstack);
80103fac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103faf:	83 ec 0c             	sub    $0xc,%esp
80103fb2:	ff 73 08             	push   0x8(%ebx)
80103fb5:	e8 b6 e8 ff ff       	call   80102870 <kfree>
    np->kstack = 0;
80103fba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103fc1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103fc4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103fcb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fd0:	eb c9                	jmp    80103f9b <fork+0xdb>
80103fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fe0 <scheduler>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103fe9:	e8 b2 fc ff ff       	call   80103ca0 <mycpu>
  c->proc = 0;
80103fee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ff5:	00 00 00 
  struct cpu *c = mycpu();
80103ff8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ffa:	8d 78 04             	lea    0x4(%eax),%edi
80103ffd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104000:	fb                   	sti    
    acquire(&ptable.lock);
80104001:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104004:	bb 14 23 11 80       	mov    $0x80112314,%ebx
    acquire(&ptable.lock);
80104009:	68 e0 22 11 80       	push   $0x801122e0
8010400e:	e8 3d 09 00 00       	call   80104950 <acquire>
80104013:	83 c4 10             	add    $0x10,%esp
80104016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104020:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104024:	75 33                	jne    80104059 <scheduler+0x79>
      switchuvm(p);
80104026:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104029:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010402f:	53                   	push   %ebx
80104030:	e8 5b 2d 00 00       	call   80106d90 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104035:	58                   	pop    %eax
80104036:	5a                   	pop    %edx
80104037:	ff 73 1c             	push   0x1c(%ebx)
8010403a:	57                   	push   %edi
      p->state = RUNNING;
8010403b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104042:	e8 e4 0b 00 00       	call   80104c2b <swtch>
      switchkvm();
80104047:	e8 34 2d 00 00       	call   80106d80 <switchkvm>
      c->proc = 0;
8010404c:	83 c4 10             	add    $0x10,%esp
8010404f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104056:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104059:	83 c3 7c             	add    $0x7c,%ebx
8010405c:	81 fb 14 42 11 80    	cmp    $0x80114214,%ebx
80104062:	75 bc                	jne    80104020 <scheduler+0x40>
    release(&ptable.lock);
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	68 e0 22 11 80       	push   $0x801122e0
8010406c:	e8 7f 08 00 00       	call   801048f0 <release>
    sti();
80104071:	83 c4 10             	add    $0x10,%esp
80104074:	eb 8a                	jmp    80104000 <scheduler+0x20>
80104076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407d:	8d 76 00             	lea    0x0(%esi),%esi

80104080 <sched>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	56                   	push   %esi
80104084:	53                   	push   %ebx
  pushcli();
80104085:	e8 76 07 00 00       	call   80104800 <pushcli>
  c = mycpu();
8010408a:	e8 11 fc ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
8010408f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104095:	e8 b6 07 00 00       	call   80104850 <popcli>
  if(!holding(&ptable.lock))
8010409a:	83 ec 0c             	sub    $0xc,%esp
8010409d:	68 e0 22 11 80       	push   $0x801122e0
801040a2:	e8 09 08 00 00       	call   801048b0 <holding>
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	85 c0                	test   %eax,%eax
801040ac:	74 4f                	je     801040fd <sched+0x7d>
  if(mycpu()->ncli != 1)
801040ae:	e8 ed fb ff ff       	call   80103ca0 <mycpu>
801040b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040ba:	75 68                	jne    80104124 <sched+0xa4>
  if(p->state == RUNNING)
801040bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801040c0:	74 55                	je     80104117 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040c2:	9c                   	pushf  
801040c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040c4:	f6 c4 02             	test   $0x2,%ah
801040c7:	75 41                	jne    8010410a <sched+0x8a>
  intena = mycpu()->intena;
801040c9:	e8 d2 fb ff ff       	call   80103ca0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801040ce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801040d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801040d7:	e8 c4 fb ff ff       	call   80103ca0 <mycpu>
801040dc:	83 ec 08             	sub    $0x8,%esp
801040df:	ff 70 04             	push   0x4(%eax)
801040e2:	53                   	push   %ebx
801040e3:	e8 43 0b 00 00       	call   80104c2b <swtch>
  mycpu()->intena = intena;
801040e8:	e8 b3 fb ff ff       	call   80103ca0 <mycpu>
}
801040ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801040f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801040f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f9:	5b                   	pop    %ebx
801040fa:	5e                   	pop    %esi
801040fb:	5d                   	pop    %ebp
801040fc:	c3                   	ret    
    panic("sched ptable.lock");
801040fd:	83 ec 0c             	sub    $0xc,%esp
80104100:	68 fb 7a 10 80       	push   $0x80107afb
80104105:	e8 b6 c2 ff ff       	call   801003c0 <panic>
    panic("sched interruptible");
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 27 7b 10 80       	push   $0x80107b27
80104112:	e8 a9 c2 ff ff       	call   801003c0 <panic>
    panic("sched running");
80104117:	83 ec 0c             	sub    $0xc,%esp
8010411a:	68 19 7b 10 80       	push   $0x80107b19
8010411f:	e8 9c c2 ff ff       	call   801003c0 <panic>
    panic("sched locks");
80104124:	83 ec 0c             	sub    $0xc,%esp
80104127:	68 0d 7b 10 80       	push   $0x80107b0d
8010412c:	e8 8f c2 ff ff       	call   801003c0 <panic>
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop

80104140 <exit>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	57                   	push   %edi
80104144:	56                   	push   %esi
80104145:	53                   	push   %ebx
80104146:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104149:	e8 d2 fb ff ff       	call   80103d20 <myproc>
  if(curproc == initproc)
8010414e:	39 05 14 42 11 80    	cmp    %eax,0x80114214
80104154:	0f 84 fd 00 00 00    	je     80104257 <exit+0x117>
8010415a:	89 c3                	mov    %eax,%ebx
8010415c:	8d 70 28             	lea    0x28(%eax),%esi
8010415f:	8d 78 68             	lea    0x68(%eax),%edi
80104162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104168:	8b 06                	mov    (%esi),%eax
8010416a:	85 c0                	test   %eax,%eax
8010416c:	74 12                	je     80104180 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010416e:	83 ec 0c             	sub    $0xc,%esp
80104171:	50                   	push   %eax
80104172:	e8 29 d1 ff ff       	call   801012a0 <fileclose>
      curproc->ofile[fd] = 0;
80104177:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010417d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104180:	83 c6 04             	add    $0x4,%esi
80104183:	39 f7                	cmp    %esi,%edi
80104185:	75 e1                	jne    80104168 <exit+0x28>
  begin_op();
80104187:	e8 84 ef ff ff       	call   80103110 <begin_op>
  iput(curproc->cwd);
8010418c:	83 ec 0c             	sub    $0xc,%esp
8010418f:	ff 73 68             	push   0x68(%ebx)
80104192:	e8 c9 da ff ff       	call   80101c60 <iput>
  end_op();
80104197:	e8 e4 ef ff ff       	call   80103180 <end_op>
  curproc->cwd = 0;
8010419c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801041a3:	c7 04 24 e0 22 11 80 	movl   $0x801122e0,(%esp)
801041aa:	e8 a1 07 00 00       	call   80104950 <acquire>
  wakeup1(curproc->parent);
801041af:	8b 53 14             	mov    0x14(%ebx),%edx
801041b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b5:	b8 14 23 11 80       	mov    $0x80112314,%eax
801041ba:	eb 0e                	jmp    801041ca <exit+0x8a>
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041c0:	83 c0 7c             	add    $0x7c,%eax
801041c3:	3d 14 42 11 80       	cmp    $0x80114214,%eax
801041c8:	74 1c                	je     801041e6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801041ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041ce:	75 f0                	jne    801041c0 <exit+0x80>
801041d0:	3b 50 20             	cmp    0x20(%eax),%edx
801041d3:	75 eb                	jne    801041c0 <exit+0x80>
      p->state = RUNNABLE;
801041d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041dc:	83 c0 7c             	add    $0x7c,%eax
801041df:	3d 14 42 11 80       	cmp    $0x80114214,%eax
801041e4:	75 e4                	jne    801041ca <exit+0x8a>
      p->parent = initproc;
801041e6:	8b 0d 14 42 11 80    	mov    0x80114214,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ec:	ba 14 23 11 80       	mov    $0x80112314,%edx
801041f1:	eb 10                	jmp    80104203 <exit+0xc3>
801041f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f7:	90                   	nop
801041f8:	83 c2 7c             	add    $0x7c,%edx
801041fb:	81 fa 14 42 11 80    	cmp    $0x80114214,%edx
80104201:	74 3b                	je     8010423e <exit+0xfe>
    if(p->parent == curproc){
80104203:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104206:	75 f0                	jne    801041f8 <exit+0xb8>
      if(p->state == ZOMBIE)
80104208:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010420c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010420f:	75 e7                	jne    801041f8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104211:	b8 14 23 11 80       	mov    $0x80112314,%eax
80104216:	eb 12                	jmp    8010422a <exit+0xea>
80104218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421f:	90                   	nop
80104220:	83 c0 7c             	add    $0x7c,%eax
80104223:	3d 14 42 11 80       	cmp    $0x80114214,%eax
80104228:	74 ce                	je     801041f8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010422a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010422e:	75 f0                	jne    80104220 <exit+0xe0>
80104230:	3b 48 20             	cmp    0x20(%eax),%ecx
80104233:	75 eb                	jne    80104220 <exit+0xe0>
      p->state = RUNNABLE;
80104235:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010423c:	eb e2                	jmp    80104220 <exit+0xe0>
  curproc->state = ZOMBIE;
8010423e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104245:	e8 36 fe ff ff       	call   80104080 <sched>
  panic("zombie exit");
8010424a:	83 ec 0c             	sub    $0xc,%esp
8010424d:	68 48 7b 10 80       	push   $0x80107b48
80104252:	e8 69 c1 ff ff       	call   801003c0 <panic>
    panic("init exiting");
80104257:	83 ec 0c             	sub    $0xc,%esp
8010425a:	68 3b 7b 10 80       	push   $0x80107b3b
8010425f:	e8 5c c1 ff ff       	call   801003c0 <panic>
80104264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010426f:	90                   	nop

80104270 <wait>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
  pushcli();
80104275:	e8 86 05 00 00       	call   80104800 <pushcli>
  c = mycpu();
8010427a:	e8 21 fa ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
8010427f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104285:	e8 c6 05 00 00       	call   80104850 <popcli>
  acquire(&ptable.lock);
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 e0 22 11 80       	push   $0x801122e0
80104292:	e8 b9 06 00 00       	call   80104950 <acquire>
80104297:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010429a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010429c:	bb 14 23 11 80       	mov    $0x80112314,%ebx
801042a1:	eb 10                	jmp    801042b3 <wait+0x43>
801042a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a7:	90                   	nop
801042a8:	83 c3 7c             	add    $0x7c,%ebx
801042ab:	81 fb 14 42 11 80    	cmp    $0x80114214,%ebx
801042b1:	74 1b                	je     801042ce <wait+0x5e>
      if(p->parent != curproc)
801042b3:	39 73 14             	cmp    %esi,0x14(%ebx)
801042b6:	75 f0                	jne    801042a8 <wait+0x38>
      if(p->state == ZOMBIE){
801042b8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042bc:	74 62                	je     80104320 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042be:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801042c1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c6:	81 fb 14 42 11 80    	cmp    $0x80114214,%ebx
801042cc:	75 e5                	jne    801042b3 <wait+0x43>
    if(!havekids || curproc->killed){
801042ce:	85 c0                	test   %eax,%eax
801042d0:	0f 84 a0 00 00 00    	je     80104376 <wait+0x106>
801042d6:	8b 46 24             	mov    0x24(%esi),%eax
801042d9:	85 c0                	test   %eax,%eax
801042db:	0f 85 95 00 00 00    	jne    80104376 <wait+0x106>
  pushcli();
801042e1:	e8 1a 05 00 00       	call   80104800 <pushcli>
  c = mycpu();
801042e6:	e8 b5 f9 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
801042eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042f1:	e8 5a 05 00 00       	call   80104850 <popcli>
  if(p == 0)
801042f6:	85 db                	test   %ebx,%ebx
801042f8:	0f 84 8f 00 00 00    	je     8010438d <wait+0x11d>
  p->chan = chan;
801042fe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104301:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104308:	e8 73 fd ff ff       	call   80104080 <sched>
  p->chan = 0;
8010430d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104314:	eb 84                	jmp    8010429a <wait+0x2a>
80104316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104320:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104323:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104326:	ff 73 08             	push   0x8(%ebx)
80104329:	e8 42 e5 ff ff       	call   80102870 <kfree>
        p->kstack = 0;
8010432e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104335:	5a                   	pop    %edx
80104336:	ff 73 04             	push   0x4(%ebx)
80104339:	e8 32 2e 00 00       	call   80107170 <freevm>
        p->pid = 0;
8010433e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104345:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010434c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104350:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104357:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010435e:	c7 04 24 e0 22 11 80 	movl   $0x801122e0,(%esp)
80104365:	e8 86 05 00 00       	call   801048f0 <release>
        return pid;
8010436a:	83 c4 10             	add    $0x10,%esp
}
8010436d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104370:	89 f0                	mov    %esi,%eax
80104372:	5b                   	pop    %ebx
80104373:	5e                   	pop    %esi
80104374:	5d                   	pop    %ebp
80104375:	c3                   	ret    
      release(&ptable.lock);
80104376:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104379:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010437e:	68 e0 22 11 80       	push   $0x801122e0
80104383:	e8 68 05 00 00       	call   801048f0 <release>
      return -1;
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	eb e0                	jmp    8010436d <wait+0xfd>
    panic("sleep");
8010438d:	83 ec 0c             	sub    $0xc,%esp
80104390:	68 54 7b 10 80       	push   $0x80107b54
80104395:	e8 26 c0 ff ff       	call   801003c0 <panic>
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043a0 <yield>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801043a7:	68 e0 22 11 80       	push   $0x801122e0
801043ac:	e8 9f 05 00 00       	call   80104950 <acquire>
  pushcli();
801043b1:	e8 4a 04 00 00       	call   80104800 <pushcli>
  c = mycpu();
801043b6:	e8 e5 f8 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
801043bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043c1:	e8 8a 04 00 00       	call   80104850 <popcli>
  myproc()->state = RUNNABLE;
801043c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801043cd:	e8 ae fc ff ff       	call   80104080 <sched>
  release(&ptable.lock);
801043d2:	c7 04 24 e0 22 11 80 	movl   $0x801122e0,(%esp)
801043d9:	e8 12 05 00 00       	call   801048f0 <release>
}
801043de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e1:	83 c4 10             	add    $0x10,%esp
801043e4:	c9                   	leave  
801043e5:	c3                   	ret    
801043e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ed:	8d 76 00             	lea    0x0(%esi),%esi

801043f0 <sleep>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	56                   	push   %esi
801043f5:	53                   	push   %ebx
801043f6:	83 ec 0c             	sub    $0xc,%esp
801043f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043ff:	e8 fc 03 00 00       	call   80104800 <pushcli>
  c = mycpu();
80104404:	e8 97 f8 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80104409:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010440f:	e8 3c 04 00 00       	call   80104850 <popcli>
  if(p == 0)
80104414:	85 db                	test   %ebx,%ebx
80104416:	0f 84 87 00 00 00    	je     801044a3 <sleep+0xb3>
  if(lk == 0)
8010441c:	85 f6                	test   %esi,%esi
8010441e:	74 76                	je     80104496 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104420:	81 fe e0 22 11 80    	cmp    $0x801122e0,%esi
80104426:	74 50                	je     80104478 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 e0 22 11 80       	push   $0x801122e0
80104430:	e8 1b 05 00 00       	call   80104950 <acquire>
    release(lk);
80104435:	89 34 24             	mov    %esi,(%esp)
80104438:	e8 b3 04 00 00       	call   801048f0 <release>
  p->chan = chan;
8010443d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104440:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104447:	e8 34 fc ff ff       	call   80104080 <sched>
  p->chan = 0;
8010444c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104453:	c7 04 24 e0 22 11 80 	movl   $0x801122e0,(%esp)
8010445a:	e8 91 04 00 00       	call   801048f0 <release>
    acquire(lk);
8010445f:	89 75 08             	mov    %esi,0x8(%ebp)
80104462:	83 c4 10             	add    $0x10,%esp
}
80104465:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104468:	5b                   	pop    %ebx
80104469:	5e                   	pop    %esi
8010446a:	5f                   	pop    %edi
8010446b:	5d                   	pop    %ebp
    acquire(lk);
8010446c:	e9 df 04 00 00       	jmp    80104950 <acquire>
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104478:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010447b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104482:	e8 f9 fb ff ff       	call   80104080 <sched>
  p->chan = 0;
80104487:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010448e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104491:	5b                   	pop    %ebx
80104492:	5e                   	pop    %esi
80104493:	5f                   	pop    %edi
80104494:	5d                   	pop    %ebp
80104495:	c3                   	ret    
    panic("sleep without lk");
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	68 5a 7b 10 80       	push   $0x80107b5a
8010449e:	e8 1d bf ff ff       	call   801003c0 <panic>
    panic("sleep");
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 54 7b 10 80       	push   $0x80107b54
801044ab:	e8 10 bf ff ff       	call   801003c0 <panic>

801044b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 10             	sub    $0x10,%esp
801044b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044ba:	68 e0 22 11 80       	push   $0x801122e0
801044bf:	e8 8c 04 00 00       	call   80104950 <acquire>
801044c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044c7:	b8 14 23 11 80       	mov    $0x80112314,%eax
801044cc:	eb 0c                	jmp    801044da <wakeup+0x2a>
801044ce:	66 90                	xchg   %ax,%ax
801044d0:	83 c0 7c             	add    $0x7c,%eax
801044d3:	3d 14 42 11 80       	cmp    $0x80114214,%eax
801044d8:	74 1c                	je     801044f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801044da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044de:	75 f0                	jne    801044d0 <wakeup+0x20>
801044e0:	3b 58 20             	cmp    0x20(%eax),%ebx
801044e3:	75 eb                	jne    801044d0 <wakeup+0x20>
      p->state = RUNNABLE;
801044e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ec:	83 c0 7c             	add    $0x7c,%eax
801044ef:	3d 14 42 11 80       	cmp    $0x80114214,%eax
801044f4:	75 e4                	jne    801044da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801044f6:	c7 45 08 e0 22 11 80 	movl   $0x801122e0,0x8(%ebp)
}
801044fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104500:	c9                   	leave  
  release(&ptable.lock);
80104501:	e9 ea 03 00 00       	jmp    801048f0 <release>
80104506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	53                   	push   %ebx
80104514:	83 ec 10             	sub    $0x10,%esp
80104517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010451a:	68 e0 22 11 80       	push   $0x801122e0
8010451f:	e8 2c 04 00 00       	call   80104950 <acquire>
80104524:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104527:	b8 14 23 11 80       	mov    $0x80112314,%eax
8010452c:	eb 0c                	jmp    8010453a <kill+0x2a>
8010452e:	66 90                	xchg   %ax,%ax
80104530:	83 c0 7c             	add    $0x7c,%eax
80104533:	3d 14 42 11 80       	cmp    $0x80114214,%eax
80104538:	74 36                	je     80104570 <kill+0x60>
    if(p->pid == pid){
8010453a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010453d:	75 f1                	jne    80104530 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010453f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104543:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010454a:	75 07                	jne    80104553 <kill+0x43>
        p->state = RUNNABLE;
8010454c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104553:	83 ec 0c             	sub    $0xc,%esp
80104556:	68 e0 22 11 80       	push   $0x801122e0
8010455b:	e8 90 03 00 00       	call   801048f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104563:	83 c4 10             	add    $0x10,%esp
80104566:	31 c0                	xor    %eax,%eax
}
80104568:	c9                   	leave  
80104569:	c3                   	ret    
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	68 e0 22 11 80       	push   $0x801122e0
80104578:	e8 73 03 00 00       	call   801048f0 <release>
}
8010457d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104580:	83 c4 10             	add    $0x10,%esp
80104583:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104588:	c9                   	leave  
80104589:	c3                   	ret    
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
80104595:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104598:	53                   	push   %ebx
80104599:	bb 80 23 11 80       	mov    $0x80112380,%ebx
8010459e:	83 ec 3c             	sub    $0x3c,%esp
801045a1:	eb 24                	jmp    801045c7 <procdump+0x37>
801045a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	68 d7 7e 10 80       	push   $0x80107ed7
801045b0:	e8 2b c1 ff ff       	call   801006e0 <cprintf>
801045b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b8:	83 c3 7c             	add    $0x7c,%ebx
801045bb:	81 fb 80 42 11 80    	cmp    $0x80114280,%ebx
801045c1:	0f 84 81 00 00 00    	je     80104648 <procdump+0xb8>
    if(p->state == UNUSED)
801045c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801045ca:	85 c0                	test   %eax,%eax
801045cc:	74 ea                	je     801045b8 <procdump+0x28>
      state = "???";
801045ce:	ba 6b 7b 10 80       	mov    $0x80107b6b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045d3:	83 f8 05             	cmp    $0x5,%eax
801045d6:	77 11                	ja     801045e9 <procdump+0x59>
801045d8:	8b 14 85 cc 7b 10 80 	mov    -0x7fef8434(,%eax,4),%edx
      state = "???";
801045df:	b8 6b 7b 10 80       	mov    $0x80107b6b,%eax
801045e4:	85 d2                	test   %edx,%edx
801045e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801045e9:	53                   	push   %ebx
801045ea:	52                   	push   %edx
801045eb:	ff 73 a4             	push   -0x5c(%ebx)
801045ee:	68 6f 7b 10 80       	push   $0x80107b6f
801045f3:	e8 e8 c0 ff ff       	call   801006e0 <cprintf>
    if(p->state == SLEEPING){
801045f8:	83 c4 10             	add    $0x10,%esp
801045fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045ff:	75 a7                	jne    801045a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104601:	83 ec 08             	sub    $0x8,%esp
80104604:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104607:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010460a:	50                   	push   %eax
8010460b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010460e:	8b 40 0c             	mov    0xc(%eax),%eax
80104611:	83 c0 08             	add    $0x8,%eax
80104614:	50                   	push   %eax
80104615:	e8 86 01 00 00       	call   801047a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010461a:	83 c4 10             	add    $0x10,%esp
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
80104620:	8b 17                	mov    (%edi),%edx
80104622:	85 d2                	test   %edx,%edx
80104624:	74 82                	je     801045a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104626:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104629:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010462c:	52                   	push   %edx
8010462d:	68 81 75 10 80       	push   $0x80107581
80104632:	e8 a9 c0 ff ff       	call   801006e0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104637:	83 c4 10             	add    $0x10,%esp
8010463a:	39 fe                	cmp    %edi,%esi
8010463c:	75 e2                	jne    80104620 <procdump+0x90>
8010463e:	e9 65 ff ff ff       	jmp    801045a8 <procdump+0x18>
80104643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104647:	90                   	nop
  }
}
80104648:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010464b:	5b                   	pop    %ebx
8010464c:	5e                   	pop    %esi
8010464d:	5f                   	pop    %edi
8010464e:	5d                   	pop    %ebp
8010464f:	c3                   	ret    

80104650 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	53                   	push   %ebx
80104654:	83 ec 0c             	sub    $0xc,%esp
80104657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010465a:	68 e4 7b 10 80       	push   $0x80107be4
8010465f:	8d 43 04             	lea    0x4(%ebx),%eax
80104662:	50                   	push   %eax
80104663:	e8 18 01 00 00       	call   80104780 <initlock>
  lk->name = name;
80104668:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010466b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104671:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104674:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010467b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010467e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104681:	c9                   	leave  
80104682:	c3                   	ret    
80104683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104690 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104698:	8d 73 04             	lea    0x4(%ebx),%esi
8010469b:	83 ec 0c             	sub    $0xc,%esp
8010469e:	56                   	push   %esi
8010469f:	e8 ac 02 00 00       	call   80104950 <acquire>
  while (lk->locked) {
801046a4:	8b 13                	mov    (%ebx),%edx
801046a6:	83 c4 10             	add    $0x10,%esp
801046a9:	85 d2                	test   %edx,%edx
801046ab:	74 16                	je     801046c3 <acquiresleep+0x33>
801046ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801046b0:	83 ec 08             	sub    $0x8,%esp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	e8 36 fd ff ff       	call   801043f0 <sleep>
  while (lk->locked) {
801046ba:	8b 03                	mov    (%ebx),%eax
801046bc:	83 c4 10             	add    $0x10,%esp
801046bf:	85 c0                	test   %eax,%eax
801046c1:	75 ed                	jne    801046b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801046c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801046c9:	e8 52 f6 ff ff       	call   80103d20 <myproc>
801046ce:	8b 40 10             	mov    0x10(%eax),%eax
801046d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046da:	5b                   	pop    %ebx
801046db:	5e                   	pop    %esi
801046dc:	5d                   	pop    %ebp
  release(&lk->lk);
801046dd:	e9 0e 02 00 00       	jmp    801048f0 <release>
801046e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	56                   	push   %esi
801046f4:	53                   	push   %ebx
801046f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046f8:	8d 73 04             	lea    0x4(%ebx),%esi
801046fb:	83 ec 0c             	sub    $0xc,%esp
801046fe:	56                   	push   %esi
801046ff:	e8 4c 02 00 00       	call   80104950 <acquire>
  lk->locked = 0;
80104704:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010470a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104711:	89 1c 24             	mov    %ebx,(%esp)
80104714:	e8 97 fd ff ff       	call   801044b0 <wakeup>
  release(&lk->lk);
80104719:	89 75 08             	mov    %esi,0x8(%ebp)
8010471c:	83 c4 10             	add    $0x10,%esp
}
8010471f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104722:	5b                   	pop    %ebx
80104723:	5e                   	pop    %esi
80104724:	5d                   	pop    %ebp
  release(&lk->lk);
80104725:	e9 c6 01 00 00       	jmp    801048f0 <release>
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	31 ff                	xor    %edi,%edi
80104736:	56                   	push   %esi
80104737:	53                   	push   %ebx
80104738:	83 ec 18             	sub    $0x18,%esp
8010473b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010473e:	8d 73 04             	lea    0x4(%ebx),%esi
80104741:	56                   	push   %esi
80104742:	e8 09 02 00 00       	call   80104950 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104747:	8b 03                	mov    (%ebx),%eax
80104749:	83 c4 10             	add    $0x10,%esp
8010474c:	85 c0                	test   %eax,%eax
8010474e:	75 18                	jne    80104768 <holdingsleep+0x38>
  release(&lk->lk);
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	56                   	push   %esi
80104754:	e8 97 01 00 00       	call   801048f0 <release>
  return r;
}
80104759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010475c:	89 f8                	mov    %edi,%eax
8010475e:	5b                   	pop    %ebx
8010475f:	5e                   	pop    %esi
80104760:	5f                   	pop    %edi
80104761:	5d                   	pop    %ebp
80104762:	c3                   	ret    
80104763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104767:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104768:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010476b:	e8 b0 f5 ff ff       	call   80103d20 <myproc>
80104770:	39 58 10             	cmp    %ebx,0x10(%eax)
80104773:	0f 94 c0             	sete   %al
80104776:	0f b6 c0             	movzbl %al,%eax
80104779:	89 c7                	mov    %eax,%edi
8010477b:	eb d3                	jmp    80104750 <holdingsleep+0x20>
8010477d:	66 90                	xchg   %ax,%ax
8010477f:	90                   	nop

80104780 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104786:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104789:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010478f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104792:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104799:	5d                   	pop    %ebp
8010479a:	c3                   	ret    
8010479b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop

801047a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047a0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047a1:	31 d2                	xor    %edx,%edx
{
801047a3:	89 e5                	mov    %esp,%ebp
801047a5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801047a6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801047a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801047ac:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801047af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047b0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047bc:	77 1a                	ja     801047d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047be:	8b 58 04             	mov    0x4(%eax),%ebx
801047c1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047c4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047c7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047c9:	83 fa 0a             	cmp    $0xa,%edx
801047cc:	75 e2                	jne    801047b0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d1:	c9                   	leave  
801047d2:	c3                   	ret    
801047d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d7:	90                   	nop
  for(; i < 10; i++)
801047d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801047db:	8d 51 28             	lea    0x28(%ecx),%edx
801047de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047e6:	83 c0 04             	add    $0x4,%eax
801047e9:	39 d0                	cmp    %edx,%eax
801047eb:	75 f3                	jne    801047e0 <getcallerpcs+0x40>
}
801047ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f0:	c9                   	leave  
801047f1:	c3                   	ret    
801047f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 04             	sub    $0x4,%esp
80104807:	9c                   	pushf  
80104808:	5b                   	pop    %ebx
  asm volatile("cli");
80104809:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010480a:	e8 91 f4 ff ff       	call   80103ca0 <mycpu>
8010480f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104815:	85 c0                	test   %eax,%eax
80104817:	74 17                	je     80104830 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104819:	e8 82 f4 ff ff       	call   80103ca0 <mycpu>
8010481e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104828:	c9                   	leave  
80104829:	c3                   	ret    
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104830:	e8 6b f4 ff ff       	call   80103ca0 <mycpu>
80104835:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010483b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104841:	eb d6                	jmp    80104819 <pushcli+0x19>
80104843:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104850 <popcli>:

void
popcli(void)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104856:	9c                   	pushf  
80104857:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104858:	f6 c4 02             	test   $0x2,%ah
8010485b:	75 35                	jne    80104892 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010485d:	e8 3e f4 ff ff       	call   80103ca0 <mycpu>
80104862:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104869:	78 34                	js     8010489f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010486b:	e8 30 f4 ff ff       	call   80103ca0 <mycpu>
80104870:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104876:	85 d2                	test   %edx,%edx
80104878:	74 06                	je     80104880 <popcli+0x30>
    sti();
}
8010487a:	c9                   	leave  
8010487b:	c3                   	ret    
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104880:	e8 1b f4 ff ff       	call   80103ca0 <mycpu>
80104885:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010488b:	85 c0                	test   %eax,%eax
8010488d:	74 eb                	je     8010487a <popcli+0x2a>
  asm volatile("sti");
8010488f:	fb                   	sti    
}
80104890:	c9                   	leave  
80104891:	c3                   	ret    
    panic("popcli - interruptible");
80104892:	83 ec 0c             	sub    $0xc,%esp
80104895:	68 ef 7b 10 80       	push   $0x80107bef
8010489a:	e8 21 bb ff ff       	call   801003c0 <panic>
    panic("popcli");
8010489f:	83 ec 0c             	sub    $0xc,%esp
801048a2:	68 06 7c 10 80       	push   $0x80107c06
801048a7:	e8 14 bb ff ff       	call   801003c0 <panic>
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <holding>:
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 75 08             	mov    0x8(%ebp),%esi
801048b8:	31 db                	xor    %ebx,%ebx
  pushcli();
801048ba:	e8 41 ff ff ff       	call   80104800 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048bf:	8b 06                	mov    (%esi),%eax
801048c1:	85 c0                	test   %eax,%eax
801048c3:	75 0b                	jne    801048d0 <holding+0x20>
  popcli();
801048c5:	e8 86 ff ff ff       	call   80104850 <popcli>
}
801048ca:	89 d8                	mov    %ebx,%eax
801048cc:	5b                   	pop    %ebx
801048cd:	5e                   	pop    %esi
801048ce:	5d                   	pop    %ebp
801048cf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801048d0:	8b 5e 08             	mov    0x8(%esi),%ebx
801048d3:	e8 c8 f3 ff ff       	call   80103ca0 <mycpu>
801048d8:	39 c3                	cmp    %eax,%ebx
801048da:	0f 94 c3             	sete   %bl
  popcli();
801048dd:	e8 6e ff ff ff       	call   80104850 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801048e2:	0f b6 db             	movzbl %bl,%ebx
}
801048e5:	89 d8                	mov    %ebx,%eax
801048e7:	5b                   	pop    %ebx
801048e8:	5e                   	pop    %esi
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop

801048f0 <release>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	53                   	push   %ebx
801048f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048f8:	e8 03 ff ff ff       	call   80104800 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048fd:	8b 03                	mov    (%ebx),%eax
801048ff:	85 c0                	test   %eax,%eax
80104901:	75 15                	jne    80104918 <release+0x28>
  popcli();
80104903:	e8 48 ff ff ff       	call   80104850 <popcli>
    panic("release");
80104908:	83 ec 0c             	sub    $0xc,%esp
8010490b:	68 0d 7c 10 80       	push   $0x80107c0d
80104910:	e8 ab ba ff ff       	call   801003c0 <panic>
80104915:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104918:	8b 73 08             	mov    0x8(%ebx),%esi
8010491b:	e8 80 f3 ff ff       	call   80103ca0 <mycpu>
80104920:	39 c6                	cmp    %eax,%esi
80104922:	75 df                	jne    80104903 <release+0x13>
  popcli();
80104924:	e8 27 ff ff ff       	call   80104850 <popcli>
  lk->pcs[0] = 0;
80104929:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104930:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104937:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010493c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104942:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104945:	5b                   	pop    %ebx
80104946:	5e                   	pop    %esi
80104947:	5d                   	pop    %ebp
  popcli();
80104948:	e9 03 ff ff ff       	jmp    80104850 <popcli>
8010494d:	8d 76 00             	lea    0x0(%esi),%esi

80104950 <acquire>:
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104957:	e8 a4 fe ff ff       	call   80104800 <pushcli>
  if(holding(lk))
8010495c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010495f:	e8 9c fe ff ff       	call   80104800 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104964:	8b 03                	mov    (%ebx),%eax
80104966:	85 c0                	test   %eax,%eax
80104968:	75 7e                	jne    801049e8 <acquire+0x98>
  popcli();
8010496a:	e8 e1 fe ff ff       	call   80104850 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010496f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104978:	8b 55 08             	mov    0x8(%ebp),%edx
8010497b:	89 c8                	mov    %ecx,%eax
8010497d:	f0 87 02             	lock xchg %eax,(%edx)
80104980:	85 c0                	test   %eax,%eax
80104982:	75 f4                	jne    80104978 <acquire+0x28>
  __sync_synchronize();
80104984:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104989:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010498c:	e8 0f f3 ff ff       	call   80103ca0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104991:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104994:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104996:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104999:	31 c0                	xor    %eax,%eax
8010499b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801049a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049ac:	77 1a                	ja     801049c8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801049ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801049b1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801049b5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801049b8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801049ba:	83 f8 0a             	cmp    $0xa,%eax
801049bd:	75 e1                	jne    801049a0 <acquire+0x50>
}
801049bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801049c8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801049cc:	8d 51 34             	lea    0x34(%ecx),%edx
801049cf:	90                   	nop
    pcs[i] = 0;
801049d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049d6:	83 c0 04             	add    $0x4,%eax
801049d9:	39 c2                	cmp    %eax,%edx
801049db:	75 f3                	jne    801049d0 <acquire+0x80>
}
801049dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e0:	c9                   	leave  
801049e1:	c3                   	ret    
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801049e8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801049eb:	e8 b0 f2 ff ff       	call   80103ca0 <mycpu>
801049f0:	39 c3                	cmp    %eax,%ebx
801049f2:	0f 85 72 ff ff ff    	jne    8010496a <acquire+0x1a>
  popcli();
801049f8:	e8 53 fe ff ff       	call   80104850 <popcli>
    panic("acquire");
801049fd:	83 ec 0c             	sub    $0xc,%esp
80104a00:	68 15 7c 10 80       	push   $0x80107c15
80104a05:	e8 b6 b9 ff ff       	call   801003c0 <panic>
80104a0a:	66 90                	xchg   %ax,%ax
80104a0c:	66 90                	xchg   %ax,%ax
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	8b 55 08             	mov    0x8(%ebp),%edx
80104a17:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a1a:	53                   	push   %ebx
80104a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104a1e:	89 d7                	mov    %edx,%edi
80104a20:	09 cf                	or     %ecx,%edi
80104a22:	83 e7 03             	and    $0x3,%edi
80104a25:	75 29                	jne    80104a50 <memset+0x40>
    c &= 0xFF;
80104a27:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a2a:	c1 e0 18             	shl    $0x18,%eax
80104a2d:	89 fb                	mov    %edi,%ebx
80104a2f:	c1 e9 02             	shr    $0x2,%ecx
80104a32:	c1 e3 10             	shl    $0x10,%ebx
80104a35:	09 d8                	or     %ebx,%eax
80104a37:	09 f8                	or     %edi,%eax
80104a39:	c1 e7 08             	shl    $0x8,%edi
80104a3c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a3e:	89 d7                	mov    %edx,%edi
80104a40:	fc                   	cld    
80104a41:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104a43:	5b                   	pop    %ebx
80104a44:	89 d0                	mov    %edx,%eax
80104a46:	5f                   	pop    %edi
80104a47:	5d                   	pop    %ebp
80104a48:	c3                   	ret    
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104a50:	89 d7                	mov    %edx,%edi
80104a52:	fc                   	cld    
80104a53:	f3 aa                	rep stos %al,%es:(%edi)
80104a55:	5b                   	pop    %ebx
80104a56:	89 d0                	mov    %edx,%eax
80104a58:	5f                   	pop    %edi
80104a59:	5d                   	pop    %ebp
80104a5a:	c3                   	ret    
80104a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a5f:	90                   	nop

80104a60 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	8b 75 10             	mov    0x10(%ebp),%esi
80104a67:	8b 55 08             	mov    0x8(%ebp),%edx
80104a6a:	53                   	push   %ebx
80104a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a6e:	85 f6                	test   %esi,%esi
80104a70:	74 2e                	je     80104aa0 <memcmp+0x40>
80104a72:	01 c6                	add    %eax,%esi
80104a74:	eb 14                	jmp    80104a8a <memcmp+0x2a>
80104a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a80:	83 c0 01             	add    $0x1,%eax
80104a83:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a86:	39 f0                	cmp    %esi,%eax
80104a88:	74 16                	je     80104aa0 <memcmp+0x40>
    if(*s1 != *s2)
80104a8a:	0f b6 0a             	movzbl (%edx),%ecx
80104a8d:	0f b6 18             	movzbl (%eax),%ebx
80104a90:	38 d9                	cmp    %bl,%cl
80104a92:	74 ec                	je     80104a80 <memcmp+0x20>
      return *s1 - *s2;
80104a94:	0f b6 c1             	movzbl %cl,%eax
80104a97:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a99:	5b                   	pop    %ebx
80104a9a:	5e                   	pop    %esi
80104a9b:	5d                   	pop    %ebp
80104a9c:	c3                   	ret    
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	5b                   	pop    %ebx
  return 0;
80104aa1:	31 c0                	xor    %eax,%eax
}
80104aa3:	5e                   	pop    %esi
80104aa4:	5d                   	pop    %ebp
80104aa5:	c3                   	ret    
80104aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aad:	8d 76 00             	lea    0x0(%esi),%esi

80104ab0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104aba:	56                   	push   %esi
80104abb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104abe:	39 d6                	cmp    %edx,%esi
80104ac0:	73 26                	jae    80104ae8 <memmove+0x38>
80104ac2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ac5:	39 fa                	cmp    %edi,%edx
80104ac7:	73 1f                	jae    80104ae8 <memmove+0x38>
80104ac9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104acc:	85 c9                	test   %ecx,%ecx
80104ace:	74 0c                	je     80104adc <memmove+0x2c>
      *--d = *--s;
80104ad0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104ad4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104ad7:	83 e8 01             	sub    $0x1,%eax
80104ada:	73 f4                	jae    80104ad0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104adc:	5e                   	pop    %esi
80104add:	89 d0                	mov    %edx,%eax
80104adf:	5f                   	pop    %edi
80104ae0:	5d                   	pop    %ebp
80104ae1:	c3                   	ret    
80104ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104ae8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104aeb:	89 d7                	mov    %edx,%edi
80104aed:	85 c9                	test   %ecx,%ecx
80104aef:	74 eb                	je     80104adc <memmove+0x2c>
80104af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104af8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104af9:	39 c6                	cmp    %eax,%esi
80104afb:	75 fb                	jne    80104af8 <memmove+0x48>
}
80104afd:	5e                   	pop    %esi
80104afe:	89 d0                	mov    %edx,%eax
80104b00:	5f                   	pop    %edi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104b10:	eb 9e                	jmp    80104ab0 <memmove>
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b20 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	8b 75 10             	mov    0x10(%ebp),%esi
80104b27:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b2a:	53                   	push   %ebx
80104b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104b2e:	85 f6                	test   %esi,%esi
80104b30:	74 2e                	je     80104b60 <strncmp+0x40>
80104b32:	01 d6                	add    %edx,%esi
80104b34:	eb 18                	jmp    80104b4e <strncmp+0x2e>
80104b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
80104b40:	38 d8                	cmp    %bl,%al
80104b42:	75 14                	jne    80104b58 <strncmp+0x38>
    n--, p++, q++;
80104b44:	83 c2 01             	add    $0x1,%edx
80104b47:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b4a:	39 f2                	cmp    %esi,%edx
80104b4c:	74 12                	je     80104b60 <strncmp+0x40>
80104b4e:	0f b6 01             	movzbl (%ecx),%eax
80104b51:	0f b6 1a             	movzbl (%edx),%ebx
80104b54:	84 c0                	test   %al,%al
80104b56:	75 e8                	jne    80104b40 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b58:	29 d8                	sub    %ebx,%eax
}
80104b5a:	5b                   	pop    %ebx
80104b5b:	5e                   	pop    %esi
80104b5c:	5d                   	pop    %ebp
80104b5d:	c3                   	ret    
80104b5e:	66 90                	xchg   %ax,%ax
80104b60:	5b                   	pop    %ebx
    return 0;
80104b61:	31 c0                	xor    %eax,%eax
}
80104b63:	5e                   	pop    %esi
80104b64:	5d                   	pop    %ebp
80104b65:	c3                   	ret    
80104b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi

80104b70 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	8b 75 08             	mov    0x8(%ebp),%esi
80104b78:	53                   	push   %ebx
80104b79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b7c:	89 f0                	mov    %esi,%eax
80104b7e:	eb 15                	jmp    80104b95 <strncpy+0x25>
80104b80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b84:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b87:	83 c0 01             	add    $0x1,%eax
80104b8a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104b8e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104b91:	84 d2                	test   %dl,%dl
80104b93:	74 09                	je     80104b9e <strncpy+0x2e>
80104b95:	89 cb                	mov    %ecx,%ebx
80104b97:	83 e9 01             	sub    $0x1,%ecx
80104b9a:	85 db                	test   %ebx,%ebx
80104b9c:	7f e2                	jg     80104b80 <strncpy+0x10>
    ;
  while(n-- > 0)
80104b9e:	89 c2                	mov    %eax,%edx
80104ba0:	85 c9                	test   %ecx,%ecx
80104ba2:	7e 17                	jle    80104bbb <strncpy+0x4b>
80104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ba8:	83 c2 01             	add    $0x1,%edx
80104bab:	89 c1                	mov    %eax,%ecx
80104bad:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104bb1:	29 d1                	sub    %edx,%ecx
80104bb3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104bb7:	85 c9                	test   %ecx,%ecx
80104bb9:	7f ed                	jg     80104ba8 <strncpy+0x38>
  return os;
}
80104bbb:	5b                   	pop    %ebx
80104bbc:	89 f0                	mov    %esi,%eax
80104bbe:	5e                   	pop    %esi
80104bbf:	5f                   	pop    %edi
80104bc0:	5d                   	pop    %ebp
80104bc1:	c3                   	ret    
80104bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bd0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	8b 55 10             	mov    0x10(%ebp),%edx
80104bd7:	8b 75 08             	mov    0x8(%ebp),%esi
80104bda:	53                   	push   %ebx
80104bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104bde:	85 d2                	test   %edx,%edx
80104be0:	7e 25                	jle    80104c07 <safestrcpy+0x37>
80104be2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104be6:	89 f2                	mov    %esi,%edx
80104be8:	eb 16                	jmp    80104c00 <safestrcpy+0x30>
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104bf0:	0f b6 08             	movzbl (%eax),%ecx
80104bf3:	83 c0 01             	add    $0x1,%eax
80104bf6:	83 c2 01             	add    $0x1,%edx
80104bf9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bfc:	84 c9                	test   %cl,%cl
80104bfe:	74 04                	je     80104c04 <safestrcpy+0x34>
80104c00:	39 d8                	cmp    %ebx,%eax
80104c02:	75 ec                	jne    80104bf0 <safestrcpy+0x20>
    ;
  *s = 0;
80104c04:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104c07:	89 f0                	mov    %esi,%eax
80104c09:	5b                   	pop    %ebx
80104c0a:	5e                   	pop    %esi
80104c0b:	5d                   	pop    %ebp
80104c0c:	c3                   	ret    
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi

80104c10 <strlen>:

int
strlen(const char *s)
{
80104c10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c11:	31 c0                	xor    %eax,%eax
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c18:	80 3a 00             	cmpb   $0x0,(%edx)
80104c1b:	74 0c                	je     80104c29 <strlen+0x19>
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
80104c20:	83 c0 01             	add    $0x1,%eax
80104c23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c27:	75 f7                	jne    80104c20 <strlen+0x10>
    ;
  return n;
}
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    

80104c2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c33:	55                   	push   %ebp
  pushl %ebx
80104c34:	53                   	push   %ebx
  pushl %esi
80104c35:	56                   	push   %esi
  pushl %edi
80104c36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c39:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c3b:	5f                   	pop    %edi
  popl %esi
80104c3c:	5e                   	pop    %esi
  popl %ebx
80104c3d:	5b                   	pop    %ebx
  popl %ebp
80104c3e:	5d                   	pop    %ebp
  ret
80104c3f:	c3                   	ret    

80104c40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	53                   	push   %ebx
80104c44:	83 ec 04             	sub    $0x4,%esp
80104c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c4a:	e8 d1 f0 ff ff       	call   80103d20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c4f:	8b 00                	mov    (%eax),%eax
80104c51:	39 d8                	cmp    %ebx,%eax
80104c53:	76 1b                	jbe    80104c70 <fetchint+0x30>
80104c55:	8d 53 04             	lea    0x4(%ebx),%edx
80104c58:	39 d0                	cmp    %edx,%eax
80104c5a:	72 14                	jb     80104c70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5f:	8b 13                	mov    (%ebx),%edx
80104c61:	89 10                	mov    %edx,(%eax)
  return 0;
80104c63:	31 c0                	xor    %eax,%eax
}
80104c65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c68:	c9                   	leave  
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c75:	eb ee                	jmp    80104c65 <fetchint+0x25>
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 04             	sub    $0x4,%esp
80104c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c8a:	e8 91 f0 ff ff       	call   80103d20 <myproc>

  if(addr >= curproc->sz)
80104c8f:	39 18                	cmp    %ebx,(%eax)
80104c91:	76 2d                	jbe    80104cc0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104c93:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c96:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c98:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c9a:	39 d3                	cmp    %edx,%ebx
80104c9c:	73 22                	jae    80104cc0 <fetchstr+0x40>
80104c9e:	89 d8                	mov    %ebx,%eax
80104ca0:	eb 0d                	jmp    80104caf <fetchstr+0x2f>
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ca8:	83 c0 01             	add    $0x1,%eax
80104cab:	39 c2                	cmp    %eax,%edx
80104cad:	76 11                	jbe    80104cc0 <fetchstr+0x40>
    if(*s == 0)
80104caf:	80 38 00             	cmpb   $0x0,(%eax)
80104cb2:	75 f4                	jne    80104ca8 <fetchstr+0x28>
      return s - *pp;
80104cb4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb9:	c9                   	leave  
80104cba:	c3                   	ret    
80104cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cbf:	90                   	nop
80104cc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cc8:	c9                   	leave  
80104cc9:	c3                   	ret    
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cd5:	e8 46 f0 ff ff       	call   80103d20 <myproc>
80104cda:	8b 55 08             	mov    0x8(%ebp),%edx
80104cdd:	8b 40 18             	mov    0x18(%eax),%eax
80104ce0:	8b 40 44             	mov    0x44(%eax),%eax
80104ce3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ce6:	e8 35 f0 ff ff       	call   80103d20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ceb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cee:	8b 00                	mov    (%eax),%eax
80104cf0:	39 c6                	cmp    %eax,%esi
80104cf2:	73 1c                	jae    80104d10 <argint+0x40>
80104cf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cf7:	39 d0                	cmp    %edx,%eax
80104cf9:	72 15                	jb     80104d10 <argint+0x40>
  *ip = *(int*)(addr);
80104cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cfe:	8b 53 04             	mov    0x4(%ebx),%edx
80104d01:	89 10                	mov    %edx,(%eax)
  return 0;
80104d03:	31 c0                	xor    %eax,%eax
}
80104d05:	5b                   	pop    %ebx
80104d06:	5e                   	pop    %esi
80104d07:	5d                   	pop    %ebp
80104d08:	c3                   	ret    
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d15:	eb ee                	jmp    80104d05 <argint+0x35>
80104d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
80104d25:	53                   	push   %ebx
80104d26:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104d29:	e8 f2 ef ff ff       	call   80103d20 <myproc>
80104d2e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d30:	e8 eb ef ff ff       	call   80103d20 <myproc>
80104d35:	8b 55 08             	mov    0x8(%ebp),%edx
80104d38:	8b 40 18             	mov    0x18(%eax),%eax
80104d3b:	8b 40 44             	mov    0x44(%eax),%eax
80104d3e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d41:	e8 da ef ff ff       	call   80103d20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d46:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d49:	8b 00                	mov    (%eax),%eax
80104d4b:	39 c7                	cmp    %eax,%edi
80104d4d:	73 31                	jae    80104d80 <argptr+0x60>
80104d4f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104d52:	39 c8                	cmp    %ecx,%eax
80104d54:	72 2a                	jb     80104d80 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d56:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104d59:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d5c:	85 d2                	test   %edx,%edx
80104d5e:	78 20                	js     80104d80 <argptr+0x60>
80104d60:	8b 16                	mov    (%esi),%edx
80104d62:	39 c2                	cmp    %eax,%edx
80104d64:	76 1a                	jbe    80104d80 <argptr+0x60>
80104d66:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d69:	01 c3                	add    %eax,%ebx
80104d6b:	39 da                	cmp    %ebx,%edx
80104d6d:	72 11                	jb     80104d80 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d72:	89 02                	mov    %eax,(%edx)
  return 0;
80104d74:	31 c0                	xor    %eax,%eax
}
80104d76:	83 c4 0c             	add    $0xc,%esp
80104d79:	5b                   	pop    %ebx
80104d7a:	5e                   	pop    %esi
80104d7b:	5f                   	pop    %edi
80104d7c:	5d                   	pop    %ebp
80104d7d:	c3                   	ret    
80104d7e:	66 90                	xchg   %ax,%ax
    return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d85:	eb ef                	jmp    80104d76 <argptr+0x56>
80104d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d95:	e8 86 ef ff ff       	call   80103d20 <myproc>
80104d9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d9d:	8b 40 18             	mov    0x18(%eax),%eax
80104da0:	8b 40 44             	mov    0x44(%eax),%eax
80104da3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104da6:	e8 75 ef ff ff       	call   80103d20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dae:	8b 00                	mov    (%eax),%eax
80104db0:	39 c6                	cmp    %eax,%esi
80104db2:	73 44                	jae    80104df8 <argstr+0x68>
80104db4:	8d 53 08             	lea    0x8(%ebx),%edx
80104db7:	39 d0                	cmp    %edx,%eax
80104db9:	72 3d                	jb     80104df8 <argstr+0x68>
  *ip = *(int*)(addr);
80104dbb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104dbe:	e8 5d ef ff ff       	call   80103d20 <myproc>
  if(addr >= curproc->sz)
80104dc3:	3b 18                	cmp    (%eax),%ebx
80104dc5:	73 31                	jae    80104df8 <argstr+0x68>
  *pp = (char*)addr;
80104dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104dcc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104dce:	39 d3                	cmp    %edx,%ebx
80104dd0:	73 26                	jae    80104df8 <argstr+0x68>
80104dd2:	89 d8                	mov    %ebx,%eax
80104dd4:	eb 11                	jmp    80104de7 <argstr+0x57>
80104dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi
80104de0:	83 c0 01             	add    $0x1,%eax
80104de3:	39 c2                	cmp    %eax,%edx
80104de5:	76 11                	jbe    80104df8 <argstr+0x68>
    if(*s == 0)
80104de7:	80 38 00             	cmpb   $0x0,(%eax)
80104dea:	75 f4                	jne    80104de0 <argstr+0x50>
      return s - *pp;
80104dec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104dee:	5b                   	pop    %ebx
80104def:	5e                   	pop    %esi
80104df0:	5d                   	pop    %ebp
80104df1:	c3                   	ret    
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104df8:	5b                   	pop    %ebx
    return -1;
80104df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dfe:	5e                   	pop    %esi
80104dff:	5d                   	pop    %ebp
80104e00:	c3                   	ret    
80104e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0f:	90                   	nop

80104e10 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	53                   	push   %ebx
80104e14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e17:	e8 04 ef ff ff       	call   80103d20 <myproc>
80104e1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e1e:	8b 40 18             	mov    0x18(%eax),%eax
80104e21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e27:	83 fa 14             	cmp    $0x14,%edx
80104e2a:	77 24                	ja     80104e50 <syscall+0x40>
80104e2c:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
80104e33:	85 d2                	test   %edx,%edx
80104e35:	74 19                	je     80104e50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104e37:	ff d2                	call   *%edx
80104e39:	89 c2                	mov    %eax,%edx
80104e3b:	8b 43 18             	mov    0x18(%ebx),%eax
80104e3e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e44:	c9                   	leave  
80104e45:	c3                   	ret    
80104e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e51:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e54:	50                   	push   %eax
80104e55:	ff 73 10             	push   0x10(%ebx)
80104e58:	68 1d 7c 10 80       	push   $0x80107c1d
80104e5d:	e8 7e b8 ff ff       	call   801006e0 <cprintf>
    curproc->tf->eax = -1;
80104e62:	8b 43 18             	mov    0x18(%ebx),%eax
80104e65:	83 c4 10             	add    $0x10,%esp
80104e68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e72:	c9                   	leave  
80104e73:	c3                   	ret    
80104e74:	66 90                	xchg   %ax,%ax
80104e76:	66 90                	xchg   %ax,%ax
80104e78:	66 90                	xchg   %ax,%ax
80104e7a:	66 90                	xchg   %ax,%ax
80104e7c:	66 90                	xchg   %ax,%ax
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e88:	53                   	push   %ebx
80104e89:	83 ec 34             	sub    $0x34,%esp
80104e8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e92:	57                   	push   %edi
80104e93:	50                   	push   %eax
{
80104e94:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e97:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e9a:	e8 d1 d5 ff ff       	call   80102470 <nameiparent>
80104e9f:	83 c4 10             	add    $0x10,%esp
80104ea2:	85 c0                	test   %eax,%eax
80104ea4:	0f 84 46 01 00 00    	je     80104ff0 <create+0x170>
    return 0;
  ilock(dp);
80104eaa:	83 ec 0c             	sub    $0xc,%esp
80104ead:	89 c3                	mov    %eax,%ebx
80104eaf:	50                   	push   %eax
80104eb0:	e8 7b cc ff ff       	call   80101b30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104eb5:	83 c4 0c             	add    $0xc,%esp
80104eb8:	6a 00                	push   $0x0
80104eba:	57                   	push   %edi
80104ebb:	53                   	push   %ebx
80104ebc:	e8 cf d1 ff ff       	call   80102090 <dirlookup>
80104ec1:	83 c4 10             	add    $0x10,%esp
80104ec4:	89 c6                	mov    %eax,%esi
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	74 56                	je     80104f20 <create+0xa0>
    iunlockput(dp);
80104eca:	83 ec 0c             	sub    $0xc,%esp
80104ecd:	53                   	push   %ebx
80104ece:	e8 ed ce ff ff       	call   80101dc0 <iunlockput>
    ilock(ip);
80104ed3:	89 34 24             	mov    %esi,(%esp)
80104ed6:	e8 55 cc ff ff       	call   80101b30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104edb:	83 c4 10             	add    $0x10,%esp
80104ede:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ee3:	75 1b                	jne    80104f00 <create+0x80>
80104ee5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104eea:	75 14                	jne    80104f00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eef:	89 f0                	mov    %esi,%eax
80104ef1:	5b                   	pop    %ebx
80104ef2:	5e                   	pop    %esi
80104ef3:	5f                   	pop    %edi
80104ef4:	5d                   	pop    %ebp
80104ef5:	c3                   	ret    
80104ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104f00:	83 ec 0c             	sub    $0xc,%esp
80104f03:	56                   	push   %esi
    return 0;
80104f04:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104f06:	e8 b5 ce ff ff       	call   80101dc0 <iunlockput>
    return 0;
80104f0b:	83 c4 10             	add    $0x10,%esp
}
80104f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f11:	89 f0                	mov    %esi,%eax
80104f13:	5b                   	pop    %ebx
80104f14:	5e                   	pop    %esi
80104f15:	5f                   	pop    %edi
80104f16:	5d                   	pop    %ebp
80104f17:	c3                   	ret    
80104f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104f20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f24:	83 ec 08             	sub    $0x8,%esp
80104f27:	50                   	push   %eax
80104f28:	ff 33                	push   (%ebx)
80104f2a:	e8 91 ca ff ff       	call   801019c0 <ialloc>
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	89 c6                	mov    %eax,%esi
80104f34:	85 c0                	test   %eax,%eax
80104f36:	0f 84 cd 00 00 00    	je     80105009 <create+0x189>
  ilock(ip);
80104f3c:	83 ec 0c             	sub    $0xc,%esp
80104f3f:	50                   	push   %eax
80104f40:	e8 eb cb ff ff       	call   80101b30 <ilock>
  ip->major = major;
80104f45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f49:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f51:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f55:	b8 01 00 00 00       	mov    $0x1,%eax
80104f5a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f5e:	89 34 24             	mov    %esi,(%esp)
80104f61:	e8 1a cb ff ff       	call   80101a80 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f66:	83 c4 10             	add    $0x10,%esp
80104f69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f6e:	74 30                	je     80104fa0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f70:	83 ec 04             	sub    $0x4,%esp
80104f73:	ff 76 04             	push   0x4(%esi)
80104f76:	57                   	push   %edi
80104f77:	53                   	push   %ebx
80104f78:	e8 13 d4 ff ff       	call   80102390 <dirlink>
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	85 c0                	test   %eax,%eax
80104f82:	78 78                	js     80104ffc <create+0x17c>
  iunlockput(dp);
80104f84:	83 ec 0c             	sub    $0xc,%esp
80104f87:	53                   	push   %ebx
80104f88:	e8 33 ce ff ff       	call   80101dc0 <iunlockput>
  return ip;
80104f8d:	83 c4 10             	add    $0x10,%esp
}
80104f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f93:	89 f0                	mov    %esi,%eax
80104f95:	5b                   	pop    %ebx
80104f96:	5e                   	pop    %esi
80104f97:	5f                   	pop    %edi
80104f98:	5d                   	pop    %ebp
80104f99:	c3                   	ret    
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104fa0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104fa3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fa8:	53                   	push   %ebx
80104fa9:	e8 d2 ca ff ff       	call   80101a80 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fae:	83 c4 0c             	add    $0xc,%esp
80104fb1:	ff 76 04             	push   0x4(%esi)
80104fb4:	68 b4 7c 10 80       	push   $0x80107cb4
80104fb9:	56                   	push   %esi
80104fba:	e8 d1 d3 ff ff       	call   80102390 <dirlink>
80104fbf:	83 c4 10             	add    $0x10,%esp
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	78 18                	js     80104fde <create+0x15e>
80104fc6:	83 ec 04             	sub    $0x4,%esp
80104fc9:	ff 73 04             	push   0x4(%ebx)
80104fcc:	68 b3 7c 10 80       	push   $0x80107cb3
80104fd1:	56                   	push   %esi
80104fd2:	e8 b9 d3 ff ff       	call   80102390 <dirlink>
80104fd7:	83 c4 10             	add    $0x10,%esp
80104fda:	85 c0                	test   %eax,%eax
80104fdc:	79 92                	jns    80104f70 <create+0xf0>
      panic("create dots");
80104fde:	83 ec 0c             	sub    $0xc,%esp
80104fe1:	68 a7 7c 10 80       	push   $0x80107ca7
80104fe6:	e8 d5 b3 ff ff       	call   801003c0 <panic>
80104feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fef:	90                   	nop
}
80104ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ff3:	31 f6                	xor    %esi,%esi
}
80104ff5:	5b                   	pop    %ebx
80104ff6:	89 f0                	mov    %esi,%eax
80104ff8:	5e                   	pop    %esi
80104ff9:	5f                   	pop    %edi
80104ffa:	5d                   	pop    %ebp
80104ffb:	c3                   	ret    
    panic("create: dirlink");
80104ffc:	83 ec 0c             	sub    $0xc,%esp
80104fff:	68 b6 7c 10 80       	push   $0x80107cb6
80105004:	e8 b7 b3 ff ff       	call   801003c0 <panic>
    panic("create: ialloc");
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	68 98 7c 10 80       	push   $0x80107c98
80105011:	e8 aa b3 ff ff       	call   801003c0 <panic>
80105016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501d:	8d 76 00             	lea    0x0(%esi),%esi

80105020 <sys_dup>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	50                   	push   %eax
8010502c:	6a 00                	push   $0x0
8010502e:	e8 9d fc ff ff       	call   80104cd0 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 36                	js     80105070 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 30                	ja     80105070 <sys_dup+0x50>
80105040:	e8 db ec ff ff       	call   80103d20 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010504c:	85 f6                	test   %esi,%esi
8010504e:	74 20                	je     80105070 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105050:	e8 cb ec ff ff       	call   80103d20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105055:	31 db                	xor    %ebx,%ebx
80105057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105060:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105064:	85 d2                	test   %edx,%edx
80105066:	74 18                	je     80105080 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105068:	83 c3 01             	add    $0x1,%ebx
8010506b:	83 fb 10             	cmp    $0x10,%ebx
8010506e:	75 f0                	jne    80105060 <sys_dup+0x40>
}
80105070:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105073:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105078:	89 d8                	mov    %ebx,%eax
8010507a:	5b                   	pop    %ebx
8010507b:	5e                   	pop    %esi
8010507c:	5d                   	pop    %ebp
8010507d:	c3                   	ret    
8010507e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105080:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105083:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105087:	56                   	push   %esi
80105088:	e8 c3 c1 ff ff       	call   80101250 <filedup>
  return fd;
8010508d:	83 c4 10             	add    $0x10,%esp
}
80105090:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105093:	89 d8                	mov    %ebx,%eax
80105095:	5b                   	pop    %ebx
80105096:	5e                   	pop    %esi
80105097:	5d                   	pop    %ebp
80105098:	c3                   	ret    
80105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050a0 <sys_read>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ab:	53                   	push   %ebx
801050ac:	6a 00                	push   $0x0
801050ae:	e8 1d fc ff ff       	call   80104cd0 <argint>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 5e                	js     80105118 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050be:	77 58                	ja     80105118 <sys_read+0x78>
801050c0:	e8 5b ec ff ff       	call   80103d20 <myproc>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050cc:	85 f6                	test   %esi,%esi
801050ce:	74 48                	je     80105118 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050d0:	83 ec 08             	sub    $0x8,%esp
801050d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050d6:	50                   	push   %eax
801050d7:	6a 02                	push   $0x2
801050d9:	e8 f2 fb ff ff       	call   80104cd0 <argint>
801050de:	83 c4 10             	add    $0x10,%esp
801050e1:	85 c0                	test   %eax,%eax
801050e3:	78 33                	js     80105118 <sys_read+0x78>
801050e5:	83 ec 04             	sub    $0x4,%esp
801050e8:	ff 75 f0             	push   -0x10(%ebp)
801050eb:	53                   	push   %ebx
801050ec:	6a 01                	push   $0x1
801050ee:	e8 2d fc ff ff       	call   80104d20 <argptr>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	78 1e                	js     80105118 <sys_read+0x78>
  return fileread(f, p, n);
801050fa:	83 ec 04             	sub    $0x4,%esp
801050fd:	ff 75 f0             	push   -0x10(%ebp)
80105100:	ff 75 f4             	push   -0xc(%ebp)
80105103:	56                   	push   %esi
80105104:	e8 c7 c2 ff ff       	call   801013d0 <fileread>
80105109:	83 c4 10             	add    $0x10,%esp
}
8010510c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010510f:	5b                   	pop    %ebx
80105110:	5e                   	pop    %esi
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret    
80105113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105117:	90                   	nop
    return -1;
80105118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511d:	eb ed                	jmp    8010510c <sys_read+0x6c>
8010511f:	90                   	nop

80105120 <sys_write>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105125:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105128:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010512b:	53                   	push   %ebx
8010512c:	6a 00                	push   $0x0
8010512e:	e8 9d fb ff ff       	call   80104cd0 <argint>
80105133:	83 c4 10             	add    $0x10,%esp
80105136:	85 c0                	test   %eax,%eax
80105138:	78 5e                	js     80105198 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010513a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010513e:	77 58                	ja     80105198 <sys_write+0x78>
80105140:	e8 db eb ff ff       	call   80103d20 <myproc>
80105145:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105148:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010514c:	85 f6                	test   %esi,%esi
8010514e:	74 48                	je     80105198 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105150:	83 ec 08             	sub    $0x8,%esp
80105153:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105156:	50                   	push   %eax
80105157:	6a 02                	push   $0x2
80105159:	e8 72 fb ff ff       	call   80104cd0 <argint>
8010515e:	83 c4 10             	add    $0x10,%esp
80105161:	85 c0                	test   %eax,%eax
80105163:	78 33                	js     80105198 <sys_write+0x78>
80105165:	83 ec 04             	sub    $0x4,%esp
80105168:	ff 75 f0             	push   -0x10(%ebp)
8010516b:	53                   	push   %ebx
8010516c:	6a 01                	push   $0x1
8010516e:	e8 ad fb ff ff       	call   80104d20 <argptr>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	78 1e                	js     80105198 <sys_write+0x78>
  return filewrite(f, p, n);
8010517a:	83 ec 04             	sub    $0x4,%esp
8010517d:	ff 75 f0             	push   -0x10(%ebp)
80105180:	ff 75 f4             	push   -0xc(%ebp)
80105183:	56                   	push   %esi
80105184:	e8 d7 c2 ff ff       	call   80101460 <filewrite>
80105189:	83 c4 10             	add    $0x10,%esp
}
8010518c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010518f:	5b                   	pop    %ebx
80105190:	5e                   	pop    %esi
80105191:	5d                   	pop    %ebp
80105192:	c3                   	ret    
80105193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105197:	90                   	nop
    return -1;
80105198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519d:	eb ed                	jmp    8010518c <sys_write+0x6c>
8010519f:	90                   	nop

801051a0 <sys_close>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051ab:	50                   	push   %eax
801051ac:	6a 00                	push   $0x0
801051ae:	e8 1d fb ff ff       	call   80104cd0 <argint>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	78 3e                	js     801051f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051be:	77 38                	ja     801051f8 <sys_close+0x58>
801051c0:	e8 5b eb ff ff       	call   80103d20 <myproc>
801051c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801051cb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801051cf:	85 f6                	test   %esi,%esi
801051d1:	74 25                	je     801051f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801051d3:	e8 48 eb ff ff       	call   80103d20 <myproc>
  fileclose(f);
801051d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051db:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801051e2:	00 
  fileclose(f);
801051e3:	56                   	push   %esi
801051e4:	e8 b7 c0 ff ff       	call   801012a0 <fileclose>
  return 0;
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	31 c0                	xor    %eax,%eax
}
801051ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f1:	5b                   	pop    %ebx
801051f2:	5e                   	pop    %esi
801051f3:	5d                   	pop    %ebp
801051f4:	c3                   	ret    
801051f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051fd:	eb ef                	jmp    801051ee <sys_close+0x4e>
801051ff:	90                   	nop

80105200 <sys_fstat>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105205:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105208:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010520b:	53                   	push   %ebx
8010520c:	6a 00                	push   $0x0
8010520e:	e8 bd fa ff ff       	call   80104cd0 <argint>
80105213:	83 c4 10             	add    $0x10,%esp
80105216:	85 c0                	test   %eax,%eax
80105218:	78 46                	js     80105260 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010521a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010521e:	77 40                	ja     80105260 <sys_fstat+0x60>
80105220:	e8 fb ea ff ff       	call   80103d20 <myproc>
80105225:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105228:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010522c:	85 f6                	test   %esi,%esi
8010522e:	74 30                	je     80105260 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105230:	83 ec 04             	sub    $0x4,%esp
80105233:	6a 14                	push   $0x14
80105235:	53                   	push   %ebx
80105236:	6a 01                	push   $0x1
80105238:	e8 e3 fa ff ff       	call   80104d20 <argptr>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	85 c0                	test   %eax,%eax
80105242:	78 1c                	js     80105260 <sys_fstat+0x60>
  return filestat(f, st);
80105244:	83 ec 08             	sub    $0x8,%esp
80105247:	ff 75 f4             	push   -0xc(%ebp)
8010524a:	56                   	push   %esi
8010524b:	e8 30 c1 ff ff       	call   80101380 <filestat>
80105250:	83 c4 10             	add    $0x10,%esp
}
80105253:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105256:	5b                   	pop    %ebx
80105257:	5e                   	pop    %esi
80105258:	5d                   	pop    %ebp
80105259:	c3                   	ret    
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105265:	eb ec                	jmp    80105253 <sys_fstat+0x53>
80105267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526e:	66 90                	xchg   %ax,%ax

80105270 <sys_link>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105275:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105278:	53                   	push   %ebx
80105279:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010527c:	50                   	push   %eax
8010527d:	6a 00                	push   $0x0
8010527f:	e8 0c fb ff ff       	call   80104d90 <argstr>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
80105289:	0f 88 fb 00 00 00    	js     8010538a <sys_link+0x11a>
8010528f:	83 ec 08             	sub    $0x8,%esp
80105292:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105295:	50                   	push   %eax
80105296:	6a 01                	push   $0x1
80105298:	e8 f3 fa ff ff       	call   80104d90 <argstr>
8010529d:	83 c4 10             	add    $0x10,%esp
801052a0:	85 c0                	test   %eax,%eax
801052a2:	0f 88 e2 00 00 00    	js     8010538a <sys_link+0x11a>
  begin_op();
801052a8:	e8 63 de ff ff       	call   80103110 <begin_op>
  if((ip = namei(old)) == 0){
801052ad:	83 ec 0c             	sub    $0xc,%esp
801052b0:	ff 75 d4             	push   -0x2c(%ebp)
801052b3:	e8 98 d1 ff ff       	call   80102450 <namei>
801052b8:	83 c4 10             	add    $0x10,%esp
801052bb:	89 c3                	mov    %eax,%ebx
801052bd:	85 c0                	test   %eax,%eax
801052bf:	0f 84 e4 00 00 00    	je     801053a9 <sys_link+0x139>
  ilock(ip);
801052c5:	83 ec 0c             	sub    $0xc,%esp
801052c8:	50                   	push   %eax
801052c9:	e8 62 c8 ff ff       	call   80101b30 <ilock>
  if(ip->type == T_DIR){
801052ce:	83 c4 10             	add    $0x10,%esp
801052d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052d6:	0f 84 b5 00 00 00    	je     80105391 <sys_link+0x121>
  iupdate(ip);
801052dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801052e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052e7:	53                   	push   %ebx
801052e8:	e8 93 c7 ff ff       	call   80101a80 <iupdate>
  iunlock(ip);
801052ed:	89 1c 24             	mov    %ebx,(%esp)
801052f0:	e8 1b c9 ff ff       	call   80101c10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052f5:	58                   	pop    %eax
801052f6:	5a                   	pop    %edx
801052f7:	57                   	push   %edi
801052f8:	ff 75 d0             	push   -0x30(%ebp)
801052fb:	e8 70 d1 ff ff       	call   80102470 <nameiparent>
80105300:	83 c4 10             	add    $0x10,%esp
80105303:	89 c6                	mov    %eax,%esi
80105305:	85 c0                	test   %eax,%eax
80105307:	74 5b                	je     80105364 <sys_link+0xf4>
  ilock(dp);
80105309:	83 ec 0c             	sub    $0xc,%esp
8010530c:	50                   	push   %eax
8010530d:	e8 1e c8 ff ff       	call   80101b30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105312:	8b 03                	mov    (%ebx),%eax
80105314:	83 c4 10             	add    $0x10,%esp
80105317:	39 06                	cmp    %eax,(%esi)
80105319:	75 3d                	jne    80105358 <sys_link+0xe8>
8010531b:	83 ec 04             	sub    $0x4,%esp
8010531e:	ff 73 04             	push   0x4(%ebx)
80105321:	57                   	push   %edi
80105322:	56                   	push   %esi
80105323:	e8 68 d0 ff ff       	call   80102390 <dirlink>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	85 c0                	test   %eax,%eax
8010532d:	78 29                	js     80105358 <sys_link+0xe8>
  iunlockput(dp);
8010532f:	83 ec 0c             	sub    $0xc,%esp
80105332:	56                   	push   %esi
80105333:	e8 88 ca ff ff       	call   80101dc0 <iunlockput>
  iput(ip);
80105338:	89 1c 24             	mov    %ebx,(%esp)
8010533b:	e8 20 c9 ff ff       	call   80101c60 <iput>
  end_op();
80105340:	e8 3b de ff ff       	call   80103180 <end_op>
  return 0;
80105345:	83 c4 10             	add    $0x10,%esp
80105348:	31 c0                	xor    %eax,%eax
}
8010534a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010534d:	5b                   	pop    %ebx
8010534e:	5e                   	pop    %esi
8010534f:	5f                   	pop    %edi
80105350:	5d                   	pop    %ebp
80105351:	c3                   	ret    
80105352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105358:	83 ec 0c             	sub    $0xc,%esp
8010535b:	56                   	push   %esi
8010535c:	e8 5f ca ff ff       	call   80101dc0 <iunlockput>
    goto bad;
80105361:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105364:	83 ec 0c             	sub    $0xc,%esp
80105367:	53                   	push   %ebx
80105368:	e8 c3 c7 ff ff       	call   80101b30 <ilock>
  ip->nlink--;
8010536d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105372:	89 1c 24             	mov    %ebx,(%esp)
80105375:	e8 06 c7 ff ff       	call   80101a80 <iupdate>
  iunlockput(ip);
8010537a:	89 1c 24             	mov    %ebx,(%esp)
8010537d:	e8 3e ca ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105382:	e8 f9 dd ff ff       	call   80103180 <end_op>
  return -1;
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538f:	eb b9                	jmp    8010534a <sys_link+0xda>
    iunlockput(ip);
80105391:	83 ec 0c             	sub    $0xc,%esp
80105394:	53                   	push   %ebx
80105395:	e8 26 ca ff ff       	call   80101dc0 <iunlockput>
    end_op();
8010539a:	e8 e1 dd ff ff       	call   80103180 <end_op>
    return -1;
8010539f:	83 c4 10             	add    $0x10,%esp
801053a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a7:	eb a1                	jmp    8010534a <sys_link+0xda>
    end_op();
801053a9:	e8 d2 dd ff ff       	call   80103180 <end_op>
    return -1;
801053ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b3:	eb 95                	jmp    8010534a <sys_link+0xda>
801053b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_unlink>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801053c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053c8:	53                   	push   %ebx
801053c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801053cc:	50                   	push   %eax
801053cd:	6a 00                	push   $0x0
801053cf:	e8 bc f9 ff ff       	call   80104d90 <argstr>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	0f 88 7a 01 00 00    	js     80105559 <sys_unlink+0x199>
  begin_op();
801053df:	e8 2c dd ff ff       	call   80103110 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801053e7:	83 ec 08             	sub    $0x8,%esp
801053ea:	53                   	push   %ebx
801053eb:	ff 75 c0             	push   -0x40(%ebp)
801053ee:	e8 7d d0 ff ff       	call   80102470 <nameiparent>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801053f9:	85 c0                	test   %eax,%eax
801053fb:	0f 84 62 01 00 00    	je     80105563 <sys_unlink+0x1a3>
  ilock(dp);
80105401:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	57                   	push   %edi
80105408:	e8 23 c7 ff ff       	call   80101b30 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010540d:	58                   	pop    %eax
8010540e:	5a                   	pop    %edx
8010540f:	68 b4 7c 10 80       	push   $0x80107cb4
80105414:	53                   	push   %ebx
80105415:	e8 56 cc ff ff       	call   80102070 <namecmp>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	0f 84 fb 00 00 00    	je     80105520 <sys_unlink+0x160>
80105425:	83 ec 08             	sub    $0x8,%esp
80105428:	68 b3 7c 10 80       	push   $0x80107cb3
8010542d:	53                   	push   %ebx
8010542e:	e8 3d cc ff ff       	call   80102070 <namecmp>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	0f 84 e2 00 00 00    	je     80105520 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010543e:	83 ec 04             	sub    $0x4,%esp
80105441:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105444:	50                   	push   %eax
80105445:	53                   	push   %ebx
80105446:	57                   	push   %edi
80105447:	e8 44 cc ff ff       	call   80102090 <dirlookup>
8010544c:	83 c4 10             	add    $0x10,%esp
8010544f:	89 c3                	mov    %eax,%ebx
80105451:	85 c0                	test   %eax,%eax
80105453:	0f 84 c7 00 00 00    	je     80105520 <sys_unlink+0x160>
  ilock(ip);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	50                   	push   %eax
8010545d:	e8 ce c6 ff ff       	call   80101b30 <ilock>
  if(ip->nlink < 1)
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010546a:	0f 8e 1c 01 00 00    	jle    8010558c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105470:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105475:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105478:	74 66                	je     801054e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010547a:	83 ec 04             	sub    $0x4,%esp
8010547d:	6a 10                	push   $0x10
8010547f:	6a 00                	push   $0x0
80105481:	57                   	push   %edi
80105482:	e8 89 f5 ff ff       	call   80104a10 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105487:	6a 10                	push   $0x10
80105489:	ff 75 c4             	push   -0x3c(%ebp)
8010548c:	57                   	push   %edi
8010548d:	ff 75 b4             	push   -0x4c(%ebp)
80105490:	e8 ab ca ff ff       	call   80101f40 <writei>
80105495:	83 c4 20             	add    $0x20,%esp
80105498:	83 f8 10             	cmp    $0x10,%eax
8010549b:	0f 85 de 00 00 00    	jne    8010557f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801054a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a6:	0f 84 94 00 00 00    	je     80105540 <sys_unlink+0x180>
  iunlockput(dp);
801054ac:	83 ec 0c             	sub    $0xc,%esp
801054af:	ff 75 b4             	push   -0x4c(%ebp)
801054b2:	e8 09 c9 ff ff       	call   80101dc0 <iunlockput>
  ip->nlink--;
801054b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054bc:	89 1c 24             	mov    %ebx,(%esp)
801054bf:	e8 bc c5 ff ff       	call   80101a80 <iupdate>
  iunlockput(ip);
801054c4:	89 1c 24             	mov    %ebx,(%esp)
801054c7:	e8 f4 c8 ff ff       	call   80101dc0 <iunlockput>
  end_op();
801054cc:	e8 af dc ff ff       	call   80103180 <end_op>
  return 0;
801054d1:	83 c4 10             	add    $0x10,%esp
801054d4:	31 c0                	xor    %eax,%eax
}
801054d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054d9:	5b                   	pop    %ebx
801054da:	5e                   	pop    %esi
801054db:	5f                   	pop    %edi
801054dc:	5d                   	pop    %ebp
801054dd:	c3                   	ret    
801054de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054e4:	76 94                	jbe    8010547a <sys_unlink+0xba>
801054e6:	be 20 00 00 00       	mov    $0x20,%esi
801054eb:	eb 0b                	jmp    801054f8 <sys_unlink+0x138>
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
801054f0:	83 c6 10             	add    $0x10,%esi
801054f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801054f6:	73 82                	jae    8010547a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f8:	6a 10                	push   $0x10
801054fa:	56                   	push   %esi
801054fb:	57                   	push   %edi
801054fc:	53                   	push   %ebx
801054fd:	e8 3e c9 ff ff       	call   80101e40 <readi>
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	83 f8 10             	cmp    $0x10,%eax
80105508:	75 68                	jne    80105572 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010550a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010550f:	74 df                	je     801054f0 <sys_unlink+0x130>
    iunlockput(ip);
80105511:	83 ec 0c             	sub    $0xc,%esp
80105514:	53                   	push   %ebx
80105515:	e8 a6 c8 ff ff       	call   80101dc0 <iunlockput>
    goto bad;
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	ff 75 b4             	push   -0x4c(%ebp)
80105526:	e8 95 c8 ff ff       	call   80101dc0 <iunlockput>
  end_op();
8010552b:	e8 50 dc ff ff       	call   80103180 <end_op>
  return -1;
80105530:	83 c4 10             	add    $0x10,%esp
80105533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105538:	eb 9c                	jmp    801054d6 <sys_unlink+0x116>
8010553a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105540:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105543:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105546:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010554b:	50                   	push   %eax
8010554c:	e8 2f c5 ff ff       	call   80101a80 <iupdate>
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	e9 53 ff ff ff       	jmp    801054ac <sys_unlink+0xec>
    return -1;
80105559:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555e:	e9 73 ff ff ff       	jmp    801054d6 <sys_unlink+0x116>
    end_op();
80105563:	e8 18 dc ff ff       	call   80103180 <end_op>
    return -1;
80105568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556d:	e9 64 ff ff ff       	jmp    801054d6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105572:	83 ec 0c             	sub    $0xc,%esp
80105575:	68 d8 7c 10 80       	push   $0x80107cd8
8010557a:	e8 41 ae ff ff       	call   801003c0 <panic>
    panic("unlink: writei");
8010557f:	83 ec 0c             	sub    $0xc,%esp
80105582:	68 ea 7c 10 80       	push   $0x80107cea
80105587:	e8 34 ae ff ff       	call   801003c0 <panic>
    panic("unlink: nlink < 1");
8010558c:	83 ec 0c             	sub    $0xc,%esp
8010558f:	68 c6 7c 10 80       	push   $0x80107cc6
80105594:	e8 27 ae ff ff       	call   801003c0 <panic>
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_open>:

int
sys_open(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055a8:	53                   	push   %ebx
801055a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055ac:	50                   	push   %eax
801055ad:	6a 00                	push   $0x0
801055af:	e8 dc f7 ff ff       	call   80104d90 <argstr>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	0f 88 8e 00 00 00    	js     8010564d <sys_open+0xad>
801055bf:	83 ec 08             	sub    $0x8,%esp
801055c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055c5:	50                   	push   %eax
801055c6:	6a 01                	push   $0x1
801055c8:	e8 03 f7 ff ff       	call   80104cd0 <argint>
801055cd:	83 c4 10             	add    $0x10,%esp
801055d0:	85 c0                	test   %eax,%eax
801055d2:	78 79                	js     8010564d <sys_open+0xad>
    return -1;

  begin_op();
801055d4:	e8 37 db ff ff       	call   80103110 <begin_op>

  if(omode & O_CREATE){
801055d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055dd:	75 79                	jne    80105658 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	ff 75 e0             	push   -0x20(%ebp)
801055e5:	e8 66 ce ff ff       	call   80102450 <namei>
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	89 c6                	mov    %eax,%esi
801055ef:	85 c0                	test   %eax,%eax
801055f1:	0f 84 7e 00 00 00    	je     80105675 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801055f7:	83 ec 0c             	sub    $0xc,%esp
801055fa:	50                   	push   %eax
801055fb:	e8 30 c5 ff ff       	call   80101b30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105600:	83 c4 10             	add    $0x10,%esp
80105603:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105608:	0f 84 c2 00 00 00    	je     801056d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010560e:	e8 cd bb ff ff       	call   801011e0 <filealloc>
80105613:	89 c7                	mov    %eax,%edi
80105615:	85 c0                	test   %eax,%eax
80105617:	74 23                	je     8010563c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105619:	e8 02 e7 ff ff       	call   80103d20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010561e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105620:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105624:	85 d2                	test   %edx,%edx
80105626:	74 60                	je     80105688 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105628:	83 c3 01             	add    $0x1,%ebx
8010562b:	83 fb 10             	cmp    $0x10,%ebx
8010562e:	75 f0                	jne    80105620 <sys_open+0x80>
    if(f)
      fileclose(f);
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	57                   	push   %edi
80105634:	e8 67 bc ff ff       	call   801012a0 <fileclose>
80105639:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010563c:	83 ec 0c             	sub    $0xc,%esp
8010563f:	56                   	push   %esi
80105640:	e8 7b c7 ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105645:	e8 36 db ff ff       	call   80103180 <end_op>
    return -1;
8010564a:	83 c4 10             	add    $0x10,%esp
8010564d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105652:	eb 6d                	jmp    801056c1 <sys_open+0x121>
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010565e:	31 c9                	xor    %ecx,%ecx
80105660:	ba 02 00 00 00       	mov    $0x2,%edx
80105665:	6a 00                	push   $0x0
80105667:	e8 14 f8 ff ff       	call   80104e80 <create>
    if(ip == 0){
8010566c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010566f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105671:	85 c0                	test   %eax,%eax
80105673:	75 99                	jne    8010560e <sys_open+0x6e>
      end_op();
80105675:	e8 06 db ff ff       	call   80103180 <end_op>
      return -1;
8010567a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010567f:	eb 40                	jmp    801056c1 <sys_open+0x121>
80105681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105688:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010568b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010568f:	56                   	push   %esi
80105690:	e8 7b c5 ff ff       	call   80101c10 <iunlock>
  end_op();
80105695:	e8 e6 da ff ff       	call   80103180 <end_op>

  f->type = FD_INODE;
8010569a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801056a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801056ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056b2:	f7 d0                	not    %eax
801056b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c4:	89 d8                	mov    %ebx,%eax
801056c6:	5b                   	pop    %ebx
801056c7:	5e                   	pop    %esi
801056c8:	5f                   	pop    %edi
801056c9:	5d                   	pop    %ebp
801056ca:	c3                   	ret    
801056cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801056d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056d3:	85 c9                	test   %ecx,%ecx
801056d5:	0f 84 33 ff ff ff    	je     8010560e <sys_open+0x6e>
801056db:	e9 5c ff ff ff       	jmp    8010563c <sys_open+0x9c>

801056e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056e6:	e8 25 da ff ff       	call   80103110 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056eb:	83 ec 08             	sub    $0x8,%esp
801056ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f1:	50                   	push   %eax
801056f2:	6a 00                	push   $0x0
801056f4:	e8 97 f6 ff ff       	call   80104d90 <argstr>
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	85 c0                	test   %eax,%eax
801056fe:	78 30                	js     80105730 <sys_mkdir+0x50>
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105706:	31 c9                	xor    %ecx,%ecx
80105708:	ba 01 00 00 00       	mov    $0x1,%edx
8010570d:	6a 00                	push   $0x0
8010570f:	e8 6c f7 ff ff       	call   80104e80 <create>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	74 15                	je     80105730 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010571b:	83 ec 0c             	sub    $0xc,%esp
8010571e:	50                   	push   %eax
8010571f:	e8 9c c6 ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105724:	e8 57 da ff ff       	call   80103180 <end_op>
  return 0;
80105729:	83 c4 10             	add    $0x10,%esp
8010572c:	31 c0                	xor    %eax,%eax
}
8010572e:	c9                   	leave  
8010572f:	c3                   	ret    
    end_op();
80105730:	e8 4b da ff ff       	call   80103180 <end_op>
    return -1;
80105735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010573a:	c9                   	leave  
8010573b:	c3                   	ret    
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_mknod>:

int
sys_mknod(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105746:	e8 c5 d9 ff ff       	call   80103110 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010574b:	83 ec 08             	sub    $0x8,%esp
8010574e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105751:	50                   	push   %eax
80105752:	6a 00                	push   $0x0
80105754:	e8 37 f6 ff ff       	call   80104d90 <argstr>
80105759:	83 c4 10             	add    $0x10,%esp
8010575c:	85 c0                	test   %eax,%eax
8010575e:	78 60                	js     801057c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105766:	50                   	push   %eax
80105767:	6a 01                	push   $0x1
80105769:	e8 62 f5 ff ff       	call   80104cd0 <argint>
  if((argstr(0, &path)) < 0 ||
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	85 c0                	test   %eax,%eax
80105773:	78 4b                	js     801057c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105775:	83 ec 08             	sub    $0x8,%esp
80105778:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577b:	50                   	push   %eax
8010577c:	6a 02                	push   $0x2
8010577e:	e8 4d f5 ff ff       	call   80104cd0 <argint>
     argint(1, &major) < 0 ||
80105783:	83 c4 10             	add    $0x10,%esp
80105786:	85 c0                	test   %eax,%eax
80105788:	78 36                	js     801057c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010578a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010578e:	83 ec 0c             	sub    $0xc,%esp
80105791:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105795:	ba 03 00 00 00       	mov    $0x3,%edx
8010579a:	50                   	push   %eax
8010579b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010579e:	e8 dd f6 ff ff       	call   80104e80 <create>
     argint(2, &minor) < 0 ||
801057a3:	83 c4 10             	add    $0x10,%esp
801057a6:	85 c0                	test   %eax,%eax
801057a8:	74 16                	je     801057c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057aa:	83 ec 0c             	sub    $0xc,%esp
801057ad:	50                   	push   %eax
801057ae:	e8 0d c6 ff ff       	call   80101dc0 <iunlockput>
  end_op();
801057b3:	e8 c8 d9 ff ff       	call   80103180 <end_op>
  return 0;
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	31 c0                	xor    %eax,%eax
}
801057bd:	c9                   	leave  
801057be:	c3                   	ret    
801057bf:	90                   	nop
    end_op();
801057c0:	e8 bb d9 ff ff       	call   80103180 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ca:	c9                   	leave  
801057cb:	c3                   	ret    
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_chdir>:

int
sys_chdir(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	56                   	push   %esi
801057d4:	53                   	push   %ebx
801057d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057d8:	e8 43 e5 ff ff       	call   80103d20 <myproc>
801057dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057df:	e8 2c d9 ff ff       	call   80103110 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057e4:	83 ec 08             	sub    $0x8,%esp
801057e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ea:	50                   	push   %eax
801057eb:	6a 00                	push   $0x0
801057ed:	e8 9e f5 ff ff       	call   80104d90 <argstr>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	85 c0                	test   %eax,%eax
801057f7:	78 77                	js     80105870 <sys_chdir+0xa0>
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	ff 75 f4             	push   -0xc(%ebp)
801057ff:	e8 4c cc ff ff       	call   80102450 <namei>
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	89 c3                	mov    %eax,%ebx
80105809:	85 c0                	test   %eax,%eax
8010580b:	74 63                	je     80105870 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	50                   	push   %eax
80105811:	e8 1a c3 ff ff       	call   80101b30 <ilock>
  if(ip->type != T_DIR){
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010581e:	75 30                	jne    80105850 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	53                   	push   %ebx
80105824:	e8 e7 c3 ff ff       	call   80101c10 <iunlock>
  iput(curproc->cwd);
80105829:	58                   	pop    %eax
8010582a:	ff 76 68             	push   0x68(%esi)
8010582d:	e8 2e c4 ff ff       	call   80101c60 <iput>
  end_op();
80105832:	e8 49 d9 ff ff       	call   80103180 <end_op>
  curproc->cwd = ip;
80105837:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010583a:	83 c4 10             	add    $0x10,%esp
8010583d:	31 c0                	xor    %eax,%eax
}
8010583f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105842:	5b                   	pop    %ebx
80105843:	5e                   	pop    %esi
80105844:	5d                   	pop    %ebp
80105845:	c3                   	ret    
80105846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105850:	83 ec 0c             	sub    $0xc,%esp
80105853:	53                   	push   %ebx
80105854:	e8 67 c5 ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105859:	e8 22 d9 ff ff       	call   80103180 <end_op>
    return -1;
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105866:	eb d7                	jmp    8010583f <sys_chdir+0x6f>
80105868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586f:	90                   	nop
    end_op();
80105870:	e8 0b d9 ff ff       	call   80103180 <end_op>
    return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587a:	eb c3                	jmp    8010583f <sys_chdir+0x6f>
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_exec>:

int
sys_exec(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105885:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010588b:	53                   	push   %ebx
8010588c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105892:	50                   	push   %eax
80105893:	6a 00                	push   $0x0
80105895:	e8 f6 f4 ff ff       	call   80104d90 <argstr>
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	85 c0                	test   %eax,%eax
8010589f:	0f 88 87 00 00 00    	js     8010592c <sys_exec+0xac>
801058a5:	83 ec 08             	sub    $0x8,%esp
801058a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058ae:	50                   	push   %eax
801058af:	6a 01                	push   $0x1
801058b1:	e8 1a f4 ff ff       	call   80104cd0 <argint>
801058b6:	83 c4 10             	add    $0x10,%esp
801058b9:	85 c0                	test   %eax,%eax
801058bb:	78 6f                	js     8010592c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058bd:	83 ec 04             	sub    $0x4,%esp
801058c0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801058c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801058c8:	68 80 00 00 00       	push   $0x80
801058cd:	6a 00                	push   $0x0
801058cf:	56                   	push   %esi
801058d0:	e8 3b f1 ff ff       	call   80104a10 <memset>
801058d5:	83 c4 10             	add    $0x10,%esp
801058d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058df:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058e0:	83 ec 08             	sub    $0x8,%esp
801058e3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801058e9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801058f0:	50                   	push   %eax
801058f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058f7:	01 f8                	add    %edi,%eax
801058f9:	50                   	push   %eax
801058fa:	e8 41 f3 ff ff       	call   80104c40 <fetchint>
801058ff:	83 c4 10             	add    $0x10,%esp
80105902:	85 c0                	test   %eax,%eax
80105904:	78 26                	js     8010592c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105906:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010590c:	85 c0                	test   %eax,%eax
8010590e:	74 30                	je     80105940 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105910:	83 ec 08             	sub    $0x8,%esp
80105913:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105916:	52                   	push   %edx
80105917:	50                   	push   %eax
80105918:	e8 63 f3 ff ff       	call   80104c80 <fetchstr>
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	85 c0                	test   %eax,%eax
80105922:	78 08                	js     8010592c <sys_exec+0xac>
  for(i=0;; i++){
80105924:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105927:	83 fb 20             	cmp    $0x20,%ebx
8010592a:	75 b4                	jne    801058e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010592c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010592f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105934:	5b                   	pop    %ebx
80105935:	5e                   	pop    %esi
80105936:	5f                   	pop    %edi
80105937:	5d                   	pop    %ebp
80105938:	c3                   	ret    
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105940:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105947:	00 00 00 00 
  return exec(path, argv);
8010594b:	83 ec 08             	sub    $0x8,%esp
8010594e:	56                   	push   %esi
8010594f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105955:	e8 06 b5 ff ff       	call   80100e60 <exec>
8010595a:	83 c4 10             	add    $0x10,%esp
}
8010595d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105960:	5b                   	pop    %ebx
80105961:	5e                   	pop    %esi
80105962:	5f                   	pop    %edi
80105963:	5d                   	pop    %ebp
80105964:	c3                   	ret    
80105965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_pipe>:

int
sys_pipe(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105975:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105978:	53                   	push   %ebx
80105979:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010597c:	6a 08                	push   $0x8
8010597e:	50                   	push   %eax
8010597f:	6a 00                	push   $0x0
80105981:	e8 9a f3 ff ff       	call   80104d20 <argptr>
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	85 c0                	test   %eax,%eax
8010598b:	78 4a                	js     801059d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010598d:	83 ec 08             	sub    $0x8,%esp
80105990:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105993:	50                   	push   %eax
80105994:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105997:	50                   	push   %eax
80105998:	e8 43 de ff ff       	call   801037e0 <pipealloc>
8010599d:	83 c4 10             	add    $0x10,%esp
801059a0:	85 c0                	test   %eax,%eax
801059a2:	78 33                	js     801059d7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059a7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801059a9:	e8 72 e3 ff ff       	call   80103d20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801059b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059b4:	85 f6                	test   %esi,%esi
801059b6:	74 28                	je     801059e0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801059b8:	83 c3 01             	add    $0x1,%ebx
801059bb:	83 fb 10             	cmp    $0x10,%ebx
801059be:	75 f0                	jne    801059b0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	ff 75 e0             	push   -0x20(%ebp)
801059c6:	e8 d5 b8 ff ff       	call   801012a0 <fileclose>
    fileclose(wf);
801059cb:	58                   	pop    %eax
801059cc:	ff 75 e4             	push   -0x1c(%ebp)
801059cf:	e8 cc b8 ff ff       	call   801012a0 <fileclose>
    return -1;
801059d4:	83 c4 10             	add    $0x10,%esp
801059d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059dc:	eb 53                	jmp    80105a31 <sys_pipe+0xc1>
801059de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801059e0:	8d 73 08             	lea    0x8(%ebx),%esi
801059e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801059ea:	e8 31 e3 ff ff       	call   80103d20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059ef:	31 d2                	xor    %edx,%edx
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059fc:	85 c9                	test   %ecx,%ecx
801059fe:	74 20                	je     80105a20 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105a00:	83 c2 01             	add    $0x1,%edx
80105a03:	83 fa 10             	cmp    $0x10,%edx
80105a06:	75 f0                	jne    801059f8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105a08:	e8 13 e3 ff ff       	call   80103d20 <myproc>
80105a0d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a14:	00 
80105a15:	eb a9                	jmp    801059c0 <sys_pipe+0x50>
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105a20:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105a24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a27:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a2c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a2f:	31 c0                	xor    %eax,%eax
}
80105a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a34:	5b                   	pop    %ebx
80105a35:	5e                   	pop    %esi
80105a36:	5f                   	pop    %edi
80105a37:	5d                   	pop    %ebp
80105a38:	c3                   	ret    
80105a39:	66 90                	xchg   %ax,%ax
80105a3b:	66 90                	xchg   %ax,%ax
80105a3d:	66 90                	xchg   %ax,%ax
80105a3f:	90                   	nop

80105a40 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105a40:	e9 7b e4 ff ff       	jmp    80103ec0 <fork>
80105a45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_exit>:
}

int
sys_exit(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a56:	e8 e5 e6 ff ff       	call   80104140 <exit>
  return 0;  // not reached
}
80105a5b:	31 c0                	xor    %eax,%eax
80105a5d:	c9                   	leave  
80105a5e:	c3                   	ret    
80105a5f:	90                   	nop

80105a60 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105a60:	e9 0b e8 ff ff       	jmp    80104270 <wait>
80105a65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a70 <sys_kill>:
}

int
sys_kill(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a79:	50                   	push   %eax
80105a7a:	6a 00                	push   $0x0
80105a7c:	e8 4f f2 ff ff       	call   80104cd0 <argint>
80105a81:	83 c4 10             	add    $0x10,%esp
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 18                	js     80105aa0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	ff 75 f4             	push   -0xc(%ebp)
80105a8e:	e8 7d ea ff ff       	call   80104510 <kill>
80105a93:	83 c4 10             	add    $0x10,%esp
}
80105a96:	c9                   	leave  
80105a97:	c3                   	ret    
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
80105aa0:	c9                   	leave  
    return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa6:	c3                   	ret    
80105aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <sys_getpid>:

int
sys_getpid(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ab6:	e8 65 e2 ff ff       	call   80103d20 <myproc>
80105abb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105abe:	c9                   	leave  
80105abf:	c3                   	ret    

80105ac0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ac7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 fe f1 ff ff       	call   80104cd0 <argint>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 27                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ad9:	e8 42 e2 ff ff       	call   80103d20 <myproc>
  if(growproc(n) < 0)
80105ade:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ae1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ae3:	ff 75 f4             	push   -0xc(%ebp)
80105ae6:	e8 55 e3 ff ff       	call   80103e40 <growproc>
80105aeb:	83 c4 10             	add    $0x10,%esp
80105aee:	85 c0                	test   %eax,%eax
80105af0:	78 0e                	js     80105b00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105af2:	89 d8                	mov    %ebx,%eax
80105af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af7:	c9                   	leave  
80105af8:	c3                   	ret    
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b05:	eb eb                	jmp    80105af2 <sys_sbrk+0x32>
80105b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <sys_sleep>:

int
sys_sleep(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 ae f1 ff ff       	call   80104cd0 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	0f 88 8a 00 00 00    	js     80105bb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b2d:	83 ec 0c             	sub    $0xc,%esp
80105b30:	68 40 42 11 80       	push   $0x80114240
80105b35:	e8 16 ee ff ff       	call   80104950 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b3d:	8b 1d 20 42 11 80    	mov    0x80114220,%ebx
  while(ticks - ticks0 < n){
80105b43:	83 c4 10             	add    $0x10,%esp
80105b46:	85 d2                	test   %edx,%edx
80105b48:	75 27                	jne    80105b71 <sys_sleep+0x61>
80105b4a:	eb 54                	jmp    80105ba0 <sys_sleep+0x90>
80105b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	68 40 42 11 80       	push   $0x80114240
80105b58:	68 20 42 11 80       	push   $0x80114220
80105b5d:	e8 8e e8 ff ff       	call   801043f0 <sleep>
  while(ticks - ticks0 < n){
80105b62:	a1 20 42 11 80       	mov    0x80114220,%eax
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	29 d8                	sub    %ebx,%eax
80105b6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b6f:	73 2f                	jae    80105ba0 <sys_sleep+0x90>
    if(myproc()->killed){
80105b71:	e8 aa e1 ff ff       	call   80103d20 <myproc>
80105b76:	8b 40 24             	mov    0x24(%eax),%eax
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	74 d3                	je     80105b50 <sys_sleep+0x40>
      release(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 40 42 11 80       	push   $0x80114240
80105b85:	e8 66 ed ff ff       	call   801048f0 <release>
  }
  release(&tickslock);
  return 0;
}
80105b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b95:	c9                   	leave  
80105b96:	c3                   	ret    
80105b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	68 40 42 11 80       	push   $0x80114240
80105ba8:	e8 43 ed ff ff       	call   801048f0 <release>
  return 0;
80105bad:	83 c4 10             	add    $0x10,%esp
80105bb0:	31 c0                	xor    %eax,%eax
}
80105bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb5:	c9                   	leave  
80105bb6:	c3                   	ret    
    return -1;
80105bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bbc:	eb f4                	jmp    80105bb2 <sys_sleep+0xa2>
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
80105bc4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105bc7:	68 40 42 11 80       	push   $0x80114240
80105bcc:	e8 7f ed ff ff       	call   80104950 <acquire>
  xticks = ticks;
80105bd1:	8b 1d 20 42 11 80    	mov    0x80114220,%ebx
  release(&tickslock);
80105bd7:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
80105bde:	e8 0d ed ff ff       	call   801048f0 <release>
  return xticks;
}
80105be3:	89 d8                	mov    %ebx,%eax
80105be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be8:	c9                   	leave  
80105be9:	c3                   	ret    

80105bea <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105bea:	1e                   	push   %ds
  pushl %es
80105beb:	06                   	push   %es
  pushl %fs
80105bec:	0f a0                	push   %fs
  pushl %gs
80105bee:	0f a8                	push   %gs
  pushal
80105bf0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105bf1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105bf5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105bf7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105bf9:	54                   	push   %esp
  call trap
80105bfa:	e8 c1 00 00 00       	call   80105cc0 <trap>
  addl $4, %esp
80105bff:	83 c4 04             	add    $0x4,%esp

80105c02 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c02:	61                   	popa   
  popl %gs
80105c03:	0f a9                	pop    %gs
  popl %fs
80105c05:	0f a1                	pop    %fs
  popl %es
80105c07:	07                   	pop    %es
  popl %ds
80105c08:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c09:	83 c4 08             	add    $0x8,%esp
  iret
80105c0c:	cf                   	iret   
80105c0d:	66 90                	xchg   %ax,%ax
80105c0f:	90                   	nop

80105c10 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c10:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c11:	31 c0                	xor    %eax,%eax
{
80105c13:	89 e5                	mov    %esp,%ebp
80105c15:	83 ec 08             	sub    $0x8,%esp
80105c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c20:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c27:	c7 04 c5 82 42 11 80 	movl   $0x8e000008,-0x7feebd7e(,%eax,8)
80105c2e:	08 00 00 8e 
80105c32:	66 89 14 c5 80 42 11 	mov    %dx,-0x7feebd80(,%eax,8)
80105c39:	80 
80105c3a:	c1 ea 10             	shr    $0x10,%edx
80105c3d:	66 89 14 c5 86 42 11 	mov    %dx,-0x7feebd7a(,%eax,8)
80105c44:	80 
  for(i = 0; i < 256; i++)
80105c45:	83 c0 01             	add    $0x1,%eax
80105c48:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c4d:	75 d1                	jne    80105c20 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c4f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c52:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105c57:	c7 05 82 44 11 80 08 	movl   $0xef000008,0x80114482
80105c5e:	00 00 ef 
  initlock(&tickslock, "time");
80105c61:	68 f9 7c 10 80       	push   $0x80107cf9
80105c66:	68 40 42 11 80       	push   $0x80114240
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c6b:	66 a3 80 44 11 80    	mov    %ax,0x80114480
80105c71:	c1 e8 10             	shr    $0x10,%eax
80105c74:	66 a3 86 44 11 80    	mov    %ax,0x80114486
  initlock(&tickslock, "time");
80105c7a:	e8 01 eb ff ff       	call   80104780 <initlock>
}
80105c7f:	83 c4 10             	add    $0x10,%esp
80105c82:	c9                   	leave  
80105c83:	c3                   	ret    
80105c84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c8f:	90                   	nop

80105c90 <idtinit>:

void
idtinit(void)
{
80105c90:	55                   	push   %ebp
  pd[0] = size-1;
80105c91:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c96:	89 e5                	mov    %esp,%ebp
80105c98:	83 ec 10             	sub    $0x10,%esp
80105c9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c9f:	b8 80 42 11 80       	mov    $0x80114280,%eax
80105ca4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ca8:	c1 e8 10             	shr    $0x10,%eax
80105cab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105caf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cb2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cb5:	c9                   	leave  
80105cb6:	c3                   	ret    
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	57                   	push   %edi
80105cc4:	56                   	push   %esi
80105cc5:	53                   	push   %ebx
80105cc6:	83 ec 1c             	sub    $0x1c,%esp
80105cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ccc:	8b 43 30             	mov    0x30(%ebx),%eax
80105ccf:	83 f8 40             	cmp    $0x40,%eax
80105cd2:	0f 84 68 01 00 00    	je     80105e40 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cd8:	83 e8 20             	sub    $0x20,%eax
80105cdb:	83 f8 1f             	cmp    $0x1f,%eax
80105cde:	0f 87 8c 00 00 00    	ja     80105d70 <trap+0xb0>
80105ce4:	ff 24 85 a0 7d 10 80 	jmp    *-0x7fef8260(,%eax,4)
80105ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105cf0:	e8 fb c8 ff ff       	call   801025f0 <ideintr>
    lapiceoi();
80105cf5:	e8 c6 cf ff ff       	call   80102cc0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cfa:	e8 21 e0 ff ff       	call   80103d20 <myproc>
80105cff:	85 c0                	test   %eax,%eax
80105d01:	74 1d                	je     80105d20 <trap+0x60>
80105d03:	e8 18 e0 ff ff       	call   80103d20 <myproc>
80105d08:	8b 50 24             	mov    0x24(%eax),%edx
80105d0b:	85 d2                	test   %edx,%edx
80105d0d:	74 11                	je     80105d20 <trap+0x60>
80105d0f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d13:	83 e0 03             	and    $0x3,%eax
80105d16:	66 83 f8 03          	cmp    $0x3,%ax
80105d1a:	0f 84 e8 01 00 00    	je     80105f08 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d20:	e8 fb df ff ff       	call   80103d20 <myproc>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	74 0f                	je     80105d38 <trap+0x78>
80105d29:	e8 f2 df ff ff       	call   80103d20 <myproc>
80105d2e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d32:	0f 84 b8 00 00 00    	je     80105df0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d38:	e8 e3 df ff ff       	call   80103d20 <myproc>
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	74 1d                	je     80105d5e <trap+0x9e>
80105d41:	e8 da df ff ff       	call   80103d20 <myproc>
80105d46:	8b 40 24             	mov    0x24(%eax),%eax
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	74 11                	je     80105d5e <trap+0x9e>
80105d4d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d51:	83 e0 03             	and    $0x3,%eax
80105d54:	66 83 f8 03          	cmp    $0x3,%ax
80105d58:	0f 84 0f 01 00 00    	je     80105e6d <trap+0x1ad>
    exit();
}
80105d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d61:	5b                   	pop    %ebx
80105d62:	5e                   	pop    %esi
80105d63:	5f                   	pop    %edi
80105d64:	5d                   	pop    %ebp
80105d65:	c3                   	ret    
80105d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d70:	e8 ab df ff ff       	call   80103d20 <myproc>
80105d75:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	0f 84 a2 01 00 00    	je     80105f22 <trap+0x262>
80105d80:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d84:	0f 84 98 01 00 00    	je     80105f22 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d8a:	0f 20 d1             	mov    %cr2,%ecx
80105d8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d90:	e8 6b df ff ff       	call   80103d00 <cpuid>
80105d95:	8b 73 30             	mov    0x30(%ebx),%esi
80105d98:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d9b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105da1:	e8 7a df ff ff       	call   80103d20 <myproc>
80105da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105da9:	e8 72 df ff ff       	call   80103d20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105db4:	51                   	push   %ecx
80105db5:	57                   	push   %edi
80105db6:	52                   	push   %edx
80105db7:	ff 75 e4             	push   -0x1c(%ebp)
80105dba:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105dbb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105dbe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dc1:	56                   	push   %esi
80105dc2:	ff 70 10             	push   0x10(%eax)
80105dc5:	68 5c 7d 10 80       	push   $0x80107d5c
80105dca:	e8 11 a9 ff ff       	call   801006e0 <cprintf>
    myproc()->killed = 1;
80105dcf:	83 c4 20             	add    $0x20,%esp
80105dd2:	e8 49 df ff ff       	call   80103d20 <myproc>
80105dd7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dde:	e8 3d df ff ff       	call   80103d20 <myproc>
80105de3:	85 c0                	test   %eax,%eax
80105de5:	0f 85 18 ff ff ff    	jne    80105d03 <trap+0x43>
80105deb:	e9 30 ff ff ff       	jmp    80105d20 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105df0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105df4:	0f 85 3e ff ff ff    	jne    80105d38 <trap+0x78>
    yield();
80105dfa:	e8 a1 e5 ff ff       	call   801043a0 <yield>
80105dff:	e9 34 ff ff ff       	jmp    80105d38 <trap+0x78>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e08:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e0b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e0f:	e8 ec de ff ff       	call   80103d00 <cpuid>
80105e14:	57                   	push   %edi
80105e15:	56                   	push   %esi
80105e16:	50                   	push   %eax
80105e17:	68 04 7d 10 80       	push   $0x80107d04
80105e1c:	e8 bf a8 ff ff       	call   801006e0 <cprintf>
    lapiceoi();
80105e21:	e8 9a ce ff ff       	call   80102cc0 <lapiceoi>
    break;
80105e26:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e29:	e8 f2 de ff ff       	call   80103d20 <myproc>
80105e2e:	85 c0                	test   %eax,%eax
80105e30:	0f 85 cd fe ff ff    	jne    80105d03 <trap+0x43>
80105e36:	e9 e5 fe ff ff       	jmp    80105d20 <trap+0x60>
80105e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e3f:	90                   	nop
    if(myproc()->killed)
80105e40:	e8 db de ff ff       	call   80103d20 <myproc>
80105e45:	8b 70 24             	mov    0x24(%eax),%esi
80105e48:	85 f6                	test   %esi,%esi
80105e4a:	0f 85 c8 00 00 00    	jne    80105f18 <trap+0x258>
    myproc()->tf = tf;
80105e50:	e8 cb de ff ff       	call   80103d20 <myproc>
80105e55:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e58:	e8 b3 ef ff ff       	call   80104e10 <syscall>
    if(myproc()->killed)
80105e5d:	e8 be de ff ff       	call   80103d20 <myproc>
80105e62:	8b 48 24             	mov    0x24(%eax),%ecx
80105e65:	85 c9                	test   %ecx,%ecx
80105e67:	0f 84 f1 fe ff ff    	je     80105d5e <trap+0x9e>
}
80105e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e70:	5b                   	pop    %ebx
80105e71:	5e                   	pop    %esi
80105e72:	5f                   	pop    %edi
80105e73:	5d                   	pop    %ebp
      exit();
80105e74:	e9 c7 e2 ff ff       	jmp    80104140 <exit>
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e80:	e8 3b 02 00 00       	call   801060c0 <uartintr>
    lapiceoi();
80105e85:	e8 36 ce ff ff       	call   80102cc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e8a:	e8 91 de ff ff       	call   80103d20 <myproc>
80105e8f:	85 c0                	test   %eax,%eax
80105e91:	0f 85 6c fe ff ff    	jne    80105d03 <trap+0x43>
80105e97:	e9 84 fe ff ff       	jmp    80105d20 <trap+0x60>
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ea0:	e8 db cc ff ff       	call   80102b80 <kbdintr>
    lapiceoi();
80105ea5:	e8 16 ce ff ff       	call   80102cc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eaa:	e8 71 de ff ff       	call   80103d20 <myproc>
80105eaf:	85 c0                	test   %eax,%eax
80105eb1:	0f 85 4c fe ff ff    	jne    80105d03 <trap+0x43>
80105eb7:	e9 64 fe ff ff       	jmp    80105d20 <trap+0x60>
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ec0:	e8 3b de ff ff       	call   80103d00 <cpuid>
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	0f 85 28 fe ff ff    	jne    80105cf5 <trap+0x35>
      acquire(&tickslock);
80105ecd:	83 ec 0c             	sub    $0xc,%esp
80105ed0:	68 40 42 11 80       	push   $0x80114240
80105ed5:	e8 76 ea ff ff       	call   80104950 <acquire>
      wakeup(&ticks);
80105eda:	c7 04 24 20 42 11 80 	movl   $0x80114220,(%esp)
      ticks++;
80105ee1:	83 05 20 42 11 80 01 	addl   $0x1,0x80114220
      wakeup(&ticks);
80105ee8:	e8 c3 e5 ff ff       	call   801044b0 <wakeup>
      release(&tickslock);
80105eed:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
80105ef4:	e8 f7 e9 ff ff       	call   801048f0 <release>
80105ef9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105efc:	e9 f4 fd ff ff       	jmp    80105cf5 <trap+0x35>
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f08:	e8 33 e2 ff ff       	call   80104140 <exit>
80105f0d:	e9 0e fe ff ff       	jmp    80105d20 <trap+0x60>
80105f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f18:	e8 23 e2 ff ff       	call   80104140 <exit>
80105f1d:	e9 2e ff ff ff       	jmp    80105e50 <trap+0x190>
80105f22:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f25:	e8 d6 dd ff ff       	call   80103d00 <cpuid>
80105f2a:	83 ec 0c             	sub    $0xc,%esp
80105f2d:	56                   	push   %esi
80105f2e:	57                   	push   %edi
80105f2f:	50                   	push   %eax
80105f30:	ff 73 30             	push   0x30(%ebx)
80105f33:	68 28 7d 10 80       	push   $0x80107d28
80105f38:	e8 a3 a7 ff ff       	call   801006e0 <cprintf>
      panic("trap");
80105f3d:	83 c4 14             	add    $0x14,%esp
80105f40:	68 fe 7c 10 80       	push   $0x80107cfe
80105f45:	e8 76 a4 ff ff       	call   801003c0 <panic>
80105f4a:	66 90                	xchg   %ax,%ax
80105f4c:	66 90                	xchg   %ax,%ax
80105f4e:	66 90                	xchg   %ax,%ax

80105f50 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f50:	a1 80 4a 11 80       	mov    0x80114a80,%eax
80105f55:	85 c0                	test   %eax,%eax
80105f57:	74 17                	je     80105f70 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f59:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f5e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f5f:	a8 01                	test   $0x1,%al
80105f61:	74 0d                	je     80105f70 <uartgetc+0x20>
80105f63:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f68:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f69:	0f b6 c0             	movzbl %al,%eax
80105f6c:	c3                   	ret    
80105f6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f75:	c3                   	ret    
80105f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7d:	8d 76 00             	lea    0x0(%esi),%esi

80105f80 <uartinit>:
{
80105f80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f81:	31 c9                	xor    %ecx,%ecx
80105f83:	89 c8                	mov    %ecx,%eax
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	57                   	push   %edi
80105f88:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f8d:	56                   	push   %esi
80105f8e:	89 fa                	mov    %edi,%edx
80105f90:	53                   	push   %ebx
80105f91:	83 ec 1c             	sub    $0x1c,%esp
80105f94:	ee                   	out    %al,(%dx)
80105f95:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f9f:	89 f2                	mov    %esi,%edx
80105fa1:	ee                   	out    %al,(%dx)
80105fa2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fa7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fac:	ee                   	out    %al,(%dx)
80105fad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105fb2:	89 c8                	mov    %ecx,%eax
80105fb4:	89 da                	mov    %ebx,%edx
80105fb6:	ee                   	out    %al,(%dx)
80105fb7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fbc:	89 f2                	mov    %esi,%edx
80105fbe:	ee                   	out    %al,(%dx)
80105fbf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fc4:	89 c8                	mov    %ecx,%eax
80105fc6:	ee                   	out    %al,(%dx)
80105fc7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fcc:	89 da                	mov    %ebx,%edx
80105fce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fcf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fd4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fd5:	3c ff                	cmp    $0xff,%al
80105fd7:	74 78                	je     80106051 <uartinit+0xd1>
  uart = 1;
80105fd9:	c7 05 80 4a 11 80 01 	movl   $0x1,0x80114a80
80105fe0:	00 00 00 
80105fe3:	89 fa                	mov    %edi,%edx
80105fe5:	ec                   	in     (%dx),%al
80105fe6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105feb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fef:	bf 20 7e 10 80       	mov    $0x80107e20,%edi
80105ff4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105ff9:	6a 00                	push   $0x0
80105ffb:	6a 04                	push   $0x4
80105ffd:	e8 2e c8 ff ff       	call   80102830 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106002:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106010:	a1 80 4a 11 80       	mov    0x80114a80,%eax
80106015:	bb 80 00 00 00       	mov    $0x80,%ebx
8010601a:	85 c0                	test   %eax,%eax
8010601c:	75 14                	jne    80106032 <uartinit+0xb2>
8010601e:	eb 23                	jmp    80106043 <uartinit+0xc3>
    microdelay(10);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	6a 0a                	push   $0xa
80106025:	e8 b6 cc ff ff       	call   80102ce0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	83 eb 01             	sub    $0x1,%ebx
80106030:	74 07                	je     80106039 <uartinit+0xb9>
80106032:	89 f2                	mov    %esi,%edx
80106034:	ec                   	in     (%dx),%al
80106035:	a8 20                	test   $0x20,%al
80106037:	74 e7                	je     80106020 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106039:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010603d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106042:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106043:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106047:	83 c7 01             	add    $0x1,%edi
8010604a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010604d:	84 c0                	test   %al,%al
8010604f:	75 bf                	jne    80106010 <uartinit+0x90>
}
80106051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106054:	5b                   	pop    %ebx
80106055:	5e                   	pop    %esi
80106056:	5f                   	pop    %edi
80106057:	5d                   	pop    %ebp
80106058:	c3                   	ret    
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106060 <uartputc>:
  if(!uart)
80106060:	a1 80 4a 11 80       	mov    0x80114a80,%eax
80106065:	85 c0                	test   %eax,%eax
80106067:	74 47                	je     801060b0 <uartputc+0x50>
{
80106069:	55                   	push   %ebp
8010606a:	89 e5                	mov    %esp,%ebp
8010606c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010606d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106072:	53                   	push   %ebx
80106073:	bb 80 00 00 00       	mov    $0x80,%ebx
80106078:	eb 18                	jmp    80106092 <uartputc+0x32>
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	6a 0a                	push   $0xa
80106085:	e8 56 cc ff ff       	call   80102ce0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	83 eb 01             	sub    $0x1,%ebx
80106090:	74 07                	je     80106099 <uartputc+0x39>
80106092:	89 f2                	mov    %esi,%edx
80106094:	ec                   	in     (%dx),%al
80106095:	a8 20                	test   $0x20,%al
80106097:	74 e7                	je     80106080 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106099:	8b 45 08             	mov    0x8(%ebp),%eax
8010609c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060a1:	ee                   	out    %al,(%dx)
}
801060a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060a5:	5b                   	pop    %ebx
801060a6:	5e                   	pop    %esi
801060a7:	5d                   	pop    %ebp
801060a8:	c3                   	ret    
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060b0:	c3                   	ret    
801060b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060bf:	90                   	nop

801060c0 <uartintr>:

void
uartintr(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060c6:	68 50 5f 10 80       	push   $0x80105f50
801060cb:	e8 f0 a7 ff ff       	call   801008c0 <consoleintr>
}
801060d0:	83 c4 10             	add    $0x10,%esp
801060d3:	c9                   	leave  
801060d4:	c3                   	ret    

801060d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $0
801060d7:	6a 00                	push   $0x0
  jmp alltraps
801060d9:	e9 0c fb ff ff       	jmp    80105bea <alltraps>

801060de <vector1>:
.globl vector1
vector1:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $1
801060e0:	6a 01                	push   $0x1
  jmp alltraps
801060e2:	e9 03 fb ff ff       	jmp    80105bea <alltraps>

801060e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $2
801060e9:	6a 02                	push   $0x2
  jmp alltraps
801060eb:	e9 fa fa ff ff       	jmp    80105bea <alltraps>

801060f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $3
801060f2:	6a 03                	push   $0x3
  jmp alltraps
801060f4:	e9 f1 fa ff ff       	jmp    80105bea <alltraps>

801060f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $4
801060fb:	6a 04                	push   $0x4
  jmp alltraps
801060fd:	e9 e8 fa ff ff       	jmp    80105bea <alltraps>

80106102 <vector5>:
.globl vector5
vector5:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $5
80106104:	6a 05                	push   $0x5
  jmp alltraps
80106106:	e9 df fa ff ff       	jmp    80105bea <alltraps>

8010610b <vector6>:
.globl vector6
vector6:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $6
8010610d:	6a 06                	push   $0x6
  jmp alltraps
8010610f:	e9 d6 fa ff ff       	jmp    80105bea <alltraps>

80106114 <vector7>:
.globl vector7
vector7:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $7
80106116:	6a 07                	push   $0x7
  jmp alltraps
80106118:	e9 cd fa ff ff       	jmp    80105bea <alltraps>

8010611d <vector8>:
.globl vector8
vector8:
  pushl $8
8010611d:	6a 08                	push   $0x8
  jmp alltraps
8010611f:	e9 c6 fa ff ff       	jmp    80105bea <alltraps>

80106124 <vector9>:
.globl vector9
vector9:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $9
80106126:	6a 09                	push   $0x9
  jmp alltraps
80106128:	e9 bd fa ff ff       	jmp    80105bea <alltraps>

8010612d <vector10>:
.globl vector10
vector10:
  pushl $10
8010612d:	6a 0a                	push   $0xa
  jmp alltraps
8010612f:	e9 b6 fa ff ff       	jmp    80105bea <alltraps>

80106134 <vector11>:
.globl vector11
vector11:
  pushl $11
80106134:	6a 0b                	push   $0xb
  jmp alltraps
80106136:	e9 af fa ff ff       	jmp    80105bea <alltraps>

8010613b <vector12>:
.globl vector12
vector12:
  pushl $12
8010613b:	6a 0c                	push   $0xc
  jmp alltraps
8010613d:	e9 a8 fa ff ff       	jmp    80105bea <alltraps>

80106142 <vector13>:
.globl vector13
vector13:
  pushl $13
80106142:	6a 0d                	push   $0xd
  jmp alltraps
80106144:	e9 a1 fa ff ff       	jmp    80105bea <alltraps>

80106149 <vector14>:
.globl vector14
vector14:
  pushl $14
80106149:	6a 0e                	push   $0xe
  jmp alltraps
8010614b:	e9 9a fa ff ff       	jmp    80105bea <alltraps>

80106150 <vector15>:
.globl vector15
vector15:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $15
80106152:	6a 0f                	push   $0xf
  jmp alltraps
80106154:	e9 91 fa ff ff       	jmp    80105bea <alltraps>

80106159 <vector16>:
.globl vector16
vector16:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $16
8010615b:	6a 10                	push   $0x10
  jmp alltraps
8010615d:	e9 88 fa ff ff       	jmp    80105bea <alltraps>

80106162 <vector17>:
.globl vector17
vector17:
  pushl $17
80106162:	6a 11                	push   $0x11
  jmp alltraps
80106164:	e9 81 fa ff ff       	jmp    80105bea <alltraps>

80106169 <vector18>:
.globl vector18
vector18:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $18
8010616b:	6a 12                	push   $0x12
  jmp alltraps
8010616d:	e9 78 fa ff ff       	jmp    80105bea <alltraps>

80106172 <vector19>:
.globl vector19
vector19:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $19
80106174:	6a 13                	push   $0x13
  jmp alltraps
80106176:	e9 6f fa ff ff       	jmp    80105bea <alltraps>

8010617b <vector20>:
.globl vector20
vector20:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $20
8010617d:	6a 14                	push   $0x14
  jmp alltraps
8010617f:	e9 66 fa ff ff       	jmp    80105bea <alltraps>

80106184 <vector21>:
.globl vector21
vector21:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $21
80106186:	6a 15                	push   $0x15
  jmp alltraps
80106188:	e9 5d fa ff ff       	jmp    80105bea <alltraps>

8010618d <vector22>:
.globl vector22
vector22:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $22
8010618f:	6a 16                	push   $0x16
  jmp alltraps
80106191:	e9 54 fa ff ff       	jmp    80105bea <alltraps>

80106196 <vector23>:
.globl vector23
vector23:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $23
80106198:	6a 17                	push   $0x17
  jmp alltraps
8010619a:	e9 4b fa ff ff       	jmp    80105bea <alltraps>

8010619f <vector24>:
.globl vector24
vector24:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $24
801061a1:	6a 18                	push   $0x18
  jmp alltraps
801061a3:	e9 42 fa ff ff       	jmp    80105bea <alltraps>

801061a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $25
801061aa:	6a 19                	push   $0x19
  jmp alltraps
801061ac:	e9 39 fa ff ff       	jmp    80105bea <alltraps>

801061b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $26
801061b3:	6a 1a                	push   $0x1a
  jmp alltraps
801061b5:	e9 30 fa ff ff       	jmp    80105bea <alltraps>

801061ba <vector27>:
.globl vector27
vector27:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $27
801061bc:	6a 1b                	push   $0x1b
  jmp alltraps
801061be:	e9 27 fa ff ff       	jmp    80105bea <alltraps>

801061c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $28
801061c5:	6a 1c                	push   $0x1c
  jmp alltraps
801061c7:	e9 1e fa ff ff       	jmp    80105bea <alltraps>

801061cc <vector29>:
.globl vector29
vector29:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $29
801061ce:	6a 1d                	push   $0x1d
  jmp alltraps
801061d0:	e9 15 fa ff ff       	jmp    80105bea <alltraps>

801061d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $30
801061d7:	6a 1e                	push   $0x1e
  jmp alltraps
801061d9:	e9 0c fa ff ff       	jmp    80105bea <alltraps>

801061de <vector31>:
.globl vector31
vector31:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $31
801061e0:	6a 1f                	push   $0x1f
  jmp alltraps
801061e2:	e9 03 fa ff ff       	jmp    80105bea <alltraps>

801061e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $32
801061e9:	6a 20                	push   $0x20
  jmp alltraps
801061eb:	e9 fa f9 ff ff       	jmp    80105bea <alltraps>

801061f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $33
801061f2:	6a 21                	push   $0x21
  jmp alltraps
801061f4:	e9 f1 f9 ff ff       	jmp    80105bea <alltraps>

801061f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $34
801061fb:	6a 22                	push   $0x22
  jmp alltraps
801061fd:	e9 e8 f9 ff ff       	jmp    80105bea <alltraps>

80106202 <vector35>:
.globl vector35
vector35:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $35
80106204:	6a 23                	push   $0x23
  jmp alltraps
80106206:	e9 df f9 ff ff       	jmp    80105bea <alltraps>

8010620b <vector36>:
.globl vector36
vector36:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $36
8010620d:	6a 24                	push   $0x24
  jmp alltraps
8010620f:	e9 d6 f9 ff ff       	jmp    80105bea <alltraps>

80106214 <vector37>:
.globl vector37
vector37:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $37
80106216:	6a 25                	push   $0x25
  jmp alltraps
80106218:	e9 cd f9 ff ff       	jmp    80105bea <alltraps>

8010621d <vector38>:
.globl vector38
vector38:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $38
8010621f:	6a 26                	push   $0x26
  jmp alltraps
80106221:	e9 c4 f9 ff ff       	jmp    80105bea <alltraps>

80106226 <vector39>:
.globl vector39
vector39:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $39
80106228:	6a 27                	push   $0x27
  jmp alltraps
8010622a:	e9 bb f9 ff ff       	jmp    80105bea <alltraps>

8010622f <vector40>:
.globl vector40
vector40:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $40
80106231:	6a 28                	push   $0x28
  jmp alltraps
80106233:	e9 b2 f9 ff ff       	jmp    80105bea <alltraps>

80106238 <vector41>:
.globl vector41
vector41:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $41
8010623a:	6a 29                	push   $0x29
  jmp alltraps
8010623c:	e9 a9 f9 ff ff       	jmp    80105bea <alltraps>

80106241 <vector42>:
.globl vector42
vector42:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $42
80106243:	6a 2a                	push   $0x2a
  jmp alltraps
80106245:	e9 a0 f9 ff ff       	jmp    80105bea <alltraps>

8010624a <vector43>:
.globl vector43
vector43:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $43
8010624c:	6a 2b                	push   $0x2b
  jmp alltraps
8010624e:	e9 97 f9 ff ff       	jmp    80105bea <alltraps>

80106253 <vector44>:
.globl vector44
vector44:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $44
80106255:	6a 2c                	push   $0x2c
  jmp alltraps
80106257:	e9 8e f9 ff ff       	jmp    80105bea <alltraps>

8010625c <vector45>:
.globl vector45
vector45:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $45
8010625e:	6a 2d                	push   $0x2d
  jmp alltraps
80106260:	e9 85 f9 ff ff       	jmp    80105bea <alltraps>

80106265 <vector46>:
.globl vector46
vector46:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $46
80106267:	6a 2e                	push   $0x2e
  jmp alltraps
80106269:	e9 7c f9 ff ff       	jmp    80105bea <alltraps>

8010626e <vector47>:
.globl vector47
vector47:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $47
80106270:	6a 2f                	push   $0x2f
  jmp alltraps
80106272:	e9 73 f9 ff ff       	jmp    80105bea <alltraps>

80106277 <vector48>:
.globl vector48
vector48:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $48
80106279:	6a 30                	push   $0x30
  jmp alltraps
8010627b:	e9 6a f9 ff ff       	jmp    80105bea <alltraps>

80106280 <vector49>:
.globl vector49
vector49:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $49
80106282:	6a 31                	push   $0x31
  jmp alltraps
80106284:	e9 61 f9 ff ff       	jmp    80105bea <alltraps>

80106289 <vector50>:
.globl vector50
vector50:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $50
8010628b:	6a 32                	push   $0x32
  jmp alltraps
8010628d:	e9 58 f9 ff ff       	jmp    80105bea <alltraps>

80106292 <vector51>:
.globl vector51
vector51:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $51
80106294:	6a 33                	push   $0x33
  jmp alltraps
80106296:	e9 4f f9 ff ff       	jmp    80105bea <alltraps>

8010629b <vector52>:
.globl vector52
vector52:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $52
8010629d:	6a 34                	push   $0x34
  jmp alltraps
8010629f:	e9 46 f9 ff ff       	jmp    80105bea <alltraps>

801062a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $53
801062a6:	6a 35                	push   $0x35
  jmp alltraps
801062a8:	e9 3d f9 ff ff       	jmp    80105bea <alltraps>

801062ad <vector54>:
.globl vector54
vector54:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $54
801062af:	6a 36                	push   $0x36
  jmp alltraps
801062b1:	e9 34 f9 ff ff       	jmp    80105bea <alltraps>

801062b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $55
801062b8:	6a 37                	push   $0x37
  jmp alltraps
801062ba:	e9 2b f9 ff ff       	jmp    80105bea <alltraps>

801062bf <vector56>:
.globl vector56
vector56:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $56
801062c1:	6a 38                	push   $0x38
  jmp alltraps
801062c3:	e9 22 f9 ff ff       	jmp    80105bea <alltraps>

801062c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $57
801062ca:	6a 39                	push   $0x39
  jmp alltraps
801062cc:	e9 19 f9 ff ff       	jmp    80105bea <alltraps>

801062d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $58
801062d3:	6a 3a                	push   $0x3a
  jmp alltraps
801062d5:	e9 10 f9 ff ff       	jmp    80105bea <alltraps>

801062da <vector59>:
.globl vector59
vector59:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $59
801062dc:	6a 3b                	push   $0x3b
  jmp alltraps
801062de:	e9 07 f9 ff ff       	jmp    80105bea <alltraps>

801062e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $60
801062e5:	6a 3c                	push   $0x3c
  jmp alltraps
801062e7:	e9 fe f8 ff ff       	jmp    80105bea <alltraps>

801062ec <vector61>:
.globl vector61
vector61:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $61
801062ee:	6a 3d                	push   $0x3d
  jmp alltraps
801062f0:	e9 f5 f8 ff ff       	jmp    80105bea <alltraps>

801062f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $62
801062f7:	6a 3e                	push   $0x3e
  jmp alltraps
801062f9:	e9 ec f8 ff ff       	jmp    80105bea <alltraps>

801062fe <vector63>:
.globl vector63
vector63:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $63
80106300:	6a 3f                	push   $0x3f
  jmp alltraps
80106302:	e9 e3 f8 ff ff       	jmp    80105bea <alltraps>

80106307 <vector64>:
.globl vector64
vector64:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $64
80106309:	6a 40                	push   $0x40
  jmp alltraps
8010630b:	e9 da f8 ff ff       	jmp    80105bea <alltraps>

80106310 <vector65>:
.globl vector65
vector65:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $65
80106312:	6a 41                	push   $0x41
  jmp alltraps
80106314:	e9 d1 f8 ff ff       	jmp    80105bea <alltraps>

80106319 <vector66>:
.globl vector66
vector66:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $66
8010631b:	6a 42                	push   $0x42
  jmp alltraps
8010631d:	e9 c8 f8 ff ff       	jmp    80105bea <alltraps>

80106322 <vector67>:
.globl vector67
vector67:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $67
80106324:	6a 43                	push   $0x43
  jmp alltraps
80106326:	e9 bf f8 ff ff       	jmp    80105bea <alltraps>

8010632b <vector68>:
.globl vector68
vector68:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $68
8010632d:	6a 44                	push   $0x44
  jmp alltraps
8010632f:	e9 b6 f8 ff ff       	jmp    80105bea <alltraps>

80106334 <vector69>:
.globl vector69
vector69:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $69
80106336:	6a 45                	push   $0x45
  jmp alltraps
80106338:	e9 ad f8 ff ff       	jmp    80105bea <alltraps>

8010633d <vector70>:
.globl vector70
vector70:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $70
8010633f:	6a 46                	push   $0x46
  jmp alltraps
80106341:	e9 a4 f8 ff ff       	jmp    80105bea <alltraps>

80106346 <vector71>:
.globl vector71
vector71:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $71
80106348:	6a 47                	push   $0x47
  jmp alltraps
8010634a:	e9 9b f8 ff ff       	jmp    80105bea <alltraps>

8010634f <vector72>:
.globl vector72
vector72:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $72
80106351:	6a 48                	push   $0x48
  jmp alltraps
80106353:	e9 92 f8 ff ff       	jmp    80105bea <alltraps>

80106358 <vector73>:
.globl vector73
vector73:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $73
8010635a:	6a 49                	push   $0x49
  jmp alltraps
8010635c:	e9 89 f8 ff ff       	jmp    80105bea <alltraps>

80106361 <vector74>:
.globl vector74
vector74:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $74
80106363:	6a 4a                	push   $0x4a
  jmp alltraps
80106365:	e9 80 f8 ff ff       	jmp    80105bea <alltraps>

8010636a <vector75>:
.globl vector75
vector75:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $75
8010636c:	6a 4b                	push   $0x4b
  jmp alltraps
8010636e:	e9 77 f8 ff ff       	jmp    80105bea <alltraps>

80106373 <vector76>:
.globl vector76
vector76:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $76
80106375:	6a 4c                	push   $0x4c
  jmp alltraps
80106377:	e9 6e f8 ff ff       	jmp    80105bea <alltraps>

8010637c <vector77>:
.globl vector77
vector77:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $77
8010637e:	6a 4d                	push   $0x4d
  jmp alltraps
80106380:	e9 65 f8 ff ff       	jmp    80105bea <alltraps>

80106385 <vector78>:
.globl vector78
vector78:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $78
80106387:	6a 4e                	push   $0x4e
  jmp alltraps
80106389:	e9 5c f8 ff ff       	jmp    80105bea <alltraps>

8010638e <vector79>:
.globl vector79
vector79:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $79
80106390:	6a 4f                	push   $0x4f
  jmp alltraps
80106392:	e9 53 f8 ff ff       	jmp    80105bea <alltraps>

80106397 <vector80>:
.globl vector80
vector80:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $80
80106399:	6a 50                	push   $0x50
  jmp alltraps
8010639b:	e9 4a f8 ff ff       	jmp    80105bea <alltraps>

801063a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $81
801063a2:	6a 51                	push   $0x51
  jmp alltraps
801063a4:	e9 41 f8 ff ff       	jmp    80105bea <alltraps>

801063a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $82
801063ab:	6a 52                	push   $0x52
  jmp alltraps
801063ad:	e9 38 f8 ff ff       	jmp    80105bea <alltraps>

801063b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $83
801063b4:	6a 53                	push   $0x53
  jmp alltraps
801063b6:	e9 2f f8 ff ff       	jmp    80105bea <alltraps>

801063bb <vector84>:
.globl vector84
vector84:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $84
801063bd:	6a 54                	push   $0x54
  jmp alltraps
801063bf:	e9 26 f8 ff ff       	jmp    80105bea <alltraps>

801063c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $85
801063c6:	6a 55                	push   $0x55
  jmp alltraps
801063c8:	e9 1d f8 ff ff       	jmp    80105bea <alltraps>

801063cd <vector86>:
.globl vector86
vector86:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $86
801063cf:	6a 56                	push   $0x56
  jmp alltraps
801063d1:	e9 14 f8 ff ff       	jmp    80105bea <alltraps>

801063d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $87
801063d8:	6a 57                	push   $0x57
  jmp alltraps
801063da:	e9 0b f8 ff ff       	jmp    80105bea <alltraps>

801063df <vector88>:
.globl vector88
vector88:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $88
801063e1:	6a 58                	push   $0x58
  jmp alltraps
801063e3:	e9 02 f8 ff ff       	jmp    80105bea <alltraps>

801063e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $89
801063ea:	6a 59                	push   $0x59
  jmp alltraps
801063ec:	e9 f9 f7 ff ff       	jmp    80105bea <alltraps>

801063f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $90
801063f3:	6a 5a                	push   $0x5a
  jmp alltraps
801063f5:	e9 f0 f7 ff ff       	jmp    80105bea <alltraps>

801063fa <vector91>:
.globl vector91
vector91:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $91
801063fc:	6a 5b                	push   $0x5b
  jmp alltraps
801063fe:	e9 e7 f7 ff ff       	jmp    80105bea <alltraps>

80106403 <vector92>:
.globl vector92
vector92:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $92
80106405:	6a 5c                	push   $0x5c
  jmp alltraps
80106407:	e9 de f7 ff ff       	jmp    80105bea <alltraps>

8010640c <vector93>:
.globl vector93
vector93:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $93
8010640e:	6a 5d                	push   $0x5d
  jmp alltraps
80106410:	e9 d5 f7 ff ff       	jmp    80105bea <alltraps>

80106415 <vector94>:
.globl vector94
vector94:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $94
80106417:	6a 5e                	push   $0x5e
  jmp alltraps
80106419:	e9 cc f7 ff ff       	jmp    80105bea <alltraps>

8010641e <vector95>:
.globl vector95
vector95:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $95
80106420:	6a 5f                	push   $0x5f
  jmp alltraps
80106422:	e9 c3 f7 ff ff       	jmp    80105bea <alltraps>

80106427 <vector96>:
.globl vector96
vector96:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $96
80106429:	6a 60                	push   $0x60
  jmp alltraps
8010642b:	e9 ba f7 ff ff       	jmp    80105bea <alltraps>

80106430 <vector97>:
.globl vector97
vector97:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $97
80106432:	6a 61                	push   $0x61
  jmp alltraps
80106434:	e9 b1 f7 ff ff       	jmp    80105bea <alltraps>

80106439 <vector98>:
.globl vector98
vector98:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $98
8010643b:	6a 62                	push   $0x62
  jmp alltraps
8010643d:	e9 a8 f7 ff ff       	jmp    80105bea <alltraps>

80106442 <vector99>:
.globl vector99
vector99:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $99
80106444:	6a 63                	push   $0x63
  jmp alltraps
80106446:	e9 9f f7 ff ff       	jmp    80105bea <alltraps>

8010644b <vector100>:
.globl vector100
vector100:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $100
8010644d:	6a 64                	push   $0x64
  jmp alltraps
8010644f:	e9 96 f7 ff ff       	jmp    80105bea <alltraps>

80106454 <vector101>:
.globl vector101
vector101:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $101
80106456:	6a 65                	push   $0x65
  jmp alltraps
80106458:	e9 8d f7 ff ff       	jmp    80105bea <alltraps>

8010645d <vector102>:
.globl vector102
vector102:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $102
8010645f:	6a 66                	push   $0x66
  jmp alltraps
80106461:	e9 84 f7 ff ff       	jmp    80105bea <alltraps>

80106466 <vector103>:
.globl vector103
vector103:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $103
80106468:	6a 67                	push   $0x67
  jmp alltraps
8010646a:	e9 7b f7 ff ff       	jmp    80105bea <alltraps>

8010646f <vector104>:
.globl vector104
vector104:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $104
80106471:	6a 68                	push   $0x68
  jmp alltraps
80106473:	e9 72 f7 ff ff       	jmp    80105bea <alltraps>

80106478 <vector105>:
.globl vector105
vector105:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $105
8010647a:	6a 69                	push   $0x69
  jmp alltraps
8010647c:	e9 69 f7 ff ff       	jmp    80105bea <alltraps>

80106481 <vector106>:
.globl vector106
vector106:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $106
80106483:	6a 6a                	push   $0x6a
  jmp alltraps
80106485:	e9 60 f7 ff ff       	jmp    80105bea <alltraps>

8010648a <vector107>:
.globl vector107
vector107:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $107
8010648c:	6a 6b                	push   $0x6b
  jmp alltraps
8010648e:	e9 57 f7 ff ff       	jmp    80105bea <alltraps>

80106493 <vector108>:
.globl vector108
vector108:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $108
80106495:	6a 6c                	push   $0x6c
  jmp alltraps
80106497:	e9 4e f7 ff ff       	jmp    80105bea <alltraps>

8010649c <vector109>:
.globl vector109
vector109:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $109
8010649e:	6a 6d                	push   $0x6d
  jmp alltraps
801064a0:	e9 45 f7 ff ff       	jmp    80105bea <alltraps>

801064a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $110
801064a7:	6a 6e                	push   $0x6e
  jmp alltraps
801064a9:	e9 3c f7 ff ff       	jmp    80105bea <alltraps>

801064ae <vector111>:
.globl vector111
vector111:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $111
801064b0:	6a 6f                	push   $0x6f
  jmp alltraps
801064b2:	e9 33 f7 ff ff       	jmp    80105bea <alltraps>

801064b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $112
801064b9:	6a 70                	push   $0x70
  jmp alltraps
801064bb:	e9 2a f7 ff ff       	jmp    80105bea <alltraps>

801064c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $113
801064c2:	6a 71                	push   $0x71
  jmp alltraps
801064c4:	e9 21 f7 ff ff       	jmp    80105bea <alltraps>

801064c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $114
801064cb:	6a 72                	push   $0x72
  jmp alltraps
801064cd:	e9 18 f7 ff ff       	jmp    80105bea <alltraps>

801064d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $115
801064d4:	6a 73                	push   $0x73
  jmp alltraps
801064d6:	e9 0f f7 ff ff       	jmp    80105bea <alltraps>

801064db <vector116>:
.globl vector116
vector116:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $116
801064dd:	6a 74                	push   $0x74
  jmp alltraps
801064df:	e9 06 f7 ff ff       	jmp    80105bea <alltraps>

801064e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $117
801064e6:	6a 75                	push   $0x75
  jmp alltraps
801064e8:	e9 fd f6 ff ff       	jmp    80105bea <alltraps>

801064ed <vector118>:
.globl vector118
vector118:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $118
801064ef:	6a 76                	push   $0x76
  jmp alltraps
801064f1:	e9 f4 f6 ff ff       	jmp    80105bea <alltraps>

801064f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $119
801064f8:	6a 77                	push   $0x77
  jmp alltraps
801064fa:	e9 eb f6 ff ff       	jmp    80105bea <alltraps>

801064ff <vector120>:
.globl vector120
vector120:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $120
80106501:	6a 78                	push   $0x78
  jmp alltraps
80106503:	e9 e2 f6 ff ff       	jmp    80105bea <alltraps>

80106508 <vector121>:
.globl vector121
vector121:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $121
8010650a:	6a 79                	push   $0x79
  jmp alltraps
8010650c:	e9 d9 f6 ff ff       	jmp    80105bea <alltraps>

80106511 <vector122>:
.globl vector122
vector122:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $122
80106513:	6a 7a                	push   $0x7a
  jmp alltraps
80106515:	e9 d0 f6 ff ff       	jmp    80105bea <alltraps>

8010651a <vector123>:
.globl vector123
vector123:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $123
8010651c:	6a 7b                	push   $0x7b
  jmp alltraps
8010651e:	e9 c7 f6 ff ff       	jmp    80105bea <alltraps>

80106523 <vector124>:
.globl vector124
vector124:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $124
80106525:	6a 7c                	push   $0x7c
  jmp alltraps
80106527:	e9 be f6 ff ff       	jmp    80105bea <alltraps>

8010652c <vector125>:
.globl vector125
vector125:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $125
8010652e:	6a 7d                	push   $0x7d
  jmp alltraps
80106530:	e9 b5 f6 ff ff       	jmp    80105bea <alltraps>

80106535 <vector126>:
.globl vector126
vector126:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $126
80106537:	6a 7e                	push   $0x7e
  jmp alltraps
80106539:	e9 ac f6 ff ff       	jmp    80105bea <alltraps>

8010653e <vector127>:
.globl vector127
vector127:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $127
80106540:	6a 7f                	push   $0x7f
  jmp alltraps
80106542:	e9 a3 f6 ff ff       	jmp    80105bea <alltraps>

80106547 <vector128>:
.globl vector128
vector128:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $128
80106549:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010654e:	e9 97 f6 ff ff       	jmp    80105bea <alltraps>

80106553 <vector129>:
.globl vector129
vector129:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $129
80106555:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010655a:	e9 8b f6 ff ff       	jmp    80105bea <alltraps>

8010655f <vector130>:
.globl vector130
vector130:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $130
80106561:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106566:	e9 7f f6 ff ff       	jmp    80105bea <alltraps>

8010656b <vector131>:
.globl vector131
vector131:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $131
8010656d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106572:	e9 73 f6 ff ff       	jmp    80105bea <alltraps>

80106577 <vector132>:
.globl vector132
vector132:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $132
80106579:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010657e:	e9 67 f6 ff ff       	jmp    80105bea <alltraps>

80106583 <vector133>:
.globl vector133
vector133:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $133
80106585:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010658a:	e9 5b f6 ff ff       	jmp    80105bea <alltraps>

8010658f <vector134>:
.globl vector134
vector134:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $134
80106591:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106596:	e9 4f f6 ff ff       	jmp    80105bea <alltraps>

8010659b <vector135>:
.globl vector135
vector135:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $135
8010659d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065a2:	e9 43 f6 ff ff       	jmp    80105bea <alltraps>

801065a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $136
801065a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ae:	e9 37 f6 ff ff       	jmp    80105bea <alltraps>

801065b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $137
801065b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065ba:	e9 2b f6 ff ff       	jmp    80105bea <alltraps>

801065bf <vector138>:
.globl vector138
vector138:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $138
801065c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065c6:	e9 1f f6 ff ff       	jmp    80105bea <alltraps>

801065cb <vector139>:
.globl vector139
vector139:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $139
801065cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065d2:	e9 13 f6 ff ff       	jmp    80105bea <alltraps>

801065d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $140
801065d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065de:	e9 07 f6 ff ff       	jmp    80105bea <alltraps>

801065e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $141
801065e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801065ea:	e9 fb f5 ff ff       	jmp    80105bea <alltraps>

801065ef <vector142>:
.globl vector142
vector142:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $142
801065f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801065f6:	e9 ef f5 ff ff       	jmp    80105bea <alltraps>

801065fb <vector143>:
.globl vector143
vector143:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $143
801065fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106602:	e9 e3 f5 ff ff       	jmp    80105bea <alltraps>

80106607 <vector144>:
.globl vector144
vector144:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $144
80106609:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010660e:	e9 d7 f5 ff ff       	jmp    80105bea <alltraps>

80106613 <vector145>:
.globl vector145
vector145:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $145
80106615:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010661a:	e9 cb f5 ff ff       	jmp    80105bea <alltraps>

8010661f <vector146>:
.globl vector146
vector146:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $146
80106621:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106626:	e9 bf f5 ff ff       	jmp    80105bea <alltraps>

8010662b <vector147>:
.globl vector147
vector147:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $147
8010662d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106632:	e9 b3 f5 ff ff       	jmp    80105bea <alltraps>

80106637 <vector148>:
.globl vector148
vector148:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $148
80106639:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010663e:	e9 a7 f5 ff ff       	jmp    80105bea <alltraps>

80106643 <vector149>:
.globl vector149
vector149:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $149
80106645:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010664a:	e9 9b f5 ff ff       	jmp    80105bea <alltraps>

8010664f <vector150>:
.globl vector150
vector150:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $150
80106651:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106656:	e9 8f f5 ff ff       	jmp    80105bea <alltraps>

8010665b <vector151>:
.globl vector151
vector151:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $151
8010665d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106662:	e9 83 f5 ff ff       	jmp    80105bea <alltraps>

80106667 <vector152>:
.globl vector152
vector152:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $152
80106669:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010666e:	e9 77 f5 ff ff       	jmp    80105bea <alltraps>

80106673 <vector153>:
.globl vector153
vector153:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $153
80106675:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010667a:	e9 6b f5 ff ff       	jmp    80105bea <alltraps>

8010667f <vector154>:
.globl vector154
vector154:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $154
80106681:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106686:	e9 5f f5 ff ff       	jmp    80105bea <alltraps>

8010668b <vector155>:
.globl vector155
vector155:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $155
8010668d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106692:	e9 53 f5 ff ff       	jmp    80105bea <alltraps>

80106697 <vector156>:
.globl vector156
vector156:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $156
80106699:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010669e:	e9 47 f5 ff ff       	jmp    80105bea <alltraps>

801066a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $157
801066a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066aa:	e9 3b f5 ff ff       	jmp    80105bea <alltraps>

801066af <vector158>:
.globl vector158
vector158:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $158
801066b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066b6:	e9 2f f5 ff ff       	jmp    80105bea <alltraps>

801066bb <vector159>:
.globl vector159
vector159:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $159
801066bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066c2:	e9 23 f5 ff ff       	jmp    80105bea <alltraps>

801066c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $160
801066c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066ce:	e9 17 f5 ff ff       	jmp    80105bea <alltraps>

801066d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $161
801066d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066da:	e9 0b f5 ff ff       	jmp    80105bea <alltraps>

801066df <vector162>:
.globl vector162
vector162:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $162
801066e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801066e6:	e9 ff f4 ff ff       	jmp    80105bea <alltraps>

801066eb <vector163>:
.globl vector163
vector163:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $163
801066ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801066f2:	e9 f3 f4 ff ff       	jmp    80105bea <alltraps>

801066f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $164
801066f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801066fe:	e9 e7 f4 ff ff       	jmp    80105bea <alltraps>

80106703 <vector165>:
.globl vector165
vector165:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $165
80106705:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010670a:	e9 db f4 ff ff       	jmp    80105bea <alltraps>

8010670f <vector166>:
.globl vector166
vector166:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $166
80106711:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106716:	e9 cf f4 ff ff       	jmp    80105bea <alltraps>

8010671b <vector167>:
.globl vector167
vector167:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $167
8010671d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106722:	e9 c3 f4 ff ff       	jmp    80105bea <alltraps>

80106727 <vector168>:
.globl vector168
vector168:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $168
80106729:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010672e:	e9 b7 f4 ff ff       	jmp    80105bea <alltraps>

80106733 <vector169>:
.globl vector169
vector169:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $169
80106735:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010673a:	e9 ab f4 ff ff       	jmp    80105bea <alltraps>

8010673f <vector170>:
.globl vector170
vector170:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $170
80106741:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106746:	e9 9f f4 ff ff       	jmp    80105bea <alltraps>

8010674b <vector171>:
.globl vector171
vector171:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $171
8010674d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106752:	e9 93 f4 ff ff       	jmp    80105bea <alltraps>

80106757 <vector172>:
.globl vector172
vector172:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $172
80106759:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010675e:	e9 87 f4 ff ff       	jmp    80105bea <alltraps>

80106763 <vector173>:
.globl vector173
vector173:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $173
80106765:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010676a:	e9 7b f4 ff ff       	jmp    80105bea <alltraps>

8010676f <vector174>:
.globl vector174
vector174:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $174
80106771:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106776:	e9 6f f4 ff ff       	jmp    80105bea <alltraps>

8010677b <vector175>:
.globl vector175
vector175:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $175
8010677d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106782:	e9 63 f4 ff ff       	jmp    80105bea <alltraps>

80106787 <vector176>:
.globl vector176
vector176:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $176
80106789:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010678e:	e9 57 f4 ff ff       	jmp    80105bea <alltraps>

80106793 <vector177>:
.globl vector177
vector177:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $177
80106795:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010679a:	e9 4b f4 ff ff       	jmp    80105bea <alltraps>

8010679f <vector178>:
.globl vector178
vector178:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $178
801067a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067a6:	e9 3f f4 ff ff       	jmp    80105bea <alltraps>

801067ab <vector179>:
.globl vector179
vector179:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $179
801067ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067b2:	e9 33 f4 ff ff       	jmp    80105bea <alltraps>

801067b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $180
801067b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067be:	e9 27 f4 ff ff       	jmp    80105bea <alltraps>

801067c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $181
801067c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067ca:	e9 1b f4 ff ff       	jmp    80105bea <alltraps>

801067cf <vector182>:
.globl vector182
vector182:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $182
801067d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067d6:	e9 0f f4 ff ff       	jmp    80105bea <alltraps>

801067db <vector183>:
.globl vector183
vector183:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $183
801067dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801067e2:	e9 03 f4 ff ff       	jmp    80105bea <alltraps>

801067e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $184
801067e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801067ee:	e9 f7 f3 ff ff       	jmp    80105bea <alltraps>

801067f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $185
801067f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801067fa:	e9 eb f3 ff ff       	jmp    80105bea <alltraps>

801067ff <vector186>:
.globl vector186
vector186:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $186
80106801:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106806:	e9 df f3 ff ff       	jmp    80105bea <alltraps>

8010680b <vector187>:
.globl vector187
vector187:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $187
8010680d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106812:	e9 d3 f3 ff ff       	jmp    80105bea <alltraps>

80106817 <vector188>:
.globl vector188
vector188:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $188
80106819:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010681e:	e9 c7 f3 ff ff       	jmp    80105bea <alltraps>

80106823 <vector189>:
.globl vector189
vector189:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $189
80106825:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010682a:	e9 bb f3 ff ff       	jmp    80105bea <alltraps>

8010682f <vector190>:
.globl vector190
vector190:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $190
80106831:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106836:	e9 af f3 ff ff       	jmp    80105bea <alltraps>

8010683b <vector191>:
.globl vector191
vector191:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $191
8010683d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106842:	e9 a3 f3 ff ff       	jmp    80105bea <alltraps>

80106847 <vector192>:
.globl vector192
vector192:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $192
80106849:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010684e:	e9 97 f3 ff ff       	jmp    80105bea <alltraps>

80106853 <vector193>:
.globl vector193
vector193:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $193
80106855:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010685a:	e9 8b f3 ff ff       	jmp    80105bea <alltraps>

8010685f <vector194>:
.globl vector194
vector194:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $194
80106861:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106866:	e9 7f f3 ff ff       	jmp    80105bea <alltraps>

8010686b <vector195>:
.globl vector195
vector195:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $195
8010686d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106872:	e9 73 f3 ff ff       	jmp    80105bea <alltraps>

80106877 <vector196>:
.globl vector196
vector196:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $196
80106879:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010687e:	e9 67 f3 ff ff       	jmp    80105bea <alltraps>

80106883 <vector197>:
.globl vector197
vector197:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $197
80106885:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010688a:	e9 5b f3 ff ff       	jmp    80105bea <alltraps>

8010688f <vector198>:
.globl vector198
vector198:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $198
80106891:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106896:	e9 4f f3 ff ff       	jmp    80105bea <alltraps>

8010689b <vector199>:
.globl vector199
vector199:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $199
8010689d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068a2:	e9 43 f3 ff ff       	jmp    80105bea <alltraps>

801068a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $200
801068a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ae:	e9 37 f3 ff ff       	jmp    80105bea <alltraps>

801068b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $201
801068b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068ba:	e9 2b f3 ff ff       	jmp    80105bea <alltraps>

801068bf <vector202>:
.globl vector202
vector202:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $202
801068c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068c6:	e9 1f f3 ff ff       	jmp    80105bea <alltraps>

801068cb <vector203>:
.globl vector203
vector203:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $203
801068cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068d2:	e9 13 f3 ff ff       	jmp    80105bea <alltraps>

801068d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $204
801068d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068de:	e9 07 f3 ff ff       	jmp    80105bea <alltraps>

801068e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $205
801068e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801068ea:	e9 fb f2 ff ff       	jmp    80105bea <alltraps>

801068ef <vector206>:
.globl vector206
vector206:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $206
801068f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801068f6:	e9 ef f2 ff ff       	jmp    80105bea <alltraps>

801068fb <vector207>:
.globl vector207
vector207:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $207
801068fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106902:	e9 e3 f2 ff ff       	jmp    80105bea <alltraps>

80106907 <vector208>:
.globl vector208
vector208:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $208
80106909:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010690e:	e9 d7 f2 ff ff       	jmp    80105bea <alltraps>

80106913 <vector209>:
.globl vector209
vector209:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $209
80106915:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010691a:	e9 cb f2 ff ff       	jmp    80105bea <alltraps>

8010691f <vector210>:
.globl vector210
vector210:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $210
80106921:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106926:	e9 bf f2 ff ff       	jmp    80105bea <alltraps>

8010692b <vector211>:
.globl vector211
vector211:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $211
8010692d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106932:	e9 b3 f2 ff ff       	jmp    80105bea <alltraps>

80106937 <vector212>:
.globl vector212
vector212:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $212
80106939:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010693e:	e9 a7 f2 ff ff       	jmp    80105bea <alltraps>

80106943 <vector213>:
.globl vector213
vector213:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $213
80106945:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010694a:	e9 9b f2 ff ff       	jmp    80105bea <alltraps>

8010694f <vector214>:
.globl vector214
vector214:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $214
80106951:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106956:	e9 8f f2 ff ff       	jmp    80105bea <alltraps>

8010695b <vector215>:
.globl vector215
vector215:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $215
8010695d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106962:	e9 83 f2 ff ff       	jmp    80105bea <alltraps>

80106967 <vector216>:
.globl vector216
vector216:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $216
80106969:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010696e:	e9 77 f2 ff ff       	jmp    80105bea <alltraps>

80106973 <vector217>:
.globl vector217
vector217:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $217
80106975:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010697a:	e9 6b f2 ff ff       	jmp    80105bea <alltraps>

8010697f <vector218>:
.globl vector218
vector218:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $218
80106981:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106986:	e9 5f f2 ff ff       	jmp    80105bea <alltraps>

8010698b <vector219>:
.globl vector219
vector219:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $219
8010698d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106992:	e9 53 f2 ff ff       	jmp    80105bea <alltraps>

80106997 <vector220>:
.globl vector220
vector220:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $220
80106999:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010699e:	e9 47 f2 ff ff       	jmp    80105bea <alltraps>

801069a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $221
801069a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069aa:	e9 3b f2 ff ff       	jmp    80105bea <alltraps>

801069af <vector222>:
.globl vector222
vector222:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $222
801069b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069b6:	e9 2f f2 ff ff       	jmp    80105bea <alltraps>

801069bb <vector223>:
.globl vector223
vector223:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $223
801069bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069c2:	e9 23 f2 ff ff       	jmp    80105bea <alltraps>

801069c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $224
801069c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069ce:	e9 17 f2 ff ff       	jmp    80105bea <alltraps>

801069d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $225
801069d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069da:	e9 0b f2 ff ff       	jmp    80105bea <alltraps>

801069df <vector226>:
.globl vector226
vector226:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $226
801069e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801069e6:	e9 ff f1 ff ff       	jmp    80105bea <alltraps>

801069eb <vector227>:
.globl vector227
vector227:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $227
801069ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801069f2:	e9 f3 f1 ff ff       	jmp    80105bea <alltraps>

801069f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $228
801069f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801069fe:	e9 e7 f1 ff ff       	jmp    80105bea <alltraps>

80106a03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $229
80106a05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a0a:	e9 db f1 ff ff       	jmp    80105bea <alltraps>

80106a0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $230
80106a11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a16:	e9 cf f1 ff ff       	jmp    80105bea <alltraps>

80106a1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $231
80106a1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a22:	e9 c3 f1 ff ff       	jmp    80105bea <alltraps>

80106a27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $232
80106a29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a2e:	e9 b7 f1 ff ff       	jmp    80105bea <alltraps>

80106a33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $233
80106a35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a3a:	e9 ab f1 ff ff       	jmp    80105bea <alltraps>

80106a3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $234
80106a41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a46:	e9 9f f1 ff ff       	jmp    80105bea <alltraps>

80106a4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $235
80106a4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a52:	e9 93 f1 ff ff       	jmp    80105bea <alltraps>

80106a57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $236
80106a59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a5e:	e9 87 f1 ff ff       	jmp    80105bea <alltraps>

80106a63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $237
80106a65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a6a:	e9 7b f1 ff ff       	jmp    80105bea <alltraps>

80106a6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $238
80106a71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a76:	e9 6f f1 ff ff       	jmp    80105bea <alltraps>

80106a7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $239
80106a7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a82:	e9 63 f1 ff ff       	jmp    80105bea <alltraps>

80106a87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $240
80106a89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a8e:	e9 57 f1 ff ff       	jmp    80105bea <alltraps>

80106a93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $241
80106a95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a9a:	e9 4b f1 ff ff       	jmp    80105bea <alltraps>

80106a9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $242
80106aa1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106aa6:	e9 3f f1 ff ff       	jmp    80105bea <alltraps>

80106aab <vector243>:
.globl vector243
vector243:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $243
80106aad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ab2:	e9 33 f1 ff ff       	jmp    80105bea <alltraps>

80106ab7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $244
80106ab9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106abe:	e9 27 f1 ff ff       	jmp    80105bea <alltraps>

80106ac3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $245
80106ac5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106aca:	e9 1b f1 ff ff       	jmp    80105bea <alltraps>

80106acf <vector246>:
.globl vector246
vector246:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $246
80106ad1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ad6:	e9 0f f1 ff ff       	jmp    80105bea <alltraps>

80106adb <vector247>:
.globl vector247
vector247:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $247
80106add:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ae2:	e9 03 f1 ff ff       	jmp    80105bea <alltraps>

80106ae7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $248
80106ae9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106aee:	e9 f7 f0 ff ff       	jmp    80105bea <alltraps>

80106af3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $249
80106af5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106afa:	e9 eb f0 ff ff       	jmp    80105bea <alltraps>

80106aff <vector250>:
.globl vector250
vector250:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $250
80106b01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b06:	e9 df f0 ff ff       	jmp    80105bea <alltraps>

80106b0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $251
80106b0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b12:	e9 d3 f0 ff ff       	jmp    80105bea <alltraps>

80106b17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $252
80106b19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b1e:	e9 c7 f0 ff ff       	jmp    80105bea <alltraps>

80106b23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $253
80106b25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b2a:	e9 bb f0 ff ff       	jmp    80105bea <alltraps>

80106b2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $254
80106b31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b36:	e9 af f0 ff ff       	jmp    80105bea <alltraps>

80106b3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $255
80106b3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b42:	e9 a3 f0 ff ff       	jmp    80105bea <alltraps>
80106b47:	66 90                	xchg   %ax,%ax
80106b49:	66 90                	xchg   %ax,%ax
80106b4b:	66 90                	xchg   %ax,%ax
80106b4d:	66 90                	xchg   %ax,%ax
80106b4f:	90                   	nop

80106b50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b5c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b62:	83 ec 1c             	sub    $0x1c,%esp
80106b65:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b68:	39 d3                	cmp    %edx,%ebx
80106b6a:	73 49                	jae    80106bb5 <deallocuvm.part.0+0x65>
80106b6c:	89 c7                	mov    %eax,%edi
80106b6e:	eb 0c                	jmp    80106b7c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b70:	83 c0 01             	add    $0x1,%eax
80106b73:	c1 e0 16             	shl    $0x16,%eax
80106b76:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b78:	39 da                	cmp    %ebx,%edx
80106b7a:	76 39                	jbe    80106bb5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106b7c:	89 d8                	mov    %ebx,%eax
80106b7e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b81:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106b84:	f6 c1 01             	test   $0x1,%cl
80106b87:	74 e7                	je     80106b70 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b89:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b8b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106b91:	c1 ee 0a             	shr    $0xa,%esi
80106b94:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b9a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106ba1:	85 f6                	test   %esi,%esi
80106ba3:	74 cb                	je     80106b70 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106ba5:	8b 06                	mov    (%esi),%eax
80106ba7:	a8 01                	test   $0x1,%al
80106ba9:	75 15                	jne    80106bc0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106bab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bb1:	39 da                	cmp    %ebx,%edx
80106bb3:	77 c7                	ja     80106b7c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bbb:	5b                   	pop    %ebx
80106bbc:	5e                   	pop    %esi
80106bbd:	5f                   	pop    %edi
80106bbe:	5d                   	pop    %ebp
80106bbf:	c3                   	ret    
      if(pa == 0)
80106bc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bc5:	74 25                	je     80106bec <deallocuvm.part.0+0x9c>
      kfree(v);
80106bc7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bca:	05 00 00 00 80       	add    $0x80000000,%eax
80106bcf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bd2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106bd8:	50                   	push   %eax
80106bd9:	e8 92 bc ff ff       	call   80102870 <kfree>
      *pte = 0;
80106bde:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106be4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106be7:	83 c4 10             	add    $0x10,%esp
80106bea:	eb 8c                	jmp    80106b78 <deallocuvm.part.0+0x28>
        panic("kfree");
80106bec:	83 ec 0c             	sub    $0xc,%esp
80106bef:	68 ea 77 10 80       	push   $0x801077ea
80106bf4:	e8 c7 97 ff ff       	call   801003c0 <panic>
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <mappages>:
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106c06:	89 d3                	mov    %edx,%ebx
80106c08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c0e:	83 ec 1c             	sub    $0x1c,%esp
80106c11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c20:	8b 45 08             	mov    0x8(%ebp),%eax
80106c23:	29 d8                	sub    %ebx,%eax
80106c25:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c28:	eb 3d                	jmp    80106c67 <mappages+0x67>
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c30:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c37:	c1 ea 0a             	shr    $0xa,%edx
80106c3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c40:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c47:	85 c0                	test   %eax,%eax
80106c49:	74 75                	je     80106cc0 <mappages+0xc0>
    if(*pte & PTE_P)
80106c4b:	f6 00 01             	testb  $0x1,(%eax)
80106c4e:	0f 85 86 00 00 00    	jne    80106cda <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106c54:	0b 75 0c             	or     0xc(%ebp),%esi
80106c57:	83 ce 01             	or     $0x1,%esi
80106c5a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c5c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106c5f:	74 6f                	je     80106cd0 <mappages+0xd0>
    a += PGSIZE;
80106c61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c6a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c6d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c70:	89 d8                	mov    %ebx,%eax
80106c72:	c1 e8 16             	shr    $0x16,%eax
80106c75:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c78:	8b 07                	mov    (%edi),%eax
80106c7a:	a8 01                	test   $0x1,%al
80106c7c:	75 b2                	jne    80106c30 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c7e:	e8 ad bd ff ff       	call   80102a30 <kalloc>
80106c83:	85 c0                	test   %eax,%eax
80106c85:	74 39                	je     80106cc0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c87:	83 ec 04             	sub    $0x4,%esp
80106c8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c8d:	68 00 10 00 00       	push   $0x1000
80106c92:	6a 00                	push   $0x0
80106c94:	50                   	push   %eax
80106c95:	e8 76 dd ff ff       	call   80104a10 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c9d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ca0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ca6:	83 c8 07             	or     $0x7,%eax
80106ca9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106cab:	89 d8                	mov    %ebx,%eax
80106cad:	c1 e8 0a             	shr    $0xa,%eax
80106cb0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cb5:	01 d0                	add    %edx,%eax
80106cb7:	eb 92                	jmp    80106c4b <mappages+0x4b>
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc8:	5b                   	pop    %ebx
80106cc9:	5e                   	pop    %esi
80106cca:	5f                   	pop    %edi
80106ccb:	5d                   	pop    %ebp
80106ccc:	c3                   	ret    
80106ccd:	8d 76 00             	lea    0x0(%esi),%esi
80106cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cd3:	31 c0                	xor    %eax,%eax
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret    
      panic("remap");
80106cda:	83 ec 0c             	sub    $0xc,%esp
80106cdd:	68 28 7e 10 80       	push   $0x80107e28
80106ce2:	e8 d9 96 ff ff       	call   801003c0 <panic>
80106ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cee:	66 90                	xchg   %ax,%ax

80106cf0 <seginit>:
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106cf6:	e8 05 d0 ff ff       	call   80103d00 <cpuid>
  pd[0] = size-1;
80106cfb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d00:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d06:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d0a:	c7 80 d8 1d 11 80 ff 	movl   $0xffff,-0x7feee228(%eax)
80106d11:	ff 00 00 
80106d14:	c7 80 dc 1d 11 80 00 	movl   $0xcf9a00,-0x7feee224(%eax)
80106d1b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d1e:	c7 80 e0 1d 11 80 ff 	movl   $0xffff,-0x7feee220(%eax)
80106d25:	ff 00 00 
80106d28:	c7 80 e4 1d 11 80 00 	movl   $0xcf9200,-0x7feee21c(%eax)
80106d2f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d32:	c7 80 e8 1d 11 80 ff 	movl   $0xffff,-0x7feee218(%eax)
80106d39:	ff 00 00 
80106d3c:	c7 80 ec 1d 11 80 00 	movl   $0xcffa00,-0x7feee214(%eax)
80106d43:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d46:	c7 80 f0 1d 11 80 ff 	movl   $0xffff,-0x7feee210(%eax)
80106d4d:	ff 00 00 
80106d50:	c7 80 f4 1d 11 80 00 	movl   $0xcff200,-0x7feee20c(%eax)
80106d57:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d5a:	05 d0 1d 11 80       	add    $0x80111dd0,%eax
  pd[1] = (uint)p;
80106d5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d63:	c1 e8 10             	shr    $0x10,%eax
80106d66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d6d:	0f 01 10             	lgdtl  (%eax)
}
80106d70:	c9                   	leave  
80106d71:	c3                   	ret    
80106d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d80:	a1 84 4a 11 80       	mov    0x80114a84,%eax
80106d85:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d8a:	0f 22 d8             	mov    %eax,%cr3
}
80106d8d:	c3                   	ret    
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <switchuvm>:
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 1c             	sub    $0x1c,%esp
80106d99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d9c:	85 f6                	test   %esi,%esi
80106d9e:	0f 84 cb 00 00 00    	je     80106e6f <switchuvm+0xdf>
  if(p->kstack == 0)
80106da4:	8b 46 08             	mov    0x8(%esi),%eax
80106da7:	85 c0                	test   %eax,%eax
80106da9:	0f 84 da 00 00 00    	je     80106e89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106daf:	8b 46 04             	mov    0x4(%esi),%eax
80106db2:	85 c0                	test   %eax,%eax
80106db4:	0f 84 c2 00 00 00    	je     80106e7c <switchuvm+0xec>
  pushcli();
80106dba:	e8 41 da ff ff       	call   80104800 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dbf:	e8 dc ce ff ff       	call   80103ca0 <mycpu>
80106dc4:	89 c3                	mov    %eax,%ebx
80106dc6:	e8 d5 ce ff ff       	call   80103ca0 <mycpu>
80106dcb:	89 c7                	mov    %eax,%edi
80106dcd:	e8 ce ce ff ff       	call   80103ca0 <mycpu>
80106dd2:	83 c7 08             	add    $0x8,%edi
80106dd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dd8:	e8 c3 ce ff ff       	call   80103ca0 <mycpu>
80106ddd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106de0:	ba 67 00 00 00       	mov    $0x67,%edx
80106de5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106dec:	83 c0 08             	add    $0x8,%eax
80106def:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106df6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dfb:	83 c1 08             	add    $0x8,%ecx
80106dfe:	c1 e8 18             	shr    $0x18,%eax
80106e01:	c1 e9 10             	shr    $0x10,%ecx
80106e04:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106e0a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106e10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e15:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106e21:	e8 7a ce ff ff       	call   80103ca0 <mycpu>
80106e26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e2d:	e8 6e ce ff ff       	call   80103ca0 <mycpu>
80106e32:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e36:	8b 5e 08             	mov    0x8(%esi),%ebx
80106e39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e3f:	e8 5c ce ff ff       	call   80103ca0 <mycpu>
80106e44:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e47:	e8 54 ce ff ff       	call   80103ca0 <mycpu>
80106e4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e50:	b8 28 00 00 00       	mov    $0x28,%eax
80106e55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e58:	8b 46 04             	mov    0x4(%esi),%eax
80106e5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e60:	0f 22 d8             	mov    %eax,%cr3
}
80106e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e66:	5b                   	pop    %ebx
80106e67:	5e                   	pop    %esi
80106e68:	5f                   	pop    %edi
80106e69:	5d                   	pop    %ebp
  popcli();
80106e6a:	e9 e1 d9 ff ff       	jmp    80104850 <popcli>
    panic("switchuvm: no process");
80106e6f:	83 ec 0c             	sub    $0xc,%esp
80106e72:	68 2e 7e 10 80       	push   $0x80107e2e
80106e77:	e8 44 95 ff ff       	call   801003c0 <panic>
    panic("switchuvm: no pgdir");
80106e7c:	83 ec 0c             	sub    $0xc,%esp
80106e7f:	68 59 7e 10 80       	push   $0x80107e59
80106e84:	e8 37 95 ff ff       	call   801003c0 <panic>
    panic("switchuvm: no kstack");
80106e89:	83 ec 0c             	sub    $0xc,%esp
80106e8c:	68 44 7e 10 80       	push   $0x80107e44
80106e91:	e8 2a 95 ff ff       	call   801003c0 <panic>
80106e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ea0 <inituvm>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 1c             	sub    $0x1c,%esp
80106ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eac:	8b 75 10             	mov    0x10(%ebp),%esi
80106eaf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106eb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106eb5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ebb:	77 4b                	ja     80106f08 <inituvm+0x68>
  mem = kalloc();
80106ebd:	e8 6e bb ff ff       	call   80102a30 <kalloc>
  memset(mem, 0, PGSIZE);
80106ec2:	83 ec 04             	sub    $0x4,%esp
80106ec5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106eca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ecc:	6a 00                	push   $0x0
80106ece:	50                   	push   %eax
80106ecf:	e8 3c db ff ff       	call   80104a10 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ed4:	58                   	pop    %eax
80106ed5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106edb:	5a                   	pop    %edx
80106edc:	6a 06                	push   $0x6
80106ede:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ee3:	31 d2                	xor    %edx,%edx
80106ee5:	50                   	push   %eax
80106ee6:	89 f8                	mov    %edi,%eax
80106ee8:	e8 13 fd ff ff       	call   80106c00 <mappages>
  memmove(mem, init, sz);
80106eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ef0:	89 75 10             	mov    %esi,0x10(%ebp)
80106ef3:	83 c4 10             	add    $0x10,%esp
80106ef6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ef9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eff:	5b                   	pop    %ebx
80106f00:	5e                   	pop    %esi
80106f01:	5f                   	pop    %edi
80106f02:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f03:	e9 a8 db ff ff       	jmp    80104ab0 <memmove>
    panic("inituvm: more than a page");
80106f08:	83 ec 0c             	sub    $0xc,%esp
80106f0b:	68 6d 7e 10 80       	push   $0x80107e6d
80106f10:	e8 ab 94 ff ff       	call   801003c0 <panic>
80106f15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f20 <loaduvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f2c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106f2f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106f34:	0f 85 bb 00 00 00    	jne    80106ff5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106f3a:	01 f0                	add    %esi,%eax
80106f3c:	89 f3                	mov    %esi,%ebx
80106f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f41:	8b 45 14             	mov    0x14(%ebp),%eax
80106f44:	01 f0                	add    %esi,%eax
80106f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106f49:	85 f6                	test   %esi,%esi
80106f4b:	0f 84 87 00 00 00    	je     80106fd8 <loaduvm+0xb8>
80106f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106f5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106f5e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f60:	89 c2                	mov    %eax,%edx
80106f62:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f65:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f68:	f6 c2 01             	test   $0x1,%dl
80106f6b:	75 13                	jne    80106f80 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f6d:	83 ec 0c             	sub    $0xc,%esp
80106f70:	68 87 7e 10 80       	push   $0x80107e87
80106f75:	e8 46 94 ff ff       	call   801003c0 <panic>
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f80:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f83:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f89:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f8e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f95:	85 c0                	test   %eax,%eax
80106f97:	74 d4                	je     80106f6d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f99:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f9b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f9e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fa3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fa8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106fae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fb1:	29 d9                	sub    %ebx,%ecx
80106fb3:	05 00 00 00 80       	add    $0x80000000,%eax
80106fb8:	57                   	push   %edi
80106fb9:	51                   	push   %ecx
80106fba:	50                   	push   %eax
80106fbb:	ff 75 10             	push   0x10(%ebp)
80106fbe:	e8 7d ae ff ff       	call   80101e40 <readi>
80106fc3:	83 c4 10             	add    $0x10,%esp
80106fc6:	39 f8                	cmp    %edi,%eax
80106fc8:	75 1e                	jne    80106fe8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106fca:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106fd0:	89 f0                	mov    %esi,%eax
80106fd2:	29 d8                	sub    %ebx,%eax
80106fd4:	39 c6                	cmp    %eax,%esi
80106fd6:	77 80                	ja     80106f58 <loaduvm+0x38>
}
80106fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fdb:	31 c0                	xor    %eax,%eax
}
80106fdd:	5b                   	pop    %ebx
80106fde:	5e                   	pop    %esi
80106fdf:	5f                   	pop    %edi
80106fe0:	5d                   	pop    %ebp
80106fe1:	c3                   	ret    
80106fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106feb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ff0:	5b                   	pop    %ebx
80106ff1:	5e                   	pop    %esi
80106ff2:	5f                   	pop    %edi
80106ff3:	5d                   	pop    %ebp
80106ff4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106ff5:	83 ec 0c             	sub    $0xc,%esp
80106ff8:	68 28 7f 10 80       	push   $0x80107f28
80106ffd:	e8 be 93 ff ff       	call   801003c0 <panic>
80107002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107010 <allocuvm>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107019:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010701c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010701f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107022:	85 c0                	test   %eax,%eax
80107024:	0f 88 b6 00 00 00    	js     801070e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010702a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010702d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107030:	0f 82 9a 00 00 00    	jb     801070d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107036:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010703c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107042:	39 75 10             	cmp    %esi,0x10(%ebp)
80107045:	77 44                	ja     8010708b <allocuvm+0x7b>
80107047:	e9 87 00 00 00       	jmp    801070d3 <allocuvm+0xc3>
8010704c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107050:	83 ec 04             	sub    $0x4,%esp
80107053:	68 00 10 00 00       	push   $0x1000
80107058:	6a 00                	push   $0x0
8010705a:	50                   	push   %eax
8010705b:	e8 b0 d9 ff ff       	call   80104a10 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107060:	58                   	pop    %eax
80107061:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107067:	5a                   	pop    %edx
80107068:	6a 06                	push   $0x6
8010706a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010706f:	89 f2                	mov    %esi,%edx
80107071:	50                   	push   %eax
80107072:	89 f8                	mov    %edi,%eax
80107074:	e8 87 fb ff ff       	call   80106c00 <mappages>
80107079:	83 c4 10             	add    $0x10,%esp
8010707c:	85 c0                	test   %eax,%eax
8010707e:	78 78                	js     801070f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107080:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107086:	39 75 10             	cmp    %esi,0x10(%ebp)
80107089:	76 48                	jbe    801070d3 <allocuvm+0xc3>
    mem = kalloc();
8010708b:	e8 a0 b9 ff ff       	call   80102a30 <kalloc>
80107090:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107092:	85 c0                	test   %eax,%eax
80107094:	75 ba                	jne    80107050 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107096:	83 ec 0c             	sub    $0xc,%esp
80107099:	68 a5 7e 10 80       	push   $0x80107ea5
8010709e:	e8 3d 96 ff ff       	call   801006e0 <cprintf>
  if(newsz >= oldsz)
801070a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a6:	83 c4 10             	add    $0x10,%esp
801070a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801070ac:	74 32                	je     801070e0 <allocuvm+0xd0>
801070ae:	8b 55 10             	mov    0x10(%ebp),%edx
801070b1:	89 c1                	mov    %eax,%ecx
801070b3:	89 f8                	mov    %edi,%eax
801070b5:	e8 96 fa ff ff       	call   80106b50 <deallocuvm.part.0>
      return 0;
801070ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c7:	5b                   	pop    %ebx
801070c8:	5e                   	pop    %esi
801070c9:	5f                   	pop    %edi
801070ca:	5d                   	pop    %ebp
801070cb:	c3                   	ret    
801070cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801070d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801070d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070d9:	5b                   	pop    %ebx
801070da:	5e                   	pop    %esi
801070db:	5f                   	pop    %edi
801070dc:	5d                   	pop    %ebp
801070dd:	c3                   	ret    
801070de:	66 90                	xchg   %ax,%ax
    return 0;
801070e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ed:	5b                   	pop    %ebx
801070ee:	5e                   	pop    %esi
801070ef:	5f                   	pop    %edi
801070f0:	5d                   	pop    %ebp
801070f1:	c3                   	ret    
801070f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801070f8:	83 ec 0c             	sub    $0xc,%esp
801070fb:	68 bd 7e 10 80       	push   $0x80107ebd
80107100:	e8 db 95 ff ff       	call   801006e0 <cprintf>
  if(newsz >= oldsz)
80107105:	8b 45 0c             	mov    0xc(%ebp),%eax
80107108:	83 c4 10             	add    $0x10,%esp
8010710b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010710e:	74 0c                	je     8010711c <allocuvm+0x10c>
80107110:	8b 55 10             	mov    0x10(%ebp),%edx
80107113:	89 c1                	mov    %eax,%ecx
80107115:	89 f8                	mov    %edi,%eax
80107117:	e8 34 fa ff ff       	call   80106b50 <deallocuvm.part.0>
      kfree(mem);
8010711c:	83 ec 0c             	sub    $0xc,%esp
8010711f:	53                   	push   %ebx
80107120:	e8 4b b7 ff ff       	call   80102870 <kfree>
      return 0;
80107125:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010712c:	83 c4 10             	add    $0x10,%esp
}
8010712f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107132:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107135:	5b                   	pop    %ebx
80107136:	5e                   	pop    %esi
80107137:	5f                   	pop    %edi
80107138:	5d                   	pop    %ebp
80107139:	c3                   	ret    
8010713a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107140 <deallocuvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	8b 55 0c             	mov    0xc(%ebp),%edx
80107146:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107149:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010714c:	39 d1                	cmp    %edx,%ecx
8010714e:	73 10                	jae    80107160 <deallocuvm+0x20>
}
80107150:	5d                   	pop    %ebp
80107151:	e9 fa f9 ff ff       	jmp    80106b50 <deallocuvm.part.0>
80107156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
80107160:	89 d0                	mov    %edx,%eax
80107162:	5d                   	pop    %ebp
80107163:	c3                   	ret    
80107164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010716f:	90                   	nop

80107170 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 0c             	sub    $0xc,%esp
80107179:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010717c:	85 f6                	test   %esi,%esi
8010717e:	74 59                	je     801071d9 <freevm+0x69>
  if(newsz >= oldsz)
80107180:	31 c9                	xor    %ecx,%ecx
80107182:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107187:	89 f0                	mov    %esi,%eax
80107189:	89 f3                	mov    %esi,%ebx
8010718b:	e8 c0 f9 ff ff       	call   80106b50 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107190:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107196:	eb 0f                	jmp    801071a7 <freevm+0x37>
80107198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010719f:	90                   	nop
801071a0:	83 c3 04             	add    $0x4,%ebx
801071a3:	39 df                	cmp    %ebx,%edi
801071a5:	74 23                	je     801071ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071a7:	8b 03                	mov    (%ebx),%eax
801071a9:	a8 01                	test   $0x1,%al
801071ab:	74 f3                	je     801071a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071bd:	50                   	push   %eax
801071be:	e8 ad b6 ff ff       	call   80102870 <kfree>
801071c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071c6:	39 df                	cmp    %ebx,%edi
801071c8:	75 dd                	jne    801071a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071d0:	5b                   	pop    %ebx
801071d1:	5e                   	pop    %esi
801071d2:	5f                   	pop    %edi
801071d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071d4:	e9 97 b6 ff ff       	jmp    80102870 <kfree>
    panic("freevm: no pgdir");
801071d9:	83 ec 0c             	sub    $0xc,%esp
801071dc:	68 d9 7e 10 80       	push   $0x80107ed9
801071e1:	e8 da 91 ff ff       	call   801003c0 <panic>
801071e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ed:	8d 76 00             	lea    0x0(%esi),%esi

801071f0 <setupkvm>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	56                   	push   %esi
801071f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801071f5:	e8 36 b8 ff ff       	call   80102a30 <kalloc>
801071fa:	89 c6                	mov    %eax,%esi
801071fc:	85 c0                	test   %eax,%eax
801071fe:	74 42                	je     80107242 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107200:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107203:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107208:	68 00 10 00 00       	push   $0x1000
8010720d:	6a 00                	push   $0x0
8010720f:	50                   	push   %eax
80107210:	e8 fb d7 ff ff       	call   80104a10 <memset>
80107215:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107218:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010721b:	83 ec 08             	sub    $0x8,%esp
8010721e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107221:	ff 73 0c             	push   0xc(%ebx)
80107224:	8b 13                	mov    (%ebx),%edx
80107226:	50                   	push   %eax
80107227:	29 c1                	sub    %eax,%ecx
80107229:	89 f0                	mov    %esi,%eax
8010722b:	e8 d0 f9 ff ff       	call   80106c00 <mappages>
80107230:	83 c4 10             	add    $0x10,%esp
80107233:	85 c0                	test   %eax,%eax
80107235:	78 19                	js     80107250 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107237:	83 c3 10             	add    $0x10,%ebx
8010723a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107240:	75 d6                	jne    80107218 <setupkvm+0x28>
}
80107242:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107245:	89 f0                	mov    %esi,%eax
80107247:	5b                   	pop    %ebx
80107248:	5e                   	pop    %esi
80107249:	5d                   	pop    %ebp
8010724a:	c3                   	ret    
8010724b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010724f:	90                   	nop
      freevm(pgdir);
80107250:	83 ec 0c             	sub    $0xc,%esp
80107253:	56                   	push   %esi
      return 0;
80107254:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107256:	e8 15 ff ff ff       	call   80107170 <freevm>
      return 0;
8010725b:	83 c4 10             	add    $0x10,%esp
}
8010725e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107261:	89 f0                	mov    %esi,%eax
80107263:	5b                   	pop    %ebx
80107264:	5e                   	pop    %esi
80107265:	5d                   	pop    %ebp
80107266:	c3                   	ret    
80107267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726e:	66 90                	xchg   %ax,%ax

80107270 <kvmalloc>:
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107276:	e8 75 ff ff ff       	call   801071f0 <setupkvm>
8010727b:	a3 84 4a 11 80       	mov    %eax,0x80114a84
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107280:	05 00 00 00 80       	add    $0x80000000,%eax
80107285:	0f 22 d8             	mov    %eax,%cr3
}
80107288:	c9                   	leave  
80107289:	c3                   	ret    
8010728a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107290 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 08             	sub    $0x8,%esp
80107296:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107299:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010729c:	89 c1                	mov    %eax,%ecx
8010729e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072a4:	f6 c2 01             	test   $0x1,%dl
801072a7:	75 17                	jne    801072c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801072a9:	83 ec 0c             	sub    $0xc,%esp
801072ac:	68 ea 7e 10 80       	push   $0x80107eea
801072b1:	e8 0a 91 ff ff       	call   801003c0 <panic>
801072b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801072c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801072d5:	85 c0                	test   %eax,%eax
801072d7:	74 d0                	je     801072a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801072d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072dc:	c9                   	leave  
801072dd:	c3                   	ret    
801072de:	66 90                	xchg   %ax,%ax

801072e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801072e9:	e8 02 ff ff ff       	call   801071f0 <setupkvm>
801072ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072f1:	85 c0                	test   %eax,%eax
801072f3:	0f 84 bd 00 00 00    	je     801073b6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801072f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072fc:	85 c9                	test   %ecx,%ecx
801072fe:	0f 84 b2 00 00 00    	je     801073b6 <copyuvm+0xd6>
80107304:	31 f6                	xor    %esi,%esi
80107306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010730d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107310:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107313:	89 f0                	mov    %esi,%eax
80107315:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107318:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010731b:	a8 01                	test   $0x1,%al
8010731d:	75 11                	jne    80107330 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010731f:	83 ec 0c             	sub    $0xc,%esp
80107322:	68 f4 7e 10 80       	push   $0x80107ef4
80107327:	e8 94 90 ff ff       	call   801003c0 <panic>
8010732c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107330:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107337:	c1 ea 0a             	shr    $0xa,%edx
8010733a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107340:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107347:	85 c0                	test   %eax,%eax
80107349:	74 d4                	je     8010731f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010734b:	8b 00                	mov    (%eax),%eax
8010734d:	a8 01                	test   $0x1,%al
8010734f:	0f 84 9f 00 00 00    	je     801073f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107355:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107357:	25 ff 0f 00 00       	and    $0xfff,%eax
8010735c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010735f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107365:	e8 c6 b6 ff ff       	call   80102a30 <kalloc>
8010736a:	89 c3                	mov    %eax,%ebx
8010736c:	85 c0                	test   %eax,%eax
8010736e:	74 64                	je     801073d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107370:	83 ec 04             	sub    $0x4,%esp
80107373:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107379:	68 00 10 00 00       	push   $0x1000
8010737e:	57                   	push   %edi
8010737f:	50                   	push   %eax
80107380:	e8 2b d7 ff ff       	call   80104ab0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107385:	58                   	pop    %eax
80107386:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010738c:	5a                   	pop    %edx
8010738d:	ff 75 e4             	push   -0x1c(%ebp)
80107390:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107395:	89 f2                	mov    %esi,%edx
80107397:	50                   	push   %eax
80107398:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010739b:	e8 60 f8 ff ff       	call   80106c00 <mappages>
801073a0:	83 c4 10             	add    $0x10,%esp
801073a3:	85 c0                	test   %eax,%eax
801073a5:	78 21                	js     801073c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801073a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801073b0:	0f 87 5a ff ff ff    	ja     80107310 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801073b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073bc:	5b                   	pop    %ebx
801073bd:	5e                   	pop    %esi
801073be:	5f                   	pop    %edi
801073bf:	5d                   	pop    %ebp
801073c0:	c3                   	ret    
801073c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073c8:	83 ec 0c             	sub    $0xc,%esp
801073cb:	53                   	push   %ebx
801073cc:	e8 9f b4 ff ff       	call   80102870 <kfree>
      goto bad;
801073d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801073d4:	83 ec 0c             	sub    $0xc,%esp
801073d7:	ff 75 e0             	push   -0x20(%ebp)
801073da:	e8 91 fd ff ff       	call   80107170 <freevm>
  return 0;
801073df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801073e6:	83 c4 10             	add    $0x10,%esp
}
801073e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ef:	5b                   	pop    %ebx
801073f0:	5e                   	pop    %esi
801073f1:	5f                   	pop    %edi
801073f2:	5d                   	pop    %ebp
801073f3:	c3                   	ret    
      panic("copyuvm: page not present");
801073f4:	83 ec 0c             	sub    $0xc,%esp
801073f7:	68 0e 7f 10 80       	push   $0x80107f0e
801073fc:	e8 bf 8f ff ff       	call   801003c0 <panic>
80107401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740f:	90                   	nop

80107410 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107416:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107419:	89 c1                	mov    %eax,%ecx
8010741b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010741e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107421:	f6 c2 01             	test   $0x1,%dl
80107424:	0f 84 00 01 00 00    	je     8010752a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010742a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010742d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107433:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107434:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107439:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107440:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107447:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010744a:	05 00 00 00 80       	add    $0x80000000,%eax
8010744f:	83 fa 05             	cmp    $0x5,%edx
80107452:	ba 00 00 00 00       	mov    $0x0,%edx
80107457:	0f 45 c2             	cmovne %edx,%eax
}
8010745a:	c3                   	ret    
8010745b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010745f:	90                   	nop

80107460 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
80107466:	83 ec 0c             	sub    $0xc,%esp
80107469:	8b 75 14             	mov    0x14(%ebp),%esi
8010746c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010746f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107472:	85 f6                	test   %esi,%esi
80107474:	75 51                	jne    801074c7 <copyout+0x67>
80107476:	e9 a5 00 00 00       	jmp    80107520 <copyout+0xc0>
8010747b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010747f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107480:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107486:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010748c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107492:	74 75                	je     80107509 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107494:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107496:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107499:	29 c3                	sub    %eax,%ebx
8010749b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074a1:	39 f3                	cmp    %esi,%ebx
801074a3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801074a6:	29 f8                	sub    %edi,%eax
801074a8:	83 ec 04             	sub    $0x4,%esp
801074ab:	01 c1                	add    %eax,%ecx
801074ad:	53                   	push   %ebx
801074ae:	52                   	push   %edx
801074af:	51                   	push   %ecx
801074b0:	e8 fb d5 ff ff       	call   80104ab0 <memmove>
    len -= n;
    buf += n;
801074b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801074b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801074be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801074c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801074c3:	29 de                	sub    %ebx,%esi
801074c5:	74 59                	je     80107520 <copyout+0xc0>
  if(*pde & PTE_P){
801074c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801074ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801074ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801074d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801074da:	f6 c1 01             	test   $0x1,%cl
801074dd:	0f 84 4e 00 00 00    	je     80107531 <copyout.cold>
  return &pgtab[PTX(va)];
801074e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801074eb:	c1 eb 0c             	shr    $0xc,%ebx
801074ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801074f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801074fb:	89 d9                	mov    %ebx,%ecx
801074fd:	83 e1 05             	and    $0x5,%ecx
80107500:	83 f9 05             	cmp    $0x5,%ecx
80107503:	0f 84 77 ff ff ff    	je     80107480 <copyout+0x20>
  }
  return 0;
}
80107509:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010750c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107511:	5b                   	pop    %ebx
80107512:	5e                   	pop    %esi
80107513:	5f                   	pop    %edi
80107514:	5d                   	pop    %ebp
80107515:	c3                   	ret    
80107516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751d:	8d 76 00             	lea    0x0(%esi),%esi
80107520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107523:	31 c0                	xor    %eax,%eax
}
80107525:	5b                   	pop    %ebx
80107526:	5e                   	pop    %esi
80107527:	5f                   	pop    %edi
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    

8010752a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010752a:	a1 00 00 00 00       	mov    0x0,%eax
8010752f:	0f 0b                	ud2    

80107531 <copyout.cold>:
80107531:	a1 00 00 00 00       	mov    0x0,%eax
80107536:	0f 0b                	ud2    
