cmin: lex.yy.o cmin.tab.o
	gcc -o cmin $^

cmin.tab.h: src/cmin.y
	bison --debug --verbose -d src/cmin.y

cmin.tab.c: src/cmin.y
	bison -d src/cmin.y

lex.yy.c: src/cmin.lex cmin.tab.h
	flex  src/cmin.lex