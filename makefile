O=logo

$O:lex.yy.c y.tab.c
	cc -o $O y.tab.c -lfl `pkg-config glib-2.0 --cflags --libs`

lex.yy.c:$O.l
	flex $O.l

y.tab.c:$O.y
	yacc -d $O.y


