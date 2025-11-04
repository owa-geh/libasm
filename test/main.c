#include "libasm.h"
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void grn() {printf("\x1b[1;32m");}
void ylw() {printf("\x1b[1;33m");}
void rst() {printf("\x1b[1;0m\n");}

void test_write(char *testmsg, int fd, char *buf, size_t len) {
	ylw();printf("----- Write test %s -----", testmsg);rst();
	int res = write(fd, buf, len);
	ylw();printf("\nog write returns: %d, errno %d: %s", res, errno, strerror(errno));rst();
	errno = 0;
	res = ft_write(fd, buf, len);
	ylw();printf("\nft_write returns: %d, errno %d: %s", res, errno, strerror(errno));rst();
	errno = 0;
}

void test_strcmp(char *s1, char *s2) {
	int r1 = ft_strcmp(s1, s2);
	printf("%i = %i\n", r1, strcmp(s1, s2));
}

void test_read(char *teststr, const char *filename, ssize_t (*func)(int, void *, size_t), int bufsize, int len, int printbuf) {
	char *buf = malloc(bufsize + 1);
	int fd = open(filename, O_RDONLY);
	printf("opening %s -> fd = %i, errno %i: %s\n", filename, fd, errno, strerror(errno));
	errno = 0;
	int redd = func(fd, (void *)buf, len);
	buf[redd] = 0;
	ylw();printf("test %s on fd %i with len %i into buffer size %i: redd: %i, errno %i: %s",
		teststr, fd, len, bufsize, redd, errno, strerror(errno));rst();
	if (printbuf && fd > -1) printf("\nBuffer: %s\n", buf);

	if (fd > 2) close(fd);
	free(buf);
}


void test_seq_read(char *teststr, const char *filename, ssize_t (*func)(int, void *, size_t), int bufsize, int printbuf) {
	char *buf = malloc(bufsize + 1);
	int fd = open(filename, O_RDONLY);
	printf("opening %s -> fd = %i, errno %i: %s\n", filename, fd, errno, strerror(errno));
	errno = 0;
	int redd = 0, read_now = 100, len = 100;
	while (read_now == len && redd < 1000) {
		read_now = func(fd, (void *)buf + redd, len);
		redd += read_now;
		printf("read %i bytes, %i bytes total. ", read_now, redd);
		printf("File pointer @ %li\n", lseek(fd, 0, SEEK_CUR));
	}
	buf[redd] = 0;
	ylw();printf("test %s on fd %i with len %i into buffer size %i: redd: %i, errno %i: %s",
		teststr, fd, len, bufsize, redd, errno, strerror(errno));rst();
	if (printbuf && fd > -1) printf("\nBuffer: %s\n", buf);

	if (fd > 2) close(fd);
	free(buf);
}

void test_read_fd(char *teststr, int fd, ssize_t (*func)(int, void *, size_t), int bufsize, int printbuf) {
	char *buf = malloc(bufsize + 1);
	errno = 0;
	int redd = func(fd, (void *)buf, bufsize);
	buf[redd] = 0;
	ylw();printf("test %s on %i into buffer size %i: redd: %i, errno %i: %s",
		teststr, fd, bufsize, redd, errno, strerror(errno));rst();
	if (printbuf) printf("\nBuffer: %s\n", buf);

	free(buf);
}

int main(void) {
	grn();printf("\n\n-----------------------FT_STRLEN----------------");rst();
//	printf("strlen of NULL: %li\n", ft_strlen(NULL));//has to segfault
//	printf("strlen of int 42: %li\n", ft_strlen(42));//has to segfault
	printf("strlen of foobar123: %li\n", ft_strlen("foobar123"));

	grn();printf("\n\n-----------------------FT_READ------------------");rst();
	int out = 0;
	//test_read("og write buffer too small", "./test/test.txt", &read, 42, 673, out);//corrupts top size
	//test_read("ft_write buffer too small", "./test/test.txt", &ft_read, 42, 673, out);//corrupts top size
	test_read("og read bad fd", "farts", &read, 4096, 673, out);
	test_read("ft_read bad fd", "farts", &ft_read, 4096, 673, out);
	test_read("og read overread", "./test/test.txt", &read, 4096, 730, out);
	test_read("read overread", "./test/test.txt", &ft_read, 4096, 730, out);
	test_seq_read("og read sequential read", "./test/test.txt", &read, 673, out);
	test_seq_read("ft_read sequential read", "./test/test.txt", &ft_read, 673, out);
	//test_read_fd("og read stdin", 0, &read, 4096, 1);
	//test_read_fd("ft_read stdin", 0, &read, 4096, 1);
	//test_read_fd("og read stdout", 1, &read, 4096, 1);//redirs to stdin
	//test_read_fd("ft_read stdout", 1, &read, 4096, 1);
	//test_read_fd("og read stderr", 2, &read, 4096, 1);
	//test_read_fd("ft_read stderr", 2, &read, 4096, 1);

	grn();printf("\n\n----------------FT_STRDUP / FT_STRCPY-----------");rst();
//	char *fubar = ft_strdup(NULL);//has to segfault
//	char *fubar; ft_strcpy(fubar, NULL);//has to segfault
	int fd = open("./test/test.txt", O_RDONLY);//673 bytes
	char buf[4096];
	int redd = ft_read(fd, &buf, 397);
	buf[redd] = 0;
	close(fd);
	char *src = ft_strdup(buf);
	int len = ft_strlen(src) + 1;
	char *dst = malloc(len);
	char *ret = ft_strcpy(dst, src);
	ylw();printf("dst: ");rst();printf("%s\n", dst);
	ylw();printf("ret: ");rst();printf("%s\n", ret);
	ylw();printf("no terminator:");rst();
	buf[0] = 'X';
	buf[1] = 'Y';
	buf[2] = 'Z';
	//non-terminated string
	char str[6] = "foobar";
	char *str2 = strdup(str);
	printf("og strdup: %s\n\n", str2);
	free(str2);
	str2 = ft_strdup(str);
	printf("ft_strdup: %s\n\n", str2);

	grn();printf("\n\n-----------------------FT_STRCMP----------------");rst();
	//test_strcmp(NULL, "foobar");//has to segfault
	//test_strcmp("foobar", NULL);//has to segfault
	test_strcmp("fööbar", "fööbar");
	test_strcmp("foobar", "f0obar");
	test_strcmp("f0obar", "foobar");
	test_strcmp("foobarfoobar", "foobar");
	test_strcmp("foobar", "foobarfoobar");
	test_strcmp(str, "foobar");

	grn();printf("\n\n-----------------------FT_WRITE-----------------");rst();
	test_write("NULL", 1, NULL, ft_strlen(src));
	test_write("wrong fd", 5, src, 3);
	test_write("failed open", -1, src, 3);
	test_write("normal string", 1, buf, ft_strlen(src));
	test_write("overshoot", 1, str, 42);
	test_write("to stdin", 0, str, 42);

	free(dst);
	free(src);
	free(str2);
}
