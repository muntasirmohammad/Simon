.data
sequence:  .byte 0,0,0,0
count:     .word 4

.globl main
.text

main:
    la t0, sequence                             # t0 is the base address of sequence array
    li t1, 0                                    # t1 = 0
    li t2, 4                                    # t2 = 4

    WHILE:
        IF:
            beq t1, t2, ELSE                    # if (t1 >= t2) goto ELSE
        THEN:
            # Setting up function call to rand here:
            addi sp, sp, -1                     # Move stack pointer to increase stack size
            li a0, 4                            # a0 = 4
            jal rand                            # Jump and link to function rand (with parameter 4)
            # Take return value from random and store it in the array
            add t3, a0, x0                      # t3 = return value of rand function
            sb t3, 0(t0)                        # sequence[t1] = t5
            addi t0, t0, 1                      # Add one bit to t0 to change position of array
            addi t1, t1, 1                      # t1 += 1
            j WHILE                             # Jump back to while loop
        ELSE:                                   # exit
            li a7, 10                           # System call to exit
            ecall                               # Execute the call

# Takes in a number in a0, and returns a (sort of) random number from 0 to
# this number (exclusive)
rand:
    mv t0, a0
    li a7, 30
    ecall
    remu a0, a0, t0
    jr ra










    
    
    
