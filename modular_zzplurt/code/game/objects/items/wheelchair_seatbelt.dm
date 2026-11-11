// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/vehicle/ridden/wheelchair
	var/has_seatbelt = FALSE
	var/seatbelt_engaged = FALSE
	var/last_collision_time	= 0
	var/collision_cooldown = 2 SECONDS
	var/last_stamina_damage_time = 0
	var/stamina_damage_cooldown	= 1	SECONDS
	var/examine_more_info =	"Left-click: Remove	occupant | Right-click:	Toggle seatbelt"

/obj/vehicle/ridden/wheelchair/Initialize(mapload)
	. = ..()
	has_seatbelt = TRUE

/obj/vehicle/ridden/wheelchair/examine(mob/user)
	. = ..()
	if(has_seatbelt)
		. += span_notice(examine_more_info)

/obj/vehicle/ridden/wheelchair/attack_hand(mob/living/user,	list/modifiers)
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		return remove_mob(user)
	return ..()

/obj/vehicle/ridden/wheelchair/proc/remove_mob(mob/living/user)
	if(!buckled_mobs.len)
		to_chat(user, span_warning(LANG("obj.1c9e8b13bbfe3e9a", null)))
		return
	var/mob/living/M = buckled_mobs[1]
	if(has_seatbelt	&& seatbelt_engaged)
		to_chat(user, span_warning(LANG("obj.22c57e3caff158a0", null)))
		return
	to_chat(user, span_notice(LANG("obj.db1550adbb111220", list(M))))
	if(do_after(user, 3	SECONDS, target	= src))
		unbuckle_mob(M)
		to_chat(user, span_notice(LANG("obj.95cdc9725aadedbe", list(M))))
		to_chat(M, span_notice(LANG("obj.0863a6c454bdc8a0", list(user))))
	else
		to_chat(user, span_warning(LANG("obj.843208578f1021ef", list(M))))

/obj/vehicle/ridden/wheelchair/proc/toggle_seatbelt(mob/living/user)
	if(!buckled_mobs.len)
		to_chat(user, span_warning(LANG("obj.1c9e8b13bbfe3e9a", null)))
		return
	var/action = seatbelt_engaged ?	"disengage"	: "engage"
	to_chat(user, span_notice(LANG("obj.092cab0a0ec07239", list(action))))
	if(do_after(user, 3	SECONDS, target	= src))
		seatbelt_engaged = !seatbelt_engaged
		to_chat(user, span_notice(LANG("obj.49a43509fd1fd5f8", list(seatbelt_engaged ? "engage"	: "disengage"))))
		playsound(src, 'modular_zzplurt/sound/items/buckling_seatbelt.ogg',	50,	TRUE)
		for(var/mob/living/M in buckled_mobs)
			to_chat(M, span_notice(LANG("obj.fc0f43954a287ced", list(user, seatbelt_engaged ? "engages" : "disengages"))))
	else
		to_chat(user, span_warning(LANG("obj.63de33ffc98eddc0", list(action))))

/obj/vehicle/ridden/wheelchair/unbuckle_mob(mob/living/buckled_mob,	force =	FALSE, can_fall	= TRUE)
	if(has_seatbelt	&& seatbelt_engaged	&& !force)
		to_chat(buckled_mob, span_warning(LANG("obj.72e9377eddddca69", null)))
		return FALSE
	return ..()

/obj/vehicle/ridden/wheelchair/post_buckle_mob(mob/living/user)
	. =	..()
	if(has_seatbelt)
		to_chat(user, span_notice(LANG("obj.4a45866834da39b5", null)))

/obj/vehicle/ridden/wheelchair/relaymove(mob/living/user, direction)
	if(world.time <	last_collision_time	+ collision_cooldown)
		to_chat(user, span_warning(LANG("obj.d85818eeefa14e96", null)))
		return FALSE
	return ..()

/obj/vehicle/ridden/wheelchair/Bump(atom/A)
	. =	..()
	if(world.time <	last_stamina_damage_time + stamina_damage_cooldown)
		return
	last_stamina_damage_time = world.time
	for(var/mob/living/M in buckled_mobs)
		M.apply_damage(30, STAMINA)
		to_chat(M, span_warning(LANG("obj.84a5dbee85623f1a", null)))
	if(has_seatbelt	&& seatbelt_engaged)
		last_collision_time	= world.time
		for(var/mob/living/M in buckled_mobs)
			to_chat(M, span_warning(LANG("obj.913d8e924b4bf490", list(A))))
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
	else
		handle_collision(A)
	if(ismob(A))
		var/mob/M =	A
		handle_mob_bump(M)

/obj/vehicle/ridden/wheelchair/proc/handle_mob_bump(mob/living/L)
	if(!istype(L))
		return
	var/damage = rand(3, 7)
	L.apply_damage(damage, BRUTE)
	L.Knockdown(0.5	SECONDS)
	to_chat(L, span_danger(LANG("obj.067bfa29f556cc2d", list(src))))
	if(buckled_mobs.len)
		var/mob/living/user	= buckled_mobs[1]
		to_chat(user, span_warning(LANG("obj.d4e05dd28fe72d97", list(L))))

/obj/vehicle/ridden/wheelchair/proc/handle_collision(atom/A)
	for(var/mob/living/passenger in buckled_mobs)
		if(!passenger.buckled)
			continue
		passenger.apply_damage(30, STAMINA)
		unbuckle_mob(passenger)
		var/damage = rand(5, 15)
		passenger.apply_damage(damage, BRUTE)
		var/throw_dir =	get_dir(src, A)
		var/turf/T = get_step(src, throw_dir)
		passenger.throw_at(T, 2, 2)
		to_chat(passenger, span_danger(LANG("obj.b3d27302e97a9910", list(A))))
	playsound(src, 'sound/effects/bang.ogg', 50, TRUE)

/obj/vehicle/ridden/wheelchair/Initialize(mapload)
	. =	..()
	has_seatbelt = TRUE

/obj/vehicle/ridden/wheelchair/proc/add_seatbelt_action(mob/living/user)
	var/datum/action/seatbelt_toggle/SB	= new(src)
	SB.Grant(user)

/obj/vehicle/ridden/wheelchair/proc/remove_seatbelt_action(mob/living/user)
	for(var/datum/action/A in user.actions)
		if(istype(A, /datum/action/seatbelt_toggle))
			A.Remove(user)

/datum/action/seatbelt_toggle
	name = "Toggle Seatbelt"
	button_icon	= 'icons/mob/actions/actions_vehicle.dmi'
	button_icon_state =	"seatbelt"

/datum/action/seatbelt_toggle/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	if(istype(owner, /mob/living))
		var/mob/living/L = owner
		if(istype(L.buckled, /obj/vehicle/ridden/wheelchair))
			var/obj/vehicle/ridden/wheelchair/W	= L.buckled
			W.toggle_seatbelt(L)

/mob/living/examine(mob/user)
	. =	..()
	if(buckled && istype(buckled, /obj/vehicle/ridden/wheelchair))
		var/obj/vehicle/ridden/wheelchair/W	= buckled
		if(W.has_seatbelt && W.seatbelt_engaged)
			. += span_notice(LANG("mob.0ab59c64b907c5b9", list(p_they(TRUE), p_are())))

/obj/vehicle/ridden/wheelchair/attack_hand_secondary(mob/user, list/modifiers)
	if(has_seatbelt)
		toggle_seatbelt(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()
