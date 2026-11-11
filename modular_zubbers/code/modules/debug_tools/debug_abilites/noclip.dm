// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/action/cooldown/noclip
	name = "Toggle noclip"
	desc = "Grand you ability move through solid objects like turfs and mobs. This also renders you unclickable by other players."
	cooldown_time = 1 SECONDS

	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "the_freezer"
	var/enabled = FALSE

/datum/action/cooldown/noclip/IsAvailable(feedback)
	. = ..()

	if(owner.stat & DEAD)
		return
	if(INCAPACITATED_IGNORING(owner, INCAPABLE_GRAB))
		return

/datum/action/cooldown/noclip/Activate(atom/target)
	. = ..()
	if(enabled)
		disable_noclip()
		return TRUE
	enable_noclip()
	return TRUE

/datum/action/cooldown/noclip/proc/enable_noclip()
	owner.pass_flags |= PASSCLOSEDTURF | PASSTABLE | PASSDOORS | PASSBLOB | PASSGLASS | PASSGRILLE | PASSMOB | PASSSTRUCTURE | PASSVEHICLE
	owner.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	owner.density = FALSE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/noclip)
	owner.visible_message(span_notice(LANG("datum.c239659eeab5a79c", list(owner.name))), span_notice(LANG("datum.9be5410ae328fcd5", null)))
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(owner_dead), TRUE)
	enabled = TRUE

/datum/action/cooldown/noclip/proc/disable_noclip()
	owner.pass_flags = initial(owner.pass_flags)
	owner.mouse_opacity = initial(owner.mouse_opacity)
	owner.density = initial(owner.density)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/noclip)
	owner.visible_message(span_notice(LANG("datum.9890fa294b284f2c", list(owner.name))), span_notice(LANG("datum.b19779cce9102fa1", null)))
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	enabled = FALSE

/datum/action/cooldown/noclip/proc/owner_dead()
	SIGNAL_HANDLER

	if(enabled)
		disable_noclip()
		StartCooldown()

/datum/movespeed_modifier/noclip
	id = "noclip"
	movetypes = GROUND | FLYING
	multiplicative_slowdown = -2
