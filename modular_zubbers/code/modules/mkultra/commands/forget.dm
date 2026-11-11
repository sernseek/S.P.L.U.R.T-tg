// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mkultra_command/forget
	name = "Forget"
	description = "disable MKUltra and cause your victim to forget they have it. Enable with *snap3"
	feedback = "suddenly falls asleep as they forget about your influence."
	trigger = "forget everything|awake and forget"
	phase_requirement = 3

/datum/mkultra_command/forget/execute(datum/status_effect/mkultra/status, mob/living/owner, mob/source, message)
	. = ..()
	if(!. || status.dormant)
		return FALSE
	status.dormant = TRUE
	owner.clear_alert(status.id)
	to_chat(owner, span_boldwarning(LANG("datum.821bdfbb10aaad4c", list(status.enchanter))))
	owner.AdjustSleeping(10 SECONDS)
	status.RegisterSignal(status.enchanter, COMSIG_MOB_EMOTE, TYPE_PROC_REF(/datum/status_effect/mkultra, snapping))
	return TRUE

/datum/status_effect/mkultra/proc/snapping(atom/source, datum/emote/emote_args) // For the forget command
	SIGNAL_HANDLER

	if(!enchanter)
		return
	if(get_dist(owner, enchanter) >= DEFAULT_VIEW_RANGE)
		return
	if(owner.stat == DEAD || !owner.client || owner.IsSleeping())
		return
	if(emote_args.key == "snap3")
		to_chat(owner, span_warning(LANG("datum.7364ccbd882cd143", list(lewd ? get_gender() : enchanter))))
		to_chat(enchanter, span_notice(LANG("datum.2b4e831e690c08cb", list(owner))))
		dormant = FALSE
		owner.throw_alert(id, alert_type)
		UnregisterSignal(enchanter, COMSIG_MOB_EMOTE)
