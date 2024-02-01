CC = gcc
CFLAGS = -Wall -Wextra -g

all: progs progt


progs: programme_s.c
	$(CC) $(CFLAGS) -o $@ $^
	
progt : programme_t.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f progs progt
