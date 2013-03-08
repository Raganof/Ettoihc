#include <caml/mlvalues.h>
#include <stdlib.h>
#include <stdio.h>
#include <SDL/SDL.h>
#include "../lib/inc/fmod.h"

#define LARGEUR_FENETRE 512 /* DOIT rester à 512 impérativement car il y a 512 barres (correspondant aux 512 floats) */
#define HAUTEUR_FENETRE 400 /* Vous pouvez la faire varier celle-là par contre */
#define RATIO (HAUTEUR_FENETRE / 255.0)
#define DELAI_RAFRAICHISSEMENT 25 /* Temps en ms entre chaque mise à jour du graphe. 25 ms est la valeur minimale. */
#define TAILLE_SPECTRE 512

static void setPixel(SDL_Surface *surface, int x, int y, Uint32 pixel);