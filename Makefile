all: build


build:
	ocamlbuild -use-menhir -yaccflag --explain main.native

