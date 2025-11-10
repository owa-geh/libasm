section .note.GNU-stack noalloc progbits
	db 0

section .text
extern malloc
extern errout
global ft_list_push_front
global ft_list_size
global ft_list_sort
global ft_list_remove_if

ft_list_push_front:
	cmp rsi,0			;nullcheck base*
	je .done
	push rsp
	push rdi
	mov rdi,16			;set 16 bytes as malloc size
	call malloc wrt ..plt
	pop rdi
	pop rsp
	cmp rax,0
	je .errnomem
	mov rcx,[rdi]		;store list_begin*
	mov [rax],rsi		;move data to new address*
	mov [rax+8],rcx		;move list_begin* to next*
	mov [rdi],rax		;move address* to arg1
	.done:
		ret
	.errnomem:
		mov rdi,12
		call errout

ft_list_size:
	mov rax,0
	push rbx
	cmp rdi,0			;nullcheck list*
	je .done
	.loop_size:
		inc rax
		mov rbx,[rdi+8]
		cmp rbx,0
		je .done
		mov rdi,[rdi+8]
		jmp .loop_size
	.done:
		pop rbx
		ret

ft_list_sort:
	push rdx
	push r13
	push r14
	push r15
	mov rax,[rdi]				;nullcheck list**
	cmp rax,0
	je .done
	cmp rsi,0					;nullcheck func*
	je .done

	mov rbx,rdi					;save list start**
	mov rdx,rsi					;save function*
	.loop_start:
		mov r13,[rbx]			;init prev*
		mov r14,[rbx]			;init left*
		.loop_sort:
			mov r15,[r14+8]		;get right data*
			cmp r15,0			;check it for null for exit
			je .done
			mov rdi,[r14]		;get data from left* for first arg
			mov rsi,[r15]		;get data from right* for second arg
			call rdx			;compare args
			cmp rax,0
			jg .swap			;swap if res below 0
			mov r13,r14			;prep previous*
			mov r14,r15			;prep next*
			jmp .loop_sort
			.swap:
				mov rsi,[r15+8]	;save right swapee's next*
				mov rdi,r14		;swap left* and right*
				mov r14,r15
				mov r15,rdi

				mov [r13+8],r14	;assign new next*'s
				mov [r14+8],r15
				mov [r15+8],rsi
				cmp r15,[rbx]	;check if we have to reassign the top node**
				jne .loop_start
				mov [rbx],r14
				mov rdi,rbx		;reassign parameter node**
				jmp .loop_start
	.done:
		pop r15
		pop r14
		pop r13
		pop rdx
		ret

%macro liberate 1
	mov rdi,%1	;prep arg1
	push rsi
	push rdx
	push rcx
	push rsp
	call rcx	;free *
	pop rsp
	pop rcx
	pop rdx
	pop rsi
%endmacro

ft_list_remove_if:
	push rax
	push rbx
	push r13
	push r14
	push r15
	mov rax,[rdi]				;nullcheck list**
	cmp rax,0
	je .done
	cmp rsi,0					;nullcheck comp string*
	je .done
	cmp rdx,0					;nullcheck comp func*
	je .done
	cmp rcx,0					;nullcheck free func*
	je .done

	mov rbx,rdi					;begin_list**
	.loop_start:
		mov r13,[rbx]			;init prev*
		mov r14,[rbx]			;init left*
		.loop_remove:
			mov r15,[r14+8]		;prep right*
			mov rdi,[r14]		;get data from left* for first arg
			cmp rdi,0
			je .done
			call rdx			;compare it with second arg
			cmp rax,0
			je .free			;free it if 0
			mov r13,r14			;prep prev*
			mov r14,r15			;prep left*
			cmp r15,0			;check it for null for exit
			je .done
			jmp .loop_remove
			.free:
				cmp [rbx],r14	;compare with top node*
				jne .continue
				mov [rbx],r15
				mov rdi,rbx		;reassign parameter node**
				.continue:
				mov [r13+8],r15	;link previous node to next*
				liberate [r14]
				liberate r14
				mov rdi,r14		;move list* to arg1
				cmp r15,0		;nullcheck next* for exit
				je .done
				mov r14,r15
				jmp .loop_remove
	.done:
		pop r15
		pop r14
		pop r13
		pop rbx
		pop rax
		ret
