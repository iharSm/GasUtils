.include "memory.s"
.include "printf.s"

.section .data
.section .text

#FUNCTIONS

.globl _start

_start:
#	movl $0, %edi
#	movl msg, %eax
#	incl %eax
#	movl $1, msg(,%edi,1)

call allocate_init
pushl %eax
call printf
pushl $1024
call allocate
pushl %eax
call printf
movl	$0, %ebx
movl	$1, %eax
int	$0x80




####################################
call allocate_init

pushl %eax
movl %esp, %ebp 

movl (%ebp), %ecx
#subl $4, %ecx
movl $4, %eax
movl $1, %ebx
movl $4, %edx
int $LINUX_SYSCALL


movl $1, %eax
int $LINUX_SYSCALL
