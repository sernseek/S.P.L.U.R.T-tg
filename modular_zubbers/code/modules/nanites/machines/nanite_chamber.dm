// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/nanite_chamber
	name = "nanite chamber"
	desc = "A device that can scan, reprogram, and inject nanites."
	circuit = /obj/item/circuitboard/machine/nanite_chamber
	icon = 'icons/obj/machines/bci_implanter.dmi'
	icon_state = "bci_implanter"
	base_icon_state = "bci_implanter"
	layer = ABOVE_WINDOW_LAYER
	use_power = IDLE_POWER_USE
	anchored = TRUE
	density = TRUE
	idle_power_usage = 50
	active_power_usage = 300

	var/locked = FALSE
	var/breakout_time = 1200
	var/scan_level
	var/busy = FALSE
	var/busy_icon_state
	var/busy_message
	var/message_cooldown = 0

/obj/machinery/nanite_chamber/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	occupant_typecache = GLOB.typecache_living

/obj/machinery/nanite_chamber/RefreshParts()
	. = ..()
	scan_level = 0
	for(var/datum/stock_part/P in component_parts)
		scan_level += P.tier

/obj/machinery/nanite_chamber/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice(LANG("obj.21ba9fdf06241564", list(scan_level)))

/obj/machinery/nanite_chamber/proc/set_busy(status, message, working_icon)
	busy = status
	busy_message = message
	busy_icon_state = working_icon
	update_appearance()

/obj/machinery/nanite_chamber/proc/set_safety(threshold)
	if(!occupant)
		return
	SEND_SIGNAL(occupant, COMSIG_NANITE_SET_SAFETY, threshold)

/obj/machinery/nanite_chamber/proc/set_cloud(cloud_id)
	if(!occupant)
		return
	SEND_SIGNAL(occupant, COMSIG_NANITE_SET_CLOUD, cloud_id)

/obj/machinery/nanite_chamber/proc/inject_nanites()
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if((machine_stat & MAINT) || panel_open)
		return
	if(!occupant || busy)
		return

	var/locked_state = locked
	locked = TRUE

	//TODO OMINOUS MACHINE SOUNDS
	set_busy(TRUE, "Initializing injection protocol...", "[initial(icon_state)]_raising")
	addtimer(CALLBACK(src, PROC_REF(set_busy), TRUE, "Analyzing host bio-structure...", "[initial(icon_state)]_active"), 20)
	addtimer(CALLBACK(src, PROC_REF(set_busy), TRUE, "Priming nanites...", "[initial(icon_state)]_active"), 40)
	addtimer(CALLBACK(src, PROC_REF(set_busy), TRUE, "Injecting...", "[initial(icon_state)]_active"), 70)
	addtimer(CALLBACK(src, PROC_REF(set_busy), TRUE, "Activating nanites...", "[initial(icon_state)]_falling"), 110)
	addtimer(CALLBACK(src, PROC_REF(complete_injection), locked_state), 130)

/obj/machinery/nanite_chamber/proc/complete_injection(locked_state)
	//TODO MACHINE DING
	locked = locked_state
	set_busy(FALSE)
	if(!occupant)
		return
	occupant.AddComponent(/datum/component/nanites, 100)

/obj/machinery/nanite_chamber/proc/remove_nanites(datum/nanite_program/NP)
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if((machine_stat & MAINT) || panel_open)
		return
	if(!occupant || busy)
		return

	var/locked_state = locked
	locked = TRUE

	//TODO OMINOUS MACHINE SOUNDS
	set_busy(TRUE, "Initializing cleanup protocol...", "[initial(icon_state)]_raising")
	addtimer(CALLBACK(src, PROC_REF(set_busy), TRUE, "Analyzing host bio-structure...", "[initial(icon_state)]_active"), 20)
	addtimer(CALLBACK(src, PROC_REF(set_busy), TRUE, "Pinging nanites...", "[initial(icon_state)]_active"), 40)
	addtimer(CALLBACK(src, PROC_REF(set_busy), TRUE, "Initiating graceful self-destruct sequence...", "[initial(icon_state)]_active"), 70)
	addtimer(CALLBACK(src, PROC_REF(set_busy), TRUE, "Removing debris...", "[initial(icon_state)]_falling"), 110)
	addtimer(CALLBACK(src, PROC_REF(complete_removal), locked_state), 130)

/obj/machinery/nanite_chamber/proc/complete_removal(locked_state)
	//TODO MACHINE DING
	locked = locked_state
	set_busy(FALSE)
	if(!occupant)
		return
	SEND_SIGNAL(occupant, COMSIG_NANITE_DELETE)

/obj/machinery/nanite_chamber/update_icon_state()
	//running and someone in there
	if(occupant)
		icon_state = busy ? busy_icon_state : "[base_icon_state]_occupied"
		return ..()
	//running
	icon_state = "[base_icon_state][state_open ? "_open" : null]"
	return ..()

/obj/machinery/nanite_chamber/update_overlays()
	. = ..()

	if((machine_stat & MAINT) || panel_open)
		. += "maint"
		return

	if(machine_stat & (NOPOWER|BROKEN))
		return

	if(busy || locked)
		. += "red"
		if(locked)
			. += "bolted"
		return

	. += "green"

/obj/machinery/nanite_chamber/proc/toggle_open(mob/user)
	if(panel_open)
		to_chat(user, span_notice(LANG("obj.0358adf39518d281", null)))
		return

	if(state_open)
		close_machine()
		return

	else if(locked)
		to_chat(user, span_notice(LANG("obj.3d9ccd003f8df7c4", null)))
		return

	open_machine()

/obj/machinery/nanite_chamber/container_resist_act(mob/living/user)
	if(!locked)
		open_machine()
		return
	if(busy)
		return
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_notice(LANG("obj.485787b2b8d67ec7", list(user, src))), \
		span_notice(LANG("obj.43ad33b141e25411", list(src, DisplayTimeText(breakout_time)))), \
		span_hear(LANG("obj.a1d9c5733c600b1c", list(src))))
	if(do_after(user,(breakout_time), target = src))
		if(!user || !IS_UNCONSCIOUS_OR_CRIT(user) || user.loc != src || state_open || !locked || busy)
			return
		locked = FALSE
		user.visible_message(span_warning(LANG("obj.37696909131e91b5", list(user, src))), \
			span_notice(LANG("obj.81c31f6b9b00625a", list(src))))
		open_machine()

/obj/machinery/nanite_chamber/close_machine(mob/living/carbon/user, density_to_set = TRUE)
	if(!state_open)
		return FALSE

	..(user)
	return TRUE

/obj/machinery/nanite_chamber/open_machine(drop = TRUE, density_to_set = FALSE)
	if(state_open)
		return FALSE

	..()

	return TRUE

/obj/machinery/nanite_chamber/relaymove(mob/living/user, direction)
	if(user.stat || locked)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, span_warning(LANG("obj.c4e897cb78099448", list(src))))
		return
	open_machine()

/obj/machinery/nanite_chamber/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(occupant)
		balloon_alert(user, LANG("obj.e2478aef43510749", null))
		return ITEM_INTERACT_BLOCKING
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/nanite_chamber/attackby(obj/item/I, mob/user, params)
	if(default_pry_open(I))
		return

	if(default_deconstruction_crowbar(I))
		return

	return ..()

/obj/machinery/nanite_chamber/interact(mob/user)
	toggle_open(user)

/obj/machinery/nanite_chamber/mouse_drop_receive(atom/target, mob/user, params)
	if(!user.can_perform_action(src, FORBID_TELEKINESIS_REACH|SILENT_ADJACENCY) || !iscarbon(target))
		return
	if(close_machine(target))
		log_combat(user, target, "inserted", null, "into [src].")
	add_fingerprint(user)
