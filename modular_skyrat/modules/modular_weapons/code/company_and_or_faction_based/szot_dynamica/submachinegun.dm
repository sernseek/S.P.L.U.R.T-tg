// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Rapid firing submachinegun firing .27-54 Cesarzowa

/obj/item/gun/ballistic/automatic/miecz
	name = "\improper Miecz Submachine Gun"
	desc = "A short barrel, further compacted conversion of the 'Lanca' rifle to fire pistol caliber .27-54 cartridges. \
		Due to the intended purpose of the weapon, and less than optimal ranged performance of the projectile, it has \
		nothing more than basic glow-sights as opposed to the ranged scope Lanca users might be used to."

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/szot_dynamica/guns_48.dmi'
	icon_state = "miecz"
	greyscale_config = /datum/greyscale_config/szot_dynamica_48
	greyscale_colors = "#83825E#CD445B"
	flags_1 = parent_type::flags_1 | IS_PLAYER_COLORABLE_1 | NO_NEW_GAGS_PREVIEW_1

	inhand_icon_state = "c20r"
	worn_icon_state = "gun"

	SET_BASE_PIXEL(-8, 0)

	special_mags = FALSE

	bolt_type = BOLT_TYPE_STANDARD

	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_SUITSTORE

	accepted_magazine_type = /obj/item/ammo_box/magazine/miecz

	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/smg_light.ogg'
	can_suppress = TRUE
	suppressor_x_offset = 0
	suppressor_y_offset = 0

	burst_size = 1
	fire_delay = 0.2 SECONDS
	actions_types = list()

	spread = 5

/obj/item/gun/ballistic/automatic/miecz/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)
	AddElement(/datum/element/gags_recolorable)

/obj/item/gun/ballistic/automatic/miecz/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_SZOT)

/obj/item/gun/ballistic/automatic/miecz/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/automatic/miecz/examine_more(mob/user)
	. = ..()

	. += LANG("obj.14e229cccf195c3b", null)

	return .

/obj/item/gun/ballistic/automatic/miecz/no_mag
	spawnwithmagazine = FALSE
