// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/silicon/get_silicon_flavortext()
	. = ..()
	if(!CONFIG_GET(flag/check_vetted))
		return
	if(!client || !SSplayer_ranks.initialized)
		return
	if(SSplayer_ranks.is_vetted(client, admin_bypass = FALSE))
		. += span_greenannounce(LANG("mob.d254c798364058e6", null))

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(!CONFIG_GET(flag/check_vetted))
		return
	if(!client || !SSplayer_ranks.initialized)
		return
	if(SSplayer_ranks.is_vetted(client, admin_bypass = FALSE))
		. += span_greenannounce(LANG("mob.d254c798364058e6", null))
