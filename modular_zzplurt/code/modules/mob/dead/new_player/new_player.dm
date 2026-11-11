// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/dead/new_player/Topic(href, list/href_list)
	//maturity check
	if(!client?.maturity_prompt_whitelist && !SSmaturity_guard.age_check(src))
		return

	//discord check
	var/vibe_check = SSdiscord?.check_login(src)
	if(isnull(vibe_check))
		to_chat(usr, span_notice(LANG("mob.deffeb85c6516937", null)))
		return
	//vetted check
	var/vetted_check = SSplayer_ranks?.check_vetted(src)
	if(isnull(vetted_check))
		to_chat(usr, span_notice(LANG("mob.deffeb85c6516937", null)))
		return
	if(href_list["observe"] || href_list["toggle_ready"] || href_list["late_join"])
		if(!vibe_check)
			to_chat(src, span_warning(LANG("mob.bec7bbd0e35ab683", list(CONFIG_GET(string/discord_link), CONFIG_GET(string/verification_channel) ? "as indicated in #[CONFIG_GET(string/verification_channel)] " : ""))))
			return
		if(!vetted_check)
			to_chat(src, span_warning(LANG("mob.5e4594991888ee6b", null)))
			return
	. = ..()

// /mob/dead/new_player/update_title_screen()
// 	. = ..()
// 	if((client?.prefs?.read_preference(/datum/preference/toggle/hide_splashscreen) || (!client?.maturity_prompt_whitelist && CONFIG_GET(flag/age_prompt_system))) && SStitle.current_title_screen != DEFAULT_TITLE_SCREEN_IMAGE && SStitle.current_title_screen != DEFAULT_TITLE_LOADING_SCREEN)
// 		src << browse(DEFAULT_TITLE_SCREEN_IMAGE, "file=loading_screen.gif;display=0")
