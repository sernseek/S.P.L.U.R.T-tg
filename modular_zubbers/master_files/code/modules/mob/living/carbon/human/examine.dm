// Species examine
/mob/living/carbon/human/examine_title(mob/user, thats = FALSE)
	. = ..()
	var/skipface = covered_slots & HIDEFACE
	var/species_visible
	var/species_name_string
	if(skipface || get_visible_name() == "Unknown")
		species_visible = FALSE
	else
		species_visible = TRUE

	if(!species_visible)
		species_name_string = ""
	// ZH EDIT ADDITION START - I18N - 中文无冠词——反查物种名、去掉 a/an 冠词、逗号用中文逗号（"…, a Human" → "…，人类"）。en locale 走原分支不变。
	else if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		var/use_custom = !dna.species.lore_protected && dna.features["custom_species"] && dna.features["custom_species"] != ""
		var/species_display = use_custom ? dna.features["custom_species"] : dna.species.name
		species_name_string = "，<EM>[lang_reverse_text(species_display)][(use_custom && isobserver(user)) ? "（[lang_reverse_text(dna.species.name)]）" : ""]</EM>"
	// ZH EDIT ADDITION END
	else if (!dna.species.lore_protected && dna.features["custom_species"] && dna.features["custom_species"] != "")
		species_name_string = ", [prefix_a_or_an(dna.features["custom_species"])] <EM>[dna.features["custom_species"]] [isobserver(user) ? "([dna.species.name])" : ""]</EM>"
	else
		species_name_string = ", [prefix_a_or_an(dna.species.name)] <EM>[dna.species.name]</EM>"

	. += species_name_string
