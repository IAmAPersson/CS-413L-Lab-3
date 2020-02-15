.data
.balign 4
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

.text
.global main
.global printf
.global scanf

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
	CMP R0, #'P'
	MOVEQ R4, #peanutcost
	CMP R0, #'C'
	MOVEQ R4, #crackercost
	CMP R0, #'M'
	MOVEQ R4, #mandmcost
	CMP R0, #'i'
	BLEQ dispinv
	ADD SP, #4
	BEQ mainloop
	CMP R4, #0
	BEQ err
	B ret

err:
	LDR R0, =wrongitem
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
