// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/*
Lizard subspecies: ASHWALKERS
*/

/datum/species/lizard/ashwalker/
	language_prefs_whitelist = list(/datum/language/ashtongue, /datum/language/sylvan, /datum/language/xenocommon, /datum/language/draconic)

/datum/species/lizard/ashwalker/create_pref_language_perk()
	var/list/to_add = list()
	// Holding these variables so we can grab the exact names for our perk.
	var/datum/language/common_language = /datum/language/ashtongue

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "comment",
		SPECIES_PERK_NAME = LANG("datum.2c6ae453c19c3937", null),
		SPECIES_PERK_DESC = LANG("datum.4ae1167d82b4fd78", list(initial(common_language.name)))
	))

	return to_add
