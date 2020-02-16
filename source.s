.data
.balign 4
invarr:
gum:
	.word 2
peanuts:
	.word 2
crackers:
	.word 2
mandms:
	.word 2
welcome:
	.asciz "Welcome to Phil's Vending Machine!\n"
costs:
	.asciz "Costs: Gum is $0.50, Peanuts is $0.55, Cheese Crackers is $0.65, and M&Ms are $1.00.\n"
select:
	.asciz "Enter item selection: Gum (G), Peanuts (P), Cheese Crackers (C), or M&Ms (M):\n"
selectdone:
	.asciz "You selected %s. Is this correct? (Y/N)\n"
gumstr:
	.asciz "Gum"
peanutstr:
	.asciz "Peanuts"
crackerstr:
	.asciz "Cheese Crackers"
mandmstr:
	.asciz "M&Ms"
moneyprompt:
	.asciz "Enter at least %d cents for selection.\n"
moneyinp:
	.asciz "Dimes (D), Quarters (Q), and Dollar Bills (B):\n"
moneyprog:
	.asciz "%d cents remaining...\n"
moneydone:
	.asciz "Enough money entered.\n"
disp:
	.asciz "%s has been dispensed.\n"
change:
	.asciz "Change of %d cents has been returned.\n"
perc:
	.asciz " %c"
wrongitem:
	.asciz "You inputted a key for an invalid item. Returning to selection...\n"
inventory:
	.asciz "Current Inventory:\nGum: %d\nPeanuts: %d\nCheese Crackers: %d\nM&Ms: %d\n"
empty:
	.asciz "We're sorry, we are out of %s!\n"

.text
.global main
.global printf
.global scanf
.global abs

.equ gumcost, 50
.equ peanutcost, 55
.equ crackercost, 65
.equ mandmcost, 100

main:
	PUSH { FP }
	MOV FP, SP
	LDR R0, =welcome
	BL printf
	LDR R0, =costs
	BL printf
mainloop:
	LDR R0, =invarr
	LDR R1, [R0]
	CMP R1, #0
	LDREQ R1, [R0, #4]
	CMPEQ R1, #0
	LDREQ R1, [R0, #8]
	CMPEQ R1, #0
	LDREQ R1, [R0, #12]
	CMPEQ R1, #0
	BEQ ret
	LDR R0, =select
	BL printf
	SUB SP, #4
	MOV R1, FP
	SUB R1, #4
	LDR R0, =perc
	BL scanf

cmpsec:
	MOV R0, FP
	SUB R0, #4
	MOV R1, #0
	LDRB R1, [R0]
	MOV R0, R1
	MOV R4, #0
	CMP R0, #'G'
	MOVEQ R4, #gumcost
	LDREQ R5, =gumstr
	MOVEQ R6, #0
	CMP R0, #'P'
	MOVEQ R4, #peanutcost
	LDREQ R5, =peanutstr
	MOVEQ R6, #4
	CMP R0, #'C'
	MOVEQ R4, #crackercost
	LDREQ R5, =crackerstr
	MOVEQ R6, #8
	CMP R0, #'M'
	MOVEQ R4, #mandmcost
	LDREQ R5, =mandmstr
	MOVEQ R6, #12
	CMP R0, #'i'
	BLEQ dispinv
	BEQ mainloop
	CMP R4, #0
	BEQ err
	LDR R1, =invarr
	LDR R0, [R1, R6]
	CMP R0, #0
	BEQ emptyselec

verifyinp:
	LDR R0, =selectdone
	MOV R1, R5
	BL printf
	MOV R1, FP
	SUB R1, #4
	LDR R0, =perc
	BL scanf
	MOV R0, FP
	SUB R0, #4
	MOV R1, #0
	LDRB R1, [R0]
	MOV R0, R1
	CMP R0, #'Y'
	BNE mainloop

countcoins:
	LDR R0, =moneyprompt
	MOV R1, R4
	BL printf
	LDR R0, =moneyinp
	BL printf
countcoinsloop:
	LDR R0, =perc
	MOV R1, FP
	SUB R1, #4
	BL scanf
	MOV R0, FP
	SUB R0, #4
	MOV R1, #0
	LDRB R1, [R0]
	MOV R0, R1
	CMP R0, #'D'
	SUBEQ R4, #10
	CMP R0, #'Q'
	SUBEQ R4, #25
	CMP R0, #'B'
	SUBEQ R4, #100
	CMP R4, #0
	BLE moneydonesec
	MOV R1, R4
	LDR R0, =moneyprog
	BL printf
	B countcoinsloop

moneydonesec:
	LDR R0, =moneydone
	BL printf
	MOV R0, R4
	BL abs
	MOV R4, R0
	LDR R0, =disp
	MOV R1, R5
	BL printf
	LDR R0, =change
	MOV R1, R4
	BL printf
	LDR R1, =invarr
	LDR R0, [R1, R6]
	SUB R0, #1
	STR R0, [R1, R6]
	B mainloop

err:
	LDR R0, =wrongitem
	BL printf
	B mainloop

emptyselec:
	LDR R0, =empty
	MOV R1, R5
	BL printf
	B mainloop

ret:
	POP { FP }
	MOV R7, #1
	SVC 0

dispinv:
	PUSH { LR }
	STMFD SP, { FP }^
	SUB SP, #8
	MOV FP, SP
	LDR R0, =inventory
	LDR R1, =gum
	LDR R1, [R1]
	LDR R2, =peanuts
	LDR R2, [R2]
	LDR R3, =crackers
	LDR R3, [R3]
	LDR R4, =mandms
	LDR R4, [R4]
	PUSH { R4 }
	BL printf
	ADD SP, #4
	LDMFD SP, { FP }^
	ADD SP, #8
	POP { PC }
