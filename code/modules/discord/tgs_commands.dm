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
	help_text = "Set the donation level of a user"
	admin_only = TRUE

/datum/tgs_chat_command/setdonor/Run(datum/tgs_chat_user/sender, params)
	var/lowerparams = replacetext(lowertext(params), " ", "") // Fuck spaces
	var/list/all_params = splittext(lowerparams, " ")
	if(all_params.len < 2)
		return "Insufficient parameters"
	var/dkey = all_params[1]
	var/lvl = text2num(all_params[2])
	if(lvl != null)
		var/datum/DBQuery/donorlevel = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET donor = '[sanitizeSQL(lvl)]' WHERE ckey = '[sanitizeSQL(dkey)]'")
		donorlevel.Execute()
		qdel(donorlevel)
		return "Donor level for ckey [dkey] set to [lvl]."