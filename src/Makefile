.PHONY: all clean

ASM_FILES := $(patsubst %.s, %.o, $(wildcard *.s))
C_FILES   := $(patsubst %.c, %.o, $(wildcard *.c))

%.o: %.c
	$(CC) -o $@ $^

%.o: %.s
	$(CC) -x assembler-with-cpp -o $@ $^

all: $(ASM_FILES) $(C_FILES)
	make -C ./library

clean:
	-rm -f *.o
	make -C ./library clean
