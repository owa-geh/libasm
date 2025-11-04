section .note.GNU-stack noalloc progbits
	db 0

section .text
global ft_strlen
global ft_strcpy
global ft_strcmp
global ft_strdup
global ft_read
global ft_write
global errout
global charraytest
global stringtest
extern __errno_location
extern malloc
extern malloc_usable_size

ft_strlen:
	mov rax,0					;init return register as counter to 0
	.loop:
		cmp byte[rdi+rax],0		;check if current character is null
		je .done				;if result equals 0, exit loop
		inc rax					;inc counter
		jmp .loop				;jump to .loop label
	.done:
		ret						;return string length in rax

ft_strcpy:

	push rcx					;push rcx to stack to avoid interference
	mov rcx,-1
	.loop:
		inc rcx					;inc counter
		mov dl,byte[rsi+rcx]	;move single byte from src arg + counter to byte register
		mov byte[rdi+rcx],dl	;move that byte to dst arg + counter
		cmp dl,0				;if byte == 0
		je .done				;->exit loop
		jmp .loop
	.done:
		mov rax,rdi				;return value = dst arg
		pop rcx					;restore rcx from stack
		ret

ft_strcmp:
	push rcx
	push rdx
	mov rcx,-1					;init counter register
	mov rax,0					;init return value
	.loop:
		inc rcx					;inc counter and move bytes at index to register d low and high
		mov dl,byte[rdi+rcx]
		mov dh,byte[rsi+rcx]
		cmp dl,0				;check both bytes for terminator and exit if true
		je .done01
		cmp dh,0
		je .done
		sub dl,dh				;subtract chars
		cmp dl,0				;check for 0
		je .loop				;if yes, loop
		jmp .done				;else exit
	.done01:
		cmp dh,0				;check other byte for zero
		je .done
		neg dh					;if false, negate other byte and return it
		mov dl,dh
		jmp .done
	.done:
		movsx rax,dl			;move dl to rax with sign extension
		pop rdx
		pop rcx
		ret

errout:
	call __errno_location wrt ..plt	;retrieve address of errno variable via procedure linkage table
	mov [rax],rdi					;...and save return code there
	mov rax,rsi						;set return value
	ret

ft_strdup:
	mov rsi,rdi					;store str in rsi
	push rsi					;push rsi onto stack
	call ft_strlen
	inc rax
	mov rdi,rax					;store strlen + 1 in rdi as arg for malloc
	push rsp					;push stack pointer since we're calling an external func
	call malloc wrt ..plt
	pop rsp
	pop rsi
	cmp rax,0					;nullcheck malloc return
	je .errnomem
	mov rdi,rax					;store mallocd address in rdi
	call ft_strcpy
	ret
	.errnomem:					;error handling:
		mov rdi,12
		mov rsi,0
		call errout
		ret

%macro sysc 5
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	mov rcx,%5
	syscall
	cmp rax,0
	jl .error					;if syscall return == below zero, return errno
%endmacro

ft_read:
	cmp edi,0						;check for bad fd or stdin
	jg .check_size
	je .stdin
	mov rax,-9
	jmp .error
	.check_size:
		push rsi
		push rdx
		sysc 8, rdi, 0, 1, 0		;lseek: retrieve file* offset
		mov r9,rax
		sysc 8, rdi, 0, 2, 0		;lseek: retrieve offset of eof
		mov r8,rax
		sub r8,r9					;<- max. possible read len
		sysc 8, rdi, r9, 0, 0		;lseek: reset file* offset

		pop rdx
		pop rsi
		;jmp .continue
		cmp rdx,r8					;limit read len if necessary
		jle .continue
		mov rdx,r8
	.continue:
		push rdx
		sysc 0, rdi, rsi, rdx, 0	;read
		add r9,rdx
		sysc 8, rdi, r9, 0, 0		;lseek: set new file *offset
		pop rdx
		mov rax,rdx					;return length param
		ret
	.error:
		neg rax						;failed syscall returns are -errno's, so they have to be negated first
		mov rdi,rax
		mov rsi,-1
		call errout
		ret
	.stdin:
		sysc 0, rdi, rsi, rdx, 0
		mov rax,-1
		.check_nl:
			inc rax
			cmp byte[rsi+rax],10
			jne .check_nl
			inc rax
			ret

ft_write:
	sysc 1, rdi, rsi, rdx, rcx	;write syscall
	ret
	.error:
		neg rax					;failed syscall returns are -errno's, so they have to be negated first
		mov rdi,rax
		mov rsi,-1
		call errout
		ret
