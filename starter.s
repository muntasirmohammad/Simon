.data
sequence:  .byte 0,0,0,0
count:     .word 4
black:     .word 0x000000
green:     .word 0x03fc07
red:       .word 0xff0000
blue:      .word 0x0000ff
purple:    .word 0xaa00aa
newline:   .string "\n"
here:      .string "here\n"
nothere:   .string "nothere\n"
sequencestr: .string "sequence is "
question:  .string "\nDo you want to play again?\nEnter 1 for YES\nEnter anything else for NO\n"
ty:    .string "\nThank you for playing!\n"


.globl main
.text

addi x4, x0, 1                # Used for Enhancement B Option 1 (Speeding up the game to increase difficulty)

main:
   # TODO: Before we deal with the LEDs, we need to generate a random
   # sequence of numbers that we will use to indicate the button/LED
   # to light up. For example, we can have 0 for UP, 1 for DOWN, 2 for
   # LEFT, and 3 for RIGHT. Store the sequence in memory. We provided
   # a declaration above that you can use if you want.
   # HINT: Use the rand function provided to generate each number
  
   # Set everything to black first
   lw a0, black
   li a1, 0
   li a2, 0
   jal setLED
   lw a0, black
   li a1, 1
   li a2, 0
   jal setLED
   lw a0, black
   li a1, 0
   li a2, 1
   jal setLED
   lw a0, black
   li a1, 1
   li a2, 1
   jal setLED
  
  
  
   la t0, sequence                             # t0 is the base address of sequence array
   li t1, 0                                    # t1 = 0
   li t2, 4                                    # t2 = 4
  
   li a7, 4
   la a0, sequencestr
   ecall
  
   WHILE:
       IF:
           beq t1, t2, ELSE                    # if (t1 == t2) goto ELSE
       THEN:
           # Setting up function call to rand here:
           li a0, 4                            # a0 = 4
           jal rand                            # Jump and link to function rand (with parameter 4)
           # Take return value from random and store it in the array
           add t3, a0, x0                      # t3 = return value of rand function
           sb t3, 0(t0)                        # sequence[t1] = t5
          
          
           # Printing the array
           li a7, 1
           mv a0, t3
           ecall
          
          
           addi t0, t0, 1                      # Add one bit to t0 to change position of array
           addi t1, t1, 1                      # t1 += 1
           j WHILE                             # Jump back to while loop
      
      
      
       ELSE:
           li a7, 4
           la a0, newline
           ecall
           addi t0, t0, -4                     # Letting t0 be the base address of the modified sequence array again
 
   # TODO: Now read the sequence and replay it on the LEDs. You will
   # need to use the delay function to ensure that the LEDs light up
   # slowly. In general, for each number in the sequence you should:
   # 1. Figure out the corresponding LED location and colour
   # 2. Light up the appropriate LED (with the colour)
   # 2. Wait for a short delay (e.g. 500 ms)
   # 3. Turn off the LED (i.e. set it to black)
   # 4. Wait for a short delay (e.g. 1000 ms) before repeating
  
  
   addi t1, x0, 0                              # t1 = 0 (COUNTER)
   addi t2, x0, 4                              # t2 = 4 (COUNT=4)


   li t4, 1                                    # t4 = 1
   li t5, 2                                    # t5 = 2
   li t6, 3                                    # t6 = 3
  
   WHILE1:
       IF1:
           beq t1, t2, DPAD
           lb t3, 0(t0)
           addi x3, x0, 500
           div x3, x3, x4                      # Increases difficulty by speeding up game by dividing time by the number of times the player has played again after winning
           beq t3, x0, RED                     # If t3 = 0, goto RED, top left
           beq t3, t4, GREEN                   # If t3 = 1, goto GREEN, top right
           beq t3, t5, BLUE                    # If t3 = 2, goto BLUE, bottom left
           beq t3, t6, PURPLE                  # If t3 = 3, goto PURPLE, bottom right
           j DPAD
        RED:
           lw a0, red
           li a1, 0
           li a2, 0
           jal setLED
          
           mv a0, x3
           lw a0, black
           li a1, 0
           li a2, 0
           jal setLED
          
           addi t1, t1, 1
           addi t0, t0, 1

           j WHILE1
       GREEN:
           lw a0, green
           li a1, 1
           li a2, 0
           jal setLED
           mv a0, x3
           jal delay
           lw a0, black
           li a1, 1
           li a2, 0
           jal setLED
          
           addi t1, t1, 1
           addi t0, t0, 1
          
           j WHILE1
       BLUE:
           lw a0, blue
           li a1, 0
           li a2, 1
           jal setLED
           mv a0, x3
           jal delay
           lw a0, black
           li a1, 0
           li a2, 1
           jal setLED
          
           addi t1, t1, 1
           addi t0, t0, 1
          
           j WHILE1
       PURPLE:
           lw a0, purple
           li a1, 1
           li a2, 1
           jal setLED
           mv a0, x3
           jal delay
           lw a0, black
           li a1, 1
           li a2, 1
           jal setLED
          
           addi t1, t1, 1
           addi t0, t0, 1
          
           j WHILE1
  
   # TODO: Read through the sequence again and check for user input
   # using pollDpad. For each number in the sequence, check the d-pad
   # input and compare it against the sequence. If the input does not
   # match, display some indication of error on the LEDs and exit.
   # Otherwise, keep checking the rest of the sequence and display
   # some indication of success once you reach the end.
   DPAD:
       addi t0, t0, -4                                     # NEGATIVE COUNT
       addi t1, x0, 0
       addi t2, x0, 4
       WHILE2:
           IF2:
               beq t1, t2, WIN
           THEN2:
               jal pollDpad
               li a7, 1                                    # Printing dpad input
               ecall
               mv t3, a0
               lb t4, 0(t0)
               bne t4, t3, LOSE
               addi t0, t0, 1
               addi t1, t1, 1
               j WHILE2
           WIN:                                            # Setting all win colours
               lw a0, green
               li a1, 0
               li a2, 0
               jal setLED
               lw a0, green
               li a1, 1
               li a2, 0
               jal setLED
               lw a0, green
               li a1, 0
               li a2, 1
               jal setLED
               lw a0, green
               li a1, 1
               li a2, 1
               jal setLED
               li a0, 1000
               jal delay
               lw a0, black
               li a1, 0
               li a2, 0
               jal setLED
               lw a0, black
               li a1, 1
               li a2, 0
               jal setLED
               lw a0, black
               li a1, 0
               li a2, 1
               jal setLED
               lw a0, black
               li a1, 1
               li a2, 1
               jal setLED
               addi x1, x0, 1                        # Using x1 to determine whether time should be sped up
               j pAgain
           LOSE:                                     # Setting all lose colours
               lw a0, red
               li a1, 0
               li a2, 0
               jal setLED
               lw a0, red
               li a1, 1
               li a2, 0
               jal setLED
               lw a0, red
               li a1, 0
               li a2, 1
               jal setLED
               lw a0, red
               li a1, 1
               li a2, 1
               jal setLED
               li a0, 1000
               jal delay
               lw a0, black
               li a1, 0
               li a2, 0
               jal setLED
               lw a0, black
               li a1, 1
               li a2, 0
               jal setLED
               lw a0, black
               li a1, 0
               li a2, 1
               jal setLED
               lw a0, black
               li a1, 1
               li a2, 1
               jal setLED
               addi x1, x0, 0                        # Using x1 to determine whether time should be sped up
               li x4, 1                              # Since player lost, x4 is set to 1 (speed is back to 1)
               j pAgain

          

pAgain:
   # TODO: Ask if the user wishes to play again and either loop back to
   # start a new round or terminate, based on their input.
   li a7, 4
   la a0, question
   ecall
   jal readInt
   addi t1, x0, 1
   mv t3, a0
  
              
   bne t3, t1, exit        # If the player does not want to play again, exit, otherwise code below is reached
  
   bne x1, t1, main        # If x1 != 1, (the player did not win the last round), simply jump back to main, otherwise code below is reached
  
   addi x4, x4, 1          # Speed is increased by 1
  
   j main
  
exit:
   li a7, 10
   ecall
  
  
# --- HELPER FUNCTIONS ---
# Feel free to use (or modify) them however you see fit
   
# Takes in the number of milliseconds to wait (in a0) before returning
delay:
   addi sp, sp, -8
   sw t0, 0(sp)
   sw t1, 4(sp)
   mv t0, a0
   li a7, 30
   ecall
   mv t1, a0
   lw t0, 0(sp)
   lw t1, 4(sp)
   addi sp, sp, 8
delayLoop:
   ecall
   sub t2, a0, t1
   bgez t2, delayIfEnd
   addi t2, t2, -1
delayIfEnd:
   bltu t2, t0, delayLoop
   jr ra

# Takes in a number in a0, and returns a (sort of) random number from 0 to
# this number (exclusive)
rand:
   addi sp, sp, -4                               # Making space on stack to save one register
   sw t0, 0(sp)                                  # Saving t0 on the stack
   mv t0, a0
   li a7, 30
   ecall
   remu a0, a0, t0
   lw t0, 0(sp)                                  # Restoring t0 from the stack
   addi sp, sp, 4                                # Deallocating the stack space
   jr ra
  
# Takes in an RGB color in a0, an x-coordinate in a1, and a y-coordinate
# in a2. Then it sets the led at (x, y) to the given color.
setLED:
   addi sp, sp, -8
   sw t0, 0(sp)
   sw t1, 4(sp)
   li t1, LED_MATRIX_0_WIDTH
   mul t0, a2, t1
   add t0, t0, a1
   li t1, 4
   mul t0, t0, t1
   li t1, LED_MATRIX_0_BASE
   add t0, t1, t0
   sw a0, (0)t0
   lw t0, 0(sp)
   lw t1, 4(sp)
   addi sp, sp, 8
   jr ra
  
# Polls the d-pad input until a button is pressed, then returns a number
# representing the button that was pressed in a0.
# The possible return values are:
# 0: UP
# 1: DOWN
# 2: LEFT
# 3: RIGHT
pollDpad:
   mv a0, zero
   li t1, 4
  
pollLoop:
   addi sp, sp, -12
   sw t1, 0(sp)
   sw t2, 4(sp)
   sw t3, 8(sp)
  
  
   bge a0, t1, pollLoopEnd
   li t2, D_PAD_0_BASE
   slli t3, a0, 2
   add t2, t2, t3
   lw t3, (0)t2
   bnez t3, pollRelease
   addi a0, a0, 1
   addi sp, sp, 12
   lw t1, 0(sp)
   lw t2, 4(sp)
   lw t3, 8(sp)
   j pollLoop
pollLoopEnd:
   j pollDpad
pollRelease:
   lw t3, (0)t2
   bnez t3, pollRelease
pollExit:
   jr ra

# Taken from sample.s, lab1 example code:
# Use this to read an integer from the console into a0. You're free
# to use this however you see fit.
readInt:
   addi sp, sp, -12
   li a0, 0
   mv a1, sp
   li a2, 12
   li a7, 63
   ecall
   li a1, 1
   add a2, sp, a0
   addi a2, a2, -3
   mv a0, zero
parse:
   blt a2, sp, parseEnd
   lb a7, 0(a2)
   addi a7, a7, -48
   li a3, 9
   bltu a3, a7, error
   mul a7, a7, a1
   add a0, a0, a7
   li a3, 10
   mul a1, a1, a3
   addi a2, a2, -1
   j parse
parseEnd:
   addi sp, sp, 12
   ret

error:
   li a7, 93
   li a0, 1
   ecall


