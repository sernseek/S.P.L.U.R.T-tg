// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// The baseline time to take for doing actions with the forge, like heating glass, setting ceramics, etc.
#define BASELINE_ACTION_TIME (4 SECONDS)

/// The basline for how long an item such as molten glass will be kept workable after heating
#define BASELINE_HEATING_DURATION (25 SECONDS)

/// The amount the forge's temperature will change per process
#define FORGE_DEFAULT_TEMPERATURE_CHANGE 5
/// The maximum temperature the forge can reach
#define MAX_FORGE_TEMP 100
/// The minimum temperature for using the forge
#define MIN_FORGE_TEMP 50
/// The duration that objects heated in the forge are heated for
#define FORGE_HEATING_DURATION (1 MINUTES)

/// Defines for different levels of the forge, ranging from no level (you play like a noob) to legendary
#define FORGE_LEVEL_YOU_PLAY_LIKE_A_NOOB 1
#define FORGE_LEVEL_NOVICE 2
#define FORGE_LEVEL_APPRENTICE 3
#define FORGE_LEVEL_JOURNEYMAN 4
#define FORGE_LEVEL_EXPERT 5
#define FORGE_LEVEL_MASTER 6
#define FORGE_LEVEL_LEGENDARY 7

/// The maximum amount of temperature loss decrease that upgrades can give the forge
#define MAX_TEMPERATURE_LOSS_DECREASE 5

/// The chance per piece of wood added that charcoal will form later
#define CHARCOAL_CHANCE 45

/// Stats for the expelled gas from running the forge
#define FORGE_FUMES_HEAT FIRE_MINIMUM_TEMPERATURE_TO_EXIST
#define FORGE_FUMES_VOLUME 1

/// The minimum units of a reagent rerquired to imbue it into a weapon
#define MINIMUM_IMBUING_REAGENT_AMOUNT 100

/// Defines for the different levels of smoke coming out of the forge, (good, neutral, bad) are all used for baking, (not cooking) is used for when there is no tray in the forge
#define SMOKE_STATE_NONE 0
#define SMOKE_STATE_GOOD 1
#define SMOKE_STATE_NEUTRAL 2
#define SMOKE_STATE_BAD 3
#define SMOKE_STATE_NOT_COOKING 4

/obj/structure/reagent_forge
	name = "forge"
	desc = "A structure built out of bricks, for heating up metal, or glass, or ceramic, or food, or anything really."
	icon = 'modular_skyrat/modules/reagent_forging/icons/obj/forge_structures.dmi'
	icon_state = "forge_inactive"

	anchored = TRUE
	density = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10)

	/// What the current internal temperature of the forge is
	var/forge_temperature = 0
	/// What temperature the forge is moving towards
	var/target_temperature = 0
	/// What the minimum target temperature is, used for upgrades
	var/minimum_target_temperature = 0
	/// What is the current reduction for temperature decrease
	var/temperature_loss_reduction = 0
	/// How many seconds of weak fuel (wood) does the forge have left
	var/forge_fuel_weak = 0
	/// How many seconds of strong fuel (coal) does the forge have left
	var/forge_fuel_strong = 0
	/// If the forge is capable of reagent forging or not
	var/reagent_forging = FALSE
	/// Cooldown time for processing on the forge
	COOLDOWN_DECLARE(forging_cooldown)
	/// The current 'level' of the forge, how upgraded is it from zero to three
	var/forge_level = FORGE_LEVEL_YOU_PLAY_LIKE_A_NOOB
	/// What smoke particles should be coming out of the forge
	var/smoke_state = SMOKE_STATE_NONE
	/// Tracks any oven tray placed inside of the forge
	var/obj/item/plate/oven_tray/used_tray
	/// The list of possible things to make with materials used on the forge
	var/static/list/choice_list = list(
		"Chain" = /obj/item/forging/incomplete/chain,
		"Plate" = /obj/item/forging/incomplete/plate,
		"Rapier" = /obj/item/forging/incomplete/rapier,
		"Sword" = /obj/item/forging/incomplete/sword,
		"Katana" = /obj/item/forging/incomplete/katana,
		"Dagger" = /obj/item/forging/incomplete/dagger,
		"Spear" = /obj/item/forging/incomplete/spear,
		"Hammer" = /obj/item/forging/incomplete/hammer,
		"Axe" = /obj/item/forging/incomplete/axe,
		"Arrowhead" = /obj/item/forging/incomplete/arrowhead,
		"Revolver Frame" = /obj/item/forging/incomplete/revolver_frame,
		"Revolver Cylinder" = /obj/item/forging/incomplete/revolver_cylinder,
		"Staff" = /obj/item/forging/incomplete/staff,
		"Pickaxe" = /obj/item/forging/incomplete/pickaxe,
		"Shovel" = /obj/item/forging/incomplete/shovel,
		"Baseball Bat" = /obj/item/forging/incomplete/baseball_bat,
		"Rail Nail" = /obj/item/forging/incomplete/rail_nail,
		"Rail Cart" = /obj/item/forging/incomplete/rail_cart,
	)
	/// List of possible choices for the selection radial
	var/list/radial_choice_list = list()
	/// Filters the radial choice list by required skill
	var/list/choice_list_skill_filter = list(
		"Revolver Frame" = /datum/skill/smithing,
		"Revolver Cylinder" = /datum/skill/smithing,
	)
	/// Filters the radial choice list by required level in its skill; true means corresponding element requires it
	var/list/choice_list_skill_level_filter = list(
		"Revolver Frame" = 7,
		"Revolver Cylinder" = 7,
	)
	/// Filters the radial choice list by if it requires the smithing skillchip; true means corresponding element requires it
	var/list/choice_list_trait_filter = list(
		"Revolver Frame" = list(TRAIT_KNOW_GUNSMITHING),
		"Revolver Cylinder" = list(TRAIT_KNOW_GUNSMITHING),
	)
	/// Descriptions of the forging items in hint bubbles for the radial menu
	var/list/radial_choice_hinttext = list()

/obj/structure/reagent_forge/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.34c6c87bfaa6960b", null))
	. += span_notice(LANG("obj.738bc856dd14d31a", null))
	if(used_tray)
		. += span_notice(LANG("obj.3563f40bf009591d", list(used_tray)))
	else
		. += span_notice(LANG("obj.7928ebc4b7e5acf7", null))

	if(forge_level < FORGE_LEVEL_LEGENDARY)
		. += span_notice(LANG("obj.52e087ef680ea35c", list(src)))

	switch(forge_level)
		if(FORGE_LEVEL_YOU_PLAY_LIKE_A_NOOB)
			. += span_notice(LANG("obj.50292b069527e22e", null))

		if(FORGE_LEVEL_NOVICE)
			. += span_notice(LANG("obj.b72417bda1cec799", null))

		if(FORGE_LEVEL_APPRENTICE)
			. += span_notice(LANG("obj.919a7005fa49639b", null))

		if(FORGE_LEVEL_JOURNEYMAN)
			. += span_notice(LANG("obj.d88ec7b57ab8baff", null))

		if(FORGE_LEVEL_EXPERT)
			. += span_notice(LANG("obj.becda68dffd940c8", null))

		if(FORGE_LEVEL_MASTER)
			. += span_notice(LANG("obj.eebfe21f982ab86e", null))

		if(FORGE_LEVEL_LEGENDARY)
			. += span_hierophant(LANG("obj.1674e5f9ba51373c", null)) // Legendary skills give you the greatest gift of all, cool text

	switch(temperature_loss_reduction)
		if(0)
			. += span_notice(LANG("obj.2a821d816def17e1", list(src)))
		if(1)
			. += span_notice(LANG("obj.84124d1e108ac4ba", list(src)))
		if(2)
			. += span_notice(LANG("obj.e40efdc3aec3963a", list(src)))
		if(3)
			. += span_notice(LANG("obj.38a9bec5640fde83", list(src)))
		if(4)
			. += span_notice(LANG("obj.cfa9456120b901b6", list(src)))
		if(5)
			. += span_notice(LANG("obj.438b6152c0a5bcf2", list(src)))

	. += span_notice(LANG("obj.b24133749d788786", list(src, forge_temperature, target_temperature)))

	if(reagent_forging)
		. += span_warning(LANG("obj.139ef30d28a90056", list(src)))

	return .

/obj/structure/reagent_forge/Initialize(mapload)
	. = ..()
	if(!mapload)
		anchored = FALSE
	START_PROCESSING(SSobj, src)
	populate_radial_choice_list()
	update_appearance()
	upgrade_forge(forced = TRUE)

/// Fills out the radial choice list with everything in the choice_list's contents
/obj/structure/reagent_forge/proc/populate_radial_choice_list()
	if(!length(choice_list))
		return

	if(length(radial_choice_list))
		return

	var/obj/resulting_item
	var/datum/radial_menu_choice/option
	for(var/forge_option in choice_list)
		resulting_item = choice_list[forge_option]
		option = new
		option.image = image(icon = initial(resulting_item.icon), icon_state = initial(resulting_item.icon_state))
		option.name = initial(resulting_item.name)
		option.info = initial(resulting_item.desc)
		radial_choice_list[forge_option] = option

///Exclusively gives all the radial choices that the user can know how to make.
/obj/structure/reagent_forge/proc/get_filtered_radial_choices(mob/living/user)
	var/returner = list()
	if(isnull(user?.mind))
		return returner

	for(var/key,value in radial_choice_list)
		if(user_can_craft(user, key))
			returner[key] = value

	return returner

/obj/structure/reagent_forge/proc/user_can_craft(mob/living/user, key)
	if(isnull(user?.mind))
		return FALSE
	if(!isnull(choice_list_skill_filter[key]) && user.mind.get_skill_level(choice_list_skill_filter[key]) < choice_list_skill_level_filter[key])
		return FALSE
	if(!isnull(choice_list_trait_filter[key]))
		for(var/my_trait in choice_list_trait_filter[key])
			if (!HAS_TRAIT(user, my_trait))
				return FALSE
	return TRUE

/obj/structure/reagent_forge/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(particles)
	if(used_tray)
		QDEL_NULL(used_tray)
	. = ..()

/obj/structure/reagent_forge/update_appearance(updates)
	. = ..()
	cut_overlays()

	if(reagent_forging) // If we can do reagent forging, give the forge the gold trim
		var/image/gold_overlay = image(icon = icon, icon_state = "forge_masterwork_trim")
		add_overlay(gold_overlay)

	if(used_tray) // If we have a tray inside, check if the forge is on or not, then give the corresponding tray overlay
		var/image/tray_overlay = image(icon = icon, icon_state = "forge_tray_[check_fuel(0) ? "active" : "inactive"]")
		add_overlay(tray_overlay)

/// Checks if the forge has fuel, if so what type. If it has either type of fuel, returns TRUE, otherwise returns FALSE. just_checking will check if there is fuel without taking actions
/obj/structure/reagent_forge/proc/check_fuel(time_to_reduce_by = 0)
	if(forge_fuel_strong > 0) // Check for strong fuel (coal) first, as it has more power over weaker fuels

		forge_fuel_strong -= time_to_reduce_by
		target_temperature = 100
		return TRUE

	if(forge_fuel_weak > 0) // If there's no strong fuel, maybe we have weak fuel (wood)

		forge_fuel_weak -= time_to_reduce_by
		target_temperature = 50
		return TRUE

	target_temperature = minimum_target_temperature // If the forge has no fuel, then we should lowly return to the minimum lowest temp we can do
	return FALSE

/// Gives the forge the ability to imbue reagents into things
/obj/structure/reagent_forge/proc/create_reagent_forge()
	if(reagent_forging) // If the forge can already do reagent forging, then we can skip the rest of this
		return
	reagent_forging = TRUE
	update_appearance()


/// Adjust the temperature to head towards the target temperature, changing icon and creating light if the temperature is rising
/obj/structure/reagent_forge/proc/check_temp(seconds_per_tick)
	if(forge_temperature > target_temperature) // Being above the target temperature will cause the forge to cool down
		forge_temperature -= (FORGE_DEFAULT_TEMPERATURE_CHANGE - temperature_loss_reduction) * seconds_per_tick
		return

	else if((forge_temperature < target_temperature) && (forge_fuel_weak || forge_fuel_strong)) // Being below the target temp, and having fuel, will cause the temp to rise
		forge_temperature += FORGE_DEFAULT_TEMPERATURE_CHANGE * seconds_per_tick
		return


/// Spawns a piece of coal at the forge and renames it to charcoal
/obj/structure/reagent_forge/proc/spawn_coal()
	var/obj/item/stack/sheet/mineral/coal/spawn_coal = new(get_turf(src))
	spawn_coal.name = "charcoal"

/obj/structure/reagent_forge/process(seconds_per_tick)
	/*
	if(!COOLDOWN_FINISHED(src, forging_cooldown))
		return

	COOLDOWN_START(src, forging_cooldown, 5 SECONDS) */
	check_fuel(seconds_per_tick)
	check_temp(seconds_per_tick)
	try_expel_gas(seconds_per_tick)

	if(!used_tray && check_fuel())
		set_smoke_state(SMOKE_STATE_NOT_COOKING) // If there is no tray but we have fuel, use the not cooking smoke state
		return

	if(!check_fuel()) // If there's no fuel, remove it all
		set_smoke_state(SMOKE_STATE_NONE)
		return

	handle_baking_things(seconds_per_tick)

/obj/structure/reagent_forge/proc/try_expel_gas(seconds_per_tick)
	if(check_fuel())
		atmos_spawn_air("[GAS_CO2]=[FORGE_FUMES_VOLUME * seconds_per_tick];[TURF_TEMPERATURE(FORGE_FUMES_HEAT)]")

/// Sends signals to bake and items on the used tray, setting the smoke state of the forge according to the most cooked item in it
/obj/structure/reagent_forge/proc/handle_baking_things(seconds_per_tick)
	if(forge_temperature < MIN_FORGE_TEMP) // If we are below minimum forge temp, don't continue on to cooking
		return

	/// The worst off item being baked in our forge right now, to ensure people know when gordon ramsay is gonna be upset at them
	var/worst_cooked_food_state = 0
	for(var/obj/item/baked_item as anything in used_tray.contents)

		var/signal_result = SEND_SIGNAL(baked_item, COMSIG_ITEM_OVEN_PROCESS, src, seconds_per_tick)

		if(signal_result & COMPONENT_HANDLED_BAKING)
			if(signal_result & COMPONENT_BAKING_GOOD_RESULT && worst_cooked_food_state < SMOKE_STATE_GOOD)
				worst_cooked_food_state = SMOKE_STATE_GOOD
			else if(signal_result & COMPONENT_BAKING_BAD_RESULT && worst_cooked_food_state < SMOKE_STATE_NEUTRAL)
				worst_cooked_food_state = SMOKE_STATE_NEUTRAL
			continue

		worst_cooked_food_state = SMOKE_STATE_BAD
		baked_item.fire_act(1000) // Overcooked food really does burn, hot hot hot!

		if(SPT_PROB(10, seconds_per_tick))
			visible_message(span_danger(LANG("obj.6d67c4b61a4de348", list(src)))) // Give indication that something is burning in the oven
	set_smoke_state(worst_cooked_food_state)

/// Sets the type of particles that the forge should be generating
/obj/structure/reagent_forge/proc/set_smoke_state(new_state)
	if(new_state == smoke_state)
		return

	smoke_state = new_state

	QDEL_NULL(particles)

	switch(smoke_state)
		if(SMOKE_STATE_NONE)
			icon_state = "forge_inactive"
			set_light(0, 0) // If we aren't heating up and thus not on fire, turn the fire light off
			return

		if(SMOKE_STATE_BAD)
			particles = new /particles/smoke()
			particles.position = list(6, 4, 0)

		if(SMOKE_STATE_NEUTRAL)
			particles = new /particles/smoke/steam()
			particles.position = list(6, 4, 0)

		if(SMOKE_STATE_GOOD)
			particles = new /particles/smoke/steam/mild()
			particles.position = list(6, 4, 0)

		if(SMOKE_STATE_NOT_COOKING)
			particles = new /particles/smoke/mild()
			particles.position = list(6, 4, 0)

	icon_state = "forge_active"
	set_light(3, 1, LIGHT_COLOR_FIRE)

/obj/structure/reagent_forge/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(used_tray)
		remove_tray_from_forge(user)
		return

	upgrade_forge(user)

/obj/structure/reagent_forge/attack_robot(mob/living/user)
	. = ..()
	upgrade_forge(user)

/obj/structure/reagent_forge/proc/upgrade_forge(mob/living/user, forced = FALSE)
	var/level_to_upgrade_to

	if(forced || !user) // This is to make sure the ready subtype of forge still works
		level_to_upgrade_to = forge_level
	else
		level_to_upgrade_to = user.mind.get_skill_level(/datum/skill/smithing)

	if((forge_level == level_to_upgrade_to) && !forced)
		to_chat(user, span_notice(LANG("obj.b7ba98a8983a4483", list(src))))
		return

	switch(level_to_upgrade_to) // Remember to carry things over from past levels in case someone skips levels in upgrading
		if(SKILL_LEVEL_NONE)
			if(!forced)
				to_chat(user, span_notice(LANG("obj.555ff34a60cc07f9", list(src))))
			return

		if(SKILL_LEVEL_NOVICE)
			if(!forced)
				to_chat(user, span_notice(LANG("obj.d588bd106157989a", null)))
			temperature_loss_reduction = 1
			forge_level = FORGE_LEVEL_NOVICE

		if(SKILL_LEVEL_APPRENTICE)
			if(!forced)
				to_chat(user, span_notice(LANG("obj.f48485ab5b9be40d", list(src))))
			temperature_loss_reduction = 2
			forge_level = FORGE_LEVEL_APPRENTICE

		if(SKILL_LEVEL_JOURNEYMAN)
			if(!forced)
				to_chat(user, span_notice(LANG("obj.f238749f87091c02", null)))
			minimum_target_temperature = 25 // Will allow quicker reheating from having no fuel
			temperature_loss_reduction = 3
			forge_level = FORGE_LEVEL_JOURNEYMAN

		if(SKILL_LEVEL_EXPERT)
			if(!forced)
				to_chat(user, span_notice(LANG("obj.3a5c9a07f572a30a", list(src))))
			temperature_loss_reduction = 4
			minimum_target_temperature = 25
			forge_level = FORGE_LEVEL_EXPERT

		if(SKILL_LEVEL_MASTER)
			if(!forced)
				to_chat(user, span_notice(LANG("obj.bce158add92bb400", list(src))))
			temperature_loss_reduction = MAX_TEMPERATURE_LOSS_DECREASE
			minimum_target_temperature = 25
			forge_level = FORGE_LEVEL_MASTER

		if(SKILL_LEVEL_LEGENDARY)
			if(!forced)
				to_chat(user, span_notice(LANG("obj.f7c6d9ad9a88840f", null)))
			create_reagent_forge()
			temperature_loss_reduction = MAX_TEMPERATURE_LOSS_DECREASE
			minimum_target_temperature = 25 // This won't matter except in a few cases here, but we still need to cover those few cases
			forge_level = FORGE_LEVEL_LEGENDARY

	playsound(src, 'sound/items/weapons/parry.ogg', 50, TRUE) // Play a feedback sound to really let players know we just did an upgrade

//this will allow click dragging certain items
/obj/structure/reagent_forge/mouse_drop_receive(atom/attacking_item, mob/user, params)
	. = ..()
	if(!isliving(user))
		return

	if(!isobj(attacking_item))
		return

	if(istype(attacking_item, /obj/item/stack/sheet/mineral/wood)) // Wood is a weak fuel, and will only get the forge up to 50 temperature
		refuel(attacking_item, user)
		return

	if(istype(attacking_item, /obj/item/stack/sheet/mineral/coal)) // Coal is a strong fuel that doesn't need bellows to heat up properly
		refuel(attacking_item, user, TRUE)
		return

	if(istype(attacking_item, /obj/item/stack/ore))
		smelt_ore(attacking_item, user)
		return

	if(attacking_item.GetComponent(/datum/component/reagent_imbued/weapon))
		handle_reagent_imbue(attacking_item, user)
		return

/obj/structure/reagent_forge/attackby(obj/item/attacking_item, mob/living/user, params)
	if(!used_tray && istype(attacking_item, /obj/item/plate/oven_tray))
		add_tray_to_forge(user, attacking_item)
		return TRUE

	if(used_tray)
		balloon_alert(user, LANG("obj.b155334402850025", list(used_tray)))
		return TRUE

	if(istype(attacking_item, /obj/item/stack/sheet/mineral/wood)) // Wood is a weak fuel, and will only get the forge up to 50 temperature
		refuel(attacking_item, user)
		return TRUE

	if(istype(attacking_item, /obj/item/stack/sheet/mineral/coal)) // Coal is a strong fuel that doesn't need bellows to heat up properly
		refuel(attacking_item, user, TRUE)
		return TRUE

	if(istype(attacking_item, /obj/item/stack/ore))
		smelt_ore(attacking_item, user)
		return TRUE

	if(attacking_item.GetComponent(/datum/component/reagent_imbued) && attacking_item?.reagents?.total_volume > 1)
		handle_reagent_imbue(attacking_item, user)
		return TRUE

	if(attacking_item.GetComponent(/datum/component/forge_smithable))
		var/datum/component/forge_smithable/mycomponent = attacking_item.GetComponent(/datum/component/forge_smithable)
		mycomponent.heat_for_smithing(FORGE_HEATING_DURATION)
		balloon_alert(user, LANG("obj.760bff133c97f5ea", list(attacking_item)))
		return TRUE

	if(istype(attacking_item, /obj/item/ceramic))
		handle_ceramics(attacking_item, user)
		return TRUE

	if(istype(attacking_item, /obj/item/stack/sheet/glass))
		handle_glass_sheet_melting(attacking_item, user)
		return TRUE

	if(istype(attacking_item, /obj/item/glassblowing/metal_cup))
		handle_metal_cup_melting(attacking_item, user)
		return TRUE

	if(istype(attacking_item, /obj/item/stack))
		stack_item_to_forgeable(user, attacking_item, burn_hand = TRUE)
		return TRUE
	return ..()

/// Take the given tray and place it inside the forge, updating everything relevant to that
/obj/structure/reagent_forge/proc/add_tray_to_forge(mob/living/user, obj/item/plate/oven_tray/tray)
	if(used_tray) // This shouldn't be able to happen but just to be safe
		balloon_alert_to_viewers(LANG("obj.666f207cebecbdb8", null))
		return

	if(!user.transferItemToLoc(tray, src, silent = FALSE))
		return

	// need to send the right signal for each item in the tray
	for(var/obj/item/baked_item in tray.contents)
		SEND_SIGNAL(baked_item, COMSIG_ITEM_OVEN_PLACED_IN, src, user)

	balloon_alert_to_viewers(LANG("obj.5c2ac820dda68a88", list(tray, src)))
	used_tray = tray
	update_appearance()

/// Take the used_tray and spit it out, updating everything relevant to that
/obj/structure/reagent_forge/proc/remove_tray_from_forge(mob/living/carbon/user)
	if(!used_tray)
		if(user)
			balloon_alert_to_viewers(LANG("obj.22bb5c6a0a2f82eb", null))
		return

	if(user)
		user.put_in_hands(used_tray)
		balloon_alert_to_viewers(LANG("obj.c6b4aa687c2eb2c1", list(used_tray)))
	else
		used_tray.forceMove(get_turf(src))
	used_tray = null

/// Adds to either the strong or weak fuel timers from the given stack
/obj/structure/reagent_forge/proc/refuel(obj/item/stack/refueling_stack, mob/living/user, is_strong_fuel = FALSE)

	if(is_strong_fuel)
		if(forge_fuel_strong >= 5 MINUTES)
			balloon_alert(user, LANG("obj.76e32f4fdf5ade4c", list(src)))
			return
	if(forge_fuel_weak >= 5 MINUTES)
		balloon_alert(user, LANG("obj.84df715afa6eff57", list(src)))
		return

	var/obj/item/stack/sheet/stack_sheet = refueling_stack
	if(!stack_sheet.use(1))
		balloon_alert(user, LANG("obj.ee38f429ab6c8597", null))
		return

	if(is_strong_fuel)
		forge_fuel_strong += 5 MINUTES
	else
		forge_fuel_weak += 5 MINUTES
	balloon_alert(user, LANG("obj.c537012baac25866", list(src)))

	if(prob(CHARCOAL_CHANCE) && !is_strong_fuel)
		to_chat(user, span_notice(LANG("obj.c19ef717c7f9aa24", list(src))))
		addtimer(CALLBACK(src, PROC_REF(spawn_coal)), 1 MINUTES)

/// Takes given ore and smelts it, possibly producing extra sheets if upgraded
/obj/structure/reagent_forge/proc/smelt_ore(obj/item/stack/ore/ore_item, mob/living/user)
	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return
	if(forge_temperature < MIN_FORGE_TEMP)
		balloon_alert(user, LANG("obj.2f50735ea303ecaa", null))
		return

	var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER)

	if(!ore_item.refined_type)
		balloon_alert(user, LANG("obj.502e2301f2e81257", list(ore_item)))
		return

	balloon_alert_to_viewers(LANG("obj.35f17b710108676a", null))

	if(!do_after(user, skill_modifier * 3 SECONDS, target = src, interaction_key = DOAFTER_SMITHING_FORGE))
		balloon_alert(user, LANG("obj.a3e1343f9a93c641", list(ore_item)))
		return

	var/src_turf = get_turf(src)
	var/spawning_item = ore_item.refined_type
	var/ore_to_sheet_amount = ore_item.amount

	for(var/spawn_ore in 1 to ore_to_sheet_amount)
		new spawning_item(src_turf)

	qdel(ore_item)
	return

/// Handles reagent imbuing
/obj/structure/reagent_forge/proc/handle_reagent_imbue(obj/attacking_item, mob/living/user)
	if(!USER_CAN_REAGENT_IMBUE(user))
		to_chat(user, span_danger(LANG("obj.72716b357fb748ce", null)))
		return

	if(attacking_item?.reagents?.total_volume < 1)
		to_chat(user, span_danger(LANG("obj.35e67440d417d1e0", null)))
		return

	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return

	var/datum/component/reagent_imbued/weapon_component = attacking_item.GetComponent(/datum/component/reagent_imbued)
	if(!weapon_component)
		balloon_alert(user, LANG("obj.998173aaec55fd87", list(attacking_item)))
		return

	balloon_alert_to_viewers(LANG("obj.d7ed8584e526b9e3", null))

	if(!do_after(user, 10 SECONDS, target = src, interaction_key = DOAFTER_SMITHING_FORGE))
		balloon_alert(user, LANG("obj.9ea682733bbd731a", null))
		return

	if(USER_CAN_REAGENT_IMBUE(user))
		weapon_component.set_reagent_imbue(attacking_item.reagents, clear_source_reagents = TRUE)

	balloon_alert_to_viewers(LANG("obj.c808bc394cb3cfc9", list(attacking_item)))
	playsound(src, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
	return TRUE

/// Sets ceramic items from their unusable state into their finished form
/obj/structure/reagent_forge/proc/handle_ceramics(obj/attacking_item, mob/living/user)

	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return
	if(forge_temperature < MIN_FORGE_TEMP)
		balloon_alert(user, LANG("obj.2f50735ea303ecaa", null))
		return

	var/obj/item/ceramic/ceramic_item = attacking_item
	var/ceramic_speed = user.mind.get_skill_modifier(/datum/skill/production, SKILL_SPEED_MODIFIER) * BASELINE_ACTION_TIME

	if(!ceramic_item.forge_item)
		balloon_alert(user, LANG("obj.5857f7522bf1cade", list(ceramic_item)))
		return

	balloon_alert_to_viewers(LANG("obj.9c64b67dcff8bbfa", list(ceramic_item)))

	if(!do_after(user, ceramic_speed, target = src, interaction_key = DOAFTER_SMITHING_FORGE))
		balloon_alert(user, LANG("obj.c51bbc0464db5aff", list(ceramic_item)))
		return

	balloon_alert(user, LANG("obj.e70febeb40aabf13", list(ceramic_item)))
	var/obj/item/ceramic/spawned_ceramic = new ceramic_item.forge_item(get_turf(src))
	user.mind?.adjust_experience(/datum/skill/production, 50)
	spawned_ceramic.color = ceramic_item.color
	qdel(ceramic_item)

/// Handles the creation of molten glass from glass sheets
/obj/structure/reagent_forge/proc/handle_glass_sheet_melting(obj/attacking_item, mob/living/user)
	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return
	if(forge_temperature < MIN_FORGE_TEMP)
		balloon_alert(user, LANG("obj.2f50735ea303ecaa", null))
		return

	var/obj/item/stack/sheet/glass/glass_item = attacking_item
	var/glassblowing_speed = user.mind.get_skill_modifier(/datum/skill/production, SKILL_SPEED_MODIFIER) * BASELINE_ACTION_TIME
	var/glassblowing_amount = BASELINE_HEATING_DURATION / user.mind.get_skill_modifier(/datum/skill/production, SKILL_SPEED_MODIFIER)

	balloon_alert_to_viewers(LANG("obj.0dbdb45629f922a6", null))

	if(!do_after(user, glassblowing_speed, target = src, interaction_key = DOAFTER_SMITHING_FORGE) || !glass_item.use(1))
		balloon_alert(user, LANG("obj.34c2f70deab9e0ab", list(glass_item)))
		return

	var/obj/item/glassblowing/molten_glass/spawned_glass = new /obj/item/glassblowing/molten_glass(get_turf(src))
	user.mind?.adjust_experience(/datum/skill/production, 10)
	COOLDOWN_START(spawned_glass, remaining_heat, glassblowing_amount)
	spawned_glass.total_time = glassblowing_amount

/// Handles creating molten glass from a metal cup filled with sand
/obj/structure/reagent_forge/proc/handle_metal_cup_melting(obj/attacking_item, mob/living/user)
	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return
	if(forge_temperature < MIN_FORGE_TEMP)
		balloon_alert(user, LANG("obj.2f50735ea303ecaa", null))
		return

	var/obj/item/glassblowing/metal_cup/metal_item = attacking_item
	var/glassblowing_speed = user.mind.get_skill_modifier(/datum/skill/production, SKILL_SPEED_MODIFIER) * BASELINE_ACTION_TIME
	var/glassblowing_amount = BASELINE_HEATING_DURATION / user.mind.get_skill_modifier(/datum/skill/production, SKILL_SPEED_MODIFIER)

	if(!metal_item.has_sand)
		balloon_alert(user, LANG("obj.4597fbf74af4fb4c", list(metal_item)))
		return

	balloon_alert_to_viewers(LANG("obj.0dbdb45629f922a6", null))

	if(!do_after(user, glassblowing_speed, target = src, interaction_key = DOAFTER_SMITHING_FORGE))
		balloon_alert(user, LANG("obj.34c2f70deab9e0ab", list(metal_item)))
		return

	metal_item.has_sand = FALSE
	metal_item.icon_state = "metal_cup_empty" // This should be handled a better way but presently this is how it works
	var/obj/item/glassblowing/molten_glass/spawned_glass = new /obj/item/glassblowing/molten_glass(get_turf(src))
	user.mind?.adjust_experience(/datum/skill/production, 10)
	COOLDOWN_START(spawned_glass, remaining_heat, glassblowing_amount)
	spawned_glass.total_time = glassblowing_amount

/obj/structure/reagent_forge/billow_act(mob/living/user, obj/item/tool)
	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return

	var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER)
	var/obj/item/forging/forge_item = tool

	if(!forge_fuel_strong && !forge_fuel_weak)
		balloon_alert(user, LANG("obj.689211b8c6beadcc", list(src)))
		return ITEM_INTERACT_SUCCESS

	if(forge_temperature >= MAX_FORGE_TEMP)
		balloon_alert(user, LANG("obj.24d3a91137a4ad95", list(src)))
		return ITEM_INTERACT_SUCCESS

	balloon_alert_to_viewers(LANG("obj.d7981a432150c31b", null))

	while(forge_temperature < 91)
		if(!do_after(user, skill_modifier * forge_item.toolspeed * 15 DECISECONDS, target = src, interaction_key = DOAFTER_SMITHING_FORGE))
			balloon_alert_to_viewers(LANG("obj.5db316f513cb6804", null))
			return ITEM_INTERACT_SUCCESS

		forge_temperature += 10

	balloon_alert(user, LANG("obj.7c734f2d88c77ddf", list(src)))
	return ITEM_INTERACT_SUCCESS

/obj/structure/reagent_forge/tong_act(mob/living/user, obj/item/tool)
	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return
	var/obj/item/tongs_contents = locate(/obj/item/) in tool.contents

	if(forge_temperature < MIN_FORGE_TEMP)
		balloon_alert(user, LANG("obj.2f50735ea303ecaa", null))
		return ITEM_INTERACT_BLOCKING

	// Here we check the item used on us (tongs) for an incomplete forge item of some kind to heat
	var/datum/component/forge_smithable/smithable = tongs_contents?.GetComponent(/datum/component/forge_smithable)
	if(!isnull(smithable))
		smithable.heat_for_smithing(FORGE_HEATING_DURATION)
		balloon_alert(user, LANG("obj.760bff133c97f5ea", list(tongs_contents)))
		return ITEM_INTERACT_SUCCESS

	// Here we check the item used on us (tongs) for a stack of some kind to create an object from
	var/obj/item/stack/search_stack = locate(/obj/item/stack) in tool.contents
	if(search_stack)
		return stack_item_to_forgeable(user, search_stack, tool)

	return ITEM_INTERACT_SUCCESS

/obj/structure/reagent_forge/proc/stack_item_to_forgeable(mob/living/user, obj/item/stack/search_stack, obj/item/tool = null, burn_hand = FALSE)
	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return

	if(forge_temperature < MIN_FORGE_TEMP)
		balloon_alert(user, LANG("obj.2f50735ea303ecaa", null))
		return ITEM_INTERACT_BLOCKING

	if(values_sum(search_stack.mats_per_unit) < SHEET_MATERIAL_AMOUNT)
		balloon_alert(user, LANG("obj.90b30619315cb76f", list(search_stack)))
		return ITEM_INTERACT_BLOCKING

	var/list/my_list = get_filtered_radial_choices(user)
	var/user_choice = show_radial_menu(user, src, my_list, radius = 38, require_near = TRUE, tooltips = TRUE)
	var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER)

	if(!user_choice)
		balloon_alert(user, LANG("obj.79ebf8df11e241bb", null))
		return ITEM_INTERACT_BLOCKING

	// Sets up a list of the materials to give to the item later
	var/list/material_list = list()

	if(search_stack.material_type)
		material_list[SSmaterials.get_material(search_stack.material_type)] = SHEET_MATERIAL_AMOUNT

	else
		for(var/material in search_stack.custom_materials)
			material_list[material] = SHEET_MATERIAL_AMOUNT

	if(search_stack.amount < 1)
		balloon_alert(user, LANG("obj.c5fd95b69c463fb1", list(search_stack)))
		return ITEM_INTERACT_BLOCKING

	balloon_alert_to_viewers(LANG("obj.d0bc5f448dd8a4d3", list(search_stack)))

	if(!burn_hand)
		if(!isnull(tool))
			if(!do_after(user, skill_modifier * tool.toolspeed * 2 SECONDS, target = src, interaction_key = DOAFTER_SMITHING_FORGE))
				balloon_alert_to_viewers(LANG("obj.34c2f70deab9e0ab", list(search_stack)))
				return ITEM_INTERACT_BLOCKING
		else
			stack_trace("[src] had its 'make forgeable item' function called, with burn_hand = false and tool = null! This should never happen!")
	else
		to_chat(user, span_warning(LANG("obj.6fd0129bbebf23a5", list(search_stack))))
		if(!do_after(user, skill_modifier * 5 SECONDS, target = src, interaction_key = DOAFTER_SMITHING_FORGE))
			balloon_alert_to_viewers(LANG("obj.34c2f70deab9e0ab", list(search_stack)))
			return ITEM_INTERACT_BLOCKING

		var/hand_protected = FALSE
		var/mob/living/carbon/human/human_user = user
		if(!istype(human_user) || HAS_TRAIT(human_user, TRAIT_RESISTHEAT) || HAS_TRAIT(human_user, TRAIT_RESISTHEATHANDS))
			hand_protected = TRUE
		else if(!istype(human_user.gloves, /obj/item/clothing/gloves))
			hand_protected = FALSE
		else
			var/obj/item/clothing/gloves/gloves = human_user.gloves
			if(gloves.max_heat_protection_temperature)
				hand_protected = (gloves.max_heat_protection_temperature > 360)
		if(!hand_protected)
			var/hitzone = user.held_index_to_dir(user.active_hand_index) == "r" ? BODY_ZONE_PRECISE_R_HAND : BODY_ZONE_PRECISE_L_HAND
			user.apply_damage(35, BURN, hitzone)
			playsound(src, 'sound/effects/wounds/sizzle1.ogg', 50, TRUE)
			to_chat(user, span_danger(LANG("obj.eb0ca4991afacdb6", list(search_stack, src))))
			user.add_mood_event("burnt_thumb", /datum/mood_event/burnt_thumb)

	search_stack.forceMove(get_turf(src))

	if(!search_stack.use(1))
		balloon_alert(user, LANG("obj.c5fd95b69c463fb1", list(search_stack)))
		return ITEM_INTERACT_BLOCKING

	var/spawn_item = choice_list[user_choice]
	var/obj/item/forging/incomplete/incomplete_item = new spawn_item(get_turf(src))

	if(material_list)
		incomplete_item.set_custom_materials(material_list)

	var/datum/component/forge_smithable/smith_component = incomplete_item.GetComponent(/datum/component/forge_smithable)
	if(!isnull(smith_component))
		COOLDOWN_START(smith_component, heating_remainder, FORGE_HEATING_DURATION)

	balloon_alert(user, LANG("obj.1784b6dbb105c338", list(search_stack, user_choice)))

	return ITEM_INTERACT_SUCCESS


/obj/structure/reagent_forge/blowrod_act(mob/living/user, obj/item/tool)
	if(DOING_INTERACTION(user, DOAFTER_SMITHING_FORGE))
		return
	var/obj/item/glassblowing/blowing_rod/blowing_item = tool
	var/glassblowing_speed = user.mind.get_skill_modifier(/datum/skill/production, SKILL_SPEED_MODIFIER) * BASELINE_ACTION_TIME
	var/glassblowing_amount = BASELINE_HEATING_DURATION / user.mind.get_skill_modifier(/datum/skill/production, SKILL_SPEED_MODIFIER)

	if(forge_temperature < MIN_FORGE_TEMP)
		balloon_alert(user, LANG("obj.acbd16e54c767ebb", list(blowing_item)))
		return ITEM_INTERACT_SUCCESS

	var/obj/item/glassblowing/molten_glass/find_glass = locate() in blowing_item.contents
	if(!find_glass)
		balloon_alert(user, LANG("obj.4d57aff91913e9af", list(blowing_item)))
		return ITEM_INTERACT_SUCCESS

	if(!COOLDOWN_FINISHED(find_glass, remaining_heat))
		balloon_alert(user, LANG("obj.0e8f76b1e74b410f", list(find_glass)))
		return ITEM_INTERACT_SUCCESS

	to_chat(user, span_notice(LANG("obj.612cae705eee5b4b", list(blowing_item))))

	if(!do_after(user, glassblowing_speed, target = src, interaction_key = DOAFTER_SMITHING_FORGE))
		balloon_alert(user, LANG("obj.9dea8f05ca91dbcb", list(blowing_item)))
		return ITEM_INTERACT_SUCCESS

	COOLDOWN_START(find_glass, remaining_heat, glassblowing_amount)
	find_glass.total_time = glassblowing_amount
	to_chat(user, span_notice(LANG("obj.ea0991c2c0f1859d", list(blowing_item))))
	user.mind?.adjust_experience(/datum/skill/production, 10)
	return ITEM_INTERACT_SUCCESS

/obj/structure/reagent_forge/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	set_anchored(!anchored)
	balloon_alert_to_viewers(anchored ? "secured" : "unsecured")
	return TRUE

/obj/structure/reagent_forge/crowbar_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	balloon_alert(user, LANG("obj.4462066733c487bc", null))
	deconstruct(TRUE)
	return TRUE

/obj/structure/reagent_forge/atom_deconstruct(disassembled)
	new /obj/item/stack/sheet/iron/ten(get_turf(src))
	return ..()

/obj/structure/reagent_forge/tier2
	forge_level = FORGE_LEVEL_NOVICE

/obj/structure/reagent_forge/tier3
	forge_level = FORGE_LEVEL_APPRENTICE

/obj/structure/reagent_forge/tier4
	forge_level = FORGE_LEVEL_JOURNEYMAN

/obj/structure/reagent_forge/tier5
	forge_level = FORGE_LEVEL_EXPERT

/obj/structure/reagent_forge/tier6
	forge_level = FORGE_LEVEL_MASTER

/obj/structure/reagent_forge/tier7
	forge_level = FORGE_LEVEL_LEGENDARY

/obj/structure/reagent_forge/tier7/imbuing/Initialize(mapload)
	. = ..()
	create_reagent_forge()

/particles/smoke/mild
	spawning = 1
	velocity = list(0, 0.3, 0)
	friction = 0.25

#undef BASELINE_ACTION_TIME

#undef BASELINE_HEATING_DURATION

#undef FORGE_DEFAULT_TEMPERATURE_CHANGE
#undef MAX_FORGE_TEMP
#undef MIN_FORGE_TEMP
#undef FORGE_HEATING_DURATION

#undef FORGE_LEVEL_YOU_PLAY_LIKE_A_NOOB
#undef FORGE_LEVEL_NOVICE
#undef FORGE_LEVEL_APPRENTICE
#undef FORGE_LEVEL_JOURNEYMAN
#undef FORGE_LEVEL_EXPERT
#undef FORGE_LEVEL_MASTER
#undef FORGE_LEVEL_LEGENDARY

#undef MAX_TEMPERATURE_LOSS_DECREASE

#undef CHARCOAL_CHANCE

#undef MINIMUM_IMBUING_REAGENT_AMOUNT

#undef SMOKE_STATE_NONE
#undef SMOKE_STATE_GOOD
#undef SMOKE_STATE_NEUTRAL
#undef SMOKE_STATE_BAD
#undef SMOKE_STATE_NOT_COOKING

#undef FORGE_FUMES_HEAT
#undef FORGE_FUMES_VOLUME
