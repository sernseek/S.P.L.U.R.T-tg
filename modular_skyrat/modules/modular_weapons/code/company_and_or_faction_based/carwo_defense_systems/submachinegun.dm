// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Base Sol SMG

/obj/item/gun/ballistic/automatic/sol_smg
	name = "\improper Sindano Submachine Gun"
	desc = "A small submachine gun firing .35 Sol. Commonly seen in the hands of PMCs and other unsavory corpos. Accepts any standard Sol pistol magazine."

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/carwo_defense_systems/guns32x.dmi'
	icon_state = "sindano"

	lefthand_file = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/carwo_defense_systems/guns_lefthand.dmi'
	righthand_file = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/carwo_defense_systems/guns_righthand.dmi'
	inhand_icon_state = "sindano"

	special_mags = TRUE

	bolt_type = BOLT_TYPE_OPEN

	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BELT

	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	spawn_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol/stendo

	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/smg_light.ogg'
	can_suppress = TRUE

	suppressor_x_offset = 11

	burst_size = 3
	fire_delay = 0.2 SECONDS

	spread = 7.5

/obj/item/gun/ballistic/automatic/sol_smg/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_CARWO)

/obj/item/gun/ballistic/automatic/sol_smg/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/automatic/sol_smg/examine_more(mob/user)
	. = ..()

	. += LANG("obj.e5e2f232d58d675f", null)

	return .

/obj/item/gun/ballistic/automatic/sol_smg/no_mag
	spawnwithmagazine = FALSE

// Sindano (evil)

/obj/item/gun/ballistic/automatic/sol_smg/evil
	desc = "A small submachinegun, this one is painted in tacticool black. Accepts any standard Sol pistol magazine."

	icon_state = "sindano_evil"
	inhand_icon_state = "sindano_evil"

/obj/item/gun/ballistic/automatic/sol_smg/evil/no_mag
	spawnwithmagazine = FALSE
