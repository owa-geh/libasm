#include "libasm_bonus.h"
#include "libasm.h"
#include <limits.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


/*
ft_atoi:
• Write a function that converts the initial portion of the string pointed to by str into its
integer representation.
• The string may begin with an arbitrary amount of whitespace (as determined by isspace(3)).
• The string may be preceded by an arbitrary number of ‘+’ and ‘-’ signs. A ‘-’ sign
will invert the result depending on whether the number of ‘-’ signs is odd or even.
• The function should then process any consecutive digits in base 10.
• The function reads the string until a non-conforming character is encountered and returns
the number obtained so far.
• Overflow and underflow do not need to be handled; the function’s return value is undefined
in such cases.

base:
• The base system consists of all the symbols used to represent the number.
◦ 0123456789 is the commonly used base system for representing decimal num-
bers.
◦ 01 is a binary base system.
◦ 0123456789ABCDEF is a hexadecimal base system.
◦ poneyvif is an octal base system.

ft_atoi_base
• Write a function that converts the initial portion of the string pointed to by str
into an integer representation.
• str is in a specific base, given as a second parameter.
• Except for the base rule, the function should behave exactly like ft_atoi.
• If an invalid argument is provided, the function should return 0.
Examples of invalid arguments:
◦ The base is empty or has only one character.
◦ The base contains duplicate characters.
◦ The base contains +, -, or whitespace characters.
*/

void test_atoi(char *teststr, char *str, char *base) {
	errno = 0;
	int res = ft_atoi_base(str, base);
	printf("testing %s res %d\terrno %d: %s\n", teststr, res, errno, strerror(errno));
}

void print_list(t_list *list) {
	if (list) {
		while (list) {
			printf("%s", list->data);
			list = list->next;
			if (list) printf(" - ");
		}
		printf("\n");
	}
}

int main(void) {
	printf("\n--------------- FT_ATOI_BASE ---------------------\n");
	test_atoi("123456789 base 10:\t", "123456789", "0123456789");
	test_atoi("INT_MAX base 10:\t", "2147483647", "0123456789");
	test_atoi("INT_MIN base 10:\t", "-2147483648", "0123456789");
	test_atoi("123456789 base 16:\t", "75BCD15", "0123456789ABCDEF");
	test_atoi("195948557 base 16:\t", "BADF00D", "0123456789ABCDEF");
	test_atoi("123456789 base 2:\t", "0111010110111100110100010101", "01");
	test_atoi("whitespace+ 123456789:\t", " \f\n\r\t\v+123456789", "0123456789");
	test_atoi("-123456789 base 10:\t", "-123456789", "0123456789");
	test_atoi("+- - 123456789 base 10:\t", "+- - 123456789", "0123456789");
	test_atoi("-123456789 base 10:\t", "-123456789", "0123456789");
	test_atoi("000555 56789 base 10:\t", "000555 56789", "0123456789");
	printf("\nerror tests:\n");
	test_atoi("err overflow:\t\t", "2147483648", "0123456789");
	test_atoi("err underflow:\t\t", "-2147483649", "0123456789");
	test_atoi("err base space:\t\t", "123456789", " 0123456789");
	test_atoi("err base \\f:\t\t", "123456789", "\f0123456789");
	test_atoi("err base \\n:\t\t", "123456789", "\n0123456789");
	test_atoi("err base \\r:\t\t", "123456789", "\r0123456789");
	test_atoi("err base \\t:\t\t", "123456789", "\t0123456789");
	test_atoi("err base \\v:\t\t", "123456789", "\v0123456789");
	test_atoi("err empty string:\t", "", "0123456789");
	test_atoi("err base too small:\t", "123456789", "0");
	test_atoi("err dbl base char:\t", "1234567890", "0123056789");
	test_atoi("err inv base char:\t", "1234567890", " 123456789");

	printf("\n------------------ FT_LIST -----------------------\n");
	//printf("list type size: %li\n", sizeof(t_list));
	t_list *p_list = NULL;
	printf("Null checks... ");
	ft_list_size(NULL);
	ft_list_size(p_list);
	ft_list_sort(&p_list, &ft_strcmp);
	ft_list_remove_if(&p_list, "Harl", &ft_strcmp, &free);
	ft_list_push_front(&p_list, ft_strdup("Arthur"));
	ft_list_remove_if(&p_list, NULL, &ft_strcmp, &free);
	ft_list_remove_if(&p_list, "Harl", NULL, &free);
	ft_list_remove_if(&p_list, "Harl", &ft_strcmp, NULL);
	ft_list_sort(&p_list, NULL);
	printf("OK!\n");

	printf("removing wrong element... ");
	ft_list_remove_if(&p_list, "Harl", &ft_strcmp, &free);
	printf("OK!\n");
	printf("list size: %i elements\n", ft_list_size(p_list));
	printf("sorting single element... ");
	ft_list_sort(&p_list, &ft_strcmp);
	printf("OK!\n");
	printf("removing single element... ");
	ft_list_remove_if(&p_list, "Arthur", &ft_strcmp, &free);
	printf("OK!\n");
	printf("list size: %i elements\n", ft_list_size(p_list));
	print_list(p_list);

	printf("populating list...");
	ft_list_push_front(&p_list, ft_strdup("Arthur"));
	ft_list_push_front(&p_list, ft_strdup("Ford"));
	ft_list_push_front(&p_list, ft_strdup("Marvin"));
	ft_list_push_front(&p_list, ft_strdup("Harl"));
	ft_list_push_front(&p_list, ft_strdup("Trillian"));
	ft_list_push_front(&p_list, ft_strdup("Harl"));
	ft_list_push_front(&p_list, ft_strdup("Zaphod"));
	ft_list_push_front(&p_list, ft_strdup("Harl"));
	printf("OK!\n");
	printf("unsorted list: ");
	print_list(p_list);
	printf("list size: %i elements\n", ft_list_size(p_list));
	printf("removing Harl... ");
	ft_list_remove_if(&p_list, "Harl", &ft_strcmp, &free);
	printf("OK!\n");
	print_list(p_list);
	ft_list_sort(&p_list, &ft_strcmp);
	printf("sorted list: ");
	print_list(p_list);
	printf("emptying list... ");
	ft_list_remove_if(&p_list, "Ford", &ft_strcmp, &free);
	ft_list_remove_if(&p_list, "Zaphod", &ft_strcmp, &free);
	ft_list_remove_if(&p_list, "Arthur", &ft_strcmp, &free);
	ft_list_remove_if(&p_list, "Marvin", &ft_strcmp, &free);
	ft_list_remove_if(&p_list, "Trillian", &ft_strcmp, &free);
	t_list *current = p_list;
		print_list(p_list);
	printf("OK!\n");
	printf("list size: %i elements\n", ft_list_size(p_list));
}
