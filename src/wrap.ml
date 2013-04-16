(*
  Fonctions C
*)
external playlistSave:  string-> string -> unit = "ocaml_playlist"
external egaliseur:     float -> float  -> unit = "ocaml_egaliseurPerso"
external biblioSave:    string-> unit   = "ocaml_biblio"
external init_sound:    unit  -> unit   = "ocaml_init"
external destroy_sound:	unit  -> unit   = "ocaml_destroy"
external play_sound:    string-> unit   = "ocaml_play"
external pause_sound:   unit  -> unit   = "ocaml_pause"
external length_sound:  unit  -> int    = "ocaml_length"
external time_sound:    unit  -> int    = "ocaml_time"
external stop_sound:    unit  -> unit   = "ocaml_stop"
external vol_sound:     float -> unit   = "ocaml_vol"
external dist_sound:    float -> unit   = "ocaml_distortion"
external echo_sound:    float -> unit   = "ocaml_echo"
external flange_sound:  unit  -> unit   = "ocaml_flange"
external chorus_sound:  unit  -> unit   = "ocaml_chorus"
external egal_sound:    string-> unit   = "ocaml_egaliseur"
external lpasse_sound:  unit  -> unit   = "ocaml_lpasse"
external hpasse_sound:  unit  -> unit   = "ocaml_hpasse"

(*external spectreTest:   int   -> unit   = "spectreTest"
external sdlTest:   unit   -> unit = "do_sdl_stuff"*)
external spectre:	unit	-> unit = "ocaml_spectre"
external init_sdl:	unit	-> unit = "ocaml_initSDL"
external destroy_sdl:	unit	-> unit = "ocaml_destroySDL"
