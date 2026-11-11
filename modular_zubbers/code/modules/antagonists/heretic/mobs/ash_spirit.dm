// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/basic/heretic_summon/ash_spirit/examine(mob/user)
	. = ..()

	. += span_notice(LANG("mob.e409fa3978e5a475", null))
