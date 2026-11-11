// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/phystool_mode/build_mode
	name = "Build mode"
	desc = "Use LMB for build mode, RMB for remover and in hands to choose between structures."

	var/atom/selected_atom

/datum/phystool_mode/build_mode/use_act(mob/user)
	. = ..()

	var/list/choise = list(
		"Wall mode" = image(icon = 'icons/turf/walls.dmi', icon_state = "wall3"),
		"Turf mode" = image(icon = 'icons/turf/walls.dmi', icon_state = "floor"),
		"Structure mode" = image(icon = 'icons/obj/doors/airlocks/external/external.dmi', icon_state = "closed")
	)
	var/choised_mode = show_radial_menu(user, user, choise, require_near = TRUE)
	if(!choised_mode)
		user.balloon_alert(user, LANG("datum.16c6c7395e1a6b01", null))
		return FALSE
	var/list/pick = list()
	if(choised_mode == "Wall mode")
		pick = init_subtypes_w_path_keys(/turf/closed/wall)
	if(choised_mode == "Turf mode")
		pick = init_subtypes_w_path_keys(/turf/open)
		for(var/turf/open/space/T in pick)
			pick -= T
	if(choised_mode == "Structure mode")
		pick = init_subtypes_w_path_keys(/obj/machinery/door)
	selected_atom = tgui_input_list(user, LANG("datum.03d2ebf713270921", null), LANG("datum.3cd4a50efb841ca4", null), pick)
	return TRUE

/datum/phystool_mode/build_mode/secondnary_act(atom/target, mob/user)
	. = ..()

	if(iswallturf(target))
		var/turf/T = target
		T.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return TRUE
	else if(istype(target, /obj/machinery/door))
		qdel(target)
		return TRUE

/datum/phystool_mode/build_mode/main_act(atom/target, mob/user)
	. = ..()

	if(!selected_atom)
		user.balloon_alert(user, LANG("datum.b4ab69b0c79928aa", null))
		return FALSE
	if(!isopenturf(target))
		user.balloon_alert(user, LANG("datum.62d831a3dbaf3612", null))
		return FALSE
	var/turf/T = target
	if(T.is_blocked_turf())
		user.balloon_alert(user, LANG("datum.62d831a3dbaf3612", null))
		return FALSE
	if(!isturf(selected_atom))
		T.place_on_top(selected_atom)
		return TRUE
	T.TerraformTurf(selected_atom, selected_atom, flags = CHANGETURF_INHERIT_AIR)
	return TRUE
