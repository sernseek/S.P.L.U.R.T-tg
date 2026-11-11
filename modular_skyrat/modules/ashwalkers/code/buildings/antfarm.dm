// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/structure/antfarm
	name = "ant farm"
	desc = "Though it may look natural, this was not made by ants."
	icon = 'modular_skyrat/modules/ashwalkers/icons/structures.dmi'
	icon_state = "anthill"
	density = TRUE
	anchored = TRUE
	custom_materials = list(/datum/material/sand = SHEET_MATERIAL_AMOUNT * 20)
	/// If the farm is occupied by ants
	var/has_ants = FALSE
	/// the chance for the farm to get ants
	var/ant_chance = 0
	/// the list of ore-y stuff that ants can drag up from deep within their nest
	var/list/ore_list = list(
		/obj/item/stack/ore/iron = 20,
		/obj/item/stack/ore/glass/basalt = 20,
		/obj/item/stack/ore/plasma = 14,
		/obj/item/stack/ore/silver = 8,
		/obj/item/xenoarch/strange_rock = 8,
		/obj/item/stack/stone = 8,
		/obj/item/stack/sheet/mineral/coal = 8,
		/obj/item/stack/ore/titanium = 8,
		/obj/item/stack/ore/uranium = 3,
		/obj/item/stack/ore/gold = 3,
	)
	// The cooldown between each worm "breeding"
	COOLDOWN_DECLARE(ant_timer)

/obj/structure/antfarm/Initialize(mapload)
	. = ..()
	if(!mapload)
		var/turf/src_turf = get_turf(src)
		if(!src_turf.GetComponent(/datum/component/simple_farm))
			src_turf.balloon_alert_to_viewers(LANG("obj.18694f10a5214b78", null))
			return INITIALIZE_HINT_QDEL

		for(var/obj/structure/antfarm/found_farm in range(2, get_turf(src)))
			if(found_farm == src)
				continue

			src_turf.balloon_alert_to_viewers(LANG("obj.9a5e582c2e0dd0cf", null))
			return INITIALIZE_HINT_QDEL

	START_PROCESSING(SSobj, src)
	COOLDOWN_START(src, ant_timer, 30 SECONDS)

/obj/structure/antfarm/Destroy()
	STOP_PROCESSING(SSobj, src)
	new /obj/item/stack/ore/glass/ten(get_turf(src))
	return ..()

/obj/structure/antfarm/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, ant_timer))
		return

	COOLDOWN_START(src, ant_timer, 30 SECONDS)

	if(!has_ants)
		if(prob(ant_chance))
			balloon_alert_to_viewers(LANG("obj.38cb8d43792ec485", null))
			has_ants = TRUE

		return

	var/spawned_ore = pick_weight(ore_list)
	new spawned_ore(get_turf(src))

/obj/structure/antfarm/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.d22d28bbe99edf80", list(has_ants ? "" : "no ")))
	. += span_notice(LANG("obj.89a51ec74aa8a28e", null))

/obj/structure/antfarm/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/food))
		qdel(attacking_item)
		balloon_alert(user, LANG("obj.9bf1051b82bbaedd", null))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		ant_chance++
		if(prob(user.mind.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
			ant_chance++
		return

	if(istype(attacking_item, /obj/item/storage/bag/plants))
		balloon_alert(user, LANG("obj.585ba266c316f44b", null))
		var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		for(var/obj/item/food/selected_food in attacking_item.contents)
			if(!do_after(user, 1 SECONDS * skill_modifier, src))
				return

			qdel(selected_food)
			user.mind?.adjust_experience(/datum/skill/primitive, 5)
			ant_chance++
			if(prob(user.mind.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
				ant_chance++

		return

	return ..()

/obj/item/stack/ore/glass/ten
	amount = 10

/obj/structure/antfarm/natural
	name = "ant farm"
	desc = "A natural ant farm."
