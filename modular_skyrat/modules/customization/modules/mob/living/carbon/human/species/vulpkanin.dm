// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/species/vulpkanin
	name = "Vulpkanin"
	plural_form = "Vulpkanin"
	id = SPECIES_VULP
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
		TRAIT_MUTANT_COLORS,
		TRAIT_FAST_METABOLISM,
		TRAIT_HARD_SOLES,
		TRAIT_NIGHT_VISION,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutant_bodyparts = list()
	mutanttongue = /obj/item/organ/tongue/vulpkanin
	mutanteyes = /obj/item/organ/eyes/vulpkanin
	species_language_holder = /datum/language_holder/vulpkanin
	payday_modifier = 1.0
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	examine_limb_id = SPECIES_MAMMAL
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant,
	)

	meat = /obj/item/food/meat/slab/corgi

/datum/species/vulpkanin/create_pref_unique_perks()
	var/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "face-smile-beam",
		SPECIES_PERK_NAME = LANG("datum.303632e0f0cad5b4", null),
		SPECIES_PERK_DESC = LANG("datum.f3229c6227d9dbb9", null),
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "shoe-prints",
		SPECIES_PERK_NAME = LANG("datum.b9ef4cdcbce54b54", null),
		SPECIES_PERK_DESC = LANG("datum.5d4d38e3b9569289", null),
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "eye",
		SPECIES_PERK_NAME = LANG("datum.cb95f802766549e4", null),
		SPECIES_PERK_DESC = LANG("datum.dabed070d145125e", null),
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "biohazard",
		SPECIES_PERK_NAME = LANG("datum.41fcb045c52ce1f6", null),
		SPECIES_PERK_DESC = LANG("datum.7c048db3d4892981", null),
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "stomach",
		SPECIES_PERK_NAME = LANG("datum.cca4b750e1794fbe", null),
		SPECIES_PERK_DESC = LANG("datum.60c821afb59a8ead", null),
	))

	return to_add
/datum/species/vulpkanin/get_default_mutant_bodyparts()
	return list(
		"tail" = list("Fox", TRUE),
		"snout" = list("Mammal, Long", TRUE),
		"ears" = list("Fox", TRUE),
		"legs" = list("Normal Legs", FALSE),
	)

/obj/item/organ/tongue/vulpkanin
	liked_foodtypes = RAW | MEAT
	disliked_foodtypes = CLOTH
	toxic_foodtypes = TOXIC


/datum/species/vulpkanin/randomize_features()
	var/list/features = ..()
	var/main_color
	var/second_color
	var/random = rand(1,5)
	//Choose from a variety of mostly brightish, animal, matching colors
	switch(random)
		if(1)
			main_color = "#FFAA00"
			second_color = "#FFDD44"
		if(2)
			main_color = "#FF8833"
			second_color = "#FFAA33"
		if(3)
			main_color = "#FFCC22"
			second_color = "#FFDD88"
		if(4)
			main_color = "#FF8800"
			second_color = "#FFFFFF"
		if(5)
			main_color = "#999999"
			second_color = "#EEEEEE"
	features[FEATURE_MUTANT_COLOR] = main_color
	features[FEATURE_MUTANT_COLOR_TWO] = second_color
	features[FEATURE_MUTANT_COLOR_THREE] = second_color
	return features

/datum/species/vulpkanin/get_random_body_markings(list/passed_features)
	var/name = pick("Fox", "Floof", "Floofer")
	var/datum/body_marking_set/BMS = GLOB.body_marking_sets[name]
	var/list/markings = list()
	if(BMS)
		markings = assemble_body_markings_from_set(BMS, passed_features, src)
	return markings

/datum/species/vulpkanin/get_species_description()
	return placeholder_description

/datum/species/vulpkanin/get_species_lore()
	return list(placeholder_lore)

/datum/species/vulpkanin/prepare_human_for_preview(mob/living/carbon/human/vulp)
	var/main_color = "#FF8800"
	var/second_color = "#FFFFFF"

	vulp.dna.features[FEATURE_MUTANT_COLOR] = main_color
	vulp.dna.features[FEATURE_MUTANT_COLOR_TWO] = second_color
	vulp.dna.features[FEATURE_MUTANT_COLOR_THREE] = second_color
	vulp.dna.mutant_bodyparts[FEATURE_SNOUT] = list(MUTANT_INDEX_NAME = "Mammal, Long", MUTANT_INDEX_COLOR_LIST = list(main_color, main_color, main_color))
	vulp.dna.mutant_bodyparts[FEATURE_TAIL_GENERIC] = list(MUTANT_INDEX_NAME = "Husky", MUTANT_INDEX_COLOR_LIST = list(second_color, main_color, main_color))
	vulp.dna.mutant_bodyparts[FEATURE_EARS] = list(MUTANT_INDEX_NAME = "Wolf", MUTANT_INDEX_COLOR_LIST = list(main_color, second_color, second_color))
	regenerate_organs(vulp, src, visual_only = TRUE)
	vulp.update_body(TRUE)
