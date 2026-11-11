// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/structure/plant_tank
	name = "plant tank"
	desc = "A small little glass tank that is used to grow plants; this tank promotes the nitrogen and oxygen cycle."
	icon = 'modular_skyrat/modules/ashwalkers/icons/structures.dmi'
	icon_state = "plant_tank_e"
	anchored = FALSE
	density = TRUE
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 4, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)
	///the amount of times the tank can produce-- can be increased through feeding the tank
	var/operation_number = 0

/obj/structure/plant_tank/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/plant_tank/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/plant_tank/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.7119a77581127558", null))
	. += span_notice(LANG("obj.17448eb1b2ed5983", list(operation_number)))
	var/datum/component/simple_farm/find_farm = GetComponent(/datum/component/simple_farm)
	if(!find_farm)
		. += span_notice(LANG("obj.884eae86cd9490ef", null))

/obj/structure/plant_tank/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/food) || istype(attacking_item, /obj/item/stack/worm_fertilizer))
		var/obj/item/stack/stack_item = attacking_item
		if(isstack(stack_item))
			if(!stack_item.use(1))
				return

		else
			qdel(attacking_item)

		balloon_alert(user, LANG("obj.b25cae3550bffe99", list(attacking_item)))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		operation_number += 2
		if(prob(user.mind.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
			operation_number += 2

		return

	if(istype(attacking_item, /obj/item/storage/bag/plants))
		balloon_alert(user, LANG("obj.0126860d0577a5f0", null))
		var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		for(var/obj/item/food/selected_food in attacking_item.contents)
			if(!do_after(user, 1 SECONDS * skill_modifier, src))
				return

			qdel(selected_food)
			operation_number += 2
			if(prob(user.mind.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
				operation_number += 2

		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		return

	if(istype(attacking_item, /obj/item/stack/ore/glass))
		var/datum/component/simple_farm/find_farm = GetComponent(/datum/component/simple_farm)
		if(find_farm)
			balloon_alert(user, LANG("obj.47cd9db73bd58933", list(attacking_item)))
			return

		var/obj/item/stack/attacking_stack = attacking_item
		if(!attacking_stack.use(5))
			balloon_alert(user, LANG("obj.acbb2297f142a2b5", null))
			return

		AddComponent(/datum/component/simple_farm, TRUE, TRUE, list(0, 12))
		icon_state = "plant_tank_f"
		return

	return ..()

/obj/structure/plant_tank/process(seconds_per_tick)
	if(operation_number <= 0) //we require "fuel" to actually produce stuff
		return

	if(!locate(/obj/structure/simple_farm) in get_turf(src)) //we require a plant to process the "fuel"
		return

	operation_number--

	var/turf/open/src_turf = get_turf(src)
	if(!isopenturf(src_turf) || isspaceturf(src_turf) || src_turf.planetary_atmos) //must be open turf, can't be space turf, and can't be a turf that regenerates its atmos
		return

	var/datum/gas_mixture/src_mixture = src_turf.return_air()

	src_mixture.assert_gases(/datum/gas/carbon_dioxide, /datum/gas/oxygen, /datum/gas/nitrogen)

	var/proportion = src_mixture.moles[/datum/gas/carbon_dioxide]
	if(proportion) //if there is carbon dioxide in the air, lets turn it into oxygen
		src_mixture.moles[/datum/gas/carbon_dioxide] -= proportion
		src_mixture.moles[/datum/gas/oxygen] += proportion

	src_mixture.moles[/datum/gas/nitrogen] += MOLES_CELLSTANDARD //the nitrogen cycle-- plants (and bacteria) participate in the nitrogen cycle

/obj/structure/plant_tank/wrench_act(mob/living/user, obj/item/tool)
	balloon_alert(user, LANG("obj.e8caa39b6b91e64c", list(anchored ? "un" : "")))
	tool.play_tool_sound(src, 50)
	if(!tool.use_tool(src, user, 2 SECONDS))
		return TRUE

	anchored = !anchored
	balloon_alert(user, LANG("obj.1e8c7ea22ad920d6", list(anchored ? "" : "un")))
	return TRUE

/obj/structure/plant_tank/screwdriver_act(mob/living/user, obj/item/tool)
	balloon_alert(user, LANG("obj.5a199e01223ef916", null))
	tool.play_tool_sound(src, 50)
	if(!tool.use_tool(src, user, 2 SECONDS))
		return TRUE

	deconstruct()
	return TRUE

/obj/structure/plant_tank/atom_deconstruct(disassembled)
	var/target_turf = get_turf(src)
	for(var/loop in 1 to 4)
		new /obj/item/stack/sheet/glass(target_turf)
		new /obj/item/stack/rods(target_turf)
	new /obj/item/forging/complete/plate(target_turf)
	return ..()

/datum/crafting_recipe/plant_tank
	name = "Plant Tank"
	result = /obj/structure/plant_tank
	reqs = list(
		/obj/item/forging/complete/plate = 1,
		/obj/item/stack/sheet/glass = 4,
		/obj/item/stack/rods = 4,
	)
	category = CAT_STRUCTURE
