all: build


build:
	ocamlbuild -use-menhir -yaccflag --explain -cflags -annot main.native

