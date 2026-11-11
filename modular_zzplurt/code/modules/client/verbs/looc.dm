// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/client/looc(msg as text)
	var/vibe_check = SSdiscord?.check_login(usr)
	if(isnull(vibe_check))
		to_chat(usr, span_notice(LANG("client.deffeb85c6516937", null)))
		return
	else if(!vibe_check) //Dirty but I guess we gotta tell when the subsystem hasn't started
		to_chat(usr, span_warning(LANG("client.bec7bbd0e35ab683", list(CONFIG_GET(string/discord_link), CONFIG_GET(string/verification_channel) ? "as indicated in #[CONFIG_GET(string/verification_channel)] " : ""))))
		return
	var/vetted_check = SSplayer_ranks?.check_vetted(usr)
	if(isnull(vetted_check))
		to_chat(usr, span_notice(LANG("client.deffeb85c6516937", null)))
		return
	else if(!vetted_check)
		to_chat(usr, span_warning(LANG("client.b2f8fe08d6cdce81", null)))
		return

	. = ..()
