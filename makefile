FLEX = flex
C = gcc
SCANNER = scanner.l
FILE = lex.yy.c
OUTPUT = scanner

build:
	$(FLEX) $(SCANNER)
	$(C) -o $(OUTPUT) $(FILE) -lfl
clean:
	rm -f $(FILE)


 
