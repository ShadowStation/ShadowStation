/*
	Stoned-MC Subsystem for pushing playercounts to ArcHub (https://affectedarc07.co.uk/BYOND-Hub)
	As long as youre running the stoned MC, and you track clients in a global list, this subsystem should just be a dropin code addition
	Your code may have a dedicated playercount var, or more efficient ways of file handling
	This code was designed to be modular, and compatible with /most/ StonedMC systems

	(C) AffectedArc07 2019 | Source: https://github.com/AffectedArc07/ArcHub-DMAPI
*/
SUBSYSTEM_DEF(ahub)
	name = "Hub"
	wait = 600 // 60 seconds delay, to avoid excess calls
	var/api_key
	var/last_playercount

// Stops people from viewing the API key. Yes I am that worried
/datum/controller/subsystem/ahub/vv_get_var(var_name)
	if(var_name == "api_key")
		return 0
	return ..()

/datum/controller/subsystem/ahub/Initialize(timeofday)
	api_key = trim(file2text("config/archub_api_key.txt"))
	..()

/datum/controller/subsystem/ahub/fire(resumed)
	if(GLOB.clients.len != last_playercount)
		var/list/http[] = world.Export("http://aa07.ml/archub.php?key=[api_key]&players=[GLOB.clients.len]")
		last_playercount = GLOB.clients.len // I love caching
		if(!http)
			can_fire = 0
			message_admins("Failed to push playercount to ArcHub. SSahub will no longer fire for this round, to avoid excess world.Export() calls.")
