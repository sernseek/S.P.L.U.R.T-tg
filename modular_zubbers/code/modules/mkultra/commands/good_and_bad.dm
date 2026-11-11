// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mkultra_command/good_boy
	name = "Praise"
	description = "Give praise as a reward"
	feedback = "shudders from the praise!"
	erp_command = TRUE
	trigger = "good boy|good girl|good pet|good job|good"
	cooldown = 10 SECONDS

/datum/mkultra_command/good_boy/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return FALSE
	to_chat(owner, span_userlove(LANG("datum.a34000d587e738c6", list(status.get_gender()))))
	owner.emote("shiver")
	status.progress += 20
	return TRUE

/datum/mkultra_command/bad_boy
	name = "Punish"
	description = "Verbally punish your pet"
	feedback = "shrinks from the scorn."
	erp_command = TRUE
	trigger = "bad boy|bad girl|bad pet|bad job"
	cooldown = 10 SECONDS

/datum/mkultra_command/bad_boy/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return FALSE
	to_chat(owner, span_red(LANG("datum.30f9b506a449790b", list(status.get_gender()))))
	return TRUE
