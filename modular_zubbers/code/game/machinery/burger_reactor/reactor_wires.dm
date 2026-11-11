// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define WIRE_VENT_DIRECTION "Vent Direction"
#define WIRE_VENT_POWER "Vent Power"
#define WIRE_TAMPER "Tamper"
#define WIRE_FACTORY_RESET "Factory Reset"

/datum/wires/rbmk2
	holder_type = /obj/machinery/power/rbmk2
	proper_name = "RB-MK2"

/datum/wires/rbmk2/New(atom/holder)
	wires = list(
		WIRE_ACTIVATE,
		WIRE_THROW,
		WIRE_VENT_POWER,
		WIRE_VENT_DIRECTION,
		WIRE_SAFETY,
		WIRE_LIMIT,
		WIRE_POWER,
		WIRE_TAMPER,
	)
	. = ..()

/datum/wires/rbmk2/emp_pulse()
	return TRUE //Handled already in the RBMK.

/datum/wires/rbmk2/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/power/rbmk2/M = holder
	return M.panel_open

/datum/wires/rbmk2/get_status()
	var/obj/machinery/power/rbmk2/M = holder
	. = list()
	. += LANG("datum.50637ffafedc0b84", list(M.power && M.powernet ? "yellow" : "off"))
	. += LANG("datum.3e1ae9d681719f9a", list(M.stored_rod ? "purple" : "off"))
	. += LANG("datum.0b8d503ccae7f5b4", list(M.active ? "green" : "off"))
	. += LANG("datum.2c3bcfb8d9293d5f", list(M.safety ? "blue" : "flashing red"))

	if(M.auto_vent_upgrade && M.auto_vent)
		. += LANG("datum.1c191eb5e95e03ba", list(M.venting ? "yellow" : "flashing red"))
	else if(M.vent_reverse_direction)
		. += LANG("datum.1c191eb5e95e03ba", list(M.venting ? "flashing orange and white" : "flashing red"))
	else
		. += LANG("datum.1c191eb5e95e03ba", list(M.venting ? "green" : "flashing red"))

	. += LANG("datum.38cf17e698565126", list(M.cooling_limiter < M.cooling_limiter_max ? "[M.cooling_limiter]%" : "AUTO"))
	. += LANG("datum.230eb30ac5842bfc", list(M.tampered ? "flashing red" : "green"))

/datum/wires/rbmk2/on_pulse(wire)
	var/obj/machinery/power/rbmk2/M = holder
	switch(wire)
		if(WIRE_FACTORY_RESET)
			M.auto_vent_upgrade = FALSE
			M.safeties_upgrade = FALSE
			M.overclocked_upgrade = FALSE
		if(WIRE_ACTIVATE)
			M.toggle_active(usr)
		if(WIRE_THROW)
			M.remove_rod(usr,do_throw=TRUE)
		if(WIRE_VENT_POWER)
			M.toggle_vents(usr)
			if(isliving(usr))
				M.shock(usr,0.125)
		if(WIRE_VENT_DIRECTION)
			M.toggle_reverse_vents(usr)
		if(WIRE_SAFETY)
			M.toggle_active(usr,FALSE)
		if(WIRE_LIMIT)
			M.cooling_limiter = (M.cooling_limiter + 10) % (M.cooling_limiter_max+10)
		if(WIRE_POWER)
			if(isliving(usr))
				M.shock(usr,0.5)
		if(WIRE_TAMPER)
			M.tampered = TRUE

/datum/wires/rbmk2/on_cut(wire, mend, source)
	var/obj/machinery/power/rbmk2/M = holder
	switch(wire)
		if(WIRE_ACTIVATE)
			M.toggle_active(usr,mend)
		if(WIRE_THROW)
			if(mend)
				M.remove_rod(usr,do_throw=TRUE)
		if(WIRE_VENT_POWER)
			M.toggle_vents(usr,mend)
			if(isliving(usr))
				M.shock(usr,0.25)
		if(WIRE_VENT_DIRECTION)
			if(mend)
				M.toggle_reverse_vents(usr,FALSE)
		if(WIRE_SAFETY)
			M.safety = mend
			if(!mend)
				var/turf/T = get_turf(M)
				if(usr)
					message_admins("[src] had the safety wire cut by [ADMIN_LOOKUPFLW(usr)] at [ADMIN_VERBOSEJMP(T)].")
					usr.log_message("cut the safety wire of [M]", LOG_GAME)
					M.investigate_log("had the safety wire cut by [key_name(usr)] at [AREACOORD(M)].", INVESTIGATE_ENGINE)
				else
					message_admins("[src] had the safety wire cut at [ADMIN_VERBOSEJMP(T)]")
					log_game("[src] had the safety wire cut at [AREACOORD(T)]")
					M.investigate_log("had the safety wire cut at [AREACOORD(T)]", INVESTIGATE_ENGINE)
		if(WIRE_LIMIT)
			M.cooling_limiter = mend ? initial(M.cooling_limiter) : 0
		if(WIRE_POWER)
			M.power = mend
			if(!mend)
				var/turf/T = get_turf(M)
				if(usr)
					message_admins("[src] had the power wire cut by [ADMIN_LOOKUPFLW(usr)] at [ADMIN_VERBOSEJMP(T)].")
					usr.log_message("cut the power wire of [M]", LOG_GAME)
					M.investigate_log("had the power wire cut by [key_name(usr)] at [AREACOORD(M)].", INVESTIGATE_ENGINE)
				else
					message_admins("[src] had the power wire cut at [ADMIN_VERBOSEJMP(T)]")
					log_game("[src] had the power wire cut at [AREACOORD(T)]")
					M.investigate_log("had the power wire cut at [AREACOORD(T)]", INVESTIGATE_ENGINE)
			if(isliving(usr))
				M.shock(usr)
		if(WIRE_TAMPER)
			M.tampered = TRUE

/datum/wires/rbmk2/can_reveal_wires(mob/user)
	if(HAS_TRAIT(user, TRAIT_KNOW_ENGI_WIRES))
		return TRUE
	return ..()


#undef WIRE_VENT_DIRECTION
#undef WIRE_VENT_POWER
#undef WIRE_TAMPER
#undef WIRE_FACTORY_RESET
