#include "../lib/inc/fmod.h"
#include "../lib/inc/fmod_errors.h"
#include "../lib/wincompat.h"
#include <stdio.h>

static void ERRCHECK(FMOD_RESULT problem)
{
    if (problem != FMOD_OK)
    {
        printf("FMOD error! (%d) %s\n", problem, FMOD_ErrorString(result));
        exit(-1);
    }
}


FMOD_SYSTEM      *system;
FMOD_RESULT       result;
FMOD_SOUND       *sound;

void playSong (char *name)
{
    FMOD_CHANNEL     *channel = 0;
    
    result = FMOD_System_CreateSound(system, name, FMOD_CREATESTREAM, 0, &sound);
    ERRCHECK(result); //Cree un stream pour la musique
    ERRCHECK(FMOD_Sound_SetMode(sound, FMOD_LOOP_OFF));
    
    ERRCHECK(FMOD_System_PlaySound(system, FMOD_CHANNEL_FREE, sound, 0, &channel));
}


// Create a System object and initialize.
void initSystemSon()
{
    ERRCHECK(FMOD_System_Create(&system));
    ERRCHECK(FMOD_System_Init(system, 32, FMOD_INIT_NORMAL, NULL));
}

    // Fin du programme
void destroySystem()
{
    result = FMOD_Sound_Release(sound);
    ERRCHECK(result);
    result = FMOD_System_Close(system);
    ERRCHECK(result);
    result = FMOD_System_Release(system);
    ERRCHECK(result);
}
