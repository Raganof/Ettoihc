#include <caml/mlvalues.h>
#include "lecture.h"
#include "playlist.h"
#include "spectre.h"

value ocaml_pause (value v)
{
  pauseSong();
  return v;
}

value ocaml_play (value v)
{
  playSong(String_val(v));
  return v;
}

value ocaml_stop (value v)
{
  stopSong();
  return v;
}

value ocaml_vol (value v)
{
  adjustVol(Double_val(v));
  return v;
}
  
value ocaml_destroy (value v)
{
  destroySystem();
  return v;
}

value ocaml_init (value v)
{
  initSystemSon();
  return v;
}

value ocaml_playlist (value n,value s)
{
  create_pl(String_val(n),String_val(s));
  return Val_unit;
}
