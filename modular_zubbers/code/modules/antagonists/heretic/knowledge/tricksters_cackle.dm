// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// prestidigitation
/datum/heretic_knowledge/spell/tricksters_cackle
	name = "Trickster's Promise"
	desc = "Allows you to pick from a small list of party tricks and somewhat useful abilities, such as cleaning, confetti, etc. Right click to select the mode. Left click to cast. (Can be casted without a focus)"
	gain_text = "The Trickster, true to its name, is a trickster. It always holds a deck of cards, or perhaps a paintbrush. Offer a smile and a wink to the god, \
	and it might just grant you its promise."
	drafting_tier = 1
	drafting_cost = 1 // has actual uses - free cleaning? free synth-compatible healing? yes please
	action_to_add = /datum/action/cooldown/spell/pointed/tricksters_cackle

/datum/action/cooldown/spell/pointed/tricksters_cackle
	name = "Trickster's Promise"
	desc = "Allows you to pick from a small list of party tricks and vaguely useful abilities. Right click to select the mode. Left click to cast."
	var/static/list/modes = list(
		"Spawn Confetti" = 5 SECONDS,
		"Clean" = 2 SECONDS,
		"Add A Glow To Any Item" = 10 SECONDS,
		"Enhance Taste & Add Healing To Food" = 50 SECONDS,
		//"ignite" = list(10 SECONDS, image(icon = 'icons/obj/cigarettes.dmi', icon_state = "zippo")),
	)
	var/static/list/modes_to_images = list(
		"Spawn Confetti" = image(icon = 'icons/obj/toys/toy.dmi', icon_state = "party_popper"),
		"Clean" = image(icon = 'icons/obj/watercloset.dmi', icon_state = "soap"),
		"Add A Glow To Any Item" = image(icon = 'icons/obj/lighting.dmi', icon_state = "lantern"),
		"Enhance Taste & Add Healing To Food" = image(icon = 'icons/obj/food/burgerbread.dmi', icon_state = "hburger"),
		//"ignite" = list(10 SECONDS, image(icon = 'icons/obj/cigarettes.dmi', icon_state = "zippo")),
	)
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/obj/food/burgerbread.dmi'
	sound = null
	school = SCHOOL_EVOCATION // no focus needed babe
	antimagic_flags = MAGIC_RESISTANCE
	invocation_type = INVOCATION_NONE // sneaky spell
	spell_requirements = NONE
	button_icon_state = "hburger"
	cooldown_time = 5 SECONDS
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS

	var/mode = "Spawn Confetti"

/datum/action/cooldown/spell/pointed/tricksters_cackle/Trigger(mob/clicker, trigger_flags, atom/target)
	var/right_clicked = !!(trigger_flags & TRIGGER_SECONDARY_ACTION)
	if (right_clicked)
		mode = show_radial_menu(clicker, clicker, modes_to_images)
		if (isnull(mode))
			return TRUE
		cooldown_time = modes[mode]
		clicker.balloon_alert(clicker, LANG("datum.e692b9c0125a3236", list(LOWER_TEXT(mode))))
		return TRUE
	else
		return ..()

/datum/action/cooldown/spell/pointed/tricksters_cackle/is_valid_target(atom/cast_on)
	return TRUE // self casting is a-ok

/datum/action/cooldown/spell/pointed/tricksters_cackle/cast(atom/cast_on)
	. = ..()

	switch (mode)
		if ("Spawn Confetti")
			var/turf/start = owner.loc
			var/range = 3
			if (!istype(start))
				return FALSE

			var/obj/effect/decal/chempuff/reagent_puff = new(start)
			reagent_puff.create_reagents(500)
			reagent_puff.reagents.add_reagent(/datum/reagent/confetti, 15)
			reagent_puff.user = owner
			reagent_puff.stream = FALSE

			var/turf/target_turf = get_turf(cast_on)
			if(target_turf == start) // Don't need to bother movelooping if we don't move
				reagent_puff.setDir(owner.dir)
				reagent_puff.spray_down_turf(target_turf)
				reagent_puff.end_life()
				return

			var/datum/move_loop/our_loop = GLOB.move_manager.move_towards_legacy(reagent_puff, cast_on, 2, timeout = range * 2, flags = MOVEMENT_LOOP_START_FAST, priority = MOVEMENT_ABOVE_SPACE_PRIORITY)
			reagent_puff.RegisterSignal(our_loop, COMSIG_QDELETING, TYPE_PROC_REF(/obj/effect/decal/chempuff, loop_ended))
			reagent_puff.RegisterSignal(our_loop, COMSIG_MOVELOOP_POSTPROCESS, TYPE_PROC_REF(/obj/effect/decal/chempuff, check_move))

			playsound(owner, 'sound/effects/snap.ogg', 30)

			owner.visible_message(
				span_warning(LANG("datum.9fa42bc0cdfda776", list(owner, owner.p_their(), owner.p_their()))),
				span_notice(LANG("datum.a611de9bdc565f02", null))
			)
			return TRUE
		if ("Clean")
			if (!cast_on.Adjacent(owner))
				owner.balloon_alert(owner, LANG("datum.f5e75781e8f1dc46", null))
				return FALSE
			cast_on.wash(CLEAN_SCRUB)
			owner.visible_message(
				span_warning(LANG("datum.7b9ec4e099499e8c", list(owner, owner.p_their(), cast_on))),
				span_notice(LANG("datum.67ef2f4c494b743f", list(cast_on)))
			)
			cast_on.balloon_alert_to_viewers(LANG("datum.484fe294f70e4261", null))
			return TRUE
		if ("Add A Glow To Any Item")
			if (!cast_on.Adjacent(owner))
				owner.balloon_alert(owner, LANG("datum.f5e75781e8f1dc46", null))
				return FALSE
			if (!isitem(cast_on))
				owner.balloon_alert(owner, LANG("datum.4f235f088ae71d9c", null))
				return FALSE
			if (cast_on.light != null)
				owner.balloon_alert(owner, LANG("datum.f95b5b3a00391c2e", null))
				return FALSE
			cast_on.set_light(
				3,
				3,
				"#ffcc66"
			)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unset_trickster_light), cast_on), 120 SECONDS)
			owner.visible_message(
				span_warning(LANG("datum.029958f00080a8bd", list(owner, owner.p_their(), cast_on))),
				span_notice(LANG("datum.17713b50b6ac87c8", list(cast_on)))
			)
			cast_on.balloon_alert_to_viewers(LANG("datum.35cb92e9d1c46a40", null))
			return TRUE
		if ("Enhance Taste & Add Healing To Food")
			if (!cast_on.Adjacent(owner))
				owner.balloon_alert(owner, LANG("datum.f5e75781e8f1dc46", null))
				return FALSE
			if (!IS_EDIBLE(cast_on))
				owner.balloon_alert(owner, LANG("datum.01aad7513918186a", null))
				return FALSE
			if (HAS_TRAIT(cast_on, TRAIT_TRICKSTER_TASTE))
				owner.balloon_alert(owner, LANG("datum.b1959eb8347da277", null))
				return FALSE
			ADD_TRAIT(cast_on, TRAIT_TRICKSTER_TASTE, REF(src))
			cast_on.reagents?.add_reagent(/datum/reagent/medicine/omnizine/heretic, 5)

			owner.visible_message(
				span_warning(LANG("datum.c308f8f68d140593", list(owner, owner.p_their(), cast_on))),
				span_notice(LANG("datum.4e6de341b1ad873a", list(cast_on)))
			)

			RegisterSignal(cast_on, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, PROC_REF(get_food_boost))

			cast_on.balloon_alert_to_viewers(LANG("datum.b0623b6cac60c7bc", null))

			return TRUE

	return FALSE

/datum/reagent/medicine/omnizine/heretic
	name = "Trickster's Cackle"
	description = "Laugh, laugh, laugh it off! It's all just a play, anyway!"
	color = "#d8c7b7"
	healing = 0.3 // slightly better than protozine
	chemical_flags = NONE // synths can heal from it
	process_flags = REAGENT_ORGANIC|REAGENT_SYNTHETIC

/datum/reagent/medicine/omnizine/heretic/on_mob_metabolize(mob/living/affected_mob)
	. = ..()

	affected_mob.emote("laugh")

/datum/action/cooldown/spell/pointed/proc/get_food_boost(datum/signal_source, list/extra_complexity)
	SIGNAL_HANDLER

	extra_complexity[1] = extra_complexity[1] + 2 // bonus

/proc/unset_trickster_light(atom/target)
	target.set_light(
		0,
		0
	)
	target.visible_message(span_warning(LANG("_root.c0346e98d56912df", list(target))))
