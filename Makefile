CFLAGS := -std=c99 -Wall -W
ifneq ($(shell uname),Darwin)
CFLAGS += -static
endif

CPPFLAGS := -D_GNU_SOURCE

ifdef DEBUG
CFLAGS += -g -O0
else
CFLAGS += -O -fomit-frame-pointer
endif

ifndef NOMUSL
CC := x86_64-linux-musl-gcc
endif

all: tube
ifndef DEBUG
	strip $<
	upx -qqq $<
endif

clean:
	$(RM) tube
