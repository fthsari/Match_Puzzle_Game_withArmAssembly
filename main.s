Stack_Size       EQU     0x400;
	
				 AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem        SPACE   Stack_Size
__initial_sp

				 AREA    RESET, DATA, READONLY
                 EXPORT  __Vectors
                 EXPORT  __Vectors_End

__Vectors        DCD     __initial_sp               ; Top of Stack
                 DCD     Reset_Handler              ; Reset Handler
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	Button_Handler					 
__Vectors_End    

				 AREA    |.text|, CODE, READONLY
Reset_Handler    PROC
                 EXPORT  Reset_Handler
				 ldr	 r0, =0xE000E100
				 movs	 r1,#1	
				 str	 r1,[r0]						 
			     CPSIE	 i					 
                 LDR     R0, =__main
                 BX      R0
                 ENDP

				 AREA	 button, CODE, READONLY
Button_Handler	 PROC
				 EXPORT	 Button_Handler
				 ldr	 r0, =0x40010010
				 ldr	 r1, [r0]
				 ldr	 r2, =0x000000FF
				 ands	 r1, r1, r2
				 movs	 r2, #128
				 cmp	 r1, r2
				 beq	 cursorR
backR			 lsrs	 r2, r2, #1
				 cmp	 r1, r2
				 beq	 cursorL
backL			 lsrs	 r2, r2, #1
				 cmp	 r1, r2
				 beq	 cursorD
backD			 lsrs	 r2, r2, #1
				 cmp	 r1, r2
				 beq	 cursorU
backU			 lsrs	 r2, r2, #1
				 cmp	 r1, r2
				 beq	 pressB			 
pressBBack		 ldr	 r1, =0x80000000
				 ldr	 r0, =0x40010010
				 str	 r1, [r0]
				 bx		 lr
				 ENDP
												;degisiklik fonksiyonlarinin icinde pressBBack kullanabiliriz
cursorR			 PROC
				 push	 {r4}
				 ldr	 r4, =0x00000118
				 mov	 r0, r8
				 ldr	 r3, =0xFFF00000
				 ands	 r0, r0, r3
				 lsrs	 r0, r0, #20 
				 cmp	 r0, r4
				 pop	 {r4}
				 beq	 backR
				 push	 {r1}
				 adds	 r0, r0, #40
				 lsls	 r0, r0, #20
				 mov	 r3, r8
				 ldr	 r1, =0x000FFFFF
				 ands	 r1, r1, r3
				 adds	 r0, r0, r1
				 mov	 r8, r0
				 pop	 {r1}
				 b		 backR
				 ENDP

cursorL			 PROC
				 push	 {r4}
				 movs	 r4, #0
				 mov	 r0, r8
				 ldr	 r3, =0xFFF00000
				 ands	 r0, r0, r3
				 lsrs	 r0, r0, #20 
				 cmp	 r0, r4
				 pop	 {r4}
				 beq	 backL
				 push	 {r1}
				 subs	 r0, r0, #40
				 lsls	 r0, r0, #20
				 mov	 r3, r8
				 ldr	 r1, =0x000FFFFF
				 ands	 r1, r1, r3
				 adds	 r0, r0, r1
				 mov	 r8, r0
				 pop	 {r1}
				 b		 backL
				 ENDP
					 
cursorD			 PROC
				 push	 {r4}
				 movs	 r4, #170
				 mov	 r0, r8
				 ldr	 r3, =0x000FFF00
				 ands	 r0, r0, r3
				 lsrs	 r0, r0, #8 
				 cmp	 r0, r4
				 pop	 {r4}
				 beq	 backD
				 push	 {r1}
				 adds	 r0, r0, #70
				 lsls	 r0, r0, #8
				 mov	 r3, r8
				 ldr	 r1, =0xFFF000FF
				 ands	 r1, r1, r3
				 adds	 r0, r0, r1
				 mov	 r8, r0
				 pop	 {r1}
				 b		 backD
				 ENDP
					 
cursorU			 PROC
				 push	 {r4}
				 movs	 r4, #30
				 mov	 r0, r8
				 ldr	 r3, =0x000FFF00
				 ands	 r0, r0, r3
				 lsrs	 r0, r0, #8 
				 cmp	 r0, r4
				 pop	 {r4}
				 beq	 backU
				 push	 {r1}
				 subs	 r0, r0, #70
				 lsls	 r0, r0, #8
				 mov	 r3, r8
				 ldr	 r1, =0xFFF000FF
				 ands	 r1, r1, r3
				 adds	 r0, r0, r1
				 mov	 r8, r0
				 pop	 {r1}
				 b		 backU
				 ENDP
					 
pressB			 PROC
				 push	 {r0-r3}
				 movs	 r1, #1
				 mov	 r0, r8
				 lsrs	 r0, r0, #20
cmpColumn		 cmp	 r0, #0
				 beq	 countedColumn
				 adds	 r1, r1, #1
				 subs	 r0, r0, #40
				 b		 cmpColumn
countedColumn	 mov	 r0, r8
				 lsrs	 r0, r0, #8
				 ldr	 r2, =0x00000FFF
				 ands	 r0, r0, r2
cmpRow			 cmp	 r0, #30
				 beq	 countedRow
				 adds	 r1, r1, #8
				 subs	 r0, r0, #70
				 b		 cmpRow
countedRow		 movs	 r2, #1
				 movs	 r3, #1
				 lsls	 r2, r2, r1
				 lsls	 r3, r3, r1
				 add	 r10, r10, r2
				 mov	 r0, r9
				 ands	 r3, r3, r0
				 cmp	 r2, r3
				 beq	 alreadyOne
				 add	 r9, r9, r2
				 pop	 {r0-r3}
				 b	 	 pressBBack
alreadyOne	 	 mvns	 r0, r3
				 mov	 r1, r10
				 subs	 r1, r1, r2
				 subs	 r1, r1, r2
				 mov	 r10, r1
				 mov	 r3, r9
				 ands	 r0, r0, r3
				 mov	 r9, r0
				 pop	 {r0-r3}
				 b		 pressBBack
				 ENDP

                 AREA    main, CODE, READONLY
                 EXPORT	 __main			 ;make __main visible to linker
				 IMPORT  yugioh_arka_scaled_wframe
				 IMPORT	 yugioh_arka_scaled
				 IMPORT	 colorTable
                 ENTRY
				 
__main			 PROC							;----------------------------------------------
				 ldr	 r0, =0x00001e00
				 mov	 r8, r0					;This is the starting point of the program. With the r8 register, we determined our cursor, that is, the first
				 movs	 r0, #0					;position of our frame, as the upper left corner and assigned it to the register. We reserved the r9 register
				 mov	 r9, r0					;to store the location information of the open cards.
				 b		 prt_scr
				 ENDP							;----------------------------------------------
				 				 
openCardCheck	 PROC							;----------------------------------------------
				 push	 {r0-r3}
				 movs	 r0, #1
				 mov	 r1, r12
cmpColumnC		 cmp	 r1, #0
				 beq	 countedColumnC
				 adds	 r0, r0, #1
				 subs	 r1, r1, #40			;At that moment, we determine which card region will
				 b		 cmpColumnC				;print to the screen. After determining which card we
countedColumnC	 mov	 r1, r11				;are on, we check whether that card area is open
cmpRowC			 cmp	 r1, #30				;before, and if it is open, we draw the color information
				 beq	 countedRowC			;from the address where the color information is to be
				 adds	 r0, r0, #8				;applied to the entire card area.
				 subs	 r1, r1, #70			
				 b		 cmpRowC
countedRowC		 movs	 r2, #1
				 lsls	 r2, r2, r0
				 mov	 r5, r0
				 mov	 r1, r9
				 ands	 r1, r1, r2
				 cmp	 r1, #0
				 pop	 {r0-r3}
				 beq	 openCardOut
				 ldr	 r4, =colorTable
				 lsls	 r5, r5, #2
				 ldr	 r6, [r4, r5]
				 b		 openCardActive
				 ENDP							;----------------------------------------------
								 
prt_scr          PROC				 
				 ldr     r0, =0x40010000
				 movs	 r6, #0
				 mov	 r12, r6			;min column count register
				 movs	 r6, #30
				 mov	 r11, r6			;min row count register
				 movs    r7, #0
				 mov     r2, r11          	;initialize row counter
                 mov     r3, r12          	;initialize column counter
				 str     r2, [r0]        	;update row register with first row count
				 str     r3, [r0, #0x4]  	;update column register with first column count
paint			 str     r6, [r0, #0x8]  	;write the color to screen at current row and column using color register
				 b		 openCardCheck							;---------------------------------------------------------------
openCardOut		 mov	 r1, r8
				 lsrs	 r1, r1, #20
				 cmp	 r1, r12
				 bne	 notFramed								;If there is a previously exposed card, this part jumps to a function to print that
				 mov	 r1, r8									;card in the color it should be and checks this situation. If the card is unopened
				 lsrs	 r1, r1, #8								;and framed according to the cursor's instant position, it prints the card's background.
				 ldr	 r4, =0x00000FFF
				 ands	 r1, r1, r4
				 ldr	 r4, =yugioh_arka_scaled_wframe
				 cmp	 r1, r11
				 beq	 Framed
notFramed		 ldr     r4, =yugioh_arka_scaled
Framed			 ldr	 r6, [r4, r7]				 			;---------------------------------------------------------------					 
				 
openCardActive	 movs	 r5, #255		;---------------------------------------------------------------
				 ands	 r5, r5, r6
				 lsls	 r5, r5, #16
				 movs    r1, #255
				 lsls	 r1, r1, #16
				 ands	 r1, r1, r6
				 lsrs 	 r1, r1, #16
				 adds	 r5, r5, r1					;This part is swapping R and B values
				 ldr	 r1, =0xff000000
				 adds	 r1, r1, r5
				 movs	 r5, #255
				 lsls    r5, r5, #8
				 ands	 r6, r6, r5
				 adds	 r6, r6 ,r1		;----------------------------------------------------------------
				 
				 adds    r7, r7, #4			;This line allows us to read the RGB values of the pixels sequentially with the r7 register. 
				 movs	 r5, #40
				 add	 r5, r5, r12
				 adds    r3, r3, #1      ;increment the column counter
                 cmp     r3, r5          ;check if we have reached the end of current row
				 bne     nc
                 mov     r3, r12          ;reset the column counter (move to the beginning of the row)            
				 movs	 r5, #70
				 add	 r5, r5, r11
				 adds    r2, r2, #1     ;increment the row counter
				 cmp     r2, r5        	;check if we have reached the end of the screen
                 bne     nr
				 
				 ldr	 r5, =0x00000118
				 movs	 r7, #0
				 cmp	 r5, r12
				 bne	 border_update
				 ldr	 r5, =0x000000aa
				 cmp	 r5, r11
				 beq	 refs
				 
				 b		 border_update
afterUpd		 mov     r2, r11          ;reset the row counter and column counter (move to the beginning of the screen)		
                 mov     r3, r12 
				 
				 ldr	 r0, =0x40010000
nr               str     r2, [r0]		  ;update the row register
nc               str     r3, [r0, #0x4]   ;update the column register
                 b       paint
				 
refs			 movs	 r7, #1
                 str     r7, [r0, #0xC]   ;refresh the screen
				 b		 checkTruth
not2CardOpen	 movs	 r7, #0
				 b		 border_update
                 ENDP
					 
checkTruth		 PROC							;-------------------------------------------------
				 push	 {r0-r4}
				 movs	 r4, #25
				 movs	 r3, #0
				 mov	 r0, r10
compareAgain	 movs	 r2, #1
				 ands	 r2, r2, r0				;In this region, we store the positions of the cards that
				 cmp	 r4, #0					;we have opened consecutively with our r10 register
				 beq	 compareFinished		;and it acts as a kind of counter to count how many
				 cmp	 r2, #1					;cards we have opened
				 beq	 yesOne
				 lsrs	 r0, r0, #1
				 subs	 r4, r4, #1
				 b		 compareAgain	 
yesOne			 adds	 r3, r3, #1
				 lsrs	 r0, r0, #1
				 subs	 r4, r4, #1
				 b		 compareAgain			;-------------------------------------------------
compareFinished	 cmp	 r3, #2
				 pop	 {r0-r4}
				 bne	 not2CardOpen
				 push	 {r0-r4}
				 ldr	 r0, =0x00000FFF
				 mov	 r1, r10
				 ands	 r0, r0, r1
				 lsrs	 r1, r1, #12
				 cmp	 r0, r1
				 bne	 clsUnmatchC			
				 movs	 r0, #0
				 mov	 r10, r0
				 pop	 {r0-r4}
				 b		 not2CardOpen
clsUnmatchC		 mov	 r0, r10
				 mov	 r1, r9
				 mvns	 r0, r0
				 ands	 r1, r1, r0
				 mov	 r9, r1
				 movs	 r0, #0
				 mov	 r10, r0
				 pop	 {r0-r4}
				 b		 not2CardOpen
				 ENDP							;-------------------------------------------------
					 
border_update	 PROC
				 ldr	 r1, =0x00000118
				 mov	 r0, r12
				 cmp	 r12, r1
				 beq	 columnEnd
				 adds	 r0, r0, #40
				 mov	 r12, r0
				 b	 	 afterUpd
columnEnd		 movs	 r0, #0		
				 mov	 r12, r0
				 ldr	 r1, =0x000000aa
				 mov	 r0, r11
				 cmp	 r11, r1
				 beq	 rowEnd
				 adds	 r0, r0, #70
				 mov	 r11, r0
				 b		 afterUpd
rowEnd			 movs	 r0, #30
				 mov	 r11, r0
				 b		 afterUpd
				 ENDP
                 END