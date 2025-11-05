# libasm
Mandatory part
• The library must be called libasm.a.
• You must submit a main function that will test your functions and compile with your library to demonstrate that it is functional.
• You must rewrite the following functions in assembly:
◦ ft_strlen (man 3 strlen)
◦ ft_strcpy (man 3 strcpy)
◦ ft_strcmp (man 3 strcmp)
◦ ft_write (man 2 write)
◦ ft_read (man 2 read)
◦ ft_strdup (man 3 strdup, you can call to malloc)
• You must check for errors during syscalls and handle them properly when needed.
• Your code must set the variable errno properly.
• For that, you are allowed to call the extern ___error or errno_location.

Bonus part
You can rewrite these functions in assembly. The linked list functions will use the following structure:
typedef struct s_list {
	void *data;
	struct s_list *next;
} t_list;
• ft_atoi_base
	• Write a function that converts the initial portion of the string pointed to by str into an integer representation.
	• str is in a specific base, given as a second parameter.
	• Except for the base rule, the function should behave exactly like ft_atoi.
	• If an invalid argument is provided, the function should return 0.
		Examples of invalid arguments:
		◦ The base is empty or has only one character.
		◦ The base contains duplicate characters.
		◦ The base contains +, -, or whitespace characters.
		• The function should be prototyped as follows:
			int ft_atoi_base(char *str, char *base);
• ft_list_push_front
	• Create the function ft_list_push_front, which adds a new element of type t_list to the beginning of the list.
	• It should assign data to the given argument.
	• If necessary, it will update the pointer at the beginning of the list.
	• Prototype:
		void ft_list_push_front(t_list **begin_list, void *data);
• ft_list_size
	• Create the function ft_list_size, which returns the number of elements in the list.
	• Prototype:
		int ft_list_size(t_list *begin_list);
• ft_list_sort
	• Create the function ft_list_sort which sorts the list’s elements in ascending order by comparing two elements and their data using a comparison function.
	• Prototype:
		void ft_list_sort(t_list **begin_list, int (*cmp)());
	• The function pointed to by cmp will be used as:
		(*cmp)(list_ptr->data, list_other_ptr->data);
		cmp could be for instance ft_strcmp.
• ft_list_remove_if
	• Create the function ft_list_remove_if which removes from the list all elements whose data, when compared to data_ref using cmp, causes cmp to return 0.
	• The data from an element to be erased should be freed using free_fct.
	• Prototype:
		void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));
	• The functions pointed to by cmp and free_fct will be used as:
		(*cmp)(list_ptr->data, data_ref);
		(*free_fct)(list_ptr->data);


• You must write 64-bit assembly. Beware of the "calling convention".
• You can’t do inline ASM, you must do ’.s’ files.
• You must compile your assembly code with nasm.
• You must use the Intel syntax, not the AT&T syntax.
It is forbidden to use the compilation flag: -no-pie.
