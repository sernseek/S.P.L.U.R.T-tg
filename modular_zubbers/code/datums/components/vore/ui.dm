// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/component/vore
	var/ui_editing_lookuptable = FALSE
	var/rate_limit_belly_creation = 0

/datum/component/vore/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VorePanel", "Vore Panel")
		ui.open()

/datum/component/vore/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	// Only parent can edit us
	if(user != parent)
		. = min(., UI_UPDATE)

/datum/component/vore/ui_state(mob/user)
	return GLOB.conscious_state

/datum/component/vore/ui_static_data(mob/user)
	var/list/data = list()

	data["max_bellies"] = MAX_BELLIES
	data["max_prey"] = MAX_PREY
	data["max_verb_length"] = MAX_VERB_LENGTH
	data["max_vore_message_length"] = MAX_VORE_MESSAGE_LENGTH
	data["min_vore_message_length"] = MIN_VORE_MESSAGE_LENGTH

	data["max_burn_damage"] = MAX_BURN_DAMAGE
	data["max_brute_damage"] = MAX_BRUTE_DAMAGE
	data["max_escape_time"] = MAX_ESCAPE_TIME
	data["min_escape_time"] = MIN_ESCAPE_TIME

	data["character_slots"] = null
	data["vore_slots"] = null
	data["lookup_table"] = null

	var/list/overlay_data = list()
	for(var/atom/movable/screen/fullscreen/carrier/vore/type as anything in subtypesof(/atom/movable/screen/fullscreen/carrier/vore))
		UNTYPED_LIST_ADD(overlay_data, list(
			"path" = type,
			"name" = initial(type.name),
			"icon" = initial(type.icon),
			"icon_state" = initial(type.icon_state),
			"recolorable" = initial(type.recolorable),
		))
	data["available_overlays"] = overlay_data

	if(ui_editing_lookuptable)
		var/datum/vore_preferences/vore_prefs = user.client.get_vore_prefs()
		if(!vore_prefs)
			return data

		data["character_slots"] = user.client.prefs.create_character_profiles()
		data["vore_slots"] = vore_prefs.generate_slot_choice_list()
		data["lookup_table"] = vore_prefs.get_lookup_table()

	return data

/datum/component/vore/ui_data(mob/user)
	var/list/data = list()

	data["selected_belly"] = LAZYFIND(vore_bellies, selected_belly)

	var/list/bellies = list()

	var/index = 0
	for(var/obj/vore_belly/belly as anything in vore_bellies)
		index++
		UNTYPED_LIST_ADD(bellies, list("index" = index) + belly.ui_data(user))

	data["bellies"] = bellies

	// Always their own prefs
	var/datum/vore_preferences/vore_prefs = user.get_vore_prefs()
	if(vore_prefs)
		data += vore_prefs.ui_data(user)

	data["inside"] = null
	if(istype(user.loc, /obj/vore_belly))
		var/obj/vore_belly/tummy = user.loc
		data["inside"] = tummy.ui_data(user)

	data["not_our_owner"] = (user.ckey != our_owner_ckey)

	return data

/datum/component/vore/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/living_parent = parent
	if(usr != living_parent)
		stack_trace("Vore component ui_act triggered by [key_name(usr)] who IS NOT OUR PARENT [key_name(living_parent)]")
		return

	switch(action)
		if("create_belly")
			if(!COOLDOWN_FINISHED(src, rate_limit_belly_creation))
				to_chat(living_parent, span_warning(LANG("datum.e3a9f745f33b278a", list(COOLDOWN_TIMELEFT(src, rate_limit_belly_creation) / 10))))
				return
			if(LAZYLEN(vore_bellies) >= MAX_BELLIES)
				to_chat(living_parent, span_warning(LANG("datum.f470f9df2ce8a7fd", list(MAX_BELLIES))))
				return TRUE
			create_default_belly()
			COOLDOWN_START(src, rate_limit_belly_creation, BELLY_CREATION_COOLDOWN)
			. = TRUE
		if("select_belly")
			var/obj/vore_belly/new_selected = locate(params["ref"])
			if(istype(new_selected) && new_selected.owner == src)
				selected_belly = new_selected
				to_chat(living_parent, span_notice(LANG("datum.f8ea6f5d7f19b600", list(selected_belly))))
			. = TRUE
		if("click_prey")
			var/mob/prey = locate(params["ref"])
			if(istype(prey))
				click_prey(prey)
			. = TRUE
		if("edit_belly")
			var/obj/vore_belly/target = locate(params["ref"])
			if(!istype(target))
				return
			if(target.owner != src)
				return
			target.ui_modify_var(params["var"], params["value"])
			save_bellies()
			. = TRUE
		if("test_sound")
			var/obj/vore_belly/target = locate(params["ref"])
			if(!istype(target))
				return
			if(target.owner != src)
				return
			switch(params["sound"])
				if("insert_sound")
					SEND_SOUND(living_parent, sound(target.get_insert_sound()))
				if("release_sound")
					SEND_SOUND(living_parent, sound(target.get_release_sound()))
		if("set_pref")
			var/datum/vore_preferences/vore_prefs = living_parent.get_vore_prefs()
			if(!vore_prefs)
				to_chat(living_parent, span_danger(LANG("datum.a5759e89dffd4981", null)))
				return

			var/key = params["key"]
			var/value = params["value"]

			var/datum/vore_pref/P = GLOB.vore_preference_entries_by_key[key]
			if(!istype(P))
				CRASH("Bad pref key: [key]")

			if(!vore_prefs.write_preference(P, value))
				CRASH("Couldn't write value for [key] ([P]) ([value])")
			. = TRUE
		if("move_belly")
			var/obj/vore_belly/target = locate(params["ref"])
			if(!istype(target))
				return
			if(target.owner != src)
				return
			var/index = vore_bellies.Find(target)
			if(!index)
				return

			var/dir = params["dir"]
			if(dir == "up" && index > 1)
				vore_bellies.Swap(index - 1, index)
			else if(index < LAZYLEN(vore_bellies))
				vore_bellies.Swap(index, index + 1)

			save_bellies()
			. = TRUE
		if("delete_belly")
			var/obj/vore_belly/target = locate(params["ref"])
			if(!istype(target))
				return
			if(target.owner != src)
				return
			if(LAZYLEN(vore_bellies) == 1)
				to_chat(living_parent, span_danger(LANG("datum.84965cb22c9e62b2", null)))
				return

			qdel(target)
			save_bellies()
			. = TRUE
		if("belly_backups")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return
			download_belly_backup()
			. = TRUE
		if("load_slot")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return
			var/datum/vore_preferences/vore_prefs = living_parent.get_vore_prefs()
			if(!vore_prefs)
				return

			// returns true if the user doesn't decline to load a slot
			if(vore_prefs.load_slot())
				clear_bellies()
				load_bellies_from_prefs()
			. = TRUE
		if("set_slot_name")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return
			var/datum/vore_preferences/vore_prefs = living_parent.get_vore_prefs()
			if(!vore_prefs)
				return

			var/name = permissive_sanitize_name(params["name"])
			vore_prefs.set_slot_name(name)
			. = TRUE
		if("copy_to_slot")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return
			var/datum/vore_preferences/vore_prefs = living_parent.get_vore_prefs()
			if(!vore_prefs)
				return

			var/slot_to_save_over = vore_prefs.copy_to_slot()
			if(slot_to_save_over != null)
				save_bellies(slot_to_save_over)
				to_chat(living_parent, span_notice(LANG("datum.1fdc458ea7449996", list(slot_to_save_over))))
			. = TRUE
		if("toggle_lookup_data")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return
			ui_editing_lookuptable = !ui_editing_lookuptable
			update_static_data(living_parent, ui)
			. = TRUE
		if("set_lookup_table_entry")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return
			var/datum/vore_preferences/vore_prefs = living_parent.get_vore_prefs()
			if(!vore_prefs)
				return
			var/from_slot = params["from"]
			var/to_slot = text2num(params["to"])
			if(isnull(to_slot))
				return

			var/list/lookup_table = vore_prefs.get_lookup_table()
			lookup_table["[from_slot]"] = to_slot
			vore_prefs.set_lookup_table(lookup_table)
			update_static_data(living_parent, ui)

			. = TRUE
		if("delete_lookup_table_entry")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return
			var/datum/vore_preferences/vore_prefs = living_parent.get_vore_prefs()
			if(!vore_prefs)
				return
			var/slot_to_delete = "[params["slot_to_delete"]]"

			var/list/lookup_table = vore_prefs.get_lookup_table()
			lookup_table -= slot_to_delete
			vore_prefs.set_lookup_table(lookup_table)
			update_static_data(living_parent, ui)

			. = TRUE
		if("import_bellies")
			if(!COOLDOWN_FINISHED(src, rate_limit_belly_creation))
				to_chat(living_parent, span_warning(LANG("datum.e3a9f745f33b278a", list(COOLDOWN_TIMELEFT(src, rate_limit_belly_creation) / 10))))
				return

			// Nearly straight from CHOMP
			var/panel_choice = tgui_input_list(living_parent, LANG("datum.e00c037f09b2e0ea", null), LANG("datum.af65b956956a1852", null), list("Import all bellies from JSON", "Import one belly from JSON"))
			if(!panel_choice)
				return
			var/pickOne = FALSE
			if(panel_choice == "Import one belly from JSON")
				pickOne = TRUE
			var/input_file = input(living_parent, LANG("datum.0567f6d8bbb2c88c", null), LANG("datum.cc1bdff3d9037f45", null)) as file
			var/input_data
			try
				var/text = file2text(input_file)

				if(LAZYLEN(text) > MAX_JSON_CHARACTERS)
					CRASH("The supplied file is too large and cannot be parsed.")

				input_data = json_decode(text)

				if(!islist(input_data))
					CRASH("The supplied file was not a valid JSON file!")

				if(LAZYLEN(input_data) > MAX_JSON_ENTRIES)
					CRASH("The supplied file is too large and cannot be parsed.")

				var/is_vrdb = detect_vrdb(input_data)
				if(is_vrdb)
					to_chat(living_parent, span_danger(LANG("datum.063e2bf31c5b9ef9", null)))
				else
					if(input_data["db_repo"] != VORE_DB_REPO)
						CRASH("Unable to load file - db_repo was expected to be '[VORE_DB_REPO]' but was '[input_data["db_repo"]]'")

					if(input_data["db_version"] != VORE_DB_VERSION)
						CRASH("Unable to load file - db_version was expected to be '[VORE_DB_VERSION]' but was '[input_data["db_version"]]'")

				var/list/bellies_to_import = is_vrdb ? input_data : input_data["bellies"]

				if(LAZYLEN(bellies_to_import) < 1)
					CRASH("No bellies found!")

				if(pickOne)
					var/list/choices = list()
					var/index = 0
					var/list/repeat_items = list()
					for(var/list/V in bellies_to_import)
						index++
						var/name = V["name"]
						if(!istext(name))
							name = "<unnamed>"
						name = avoid_assoc_duplicate_keys(name, repeat_items)
						choices[name] = index
					var/picked = tgui_input_list(living_parent, LANG("datum.cc1bdff3d9037f45", null), LANG("datum.7cac121fb8655b57", null), choices)
					if(picked)
						bellies_to_import = list(bellies_to_import[choices[picked]])

				var/current_belly_count = LAZYLEN(vore_bellies)
				var/amount_to_import = min(LAZYLEN(bellies_to_import), MAX_BELLIES - LAZYLEN(current_belly_count))
				if(amount_to_import != LAZYLEN(bellies_to_import))
					to_chat(living_parent, span_warning(LANG("datum.3c935a57fdaf4b3c", list(amount_to_import))))

				for(var/i in 1 to amount_to_import)
					var/list/belly = bellies_to_import[i]
					var/obj/vore_belly/new_belly = new /obj/vore_belly(parent, src)
					new_belly.deserialize(belly)
					CHECK_TICK

				// Directly scale cooldown with how much they're creating
				COOLDOWN_START(src, rate_limit_belly_creation, BELLY_CREATION_COOLDOWN * amount_to_import)
				to_chat(living_parent, span_notice(LANG("datum.8b7ec04414453a5f", null)))
				save_bellies()
			catch(var/exception/e)
				tgui_alert(living_parent, LANG("datum.fcb20cabca42ebeb", list(e)), LANG("datum.8718c10c304578eb", null))
				return FALSE

			. = TRUE
		if("export_bellies")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return
			var/datum/vore_preferences/vore_prefs = get_parent_vore_prefs()
			if(!vore_prefs)
				return
			vore_prefs.export_slot()
			. = TRUE
		if("test_fullscreen")
			if(living_parent.screens["vore"])
				to_chat(living_parent, span_warning(LANG("datum.ba8cc8839e82c842", null)))
				return
			if(!living_parent.wants_vore_fullscreen())
				to_chat(living_parent, span_warning(LANG("datum.a6d95fcc30ac375d", null)))
				return
			// We need a belly for this to be relative to, for recoloring
			var/obj/vore_belly/target = locate(params["ref"])
			if(!istype(target))
				return
			if(target.owner != src)
				return
			target.show_fullscreen(living_parent)
			addtimer(CALLBACK(src, PROC_REF(reset_vore_fullscreen)), 2 SECONDS)
			. = TRUE

/datum/component/vore/proc/reset_vore_fullscreen()
	var/mob/living/living_parent = parent
	living_parent.clear_fullscreen("vore", 1 SECONDS)

/datum/component/vore/proc/click_prey(mob/living/prey)
	var/mob/living/living_parent = parent

	if(prey == living_parent)
		living_parent.examinate(living_parent)
		return

	var/obj/vore_belly/prey_loc = prey.loc
	if(!istype(prey_loc))
		return

	// We are prey next to them
	if(prey_loc == living_parent.loc)
		click_fellow_prey(prey)
	// We ate them
	else if(prey_loc.owner == src)
		click_our_prey(prey)

/datum/component/vore/proc/click_fellow_prey(mob/living/prey)
	var/obj/vore_belly/prey_loc = prey.loc
	var/mob/living/pred = prey_loc.owner.parent
	var/mob/living/living_parent = parent

	var/list/options = list("Examine")

	// If not absorbed, able to do these
	if(!HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE) && !HAS_TRAIT_FROM(living_parent, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
		options += list("Interact", "Help Out")

	var/what_to_do = tgui_alert(living_parent, LANG("datum.3614c9eb6db03d70", list(prey)), LANG("datum.7a300d12b3a675f2", null), options)
	// We have to check all of the conditions inside each of these branches because things could have changed while the
	// dialog was open.
	switch(what_to_do)
		if("Examine")
			living_parent.examinate(prey)
		if("Interact")
			if(HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, LANG("datum.3b3de0865a202f9d", list(prey)))
				return
			if(HAS_TRAIT_FROM(living_parent, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, LANG("datum.27b4f63fd62106a3", null))
				return
			living_parent.CtrlShiftClickOn(prey)
		if("Help Out")
			if(HAS_TRAIT_FROM(living_parent, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, LANG("datum.27b4f63fd62106a3", null))
				return
			if(HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, LANG("datum.3b3de0865a202f9d", list(prey)))
				return
			// If they're otherwise incapacitated
			if(living_parent.incapacitated)
				return

			to_chat(living_parent, span_notice(span_green(LANG("datum.2ed26103b7765202", list(prey)))))
			to_chat(prey, span_notice(LANG("datum.6d5664c77f35b0b2", list(living_parent))))
			to_chat(pred, span_warning(LANG("datum.edb591c847bb9028", null)))

			if(do_after(living_parent, 5 SECONDS, pred, timed_action_flags = IGNORE_TARGET_LOC_CHANGE) && prob(33))
				if(prey.loc != prey_loc)
					return
				prey_loc.release(prey)
				to_chat(living_parent, span_notice(span_green(LANG("datum.d5e593d6bd0c0c83", list(prey)))))
				to_chat(prey,  span_notice(span_green(LANG("datum.ef5266367eb27573", list(living_parent)))))
				to_chat(pred, span_alert(LANG("datum.008ee93988944ff7", list(prey))))
			else
				to_chat(living_parent, span_alert(LANG("datum.3ef4a3a8336e3884", list(prey))))
				to_chat(prey, span_alert(LANG("datum.08fbaafed765ee67", list(living_parent))))
				to_chat(pred, span_notice(span_green(LANG("datum.ae7aa1b1a7c547a9", list(prey)))))

/datum/component/vore/proc/click_our_prey(mob/living/prey)
	var/obj/vore_belly/prey_loc = prey.loc
	var/mob/living/living_parent = parent

	var/list/options = list("Examine")

	if(!HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
		options += list("Eject", "Transfer", "Digest", "Absorb")
	else
		options += "Unabsorb"
		if(living_parent.ckey == our_owner_ckey)
			options += "Put In Charge"

	var/what_to_do = tgui_input_list(living_parent, LANG("datum.3614c9eb6db03d70", list(prey)), LANG("datum.7a300d12b3a675f2", null), options)
	// We have to check all of the conditions inside each of these branches because things could have changed while the
	// dialog was open.
	switch(what_to_do)
		if("Examine")
			living_parent.examinate(prey)
		if("Eject")
			if(HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, span_warning(LANG("datum.c94208e85036a841", null)))
				return
			#ifdef VORE_EJECT_DELAY
			to_chat(living_parent, span_notice(LANG("datum.96a7aa884721abb9", list(prey, LOWER_TEXT(prey_loc.name)))))
			to_chat(prey, span_notice(LANG("datum.a91119cf72170d6b", list(living_parent, LOWER_TEXT(prey_loc.name)))))
			if(!do_after(living_parent, VORE_EJECT_DELAY, interaction_key = "vore_eject"))
				return
			#endif
			prey_loc.release(prey)
		if("Transfer")
			if(HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, span_warning(LANG("datum.15770c47a9b261a1", null)))
				return
			var/obj/vore_belly/which_belly = tgui_input_list(living_parent, LANG("datum.de77d72f3b87bdde", null), LANG("datum.e0b6d9105645d6b1", null), vore_bellies)
			if(which_belly && prey.loc == prey_loc)
				prey.forceMove(which_belly)
		if("Digest")
			if(HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, span_warning(LANG("datum.00e8efaeedc7b216", null)))
				return
			if(!REQUIRES_PLAYER && !prey.mind)
				prey_loc.digestion_death(prey)
				return
			var/datum/vore_preferences/prey_vore_prefs = prey.get_vore_prefs()
			if(!prey_vore_prefs)
				to_chat(living_parent, span_warning(LANG("datum.b4dd9394b010e9da", list(prey))))
				return
			if(!prey_vore_prefs.read_preference(/datum/vore_pref/toggle/digestion) || !prey_vore_prefs.read_preference(/datum/vore_pref/toggle/digestion_qdel))
				to_chat(living_parent, span_warning(LANG("datum.b4dd9394b010e9da", list(prey))))
				return

			var/consents = tgui_alert(prey, LANG("datum.d178b7aa9ee6473e", list(living_parent)), LANG("datum.1cf5c85d0e7fae66", null), list("No", "Yes"))
			if(consents == "Yes")
				if(!prey_loc.digestion_death(prey))
					to_chat(living_parent, span_warning(LANG("datum.c6cff1f16030e368", list(prey))))
			else
				to_chat(living_parent, span_warning(LANG("datum.2688fb46f7f7f5ed", list(prey))))
		if("Absorb")
			if(HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, span_warning(LANG("datum.7b77d3a4bfc448d6", list(prey))))
				return
			if(!prey.vore_can_absorb())
				to_chat(living_parent, LANG("datum.d5f5bfa619b26e8f", list(prey)))
				return
			var/consents = tgui_alert(prey, LANG("datum.b714b4a18b76cf5e", list(living_parent)), LANG("datum.073b9c8fcbbeccf1", null), list("No", "Yes"))
			if(consents == "Yes")
				// Get the nutrition
				var/nutrition = prey.nutrition - ABSORB_NUTRITION_BARRIER
				if(nutrition > 0)
					prey.set_nutrition(ABSORB_NUTRITION_BARRIER)
					living_parent.adjust_nutrition(nutrition)
				if(!prey_loc.absorb(prey))
					to_chat(living_parent, LANG("datum.d5f5bfa619b26e8f", list(prey)))
			else
				to_chat(living_parent, span_warning(LANG("datum.2688fb46f7f7f5ed", list(prey))))
		if("Unabsorb")
			if(!HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, span_warning(LANG("datum.e3ef6277fb45bb70", list(prey))))
				return
			if(living_parent.nutrition < ABSORB_NUTRITION_BARRIER)
				to_chat(living_parent, span_warning(LANG("datum.abc86be066b8a3f3", list(prey))))
				return
			living_parent.adjust_nutrition(-ABSORB_NUTRITION_BARRIER)
			prey_loc.unabsorb(prey)
		if("Put In Charge")
			if(living_parent.ckey != our_owner_ckey)
				to_chat(living_parent, span_warning(LANG("datum.0ae2d29895893254", null)))
				return

			if(!HAS_TRAIT_FROM(prey, TRAIT_RESTRAINED, TRAIT_SOURCE_VORE))
				to_chat(living_parent, span_warning(LANG("datum.cdb5c29735532584", list(prey))))
				return

			var/consents = tgui_alert(prey, LANG("datum.88fd61f20038eb05", list(living_parent)), LANG("datum.e83c256d895561f7", null), list("No", "Yes"))
			if(consents == "Yes")
				living_parent.AddComponent(/datum/component/absorb_control, prey)
