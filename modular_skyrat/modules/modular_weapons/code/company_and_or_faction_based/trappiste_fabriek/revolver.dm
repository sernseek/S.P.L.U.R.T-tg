// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// .35 Sol mini revolver

/obj/item/gun/ballistic/revolver/sol
	name = "\improper Eland Revolver"
	desc = "A small revolver with a comically short barrel and cylinder space for eight .35 Sol Short rounds."

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/guns32x.dmi'
	icon_state = "eland"

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/c35sol

	suppressor_x_offset = 3

	w_class = WEIGHT_CLASS_SMALL

	can_suppress = TRUE

/obj/item/gun/ballistic/revolver/sol/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_TRAPPISTE)

/obj/item/gun/ballistic/revolver/sol/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/revolver/sol/examine_more(mob/user)
	. = ..()

	. += LANG("obj.cc1184d3a1bd8343", null)

	return .

/obj/item/ammo_box/magazine/internal/cylinder/c35sol
	ammo_type = /obj/item/ammo_casing/c35sol
	caliber = CALIBER_SOL35SHORT
	max_ammo = 8

// .585 super revolver

/obj/item/gun/ballistic/revolver/takbok
	name = "\improper Takbok Revolver"
	desc = "A hefty revolver with an equally large cylinder capable of holding five .585 Trappiste rounds."

	icon = 'modular_skyrat/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/guns32x.dmi'
	icon_state = "takbok"

	fire_sound = 'modular_skyrat/modules/modular_weapons/sounds/revolver_heavy.ogg'
	suppressed_sound = 'modular_skyrat/modules/modular_weapons/sounds/suppressed_heavy.ogg'

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/c585trappiste

	suppressor_x_offset = 5

	can_suppress = TRUE

	fire_delay = 1 SECONDS
	recoil = 3

/obj/item/gun/ballistic/revolver/takbok/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_TRAPPISTE)

/obj/item/gun/ballistic/revolver/takbok/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.b663717df67087e6", null))

/obj/item/gun/ballistic/revolver/takbok/examine_more(mob/user)
	. = ..()

	. += LANG("obj.fc5e4f170e2ae285", null)

	return .

/obj/item/ammo_box/magazine/internal/cylinder/c585trappiste
	ammo_type = /obj/item/ammo_casing/c585trappiste
	caliber = CALIBER_585TRAPPISTE
	max_ammo = 5
