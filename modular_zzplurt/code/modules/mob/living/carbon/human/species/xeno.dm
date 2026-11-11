// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/species/xeno
	mutant_organs = list(
		/obj/item/organ/alien/plasmavessel/roundstart,
		/obj/item/organ/alien/resinspinner,
		)
/datum/species/xeno/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "Sun",
		SPECIES_PERK_NAME = LANG("datum.08903a1095a96b3e", null),
		SPECIES_PERK_DESC = LANG("datum.cd6dd59a134d4da5", null)
	))
	return to_add
