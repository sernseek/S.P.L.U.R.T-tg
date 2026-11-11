// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/*
* BUTT ENLARGEMENT
* Normal function increases the player's butt size
* If the player's butt is near or at the maximum size and they're wearing clothing, they press against the player's clothes and causes brute damage
*/

/datum/reagent/drug/aphrodisiac/butt_enlarger
	name = "denbu tincture"
	description = "A mixture of natural vitamins and valentines plant extract, causing butt enlargement in humanoids."
	color = "#e8ff1b"
	taste_description = "butter with a sweet aftertaste"
	overdose_threshold = 17
	metabolization_rate = 0.25
	life_pref_datum = /datum/preference/toggle/erp/butt_enlargement
	overdose_pref_datum = /datum/preference/toggle/erp

	/// Words for the butt when huge
	var/static/list/words_for_bigger = list(
		"huge",
		"massive",
		"jiggly",
		"hefty",
		"plump",
		"thick",
		"bubbling"
	)

	/// Wording chosen to expand the butt, shown only to the mob
	var/static/list/action_text_list = list(
		"expands outward to ",
		"grows out to ",
		"begins to plump up, growing to ",
		"suddenly expands to ",
		"swells out to "
	)

	/// Wording chosen to be seen by other mobs
	var/static/list/public_action_text_list = list(
		"expands outward.",
		"seems to grow larger.",
		"appears more plump than before.",
		"suddenly swells up."
	)

/datum/reagent/drug/aphrodisiac/butt_enlarger/life_effects(mob/living/carbon/human/exposed_mob)
	if(!ishuman(exposed_mob))
		return

	var/obj/item/organ/genital/butt/mob_butt = exposed_mob.get_organ_slot(ORGAN_SLOT_BUTT)

	// Create butt if they don't have one
	if(!mob_butt)
		create_butt(exposed_mob)
		return

	// Grow existing butt
	grow_butt(exposed_mob)

/datum/reagent/drug/aphrodisiac/butt_enlarger/growth_to_chat(mob/living/carbon/human/exposed_mob, obj/item/organ/genital/butt/mob_butt)
	if(!mob_butt)
		return

	if(mob_butt.genital_size >= (butt_max_size - 2))
		exposed_mob.visible_message(span_notice(LANG("datum.b56c7da101d57f33", list(exposed_mob, pick(words_for_bigger), pick(public_action_text_list)))))
		to_chat(exposed_mob, span_purple(LANG("datum.31d7e89d1d2b349a", list(pick(words_for_bigger), pick(action_text_list), mob_butt.genital_size))))
	else
		exposed_mob.visible_message(span_notice(LANG("datum.dd957574a7427c9d", list(exposed_mob, pick(public_action_text_list)))))
		to_chat(exposed_mob, span_purple(LANG("datum.5cabd57f31e852e7", list(pick(action_text_list), mob_butt.genital_size))))

/datum/chemical_reaction/butt_enlarger
	results = list(/datum/reagent/drug/aphrodisiac/butt_enlarger = 8)
	required_reagents = list(/datum/reagent/medicine/salglu_solution = 1,
							/datum/reagent/consumable/sugar = 2,
							/datum/reagent/silicon = 3,
							/datum/reagent/drug/aphrodisiac/crocin = 2)
	mix_message = "the reaction gives off a sweet buttery aroma."
	erp_reaction = TRUE
	reaction_tags = REACTION_TAG_CHEMICAL | REACTION_TAG_HARD | REACTION_TAG_ORGAN
