// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/**
 *	# Dominate;
 *
 *	Level 1 - Mesmerizes target
 *	Level 2 - Mesmerizes and mutes target
 *	Level 3 - Mesmerizes, blinds and mutes target
 *	Level 4 - Target (if at least in crit & has a mind) will revive as a Mute/Deaf Ghoul for 5 minutes before dying.
 *	Level 5 - Target (if at least in crit & has a mind) will revive as a Ghoul for 8 minutes before dying.
 */

#define TEMP_GHOULIZE_COST 150
#define DOMINATE_XRAY_LEVEL 3
#define DOMINATE_NON_MUTE_GHOULIZE_LEVEL 4
/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate
	name = "Dominate"
	button_icon_state = "power_auspex"
	background_icon_state = "tremere_power_off"
	active_background_icon_state = "tremere_power_on"
	base_background_icon_state = "tremere_power_off"
	button_icon = 'modular_zubbers/icons/mob/actions/tremere_bloodsucker.dmi'
	background_icon = 'modular_zubbers/icons/mob/actions/tremere_bloodsucker.dmi'
	level_current = 1
	button_icon_state = "power_dominate"
	purchase_flags = TREMERE_CAN_BUY
	bloodcost = 15
	constant_bloodcost = 0.1
	target_range = 6
	mesmerize_delay = 4 SECONDS
	blind_at_level = 3
	requires_facing_target = FALSE
	blocked_by_glasses = FALSE
	knockdown_on_secondary = TRUE
	/// Data huds to show while the power is active
	var/list/datahuds = list(DATA_HUD_SECURITY_ADVANCED, DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC, DATA_HUD_BOT_PATH)
	var/list/thralls = list()

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/Remove(mob/removed_from)
	. = ..()
	for(var/thrall in thralls)
		if(!thrall)
			continue
		end_possession(thrall)

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/get_power_desc_extended()
	. = ..()
	if(level_current >= DOMINATE_GHOULIZE_LEVEL)
		. += LANG("datum.dfe0570a2a39e5d4", list(TEMP_GHOULIZE_COST))

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/get_power_explanation_extended()
	. = list()
	. += LANG("datum.ec3979e3e3a5762b", list(DisplayTimeText(mesmerize_delay), DisplayTimeText(get_power_time())))
	. += LANG("datum.20ab440b0d89c6f7", list(DisplayTimeText(get_power_time())))
	. += LANG("datum.88cd7d72f136452d", list(DisplayTimeText(get_power_time()), DisplayTimeText(get_power_time())))
	. += LANG("datum.3a6c04a25a9d3423", null)
	. += LANG("datum.d071d544d0725849", list(DOMINATE_XRAY_LEVEL))
	. += LANG("datum.dfb85b4dc2fdcb9b", list(DOMINATE_GHOULIZE_LEVEL, TEMP_GHOULIZE_COST))
	. += LANG("datum.a2d2f1569d34739e", list(BLOOD_VOLUME_BAD))
	. += LANG("datum.42aeb1819e678dd8", list(src, DOMINATE_NON_MUTE_GHOULIZE_LEVEL))
	. += LANG("datum.57f57519740fc489", null)
	. += LANG("datum.e79eda28f0fbf80c", list(DisplayTimeText(get_ghoul_duration())))
	. += LANG("datum.93bf59ff663c561b", list(DisplayTimeText(get_ghoulize_cooldown())))

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/CheckCanTarget(atom/target_atom)
	var/mob/living/selected_target = target_atom
	if(level_current >= DOMINATE_GHOULIZE_LEVEL && (IS_GHOUL(selected_target) || selected_target.stat >= SOFT_CRIT))
		if(selected_target?.mind && owner.Adjacent(selected_target))
			return TRUE
	. = ..()
	if(!.)
		return FALSE
	return TRUE

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/ContinueActive(mob/living/user, mob/living/target)
	if(!target)
		return can_use(user)
	. = ..()

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/ActivatePower(atom/target)
	. = ..()
	if(level_current >= DOMINATE_XRAY_LEVEL)
		ADD_TRAIT(owner, TRAIT_XRAY_VISION, DOMINATE_TRAIT)
	for(var/hudtype in datahuds)
		var/datum/atom_hud/data_hud = GLOB.huds[hudtype]
		data_hud.show_to(owner)
	owner.update_sight()
	return TRUE

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/DeactivatePower(deactivate_flags)
	. = ..()
	if(!.)
		return
	if(level_current >= DOMINATE_XRAY_LEVEL)
		REMOVE_TRAIT(owner, TRAIT_XRAY_VISION, DOMINATE_TRAIT)
	for(var/hudtype in datahuds)
		var/datum/atom_hud/data_hud = GLOB.huds[hudtype]
		data_hud.hide_from(owner)
	owner.update_sight()

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/FireTargetedPower(atom/target, params)
	var/mob/living/target_mob = target
	var/mob/living/user = owner
	if(IS_UNCONSCIOUS(target_mob) && level_current >= DOMINATE_GHOULIZE_LEVEL)
		if(user.Adjacent(target))
			attempt_ghoulize(target, user)
		else
			if(IS_GHOUL(target_mob))
				owner.balloon_alert(owner, LANG("datum.8601337967f5ba43", null))
			else
				owner.balloon_alert(owner, LANG("datum.7dd2e7429c68b114", null))
		return TRUE
	return ..()

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/proc/attempt_ghoulize(mob/living/target, mob/living/user)
	owner.face_atom(target)
	var/datum/antagonist/ghoul/ghoul = IS_GHOUL(target)
	if(!victim_has_blood(target))
		return FALSE
	if(ghoul)
		owner.balloon_alert(owner, LANG("datum.a4a0012b97ba0c70", null))
	else
		owner.balloon_alert(owner, LANG("datum.e0433dcd5ef1a30a", null))
	if(!do_after(user, 6 SECONDS, target, NONE, TRUE))
		return FALSE
	if(!victim_has_blood(target))
		return FALSE
	if(ghoul?.master == bloodsuckerdatum_power)
		if(target.stat != DEAD)
			owner.balloon_alert(owner, LANG("datum.f5271c5dfec0a80a", null))
			return FALSE
		PowerActivatedSuccesfully(get_ghoulize_cooldown())
		to_chat(user, span_warning(LANG("datum.c1420e157f463265", list(target))))
		owner.balloon_alert(owner, LANG("datum.d4d901f326d51a33", null))
		target.mind?.grab_ghost()
		target.revive(ADMIN_HEAL_ALL)
		pay_cost(TEMP_GHOULIZE_COST - bloodcost)
		log_combat(owner, target, "tremere revived", addition="Revived their ghoul using dominate")
		return FALSE
	if(!bloodsuckerdatum_power.make_ghoul(target))
		owner.balloon_alert(owner, LANG("datum.e19896d4b6f902ea", null))
		return

	/*if(IS_MONSTERHUNTER(target))
		to_chat(target, span_notice("Their body refuses to react..."))
		return*/
	PowerActivatedSuccesfully(get_ghoulize_cooldown())
	to_chat(user, span_warning(LANG("datum.c1420e157f463265", list(target))))
	// no escaping at this point
	target.mind?.grab_ghost(TRUE)
	target.revive(ADMIN_HEAL_ALL)
	var/datum/antagonist/ghoul/ghouldatum = target.mind.has_antag_datum(/datum/antagonist/ghoul)
	ghouldatum.special_type = TREMERE_GHOUL //don't turn them into a favorite please
	var/living_time = get_ghoul_duration()
	log_combat(owner, target, "tremere mindslaved", addition="Revived and converted [target] into a temporary tremere ghoul for [DisplayTimeText(living_time)].")
	if(level_current <= DOMINATE_NON_MUTE_GHOULIZE_LEVEL)
		target.add_traits(list(TRAIT_MUTE, TRAIT_DEAF), DOMINATE_TRAIT)
	user.balloon_alert(target, LANG("datum.c35d2d27fa30312c", list(DisplayTimeText(living_time))))
	to_chat(target, span_warning(LANG("datum.56cd5bd8d3c496f0", list(DisplayTimeText(living_time)))))
	var/timer_id = addtimer(CALLBACK(src, PROC_REF(end_possession), target), living_time, TIMER_STOPPABLE)
	// timer that only the master and thrall can see
	setup_timer(user, target, living_time, timer_id)
	thralls += target
	RegisterSignals(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING), PROC_REF(end_possession), timer_id)
	RegisterSignal(ghouldatum, COMSIG_ANTAGONIST_REMOVED, PROC_REF(on_antag_datum_removal), target, timer_id)
	pay_cost(TEMP_GHOULIZE_COST - bloodcost)
	return TRUE

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/proc/victim_has_blood(mob/living/target)
	// you can always revive non-temporary ghouls
	if(IS_GHOUL(target))
		return TRUE
	if(target.blood_volume < BLOOD_VOLUME_BAD)
		owner.balloon_alert(owner, LANG("datum.4709ed4274b959f7", null))
		return FALSE
	return TRUE

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/proc/setup_timer(mob/living/user, mob/living/target, living_time, timer_id)
	var/list/show_to = list(user, target)
	if(bloodsuckerdatum_power && length(bloodsuckerdatum_power.ghouls))
		for(var/datum/antagonist/ghoul in bloodsuckerdatum_power.ghouls)
			if(!ghoul?.owner?.current)
				continue
			show_to += ghoul.owner.current
	new /atom/movable/screen/text/screen_timer/attached(null, show_to, timer_id, "Dies in ${timer}", null, null, target)
	new /atom/movable/screen/text/screen_timer(null, target, timer_id, "You die in ${timer}")

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/proc/on_antag_datum_removal(datum/antagonist/ghoul, mob/living/thrall, timer_id)
	end_possession(thrall, timer_id)

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/proc/end_possession(mob/living/user, timer_id)
	if(timer_id)
		deltimer(timer_id)
	if(!user)
		CRASH("[src] end_possession called with no user!")
	if(!(user in thralls))
		return
	thralls -= user
	user.remove_traits(list(TRAIT_MUTE, TRAIT_DEAF), DOMINATE_TRAIT)
	if(!HAS_TRAIT(user, TRAIT_NOBLOOD))
		user.blood_volume = 0
	if(!IS_GHOUL(user))
		to_chat(user, span_warning(LANG("datum.933679bbff7c0ef9", null)))
		return
	to_chat(user, span_warning(LANG("datum.5f97c48a7cd52863", null)))
	user.mind?.remove_antag_datum(/datum/antagonist/ghoul)
	if(user.stat == DEAD)
		return
	user.death()

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/proc/get_ghoul_duration()
	return 4 MINUTES * max(level_current, 1)

/datum/action/cooldown/bloodsucker/targeted/mesmerize/dominate/proc/get_ghoulize_cooldown()
	return cooldown_time * 3

#undef TEMP_GHOULIZE_COST
#undef DOMINATE_XRAY_LEVEL
#undef DOMINATE_NON_MUTE_GHOULIZE_LEVEL
