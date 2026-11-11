// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Tajaran Bubber edit
//makes them more like Citrp's tajara aka snow cats

/datum/species/tajaran
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
		TRAIT_HATED_BY_DOGS,
		TRAIT_MUTANT_COLORS,
		TRAIT_CATLIKE_INSTINCT,
	)
	mutanteyes = /obj/item/organ/eyes/tajaran
	mutantears = /obj/item/organ/ears/cat/tajaran
	//Cold resistance
	coldmod = 0.45
	heatmod = 1.25
	bodytemp_normal = BODYTEMP_NORMAL + 5 //Even more cold resistant, even more flammable
	bodytemp_heat_damage_limit = (BODYTEMP_HEAT_DAMAGE_LIMIT - 25)// Hopefully shows over heating less
	bodytemp_cold_damage_limit = (BODYTEMP_COLD_DAMAGE_LIMIT - 35)
	meat = /obj/item/food/meat/slab/human/mutant/feline //you monster! //mmmfghghgf cat meat
	skinned_type = /obj/item/stack/sheet/animalhide/cat

/obj/item/bodypart/chest/mutant/tajaran

//Tajaran tongue
/obj/item/organ/tongue/cat/tajaran
	name = "tajaran tongue"
	modifies_speech = TRUE
	languages_native = list(/datum/language/siiktajr)

/obj/item/organ/tongue/cat/tajaran/modify_speech(datum/source, list/speech_args)
	var/static/regex/tajara_roll = new("r+", "g")
	var/static/regex/tajara_roLL = new("R+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = tajara_roll.Replace(message, "rrr")
		message = tajara_roLL.Replace(message, "RRR")
		message = replacetext(message, "r", "r")
//Insert russion translations here (sorry russions)
	speech_args[SPEECH_MESSAGE] = message

/datum/augment_item/organ/tongue/tajaran
	name = "Tajaran tongue"
	path = /obj/item/organ/tongue/cat/tajaran

//Tajara have the innate ability to see in the dark better than most
/obj/item/organ/eyes/tajaran
	name = "tajaran eyes"
	desc = "they seem very cat like."
	flash_protect = FLASH_PROTECTION_SENSITIVE //One layer protection
	color_cutoffs = list(12, 7, 7)

/obj/item/organ/eyes/tajaran/on_mob_insert(mob/living/carbon/human/eyes_owner)
	. = ..()
	if(istype(eyes_owner))
		if(HAS_TRAIT(eyes_owner, TRAIT_NIGHT_VISION)) //prevents double stacking of tajara night vision and the night vision quirk.
			to_chat(eyes_owner, span_danger(LANG("obj.70450f2c3effff95", null)))
			REMOVE_TRAIT(eyes_owner, TRAIT_NIGHT_VISION, QUIRK_TRAIT)

/obj/item/organ/ears/cat/tajaran
	name = "Tajaran ears"
	desc = "These ears to seem to be from a feline of some type"

/datum/species/tajaran/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "fire",
			SPECIES_PERK_NAME = LANG("datum.995f4c6640668a7d", null),
			SPECIES_PERK_DESC = LANG("datum.caf71be434b92b41", null)
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "sun",
			SPECIES_PERK_NAME = LANG("datum.da9dee50ff8ae0e8", null),
			SPECIES_PERK_DESC = LANG("datum.f6a2cb1fe7f357f1", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "eye",
			SPECIES_PERK_NAME = LANG("datum.ac6f015f15b87f50", null),
			SPECIES_PERK_DESC = LANG("datum.0da38e116e5f5d9a", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "assistive-listening-systems",
			SPECIES_PERK_NAME = LANG("datum.bb136bbdf22cb336", null),
			SPECIES_PERK_DESC = LANG("datum.95d8688b14887b52", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "paw",
			SPECIES_PERK_NAME = LANG("datum.ac7ca64554ede9e7", null),
			SPECIES_PERK_DESC = LANG("datum.e49e3c39eb57d56f", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_PERSON_FALLING,
			SPECIES_PERK_NAME = LANG("datum.1c8445c68f34e14c", null),
			SPECIES_PERK_DESC = LANG("datum.03e0485e65f90753", null),
		),
	)

	return to_add

/obj/item/bodypart/chest/mutant/tajaran/get_butt_sprite()
	return icon('icons/mob/butts.dmi', BUTT_SPRITE_CAT)

/datum/species/tajaran/get_species_description() //Something basic until I make lore later
	return list("The Tajara are a race of humanoids that possess markedly felinoid traits that include \
	a semi-prehensile tail, a body covered in fur of varying shades, and padded, digitigrade feet. \
	Being that they are from a harsh and icy cold planet, Tajara are vulnerable to high temperatures and fire.",)
