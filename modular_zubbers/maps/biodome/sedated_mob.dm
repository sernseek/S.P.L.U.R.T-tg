// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/**
 * Attached to a mob with an AI controller, if this mob is attacked then it will replace the AI controller.
 */
/datum/element/sedated_mob
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// The AI controller used when we wake up
	var/awake_controller

/datum/element/sedated_mob/Attach(datum/target, awake_controller)
	. = ..()
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE

	src.awake_controller = awake_controller
	target.AddElement(/datum/element/relay_attackers)
	RegisterSignal(target, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_attacked))

/datum/element/sedated_mob/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_ATOM_WAS_ATTACKED)

/// Add an attacking atom to a blackboard list of things which attacked us
/datum/element/sedated_mob/proc/on_attacked(mob/victim, atom/attacker)
	SIGNAL_HANDLER

	if (!victim.ai_controller || victim.stat == DEAD)
		return
	victim.balloon_alert_to_viewers(LANG("datum.0002006ddb4e4a89", null))
	victim.ai_controller = new awake_controller(victim)
	victim.RemoveElement(/datum/element/sedated_mob, awake_controller)
