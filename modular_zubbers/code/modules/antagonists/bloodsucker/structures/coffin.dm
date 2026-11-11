// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/antagonist/bloodsucker/proc/can_claim_coffin(obj/structure/closet/crate/claimed, area/current_area)
	if(coffin)
		return FALSE
	// ALREADY CLAIMED
	if(claimed.resident)
		if(claimed.resident != owner.current)
			claimed.balloon_alert(owner.current, LANG("datum.0a9e538756315212", null))
		return FALSE
	if(!(GLOB.the_station_areas.Find(current_area.type)))
		claimed.balloon_alert(owner.current, LANG("datum.6825482388a254bb", null))
		return
	return TRUE

/datum/antagonist/bloodsucker/proc/claim_coffin(obj/structure/closet/crate/claimed, area/current_area)
	if(!can_claim_coffin(claimed, current_area))
		return FALSE
	// This is my Haven
	coffin = claimed
	bloodsucker_haven_area = current_area
	to_chat(owner, span_userdanger(LANG("datum.8a4b9e2f4cb591c1", list(claimed, bloodsucker_haven_area))))
	to_chat(owner, span_announce(LANG("datum.deef0cc631cb02fa", null)))
	return TRUE

/// From crate.dm
/obj/structure/closet/crate
	breakout_time = 20 SECONDS
	///The resident (owner) of this crate/coffin.
	var/mob/living/resident
	///The time it takes to pry this open with a crowbar.
	var/pry_lid_timer = 25 SECONDS

/obj/structure/closet/crate/coffin/examine(mob/user)
	. = ..()
	if(user == resident)
		. += span_cult(LANG("obj.579e2629c843e5ea", null))
		. += span_cult(LANG("obj.a10789a3f55b3834", null))
		. += span_cult(LANG("obj.815030028a9dd9fa", null))
		. += span_cult(LANG("obj.dca160715a82106a", null))
		. += span_cult(LANG("obj.3f259aa1a5fba907", null))

/obj/structure/closet/crate/coffin/blackcoffin
	name = "black coffin"
	desc = "For those departed who are not so dear."
	icon_state = "coffin"
	icon = 'modular_zubbers/icons/obj/structures/vamp_obj.dmi'
	open_sound = 'modular_zubbers/sound/machines/coffin_open.ogg'
	close_sound = 'modular_zubbers/sound/machines/coffin_close.ogg'
	breakout_time = 30 SECONDS
	pry_lid_timer = 20 SECONDS
	resistance_flags = NONE
	material_drop = /obj/item/stack/sheet/iron
	material_drop_amount = 2
	armor_type = /datum/armor/blackcoffin
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 5, /datum/material/iron = SHEET_MATERIAL_AMOUNT)

/datum/armor/blackcoffin
	melee = 50
	bullet = 20
	laser = 30
	bomb = 50
	fire = 70
	acid = 60

/obj/structure/closet/crate/coffin/securecoffin
	name = "secure coffin"
	desc = "For those too scared of having their place of rest disturbed."
	icon_state = "securecoffin"
	base_icon_state = "securecoffin"
	icon = 'modular_zubbers/icons/obj/structures/vamp_obj.dmi'
	open_sound = 'modular_zubbers/sound/machines/coffin_open.ogg'
	close_sound = 'modular_zubbers/sound/machines/coffin_close.ogg'
	breakout_time = 35 SECONDS
	pry_lid_timer = 35 SECONDS
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF
	material_drop = /obj/item/stack/sheet/iron
	material_drop_amount = 2
	armor_type = /datum/armor/securecoffin
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5.5, /datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT * 5)

/datum/armor/securecoffin
	melee = 35
	bullet = 20
	laser = 20
	bomb = 100
	fire = 100
	acid = 100

/obj/structure/closet/crate/coffin/meatcoffin
	name = "meat coffin"
	desc = "When you're ready to meat your maker, the steaks can never be too high."
	icon_state = "meatcoffin"
	base_icon_state = "meatcoffin"
	icon = 'modular_zubbers/icons/obj/structures/vamp_obj.dmi'
	resistance_flags = FIRE_PROOF
	open_sound = 'sound/effects/footstep/slime1.ogg'
	close_sound = 'sound/effects/footstep/slime1.ogg'
	breakout_time = 25 SECONDS
	pry_lid_timer = 20 SECONDS
	material_drop = /obj/item/food/meat/slab/human
	material_drop_amount = 3
	armor_type = /datum/armor/meatcoffin
	custom_materials = list(
		/datum/material/meat = SHEET_MATERIAL_AMOUNT * 20,
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 1.5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.5,
	)

/datum/armor/meatcoffin
	melee = 70
	bullet = 10
	laser = 10
	bomb = 70
	fire = 70
	acid = 60

/obj/structure/closet/crate/coffin/metalcoffin
	name = "metal coffin"
	desc = "A big metal sardine can inside of another big metal sardine can, in space."
	icon_state = "metalcoffin"
	base_icon_state = "metalcoffin"
	icon = 'modular_zubbers/icons/obj/structures/vamp_obj.dmi'
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	open_sound = 'sound/effects/pressureplate.ogg'
	close_sound = 'sound/effects/pressureplate.ogg'
	breakout_time = 25 SECONDS
	pry_lid_timer = 30 SECONDS
	material_drop = /obj/item/stack/sheet/iron
	material_drop_amount = 5
	armor_type = /datum/armor/metalcoffin
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7)

/datum/armor/metalcoffin
	melee = 40
	bullet = 15
	laser = 50
	bomb = 10
	fire = 70
	acid = 60

//////////////////////////////////////////////

/// NOTE: This can be any coffin that you are resting AND inside of.
/obj/structure/closet/crate/coffin/proc/claim_coffin(mob/living/claimant, area/current_area)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = IS_BLOODSUCKER(claimant)
	// Successfully claimed?
	if(bloodsuckerdatum.claim_coffin(src, current_area))
		resident = claimant
		anchored = TRUE
		if(!(interaction_flags_click & ALLOW_RESTING))
			interaction_flags_click = interaction_flags_click | ALLOW_RESTING
		START_PROCESSING(SSprocessing, src)
		return TRUE
	return FALSE

/obj/structure/closet/crate/coffin/Destroy()
	unclaim_coffin()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/closet/crate/coffin/process()
	. = ..()
	if(!.)
		return FALSE
	var/list/turf/area_turfs = get_area_turfs(get_area(src))
	// Create Dirt etc.
	var/turf/T_Dirty = pick(area_turfs)
	if(T_Dirty && !T_Dirty.density)
		// Default: Dirt
		// STEP ONE: COBWEBS
		// CHECK: Wall to North?
		var/turf/check_N = get_step(T_Dirty, NORTH)
		if(istype(check_N, /turf/closed/wall))
			// CHECK: Wall to West?
			var/turf/check_W = get_step(T_Dirty, WEST)
			if(istype(check_W, /turf/closed/wall))
				new /obj/effect/decal/cleanable/cobweb(T_Dirty)
			// CHECK: Wall to East?
			var/turf/check_E = get_step(T_Dirty, EAST)
			if(istype(check_E, /turf/closed/wall))
				new /obj/effect/decal/cleanable/cobweb/cobweb2(T_Dirty)
		new /obj/effect/decal/cleanable/dirt(T_Dirty)

/obj/structure/closet/crate/proc/unclaim_coffin(manual = FALSE, silent = FALSE)
	// Unanchor it (If it hasn't been broken, anyway)
	anchored = FALSE
	if(!resident || !resident.mind)
		return
	un_enlarge(resident)
	// Unclaiming
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = IS_BLOODSUCKER(resident)
	if(bloodsuckerdatum && bloodsuckerdatum.coffin == src)
		bloodsuckerdatum.coffin = null
		bloodsuckerdatum.bloodsucker_haven_area = null
	for(var/obj/structure/bloodsucker/bloodsucker_structure in get_area(src))
		if(bloodsucker_structure.owner == resident)
			bloodsucker_structure.unbolt()
	if(!silent)
		if(manual)
			to_chat(resident, span_cult_italic(LANG("obj.ec8bf708c49d5811", null)))
		else
			to_chat(resident, span_cult_italic(LANG("obj.8cb096bc1b9ec7ee", null)))
	// Remove resident. Because this object isnt removed from the game immediately (GC?) we need to give them a way to see they don't have a home anymore.
	resident = null
	if(interaction_flags_click & ALLOW_RESTING)
		interaction_flags_click = interaction_flags_click & ~ALLOW_RESTING

/// You cannot lock in/out a coffin's owner. SORRY.
/obj/structure/closet/crate/coffin/can_open(mob/living/user)
	if(!locked)
		return ..()
	if(user == resident)
		if(welded)
			welded = FALSE
			update_icon()
		locked = FALSE
		return TRUE
	playsound(get_turf(src), 'modular_zubbers/sound/machines/coffin_locked.ogg', 20, 1)
	to_chat(user, span_notice(LANG("obj.8d091e470c67a22c", list(src))))

/obj/structure/closet/crate/coffin/close(mob/living/user)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = IS_BLOODSUCKER(user)
	if(bloodsuckerdatum && user.has_quirk(/datum/quirk/oversized))
		if(!HAS_TRAIT_FROM_ONLY(src, TRAIT_COFFIN_ENLARGED, "bloodsucker_coffin"))
			if(prompt_coffin_claim(bloodsuckerdatum))
				enlarge(user)
			else
				user.balloon_alert(user, LANG("obj.0a9e538756315212", null))
	. = ..()
	if(!.)
		return FALSE
	for(var/atom/thing as anything in contents)
		SEND_SIGNAL(thing, COMSIG_ENTER_COFFIN, src, user)
	return TRUE

// /obj/structure/closet/crate/coffin/proc/is_claimable_coffin(datum/antagonist/bloodsucker/dracula, area/current_area)
// 	if(!dracula)
// 		return FALSE
// 	if(resident == dracula.owner.current)
// 		return TRUE
// 	if(!dracula.can_claim_coffin(src, current_area))
// 		return FALSE
// 	if(!dracula.coffin && resident)
// 		return FALSE
// 	return TRUE

/obj/structure/closet/crate/coffin/proc/prompt_coffin_claim(datum/antagonist/bloodsucker/dracula)
	var/area/current_area = get_area(src)
	switch(tgui_alert(dracula.owner.current, LANG("obj.c70f2612c760add3", list(current_area)), LANG("obj.5d11672262003783", null), list("Yes", "No")))
		if("Yes")
			return claim_coffin(dracula.owner.current, current_area)
	return FALSE

// some fatass bloodsucker is trying to fit in a too-small coffin, how about we make some room?
/obj/structure/closet/crate/proc/enlarge(mob/living/user)
	ADD_TRAIT(src, TRAIT_COFFIN_ENLARGED, "bloodsucker_coffin")
	to_chat(user, span_warning(LANG("obj.271ab668603b43a5", null)))
	playsound(src, 'modular_skyrat/modules/aesthetics/airlock/sound/creaking.ogg')
	animate(src, 1 SECONDS, FALSE, BOUNCE_EASING, transform = transform.Scale(1.5))

/obj/structure/closet/crate/proc/un_enlarge(mob/living/user)
	if(!HAS_TRAIT_FROM_ONLY(src, TRAIT_COFFIN_ENLARGED, "bloodsucker_coffin"))
		return
	REMOVE_TRAIT(src, TRAIT_COFFIN_ENLARGED, "bloodsucker_coffin")
	max_mob_size = initial(max_mob_size)
	var/matrix/normal
	// transform.Scale(user.mob_size * (COFFIN_ENLARGE_MULT + 1)
	animate(src, 1 SECONDS, FALSE, transform = normal)

/// You cannot weld or deconstruct an owned coffin. Only the owner can destroy their own coffin.
/obj/structure/closet/crate/coffin/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(resident && anchored)
		to_chat(user, span_danger(LANG("obj.ca785180c7c8b083", list(user == resident ? " You can Alt-Click to unclaim and unwrench your Coffin." : ""))))
		return TRUE
	. = ..()

/obj/structure/closet/crate/coffin/crowbar_act(mob/living/user, obj/item/tool)
	if(locked)
		var/pry_time = pry_lid_timer * tool.toolspeed // Pry speed must be affected by the speed of the tool.
		user.visible_message(
			span_notice(LANG("obj.58393b532dd78b9b", list(user, src, tool))),
			span_notice(LANG("obj.47fe818b086e8836", list(src, tool, DisplayTimeText(pry_time))))
		)
		if(!do_after(user, pry_time, src))
			return TRUE
		bust_open()
		user.visible_message(
			span_notice(LANG("obj.b5f0884d7eeb7ac4", list(user, src))),
			span_notice(LANG("obj.cae0ba3f07b59c14", list(src)))
		)
		return TRUE
	if(!resident)
		. = ..()

/obj/structure/closet/crate/coffin/welder_act(mob/living/user, obj/item/tool)
	if(user != resident)
		if(istype(tool, cutting_tool))
			to_chat(user, span_notice(LANG("obj.5e78b6dfd66aa75b", list(src))))
			return TRUE
	. = ..()

/// Forces the coffin to get contents
/obj/structure/closet/proc/force_enter(mob/living/user)
	SEND_SIGNAL(src, COMSIG_CLOSET_PRE_CLOSE, user)
	take_contents()
	var/inserted = insert(user)
	playsound(loc, close_sound, close_sound_volume, TRUE, -3)
	opened = FALSE
	set_density(TRUE)
	animate_door(TRUE)
	update_appearance()
	after_close(user)
	SEND_SIGNAL(src, COMSIG_CLOSET_POST_CLOSE, user)
	return inserted

/// Distance Check (Inside Of)
/obj/structure/closet/crate/coffin/click_alt(mob/user)
	. = ..()
	if(user in src)
		LockMe(user, !locked)
		return CLICK_ACTION_SUCCESS

	if(user == resident && user.Adjacent(src))
		balloon_alert(user, LANG("obj.ef63d7d41b8fd8c7", null))
		var/static/list/unclaim_options = list(
			"Yes" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_yes"),
			"No" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_no"))
		var/unclaim_response = show_radial_menu(user, src, unclaim_options, radius = 36, require_near = TRUE)
		switch(unclaim_response)
			if("Yes")
				unclaim_coffin(TRUE)
	return CLICK_ACTION_SUCCESS

/obj/structure/closet/crate/proc/LockMe(mob/user, inLocked = TRUE)
	if(user == resident)
		if(!broken)
			locked = inLocked
			if(locked)
				to_chat(user, span_notice(LANG("obj.fbd41ae314d5a76c", list(src))))
			else
				to_chat(user, span_notice(LANG("obj.e07149fec5ccd1af", list(src))))
			return TRUE
		// Broken? Let's fix it.
		to_chat(resident, span_notice(LANG("obj.4e8322239ed1235e", list(src))))
		if(!do_after(resident, 5 SECONDS, src))
			to_chat(resident, span_notice(LANG("obj.3eb645e119d6be38", list(src))))
			return FALSE
		to_chat(resident, span_notice(LANG("obj.8256519e13e43032", null)))
		broken = FALSE
		locked = TRUE
		return TRUE
