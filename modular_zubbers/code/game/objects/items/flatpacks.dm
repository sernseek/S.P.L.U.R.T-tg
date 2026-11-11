// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/flatpack/export_gate
	name = "bounty cube export gate"
	board = /obj/item/circuitboard/machine/export_gate
	custom_premium_price = PAYCHECK_CREW * 1.5

/obj/item/flatpack/export_gate/Initialize(mapload)
	. = ..()
	var/turf/our_turf = get_turf(src)
	new /obj/item/paper/fluff/export_gate(our_turf)

/obj/item/flatpack/export_gate/multitool_act(mob/living/user, obj/item/tool)
	if(isturf(loc))
		var/turf/location = loc
		if(!locate(/obj/machinery/conveyor) in location)
			balloon_alert(user, LANG("obj.232915e0d24de3d4", null))
			return ITEM_INTERACT_BLOCKING

	return ..()

/obj/item/flatpack/materials_market
	name = "materials import market"
	board = /obj/item/circuitboard/machine/materials_market
	custom_premium_price = PAYCHECK_CREW * 1.5
