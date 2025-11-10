# libasm
**Mandatory part**<br>
<br>
• The library must be called libasm.a.<br>
• You must submit a main function that will test your functions and compile with your library to demonstrate that it is functional.<br>
• You must rewrite the following functions in assembly:<br>
    ◦ ft_strlen (man 3 strlen)<br>
    ◦ ft_strcpy (man 3 strcpy)<br>
    ◦ ft_strcmp (man 3 strcmp)<br>
    ◦ ft_write (man 2 write)<br>
    ◦ ft_read (man 2 read)<br>
    ◦ ft_strdup (man 3 strdup, you can call to malloc)<br>
• You must check for errors during syscalls and handle them properly when needed.<br>
• Your code must set the variable errno properly.<br>
• For that, you are allowed to call the extern ___error or errno_location.<br>
<br>
**Bonus part**<br>
You can rewrite these functions in assembly. The linked list functions will use the following structure:<br>
typedef struct s_list {<br>
    void *data;<br>
    struct s_list *next;<br>
} t_list;<br>
• ft_atoi_base<br>
    • Write a function that converts the initial portion of the string pointed to by str into an integer representation.<br>
    • str is in a specific base, given as a second parameter.<br>
    • Except for the base rule, the function should behave exactly like ft_atoi.<br>
    • If an invalid argument is provided, the function should return 0.<br>
        Examples of invalid arguments:<br>
        ◦ The base is empty or has only one character.<br>
        ◦ The base contains duplicate characters.<br>
        ◦ The base contains +, -, or whitespace characters.<br>
        • The function should be prototyped as follows:<br>
            int ft_atoi_base(char *str, char *base);<br>
• ft_list_push_front<br>
    • Create the function ft_list_push_front, which adds a new element of type t_list to the beginning of the list.<br>
    • It should assign data to the given argument.<br>
    • If necessary, it will update the pointer at the beginning of the list.<br>
    • Prototype:<br>
        void ft_list_push_front(t_list **begin_list, void *data);<br>
• ft_list_size<br>
    • Create the function ft_list_size, which returns the number of elements in the list.<br>
    • Prototype:<br>
        int ft_list_size(t_list *begin_list);<br>
• ft_list_sort<br>
    • Create the function ft_list_sort which sorts the list’s elements in ascending order by comparing two elements and their data using a comparison function.<br>
    • Prototype:<br>
        void ft_list_sort(t_list **begin_list, int (*cmp)());<br>
    • The function pointed to by cmp will be used as:<br>
        (*cmp)(list_ptr->data, list_other_ptr->data);<br>
        cmp could be for instance ft_strcmp.<br>
• ft_list_remove_if<br>
    • Create the function ft_list_remove_if which removes from the list all elements whose data, when compared to data_ref using cmp, causes cmp to return 0.<br>
    • The data from an element to be erased should be freed using free_fct.<br>
    • Prototype:<br>
        void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));<br>
    • The functions pointed to by cmp and free_fct will be used as:<br>
        (*cmp)(list_ptr->data, data_ref);<br>
        (*free_fct)(list_ptr->data);<br>


• You must write 64-bit assembly. Beware of the "calling convention".<br>
• You can’t do inline ASM, you must do ’.s’ files.<br>
• You must compile your assembly code with nasm.<br>
• You must use the Intel syntax, not the AT&T syntax.<br>
It is forbidden to use the compilation flag: -no-pie.<br>
