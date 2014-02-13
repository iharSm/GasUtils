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

incl %eax #need next address
movl %eax, heap_begin
movl %eax, current_break

movl %ebp, %esp
popl %ebp
ret

##############################
#       allocate             #
##############################
#params: the size of the memory block we want to allocate
#returns: the address of the allocated memory in %eax. 0 if nothing is allocated


.global
.type allcate, @function
allocate:

pushl %ebp
movl %esp, %ebp
movl 8(%ebp), %eax  #size of memory block

movl heap_begin, %ecx  
loop:
cmpl %ecx, current_break #allocate new block if %ecx points at the current_break  
jge allocate_new

cmpl HDR_SIZE_OFFSET(%ecx), %eax #check if new block of memory fits free space
jg next_block 

cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%ecx) #check if new block is available
je next_block

movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%ecx) #mark block as unavailable
movl HDR_SIZE_OFFSET(%ecx), %ebx  # save old block  size
movl %eax, HDR_SIZE_OFFSET(%ecx) # set new size of the block
#prepare new block
addl %eax, %ecx
subl %eax, %ebx
movl $AVAILABLE, HDR_AVAIL_OFFSET(%ecx)
movl %ebx, HDR_SIZE_OFFSET(%ecx)
movl %ecx, %eax #copy new block address
jmp done

next_block:   #go to the next block
addl HDR_SIZE_OFFSET(%ecx), %ecx
addl $HEADER_SIZE, %ecx

jmp loop

allocate_new:
movl $SYS_BRK, %eax
movl  8(%ebp), %ebx
addl current_break, %ebx
movl %ebx, current_break
movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%ecx) #mark block as unavailable
movl HDR_SIZE_OFFSET(%ecx), %ebx  # save old block  size
movl %eax, HDR_SIZE_OFFSET(%ecx) # set new size of the block
int $LINUX_SYSCALL 

done:
movl %ebp, %esp
popl %ebp
ret







