#Global Variables#

.section .data
heap_begin:
	.long 0
current_break:
	.long 0
.equ HEADER_SIZE, 8
.equ HDR_AVAIL_OFFSET, 0
.equ HDR_SIZE_OFFSET, 4

.equ UNAVAILABLE, 0
.equ AVAILABLE, 1

.equ SYS_BRK, 45
.equ LINUX_SYSCALL, 0x80

.section .text

#FUNCTIONS#

#allocate_init
.globl #allocate_init
.type allocate_init, @function

allocate_init:
pushl %ebp
movl %esp, %ebp

movl $0, %ebx
movl $SYS_BRK, %eax
int $LINUX_SYSCALL

movl %ebp, %esp
popl %ebp
ret






