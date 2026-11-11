// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mkultra_command/laydown
	name = "Kneel / Laydown"
	description = "Causes your thrall to lay down."
	feedback = "immediately places themselves on the ground."
	trigger = "lay down|kneel|rest|on the floor"
	phase_requirement = 1
	erp_command = TRUE
	cooldown = 10 SECONDS

/datum/mkultra_command/laydown/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return
	var/datum/status_effect/mkultra/ultra = status
	var/mob/living/victim = owner
	to_chat(owner, span_userlove(LANG("datum.550d0120bffc8b94", list(ultra.get_gender()))))
	victim.toggle_resting()

