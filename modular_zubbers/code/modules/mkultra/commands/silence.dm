// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mkultra_command/silence
	name = "Invoke Silence"
	description = "Invoke silence in your target."
	feedback = "shuts their mouth tight!"
	trigger = "shh|silence|stop talking|shut up|be quiet|hush"
	cooldown = 60 SECONDS
	phase_requirement = 1

/datum/mkultra_command/silence/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/victim = owner
	if(status.phase == 3)
		ADD_TRAIT(victim, TRAIT_MUTE, "mkultra")
		to_chat(victim, span_warning(LANG("datum.4fce8f28fa544655", list(status.lewd ? "obediently" : ""))))
	else
		victim.adjust_silence(20 SECONDS * status.phase)
		to_chat(victim, span_warning(LANG("datum.e8f4c73198529273", list(status.lewd ? status.get_gender() : source))))
	return TRUE

/datum/mkultra_command/silence/on_destroy(datum/status_effect/mkultra/status, mob/owner, mob/source)
	var/mob/living/victim = owner
	REMOVE_TRAIT(victim, TRAIT_MUTE, "mkultra")
	victim.set_silence(0)

/datum/mkultra_command/speak
	name = "Allow Speech"
	description = "Allow your target to speak normally again."
	feedback = "is allowed to speak again."
	trigger = "talk|speak|talk to me|say something|speak"
	phase_requirement = 1

/datum/mkultra_command/speak/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/victim = owner
	REMOVE_TRAIT(victim, TRAIT_MUTE, "mkultra")
	victim.set_silence(0)
	to_chat(victim, span_notice(LANG("datum.0a546e0271cfe0ad", list(status.lewd ? status.get_gender() : source))))
	return TRUE
