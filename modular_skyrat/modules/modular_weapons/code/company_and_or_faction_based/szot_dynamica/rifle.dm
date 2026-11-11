// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Semi-automatic rifle firing .310 with reduced damage compared to a Sakhno

/obj/item/gun/ballistic/automatic/lanca
	name = "\improper Lanca Battle Rifle"
	desc = "A relatively compact, long-barreled bullpup battle rifle chambered for .310 Strilka."

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/szot_dynamica/guns_48.dmi'
	icon_state = "lanca"

	worn_icon = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/szot_dynamica/guns_worn.dmi'
	worn_icon_state = "lanca"

	lefthand_file = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/szot_dynamica/guns_lefthand.dmi'
	righthand_file = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/szot_dynamica/guns_righthand.dmi'
	inhand_icon_state = "lanca"
	greyscale_config = /datum/greyscale_config/szot_dynamica_48
	greyscale_config_worn = /datum/greyscale_config/szot_dynamica_worn
	greyscale_config_inhand_left = /datum/greyscale_config/szot_dynamica_lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/szot_dynamica_righthand
	greyscale_colors = "#83825E#CD445B"
	flags_1 = parent_type::flags_1 | IS_PLAYER_COLORABLE_1 | NO_NEW_GAGS_PREVIEW_1

	SET_BASE_PIXEL(-8, 0)

	special_mags = FALSE

	bolt_type = BOLT_TYPE_STANDARD

	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE

	accepted_magazine_type = /obj/item/ammo_box/magazine/lanca

	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/battle_rifle.ogg'
	suppressed_sound = 'modular_skyrat/modules/modular_weapons/sounds/suppressed_heavy.ogg'
	can_suppress = TRUE
	suppressor_x_offset = 0
	suppressor_y_offset = 0

	burst_size = 1
	fire_delay = 1 SECONDS
	actions_types = list()

	recoil = 0.5
	spread = 2.5
	projectile_wound_bonus = -20

/obj/item/gun/ballistic/automatic/lanca/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_SZOT)

/// Shows which magazine is actually fitted rather than one generic block
/obj/item/gun/ballistic/automatic/lanca/update_overlays()
	. = ..()
	if(!magazine || internal_magazine || !mag_display)
		return
	if(istype(magazine, /obj/item/ammo_box/magazine/lanca/extended))
		. -= "[icon_state]_mag"
		. += "[icon_state]_mag_extended"

/obj/item/gun/ballistic/automatic/lanca/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.25)
	AddElement(/datum/element/gags_recolorable)

/obj/item/gun/ballistic/automatic/lanca/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/automatic/lanca/examine_more(mob/user)
	. = ..()

	. += LANG("obj.613e9ee575b18576", null)

	return .

/obj/item/gun/ballistic/automatic/lanca/no_mag
	spawnwithmagazine = FALSE

// The AMR
// This sounds a lot scarier than it actually is, you'll just have to trust me here

/obj/item/gun/ballistic/automatic/wylom
	name = "\improper Wyłom Anti-Materiel Rifle"
	desc = "A massive, outdated beast of an anti-materiel rifle that was once in use by CIN military forces. Fires the devastating .60 Strela caseless round, \
		the massively overperforming penetration of which was the reason this weapon was discontinued."
	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/szot_dynamica/guns_64.dmi'
	base_pixel_x = -16 // This baby is 64 pixels wide
	pixel_x = -16
	righthand_file = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/szot_dynamica/inhands_64_left.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/szot_dynamica/inhands_64_right.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	worn_icon = 'modular_skyrat/modules/modular_weapons/icons/mob/company_and_or_faction_based/szot_dynamica/guns_worn.dmi'
	icon_state = "wylom"
	inhand_icon_state = "wylom"
	worn_icon_state = "wylom"
	greyscale_config = /datum/greyscale_config/szot_dynamica_64
	greyscale_config_worn = /datum/greyscale_config/szot_dynamica_worn
	greyscale_config_inhand_left = /datum/greyscale_config/szot_dynamica_inhand64_right
	greyscale_config_inhand_right = /datum/greyscale_config/szot_dynamica_inhand64_left
	greyscale_colors = "#83825E#CD445B"
	flags_1 = parent_type::flags_1 | IS_PLAYER_COLORABLE_1 | NO_NEW_GAGS_PREVIEW_1
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK

	accepted_magazine_type = /obj/item/ammo_box/magazine/wylom
	can_suppress = FALSE

	fire_sound = 'modular_skyrat/modules/novaya_ert/sound/amr_fire.ogg'
	fire_sound_volume = 100 // BOOM BABY

	recoil = 4

	weapon_weight = WEAPON_HEAVY
	burst_size = 1
	fire_delay = 2 SECONDS
	actions_types = list()

	force = 15 // I mean if you're gonna beat someone with the thing you might as well get damage appropriate for how big the fukken thing is

/obj/item/gun/ballistic/automatic/wylom/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/gags_recolorable)

/obj/item/gun/ballistic/automatic/wylom/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_SZOT)
	AddElement(/datum/element/gun_launches_little_guys, throwing_force = 3, throwing_range = 5)

/obj/item/gun/ballistic/automatic/wylom/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/automatic/wylom/examine_more(mob/user)
	. = ..()

	. += LANG("obj.5d4e8cd7f86e11af", null)

	return .
