let filedisplay = ref ""

let toolbar = GButton.toolbar  
	~orientation:`HORIZONTAL  
	~style:`BOTH
	~width:470
	~height:10
	~packing:(Ettoihc.menubox#pack ~expand:false) ()

let volbox = GPack.hbox
	~width: 90
	~packing:(Ettoihc.menubox#pack ~expand:false) ()
	
let infobar = GButton.toolbar  
  ~orientation:`HORIZONTAL  
  ~style:`BOTH
  ~width:80
  ~packing:(Ettoihc.menubox#pack ~expand:false) ()

(* Fichier en cours de lecture *)
let soundText =
  let scroll = GBin.scrolled_window
    ~hpolicy:`NEVER
    ~vpolicy:`NEVER
    ~shadow_type:`ETCHED_IN
    ~packing:Ettoihc.soundbox#add () in
  let txt = GText.view 
    ~packing:scroll#add ()
    ~editable: false  
    ~cursor_visible: false in
  txt#misc#modify_font_by_name "Monospace 10";
  txt

(* Fonctions du menu *)
let actDisplay filepath =
  if (filepath = "") then
    filedisplay := ""
  else
    (begin
      if Meta.Id3v1.has_tag filepath then
		    let t = Meta.Id3v1.read_file filepath in
		    filedisplay := Meta.Id3v1.getTitle t ^ " - " ^ Meta.Id3v1.getArtist t
	    else
		    filedisplay := filepath
    end);
  soundText#buffer#set_text (!filedisplay)

let play () =
  actDisplay !Current.filepath;
  Wrap.play_sound(!Current.filepath)

let precedent = (fun () ->
  if (!Current.indexSong != 0) then
      begin
  	    Current.indexSong := !Current.indexSong - 1;
  	    Current.filepath := List.nth !Current.playListFile !Current.indexSong;
        actDisplay !Current.filepath;
  	    play ()
      end
   else
      (if (!filedisplay != "") then
  	  begin
  	    Current.filepath := "";
        actDisplay "";
  	    Current.indexSong := 0;
  	    Wrap.stop_sound()
  	  end
      )
  )
  
let suivant = (fun () ->
  if (!Current.indexSong != List.length !Current.playListFile - 1) then
      begin
  	    Current.indexSong := !Current.indexSong + 1;
  	    Current.filepath := List.nth !Current.playListFile !Current.indexSong;
        actDisplay !Current.filepath;
  	    play ()
      end
   else
      (if (!filedisplay != "") then
  	  begin
  	    Current.filepath := "";
        actDisplay "";
  	    Current.indexSong := 0;
  	    Wrap.stop_sound()
  	  end
      )
  )

(* Bouton d'ouverture du fichier *) 
  
let open_button =
  let btn = GButton.tool_button 
    ~stock:`OPEN
    ~packing: toolbar#insert () in 
  ignore(btn#connect#clicked 
    (fun () ->
      Current.launchPlaylist filedisplay;
      Biblio.checkBiblio ();
      Ettoihc.biblioText#buffer#set_text (!Biblio.biblioForDisplay)));
  btn

(* Bouton Save *)

let save_button =
  let btn = GButton.tool_button
    ~stock: `SAVE
    ~packing: toolbar#insert () in
  ignore(btn#connect#clicked Ettoihc.saveDialog );
  btn

let separator1 = GButton.separator_tool_item ~packing: toolbar#insert ()

(* Bouton Previous *)

let previous_button =
  let btn = GButton.tool_button 
    ~stock:`MEDIA_PREVIOUS
    ~label:"Previous"
    ~packing:toolbar#insert () in
  ignore(btn#connect#clicked (fun () -> precedent ()));
  btn

(* Bouton Play/Pause *)

let playpause_button =  
  let btnplay = GButton.tool_button 
    ~stock:`MEDIA_PLAY
    ~label:"Play"
    ~packing:toolbar#insert () in
  let btnpause = GButton.tool_button 
    ~stock:`MEDIA_PAUSE
    ~label:"Pause"
    ~packing:toolbar#insert () in
  ignore(btnpause#connect#clicked 
    (fun () -> btnplay#misc#show (); btnpause#misc#hide (); 
               Ettoihc.pause := true; Wrap.pause_sound ()));
  ignore(btnplay#connect#clicked 
  	(fun () -> btnpause#misc#show (); btnplay#misc#hide ();
               Current.play (); play (); Ettoihc.pause := false)); 
  btnpause#misc#hide ()

(* Bouton Stop *)

let stop_button =
  let btn = GButton.tool_button 
    ~stock:`MEDIA_STOP
    ~label:"Stop"
    ~packing:toolbar#insert () in
  ignore(btn#connect#clicked (fun () -> 
    Current.filepath := "";
    Current.indexSong := 0;
    actDisplay "";
    Wrap.stop_sound()));
  btn

(* Bouton Next *)

let next_button =
  let btn = GButton.tool_button 
    ~stock:`MEDIA_NEXT
    ~label:"Next"
    ~packing:toolbar#insert () in
  ignore(btn#connect#clicked (fun () -> suivant ()));
  btn

let separator2 = GButton.separator_tool_item ~packing: toolbar#insert()

(* Barre de volume *)
let volume=
  let file_vol = ref 50. in
  let vol_change vol_b() =
    file_vol := vol_b#adjustment#value;
    Wrap.vol_sound (!file_vol /. 100.) in
  let adj= GData.adjustment 
    ~value:50.  
    ~lower:0.
    ~upper:110.  
    ~step_incr:1. () in
  let volume_scale = GRange.scale `HORIZONTAL
    ~draw_value:true
    ~show:true
    ~digits: 0
    ~adjustment:adj
    ~packing:volbox#add () in 
  ignore(volume_scale#connect#value_changed (vol_change volume_scale));
  volume_scale

(* Bouton "A propos" *)
let about_button =
  let dlg = GWindow.about_dialog
    ~authors:["Nablah"]
    ~version:"1.0"
    ~website:"http://ettoihc.wordpress.com/"
    ~website_label:"Ettoihc Website"
    ~position:`CENTER_ON_PARENT
    ~parent:Ettoihc.window
    ~width: 400
    ~height: 150
    ~destroy_with_parent:true () in
  let btn = GButton.tool_button 
    ~stock:`ABOUT 
    ~packing:infobar#insert () in
  ignore(btn#connect#clicked (fun () -> 
    ignore (dlg#run ()); dlg#misc#hide ()));
  btn

let _ =
  Wrap.init_sound();
  ignore(Ettoihc.window#event#connect#delete Ettoihc.confirm);
  Biblio.startBiblio ();
  Ettoihc.window#show ();
  GMain.main ();
  Wrap.destroy_sound()