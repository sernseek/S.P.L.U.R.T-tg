// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mkultra_command/sleep_command
	name = "Sleep"
	description = "Make your victim sleep for 60 seconds."
	feedback = "falls asleep instantly!"
	trigger = "go to sleep|slumber|rest|take a nap"
	phase_requirement = 2
	cooldown = 4 MINUTES

/datum/mkultra_command/sleep_command/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/victim = owner
	if(HAS_TRAIT(victim, TRAIT_KNOCKEDOUT))
		to_chat(source, span_warning(LANG("datum.ba3e6d681dba128a", list(victim))))
		return FALSE
	victim.SetSleeping(1 MINUTES)
	return TRUE
