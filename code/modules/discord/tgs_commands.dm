// Verify
/datum/tgs_chat_command/verify
	name = "verify"
	help_text = "Verifies your discord account and your BYOND account linkage"

/datum/tgs_chat_command/verify/Run(datum/tgs_chat_user/sender, params)
	var/lowerparams = replacetext(lowertext(params), " ", "") // Fuck spaces
	if(SSdiscord.account_link_cache[lowerparams]) // First if they are in the list, then if the ckey matches
		if(SSdiscord.account_link_cache[lowerparams] == "[SSdiscord.id_clean(sender.mention)]") // If the associated ID is the correct one
			SSdiscord.link_account(lowerparams)
			return "Successfully linked accounts"
		else
			return "That ckey is not associated to this discord account. If someone has used your ID, please inform an administrator."
	else
		return "Account not setup for linkage. Start the linking process in-game via the Special Verbs tab."

/datum/tgs_chat_command/setdonor
	name = "setdonor"
	help_text = "Set the donation level of a user! <ckey> <donorlevel>"
	admin_only = TRUE

/datum/tgs_chat_command/setdonor/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return "Insufficient parameters."
	var/dkey = all_params[1]
	var/lvl = all_params[2]
	if(lvl != null)
		var/datum/DBQuery/donorlevel = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET donor = '[sanitizeSQL(lvl)]' WHERE ckey = '[sanitizeSQL(dkey)]'")
		donorlevel.Execute()
		qdel(donorlevel)
		return "Donor level for ckey [dkey] set to [lvl]."

/datum/tgs_chat_command/idlookup
	name = "idlookup"
	help_text = "Allows you to perform a search for ckey or discord ID. <ckey/did> <ckey/discord ID>"
	admin_only = TRUE

/datum/tgs_chat_command/idlookup/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return "Insufficient parameters. Syntax: idlookup ckey/did ckey/discord ID"
	var/lookup_type = all_params[1]
	var/lookup_id = all_params[2]
	if(lookup_id != null)
		if(lookup_type == "ckey")
			var/returned_id = SSdiscord.lookup_id(lookup_id)
			if(returned_id)
				return "[returned_id] is linked to ckey [lookup_id]"
			else
				return "Ckey [lookup_id] has no associated Discord ID"
		else if(lookup_type == "did")
			var/returned_ckey = SSdiscord.lookup_ckey(lookup_id)
			if(returned_ckey)
				return "[returned_ckey] is linked to Discord ID [lookup_id]"
			else
				return "Discord ID [lookup_id] has no associated Ckey"
