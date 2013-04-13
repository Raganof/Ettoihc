#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include "lecture.h"
#include "playlist.h"
#include "spectre.h"
#include "effects.h"

FMOD_SYSTEM     *systemSong = NULL;
FMOD_SOUND      *sound = NULL;
FMOD_DSP        *distortion = 0, *flange = 0, *echo = 0, *chorus = 0,
                *parameq = 0, *low_pass = 0, *high_pass = 0, *dsp0 = 0,
                *dsp1 = 0, *dsp2 = 0, *dsp3 = 0, *dsp4 = 0, *dsp5 = 0,
                *dsp6 = 0, *dsp7 = 0, *dsp8 = 0,*dsp9 = 0;
long            soundLength = 0;
int             egalizeurOn = 0;

value ocaml_play (value v)
{
  sound = playSong(systemSong, sound, String_val(v));
  return v;
}

value ocaml_length ()
{
  soundLength = getLength(sound);
  return Val_long(soundLength);
}

value ocaml_pause (value v)
{
  pauseSong(systemSong);
  return v;
}

value ocaml_stop (value v)
{
  stopSong(systemSong);
  return v;
}

value ocaml_vol (value v)
{
  adjustVol(systemSong, Double_val(v));
  return Val_unit;
}

value ocaml_destroy (value v)
{
  destroySystem(systemSong, sound);
  return v;
}

value ocaml_init (value v)
{
  systemSong = initSystemSon(systemSong);
  return v;
}

value ocaml_playlist (value n,value s)
{
  create_pl(String_val(n),String_val(s));
  return Val_unit;
}

value ocaml_biblio (value s)
{
  save_biblio(String_val(s));
  return Val_unit;
}

value ocaml_distortion (value v)
{
  distortion = distortion_event(systemSong, distortion, Double_val(v));
  return Val_unit;
}

value ocaml_echo (value v)
{
  echo = echo_event(systemSong, echo, Double_val(v));
  return Val_unit;
}

value ocaml_flange(value v)
{
  flange = flange_event(systemSong, flange);
  return v;
}

value ocaml_chorus (value v)
{
  chorus = chorus_event(systemSong, chorus);
  return v ;
}

value ocaml_rock (value v)
{
  if (egalizeurOn)
   {
    dsp0 = rock(systemSong, dsp0, 29., 1.);
    dsp1 = rock(systemSong, dsp1, 59., 1.);
    dsp2 = rock(systemSong, dsp2, 119., 1.);
    dsp3 = rock(systemSong, dsp3, 237., 1.);
    dsp4 = rock(systemSong, dsp4, 474., 1.);
    dsp5 = rock(systemSong, dsp5, 947., 1.);
    dsp6 = rock(systemSong, dsp6, 2000., 1.);
    dsp7 = rock(systemSong, dsp7, 4000., 1.);
    dsp8 = rock(systemSong, dsp8, 8000., 1.);
    dsp9 = rock(systemSong, dsp9, 15000., 1.);
    egalizeurOn = 0;
  } 
  else
  {
    dsp0 = rock(systemSong, dsp0, 29., 2.);
    dsp1 = rock(systemSong, dsp1, 59., 1.4);
    dsp2 = rock(systemSong, dsp2, 119., 0.625);
    dsp3 = rock(systemSong, dsp3, 237., 0.550);
    dsp4 = rock(systemSong, dsp4, 474., 0.800);
    dsp5 = rock(systemSong, dsp5, 947., 1.3);
    dsp6 = rock(systemSong, dsp6, 2000., 2.3);
    dsp7 = rock(systemSong, dsp7, 4000., 2.5);
    dsp8 = rock(systemSong, dsp8, 8000., 2.5);
    dsp9 = rock(systemSong, dsp9, 15000., 2.5);
    egalizeurOn = 1;
  }
  return v;
}

value ocaml_lpasse (value v)
{
  low_pass = low_pass_event(systemSong, low_pass);
  return v;
}

value ocaml_hpasse (value v)
{
  high_pass = high_pass_event(systemSong, high_pass);
  return v;
}
