// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/glassblowing/magnifying_glass
	name = "magnifying glass"
	desc = "A tool that, with the assistance of a magnifying lens, allows you to view what is small."
	icon_state = "magnifying_glass"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)

/obj/item/glassblowing/magnifying_glass/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_XENOARCH_QUALIFIED))
		. += span_notice(LANG("obj.cda304bef273487b", list(src)))

/datum/crafting_recipe/magnifying_glass
	name = "Magnifying Glass"
	result = /obj/item/glassblowing/magnifying_glass
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/glassblowing/glass_lens = 1,
	)
	category = CAT_EQUIPMENT
