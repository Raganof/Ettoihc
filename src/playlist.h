#ifndef _PLAYLIST_H_
#define _PLAYLIST_H_

void create_pl(char* s);

void del_pl(char* pathname);

void add_song(char* playlist_name, char* song_path);

void del_song(char* playlist_name, char* song_path);

#endif
