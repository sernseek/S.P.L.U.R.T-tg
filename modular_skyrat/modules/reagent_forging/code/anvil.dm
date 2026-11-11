// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define AUTO_SMITHING_SPEED_PENALTY 8 DECISECONDS

/obj/structure/reagent_anvil
	name = "smithing anvil"
	desc = "Essentially a big block of metal that you can hammer other metals on top of, crucial for anyone working metal by hand."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_structures.dmi'
	icon_state = "anvil_empty"

	anchored = TRUE
	density = TRUE
	drag_slowdown = 1.8 //comically heavy
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 10)

/obj/structure/reagent_anvil/Initialize(mapload)
	. = ..()
	if(!mapload)
		anchored = FALSE
	AddElement(/datum/element/falling_hazard, damage = 40, wound_bonus = 10, hardhat_safety = FALSE, crushes = TRUE)

/obj/structure/reagent_anvil/update_appearance()
	. = ..()
	cut_overlays()
	if(!length(contents))
		return

	var/image/overlayed_item = image(icon = contents[1].icon, icon_state = contents[1].icon_state)
	overlayed_item.transform = matrix(, 0, 0, 0, 0.8, 0)
	add_overlay(overlayed_item)

/obj/structure/reagent_anvil/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.a4681bf1df24b0db", null))
	. += span_notice(LANG("obj.fa147aef83883e87", null))

	if(length(contents))
		var/obj/my_contents = contents[1]
		. += span_notice(LANG("obj.130b7d3822325e9d", list(my_contents)))
		. += span_notice(LANG("obj.41532f9aca5869ef", null))
		if(USER_CAN_SEE_SMITHING_INFO(user) && !isnull(my_contents?.GetComponent(/datum/component/forge_smithable)))
			var/datum/component/forge_smithable/my_component = my_contents.GetComponent(/datum/component/forge_smithable)
			. += span_notice(LANG("obj.9e6faad631d2ae0c", list(round(my_component.get_completion_ratio() * 100))))
			. += span_notice(LANG("obj.3c6ea6d280fde311", list(round(my_component.get_perfect_ratio() * 100))))
		if(HAS_TRAIT(user, TRAIT_KNOW_ADVANCED_SMITHING))
			. += span_notice(LANG("obj.b7254ed4e2b47f83", null))
		else
			. += span_notice(LANG("obj.72546a2273fa6b8b", null))
		. += span_notice(LANG("obj.7f8598d95ac45909", null))
		. += span_notice(LANG("obj.8b19b2f384139a0a", list(contents[1])))
	. += span_notice(LANG("obj.b6a312a70faee9a4", null))

/obj/structure/reagent_anvil/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(user.combat_mode)
		return SECONDARY_ATTACK_CALL_NORMAL

	if(length(contents) > 0)
		var/obj/item/contained_item = contents[1]
		user.put_in_hands(contained_item)
		balloon_alert(user, LANG("obj.a5cc9afccb64ed0b", list(contained_item)))
		update_appearance()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/reagent_anvil/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!can_interact(user) || !user.can_perform_action(src))
		return

	add_fingerprint(user)
	set_anchored(!anchored)
	balloon_alert_to_viewers(anchored ? "secured" : "unsecured")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/reagent_anvil/welder_act(mob/living/user, obj/item/tool)
	if(!tool.tool_start_check(user, amount=2))
		return TRUE
	add_fingerprint(user)

	if(tool.use_tool(src, user, 2 SECONDS, volume=2))
		new /obj/item/sliced_pipe(drop_location())
		user.visible_message( \
			LANG("obj.04dbd13d56fc705c", list(user, src)), \
			span_notice(LANG("obj.9430633b83d852ce", list(src))), \
			span_hear(LANG("obj.1aa82fa3545466eb", null)))

		deconstruct(TRUE)

	return TRUE

/obj/structure/reagent_anvil/atom_deconstruct(disassembled = TRUE)
	var/obj/item/stack/sheet/my_drop = new /obj/item/stack/sheet/mineral/titanium(get_turf(src))
	my_drop.add(9)
	if(length(contents))
		for(var/obj/contained in contents)
			contained.forceMove(get_turf(src))
	return ..()

/obj/structure/reagent_anvil/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE

	if(!isnull(tool.GetComponent(/datum/component/forge_smithable)))
		tool.forceMove(src)
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/structure/reagent_anvil/tong_act(mob/living/user, obj/item/tool)
	var/obj/item/forging/forge_item = tool
	add_fingerprint(user)
	var/obj/obj_anvil_search = locate() in contents
	var/obj/obj_tong_search = locate() in forge_item.contents
	if(obj_anvil_search && !obj_tong_search)
		obj_anvil_search.forceMove(forge_item)
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(!obj_anvil_search && obj_tong_search)
		var/returner = item_interaction(user, obj_tong_search)
		return returner
	return NONE

/obj/structure/reagent_anvil/hammer_act(mob/living/user, obj/item/tool)
	//do we have a hammerable item?
	add_fingerprint(user)
	var/obj/locate_obj = locate() in contents
	if(!isnull(locate_obj))
		var/datum/component/forge_smithable/smith_component = locate_obj.GetComponent(/datum/component/forge_smithable/)
		if(!isnull(smith_component))
			smith_component.anvil_work(user, tool)
			update_appearance()
			return ITEM_INTERACT_SUCCESS
	update_appearance()
	return ITEM_INTERACT_BLOCKING

/obj/structure/reagent_anvil/hammer_act_secondary(mob/living/user, obj/item/tool)
	if(DOING_INTERACTION(user, DOAFTER_SMITHING_ANVIL))
		return

	var/obj/item/my_anvil_item = contents[1]
	var/datum/component/forge_smithable/smith_component = my_anvil_item.GetComponent(/datum/component/forge_smithable)
	if(!isnull(my_anvil_item) && !isnull(smith_component))
		if(!should_stop_autohammering())
			balloon_alert_to_viewers(LANG("obj.6d649c22a856752a", null))
			while(!should_stop_autohammering())
				var/wait_between_swings = COOLDOWN_TIMELEFT(user, striking_cooldown) DECISECONDS
				wait_between_swings += AUTO_SMITHING_SPEED_PENALTY

				if(!do_after(user, wait_between_swings, target = src, interaction_key = DOAFTER_SMITHING_ANVIL))
					balloon_alert_to_viewers(LANG("obj.80efa915cb0ab722", null))
					break
				else
					hammer_act(user, tool)

		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/structure/reagent_anvil/proc/should_stop_autohammering()
	var/obj/item/forging/incomplete/my_incomplete_item = contents[1]
	var/datum/component/forge_smithable/my_forge_component = my_incomplete_item.GetComponent(/datum/component/forge_smithable/)
	if(!isnull(my_forge_component))
		if(my_forge_component.is_finished_smithing())
			return TRUE
		if(COOLDOWN_FINISHED(my_forge_component, heating_remainder))
			return TRUE
		return FALSE
	return TRUE

/obj/structure/reagent_anvil/onZImpact(turf/impacted_turf, levels, message = TRUE)
	var/mob/living/poor_target = locate(/mob/living) in impacted_turf
	if(!poor_target)
		return ..()

	poor_target.apply_damage(60 * levels, forced = TRUE)

	if(istype(poor_target, /mob/living/carbon)) //If this mob is a carbon, break a few of their limbs
		poor_target.take_bodypart_damage(40 * levels, wound_bonus = 5 * levels)
		poor_target.take_bodypart_damage(40 * levels, wound_bonus = 5 * levels)

	poor_target.AddElement(/datum/element/squish, 30 SECONDS)
	poor_target.visible_message(
		span_bolddanger(LANG("obj.ce4a624aefe4b419", list(src, poor_target))),
		span_userdanger(LANG("obj.872dcdba4bdb623d", list(src)))
	)
	poor_target.Paralyze(5 SECONDS)
	poor_target.emote("scream")
	playsound(poor_target, 'sound/effects/magic/clockwork/fellowship_armory.ogg', 50, TRUE)
	add_memory_in_range(poor_target, 7, /datum/memory/witness_vendor_crush, protagonist = poor_target, antognist = src)
	return TRUE

#undef AUTO_SMITHING_SPEED_PENALTY
