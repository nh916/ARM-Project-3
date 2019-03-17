@ ========================== equ for 8 segment display==================
.equ SEG_A,0x80
.equ SEG_B,0x40
.equ SEG_C,0x20
.equ SEG_D,0x08
.equ SEG_E,0x04
.equ SEG_F,0x02
.equ SEG_G,0x01
.equ SEG_P,0x10
.equ SWI_SETSEG8, 0x200           @display on 8 Segmen
@ ==========================End equ for 8 segment display=================



@ ===========================Black buttons================================
.equ SWI_CheckBlack, 0x202         @check Black button 
.equ LEFT_BLACK_BUTTON,0x02        @bit patterns for black buttons 
.equ RIGHT_BLACK_BUTTON,0x01       @bit patterns for blue buttons 
@ =======================END Black buttons===============================




@=========================Blue Buttons===================================
.equ SWI_CheckBlue, 0x203          @check press Blue button
.equ BLUE_KEY_00, 0x01  @button(0) 
.equ BLUE_KEY_01, 0x02  @button(1) 
.equ BLUE_KEY_02, 0x04  @button(2) 
.equ BLUE_KEY_03, 0x08  @button(3) 
.equ BLUE_KEY_04, 0x10  @button(4) 
.equ BLUE_KEY_05, 0x20  @button(5) 
.equ BLUE_KEY_06, 0x40  @button(6) 
.equ BLUE_KEY_07, 0x80  @button(7) 
.equ BLUE_KEY_08, 1<<8  @button(8)
.equ BLUE_KEY_09, 1<<9  @button(9) 
.equ BLUE_KEY_10, 1<<10 @button(10) 
.equ BLUE_KEY_11, 1<<11 @button(11) 
.equ BLUE_KEY_12, 1<<12 @button(12) 
.equ BLUE_KEY_13, 1<<13 @button(13) 
.equ BLUE_KEY_14, 1<<14 @button(14) 
.equ BLUE_KEY_15, 1<<15 @button(15)
@======================END Blue Buttons======================================



@======================LCD====================================================
.equ SWI_DRAW_STRING, 0x204       @display a string on LCD
.equ SWI_CLEAR_DISPLAY,0x206      @clear LCD
.equ SWI_DRAW_INT, 0x205          @display an int on LCD 
@======================END LCD=================================================



@ ======================= Segments shortcut equ=================================
@ .equ ZEROS, SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
@ .equ ONES, SEG_B|SEG_C @1
@ .equ TWOS, SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
@ .equ THREES, SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3 
@ .equ FOURS, SEG_G|SEG_F|SEG_B|SEG_C @4 
@ .equ FIVES, SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5 
@ .equ SIXS, SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6
@ .equ SEVENS, SEG_A|SEG_B|SEG_C @7 
@ .equ EIGHTS, SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8
@ .equ NINES, SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9
@ .equ BLANKS, 0 @Blank display
@ .equ ERRORS, SEG_A|SEG_G|SEG_E|SEG_D|SEG_F @ E

@ .equ F, SEG_A|SEG_G|SEG_F|SEG_E @ F
@ ======================= END Segments shortcut equ==============================



@==============================END OF ALL EQU=====================================



Reset:
    swi SWI_CLEAR_DISPLAY   @clear LCD screen
    mov r7,#0   @put 0 into r7 to reset the r7 (the counter/result) to 0

    mov r0,#15  @ column number
    mov r1,#5   @ row number
    mov r2,r7   @ put r7 (the counter/result) into r2 for input print it to LCD
    swi SWI_DRAW_INT @display an int on LCD

@ ldr r2, =Zero   @ load address of Zero
@ swi SWI_DRAW_STRING

    ldr r0,=0   @clear 8 segment display
    swi SWI_SETSEG8   @Turn off the 8 segment display
    b infinantLoop @branch to infinant loop and wait for instructions


infinantLoop:

CheckForBlackButtons:
    swi SWI_CheckBlack                    @check if any of the black buttons has been pressed
        cmp r0, #LEFT_BLACK_BUTTON        @Check if Left button is pressed and then branch to reset
            beq Reset                     @if it has then branch to reset and start over again

        cmp r0, #RIGHT_BLACK_BUTTON       @Check if Right button pressed and then branch to reset
            beq Reset                     @if it has then branch to reset and start over again




CheckForBlueButtons:
    swi SWI_CheckBlue   @check if any of the blue buttons have been pressed
        
        cmp r0, #BLUE_KEY_00      @means 0.0 or 7 was pressed
            beq Displayseven      @Branch to Displayseven if r0 equal to the value for seven in the keypad

        cmp r0, #BLUE_KEY_01      @means 0.1 or 8 was pressed
            beq DisplayEight

        cmp r0, #BLUE_KEY_02      @means 0.02 or 9 was pressed
            beq DisplayNine

        cmp r0, #BLUE_KEY_03      @means 0.03 or N/A was pressed
            beq DisplayE          @ branches to DisplayE if r0 has the number that corresponds to the N/A key being pressed
        


        cmp r0, #BLUE_KEY_04    @means 1.0 or 4 was pressed
            beq DisplayFour

        cmp r0, #BLUE_KEY_05    @means 1.1 or 5 was pressed
            beq DisplayFive

        cmp r0, #BLUE_KEY_06    @means 1.2 or 6 was pressed
            beq DisplaySix       
        
        cmp r0, #BLUE_KEY_07    @means 1.3 or N/A was pressed
            beq DisplayE



        cmp r0, #BLUE_KEY_08   @means 2.0 or 1 was pressed
            beq DisplayOne

        cmp r0, #BLUE_KEY_09   @means 2.1 or 2 was pressed
            beq DisplayTwo  

        cmp r0, #BLUE_KEY_10   @means 2.2 or 3 was pressed
            beq DisplayThree

        cmp r0, #BLUE_KEY_11   @means 2.3 or N/A was pressed
            beq DisplayE       
        
        
        
        cmp r0, #BLUE_KEY_12    @means 3.0 or N/A was pressed
            beq DisplayE 
        
        cmp r0, #BLUE_KEY_13    @means 3.1 or 0 was pressed  
            beq DisplayZero 

        cmp r0, #BLUE_KEY_14    @means 3.2 or N/A was pressed
            beq DisplayE
        
        cmp r0, #BLUE_KEY_15    @means 3.3 or N/A was pressed
            beq DisplayE      




 b infinantLoop @branch to infinantLoop and keep checking for key pressed






DisplayE:
    ldr r0,=SEG_A|SEG_G|SEG_E|SEG_D|SEG_F   @E
    swi SWI_SETSEG8   @light up the 8 seg display
    
    @ Does nothing with the LCD and does not add anything to the counter. Only displays E on 8 seg display
    
    @ swi SWI_CLEAR_DISPLAY   @clear LCD screen
    @ mov r0,#0 @ column number 
    @ mov r1,#0 @ row number
    @ ldr r2, =Error   @ load address of Error
    @ swi SWI_DRAW_STRING @Prints the string on LCD
    
    b DisplayNumbersOnLCD

DisplayZero:
    ldr r0,=SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #0     @Adds 0 to r7 and keeps count
    
    b DisplayNumbersOnLCD   @branches to DisplayNumbersOnLCD to print that onto the LCD

DisplayOne:
    ldr r0,=SEG_B|SEG_C @1
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #1     @Adds 1 to r7 and keeps count
        
    b DisplayNumbersOnLCD

DisplayTwo:
    ldr r0,=SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #2     @Adds 2 to r7 and keeps count

    b DisplayNumbersOnLCD

DisplayThree:
    ldr r0,=SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3 
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #3     @Adds 3 to r7 and keeps count

    b DisplayNumbersOnLCD

DisplayFour:
    ldr r0,=SEG_G|SEG_F|SEG_B|SEG_C @4 
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #4     @Adds 4 to r7 and keeps count

    b DisplayNumbersOnLCD

DisplayFive:
    ldr r0,=SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #5     @Adds 5 to r7 and keeps count

    b DisplayNumbersOnLCD

DisplaySix:
    ldr r0,=SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6 
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #6     @Adds 6 to r7 and keeps count

    b DisplayNumbersOnLCD

Displayseven:
    ldr r0,=SEG_A|SEG_B|SEG_C @7 
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #7     @Adds 7 to r7 and keeps count

    b DisplayNumbersOnLCD

DisplayEight:
    ldr r0,=SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8 
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #8     @Adds 8 to r7 and keeps count

    b DisplayNumbersOnLCD

DisplayNine:
    ldr r0,=SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9 
    swi SWI_SETSEG8   @light up the 8 seg display

    add r7,r7, #9     @Adds 9 to r7 and keeps count

    b DisplayNumbersOnLCD   




DisplayNumbersOnLCD:
@ store the value pressed in a register then put that number in the register then display that value on the LCD with intiger

    swi SWI_CLEAR_DISPLAY   @clear LCD screen
    mov r2,r7   @move r7 (the addition holder) to r2 for the LCD display input, and get ready to print it
    mov r0,#15 @ column number 
    mov r1,#5 @ row number
    mov r2,r7   @ load address of Nine
    swi SWI_DRAW_INT @display an int on LCD

    b infinantLoop  @branches back up to infinantLoop and waits for another button press






.data
Zero: .asciz "0.0"
One: .asciz "1.0"
Two: .asciz "2.0"
Three: .asciz "3.0"
Four: .asciz "4.0"
Five: .asciz "5.0"
Six: .asciz "6.0"
Seven: .asciz "7.0"
Eight: .asciz "8.0"
Nine: .asciz "9.0"
Error: .asciz "N/A"

@ currently planning on coming back to clean up the code and make it better, but before that I will focus on other classes that I have huge project and tests 


@ Digits: 
@ .word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0 
@ .word SEG_B|SEG_C @1 
@ .word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2 
@ .word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3 
@ .word SEG_G|SEG_F|SEG_B|SEG_C @4 
@ .word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5 
@ .word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6 
@ .word SEG_A|SEG_B|SEG_C @7 
@ .word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8 
@ .word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9 
@ .word 0 @Blank display