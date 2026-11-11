// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md

/datum/species/human/cursekin
	inherent_traits = list(
		TRAIT_LYCAN,
		TRAIT_MUTANT_COLORS,
		TRAIT_FAST_METABOLISM,
		TRAIT_VIRUSIMMUNE, // where wolf? wolves? where?
	)
	mutanteyes = /obj/item/organ/eyes/cursekin
	mutantears = /obj/item/organ/ears/cursekin

/datum/species/human/cursekin/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "robot",
			SPECIES_PERK_NAME = LANG("datum.d7c5a41a1a0d6f22", null),
			SPECIES_PERK_DESC = LANG("datum.54af8d942c4946a6", null)
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = LANG("datum.1c52a2b5de22a451", null),
			SPECIES_PERK_DESC = LANG("datum.b74f45a5396715ef", null)
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "assistive-listening-systems",
			SPECIES_PERK_NAME = LANG("datum.bb136bbdf22cb336", null),
			SPECIES_PERK_DESC = LANG("datum.2322e961d06f07d4", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "stomach",
			SPECIES_PERK_NAME = LANG("datum.c894ffadb47dd1d8", null),
			SPECIES_PERK_DESC = LANG("datum.7a7f3039e26f56fb", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "moon",
			SPECIES_PERK_NAME = LANG("datum.7ab5bf1752caa1fc", null),
			SPECIES_PERK_DESC = LANG("datum.6534b98f30deaa4f", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_SYRINGE,
			SPECIES_PERK_NAME = LANG("datum.7ecf78de9d9369b3", null),
			SPECIES_PERK_DESC = LANG("datum.718411ce22f99eb6", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "eye",
			SPECIES_PERK_NAME = LANG("datum.360cb4d171c936ad", null),
			SPECIES_PERK_DESC = LANG("datum.d9938c5fb785f99f", null),
		),
	)
	return to_add


/obj/item/organ/ears/cursekin // how they look specifically is down to the player
	name = "cursekin ears"
	desc = "A pair of unusually long ears, with tufts of fur growing under them."
	damage_multiplier = 2

/obj/item/organ/eyes/cursekin
	name = "cursekin eyes"
	desc = "They bare an unusual similarity to the eyes of a wild wolf."
	flash_protect = FLASH_PROTECTION_SENSITIVE
	color_cutoffs = list(12, 7, 7) // ditto tajaran
