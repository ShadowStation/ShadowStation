/*

This file is a massively edited version of aa07's discord linking subsystem. We don't use this for notifications, we use it to assign donation rewards and other crap.
NOTES:
There is a DB table to track ckeys and associated discord IDs.
This system REQUIRES TGS, and will auto-disable if TGS is not present.
The SS uses fire() instead of just pure shutdown, so people can be notified if it comes back after a crash, where the SS wasnt properly shutdown
It only writes to the disk every 5 minutes, and it wont write to disk if the file is the same as it was the last time it was written. This is to save on disk writes
The system is kept per-server (EG: Terry will not notify people who pressed notify on Sybil), but the accounts are between servers so you dont have to relink on each server.

##################
# HOW THIS WORKS #
##################

MIDROUND:
1] Someone usees the link verb, it adds their discord ID to the list.
2] On fire, it will write that to the disk, as long as conditions above are correct

*/

SUBSYSTEM_DEF(discord)
	name = "Discord"
	wait = 3000
	init_order = INIT_ORDER_DISCORD

	var/list/account_link_cache = list() // List that holds accounts to link, used in conjunction with TGS
	var/enabled = 0 // Is TGS enabled (If not we wont fire because otherwise this is useless)

/datum/controller/subsystem/discord/Initialize(start_timeofday)
	// Check for if we are using TGS, otherwise return and disabless firing
	if(world.TgsAvailable())
		enabled = 1 // Allows other procs to use this (Account linking, etc)
	else
		can_fire = 0 // We dont want excess firing
		return ..() // Cancel

// Returns ID from ckey
/datum/controller/subsystem/discord/proc/lookup_id(lookup_ckey)
	var/datum/DBQuery/query_get_discord_id = SSdbcore.NewQuery("SELECT discord_id FROM [format_table_name("player")] WHERE ckey = '[sanitizeSQL(lookup_ckey)]'")
	if(!query_get_discord_id.Execute())
		qdel(query_get_discord_id)
		return
	if(query_get_discord_id.NextRow())
		. = query_get_discord_id.item[1]
	qdel(query_get_discord_id)

// Returns ckey from ID
/datum/controller/subsystem/discord/proc/lookup_ckey(lookup_id)
	var/datum/DBQuery/query_get_discord_ckey = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE discord_id = '[sanitizeSQL(lookup_id)]'")
	if(!query_get_discord_ckey.Execute())
		qdel(query_get_discord_ckey)
		return
	if(query_get_discord_ckey.NextRow())
		. = query_get_discord_ckey.item[1]
	qdel(query_get_discord_ckey)

// Finalises link
/datum/controller/subsystem/discord/proc/link_account(ckey)
	var/datum/DBQuery/link_account = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET discord_id = '[sanitizeSQL(account_link_cache[ckey])]' WHERE ckey = '[sanitizeSQL(ckey)]'")
	link_account.Execute()
	qdel(link_account)
	account_link_cache -= ckey

// Unlink account (Admin verb used)
/datum/controller/subsystem/discord/proc/unlink_account(ckey)
	var/datum/DBQuery/unlink_account = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET discord_id = NULL WHERE ckey = '[sanitizeSQL(ckey)]'")
	unlink_account.Execute()
	qdel(unlink_account)

// Clean up a discord account mention
/datum/controller/subsystem/discord/proc/id_clean(input)
	var/regex/num_only = regex("\[^0-9\]", "g")
	return num_only.Replace(input, "")