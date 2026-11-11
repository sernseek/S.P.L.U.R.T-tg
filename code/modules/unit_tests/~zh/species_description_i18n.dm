/datum/unit_test/species_description_i18n

/datum/unit_test/species_description_i18n/Run()
	if(GLOB.i18n_server_locale != LANGUAGE_LOCALE_ZH_HANS)
		return
	var/datum/species/human/human_species = GLOB.species_prototypes[/datum/species/human]
	var/list/description = human_species.get_species_description()
	TEST_ASSERT(islist(description) && length(description) >= 2, "The human description should contain separate paragraphs.")
	description = lang_reverse_string_list(description)
	TEST_ASSERT_EQUAL(description[1], "凭借适应性强的生理构造，人类几乎遍布已知银河。人类往往能够适应太空生活，许多人选择在已知银河中四处游历。", "Species descriptions must be localized as separate paragraphs before being joined.")
	TEST_ASSERT(findtext(description.Join("\n\n"), "哺乳物种"), "The joined description must retain the translated second paragraph.")
