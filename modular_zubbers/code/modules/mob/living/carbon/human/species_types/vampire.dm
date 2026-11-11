// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/species/human/vampire
	inherent_biotypes = MOB_VAMPIRIC|MOB_UNDEAD|MOB_HUMANOID

/datum/species/human/vampire/on_bloodsucker_gain(mob/living/carbon/human/target, datum/species/current_species)
	to_chat(target, span_warning(LANG("datum.7228602092bcea31", null)))
	humanize_organs(target, current_species)

/datum/species/human/vampire/on_bloodsucker_loss(mob/living/carbon/human/target)
	normalize_organs(target)

/datum/species/human/vampire/get_species_description()
	return list("A classy Vampire! They descend upon Space Station Thirteen Every year to spook the crew! \"Bleeg!!\"",)
