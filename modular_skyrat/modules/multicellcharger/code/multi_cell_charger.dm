// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/cell_charger_multi
	name = "multi-cell charging rack"
	desc = "A cell charging rack for multiple batteries."
	icon = 'modular_skyrat/modules/aesthetics/cells/cell.dmi'
	icon_state = "cchargermulti"
	base_icon_state = "cchargermulti"
	use_power = IDLE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 60
	power_channel = AREA_USAGE_EQUIP
	circuit = /obj/item/circuitboard/machine/cell_charger_multi
	pass_flags = PASSTABLE
	/// The list of batteries we are gonna charge!
	var/list/charging_batteries = list()
	/// Number of concurrent batteries that can be charged
	var/max_batteries = 4
	/// The base charge rate when spawned
	var/charge_rate = STANDARD_CELL_RATE

/obj/machinery/cell_charger_multi/update_overlays()
	. = ..()

	if(!charging_batteries.len)
		return

	for(var/i = charging_batteries.len, i >= 1, i--)
		var/obj/item/stock_parts/power_store/cell/charging = charging_batteries[i]
		var/newlevel = round(charging.percent() * 4 / 100)
		var/mutable_appearance/charge_overlay = mutable_appearance(icon, "[base_icon_state]-o[newlevel]")
		var/mutable_appearance/cell_overlay = mutable_appearance(icon, "[base_icon_state]-cell")
		charge_overlay.pixel_x = 5 * (i - 1)
		cell_overlay.pixel_x = 5 * (i - 1)
		. += new /mutable_appearance(charge_overlay)
		. += new /mutable_appearance(cell_overlay)

/obj/machinery/cell_charger_multi/click_alt(mob/user)
	if(!can_interact(user) || !charging_batteries.len)
		return
	to_chat(user, span_notice(LANG("obj.d929e1badef7503b", null)))
	for(var/i in charging_batteries)
		removecell()
	return CLICK_ACTION_SUCCESS

/obj/machinery/cell_charger_multi/examine(mob/user)
	. = ..()
	if(!charging_batteries.len)
		. += LANG("obj.4d1f049a8bc14a84", list(src))
	else
		. += LANG("obj.894e8427d8b3773c", list(charging_batteries.len, src))
		for(var/obj/item/stock_parts/power_store/cell/charging in charging_batteries)
			. += LANG("obj.ef59e67cb6b77620", list(charging, round(charging.percent(), 1)))
	if(in_range(user, src) || isobserver(user))
		. += span_notice(LANG("obj.950628d2734e1f1b", list(display_power(charge_rate, convert = FALSE))))
	. += span_notice(LANG("obj.6b876f29e7ec3797", null))

/obj/machinery/cell_charger_multi/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(length(charging_batteries))
		to_chat(user, span_warning(LANG("obj.128fad95941ae74a", list(src))))
		return ITEM_INTERACT_BLOCKING
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/cell_charger_multi/attackby(obj/item/tool, mob/user, params)
	if(istype(tool, /obj/item/stock_parts/power_store/cell) && !panel_open)
		if(machine_stat & BROKEN)
			to_chat(user, span_warning(LANG("obj.e2c73115e801b359", list(src))))
			return
		if(!anchored)
			to_chat(user, span_warning(LANG("obj.f467682f5bf33467", list(src))))
			return
		var/obj/item/stock_parts/power_store/cell/inserting_cell = tool
		if(inserting_cell.chargerate <= 0)
			to_chat(user, span_warning(LANG("obj.d4b2e04f1ab025de", list(inserting_cell))))
			return
		if(length(charging_batteries) >= max_batteries)
			to_chat(user, span_warning(LANG("obj.4599e6423f3a5dbe", list(src))))
			return
		else
			var/area/current_area = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(current_area))
				return
			if(current_area.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, span_warning(LANG("obj.ebb2a520235ba42f", list(src))))
				return
			if(!user.transferItemToLoc(tool,src))
				return

			charging_batteries += tool
			user.visible_message(span_notice(LANG("obj.c4a3d9201d508013", list(user, src))), span_notice(LANG("obj.0e4e6b90adadf964", list(src))))
			update_appearance()
	else
		if(default_deconstruction_crowbar(tool))
			return
		if(!charging_batteries.len && default_unfasten_wrench(user, tool))
			return
		return ..()

/obj/machinery/cell_charger_multi/process(seconds_per_tick)
	if(!charging_batteries.len || !anchored || (machine_stat & (BROKEN|NOPOWER)))
		return

	// create a charging queue, we only want cells that require charging to use the power budget
	var/list/charging_queue
	for(var/obj/item/stock_parts/power_store/cell/battery_slot in charging_batteries)
		if(battery_slot.percent() >= 100)
			continue
		LAZYADD(charging_queue, battery_slot)

	if(!LAZYLEN(charging_queue))
		return

	//use a small bit for the charger itself, but power usage scales up with the part tier
	use_energy(charge_rate / length(charging_queue) * seconds_per_tick * 0.01)

	for(var/obj/item/stock_parts/power_store/cell/charging_cell in charging_queue)
		charge_cell(charge_rate * seconds_per_tick, charging_cell)

	LAZYNULL(charging_queue)
	update_appearance()

/obj/machinery/cell_charger_multi/attack_tk(mob/user)
	if(!charging_batteries.len)
		return

	to_chat(user, span_notice(LANG("obj.2e70f3132b99713e", list(removecell(user), src))))

	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/machinery/cell_charger_multi/RefreshParts()
	. = ..()
	var/tier_total
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		tier_total += capacitor.tier
	charge_rate = tier_total * (initial(charge_rate) / 6)

/obj/machinery/cell_charger_multi/emp_act(severity)
	. = ..()

	if(machine_stat & (BROKEN|NOPOWER) || . & EMP_PROTECT_CONTENTS)
		return

	for(var/obj/item/stock_parts/power_store/cell/charging in charging_batteries)
		charging.emp_act(severity)

/obj/machinery/cell_charger_multi/on_deconstruction(disassembled)
	for(var/obj/item/stock_parts/power_store/cell/charging in charging_batteries)
		charging.forceMove(drop_location())
	charging_batteries = null
	return ..()


/obj/machinery/cell_charger_multi/attack_ai(mob/user)
	return

/obj/machinery/cell_charger_multi/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return

	var/obj/item/stock_parts/power_store/cell/charging = removecell(user)

	if(!charging)
		return

	user.put_in_hands(charging)
	charging.add_fingerprint(user)

	user.visible_message(span_notice(LANG("obj.4a2c1fddbcf43cde", list(user, charging, src))), span_notice(LANG("obj.cbed32661d4c054a", list(charging, src))))

/obj/machinery/cell_charger_multi/proc/removecell(mob/user)
	if(!charging_batteries.len)
		return FALSE
	var/obj/item/stock_parts/power_store/cell/charging
	if(charging_batteries.len > 1 && user)
		var/list/buttons = list()
		for(var/obj/item/stock_parts/power_store/cell/battery in charging_batteries)
			buttons["[battery.name] ([round(battery.percent(), 1)]%)"] = battery
		var/cell_name = tgui_input_list(user, LANG("obj.8ba5d457784be70c", null), LANG("obj.bbe3072dc2846a30", null), buttons)
		if(!in_range(loc, user))
			return FALSE
		charging = buttons[cell_name]
	else
		charging = charging_batteries[1]
	if(!charging)
		return FALSE
	charging.forceMove(drop_location())
	charging.update_appearance()
	charging_batteries -= charging
	update_appearance()
	return charging

/obj/machinery/cell_charger_multi/Destroy()
	for(var/obj/item/stock_parts/power_store/cell/charging in charging_batteries)
		QDEL_NULL(charging)
	charging_batteries = null
	return ..()

/obj/item/circuitboard/machine/cell_charger_multi
	name = "Multi-Cell Charger (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/cell_charger_multi
	req_components = list(/datum/stock_part/capacitor = 6)
	needs_anchored = FALSE


/datum/design/board/cell_charger_multi
	name = "Machine Design (Multi-Cell Charger Board)"
	desc = "The circuit board for a multi-cell charger."
	id = "multi_cell_charger"
	build_path = /obj/item/circuitboard/machine/cell_charger_multi
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING
