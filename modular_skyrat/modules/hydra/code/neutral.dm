// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/quirk/hydra
	name = "Hydra Heads"
	desc = "You are a tri-headed creature. To use, format name like (Rucks-Sucks-Ducks)"
	value = 0
	mob_trait = TRAIT_HYDRA_HEADS
	gain_text = span_notice("You hear two other voices inside of your head(s).")
	lose_text = span_danger("All of your minds become singular.")
	medical_record_text = "There are multiple heads and personalities affixed to one body."
	icon = FA_ICON_HORSE_HEAD
	// remember what the name was before activation
	var/original_name
	var/heads_checked = FALSE
	var/list/heads
	var/datum/action/innate/hydra_head/head_spell
	var/datum/action/innate/hydra_reset/reset_spell

/datum/quirk/hydra/add(client/client_source)
	head_spell = new()
	reset_spell = new()
	head_spell.Grant(quirk_holder)
	reset_spell.Grant(quirk_holder)

/datum/quirk/hydra/remove()
	head_spell.Remove(quirk_holder)
	reset_spell.Remove(quirk_holder)
	QDEL_NULL(head_spell)
	QDEL_NULL(reset_spell)
	quirk_holder.real_name = original_name

/datum/quirk_constant_data/hydra
	associated_typepath = /datum/quirk/hydra
	customization_options = list(
		/datum/preference/text/hydra/name1,
		/datum/preference/text/hydra/name2,
		/datum/preference/text/hydra/name3,
	)

/datum/preference/text/hydra
	abstract_type = /datum/preference/text/hydra
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/text/hydra/name1
	savefile_key = "hydra__head_name1"

/datum/preference/text/hydra/name2
	savefile_key = "hydra__head_name2"

/datum/preference/text/hydra/name3
	savefile_key = "hydra__head_name3"

/datum/preference/text/hydra/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/action/innate/hydra_head
	name = "Switch head"
	desc = "Switch between each of the heads on your body."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "art_summon"

/datum/action/innate/hydra_head/Activate() //Oops, all hydra!
	var/mob/living/carbon/human/hydra = owner
	var/datum/quirk/hydra/hydra_quirk = hydra.get_quirk(/datum/quirk/hydra)
	if(!hydra_quirk.original_name) // sets the archived 'real' name if not set.
		hydra_quirk.original_name = hydra.real_name

	if(!hydra_quirk.check_heads())
		to_chat(hydra, LANG("datum.76a89be63507a067", null))
		return
	var/selhead = tgui_input_list(hydra, LANG("datum.ab6e0efa7693a2bc", null), LANG("datum.ca73cff9f4ad2fe4", null), hydra_quirk.heads)
	hydra.real_name = selhead
	hydra.visible_message(span_notice(LANG("datum.d7f4faab893c02d0", list(hydra.name, selhead))), \
							span_notice(LANG("datum.0082db02ae2ded2d", list(selhead))), ignored_mobs=owner)

/datum/quirk/hydra/proc/check_heads()
	if(heads_checked)
		return TRUE
	heads = list(
		quirk_holder?.client?.prefs?.read_preference(/datum/preference/text/hydra/name1),
		quirk_holder?.client?.prefs?.read_preference(/datum/preference/text/hydra/name2),
		quirk_holder?.client?.prefs?.read_preference(/datum/preference/text/hydra/name3),
	)
	for(var/headname in heads)
		if(headname == "")
			return FALSE
	heads_checked = TRUE
	return TRUE

/datum/action/innate/hydra_reset
	name = "Reset Speech"
	desc = "Go back to speaking as a whole."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "art_summon"

/datum/action/innate/hydra_reset/Activate()
	var/mob/living/carbon/human/hydra = owner
	var/datum/quirk/hydra/hydra_quirk = hydra.get_quirk(/datum/quirk/hydra)
	if(!hydra_quirk.original_name) // sets the archived 'real' name if not set.
		hydra_quirk.original_name = hydra.real_name
	hydra.real_name = hydra_quirk.original_name
	hydra.visible_message(span_notice(LANG("datum.78664ff61631e590", list(hydra.name))), \
							span_notice(LANG("datum.0082db02ae2ded2d", list(hydra_quirk.original_name))), ignored_mobs=owner)
