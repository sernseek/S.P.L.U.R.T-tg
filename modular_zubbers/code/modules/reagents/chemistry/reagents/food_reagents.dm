// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/reagent/consumable/garlic/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	if(IS_BLOODSUCKER(affected_mob))
		affected_mob.balloon_alert(affected_mob, LANG("datum.f6dbd371182784af", null))


/datum/reagent/consumable/garlic/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(IS_BLOODSUCKER(affected_mob))
		if(SPT_PROB(min((current_cycle-1)/2, 12.5), seconds_per_tick))
			to_chat(affected_mob, span_danger(LANG("datum.c6419abfedd59f65", null)))
			affected_mob.Paralyze(1 SECONDS)
			affected_mob.set_eye_blur_if_lower(2 SECONDS)
