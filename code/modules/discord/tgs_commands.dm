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
		return "Account not setup for linkage. Start the linking process in-game."