
_sdvar:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
    }
    return sum / len;
}

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 98 00 00 00    	sub    $0x98,%esp
  17:	8b 01                	mov    (%ecx),%eax
  19:	8b 79 04             	mov    0x4(%ecx),%edi
  1c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    int inputNumbers[MAX_INPUTS];
    int upperMeanNumbers[MAX_INPUTS], j = 0;
    int lowerMeanNumbers[MAX_INPUTS], k = 0;
    int len = argc - 1;

    if (argc > 8) {
  22:	83 f8 08             	cmp    $0x8,%eax
  25:	0f 8f 0f 02 00 00    	jg     23a <main+0x23a>
    int len = argc - 1;
  2b:	8d 58 ff             	lea    -0x1(%eax),%ebx
        printf(2, "Error: number of args...\n");
        exit();
    }

    for (int i = 0; i < len; ++i) {
  2e:	31 f6                	xor    %esi,%esi
  30:	85 db                	test   %ebx,%ebx
  32:	0f 8e 15 02 00 00    	jle    24d <main+0x24d>
  38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  3f:	90                   	nop
        inputNumbers[i] = atoi(argv[i + 1]);
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	ff 74 b7 04          	push   0x4(%edi,%esi,4)
  47:	e8 e4 05 00 00       	call   630 <atoi>
    for (int i = 0; i < len; ++i) {
  4c:	83 c4 10             	add    $0x10,%esp
        inputNumbers[i] = atoi(argv[i + 1]);
  4f:	89 44 b5 94          	mov    %eax,-0x6c(%ebp,%esi,4)
    for (int i = 0; i < len; ++i) {
  53:	83 c6 01             	add    $0x1,%esi
  56:	39 f3                	cmp    %esi,%ebx
  58:	75 e6                	jne    40 <main+0x40>
  5a:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  60:	8d 45 94             	lea    -0x6c(%ebp),%eax
  63:	d9 ee                	fldz   
  65:	89 c2                	mov    %eax,%edx
  67:	8d 4c bd 90          	lea    -0x70(%ebp,%edi,4),%ecx
  6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  6f:	90                   	nop
        sum += numbers[i];
  70:	db 02                	fildl  (%edx)
    for (int i = 0; i < len; ++i) {
  72:	83 c2 04             	add    $0x4,%edx
        sum += numbers[i];
  75:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < len; ++i) {
  77:	39 d1                	cmp    %edx,%ecx
  79:	75 f5                	jne    70 <main+0x70>
    return sum / len;
  7b:	89 9d 78 ff ff ff    	mov    %ebx,-0x88(%ebp)
  81:	db 85 78 ff ff ff    	fildl  -0x88(%ebp)
  87:	31 db                	xor    %ebx,%ebx
  89:	31 f6                	xor    %esi,%esi
  8b:	de f9                	fdivrp %st,%st(1)
    }

    double meanAll = cal_mean(inputNumbers, len);

    for(int i = 0; i < len; ++i) {
  8d:	eb 0f                	jmp    9e <main+0x9e>
  8f:	90                   	nop
  90:	83 c0 04             	add    $0x4,%eax
        if (inputNumbers[i] <= meanAll) {
            lowerMeanNumbers[j++] = inputNumbers[i];
  93:	89 54 b5 cc          	mov    %edx,-0x34(%ebp,%esi,4)
  97:	83 c6 01             	add    $0x1,%esi
    for(int i = 0; i < len; ++i) {
  9a:	39 c1                	cmp    %eax,%ecx
  9c:	74 24                	je     c2 <main+0xc2>
        if (inputNumbers[i] <= meanAll) {
  9e:	8b 10                	mov    (%eax),%edx
  a0:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
  a6:	db 85 78 ff ff ff    	fildl  -0x88(%ebp)
  ac:	d9 c9                	fxch   %st(1)
  ae:	db f1                	fcomi  %st(1),%st
  b0:	dd d9                	fstp   %st(1)
  b2:	73 dc                	jae    90 <main+0x90>
    for(int i = 0; i < len; ++i) {
  b4:	83 c0 04             	add    $0x4,%eax
        }
        else {
            upperMeanNumbers[k++] = inputNumbers[i];
  b7:	89 54 9d b0          	mov    %edx,-0x50(%ebp,%ebx,4)
  bb:	83 c3 01             	add    $0x1,%ebx
    for(int i = 0; i < len; ++i) {
  be:	39 c1                	cmp    %eax,%ecx
  c0:	75 dc                	jne    9e <main+0x9e>
    for (int i = 0; i < len; ++i) {
  c2:	85 f6                	test   %esi,%esi
  c4:	0f 84 c7 01 00 00    	je     291 <main+0x291>
  ca:	8d 4d cc             	lea    -0x34(%ebp),%ecx
    double sum = 0;
  cd:	d9 ee                	fldz   
  cf:	89 c8                	mov    %ecx,%eax
  d1:	8d 14 b1             	lea    (%ecx,%esi,4),%edx
  d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sum += numbers[i];
  d8:	db 00                	fildl  (%eax)
    for (int i = 0; i < len; ++i) {
  da:	83 c0 04             	add    $0x4,%eax
        sum += numbers[i];
  dd:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < len; ++i) {
  df:	39 c2                	cmp    %eax,%edx
  e1:	75 f5                	jne    d8 <main+0xd8>
  e3:	d9 c9                	fxch   %st(1)
  e5:	dd 9d 70 ff ff ff    	fstpl  -0x90(%ebp)
    return sum / len;
  eb:	89 b5 78 ff ff ff    	mov    %esi,-0x88(%ebp)
  f1:	db 85 78 ff ff ff    	fildl  -0x88(%ebp)
        }
    }

    double standardDeviation = cal_standard_deviation(lowerMeanNumbers, j, cal_mean(lowerMeanNumbers, j));
  f7:	57                   	push   %edi
  f8:	57                   	push   %edi
    return sum / len;
  f9:	de f9                	fdivrp %st,%st(1)
    double standardDeviation = cal_standard_deviation(lowerMeanNumbers, j, cal_mean(lowerMeanNumbers, j));
  fb:	dd 1c 24             	fstpl  (%esp)
  fe:	56                   	push   %esi
  ff:	51                   	push   %ecx
 100:	e8 4b 02 00 00       	call   350 <cal_standard_deviation>
 105:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < len; ++i) {
 108:	85 db                	test   %ebx,%ebx
    double standardDeviation = cal_standard_deviation(lowerMeanNumbers, j, cal_mean(lowerMeanNumbers, j));
 10a:	dd 9d 60 ff ff ff    	fstpl  -0xa0(%ebp)
    for (int i = 0; i < len; ++i) {
 110:	dd 85 70 ff ff ff    	fldl   -0x90(%ebp)
 116:	0f 84 6a 01 00 00    	je     286 <main+0x286>
 11c:	8d 45 b0             	lea    -0x50(%ebp),%eax
    double sum = 0;
 11f:	d9 ee                	fldz   
 121:	8d 0c 98             	lea    (%eax,%ebx,4),%ecx
    for (int i = 0; i < len; ++i) {
 124:	89 c2                	mov    %eax,%edx
 126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12d:	8d 76 00             	lea    0x0(%esi),%esi
        sum += numbers[i];
 130:	db 02                	fildl  (%edx)
    for (int i = 0; i < len; ++i) {
 132:	83 c2 04             	add    $0x4,%edx
        sum += numbers[i];
 135:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < len; ++i) {
 137:	39 d1                	cmp    %edx,%ecx
 139:	75 f5                	jne    130 <main+0x130>
    return sum / len;
 13b:	89 9d 78 ff ff ff    	mov    %ebx,-0x88(%ebp)
 141:	db 85 78 ff ff ff    	fildl  -0x88(%ebp)
 147:	dc f9                	fdivr  %st,%st(1)
 149:	d9 ee                	fldz   
 14b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
 150:	db 00                	fildl  (%eax)
    for (int i = 0; i < len; ++i) {
 152:	83 c0 04             	add    $0x4,%eax
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
 155:	d8 e3                	fsub   %st(3),%st
 157:	d8 c8                	fmul   %st(0),%st
 159:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < len; ++i) {
 15b:	39 c1                	cmp    %eax,%ecx
 15d:	75 f1                	jne    150 <main+0x150>
 15f:	dd da                	fstp   %st(2)
 161:	d9 c9                	fxch   %st(1)
 163:	d9 ca                	fxch   %st(2)
    double variance = cal_variance(upperMeanNumbers, k, cal_mean(upperMeanNumbers, k));

    unlink(FILENAME);
 165:	83 ec 0c             	sub    $0xc,%esp
 168:	dd 9d 68 ff ff ff    	fstpl  -0x98(%ebp)
 16e:	d9 c9                	fxch   %st(1)
 170:	68 42 0b 00 00       	push   $0xb42
 175:	dd 9d 70 ff ff ff    	fstpl  -0x90(%ebp)
 17b:	dd 9d 78 ff ff ff    	fstpl  -0x88(%ebp)
 181:	e8 6d 05 00 00       	call   6f3 <unlink>

    int fd = open(FILENAME, O_CREATE | O_WRONLY);
 186:	59                   	pop    %ecx
 187:	5b                   	pop    %ebx
 188:	68 01 02 00 00       	push   $0x201
 18d:	68 42 0b 00 00       	push   $0xb42
 192:	e8 4c 05 00 00       	call   6e3 <open>
    if(fd < 0) {
 197:	83 c4 10             	add    $0x10,%esp
 19a:	dd 85 78 ff ff ff    	fldl   -0x88(%ebp)
 1a0:	dd 85 70 ff ff ff    	fldl   -0x90(%ebp)
 1a6:	85 c0                	test   %eax,%eax
 1a8:	dd 85 68 ff ff ff    	fldl   -0x98(%ebp)
    int fd = open(FILENAME, O_CREATE | O_WRONLY);
 1ae:	89 c3                	mov    %eax,%ebx
    if(fd < 0) {
 1b0:	78 6f                	js     221 <main+0x221>
 1b2:	d9 c9                	fxch   %st(1)
        printf(2, "Error opening file...\n");
        exit();
    }
    
    printf(fd, "%d %d %d\n", (int)meanAll, (int)standardDeviation, (int)variance);
 1b4:	d9 7d 86             	fnstcw -0x7a(%ebp)
    return sum / len;
 1b7:	de f2                	fdivp  %st,%st(2)
 1b9:	d9 c9                	fxch   %st(1)
    printf(fd, "%d %d %d\n", (int)meanAll, (int)standardDeviation, (int)variance);
 1bb:	83 ec 0c             	sub    $0xc,%esp
 1be:	0f b7 45 86          	movzwl -0x7a(%ebp),%eax
 1c2:	80 cc 0c             	or     $0xc,%ah
 1c5:	66 89 45 84          	mov    %ax,-0x7c(%ebp)
 1c9:	d9 6d 84             	fldcw  -0x7c(%ebp)
 1cc:	db 9d 78 ff ff ff    	fistpl -0x88(%ebp)
 1d2:	d9 6d 86             	fldcw  -0x7a(%ebp)
 1d5:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
 1db:	dd 85 60 ff ff ff    	fldl   -0xa0(%ebp)
 1e1:	d9 6d 84             	fldcw  -0x7c(%ebp)
 1e4:	db 9d 78 ff ff ff    	fistpl -0x88(%ebp)
 1ea:	d9 6d 86             	fldcw  -0x7a(%ebp)
 1ed:	50                   	push   %eax
 1ee:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
 1f4:	d9 6d 84             	fldcw  -0x7c(%ebp)
 1f7:	db 9d 78 ff ff ff    	fistpl -0x88(%ebp)
 1fd:	d9 6d 86             	fldcw  -0x7a(%ebp)
 200:	50                   	push   %eax
 201:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
 207:	50                   	push   %eax
 208:	68 6a 0b 00 00       	push   $0xb6a
 20d:	53                   	push   %ebx
 20e:	e8 ed 05 00 00       	call   800 <printf>
    
    close(fd);
 213:	83 c4 14             	add    $0x14,%esp
 216:	53                   	push   %ebx
 217:	e8 af 04 00 00       	call   6cb <close>

    exit();
 21c:	e8 82 04 00 00       	call   6a3 <exit>
 221:	dd d8                	fstp   %st(0)
 223:	dd d8                	fstp   %st(0)
 225:	dd d8                	fstp   %st(0)
        printf(2, "Error opening file...\n");
 227:	52                   	push   %edx
 228:	52                   	push   %edx
 229:	68 53 0b 00 00       	push   $0xb53
 22e:	6a 02                	push   $0x2
 230:	e8 cb 05 00 00       	call   800 <printf>
        exit();
 235:	e8 69 04 00 00       	call   6a3 <exit>
        printf(2, "Error: number of args...\n");
 23a:	50                   	push   %eax
 23b:	50                   	push   %eax
 23c:	68 28 0b 00 00       	push   $0xb28
 241:	6a 02                	push   $0x2
 243:	e8 b8 05 00 00       	call   800 <printf>
        exit();
 248:	e8 56 04 00 00       	call   6a3 <exit>
    return sum / len;
 24d:	89 9d 78 ff ff ff    	mov    %ebx,-0x88(%ebp)
 253:	db 85 78 ff ff ff    	fildl  -0x88(%ebp)
    double standardDeviation = cal_standard_deviation(lowerMeanNumbers, j, cal_mean(lowerMeanNumbers, j));
 259:	50                   	push   %eax
 25a:	50                   	push   %eax
 25b:	8d 45 cc             	lea    -0x34(%ebp),%eax
    return sum / len;
 25e:	d9 ee                	fldz   
 260:	dc f1                	fdiv   %st,%st(1)
 262:	d9 c9                	fxch   %st(1)
 264:	dd 9d 78 ff ff ff    	fstpl  -0x88(%ebp)
 26a:	d8 f0                	fdiv   %st(0),%st
    double standardDeviation = cal_standard_deviation(lowerMeanNumbers, j, cal_mean(lowerMeanNumbers, j));
 26c:	dd 1c 24             	fstpl  (%esp)
 26f:	6a 00                	push   $0x0
 271:	50                   	push   %eax
 272:	e8 d9 00 00 00       	call   350 <cal_standard_deviation>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	dd 9d 60 ff ff ff    	fstpl  -0xa0(%ebp)
    for (int i = 0; i < len; ++i) {
 280:	dd 85 78 ff ff ff    	fldl   -0x88(%ebp)
    return sum / len;
 286:	d9 ee                	fldz   
 288:	d9 c0                	fld    %st(0)
 28a:	d9 ca                	fxch   %st(2)
 28c:	e9 d4 fe ff ff       	jmp    165 <main+0x165>
    double sum = 0;
 291:	d9 ee                	fldz   
 293:	d9 c9                	fxch   %st(1)
 295:	8d 4d cc             	lea    -0x34(%ebp),%ecx
 298:	e9 48 fe ff ff       	jmp    e5 <main+0xe5>
 29d:	66 90                	xchg   %ax,%ax
 29f:	90                   	nop

000002a0 <sqrt_approx>:
double sqrt_approx(double x) {
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	dd 45 08             	fldl   0x8(%ebp)
    if (x == 0) return 0;
 2a6:	d9 ee                	fldz   
 2a8:	d9 c0                	fld    %st(0)
 2aa:	d9 ca                	fxch   %st(2)
 2ac:	db ea                	fucomi %st(2),%st
 2ae:	dd da                	fstp   %st(2)
 2b0:	7a 06                	jp     2b8 <sqrt_approx+0x18>
 2b2:	74 4c                	je     300 <sqrt_approx+0x60>
 2b4:	dd d8                	fstp   %st(0)
 2b6:	eb 08                	jmp    2c0 <sqrt_approx+0x20>
 2b8:	dd d8                	fstp   %st(0)
 2ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while ((result * result - x) > epsilon) {
 2c0:	d9 c0                	fld    %st(0)
 2c2:	d8 c9                	fmul   %st(1),%st
 2c4:	d8 e1                	fsub   %st(1),%st
 2c6:	dd 05 78 0b 00 00    	fldl   0xb78
    double result = x;
 2cc:	d9 c2                	fld    %st(2)
 2ce:	d9 ca                	fxch   %st(2)
    while ((result * result - x) > epsilon) {
 2d0:	df f1                	fcomip %st(1),%st
 2d2:	76 34                	jbe    308 <sqrt_approx+0x68>
 2d4:	eb 0c                	jmp    2e2 <sqrt_approx+0x42>
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	d9 c9                	fxch   %st(1)
        result = 0.5 * (result + x / result);
 2e2:	d9 c2                	fld    %st(2)
 2e4:	d8 f2                	fdiv   %st(2),%st
 2e6:	de c2                	faddp  %st,%st(2)
 2e8:	d9 c9                	fxch   %st(1)
 2ea:	d8 0d 80 0b 00 00    	fmuls  0xb80
    while ((result * result - x) > epsilon) {
 2f0:	d9 c0                	fld    %st(0)
 2f2:	d8 c9                	fmul   %st(1),%st
 2f4:	d8 e3                	fsub   %st(3),%st
 2f6:	df f2                	fcomip %st(2),%st
 2f8:	77 e6                	ja     2e0 <sqrt_approx+0x40>
 2fa:	dd d9                	fstp   %st(1)
 2fc:	dd d9                	fstp   %st(1)
 2fe:	eb 0c                	jmp    30c <sqrt_approx+0x6c>
 300:	dd d9                	fstp   %st(1)
 302:	eb 08                	jmp    30c <sqrt_approx+0x6c>
 304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 308:	dd d8                	fstp   %st(0)
 30a:	dd d9                	fstp   %st(1)
}
 30c:	5d                   	pop    %ebp
 30d:	c3                   	ret    
 30e:	66 90                	xchg   %ax,%ax

00000310 <cal_mean>:
double cal_mean(int numbers[], int len) {
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 08             	sub    $0x8,%esp
 316:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    for (int i = 0; i < len; ++i) {
 319:	85 c9                	test   %ecx,%ecx
 31b:	7e 23                	jle    340 <cal_mean+0x30>
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
    double sum = 0;
 320:	d9 ee                	fldz   
 322:	8d 14 88             	lea    (%eax,%ecx,4),%edx
 325:	8d 76 00             	lea    0x0(%esi),%esi
        sum += numbers[i];
 328:	db 00                	fildl  (%eax)
    for (int i = 0; i < len; ++i) {
 32a:	83 c0 04             	add    $0x4,%eax
        sum += numbers[i];
 32d:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < len; ++i) {
 32f:	39 c2                	cmp    %eax,%edx
 331:	75 f5                	jne    328 <cal_mean+0x18>
    return sum / len;
 333:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 336:	db 45 fc             	fildl  -0x4(%ebp)
}
 339:	c9                   	leave  
    return sum / len;
 33a:	de f9                	fdivrp %st,%st(1)
}
 33c:	c3                   	ret    
 33d:	8d 76 00             	lea    0x0(%esi),%esi
    return sum / len;
 340:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    double sum = 0;
 343:	d9 ee                	fldz   
    return sum / len;
 345:	db 45 fc             	fildl  -0x4(%ebp)
}
 348:	c9                   	leave  
    return sum / len;
 349:	de f9                	fdivrp %st,%st(1)
}
 34b:	c3                   	ret    
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000350 <cal_standard_deviation>:
double cal_standard_deviation(int numbers[], int len, double mean) {
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	83 ec 08             	sub    $0x8,%esp
 356:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 359:	dd 45 10             	fldl   0x10(%ebp)
    for (int i = 0; i < len; ++i) {
 35c:	85 c9                	test   %ecx,%ecx
 35e:	0f 8e 8c 00 00 00    	jle    3f0 <cal_standard_deviation+0xa0>
 364:	8b 45 08             	mov    0x8(%ebp),%eax
    double sum = 0;
 367:	d9 ee                	fldz   
 369:	8d 14 88             	lea    (%eax,%ecx,4),%edx
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
 370:	db 00                	fildl  (%eax)
    for (int i = 0; i < len; ++i) {
 372:	83 c0 04             	add    $0x4,%eax
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
 375:	d8 e2                	fsub   %st(2),%st
 377:	d8 c8                	fmul   %st(0),%st
 379:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < len; ++i) {
 37b:	39 c2                	cmp    %eax,%edx
 37d:	75 f1                	jne    370 <cal_standard_deviation+0x20>
 37f:	dd d9                	fstp   %st(1)
    return sqrt_approx(sum / len);
 381:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 384:	db 45 fc             	fildl  -0x4(%ebp)
 387:	de f9                	fdivrp %st,%st(1)
    if (x == 0) return 0;
 389:	d9 ee                	fldz   
 38b:	d9 c0                	fld    %st(0)
 38d:	d9 ca                	fxch   %st(2)
 38f:	db ea                	fucomi %st(2),%st
 391:	dd da                	fstp   %st(2)
 393:	7a 06                	jp     39b <cal_standard_deviation+0x4b>
 395:	74 49                	je     3e0 <cal_standard_deviation+0x90>
 397:	dd d8                	fstp   %st(0)
 399:	eb 05                	jmp    3a0 <cal_standard_deviation+0x50>
 39b:	dd d8                	fstp   %st(0)
 39d:	8d 76 00             	lea    0x0(%esi),%esi
    while ((result * result - x) > epsilon) {
 3a0:	d9 c0                	fld    %st(0)
 3a2:	d8 c9                	fmul   %st(1),%st
 3a4:	d8 e1                	fsub   %st(1),%st
 3a6:	dd 05 78 0b 00 00    	fldl   0xb78
    double result = x;
 3ac:	d9 c2                	fld    %st(2)
 3ae:	d9 ca                	fxch   %st(2)
    while ((result * result - x) > epsilon) {
 3b0:	df f1                	fcomip %st(1),%st
 3b2:	76 30                	jbe    3e4 <cal_standard_deviation+0x94>
 3b4:	eb 0c                	jmp    3c2 <cal_standard_deviation+0x72>
 3b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	d9 c9                	fxch   %st(1)
        result = 0.5 * (result + x / result);
 3c2:	d9 c2                	fld    %st(2)
 3c4:	d8 f2                	fdiv   %st(2),%st
 3c6:	de c2                	faddp  %st,%st(2)
 3c8:	d9 c9                	fxch   %st(1)
 3ca:	d8 0d 80 0b 00 00    	fmuls  0xb80
    while ((result * result - x) > epsilon) {
 3d0:	d9 c0                	fld    %st(0)
 3d2:	d8 c9                	fmul   %st(1),%st
 3d4:	d8 e3                	fsub   %st(3),%st
 3d6:	df f2                	fcomip %st(2),%st
 3d8:	77 e6                	ja     3c0 <cal_standard_deviation+0x70>
 3da:	dd d9                	fstp   %st(1)
 3dc:	dd d9                	fstp   %st(1)
 3de:	eb 08                	jmp    3e8 <cal_standard_deviation+0x98>
 3e0:	dd d9                	fstp   %st(1)
 3e2:	eb 04                	jmp    3e8 <cal_standard_deviation+0x98>
 3e4:	dd d8                	fstp   %st(0)
 3e6:	dd d9                	fstp   %st(1)
}
 3e8:	c9                   	leave  
 3e9:	c3                   	ret    
 3ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3f0:	dd d8                	fstp   %st(0)
    double sum = 0;
 3f2:	d9 ee                	fldz   
 3f4:	eb 8b                	jmp    381 <cal_standard_deviation+0x31>
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <cal_variance>:
double cal_variance(int numbers[], int len, double mean) {
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 08             	sub    $0x8,%esp
 406:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 409:	dd 45 10             	fldl   0x10(%ebp)
    for (int i = 0; i < len; ++i) {
 40c:	85 c9                	test   %ecx,%ecx
 40e:	7e 30                	jle    440 <cal_variance+0x40>
 410:	8b 45 08             	mov    0x8(%ebp),%eax
    double sum = 0;
 413:	d9 ee                	fldz   
 415:	8d 14 88             	lea    (%eax,%ecx,4),%edx
 418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41f:	90                   	nop
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
 420:	db 00                	fildl  (%eax)
    for (int i = 0; i < len; ++i) {
 422:	83 c0 04             	add    $0x4,%eax
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
 425:	d8 e2                	fsub   %st(2),%st
 427:	d8 c8                	fmul   %st(0),%st
 429:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < len; ++i) {
 42b:	39 c2                	cmp    %eax,%edx
 42d:	75 f1                	jne    420 <cal_variance+0x20>
 42f:	dd d9                	fstp   %st(1)
    return sum / len;
 431:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 434:	db 45 fc             	fildl  -0x4(%ebp)
}
 437:	c9                   	leave  
    return sum / len;
 438:	de f9                	fdivrp %st,%st(1)
}
 43a:	c3                   	ret    
 43b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop
 440:	dd d8                	fstp   %st(0)
    return sum / len;
 442:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    double sum = 0;
 445:	d9 ee                	fldz   
    return sum / len;
 447:	db 45 fc             	fildl  -0x4(%ebp)
}
 44a:	c9                   	leave  
    return sum / len;
 44b:	de f9                	fdivrp %st,%st(1)
}
 44d:	c3                   	ret    
 44e:	66 90                	xchg   %ax,%ax

00000450 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 450:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 451:	31 c0                	xor    %eax,%eax
{
 453:	89 e5                	mov    %esp,%ebp
 455:	53                   	push   %ebx
 456:	8b 4d 08             	mov    0x8(%ebp),%ecx
 459:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 460:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 464:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 467:	83 c0 01             	add    $0x1,%eax
 46a:	84 d2                	test   %dl,%dl
 46c:	75 f2                	jne    460 <strcpy+0x10>
    ;
  return os;
}
 46e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 471:	89 c8                	mov    %ecx,%eax
 473:	c9                   	leave  
 474:	c3                   	ret    
 475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000480 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	53                   	push   %ebx
 484:	8b 55 08             	mov    0x8(%ebp),%edx
 487:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 48a:	0f b6 02             	movzbl (%edx),%eax
 48d:	84 c0                	test   %al,%al
 48f:	75 17                	jne    4a8 <strcmp+0x28>
 491:	eb 3a                	jmp    4cd <strcmp+0x4d>
 493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 497:	90                   	nop
 498:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 49c:	83 c2 01             	add    $0x1,%edx
 49f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 4a2:	84 c0                	test   %al,%al
 4a4:	74 1a                	je     4c0 <strcmp+0x40>
    p++, q++;
 4a6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 4a8:	0f b6 19             	movzbl (%ecx),%ebx
 4ab:	38 c3                	cmp    %al,%bl
 4ad:	74 e9                	je     498 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 4af:	29 d8                	sub    %ebx,%eax
}
 4b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4b4:	c9                   	leave  
 4b5:	c3                   	ret    
 4b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 4c0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 4c4:	31 c0                	xor    %eax,%eax
 4c6:	29 d8                	sub    %ebx,%eax
}
 4c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 4cd:	0f b6 19             	movzbl (%ecx),%ebx
 4d0:	31 c0                	xor    %eax,%eax
 4d2:	eb db                	jmp    4af <strcmp+0x2f>
 4d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop

000004e0 <strlen>:

uint
strlen(const char *s)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 4e6:	80 3a 00             	cmpb   $0x0,(%edx)
 4e9:	74 15                	je     500 <strlen+0x20>
 4eb:	31 c0                	xor    %eax,%eax
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
 4f0:	83 c0 01             	add    $0x1,%eax
 4f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 4f7:	89 c1                	mov    %eax,%ecx
 4f9:	75 f5                	jne    4f0 <strlen+0x10>
    ;
  return n;
}
 4fb:	89 c8                	mov    %ecx,%eax
 4fd:	5d                   	pop    %ebp
 4fe:	c3                   	ret    
 4ff:	90                   	nop
  for(n = 0; s[n]; n++)
 500:	31 c9                	xor    %ecx,%ecx
}
 502:	5d                   	pop    %ebp
 503:	89 c8                	mov    %ecx,%eax
 505:	c3                   	ret    
 506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi

00000510 <memset>:

void*
memset(void *dst, int c, uint n)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 517:	8b 4d 10             	mov    0x10(%ebp),%ecx
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	89 d7                	mov    %edx,%edi
 51f:	fc                   	cld    
 520:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 522:	8b 7d fc             	mov    -0x4(%ebp),%edi
 525:	89 d0                	mov    %edx,%eax
 527:	c9                   	leave  
 528:	c3                   	ret    
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000530 <strchr>:

char*
strchr(const char *s, char c)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 53a:	0f b6 10             	movzbl (%eax),%edx
 53d:	84 d2                	test   %dl,%dl
 53f:	75 12                	jne    553 <strchr+0x23>
 541:	eb 1d                	jmp    560 <strchr+0x30>
 543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 547:	90                   	nop
 548:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 54c:	83 c0 01             	add    $0x1,%eax
 54f:	84 d2                	test   %dl,%dl
 551:	74 0d                	je     560 <strchr+0x30>
    if(*s == c)
 553:	38 d1                	cmp    %dl,%cl
 555:	75 f1                	jne    548 <strchr+0x18>
      return (char*)s;
  return 0;
}
 557:	5d                   	pop    %ebp
 558:	c3                   	ret    
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 560:	31 c0                	xor    %eax,%eax
}
 562:	5d                   	pop    %ebp
 563:	c3                   	ret    
 564:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop

00000570 <gets>:

char*
gets(char *buf, int max)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 575:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 578:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 579:	31 db                	xor    %ebx,%ebx
{
 57b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 57e:	eb 27                	jmp    5a7 <gets+0x37>
    cc = read(0, &c, 1);
 580:	83 ec 04             	sub    $0x4,%esp
 583:	6a 01                	push   $0x1
 585:	57                   	push   %edi
 586:	6a 00                	push   $0x0
 588:	e8 2e 01 00 00       	call   6bb <read>
    if(cc < 1)
 58d:	83 c4 10             	add    $0x10,%esp
 590:	85 c0                	test   %eax,%eax
 592:	7e 1d                	jle    5b1 <gets+0x41>
      break;
    buf[i++] = c;
 594:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 598:	8b 55 08             	mov    0x8(%ebp),%edx
 59b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 59f:	3c 0a                	cmp    $0xa,%al
 5a1:	74 1d                	je     5c0 <gets+0x50>
 5a3:	3c 0d                	cmp    $0xd,%al
 5a5:	74 19                	je     5c0 <gets+0x50>
  for(i=0; i+1 < max; ){
 5a7:	89 de                	mov    %ebx,%esi
 5a9:	83 c3 01             	add    $0x1,%ebx
 5ac:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 5af:	7c cf                	jl     580 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 5b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bb:	5b                   	pop    %ebx
 5bc:	5e                   	pop    %esi
 5bd:	5f                   	pop    %edi
 5be:	5d                   	pop    %ebp
 5bf:	c3                   	ret    
  buf[i] = '\0';
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 de                	mov    %ebx,%esi
 5c5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 5c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cc:	5b                   	pop    %ebx
 5cd:	5e                   	pop    %esi
 5ce:	5f                   	pop    %edi
 5cf:	5d                   	pop    %ebp
 5d0:	c3                   	ret    
 5d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop

000005e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	56                   	push   %esi
 5e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5e5:	83 ec 08             	sub    $0x8,%esp
 5e8:	6a 00                	push   $0x0
 5ea:	ff 75 08             	push   0x8(%ebp)
 5ed:	e8 f1 00 00 00       	call   6e3 <open>
  if(fd < 0)
 5f2:	83 c4 10             	add    $0x10,%esp
 5f5:	85 c0                	test   %eax,%eax
 5f7:	78 27                	js     620 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 5f9:	83 ec 08             	sub    $0x8,%esp
 5fc:	ff 75 0c             	push   0xc(%ebp)
 5ff:	89 c3                	mov    %eax,%ebx
 601:	50                   	push   %eax
 602:	e8 f4 00 00 00       	call   6fb <fstat>
  close(fd);
 607:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 60a:	89 c6                	mov    %eax,%esi
  close(fd);
 60c:	e8 ba 00 00 00       	call   6cb <close>
  return r;
 611:	83 c4 10             	add    $0x10,%esp
}
 614:	8d 65 f8             	lea    -0x8(%ebp),%esp
 617:	89 f0                	mov    %esi,%eax
 619:	5b                   	pop    %ebx
 61a:	5e                   	pop    %esi
 61b:	5d                   	pop    %ebp
 61c:	c3                   	ret    
 61d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 620:	be ff ff ff ff       	mov    $0xffffffff,%esi
 625:	eb ed                	jmp    614 <stat+0x34>
 627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62e:	66 90                	xchg   %ax,%ax

00000630 <atoi>:

int
atoi(const char *s)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	53                   	push   %ebx
 634:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 637:	0f be 02             	movsbl (%edx),%eax
 63a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 63d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 640:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 645:	77 1e                	ja     665 <atoi+0x35>
 647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 650:	83 c2 01             	add    $0x1,%edx
 653:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 656:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 65a:	0f be 02             	movsbl (%edx),%eax
 65d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 660:	80 fb 09             	cmp    $0x9,%bl
 663:	76 eb                	jbe    650 <atoi+0x20>
  return n;
}
 665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 668:	89 c8                	mov    %ecx,%eax
 66a:	c9                   	leave  
 66b:	c3                   	ret    
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	8b 45 10             	mov    0x10(%ebp),%eax
 677:	8b 55 08             	mov    0x8(%ebp),%edx
 67a:	56                   	push   %esi
 67b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 67e:	85 c0                	test   %eax,%eax
 680:	7e 13                	jle    695 <memmove+0x25>
 682:	01 d0                	add    %edx,%eax
  dst = vdst;
 684:	89 d7                	mov    %edx,%edi
 686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 690:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 691:	39 f8                	cmp    %edi,%eax
 693:	75 fb                	jne    690 <memmove+0x20>
  return vdst;
}
 695:	5e                   	pop    %esi
 696:	89 d0                	mov    %edx,%eax
 698:	5f                   	pop    %edi
 699:	5d                   	pop    %ebp
 69a:	c3                   	ret    

0000069b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 69b:	b8 01 00 00 00       	mov    $0x1,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <exit>:
SYSCALL(exit)
 6a3:	b8 02 00 00 00       	mov    $0x2,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <wait>:
SYSCALL(wait)
 6ab:	b8 03 00 00 00       	mov    $0x3,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <pipe>:
SYSCALL(pipe)
 6b3:	b8 04 00 00 00       	mov    $0x4,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <read>:
SYSCALL(read)
 6bb:	b8 05 00 00 00       	mov    $0x5,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    

000006c3 <write>:
SYSCALL(write)
 6c3:	b8 10 00 00 00       	mov    $0x10,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret    

000006cb <close>:
SYSCALL(close)
 6cb:	b8 15 00 00 00       	mov    $0x15,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <kill>:
SYSCALL(kill)
 6d3:	b8 06 00 00 00       	mov    $0x6,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <exec>:
SYSCALL(exec)
 6db:	b8 07 00 00 00       	mov    $0x7,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <open>:
SYSCALL(open)
 6e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    

000006eb <mknod>:
SYSCALL(mknod)
 6eb:	b8 11 00 00 00       	mov    $0x11,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret    

000006f3 <unlink>:
SYSCALL(unlink)
 6f3:	b8 12 00 00 00       	mov    $0x12,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret    

000006fb <fstat>:
SYSCALL(fstat)
 6fb:	b8 08 00 00 00       	mov    $0x8,%eax
 700:	cd 40                	int    $0x40
 702:	c3                   	ret    

00000703 <link>:
SYSCALL(link)
 703:	b8 13 00 00 00       	mov    $0x13,%eax
 708:	cd 40                	int    $0x40
 70a:	c3                   	ret    

0000070b <mkdir>:
SYSCALL(mkdir)
 70b:	b8 14 00 00 00       	mov    $0x14,%eax
 710:	cd 40                	int    $0x40
 712:	c3                   	ret    

00000713 <chdir>:
SYSCALL(chdir)
 713:	b8 09 00 00 00       	mov    $0x9,%eax
 718:	cd 40                	int    $0x40
 71a:	c3                   	ret    

0000071b <dup>:
SYSCALL(dup)
 71b:	b8 0a 00 00 00       	mov    $0xa,%eax
 720:	cd 40                	int    $0x40
 722:	c3                   	ret    

00000723 <getpid>:
SYSCALL(getpid)
 723:	b8 0b 00 00 00       	mov    $0xb,%eax
 728:	cd 40                	int    $0x40
 72a:	c3                   	ret    

0000072b <sbrk>:
SYSCALL(sbrk)
 72b:	b8 0c 00 00 00       	mov    $0xc,%eax
 730:	cd 40                	int    $0x40
 732:	c3                   	ret    

00000733 <sleep>:
SYSCALL(sleep)
 733:	b8 0d 00 00 00       	mov    $0xd,%eax
 738:	cd 40                	int    $0x40
 73a:	c3                   	ret    

0000073b <uptime>:
SYSCALL(uptime)
 73b:	b8 0e 00 00 00       	mov    $0xe,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret    
 743:	66 90                	xchg   %ax,%ax
 745:	66 90                	xchg   %ax,%ax
 747:	66 90                	xchg   %ax,%ax
 749:	66 90                	xchg   %ax,%ax
 74b:	66 90                	xchg   %ax,%ax
 74d:	66 90                	xchg   %ax,%ax
 74f:	90                   	nop

00000750 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 3c             	sub    $0x3c,%esp
 759:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 75c:	89 d1                	mov    %edx,%ecx
{
 75e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 761:	85 d2                	test   %edx,%edx
 763:	0f 89 7f 00 00 00    	jns    7e8 <printint+0x98>
 769:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 76d:	74 79                	je     7e8 <printint+0x98>
    neg = 1;
 76f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 776:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 778:	31 db                	xor    %ebx,%ebx
 77a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 77d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 780:	89 c8                	mov    %ecx,%eax
 782:	31 d2                	xor    %edx,%edx
 784:	89 cf                	mov    %ecx,%edi
 786:	f7 75 c4             	divl   -0x3c(%ebp)
 789:	0f b6 92 e4 0b 00 00 	movzbl 0xbe4(%edx),%edx
 790:	89 45 c0             	mov    %eax,-0x40(%ebp)
 793:	89 d8                	mov    %ebx,%eax
 795:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 798:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 79b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 79e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 7a1:	76 dd                	jbe    780 <printint+0x30>
  if(neg)
 7a3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 7a6:	85 c9                	test   %ecx,%ecx
 7a8:	74 0c                	je     7b6 <printint+0x66>
    buf[i++] = '-';
 7aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 7af:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 7b1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 7b6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 7b9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 7bd:	eb 07                	jmp    7c6 <printint+0x76>
 7bf:	90                   	nop
    putc(fd, buf[i]);
 7c0:	0f b6 13             	movzbl (%ebx),%edx
 7c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 7c6:	83 ec 04             	sub    $0x4,%esp
 7c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 7cc:	6a 01                	push   $0x1
 7ce:	56                   	push   %esi
 7cf:	57                   	push   %edi
 7d0:	e8 ee fe ff ff       	call   6c3 <write>
  while(--i >= 0)
 7d5:	83 c4 10             	add    $0x10,%esp
 7d8:	39 de                	cmp    %ebx,%esi
 7da:	75 e4                	jne    7c0 <printint+0x70>
}
 7dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7df:	5b                   	pop    %ebx
 7e0:	5e                   	pop    %esi
 7e1:	5f                   	pop    %edi
 7e2:	5d                   	pop    %ebp
 7e3:	c3                   	ret    
 7e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 7e8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 7ef:	eb 87                	jmp    778 <printint+0x28>
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ff:	90                   	nop

00000800 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 809:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 80c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 80f:	0f b6 13             	movzbl (%ebx),%edx
 812:	84 d2                	test   %dl,%dl
 814:	74 6a                	je     880 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 816:	8d 45 10             	lea    0x10(%ebp),%eax
 819:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 81c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 81f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 821:	89 45 d0             	mov    %eax,-0x30(%ebp)
 824:	eb 36                	jmp    85c <printf+0x5c>
 826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82d:	8d 76 00             	lea    0x0(%esi),%esi
 830:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 833:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 838:	83 f8 25             	cmp    $0x25,%eax
 83b:	74 15                	je     852 <printf+0x52>
  write(fd, &c, 1);
 83d:	83 ec 04             	sub    $0x4,%esp
 840:	88 55 e7             	mov    %dl,-0x19(%ebp)
 843:	6a 01                	push   $0x1
 845:	57                   	push   %edi
 846:	56                   	push   %esi
 847:	e8 77 fe ff ff       	call   6c3 <write>
 84c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 84f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 852:	0f b6 13             	movzbl (%ebx),%edx
 855:	83 c3 01             	add    $0x1,%ebx
 858:	84 d2                	test   %dl,%dl
 85a:	74 24                	je     880 <printf+0x80>
    c = fmt[i] & 0xff;
 85c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 85f:	85 c9                	test   %ecx,%ecx
 861:	74 cd                	je     830 <printf+0x30>
      }
    } else if(state == '%'){
 863:	83 f9 25             	cmp    $0x25,%ecx
 866:	75 ea                	jne    852 <printf+0x52>
      if(c == 'd'){
 868:	83 f8 25             	cmp    $0x25,%eax
 86b:	0f 84 07 01 00 00    	je     978 <printf+0x178>
 871:	83 e8 63             	sub    $0x63,%eax
 874:	83 f8 15             	cmp    $0x15,%eax
 877:	77 17                	ja     890 <printf+0x90>
 879:	ff 24 85 8c 0b 00 00 	jmp    *0xb8c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 880:	8d 65 f4             	lea    -0xc(%ebp),%esp
 883:	5b                   	pop    %ebx
 884:	5e                   	pop    %esi
 885:	5f                   	pop    %edi
 886:	5d                   	pop    %ebp
 887:	c3                   	ret    
 888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 88f:	90                   	nop
  write(fd, &c, 1);
 890:	83 ec 04             	sub    $0x4,%esp
 893:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 896:	6a 01                	push   $0x1
 898:	57                   	push   %edi
 899:	56                   	push   %esi
 89a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 89e:	e8 20 fe ff ff       	call   6c3 <write>
        putc(fd, c);
 8a3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 8a7:	83 c4 0c             	add    $0xc,%esp
 8aa:	88 55 e7             	mov    %dl,-0x19(%ebp)
 8ad:	6a 01                	push   $0x1
 8af:	57                   	push   %edi
 8b0:	56                   	push   %esi
 8b1:	e8 0d fe ff ff       	call   6c3 <write>
        putc(fd, c);
 8b6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8b9:	31 c9                	xor    %ecx,%ecx
 8bb:	eb 95                	jmp    852 <printf+0x52>
 8bd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 8c0:	83 ec 0c             	sub    $0xc,%esp
 8c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 8c8:	6a 00                	push   $0x0
 8ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8cd:	8b 10                	mov    (%eax),%edx
 8cf:	89 f0                	mov    %esi,%eax
 8d1:	e8 7a fe ff ff       	call   750 <printint>
        ap++;
 8d6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 8da:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8dd:	31 c9                	xor    %ecx,%ecx
 8df:	e9 6e ff ff ff       	jmp    852 <printf+0x52>
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 8e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8eb:	8b 10                	mov    (%eax),%edx
        ap++;
 8ed:	83 c0 04             	add    $0x4,%eax
 8f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 8f3:	85 d2                	test   %edx,%edx
 8f5:	0f 84 8d 00 00 00    	je     988 <printf+0x188>
        while(*s != 0){
 8fb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 8fe:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 900:	84 c0                	test   %al,%al
 902:	0f 84 4a ff ff ff    	je     852 <printf+0x52>
 908:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 90b:	89 d3                	mov    %edx,%ebx
 90d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 910:	83 ec 04             	sub    $0x4,%esp
          s++;
 913:	83 c3 01             	add    $0x1,%ebx
 916:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 919:	6a 01                	push   $0x1
 91b:	57                   	push   %edi
 91c:	56                   	push   %esi
 91d:	e8 a1 fd ff ff       	call   6c3 <write>
        while(*s != 0){
 922:	0f b6 03             	movzbl (%ebx),%eax
 925:	83 c4 10             	add    $0x10,%esp
 928:	84 c0                	test   %al,%al
 92a:	75 e4                	jne    910 <printf+0x110>
      state = 0;
 92c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 92f:	31 c9                	xor    %ecx,%ecx
 931:	e9 1c ff ff ff       	jmp    852 <printf+0x52>
 936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 940:	83 ec 0c             	sub    $0xc,%esp
 943:	b9 0a 00 00 00       	mov    $0xa,%ecx
 948:	6a 01                	push   $0x1
 94a:	e9 7b ff ff ff       	jmp    8ca <printf+0xca>
 94f:	90                   	nop
        putc(fd, *ap);
 950:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 953:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 956:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 958:	6a 01                	push   $0x1
 95a:	57                   	push   %edi
 95b:	56                   	push   %esi
        putc(fd, *ap);
 95c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 95f:	e8 5f fd ff ff       	call   6c3 <write>
        ap++;
 964:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 968:	83 c4 10             	add    $0x10,%esp
      state = 0;
 96b:	31 c9                	xor    %ecx,%ecx
 96d:	e9 e0 fe ff ff       	jmp    852 <printf+0x52>
 972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 978:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 97b:	83 ec 04             	sub    $0x4,%esp
 97e:	e9 2a ff ff ff       	jmp    8ad <printf+0xad>
 983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 987:	90                   	nop
          s = "(null)";
 988:	ba 84 0b 00 00       	mov    $0xb84,%edx
        while(*s != 0){
 98d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 990:	b8 28 00 00 00       	mov    $0x28,%eax
 995:	89 d3                	mov    %edx,%ebx
 997:	e9 74 ff ff ff       	jmp    910 <printf+0x110>
 99c:	66 90                	xchg   %ax,%ax
 99e:	66 90                	xchg   %ax,%ax

000009a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a1:	a1 2c 0f 00 00       	mov    0xf2c,%eax
{
 9a6:	89 e5                	mov    %esp,%ebp
 9a8:	57                   	push   %edi
 9a9:	56                   	push   %esi
 9aa:	53                   	push   %ebx
 9ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 9ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9b8:	89 c2                	mov    %eax,%edx
 9ba:	8b 00                	mov    (%eax),%eax
 9bc:	39 ca                	cmp    %ecx,%edx
 9be:	73 30                	jae    9f0 <free+0x50>
 9c0:	39 c1                	cmp    %eax,%ecx
 9c2:	72 04                	jb     9c8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c4:	39 c2                	cmp    %eax,%edx
 9c6:	72 f0                	jb     9b8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 9cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 9ce:	39 f8                	cmp    %edi,%eax
 9d0:	74 30                	je     a02 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9d2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9d5:	8b 42 04             	mov    0x4(%edx),%eax
 9d8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 9db:	39 f1                	cmp    %esi,%ecx
 9dd:	74 3a                	je     a19 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9df:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 9e1:	5b                   	pop    %ebx
  freep = p;
 9e2:	89 15 2c 0f 00 00    	mov    %edx,0xf2c
}
 9e8:	5e                   	pop    %esi
 9e9:	5f                   	pop    %edi
 9ea:	5d                   	pop    %ebp
 9eb:	c3                   	ret    
 9ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9f0:	39 c2                	cmp    %eax,%edx
 9f2:	72 c4                	jb     9b8 <free+0x18>
 9f4:	39 c1                	cmp    %eax,%ecx
 9f6:	73 c0                	jae    9b8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 9f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 9fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 9fe:	39 f8                	cmp    %edi,%eax
 a00:	75 d0                	jne    9d2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 a02:	03 70 04             	add    0x4(%eax),%esi
 a05:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a08:	8b 02                	mov    (%edx),%eax
 a0a:	8b 00                	mov    (%eax),%eax
 a0c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 a0f:	8b 42 04             	mov    0x4(%edx),%eax
 a12:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 a15:	39 f1                	cmp    %esi,%ecx
 a17:	75 c6                	jne    9df <free+0x3f>
    p->s.size += bp->s.size;
 a19:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 a1c:	89 15 2c 0f 00 00    	mov    %edx,0xf2c
    p->s.size += bp->s.size;
 a22:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 a25:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 a28:	89 0a                	mov    %ecx,(%edx)
}
 a2a:	5b                   	pop    %ebx
 a2b:	5e                   	pop    %esi
 a2c:	5f                   	pop    %edi
 a2d:	5d                   	pop    %ebp
 a2e:	c3                   	ret    
 a2f:	90                   	nop

00000a30 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a30:	55                   	push   %ebp
 a31:	89 e5                	mov    %esp,%ebp
 a33:	57                   	push   %edi
 a34:	56                   	push   %esi
 a35:	53                   	push   %ebx
 a36:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a39:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 a3c:	8b 3d 2c 0f 00 00    	mov    0xf2c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a42:	8d 70 07             	lea    0x7(%eax),%esi
 a45:	c1 ee 03             	shr    $0x3,%esi
 a48:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 a4b:	85 ff                	test   %edi,%edi
 a4d:	0f 84 9d 00 00 00    	je     af0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a53:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 a55:	8b 4a 04             	mov    0x4(%edx),%ecx
 a58:	39 f1                	cmp    %esi,%ecx
 a5a:	73 6a                	jae    ac6 <malloc+0x96>
 a5c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a61:	39 de                	cmp    %ebx,%esi
 a63:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 a66:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 a6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a70:	eb 17                	jmp    a89 <malloc+0x59>
 a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a78:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a7a:	8b 48 04             	mov    0x4(%eax),%ecx
 a7d:	39 f1                	cmp    %esi,%ecx
 a7f:	73 4f                	jae    ad0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a81:	8b 3d 2c 0f 00 00    	mov    0xf2c,%edi
 a87:	89 c2                	mov    %eax,%edx
 a89:	39 d7                	cmp    %edx,%edi
 a8b:	75 eb                	jne    a78 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a8d:	83 ec 0c             	sub    $0xc,%esp
 a90:	ff 75 e4             	push   -0x1c(%ebp)
 a93:	e8 93 fc ff ff       	call   72b <sbrk>
  if(p == (char*)-1)
 a98:	83 c4 10             	add    $0x10,%esp
 a9b:	83 f8 ff             	cmp    $0xffffffff,%eax
 a9e:	74 1c                	je     abc <malloc+0x8c>
  hp->s.size = nu;
 aa0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 aa3:	83 ec 0c             	sub    $0xc,%esp
 aa6:	83 c0 08             	add    $0x8,%eax
 aa9:	50                   	push   %eax
 aaa:	e8 f1 fe ff ff       	call   9a0 <free>
  return freep;
 aaf:	8b 15 2c 0f 00 00    	mov    0xf2c,%edx
      if((p = morecore(nunits)) == 0)
 ab5:	83 c4 10             	add    $0x10,%esp
 ab8:	85 d2                	test   %edx,%edx
 aba:	75 bc                	jne    a78 <malloc+0x48>
        return 0;
  }
}
 abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 abf:	31 c0                	xor    %eax,%eax
}
 ac1:	5b                   	pop    %ebx
 ac2:	5e                   	pop    %esi
 ac3:	5f                   	pop    %edi
 ac4:	5d                   	pop    %ebp
 ac5:	c3                   	ret    
    if(p->s.size >= nunits){
 ac6:	89 d0                	mov    %edx,%eax
 ac8:	89 fa                	mov    %edi,%edx
 aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 ad0:	39 ce                	cmp    %ecx,%esi
 ad2:	74 4c                	je     b20 <malloc+0xf0>
        p->s.size -= nunits;
 ad4:	29 f1                	sub    %esi,%ecx
 ad6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ad9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 adc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 adf:	89 15 2c 0f 00 00    	mov    %edx,0xf2c
}
 ae5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 ae8:	83 c0 08             	add    $0x8,%eax
}
 aeb:	5b                   	pop    %ebx
 aec:	5e                   	pop    %esi
 aed:	5f                   	pop    %edi
 aee:	5d                   	pop    %ebp
 aef:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 af0:	c7 05 2c 0f 00 00 30 	movl   $0xf30,0xf2c
 af7:	0f 00 00 
    base.s.size = 0;
 afa:	bf 30 0f 00 00       	mov    $0xf30,%edi
    base.s.ptr = freep = prevp = &base;
 aff:	c7 05 30 0f 00 00 30 	movl   $0xf30,0xf30
 b06:	0f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b09:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 b0b:	c7 05 34 0f 00 00 00 	movl   $0x0,0xf34
 b12:	00 00 00 
    if(p->s.size >= nunits){
 b15:	e9 42 ff ff ff       	jmp    a5c <malloc+0x2c>
 b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 b20:	8b 08                	mov    (%eax),%ecx
 b22:	89 0a                	mov    %ecx,(%edx)
 b24:	eb b9                	jmp    adf <malloc+0xaf>
