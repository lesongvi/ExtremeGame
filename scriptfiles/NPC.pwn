#include <a_npc>



main() {}



NextPlayBack()
{
	StartRecordingPlayback(PLAYER_RECORDING_TYPE_ONFOOT,NPC);
}

public OnRecordingPlaybackEnd()
{
	NextPlayBack();
}
public OnNPCSpawn()
{
	NextPlayBack();
}
public OnNPCExitVehicle()
{
	StopRecordingPlayback();
}