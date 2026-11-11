// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mkultra_command/mind_control
	name = "Brainwash"
	description = "Brainwash your victim with a new objective. This is mechanic backed brainwashing that gives your victim the brainwashed antag status."
	feedback = "loosens as you instill a new objective."
	trigger = "new order|obey this command|new objective"
	phase_requirement = 3
	cooldown = 5 MINUTES

/datum/mkultra_command/mind_control/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return FALSE
	var/text = tgui_input_text(source, title = LANG("datum.acb48f897b828efc", null), max_length = 150)
	if(!text)
		return FALSE
	brainwash(owner, text)
	return TRUE
