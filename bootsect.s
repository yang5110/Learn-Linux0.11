
.globl begtext, begdata, begbss, endtext, enddata, endbss
.text
begtext
.data
begdata
.bss
.text

SETUPLEN = 4					!表示4个扇区
BOOTSEG  = 0x07c0				!作为BIOS将硬盘头512字节数据搬运的目的地址
INITSEG  = 0x9000				!作为硬盘头512字节数据第二次搬运的目的地址
SETUPSEG = 0x9020				!setup开始执行的地址
SYSSEG   = 0x1000				!系统内核加载到的起始地址
ENDSEG   = SYSSEG + SYSSIZE		!内核区域的末尾地址

entry _start
_start:
	mov ax,#BOOTSEG
	mov ds,ax			!16位数据段寄存器(在内存寻址时充当段基址的作用)赋值
	mov ax,#INITSEG
	mov es,ax			!附加段寄存器赋值(在内存寻址时充当段基址的作用)
	mov cx,#256			!计数器
	sub si,si
	sub di,di
	rep movw			!重复执行256次movw(16位，两字节)，从ds:si->es:di,即将0x07c0处开始的512字节复制到0x9000处
	jmpi	go,INITSEG	!跳转到0x9000:go处,此时cs(代码段寄存器为0x9000)，CPU当前正在执行的代码在内存中的位置就是由cs:ip表示的
go: mov ax,cs
	mov ds,ax
	mov es,ax
	mov ss,ax			!将cs代码段寄存器的值分别给ds(数据段寄存器)、es(附加段寄存器)、ss(堆栈段寄存器)
	mov sp,#0XFF00		!栈顶地址：ss:sp(0x9FF00)

load_setup: