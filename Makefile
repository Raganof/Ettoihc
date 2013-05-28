################### Tools #####################
BIN=bin/ettoihc
_DATE=${shell date +%Y-%m-%e_%p-%Ih%M}
BAKF=${_DATE}-Prog

################# C Compilation #################
CC= clang
CFLAGS= -W -Wall -pedantic -std=c99 -O2 -I  `ocamlc -where`
CS= src/wrap.c src/lecture.c src/effects.c src/playlist.c
HS=${CS:.c=.h}
OS=${CS:.c=.o}
CO=  wrap.o lecture.o effects.o playlist.o
.SUFFIXES: .c .h

############### Compilation OCaML ###############
OFLAGS= -I lablgtk2 -I src -I interface -I fmod/inc -I fmod/lib
OLIB=-cclib fmod/lib/libfmodex64.so
OCOPT=ocamlopt
OCAMLC=ocamlc
CMXA= bigarray.cmxa lablgtk.cmxa unix.cmxa
CMA= bigarray.cma lablgtk.cma unix.cma
ML= src/wrap.ml src/mp3.ml src/meta.ml interface/ettoihc.ml src/playlist.ml src/biblio.ml interface/current.ml interface/database.ml interface/mix.ml interface/header.ml interface/main.ml
MLI=${ML:.ml=.mli}
CMO=${ML:.ml=.cmo}
CMX=${ML:.ml=.cmx}
CMI=${MLI:.mli=.cmi}
CMA=${CMXA:.cmxa=.cma}

.SUFFIXES: .ml .mli .cmo .cmx .cmi .o .c

.ml.cmx:
	${OCOPT} -c ${OFLAGS} ${CMA} $<
.ml.cmo:
	${OCAMLC} -c ${OFLAGS} ${CMA} $<

.ml.mli:
	${OCAMLC} -i ${CMA} $< > $@
.c.o:
	${CC} -c  $<


################## Compilation Rules ###############################
all: Ettoihc

Ettoihc:
	${CC} ${CFLAGS} -c ${CS}
	${OCOPT} ${OFLAGS} -o ${BIN} ${CO} ${CMXA} ${ML} ${OLIB}

depend: .depend
.depend: ${ML} ${MLI}
	rm -f .depend
	${OCAMLDEP} ${ML} ${MLI} > .depend

clean::
	cd src/ && rm -f *~ *# *.cm? *.o
	cd interface/ && rm -f *~ *# *.cm? *.o
	cd bin/ && rm -f *~
	rm -f *~ *# *.o ${BIN}
	
cleanBiblio:
	rm bin/biblio
	echo "" > bin/biblio

#http://oandrieu.nerim.net/ocaml/lablgtk/doc/type_GWindow.html
#http://wiki.njh.eu/OCaml_and_SDL
