
SYSSIZE = 0x3000
!
!	setup.s		(C) 2014 likeli
!

.globl begtext, begdata, begbss, endtext, enddata, endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text

SETUPLEN = 2				! nr of setup-sectors
BOOTSEG  = 0x07c0			! original address of boot-sector
INITSEG  = 0x9000			! we move boot here - out of the way
SETUPSEG = 0x9020			! setup starts here
SYSSEG   = 0x1000			! system loaded at 0x10000 (65536).
ENDSEG   = SYSSEG + SYSSIZE		! where to stop loading

! ROOT_DEV:	0x000 - same type of floppy as boot.
!		0x301 - first partition on first drive etc
ROOT_DEV = 0x306

entry _start
_start:
!==================================================================
!------Printf "we are in the seup"-----------------------------

	mov	ax,#SETUPSEG
	mov	es,ax

	mov	ah,#0x03		! read cursor pos
	xor	bh,bh
	int	0x10
	
	mov	cx,#25
	mov	bx,#0x0007		! page 0, attribute 7 (normal)
	mov	bp,#msgSETUP
	mov	ax,#0x1301		! write string, move cursor
	int	0x10
!------------------------------------------------------------------
!==================================================================

!==================================================================
!-------Read cursor-------------------------------------------------

	mov	ax,#INITSEG	
	mov	ds,ax 		!设置ds=0x9000
	mov	ah,#0x03	!读入光标位置
	xor	bh,bh
	int	0x10		!调用0x10中断
	mov	[0],dx		!将光标位置写入0x90000.

!-------Read memory-------------------------------------------------

	mov	ah,#0x88
	int	0x15
	mov	[2],ax

!-------Read others-------------------------------------------------

	mov	ax,#0x0000
	mov	ds,ax
	lds	si,[4*0x41]
	mov	ax,#INITSEG
	mov	es,ax
	mov	di,#0x0004
	mov	cx,#0x10
	rep			!重复16次
	movsb
!------------------------------------------------------------------
!==================================================================
!---------------------------------------
	mov	ax,#SETUPSEG
	mov	es,ax  		

	mov ax,#INITSEG
	mov ss,ax
	sub sp,sp

! ------Print **************----------------------------
	call 	print_1
	mov	bp,#msg
	mov	cx,#30
	call	print_2


! ------Print cursor------------------------------------

	call 	print_1
	mov	bp,#msgCUR
	call	print_2
	mov 	bp,#0x00
	call 	print_hex

! ------Print memory------------------------------------

	call 	print_1
	mov	bp,#msgMEM
	call	print_2
	mov 	bp,#0x02
	call 	print_hex

! ------Print CYLS------------------------------------

	call 	print_1
	mov	bp,#msgCYLS
	call	print_2
	mov 	bp,#0x04
	call 	print_hex

! ------Print HEADS------------------------------------

	call 	print_1
	mov	bp,#msgHEADS
	call	print_2
	mov 	bp,#0x06
	call 	print_hex

! ------Print SECTOR------------------------------------

	call 	print_1
	mov	bp,#msgSECTOR
	call	print_2
	mov 	bp,#0x12
	call 	print_hex
! ------Print **************----------------------------
	call 	print_1
	mov	bp,#msg
	mov	cx,#30
	call	print_2

	jmp 	OsGameOver

!------------------------------------------------------------------
!==================================================================
print_hex:
	!-----------------
    	mov	cx,#4 		! 4个十六进制数字
    	mov	dx,(bp) 	! 将(bp)所指的值放入dx中，如果bp是指向栈顶的话
	print_digit:
    	rol	dx,#4		! 循环以使低4比特用上 !! 取dx的高4比特移到低4比特处。
    	mov	ax,#0xe0f 	! ah = 请求的功能值，al = 半字节(4个比特)掩码。
    	and	al,dl 		! 取dl的低4比特值。
    	add	al,#0x30 	! 给al数字加上十六进制0x30
    	cmp	al,#0x3a
    	jl	outp  		!是一个不大于十的数字
    	add	al,#0x07  	!是a～f，要多加7
    	outp: 
    	int	0x10
    	loop	print_digit

    	print_nl:
   	mov	ax,#0xe0d 	! CR
    	int	0x10
    	mov	al,#0xa 	! LF
    	int	0x10
	ret

	!-----------------    	
print_1:
	!-----------------
	mov	ah,#0x03		! read cursor pos
	xor	bh,bh
	int	0x10
	
	mov	cx,#16
	mov	bx,#0x0007		! page 0, attribute 7 (normal)
	ret
	!-----------------
print_2:
	!-----------------
	mov	ax,#0x1301		! write string, move cursor
	int	0x10
	ret
	!-----------------

OsGameOver:
	

sectors:
	.word 0

msgSETUP:
	.byte 13,10
	.ascii "Now we are in SETUP"
	.byte 13,10,13,10
msgCUR:
	.ascii "*      Cursor  :"
msgMEM:
	.ascii "*      Memory  :"
msgCYLS:
	.ascii "*      Cyls    :"
msgHEADS:
	.ascii "*      Heads   :"
msgSECTOR:
	.ascii "*      Sectors :"
msg:
	.ascii "****************************"
	.byte 13,10
msg_:	.ascii "        *"
.org 508
root_dev:
	.word ROOT_DEV
boot_flag:
	.word 0xAA55

.text
endtext:
.data
enddata:
.bss
endbss:
