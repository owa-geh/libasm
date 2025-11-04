CC     = cc
AS     = nasm
AR     = ar rcs
NAME   = libasm.a
AFLAGS = -f elf64 -g -F dwarf
CFLAGS = -g -L. -lasm
FILES  = ft_libasm.s
BFILES = ft_atoi_base_bonus.s \
		 ft_list_bonus.s
AOBJ   = $(addprefix obj/, $(FILES:.s=.o))
AOBJ_B = $(addprefix obj/, $(BFILES:.s=.o))
VAL    = valgrind --leak-check=full --show-leak-kinds=all \
		 --track-origins=yes --show-mismatched-frees=yes --track-fds=yes

obj/%.o: src/%.s
	@mkdir -p obj
	@$(AS) $(AFLAGS) $< -o $@

all: $(NAME)

$(NAME): $(AOBJ)
	$(AR) $(NAME) $(AOBJ)

bonus: all $(AOBJ_B)
	$(AR) $(NAME) $(AOBJ_B)

clean:
	@rm -f $(AOBJ) $(AOBJ_B)
	@if [ -d obj ]; then rmdir obj; fi

fclean:	clean
	@rm -f $(NAME)

re: fclean all

test: re
	@clear
	@$(CC) $(CFLAGS) test/main.c $(NAME)
	@$(VAL) ./a.out #valgrind shows different strcmp results
#	@./a.out
#	@rm a.out

test_bonus: fclean bonus
	@clear
	@$(CC) $(CFLAGS) test/main_bonus.c $(NAME)
	@$(VAL) ./a.out
	@rm a.out

.PHONY: all bonus clean fclean re test test_bonus