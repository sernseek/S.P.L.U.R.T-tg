// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/heretic_knowledge/rifle
	drafting_cost = 1

/datum/heretic_knowledge/rifle_ammo
	drafting_cost = 1

/obj/item/gun/ballistic/rifle/lionhunter/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.dc06957c005b87b1", null))
