// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// .35 Sol pistol

/obj/item/gun/ballistic/automatic/pistol/sol
	name = "\improper Wespe Pistol"
	desc = "The standard issue service pistol of TerraGov's various military branches. Uses .35 Sol and comes with an attached light."

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/guns32x.dmi'
	icon_state = "wespe"

	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/pistol_light.ogg'

	w_class = WEIGHT_CLASS_NORMAL

	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	special_mags = TRUE

	suppressor_x_offset = 7
	suppressor_y_offset = 0

	fire_delay = 0.3 SECONDS

/obj/item/gun/ballistic/automatic/pistol/sol/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_TRAPPISTE)

/obj/item/gun/ballistic/automatic/pistol/sol/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
		)

/obj/item/gun/ballistic/automatic/pistol/sol/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/automatic/pistol/sol/examine_more(mob/user)
	. = ..()

	. += LANG("obj.315df26efcabb268", null)

	return .

/obj/item/gun/ballistic/automatic/pistol/sol/no_mag
	spawnwithmagazine = FALSE

// Sol pistol evil gun

/obj/item/gun/ballistic/automatic/pistol/sol/evil
	desc = "The standard issue service pistol of TerraGov's various military branches. Comes with attached light. This one is painted tacticool black."

	icon_state = "wespe_evil"

/obj/item/gun/ballistic/automatic/pistol/sol/evil/no_mag
	spawnwithmagazine = FALSE

// Trappiste high caliber pistol in .585

/obj/item/gun/ballistic/automatic/pistol/trappiste
	name = "\improper Skild Pistol"
	desc = "A somewhat rare to see Trappiste pistol firing the high caliber .585 developed by the same company. \
		Sees rare use mainly due to its tendency to cause severe wrist discomfort."

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/guns32x.dmi'
	icon_state = "skild"

	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/pistol_heavy.ogg'
	suppressed_sound = 'modular_skyrat/modules/modular_weapons/sounds/suppressed_heavy.ogg'

	w_class = WEIGHT_CLASS_NORMAL

	accepted_magazine_type = /obj/item/ammo_box/magazine/c585trappiste_pistol

	suppressor_x_offset = 8
	suppressor_y_offset = 0

	fire_delay = 1 SECONDS

	recoil = 3

/obj/item/gun/ballistic/automatic/pistol/trappiste/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_TRAPPISTE)

/obj/item/gun/ballistic/automatic/pistol/sol/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/automatic/pistol/trappiste/examine_more(mob/user)
	. = ..()

	. += LANG("obj.7d7571f0bd309abe", null)

	return .

/obj/item/gun/ballistic/automatic/pistol/trappiste/no_mag
	spawnwithmagazine = FALSE
