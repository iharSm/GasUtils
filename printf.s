.section .data
.section .text

#input number to be printed
#4 bytes

.globl #printf
.type printf, @function
printf:
pushl %ebp 
movl %esp, %ebp
subl $10, %esp #reserve 10 bytes for a result ascii string
movl 8(%ebp), %eax #copy input number to %eax

# %ebp     	   %esp
# |....10 bytes.....|
#   ^---%ecx
#   |___%esi

#while > 0
movl %ebp, %ecx # %ecx will be tracking memory address to store next number
#subl $1, %ecx
movl $0, %esi #counter   

nextInt:
cmpl $10, %esi
jg Alldone

movl $10, %edi #divide %eax by 10 and take a reminder
movl $0, %edx
divl %edi
addl $48, %edx #add '0' to the reminder to get ascii character
movb %dl, (%ecx) # move 1 byte to to the reserved memory
subl $1, %ecx
addl $1, %esi

jmp nextInt
Alldone:

movl $4, %eax
movl %ebp, %ecx
subl $10, %ecx
movl $1, %ebx
movl $10, %edx
#subl $10, %ecx
int $0x80

movl %ebp, %esp
popl %ebp
ret
