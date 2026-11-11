// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mkultra_command/stun
	name = "Stun"
	description = "Briefly incapacitate your victim."
	feedback = "is suddenly stunned!"
	trigger = "hold on|stop|stun|halt|wait|stand still"
	phase_requirement = 2
	cooldown = 1 MINUTES

/datum/mkultra_command/stun/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return
	var/mob/living/victim = owner
	to_chat(victim, span_warning(LANG("datum.aa1502de67b17f8f", list(source))))
	victim.Paralyze(10 SECONDS, TRUE)
