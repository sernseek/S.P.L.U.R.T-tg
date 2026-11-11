// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// TerraGov shotgun (this was gonna be in a proprietary shotgun shell type outside of 12ga at some point, wild right?)

/obj/item/gun/ballistic/shotgun/riot/sol
	name = "\improper Renoster Shotgun"
	desc = "A twelve gauge shotgun with an eight shell capacity underneath. Made for and used by TerraGov's various military branches."

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/guns48x.dmi'
	icon_state = "renoster"

	worn_icon = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/carwo_defense_systems/guns_worn.dmi'
	worn_icon_state = "renoster"

	lefthand_file = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/carwo_defense_systems/guns_lefthand.dmi'
	righthand_file = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/carwo_defense_systems/guns_righthand.dmi'
	inhand_icon_state = "renoster"

	inhand_x_dimension = 32
	inhand_y_dimension = 32

	SET_BASE_PIXEL(-8, 0)

	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/shotgun_heavy.ogg'
	rack_sound = 'modular_skyrat/modules/modular_weapons/sounds/shotgun_rack.ogg'
	suppressed_sound = 'modular_skyrat/modules/modular_weapons/sounds/suppressed_heavy.ogg'
	can_suppress = TRUE

	suppressor_x_offset = 7
	suppressor_y_offset = -3

	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/somewhatextended

	fire_delay = 8

/obj/item/gun/ballistic/shotgun/riot/sol/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_CARWO)

/obj/item/gun/ballistic/shotgun/riot/sol/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/shotgun/riot/sol/examine_more(mob/user)
	. = ..()

	. += LANG("obj.4ebc02c4868b7642", null)

	return .

/obj/item/gun/ballistic/shotgun/riot/sol/update_appearance(updates)
	if(sawn_off)
		suppressor_x_offset = 0
		SET_BASE_PIXEL(0, 0)

	. = ..()

// Shotgun but EVIL!

/obj/item/gun/ballistic/shotgun/riot/sol/evil
	desc = "A twleve gauge shotgun with an eight shell capacity underneath. This one is painted in a tacticool black."

	icon_state = "renoster_evil"
	worn_icon_state = "renoster_evil"
	inhand_icon_state = "renoster_evil"
