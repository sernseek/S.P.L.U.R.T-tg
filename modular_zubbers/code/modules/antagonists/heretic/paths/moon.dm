// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/suit/hooded/cultrobes/eldritch/moon
	damage_modifier = 1.2

/obj/projectile/moon_parade
	range = 20

/obj/item/clothing/neck/heretic_focus/moon_amulet/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.4663ae24f01f5d20", null))
