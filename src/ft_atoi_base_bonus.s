%define IN_STR rdi
%define BASE_STR rsi
%define IN_CHAR ebx
%define BASE_CHAR edx
%define IN_STRLEN r8
%define BASE_STRLEN r9
%define IN_STR_ITER r10
%define BASE_STR_ITER r11
%define IN_CHAR_SIZE r12
%define BASE_ITER r13
%define BASE r14
%define NEGATIVE r15

section .note.GNU-stack noalloc progbits
	db 0

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

%macro get_char 4				;input string - string offset - char dst - char len
	push %1
	add %1,%2
	mov %3,0
	mov ecx,0
	mov cl,byte[%1]
	cmp cx,0xF0
	jge %%four_chars
	cmp cx,0xE0
	jge %%three_chars
	cmp cx,0xC0
	jge %%two_chars
	add %2,1
	mov %4,1
	jmp %%done
	%%two_chars:
		mov cx,word[%1]
		add %2,2
		mov %4,2
		jmp %%done
	%%three_chars:
		shl ecx,16
		mov ch,byte[%1+1]
		mov cl,byte[%1+2]
		add %2,3
		mov %4,3
		jmp %%done
	%%four_chars:
		mov ecx,dword[%1]
		add %2,4
		mov %4,4
	%%done:
		mov %3,ecx
		pop %1
%endmacro

ft_atoi_base:
	cmp IN_STR,0				;nullcheck input str*
	je .err_arg
	cmp BASE_STR,0				;nullcheck base str*
	je .err_arg

	call ft_strlen				;check param string for empty
	cmp rax,0
	je .err_arg
	mov IN_STRLEN,rax

	push IN_STR
	mov IN_STR,BASE_STR
	call ft_strlen				;check base for < 2 chars
	pop IN_STR
	cmp rax,1
	jle .err_arg
	mov BASE_STRLEN,rax

	mov NEGATIVE,1
	mov BASE_STR_ITER,0
	mov BASE_ITER,0
	mov BASE,0

	.loop_checkBase:
		cmp BASE_STRLEN,BASE_STR_ITER		;exit loop if done
		je .atoi
		get_char BASE_STR, BASE_STR_ITER, BASE_CHAR, IN_CHAR_SIZE
		inc BASE
		mov IN_STR_ITER,0
		mov IN_CHAR_SIZE,0
		.loop_checkChar:
			cmp BASE_STRLEN,IN_STR_ITER
			je .loop_checkBase				;end subloop if at base string end
			get_char BASE_STR, IN_STR_ITER, IN_CHAR, IN_CHAR_SIZE
			cmp BASE_STR_ITER,IN_STR_ITER
			je .loop_checkChar				;don't compare char with itself
			cmp IN_CHAR,BASE_CHAR			;compare current byte to index char
			je .err_arg						;exit if base has same character twice
			checkWhitespace .err_arg, .err_arg
			jmp .loop_checkChar

	.atoi:
		mov IN_STR_ITER,0
		mov IN_CHAR_SIZE,0
		mov rax,0							;init return val
		.atoi_str_offset:
			get_char IN_STR, IN_STR_ITER, IN_CHAR, IN_CHAR_SIZE
			checkWhitespace .incOffset, .negate
			sub IN_STR_ITER,IN_CHAR_SIZE	;go back one char after wsp check
		.loop_atoi:
			cmp IN_STRLEN,IN_STR_ITER		;exit at end of in str
			je .done
			get_char IN_STR, IN_STR_ITER, IN_CHAR, IN_CHAR_SIZE
			mov BASE_STR_ITER,0
			mov BASE_ITER,-1
			.loop_atoiChar:
				cmp BASE_STRLEN,BASE_STR_ITER;exit if char not in base
				je .done
				get_char BASE_STR, BASE_STR_ITER, BASE_CHAR, IN_CHAR_SIZE
				inc BASE_ITER
				cmp IN_CHAR,BASE_CHAR
				jne .loop_atoiChar
				imul rax,BASE				;multiply return val by base
				add rax,BASE_ITER			;add iterator to base val
				cmp NEGATIVE,-1				;check underflow
				je .check_underflow
				cmp rax,2147483647			;check overflow
				jg .err_ofl
				jmp .loop_atoi
		.check_underflow:
			dec rax
			cmp rax,2147483647
			jg .err_ofl
			inc rax
			jmp .loop_atoi
		.negate:
			neg NEGATIVE
		.incOffset:
			inc rbx
			jmp .atoi_str_offset

	.done:
		imul rax,NEGATIVE
		ret
	.err_arg:					;invalid argument
		mov rbx,22
		jmp .errno
	.err_ofl:					;overflow
		mov rbx,75
	.errno:
		call __errno_location wrt ..plt
		mov [rax],rbx
		mov rax,0
		ret
