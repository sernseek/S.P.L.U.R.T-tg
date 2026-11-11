// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/reagent/drug/copium
	name = "Copium"
	description = "Cope and sssethe"
	taste_description = "coping"
	color = "#0f0"
	trippy = FALSE
	overdose_threshold = 30

/datum/reagent/drug/copium/on_mob_life(mob/living/carbon/affected_mob)
	. = ..()

	if (!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/H = affected_mob
	if (prob(10))
		to_chat(H, LANG("datum.2fe16150b11e0efa", null))
		H.adjust_disgust(-10)
		affected_mob.add_mood_event("opium", /datum/mood_event/cope, name)

/datum/reagent/drug/copium/overdose_start(mob/living/carbon/affected_mob)
	to_chat(affected_mob, LANG("datum.405e2ea2a6a69081", null))
	affected_mob.add_mood_event("[type]_overdose", /datum/mood_event/overdose, name)

/datum/reagent/drug/copium/overdose_process(mob/living/carbon/affected_mob)
	var/mob/living/carbon/human/H = affected_mob
	if (prob(5))
		H.adjust_disgust(20)
		to_chat(H, LANG("datum.9f16577bbdb07c49", null))
	. = ..()
