// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/carbon/human/examine(mob/user)
	.=..()
	if(!CONFIG_GET(flag/use_rr_opt_in_preferences))
		return
	var/mob/dead/observer/ghost = get_ghost(TRUE, TRUE)
	if(!(ghost?.client) && !client)
		return
	var/rr_status = client ? client.prefs.read_preference(/datum/preference/toggle/be_round_removed) : ghost.client.prefs.read_preference(/datum/preference/toggle/be_round_removed)
	. += span_info(LANG("mob.a4f8eee2e5fb6c54", list(rr_status ? COLOR_RED : COLOR_EMERALD, rr_status ? "Yes" : "No")))
