// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/component/simple_farm
	///whether we limit the amount of plants you can have per turf
	var/one_per_turf = TRUE
	///the reference to the movable parent the component is attached to
	var/atom/atom_parent
	///the amount of pixels shifted (x,y)
	var/list/pixel_shift = 0

/datum/component/simple_farm/Initialize(set_plant = FALSE, set_turf_limit = TRUE, list/set_shift = list(0, 0))
	//we really need to check if its movable
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	atom_parent = parent
	//important to allow people to just straight up set allowing to plant
	one_per_turf = set_turf_limit
	pixel_shift = set_shift
	//now lets register the signals
	RegisterSignal(atom_parent, COMSIG_ATOM_ATTACKBY, PROC_REF(check_attack))
	RegisterSignal(atom_parent, COMSIG_ATOM_EXAMINE, PROC_REF(check_examine))
	RegisterSignal(atom_parent, COMSIG_QDELETING, PROC_REF(delete_farm))

/datum/component/simple_farm/Destroy(force, silent)
	//lets not hard del
	UnregisterSignal(atom_parent, list(COMSIG_ATOM_ATTACKBY, COMSIG_ATOM_EXAMINE, COMSIG_QDELETING))
	atom_parent = null
	return ..()

/**
 * check_attack is meant to listen for the COMSIG_ATOM_ATTACKBY signal, where it essentially functions like the attackby proc
 */
/datum/component/simple_farm/proc/check_attack(datum/source, obj/item/attacking_item, mob/user, list/modifiers)
	SIGNAL_HANDLER

	//if its a seed, lets try to plant
	if(istype(attacking_item, /obj/item/seeds))
		var/obj/structure/simple_farm/locate_farm = locate() in get_turf(atom_parent)

		if(one_per_turf && locate_farm)
			atom_parent.balloon_alert_to_viewers(LANG("datum.cd992e8329c511c0", null))
			return

		locate_farm = new(get_turf(atom_parent))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		locate_farm.pixel_x = pixel_shift[1]
		locate_farm.pixel_y = pixel_shift[2]
		locate_farm.layer = atom_parent.layer + 0.1
		if(ismovable(atom_parent))
			var/atom/movable/movable_parent = atom_parent
			locate_farm.glide_size = movable_parent.glide_size
		attacking_item.forceMove(locate_farm)
		locate_farm.planted_seed = attacking_item
		locate_farm.attached_atom = atom_parent
		atom_parent.balloon_alert_to_viewers(LANG("datum.ff8ef9aa59fafe56", null))
		locate_farm.update_appearance()
		locate_farm.late_setup()

/**
 * check_examine is meant to listen for the COMSIG_ATOM_EXAMINE signal, where it will put additional information in the examine
 */
/datum/component/simple_farm/proc/check_examine(datum/source, mob/user, list/examine_list)
	examine_list += span_notice(LANG("datum.381384000dc59ae7", null))

/**
 * delete_farm is meant to be called when the parent of this component has been deleted-- thus deleting the ability to grow the simple farm
 * it will delete the farm that can be found on the turf of the parent of this component
 */
/datum/component/simple_farm/proc/delete_farm()
	SIGNAL_HANDLER

	var/obj/structure/simple_farm/locate_farm = locate() in get_turf(atom_parent)
	if(locate_farm)
		qdel(locate_farm)

/obj/structure/simple_farm
	name = "simple farm"
	desc = "A small little plant that has adapted to the surrounding environment."
	//it needs to be able to be walked through
	density = FALSE
	//it should not be pulled by anything
	anchored = TRUE
	///the atom the farm is attached to
	var/atom/attached_atom
	///the seed that is held within
	var/obj/item/seeds/planted_seed
	/// The amount of worms we're storing
	var/stored_worms = 0
	/// the farm level we're at
	var/farm_level = SKILL_LEVEL_NONE

	///the max amount harvested from the plants
	var/max_harvest = 3
	///the cooldown amount between each harvest
	var/harvest_cooldown = 1 MINUTES
	///the extra potency applied to the seed
	var/bonus_potency = 0
	//the cooldown between each harvest
	COOLDOWN_DECLARE(harvest_timer)

/obj/structure/simple_farm/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	COOLDOWN_START(src, harvest_timer, harvest_cooldown)

/obj/structure/simple_farm/Destroy()
	STOP_PROCESSING(SSobj, src)

	if(planted_seed)
		planted_seed.forceMove(get_turf(src))
		planted_seed = null

	if(attached_atom)
		if(ismovable(attached_atom))
			UnregisterSignal(attached_atom, COMSIG_MOVABLE_MOVED)

		attached_atom = null

	return ..()

/obj/structure/simple_farm/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.80da4e79ea0ec820", list(src, DisplayTimeText(COOLDOWN_TIMELEFT(src, harvest_timer)))))
	if(farm_level < SKILL_LEVEL_LEGENDARY)
		. += span_notice(LANG("obj.bf570990ccfc1361", null))
	if(stored_worms < 5)
		. += span_notice(LANG("obj.4fce4ab256c78df4", null))

/obj/structure/simple_farm/process(seconds_per_tick)
	update_appearance()

/obj/structure/simple_farm/update_appearance(updates)
	if(!planted_seed)
		return

	icon = planted_seed.growing_icon

	if(COOLDOWN_FINISHED(src, harvest_timer))
		if(planted_seed.icon_harvest)
			icon_state = planted_seed.icon_harvest

		else
			icon_state = "[planted_seed.icon_grow][planted_seed.growthstages]"

		name = LOWER_TEXT(planted_seed.plantname)

	else
		icon_state = "[planted_seed.icon_grow]1"
		name = LOWER_TEXT("harvested [planted_seed.plantname]")

	return ..()

/obj/structure/simple_farm/attack_hand(mob/living/user, list/modifiers)
	if(!COOLDOWN_FINISHED(src, harvest_timer))
		balloon_alert(user, LANG("obj.789d9fb4fd49e550", null))
		return

	COOLDOWN_START(src, harvest_timer, harvest_cooldown)
	create_harvest()
	user.mind?.adjust_experience(/datum/skill/primitive, 5)
	update_appearance()
	return ..()

/obj/structure/simple_farm/attackby(obj/item/attacking_item, mob/user, params)
	//if its a shovel or knife, dismantle
	if(attacking_item.tool_behaviour == TOOL_SHOVEL || attacking_item.tool_behaviour == TOOL_KNIFE)
		var/turf/src_turf = get_turf(src)
		src_turf.balloon_alert_to_viewers(LANG("obj.f0b57d5d082527d0", null))
		Destroy()
		return

	//if its a bag, harvest
	else if(istype(attacking_item, /obj/item/storage/bag/plants))
		if(!COOLDOWN_FINISHED(src, harvest_timer))
			return

		COOLDOWN_START(src, harvest_timer, harvest_cooldown)
		create_harvest(attacking_item, user)
		user.mind?.adjust_experience(/datum/skill/primitive, 15)
		update_appearance()
		return

	//if its fertilizer, boost our level
	else if(istype(attacking_item, /obj/item/stack/worm_fertilizer))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		if(farm_level >= SKILL_LEVEL_LEGENDARY)
			balloon_alert(user, LANG("obj.d6bcccafdcb97999", null))
			return

		var/obj/item/stack/worm_fertilizer/fertilizer = attacking_item
		if(!fertilizer.use(1))
			return

		balloon_alert(user, LANG("obj.1f45f02dcf14b4fa", null))
		farm_level++
		return

	//if its worms, increase our worms
	else if(istype(attacking_item, /obj/item/food/bait/worm))
		user.mind?.adjust_experience(/datum/skill/primitive, 5)
		if(stored_worms >= 5)
			balloon_alert(user, LANG("obj.1b0e551977adcc78", null))
			return

		balloon_alert(user, LANG("obj.32e873a442226cf4", null))
		qdel(attacking_item)
		stored_worms++
		return

	return ..()

/obj/structure/simple_farm/proc/increase_level(new_level)
	while(new_level > farm_level)
		farm_level++
		switch(farm_level)
			if(SKILL_LEVEL_NOVICE)
				//you figure out the weird red color these apples have doesnt make them inedible
				max_harvest += 1
				bonus_potency += 10

			if(SKILL_LEVEL_APPRENTICE)
				//hey these plants are the most ripe at this time in the season
				max_harvest += 1

			if(SKILL_LEVEL_JOURNEYMAN)
				//HEY, LADDERS EXIST, GO GET THOSE TREETOP FRUITS
				harvest_cooldown -= 10 SECONDS
				bonus_potency += 10

			if(SKILL_LEVEL_EXPERT)
				//oh so THATS why im getting mold on produce
				max_harvest += 1

			if(SKILL_LEVEL_MASTER)
				//you realize you can let some frogs eat pests for you
				harvest_cooldown -= 10 SECONDS
				bonus_potency += 10

			if(SKILL_LEVEL_LEGENDARY)
				//the PLANTS know who's their TENDER
				var/static/list/color_matrix_were_rich = list(
					1.5, 1, 0, 0,
					1.5, 1, 0, 0,
					0, 0, 0.5, 0,
					0, 0, 0, 1,
					0, 0, 0, 0
				)
				add_atom_colour(color_matrix_were_rich, FIXED_COLOUR_PRIORITY)
				bonus_potency += 20
				harvest_cooldown -= 15 SECONDS
				balloon_alert_to_viewers(LANG("obj.896609a454f0213b", list(src)))


/**
 * used during the component so that it can move when its attached atom moves
 */
/obj/structure/simple_farm/proc/late_setup()
	if(!ismovable(attached_atom))
		return
	RegisterSignal(attached_atom, COMSIG_MOVABLE_MOVED, PROC_REF(move_plant))

/**
 * a simple proc to forcemove the plant on top of the movable atom its attached to
 */
/obj/structure/simple_farm/proc/move_plant()
	forceMove(get_turf(attached_atom))

/**
 * will create a harvest of the seeds product, with a chance to create a mutated version
 */
/obj/structure/simple_farm/proc/create_harvest(obj/item/storage/bag/plants/plant_bag, mob/user)
	if(!planted_seed)
		return

	var/lower_cap = rand(1, max_harvest)
	for(var/i in 0 to stored_worms)
		if(prob(15))
			continue
		lower_cap = max(1, lower_cap - 1)

	if(farm_level >= SKILL_LEVEL_LEGENDARY)
		lower_cap = 1

	for(var/i in lower_cap to max_harvest)
		var/obj/item/seeds/seed
		if(prob(15) && length(planted_seed.mutatelist))
			var/type = pick(planted_seed.mutatelist)
			seed = new type
			balloon_alert_to_viewers(LANG("obj.63205a5c652a8861", null))
		else
			// SPLURT EDIT START - fixes botany genes
			/*
			seed = new planted_seed.type(null)
			*/
			if(istype(seed, /obj/item/seeds/random))
				seed = new planted_seed.type
			else
				seed = planted_seed.Copy()
			// SPLURT EDIT END

		//we're ASHIE GAMING, we do not concern ourselves with such puny concepts as purity
		seed.endurance = 100
		seed.lifespan = 100
		seed.instability = 0
		//also that
		seed.yield = 5 + max_harvest

		seed.potency = 50 + bonus_potency
		if(stored_worms)
			seed.potency += stored_worms * 4

		var/harvest_type = seed.product || seed.type
		var/harvest = new harvest_type(get_turf(src), seed)
		plant_bag?.atom_storage?.attempt_insert(harvest, user, TRUE)

/turf/open/misc/asteroid/basalt/getDug()
	. = ..()
	AddComponent(/datum/component/simple_farm)

/turf/open/misc/asteroid/basalt/refill_dug()
	. = ..()
	qdel(GetComponent(/datum/component/simple_farm))

/turf/open/misc/asteroid/snow/getDug()
	. = ..()
	AddComponent(/datum/component/simple_farm)

/turf/open/misc/asteroid/snow/refill_dug()
	. = ..()
	qdel(GetComponent(/datum/component/simple_farm))
