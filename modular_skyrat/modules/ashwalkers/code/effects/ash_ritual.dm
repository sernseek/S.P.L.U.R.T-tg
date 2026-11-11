// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/ash_ritual
	/// the name of the ritual
	var/name = "Summon Coders"
	/// the description of the ritual
	var/desc

	/// the components necessary for a successful ritual
	var/list/required_components = list()
	/// the list that checks whether the components will be consumed
	var/list/consumed_components = list()

	/// if the ritual is successful, it will go through each item in the list to be spawned
	var/list/ritual_success_items

	/// the effect that is spawned when the components are consumed, etc.
	var/ritual_effect = /obj/effect/particle_effect/sparks

	/// the time it takes to process each stage of the ritual
	var/ritual_time = 2 SECONDS

	/// whether the ritual is in use
	var/in_use = FALSE

/datum/ash_ritual/proc/ritual_start(obj/effect/ash_rune/rune)

	if(in_use)
		return
	in_use = TRUE

	rune.balloon_alert_to_viewers(LANG("datum.a1cab08041b2dd0b", null))
	new ritual_effect(rune.loc)

	// it is entirely possible to have your own effects here... this is just a suggestion
	var/atom/movable/warp_effect/warp = new(rune)
	rune.vis_contents += warp

	sleep(ritual_time)

	if(!check_component_list(rune))
		rune.vis_contents -= warp
		warp = null
		return

	ritual_success(rune)

	// make sure to remove your effects at the end
	rune.vis_contents -= warp
	warp = null

/datum/ash_ritual/proc/check_component_list(obj/effect/ash_rune/checked_rune)
	for(var/checked_component in required_components)
		var/set_direction = text2dir(checked_component)
		var/turf/checked_turf = get_step(checked_rune, set_direction)
		var/atom_check = locate(required_components[checked_component]) in checked_turf.contents
		if(!atom_check)
			ritual_fail(checked_rune)
			return FALSE

		if(is_type_in_list(atom_check, consumed_components))
			if(istype(atom_check, /obj/item/stack))
				var/obj/item/stack/pile = atom_check
				pile.use(1, transfer = FALSE)
			else
				qdel(atom_check)
			checked_rune.balloon_alert_to_viewers(LANG("datum.bf43ca1d21a17c20", list(checked_component)))

		else
			checked_rune.balloon_alert_to_viewers(LANG("datum.0d7d872d7a3e230e", list(checked_component)))

		new ritual_effect(checked_rune.loc)
		sleep(ritual_time)

	return TRUE

/datum/ash_ritual/proc/ritual_fail(obj/effect/ash_rune/failed_rune)
	new ritual_effect(failed_rune.loc)
	failed_rune.balloon_alert_to_viewers(LANG("datum.13a3a8c10b70e59b", null))
	failed_rune.current_ritual = null
	in_use = FALSE
	return

/datum/ash_ritual/proc/ritual_success(obj/effect/ash_rune/success_rune)
	new ritual_effect(success_rune.loc)
	success_rune.balloon_alert_to_viewers(LANG("datum.1e6cd11dcd4944a4", null))
	log_game("[name] ritual has been successfully activated.")

	var/turf/rune_turf = get_turf(success_rune)
	if(length(ritual_success_items))
		for(var/type in ritual_success_items)
			new type(rune_turf)

	success_rune.current_ritual = null
	in_use = FALSE
	return TRUE
