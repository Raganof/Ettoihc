open Meta

let actDisplay filepath filedisplay =
	if Id3v1.has_tag filepath then
		let t = Id3v1.read_file filepath in
		let s = Id3v1.getNum t ^ ", " ^ Id3v1.getTitle t in
		filedisplay := s ^ " - " ^ Id3v1.getArtist t
	else
		filedisplay := filepath

let addSong filepath filedisplay allFile playList listFile =
	if (List.mem filepath !listFile) then () else
	begin
    	actDisplay filepath filedisplay;
    	allFile := !allFile ^ !filedisplay ^ "\n";
    	playList := !playList ^ filepath ^ "\n";
    	listFile := !listFile @ [filepath]
    end

let cleanPlaylist filedisplay allFile playList listFile indexSong pause =
	allFile := "";
	playList := "";
	filedisplay := "";
	listFile := [];
	indexSong := 0;
	pause := true

let addPlaylist filepath filedisplay allFile playList listFile =
   	let ic = open_in filepath in
   	try
  		while true; do
    		 addSong (input_line ic) filedisplay allFile playList listFile;
  		done;
	with End_of_file ->
  	close_in ic

let get_extension s =
	let ext = String.sub s ((String.length s) - 4) 4 in
	match ext with
		|".mp3"-> true
		|_ -> false