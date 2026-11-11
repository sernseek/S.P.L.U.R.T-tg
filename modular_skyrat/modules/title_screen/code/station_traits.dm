// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// STANDARD JOB TRAIT HANDLING
/datum/station_trait/job/on_lobby_button_click(mob/dead/new_player/user)
	if(SSticker.HasRoundStarted())
		to_chat(user, span_redtext(LANG("datum.833ea82afb29ed68", null)))
		return
	if (LAZYFIND(lobby_candidates, user))
		LAZYREMOVE(lobby_candidates, user)
		to_chat(user, span_redtext(LANG("datum.890821c46a086370", list(name))))
	else
		LAZYADD(lobby_candidates, user)
		to_chat(user, span_greentext(LANG("datum.445b94156d7d3b16", list(name))))

// SKUB TRAIT HANDLING
#define PRO_SKUB "pro-skub"
#define ANTI_SKUB "anti-skub"
#define SKUB_IDFC "i don't frikkin' care"

/datum/station_trait/skub/on_lobby_button_click(mob/dead/new_player/user)
	var/skub_stance = tgui_input_list(user, LANG("datum.ed03c378e1fdc35b", null), LANG("datum.999760ac20587d2c", null), list(ANTI_SKUB, SKUB_IDFC, PRO_SKUB))
	skubbers[user.ckey] = skub_stance
	to_chat(user, span_greentext(LANG("datum.1ef42906953cb1bc", list(skub_stance))))

#undef PRO_SKUB
#undef ANTI_SKUB
#undef SKUB_IDFC
