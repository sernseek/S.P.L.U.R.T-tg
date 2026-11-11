// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/basic/heretic_summon/maid_in_the_mirror/examine(mob/user)
	. = ..()

	. += span_notice(LANG("mob.f6b9bbb27c9b59d0", null))
	. += span_notice(LANG("mob.0b44cf9c5ded4dcd", null))
	. += span_notice(LANG("mob.f3b7cbb91f7b539e", null))
	. += span_notice(LANG("mob.f08d60565e71addc", null))
