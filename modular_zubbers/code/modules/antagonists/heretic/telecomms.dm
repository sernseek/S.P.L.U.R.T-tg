// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/signal/subspace/vocal/proc/on_heard(atom/movable/hearer)
	if (!isliving(hearer))
		return
	var/mob/living/living_hearer = hearer
	if (data["cursed"] && !IS_HERETIC_OR_MONSTER(living_hearer) && !issilicon(living_hearer) && !living_hearer.has_status_effect(/datum/status_effect/heretic_comms_immunity))
		living_hearer.mob_mood?.adjust_sanity(-5)
		living_hearer.apply_status_effect(/datum/status_effect/heretic_comms_immunity)
		if (prob(20))
			to_chat(living_hearer, span_warning(LANG("datum.203486d939024def", null)))
			to_chat(living_hearer, span_warning(LANG("datum.dda438bae8e9272e", null)))
			living_hearer.adjust_organ_loss(ORGAN_SLOT_BRAIN, 10, BRAIN_DAMAGE_MILD)
			living_hearer.adjust_hallucinations_up_to(40 SECONDS, 5 MINUTES)

/obj/machinery/telecomms/processor/update_overlays()
	. = ..()

	if (GLOB.processors_cursed)
		. += mutable_appearance('icons/mob/effects/heretic_aura.dmi', "heretic_aura")

/obj/machinery/telecomms/processor/examine(mob/user)
	. = ..()

	if (GLOB.processors_cursed)
		. += span_warning(LANG("obj.e20be280feaa2e0c", null))
		. += span_notice(LANG("obj.0b20add33b2fd891", null))

/datum/status_effect/heretic_comms_immunity // antispam
	id = "heretic_comms_immunity"
	alert_type = null
	tick_interval = STATUS_EFFECT_NO_TICK
	duration = 1 SECONDS
