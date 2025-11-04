section .note.GNU-stack noalloc progbits
	db 0

section .data
	offset dq 0
section .text
global ft_atoi_base
extern ft_strlen
extern __errno_location

%macro cmpChar 2
	cmp cl,%1
	je %2
%endmacro
%macro checkWhitespace 2		;check char for +, - or whitespace(space, \f, \n, \r, \t, \v)
	cmpChar 43,	%1
	cmpChar 45,	%2
	cmpChar 32,	%1
	cmpChar 12,	%1
	cmpChar 10,	%1
	cmpChar 13,	%1
	cmpChar 9,	%1
	cmpChar 11,	%1
%endMacro

ft_atoi_base:
	mov rax,0
	mov rbx,0
	mov rcx,0
	mov rdx,0
	mov r10,1					;negative var

	call ft_strlen				;check param string for empty
	cmp rax,0
	je .err_arg
	mov r8,rax					;r8 = str length

	push rdi
	mov rdi,rsi
	call ft_strlen				;check base for < 2 chars
	pop rdi
	cmp rax,1
	jle .err_arg
	mov r9,rax					;r9 = base length

	.loop_checkBase:			;move from base end to start
		dec rax
		cmp rax,-1				;exit loop if done
		je .atoi
		mov rcx,[rsi+rax]		;get char at index
		mov rbx,-1
		.loop_checkChar:
			inc rbx
			cmp r9,rbx
			je .loop_checkBase		;end subloop if at base string end
			cmp rax,rbx
			je .loop_checkChar		;don't compare char with itself
			cmp byte[rsi+rbx],cl	;compare current byte to index char
			je .err_arg				;exit if base has same character twice
			checkWhitespace .err_arg, .err_arg
			jmp .loop_checkChar

	.atoi:
		mov rbx,0					;init str counter
		mov rax,0					;init return val
		.atoi_str_offset:
			mov cl,byte[rdi+rbx]
			checkWhitespace .incOffset, .negate
			dec rbx
		.loop_atoi:
			inc rbx
			cmp r8,rbx
			je .done
			mov rcx,-1					;init base counter
			.loop_atoiChar:
				inc rcx
				cmp r9,rcx				;exit loop if char not in base
				je .done
				mov dl,byte[rdi+rbx]	;get str char
				mov dh,byte[rsi+rcx]	;get base char
				cmp dl,dh
				jne .loop_atoiChar
				imul rax,r9				;multiply return val by base length
				add rax,rcx				;add iterator to base val
				cmp r10,-1				;check underflow
				je .check_underflow
				cmp rax,2147483647		;check overflow
				jg .err_ofl
				jmp .loop_atoi
		.check_underflow:
			dec rax
			cmp rax,2147483647
			jg .err_ofl
			inc rax
			jmp .loop_atoi
		.negate:
			neg r10
		.incOffset:
			inc rbx
			jmp .atoi_str_offset

	.done:
		imul rax,r10
		ret
	.err_arg:					;invalid argument
		mov rbx,22
		jmp .errno
	.err_ofl:					;overflow
		mov rbx,75
	.errno:						;error handling:
		call __errno_location wrt ..plt	;retrieve address of errno variable
		mov [rax],rbx			;and save return code there
		mov rax,0				;set return value to 0
		ret