// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define MAXIMUM_LEAP_DISTANCE 4
#define LEAP_RECHARGE_TIME 2 SECONDS
#define LEAP_SPOOLUP_TIME 0.1 SECONDS

#define IDLE 0
#define ON_COOLDOWN 1

/obj/item/dogborg/pounce
	name = "pounce"
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "pounce"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	desc = "Leap at your target to momentarily stun them."
	force = 0
	throwforce = 0

	var/system_status = IDLE
	var/leap_at

/mob/living/silicon/robot/
	/// Is this dogborg currently leaping?
	var/leaping = FALSE

/obj/item/dogborg/pounce/New()
	..()
	item_flags |= NOBLUDGEON
	if(!(icon_state in icon_states(icon)))
		icon_state = "jaws"

/obj/item/dogborg/pounce/ranged_interact_with_atom(atom/interacting_with, mob/living/user)
	var/mob/living/silicon/robot/this_robot = user
	if(!this_robot)
		return
	switch(system_status)
		if(IDLE)
			system_status = ON_COOLDOWN
			to_chat(this_robot, LANG("obj.afb5ea14ac502845", list(interacting_with)))
			addtimer(CALLBACK(this_robot, TYPE_PROC_REF(/mob/living/silicon/robot, leap_at), interacting_with, LEAP_SPOOLUP_TIME))
			spawn(LEAP_RECHARGE_TIME)
				system_status = IDLE
		if(ON_COOLDOWN)
			to_chat(this_robot, LANG("obj.c388746aa3e06a09", null))

/mob/living/silicon/robot/proc/leap_at(atom/this_atom)
	if(leaping || stat || buckled)
		return
	if(!has_gravity(src) || !has_gravity(this_atom))
		to_chat(src,LANG("mob.1e497da5ea2793ca", null))
		return
	if(cell.charge <= 750)
		to_chat(src,LANG("mob.320ea108828c238a", null))
		return
	else
		leaping = TRUE
		pixel_y = 10
		update_icons()
		throw_at(this_atom, MAXIMUM_LEAP_DISTANCE, 1, spin = 0, diagonals_first = 1)
		cell.use(750)

/mob/living/silicon/robot/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!leaping)
		return ..()
	if(hit_atom)
		if(isliving(hit_atom))
			var/mob/living/hit_living = hit_atom
			hit_living.visible_message(LANG("mob.95e600ab2ddf4dd1", list(src, hit_living)), LANG("mob.0399074a29cc9abc", list(src)))
			hit_living.Knockdown(50)
			playsound(src, 'sound/effects/sparks/sparks4.ogg', 50, 1, -1)
			step_towards(src,hit_living)
			log_combat(src, hit_living, "borg pounced")
		else if(hit_atom.density && !hit_atom.CanPass(src))
			visible_message(LANG("mob.191bc885ce1dff0f", list(src, hit_atom)), LANG("mob.116b010f31d168b9", list(hit_atom)))
			playsound(src, 'sound/items/trayhit/trayhit1.ogg', 50, 1)
			Knockdown(30, 1, 1)
		if(leaping)
			leaping = FALSE
			pixel_y = initial(pixel_y)
			update_icons()

#undef MAXIMUM_LEAP_DISTANCE
#undef LEAP_RECHARGE_TIME
#undef LEAP_SPOOLUP_TIME

#undef IDLE
#undef ON_COOLDOWN
