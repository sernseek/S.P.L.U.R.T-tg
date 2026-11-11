// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/**
 *	# Ghoul Pinpointer
 *
 *	Pinpointer that points to their Master's location at all times.
 *	Unlike the Monster hunter one, this one is permanently active, and has no power needed to activate it.
 */

/atom/movable/screen/alert/status_effect/agent_pinpointer/ghoul_edition
	name = "Blood Bond"
	desc = "You always know where your master is."

/datum/status_effect/agent_pinpointer/ghoul_edition
	id = "agent_pinpointer"
	alert_type = /atom/movable/screen/alert/status_effect/agent_pinpointer/ghoul_edition
	minimum_range = GHOUL_SCAN_MIN_DISTANCE
	tick_interval = GHOUL_SCAN_PING_TIME
	duration = STATUS_EFFECT_PERMANENT
	range_fuzz_factor = 0

/datum/status_effect/agent_pinpointer/ghoul_edition/on_creation(mob/living/new_owner, ...)
	..()
	var/datum/antagonist/ghoul/antag_datum = new_owner.mind.has_antag_datum(/datum/antagonist/ghoul)
	scan_target = antag_datum?.master?.owner?.current

/datum/status_effect/agent_pinpointer/ghoul_edition/scan_for_target()
	return

/datum/status_effect/agent_pinpointer/ghoul_edition/Destroy()
	if(scan_target)
		to_chat(owner, span_notice(LANG("datum.b87ae244cec74a68", null)))
	return ..()
