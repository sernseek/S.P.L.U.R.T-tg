// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/armorkit
	name = "rampart armor kit"
	desc = "A standard Nanotrasen security nanite armoring kit, for reinforcing outerwear."
	icon = 'modular_zzplurt/icons/obj/reinforcekits.dmi'
	icon_state = "sec_armor_kit"
	w_class = WEIGHT_CLASS_SMALL

	var/obj/item/clothing/target_armor = /obj/item/clothing/suit/armor/vest/alt/sec // Holds the typepath of the armor.
	var/datum/armor/actual_armor // Holds the real datum of the armor.
	var/target_slot = ITEM_SLOT_OCLOTHING
	var/change_allowed = TRUE
	var/list/target_allowed // = GLOB.security_vest_allowed
	var/target_body_parts_covered = CHEST

	var/armor_text = "standard Nanotrasen security armored vest"
	var/target_prefix = "rampart"

/obj/item/armorkit/Initialize(mapload)
	. = ..()
	var/armor_type = target_armor::armor_type
	if(ispath(armor_type))
		actual_armor = get_armor_by_type(armor_type)
	else
		actual_armor = get_armor_by_type(/datum/armor/none)
	target_allowed = GLOB.security_vest_allowed // You're killing me here.

/obj/item/armorkit/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/used = FALSE

	if(!isobj(interacting_with))
		return NONE

	var/obj/item/target = interacting_with
	var/obj/item/clothing/C = target

	if(!C)
		return NONE

	if(istype(C, /obj/item/clothing/suit/mod) || istype(C, /obj/item/clothing/head/mod))
		to_chat(user, LANG("obj.c5ce02abae2d07e8", list(src)))
		return NONE

	if(!(target.slot_flags & target_slot))
		to_chat(user, LANG("obj.4149a6a5eb10b12e", list(target, src)))
		return NONE

	var/datum/armor/curr_armor = C.get_armor()

	if(istype(curr_armor, /datum/armor/mod_theme))
		to_chat(user, LANG("obj.c5ce02abae2d07e8", list(src)))
		return NONE

	for(var/curr_stat in ARMOR_LIST_DAMAGE)
		if(curr_armor.get_rating(curr_stat) < actual_armor.get_rating(curr_stat))
			used = TRUE

	if(used)
		if(change_allowed)
			C.allowed = target_allowed
		C.body_parts_covered = target_body_parts_covered
		C.set_armor(actual_armor)
		C.cold_protection = target_armor::cold_protection
		C.min_cold_protection_temperature = target_armor::min_cold_protection_temperature
		C.heat_protection = target_armor::heat_protection
		C.max_heat_protection_temperature = target_armor::max_heat_protection_temperature
		C.max_integrity = target_armor::max_integrity
		C.resistance_flags = target_armor::resistance_flags
		user.visible_message(LANG("obj.9a1f1ee23e215c21", list(user, C, src)), \
		LANG("obj.03ba3eadc78d92b4", list(C, src, armor_text)))
		C.name = "[target_prefix] [C.name]"
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	to_chat(user, LANG("obj.5796409cd6a3067d", list(C)))
	return NONE

/obj/item/armorkit/helmet
	name = "rampart headgear kit"
	desc = "A standard Nanotrasen security nanite armoring kit, for reinforcing hats or other headgear."
	icon_state = "sec_helmet_kit"

	target_armor = /obj/item/clothing/head/helmet
	target_slot = ITEM_SLOT_HEAD
	change_allowed = FALSE
	target_body_parts_covered = HEAD
	// target_allowed = GLOB.security_vest_allowed

	armor_text = "standard Nanotrasen security helmet"
	// target_prefix = "rampart"

/obj/item/armorkit/blueshield
	name = "aegis armor kit"
	desc = "An elite Nanotrasen nanite armoring kit, for reinforcing outerwear."
	icon_state = "blueshield_armor_kit"

	target_armor = /obj/item/clothing/suit/armor/vest/blueshield
	// target_slot = ITEM_SLOT_OCLOTHING
	// change_allowed = TRUE
	// target_allowed = GLOB.security_vest_allowed

	armor_text = "elite Nanotrasen blueshield armored vest"
	target_prefix = "aegis"

/obj/item/armorkit/helmet/blueshield
	name = "aegis headgear kit"
	desc = "An elite Nanotrasen security nanite armoring kit, for reinforcing hats or other headgear."
	icon_state = "blueshield_helmet_kit"

	target_armor = /obj/item/clothing/head/beret/blueshield
	// target_slot = ITEM_SLOT_HEAD
	// change_allowed = FALSE
	// target_allowed = GLOB.security_vest_allowed

	armor_text = "elite Nanotrasen blueshield helmet"
	target_prefix = "aegis"
