// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/summon_beacon
	name = "summoner beacon"
	desc = "Summons a thing. Probably shouldn't use this one, though."
	icon = 'icons/obj/devices/remote.dmi'
	icon_state = "generic_delivery"
	inhand_icon_state = "generic_delivery"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

	/// How many uses the beacon has left
	var/uses = 1

	/// A list of allowed areas that the atom can be spawned in
	var/list/allowed_areas = list(
		/area,
	)

	/// A list of possible atoms available to spawn
	var/list/selectable_atoms = list(
		/obj/item/summon_beacon,
	)

	/// The currently selected atom, if any
	var/atom/selected_atom = null

	/// Descriptor of what area it should work in
	var/area_string = "any"

	/// If the supply pod should stay or not
	var/supply_pod_stay = FALSE

/obj/item/summon_beacon/examine()
	. = ..()
	. += span_warning(LANG("obj.006565ab045e0a17", list(area_string)))
	. += span_notice(LANG("obj.e7fa7fe1da063758", list(selected_atom ? initial(selected_atom.name) : "None")))

/obj/item/summon_beacon/attack_self(mob/user)
	if(!can_use_beacon(user))
		return
	if(length(selectable_atoms) == 1)
		selected_atom = selectable_atoms[1]
		return
	show_options(user)

/obj/item/summon_beacon/proc/can_use_beacon(mob/living/user)
	if(user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return TRUE
	else
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 40, TRUE)
		return FALSE

/obj/item/summon_beacon/proc/generate_display_names()
	var/list/atom_list = list()
	for(var/atom/iterated_atom as anything in selectable_atoms)
		atom_list[initial(iterated_atom.name)] = iterated_atom
	return atom_list

/obj/item/summon_beacon/proc/show_options(mob/user)
	var/list/radial_build = get_available_options()
	if(!radial_build)
		return

	selected_atom = show_radial_menu(user, src, radial_build, radius = 40, tooltips = TRUE)

/obj/item/summon_beacon/proc/get_available_options()
	var/list/options = list()
	for(var/iterating_choice in selectable_atoms)
		var/obj/our_object = iterating_choice
		var/datum/radial_menu_choice/option = new
		option.image = image(icon = initial(our_object.icon), icon_state = initial(our_object.icon_state))
		option.info = span_boldnotice("[initial(our_object.desc)]")

		options[our_object] = option

	sort_list(options)

	return options

/obj/item/summon_beacon/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!selected_atom)
		balloon_alert(user, LANG("obj.fc601c42a48f5499", null))
		return NONE
	var/turf/target_turf = get_turf(interacting_with)
	var/area/target_area = get_area(interacting_with)
	if(!target_turf || !target_area || !is_type_in_list(target_area, allowed_areas))
		balloon_alert(user, LANG("obj.df944ab2e459451c", null))
		return NONE

	var/confirmed = tgui_alert(user, LANG("obj.e94532235a469c33", list(initial(selected_atom.name))), LANG("obj.15bc27b6fe454546", null), list("Yes", "No"))
	if(confirmed != "Yes")
		return ITEM_INTERACT_BLOCKING

	if(!uses)
		return ITEM_INTERACT_BLOCKING

	uses -= 1
	balloon_alert(user, LANG("obj.de782adb79afea31", list(uses, uses == 1 ? "" : "s")))

	podspawn(list(
		"target" = target_turf,
		"path" = supply_pod_stay ? /obj/structure/closet/supplypod/podspawn/no_return : /obj/structure/closet/supplypod/podspawn,
		"style" = /datum/pod_style/centcom,
		"spawn" = selected_atom,
	))

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(istype(human_user.ears, /obj/item/radio/headset) && !istype(human_user.ears_extra, /obj/item/radio/headset)) //Splurt edit - works with both ears now
			to_chat(user, span_notice(LANG("obj.9248b3c7e22a19ae", list(span_bold("Request received. Pod inbound, please stand back from the landing site.")))))

	if(!uses)
		qdel(src)
	return ITEM_INTERACT_SUCCESS

// Misc stuff here

/obj/structure/closet/supplypod/podspawn/no_return
	bluespace = FALSE

/obj/item/storage/box/gas_miner_beacons
	name = "box of gas miner delivery beacons"
	desc = "Contains two beacons for delivery of atmospheric gas miners."

/obj/item/storage/box/gas_miner_beacons/PopulateContents()
	new /obj/item/summon_beacon/gas_miner(src)
	new /obj/item/summon_beacon/gas_miner(src)


// Actual beacons start here

/obj/item/summon_beacon/gas_miner
	name = "gas miner beacon"
	desc = "Once a gas miner type is selected, delivers a gas miner to the target location."

	allowed_areas = list(
		/area/station/engineering/atmos,
		/area/station/engineering/atmospherics_engine,
		/area/ruin/space/has_grav/port_tarkon/atmos,
	)

	selectable_atoms = list(
		/obj/machinery/atmospherics/miner/carbon_dioxide,
		/obj/machinery/atmospherics/miner/n2o,
		/obj/machinery/atmospherics/miner/nitrogen,
		/obj/machinery/atmospherics/miner/oxygen,
		/obj/machinery/atmospherics/miner/plasma,
		/obj/machinery/atmospherics/miner/water_vapor,
	)

	area_string = "atmospherics"
