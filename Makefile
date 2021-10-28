#set environment variable RM_INCLUDE_DIR to the location of redismodule.h
RM_INCLUDE_DIR=./
RMUTIL_LIBDIR = ./roaring
LIBS = -lroaring
LDFLAGS := -shared -lroaring
# find the OS
uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')

# Compile flags for linux / osx
ifeq ($(uname_S),Linux)
	SHOBJ_CFLAGS ?=  -fno-common -g -ggdb
	SHOBJ_LDFLAGS ?= -shared -Bsymbolic
else
	SHOBJ_CFLAGS ?= -dynamic -fno-common -g -ggdb
	SHOBJ_LDFLAGS ?= -bundle -undefined dynamic_lookup
endif
CFLAGS = -I$(RM_INCLUDE_DIR) -Wall -g -fPIC -lc -lm -std=gnu99  
CC=gcc

all: redis-roaring.so 

data-structure: src/data-structure.c data-structure.o
	$(CC) $(CFLAGS) $(LDFLAGS) -c -o $@ $<

redis-roaring.so: src/redis-roaring.o src/data-structure.o
	$(LD) -o $@ src/data-structure.o src/redis-roaring.o $(SHOBJ_LDFLAGS) $(LDFLAGS) -lc 

clean:
	rm -rf *.xo *.so *.o src/*.o

FORCE:
