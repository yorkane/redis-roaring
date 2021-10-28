CC ?= gcc
CFLAGS += -std=c99 -Wall -O3 -fPIC
LDFLAGS += -lm -shared -fPIC
MAKE ?= make
PREFIX ?= /usr/local
all: roaring

roaring: roaring.o
	$(CC) $(CFLAGS) -o libroaring.so $^ $(LDFLAGS) 

install: 
	mkdir -p /usr/include/roaring/
	cp *.h /usr/include/roaring/
	cp *.hh /usr/include/roaring/
	mv libroaring.so /usr/lib/
	ln -sf /usr/lib/libroaring.so /usr/lib/libroaring.so.2
clean:
	rm *.o *.so
.PHONY: all


