// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
ADMIN_VERB(discordbunker, R_SERVER, "切换 Discord 隔离区", "Toggles the Discord Bunker on or off.", ADMIN_CATEGORY_SERVER)
	if(!SSdbcore.IsConnected())
		to_chat(user, span_adminnotice(LANG("datum.014ecb6c76e09213", null)))
		return

	var/new_dbun = !CONFIG_GET(flag/discord_bunker)
	CONFIG_SET(flag/discord_bunker, new_dbun)

	log_admin("[key_name(user)] has toggled the Discord Bunker, it is now [new_dbun ? "on" : "off"]")
	message_admins("[key_name_admin(user)] has toggled the Discord Bunker, it is now [new_dbun ? "enabled" : "disabled"].")
	SSblackbox.record_feedback("nested tally", "discord_toggle", 1, list("Toggle Discord Bunker", "[new_dbun ? "Enabled" : "Disabled"]"))
	send2adminchat("Discord Bunker", "[key_name(user)] has toggled the Discord Bunker, it is now [new_dbun ? "enabled" : "disabled"].")

ADMIN_VERB(adddiscordbypass, R_SERVER, "添加 Discord 豁免", "Allows a given ckey to connect through the discord bunker for the round even if they haven't verified yet.", ADMIN_CATEGORY_SERVER)
	VERB_ARG(ckeytobypass, VERB_ARG_TYPE_TEXT, VERB_ARG_SOURCE_INPUT)
	if(!SSdbcore.IsConnected())
		to_chat(user, span_adminnotice(LANG("datum.d00907cc3c17b0e5", null)))
		return
	if(!SSdiscord)
		to_chat(user, span_adminnotice(LANG("datum.ef0b5ae3eea8b0ea", null)))
		return
	if(!CONFIG_GET(flag/discord_bunker))
		to_chat(user, span_adminnotice(LANG("datum.9ca8c33af481dceb", null)))
		return

	GLOB.discord_passthrough |= ckey(ckeytobypass)
	GLOB.discord_passthrough[ckey(ckeytobypass)] = world.realtime
	log_admin("[key_name(user)] has added [ckeytobypass] to the current round's discord bypass list.")
	message_admins("[key_name_admin(user)] has added [ckeytobypass] to the current round's discord bypass list.")
	send2adminchat("Discord Bunker", "[key_name(user)] has added [ckeytobypass] to the current round's discord bypass list.")

ADMIN_VERB(revokediscordbypass, R_SERVER, "撤销 Discord 豁免", "Revoke's a ckey's permission to bypass the discord bunker for a given round.", ADMIN_CATEGORY_SERVER)
	VERB_ARG(ckeytobypass, VERB_ARG_TYPE_TEXT, VERB_ARG_SOURCE_INPUT)
	if(!SSdbcore.IsConnected())
		to_chat(user, span_adminnotice(LANG("datum.d00907cc3c17b0e5", null)))
		return
	if(!SSdiscord)
		to_chat(user, span_adminnotice(LANG("datum.ef0b5ae3eea8b0ea", null)))
		return
	if(!CONFIG_GET(flag/discord_bunker))
		to_chat(user, span_adminnotice(LANG("datum.9ca8c33af481dceb", null)))
		return

	GLOB.discord_passthrough -= ckey(ckeytobypass)
	log_admin("[key_name(user)] has removed [ckeytobypass] from the current round's discord bypass list.")
	message_admins("[key_name_admin(user)] has removed [ckeytobypass] from the current round's discord bypass list.")
	send2adminchat("Discord Bunker", "[key_name(user)] has removed [ckeytobypass] from the current round's discord bypass list.")
