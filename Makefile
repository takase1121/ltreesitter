# !!!
# !!! You should probably be using `luarocks make` instead of this
# !!!
# !!! This is mostly for quick and dirty testing
# !!!

SRC=$(wildcard csrc/*.c) tree-sitter/lib/src/lib.c
OBJ=$(SRC:.c=.o)

INC := -Iinclude -Ilite-xl-plugin-api/include -Itree-sitter/lib/include
TS_INC := -Itree-sitter/lib/include -Itree-sitter/lib/src

CFLAGS := -O3 -Wall -Wextra -Werror -std=c99 -pedantic -fPIC
TS_CFLAGS := -O3 -Wall -Wextra -Werror -std=gnu99 -fPIC

LIBS :=
POSIX_LIBS := -ldl

ltreesitter.so: $(OBJ)
	$(CC) -shared -o $@ $^ $(LIBS) $(POSIX_LIBS)

ltreesitter.dll: $(OBJ)
	$(CC) -shared -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $(INC) $<

tree-sitter/%.o: tree-sitter/%.c
	$(CC) -c -o $@ $(TS_CFLAGS) $(TS_INC) $<

clean:
	$(RM) $(OBJ) ltreesitter.so ltreesitter.dll

.PHONY: clean
