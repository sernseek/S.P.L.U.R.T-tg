// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Szot Dynamica's officer revolver, built on the Bobr frame and priced accordingly

/obj/item/ammo_box/magazine/internal/cylinder/aniolek
	name = "\improper .310 revolver cylinder"
	ammo_type = /obj/item/ammo_casing/strilka310
	caliber = CALIBER_STRILKA310
	max_ammo = 5

/obj/item/gun/ballistic/revolver/aniolek
	resistance_flags = INDESTRUCTIBLE
	name = "\improper Aniołek .310 Revolver"
	desc = "A five-shot revolver chambered in .310 Strilka, built from the same broad frame as the Bóbr. \
		Expensive, compact, and unusually well finished, the Aniołek is most commonly associated with decorated \
		officers, state troubleshooters, and other people whose refusal to yield is considered an asset rather \
		than a disciplinary problem."
	icon = 'modular_zubbers/icons/obj/szot_aniolek.dmi'
	icon_state = "aniolek"
	greyscale_config = /datum/greyscale_config/szot_dynamica_32
	greyscale_colors = "#83825E#CD445B"
	flags_1 = parent_type::flags_1 | IS_PLAYER_COLORABLE_1 | NO_NEW_GAGS_PREVIEW_1
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/aniolek
	fire_sound = 'modular_skyrat/modules/sec_haul/sound/revolver_fire.ogg'
	fire_delay = 0.7 DECISECONDS
	projectile_damage_multiplier = 0.55 // 33 a shot
	recoil = 1
	spread = 6
	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/ballistic/revolver/aniolek/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/gags_recolorable)
	AddElement(/datum/element/gun_launches_little_guys, 2, 3)

/obj/item/gun/ballistic/revolver/aniolek/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_SZOT)

/obj/item/gun/ballistic/revolver/aniolek/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.443782c7961051dd", list(EXAMINE_HINT("look closer"), src)))

/obj/item/gun/ballistic/revolver/aniolek/examine_more(mob/user)
	. = ..()

	. += LANG("obj.2dfd155f915b78ec", null)

	. += LANG("obj.628b308923dcf55e", null)

	. += LANG("obj.1e3db97d9a6a1606", null)

	return .

// The QM's Lanca. Same rifle, deeper magazine, and a magazine you cannot buy.

/obj/item/ammo_box/magazine/lanca/extended
	name = "\improper Lanca extended rifle magazine"
	desc = "An overlong magazine for Lanca rifles, holding eight rounds. Surplus dealers swear these were standard issue \
		somewhere, but never say where."
	icon = 'modular_zubbers/icons/obj/szot_extended_mag.dmi'
	icon_state = "lanca_mag_extended"
	base_icon_state = "lanca_mag_extended"
	max_ammo = 8
