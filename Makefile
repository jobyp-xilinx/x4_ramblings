PROGS:=$(patsubst %.c,%,$(wildcard *.c))

.PHONY: all
all: $(PROGS)
	@:

% : %.c
	musl-gcc -static -Wall -Wextra -Werror -std=gnu18 -O2 -g -o $@ $^

.PHONY: clean
clean:
	@rm -vf $(PROGS) *.o *~




