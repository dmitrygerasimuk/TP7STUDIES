TARGET ?= bmptoascii
CC=g++
SRCDIR=src
STD=c++11
EXTENSION_SOURCE=cpp
EXTENSION_HEADER=h


CFLAGS= -std=$(STD) -O2
LDFLAGS=
LDLIBS= -lm

SRC= $(wildcard *.$(EXTENSION_SOURCE)) $(wildcard $(SRCDIR)/*.$(EXTENSION_SOURCE))
OBJ= ${SRC:.c=.o}

all: $(TARGET)

$(TARGET): ${OBJ}
	@echo "Generation de l'executable"
	@$(CC) -o $@ $^ $(LDFLAGS) $(LDLIBS) $(CFLAGS)

.PHONY: clean

clean:
	@rm -rf *~ *.o
	@rm -f $(TARGET)
	@rm -f $(SRCDIR)/*~
	@rm -f $(SRCDIR)/*.o
	@echo "Nettoyage"

rebuild: clean $(TARGET)


