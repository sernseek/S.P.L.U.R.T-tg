// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/cell_charger/mega
	name = "megacell charger"
	desc = "It charges big power cells."
	icon_state = "ccharger_mega"
	circuit = /obj/item/circuitboard/machine/megacell_charger
	charge_rate = 0.5 * STANDARD_BATTERY_RATE

/obj/machinery/cell_charger/mega/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stock_parts/power_store/battery) || panel_open)
		return NONE

	if(machine_stat & BROKEN)
		to_chat(user, span_warning(LANG("obj.e2c73115e801b359", list(src))))
		return ITEM_INTERACT_BLOCKING
	if(!anchored)
		to_chat(user, span_warning(LANG("obj.f467682f5bf33467", list(src))))
		return ITEM_INTERACT_BLOCKING
	if(charging)
		to_chat(user, span_warning(LANG("obj.19b677e5df5cb8e0", null)))
		return ITEM_INTERACT_BLOCKING

	var/area/charge_area = get_area(src)
	if(!isarea(charge_area))
		return ITEM_INTERACT_BLOCKING
	if(!charge_area.power_equip) // There's no APC in this area, don't try to cheat power!
		to_chat(user, span_warning(LANG("obj.ebb2a520235ba42f", list(src))))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING

	charging = tool
	user.visible_message(
		span_notice(LANG("obj.c4a3d9201d508013", list(user, src))),
		span_notice(LANG("obj.0e4e6b90adadf964", list(src))),
	)
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/cell_charger/mega/RefreshParts()
	. = ..()
	var/tier_total
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		tier_total += capacitor.tier
	charge_rate = tier_total * (initial(charge_rate) / 3)
