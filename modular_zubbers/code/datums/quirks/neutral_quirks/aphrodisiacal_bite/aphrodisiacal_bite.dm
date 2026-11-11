// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/action/cooldown/mob_cooldown/aphrodisiacal_bite
	name = "Inject Aphrodisiac"
	desc = "Sink your fangs into another and inject them with your aphrodisiac."

	button_icon = 'modular_zubbers/icons/mob/actions/quirks/aphrodisiacal_bite.dmi'
	button_icon_state = "aphrodisiac"

	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_pickturf.dmi'

	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED // can use it if cuffed, enjoy

	shared_cooldown = NONE

	/// The reagent we will inject.
	var/datum/reagent/reagent_typepath
	/// How much of [reagent_typepath] we will inject.
	var/to_inject = 0

/datum/action/cooldown/mob_cooldown/aphrodisiacal_bite/New(Target, original, datum/reagent/our_reagent, quantity_override = null)
	. = ..()
	set_reagent(our_reagent, quantity_override)

/datum/action/cooldown/mob_cooldown/aphrodisiacal_bite/proc/set_reagent(datum/reagent/new_reagent, quantity_override = null, cooldown_override = null)
	reagent_typepath = new_reagent
	var/list/reagent_spec = /datum/preference/choiced/aphrodisiacal_bite_venom::aphrodisiacal_bite_choice_specs[new_reagent]
	to_inject = quantity_override || reagent_spec[1]
	cooldown_time = cooldown_override || reagent_spec[2]

/datum/action/cooldown/mob_cooldown/aphrodisiacal_bite/set_click_ability(mob/on_who)
	. = ..()
	if (!.)
		return
	owner.visible_message(span_warning(LANG("datum.10a1ffe027280cbc", list(owner, owner.p_their()))), span_notice(LANG("datum.beb400e3e5d5fb31", null)))

/datum/action/cooldown/mob_cooldown/aphrodisiacal_bite/Activate(atom/target_atom)
	if (!isliving(target_atom))
		return FALSE

	if (astype(owner, /mob/living/carbon)?.is_mouth_covered())
		owner.balloon_alert(owner, LANG("datum.8b7fe4a7666bda72", null))
		return FALSE

	if (!owner.Adjacent(target_atom))
		owner.balloon_alert(owner, LANG("datum.f5e75781e8f1dc46", null))
		return FALSE

	if (target_atom == owner)
		owner.balloon_alert(owner, LANG("datum.c4d2b4798946b8f4", null))
		return FALSE

	if(!iscarbon(target_atom))
		owner.balloon_alert(owner, LANG("datum.1cbaa4cf08bf200c", null))
		return FALSE

	if(!astype(target_atom, /mob/living/carbon).client?.prefs.read_preference(/datum/preference/toggle/erp/aphro))
		owner.balloon_alert(owner, LANG("datum.8529cb15aeaaf38d", null))
		log_game("[key_name(owner)] tried to bite [key_name(astype(target_atom, /mob/living/carbon))] but [key_name(astype(target_atom, /mob/living/carbon))] had aphrodisiacs disabled")
		return FALSE

	log_combat(owner, target_atom, "started to bite", null, "with venom: [reagent_typepath::name]")
	owner.visible_message(span_warning(LANG("datum.b7dd8aa695b7a12b", list(owner, target_atom))), span_warning(LANG("datum.3f396cf83ac73f3a", list(target_atom))), ignored_mobs = target_atom)
	to_chat(target_atom, span_userdanger(LANG("datum.e8886eaaebdcc8e3", list(owner))))
	owner.balloon_alert_to_viewers(LANG("datum.1d0e07beede14ac4", null))
	if (!do_after(owner, 0.5 SECONDS, target_atom, IGNORE_HELD_ITEM))
		return FALSE

	. = ..()

	if (try_bite(target_atom))
		inject(target_atom)
	return TRUE

/// Does NOT inject reagents; represents the initial bite.
/datum/action/cooldown/mob_cooldown/aphrodisiacal_bite/proc/try_bite(mob/living/target)
	PRIVATE_PROC(TRUE)
	var/target_zone = check_zone(owner.zone_selected)

	var/text = "[owner] sinks [owner.p_their()] teeth into [target]'s [target.parse_zone_with_bodypart(target_zone)]!"
	var/self_message = "You sink your teeth into [target]'s [target.parse_zone_with_bodypart(target_zone)]!"
	var/victim_message = "[owner] sinks [owner.p_their()] teeth into your [target.parse_zone_with_bodypart(target_zone)]!"

	owner.visible_message(span_warning(text), span_warning(self_message), ignored_mobs = list(target))
	to_chat(target, span_userdanger(victim_message))

	owner.do_attack_animation(target, ATTACK_EFFECT_BITE)
	playsound(owner, 'sound/items/weapons/bite.ogg', 60, TRUE)
	log_combat(owner, target, "successfully bit", null, "with venom: [reagent_typepath::name]")
	return TRUE

/datum/action/cooldown/mob_cooldown/aphrodisiacal_bite/proc/inject(mob/living/target)
	if (!target.try_inject(owner, check_zone(owner.zone_selected)))
		return FALSE

	add_reagents(target.reagents)
	return TRUE

/datum/action/cooldown/mob_cooldown/aphrodisiacal_bite/proc/add_reagents(datum/reagents/target, harvesting = FALSE)
	var/temp = astype(owner, /mob/living/carbon/human)?.coretemperature
	var/datum/reagent/local_typepath = reagent_typepath
	if (harvesting)
		var/list/spec = /datum/preference/choiced/aphrodisiacal_bite_venom::aphrodisiacal_bite_choice_specs[local_typepath]
		if (!spec[3])
			local_typepath = /datum/reagent/generic_milked_venom

	target.add_reagent(local_typepath, to_inject, reagtemp = temp)
	return TRUE
