// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Donator reward for UltramariFox
/obj/item/cigarette/khi
	name = "\improper Kitsuhana Singularity cigarette"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "khioff"
	icon_on = "khion"
	icon_off = "khioff"
	type_butt = /obj/item/cigbutt/khi
	list_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/toxin/mindbreaker = 5)

/obj/item/cigbutt/khi
	icon = 'modular_skyrat/master_files/icons/obj/cigarettes_khi.dmi'
	icon_state = "khibutt"

/obj/item/storage/fancy/cigarettes/khi
	name = "\improper Kitsuhana Singularity packet"
	icon = 'modular_skyrat/master_files/icons/obj/cigarettes_khi.dmi'
	icon_state = "khi_cig_packet"
	base_icon_state = "khi_cig_packet"
	spawn_type = /obj/item/cigarette/khi

//Donator reward for Stonetear
/obj/item/hairbrush/switchblade
	name = "switchcomb"
	icon = 'modular_skyrat/master_files/icons/donator/obj/custom.dmi'
	icon_state = "switchblade"
	base_icon_state = "switchblade"
	desc = "A sharp, concealable, spring-loaded comb."
	hitsound = 'sound/items/weapons/genhit.ogg'
	resistance_flags = FIRE_PROOF
	var/extended = FALSE

/obj/item/hairbrush/switchblade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

///This is called when you transform it
/obj/item/hairbrush/switchblade/attack_self(mob/user, modifiers)
	extended = !extended
	icon_state = "switchblade[extended ? "_on" : ""]"

	playsound(user || src, 'sound/items/weapons/batonextend.ogg', 30, TRUE)


/// This makes it so you have to extend it.
/obj/item/hairbrush/switchblade/attack(mob/target, mob/user)
	if(!extended)
		to_chat(user, span_warning(LANG("obj.d8e59ffaaeddd4fd", null)))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	if(target.stat == DEAD)
		to_chat(user, span_warning(LANG("obj.227e6d840edff6e2", null)))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	brush(target, user)

	return COMPONENT_CANCEL_ATTACK_CHAIN


#define TURN_DIAL 		0
#define TAP_SCREEN		1
#define PRESS_KEYS		2
#define EXTEND_ANTENNA	3
#define SLAP_SIDE		4

/obj/item/donator/transponder
	name = "broken Helian transponder"
	desc = "Used by Helians to communicate with their mothership, the screen is cracked and its edges scuffed. This one has seen better days."
	icon = 'modular_skyrat/master_files/icons/donator/obj/custom.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/donator/mob/clothing/custom_w.dmi'
	lefthand_file = 'modular_skyrat/master_files/icons/donator/mob/inhands/donator_left.dmi'
	righthand_file = 'modular_skyrat/master_files/icons/donator/mob/inhands/donator_right.dmi'
	icon_state = "transponder"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	var/datum/effect_system/basic/spark_spread/sparks
	var/current_state = TURN_DIAL
	var/next_activate = 0

/obj/item/donator/transponder/Initialize(mapload)
	. = ..()
	sparks = new(src, 2, FALSE)
	sparks.attach(src)
	sparks.start()

/obj/item/donator/transponder/Destroy()
	if(sparks)
		QDEL_NULL(sparks)
	return ..()

/obj/item/donator/transponder/attack_self(mob/user)
	if(QDELETED(src) || (next_activate > world.time))
		return FALSE

	add_fingerprint(user)

	switch(current_state)
		if(TURN_DIAL)
			user.visible_message(
				LANG("obj.df800fbba5d34205", list(icon2html(src, oviewers(2, user)), user, src)),
				LANG("obj.fcc5b6b1909a06ae", list(icon2html(src, user))),
				vision_distance=2)
			playsound(user, 'modular_skyrat/master_files/sound/effects/bab1.ogg', 100, TRUE)
			sparks.start()
			current_state = TAP_SCREEN
			next_activate = world.time + 20
			return
		if(TAP_SCREEN)
			user.visible_message(
				LANG("obj.2599decfe81aee1e", list(icon2html(src, oviewers(2, user)), user, src, src)),
				LANG("obj.b948dcdf58cb5eb1", list(icon2html(src, user))),
				vision_distance=2)
			playsound(user, 'modular_skyrat/master_files/sound/effects/platform_call.ogg', 100, TRUE)
			current_state = PRESS_KEYS
			next_activate = world.time + 20
			return
		if(PRESS_KEYS)
			user.visible_message(
				LANG("obj.90d39fd707337a7d", list(icon2html(src, oviewers(2, user)), user, src)),
				LANG("obj.f2fa258d102af1ad", list(icon2html(src, user))),
				vision_distance=2)
			sparks.start()
			playsound(user, 'modular_skyrat/master_files/sound/effects/gmalfunction.ogg', 100, TRUE)
			current_state = EXTEND_ANTENNA
			next_activate = world.time + 20
			return
		if(EXTEND_ANTENNA)
			user.visible_message(
				LANG("obj.78ddd562325aca83", list(icon2html(src, oviewers(2, user)), user, src, user)),
				LANG("obj.64bbfa6081f98a23", list(icon2html(src, user))),
				vision_distance=2)
			current_state = SLAP_SIDE
			next_activate = world.time + 20
			return
		if(SLAP_SIDE)
			user.visible_message(
				LANG("obj.6088244a4ec2920e", list(icon2html(src, oviewers(2, user)), user, src)),
				LANG("obj.19033de2ba959e6d", list(icon2html(src, user))),
				vision_distance=2)
			playsound(user, 'modular_skyrat/master_files/sound/effects/hacked.ogg', 100, TRUE)
			sparks.start()
			current_state = TURN_DIAL
			next_activate = world.time + 110
			return
		else
			current_state = TURN_DIAL
			next_activate = world.time + 20
			return

#undef TURN_DIAL
#undef TAP_SCREEN
#undef PRESS_KEYS
#undef EXTEND_ANTENNA
#undef SLAP_SIDE

// Donation reward for SQNZTB
/obj/vehicle/ridden/wheelchair/hardlight
	name = "hardlight wheelchair"
	desc = "A wheelchair made out of hardlight, propulsed by miniaturized bluespace technology."
	alpha = 150 // Just to help differentiate it from a real wheelchair, and to show that it's a bit squishier.
	max_integrity = 10 //standard wheelchairs have 100, motorized 150
	/// The projector associated with this wheelchair.
	/// Only used so that we can remove this wheelchair from it when it gets destroyed.
	var/obj/item/holosign_creator/projector = null
	foldabletype = null


/obj/vehicle/ridden/wheelchair/hardlight/Initialize(mapload, source_projector)
	. = ..()
	if(source_projector)
		projector = source_projector
		LAZYADD(projector.signs, src)


/obj/vehicle/ridden/wheelchair/hardlight/Destroy()
	if(projector)
		LAZYREMOVE(projector.signs, src)
		projector = null

	return ..()

/obj/vehicle/ridden/wheelchair/hardlight/atom_destruction(damage_flag)
	visible_message(span_notice(LANG("obj.0c3fe8d1aacf9993", list(src))))
	qdel(src)
	return ..()

/obj/vehicle/ridden/wheelchair/hardlight/wrench_act(mob/living/user, obj/item/tool)
	return

/obj/vehicle/ridden/wheelchair/hardlight/post_unbuckle_mob()
	. = ..()

	visible_message(span_notice(LANG("obj.b9697850dd28eacf", list(src))))
	qdel(src)


/obj/vehicle/ridden/wheelchair/hardlight/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/wheelchair/hardlight)


// Custom riding component for this wheelchair, so that it behaves properly.
/datum/component/riding/vehicle/wheelchair/hardlight/driver_move(obj/vehicle/vehicle_parent, mob/living/user, direction)
	var/delay_multiplier = 6.7 // magic number from wheelchair code
	//setting speed divisor to 3. original formula from the motorized chair code is:
	//vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * delay_multiplier) / speed
	//this makes it slightly slower than a motorized wheelchair with t1 parts.
	vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * delay_multiplier) / 3
	return ..()


// The actual item they will be using.
/obj/item/holosign_creator/hardlight_wheelchair
	name = "hardlight wheelchair emitter"
	desc = "An emitter which projects a ridable but fragile wheelchair made out of hardlight."
	icon_state = "signmaker_med"
	holosign_type = /obj/vehicle/ridden/wheelchair/hardlight
	max_signs = 1


/obj/item/holosign_creator/hardlight_wheelchair/examine(mob/user)
	. = ..()
	. += span_tinynoticeital(LANG("obj.ce98fc584f0e883d", null))


/obj/item/holosign_creator/hardlight_wheelchair/examine_more(mob/user)
	. = ..()
	. += span_notice(LANG("obj.777cba0e9fc878b3", null))
	. += span_smallnoticeital(LANG("obj.1c4d1f458440eeb7", null))

/obj/item/instrument/piano_synth/headphones/catear_headphone
	name = "Cat-Ear Headphones"
	desc = "Merch of their Electric Guitarist Demi Galgan from the Singularity Shredders. It's heavily customizable and even comes with a holographic tail!"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/instrument/piano_synth/headphones/catear_headphone"
	post_init_icon_state = "catear_headphone"
	worn_icon = 'modular_skyrat/modules/GAGS/icons/head/catear_headphone.dmi'
	lefthand_file = 'modular_skyrat/modules/GAGS/icons/head/catear_headphone_inhand.dmi'
	righthand_file = 'modular_skyrat/modules/GAGS/icons/head/catear_headphone_inhand.dmi'
	inhand_icon_state = "catear_headphone"
	slot_flags = ITEM_SLOT_EARS | ITEM_SLOT_HEAD | ITEM_SLOT_NECK
	var/catTailToggled = FALSE
	instrument_range = 1
	greyscale_colors = "#FFFFFF#FFFFFF"
	greyscale_config = /datum/greyscale_config/catear_headphone
	greyscale_config_worn = /datum/greyscale_config/catear_headphone/worn
	greyscale_config_inhand_left = /datum/greyscale_config/catear_headphone_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/catear_headphone_inhand_right
	flags_1 = IS_PLAYER_COLORABLE_1


/obj/item/instrument/piano_synth/headphones/catear_headphone/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/gags_recolorable)
	update_icon(UPDATE_OVERLAYS)

/obj/item/instrument/piano_synth/headphones/catear_headphone/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance('modular_skyrat/modules/GAGS/icons/head/catear_headphone.dmi', "catearphones_[song?.playing ? "on" : "off"]_emissive", src, alpha = src.alpha)
		if(catTailToggled)
			. += emissive_appearance('modular_skyrat/modules/GAGS/icons/head/catear_headphone.dmi', "catearphones_tail_on_emissive", src, alpha = src.alpha)
			icon_state = "catear_headphone_tail[song?.playing ? "_on" : null]"
		else
			icon_state = "catear_headphone[song?.playing ? "_on" : null]"

/obj/item/instrument/piano_synth/headphones/catear_headphone/click_alt(mob/user)
	catTailToggled = !catTailToggled
	user.update_worn_head()
	update_icon(UPDATE_OVERLAYS)
	return CLICK_ACTION_SUCCESS

/obj/item/instrument/piano_synth/headphones/catear_headphone/update_overlays()
	. = ..()
	. += emissive_appearance('modular_skyrat/modules/GAGS/icons/head/catear_headphone.dmi', "catearphones_obj_lights_emissive", src, alpha = src.alpha)
