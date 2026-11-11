/datum/tgs_chat_command/addvettedpass
	name = "addvettedpass"
	help_text = "addvettedpass <ckey> | Add someone to the age gate bunker bypass list"
	admin_only = TRUE

/datum/tgs_chat_command/addvettedpass/Run(datum/tgs_chat_user/sender, params)
	if(!SSplayer_ranks)
		return LANG("datum.63fd97c4872e3c1a", null)
	if(!CONFIG_GET(flag/age_gate_bunker))
		return LANG("datum.4ebfa58e0b5525e5", null)

	GLOB.vetted_passthrough |= ckey(params)
	GLOB.vetted_passthrough[ckey(params)] = world.realtime
	log_admin("[sender.friendly_name] has added [params] to the current round's vetted bypass list.")
	message_admins("[sender.friendly_name] has added [params] to the current round's vetted bypass list.")
	return LANG("datum.0dd62de8910b915a", list(params))

/datum/tgs_chat_command/revvettedpass
	name = "revvettedpass"
	help_text = "revvettedpass <ckey> | Remove someone from the age gate bunker bypass list"
	admin_only = TRUE

/datum/tgs_chat_command/revvettedpass/Run(datum/tgs_chat_user/sender, params)
	if(!SSplayer_ranks)
		return LANG("datum.63fd97c4872e3c1a", null)
	if(!CONFIG_GET(flag/age_gate_bunker))
		return LANG("datum.4ebfa58e0b5525e5", null)

	GLOB.vetted_passthrough -= ckey(params)
	log_admin("[sender.friendly_name] has removed [params] from the current round's vetted bypass list.")
	message_admins("[sender.friendly_name] has removed [params] from the current round's vetted bypass list.")
	return LANG("datum.0e3bce6c26945b61", list(params))

