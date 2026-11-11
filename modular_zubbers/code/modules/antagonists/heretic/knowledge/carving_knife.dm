// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/melee/rune_carver/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.5991bb3b8b764ee3", null))
