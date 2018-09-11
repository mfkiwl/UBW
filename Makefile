# external parameters
export CROSS_PREFIX = mipsel-linux-
export OPT_LEVEL = 3

# C compiler
CFLAGS := -c -O$(OPT_LEVEL) -mips1 -EL -G8 -Wall -Werror -std=gnu99
CFLAGS += -fno-builtin -nostdlib -nostdinc -fno-reorder-blocks
CFLAGS += -fno-reorder-functions -mno-abicalls -msoft-float
CFLAGS += -finline-functions
export CC := $(CROSS_PREFIX)gcc $(CFLAGS)

# assembler
ASFLAGS := -mips32 -EL   # in order to support instructions such as 'eret'
export AS := $(CROSS_PREFIX)as $(ASFLAGS)

# linker
LDFLAGS := -nostdlib -n -EL
LD := $(CROSS_PREFIX)ld $(LDFLAGS)

# object copy
OBJCFLAGS := -O binary -j .text
OBJC := $(CROSS_PREFIX)objcopy $(OBJCFLAGS)

# object dump
OBJDFLAGS := -alD
OBJD := $(CROSS_PREFIX)objdump $(OBJDFLAGS)

# directory definitions
TARGET_DIR = ./build
SRC_DIR = ./src
TEST_DIR = ./test

# targets
TEST_OBJS_TXT    = $(wildcard $(TEST_DIR)/*.o)
TEST_TARGETS_TXT = $(patsubst %.o, $(TARGET_DIR)/%.bin, $(notdir $(TEST_OBJS_TXT)))
SRC_OBJS_TXT     = $(wildcard $(SRC_DIR)/*.o $(SRC_DIR)/library/*.o)

.PHONY: all ubw test ubw_make test_make test_targets clean

all: $(TARGET_DIR) test ubw

ubw: $(TARGET_DIR) ubw_make $(TARGET_DIR)/ubw.bin

test: $(TARGET_DIR) test_make test_targets

ubw_make:
	make -C $(SRC_DIR)

test_make:
	make -C $(TEST_DIR)

test_targets:
	$(eval TEST_TARGETS = $(TEST_TARGETS_TXT))
	$(MAKE) $(TEST_TARGETS)

clean:
	-rm -f $(TARGET_DIR)/*.elf
	-rm -f $(TARGET_DIR)/*.elf.s
	-rm -f $(TARGET_DIR)/*.bin
	make -C $(SRC_DIR) clean
	make -C $(TEST_DIR) clean

$(TARGET_DIR):
	mkdir $(TARGET_DIR)

$(TARGET_DIR)/%.elf: $(TEST_DIR)/%.o
	$(LD) -Ttext 0xbfc00000 -o $@ $^

$(TARGET_DIR)/ubw.elf: linker.ld
	$(eval SRC_OBJS = $(SRC_OBJS_TXT))
	$(LD) -T linker.ld -o $@ $(SRC_OBJS)
	$(OBJD) $@ > $@.s

$(TARGET_DIR)/%.bin: $(TARGET_DIR)/%.elf
	$(OBJC) -j .data $^ $@
