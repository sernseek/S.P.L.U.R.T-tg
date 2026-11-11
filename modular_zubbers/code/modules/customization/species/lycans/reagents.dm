// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define BASE_BURN_PER_SECOND 0.5

/datum/reagent/silver/on_mob_metabolize(mob/living/affected_mob)
	. = ..()

	if (get_lycanthropy_intensity(affected_mob) == 0)
		return

	to_chat(affected_mob, span_userdanger(LANG("datum.912d8548888288bb", null)))
	affected_mob.emote("scream")

/datum/reagent/silver/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()

	if (get_lycanthropy_intensity(affected_mob) == 0)
		return

	to_chat(affected_mob, span_bolddanger(LANG("datum.38372dc334fb6efa", null)))

/datum/reagent/silver/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()

	var/intensity = get_lycanthropy_intensity(affected_mob)
	if (intensity == 0)
		return

	// we are a lycan and we have silver in our blood ohhhh noooo broooooooo

	var/damage_amt = BASE_BURN_PER_SECOND * intensity * seconds_per_tick
	affected_mob.apply_damage(
		damage_amt,
		BURN,
		wound_bonus = CANT_WOUND // TODO - maybe have a small chance to cause a burn wound?
	)

	if (SPT_PROB(5, seconds_per_tick))
		to_chat(affected_mob, span_warning(LANG("datum.23c8553a259d406d", null)))
		affected_mob.emote("scream")

/datum/reagent/silver/proc/get_lycanthropy_intensity(mob/living/carbon/affected_mob)
	if (!ishuman(affected_mob))
		return 0

	if (islycan(affected_mob))
		return 3
	else if (iscursekin(affected_mob))
		return 1

	return 0

#undef BASE_BURN_PER_SECOND
