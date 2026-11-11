// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Defining rope tightness for code readability. This var works as multiplier for arousal and pleasure per tick when character tied up with those.
#define ROPE_TIGHTNESS_LOW (1<<0)
#define ROPE_TIGHTNESS_MED (1<<1)
#define ROPE_TIGHTNESS_HIGH (1<<2)

/obj/item/stack/shibari_rope
	name = "shibari ropes"
	desc = "Coil of bondage ropes."
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/stack/shibari_rope"
	post_init_icon_state = "shibari_rope"
	amount = 1
	merge_type = /obj/item/stack/shibari_rope
	singular_name = "rope"
	max_amount = 5
	flags_1 = IS_PLAYER_COLORABLE_1

	greyscale_config = /datum/greyscale_config/shibari_rope
	greyscale_colors = "#bd8fcf"

	greyscale_config_inhand_left = /datum/greyscale_config/shibari_rope_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/shibari_rope_inhand_right

	///We use this var to change tightness var on worn version of this item.
	var/tightness = ROPE_TIGHTNESS_LOW
	///should clothing items created by this stack glow
	var/glow = FALSE

	///Things this rope can transform into when it's tied to a person
	var/obj/item/clothing/under/shibari/torso/shibari_body
	var/obj/item/clothing/under/shibari/groin/shibari_groin
	var/obj/item/clothing/under/shibari/full/shibari_fullbody
	var/obj/item/clothing/shoes/shibari_legs/shibari_legs
	var/obj/item/clothing/gloves/shibari_hands/shibari_hands

//This part of code spawns ropes with full stack.
/obj/item/stack/shibari_rope/full
	amount = 5

/obj/item/stack/shibari_rope/glow
	name = "glowy shibari ropes"
	singular_name = "glowy rope"
	merge_type = /obj/item/stack/shibari_rope/glow
	icon_state = "/obj/item/stack/shibari_rope/glow"
	post_init_icon_state = "shibari_rope_glow"
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_on = TRUE
	light_power = 3
	glow = TRUE

/obj/item/stack/shibari_rope/glow/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	set_light_color(greyscale_colors)

/obj/item/stack/shibari_rope/glow/full
	amount = 5

/obj/item/stack/shibari_rope/update_overlays()
	. = ..()
	if(glow)
		. += emissive_appearance(icon, icon_state, src, alpha = alpha)

/obj/item/stack/shibari_rope/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(glow)
		. += emissive_appearance(standing.icon, standing.icon_state, src, alpha = standing.alpha)

/obj/item/stack/shibari_rope/update_icon_state()
	if(amount <= (max_amount * (1/3)))
		set_greyscale(greyscale_colors, /datum/greyscale_config/shibari_rope)
		return ..()
	if (amount <= (max_amount * (2/3)))
		set_greyscale(greyscale_colors, /datum/greyscale_config/shibari_rope/med)
		return ..()
	set_greyscale(greyscale_colors, /datum/greyscale_config/shibari_rope/high)
	return ..()

/obj/item/stack/shibari_rope/split_stack(amount)
	. = ..()
	if(.)
		var/obj/item/stack/current_stack = .
		current_stack.set_greyscale(greyscale_colors)

/obj/item/stack/shibari_rope/can_merge(obj/item/stack/check, inhand = TRUE)
	if(check.greyscale_colors == greyscale_colors)
		return ..()
	else
		return FALSE

/obj/item/stack/shibari_rope/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	RegisterSignal(src, COMSIG_ITEM_ATTACK, PROC_REF(handle_roping))
	if(!greyscale_colors)
		var/new_color = "#"
		for(var/i in 1 to 3)
			new_color += num2hex(rand(0, 255), 2)
		set_greyscale(colors = list(new_color))

/obj/item/stack/shibari_rope/proc/handle_roping(datum/source, mob/living/carbon/attacked, mob/living/user, list/modifiers)
	SIGNAL_HANDLER

	if(get_dist(user, src) > 1)
		return
	if(!ishuman(attacked))
		return
	if(!attacked.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, user, src))
		to_chat(user, span_danger(LANG("obj.f3f1a07e3d5002f8", list(attacked))))
		return
	switch(user.zone_selected)
		if(BODY_ZONE_L_LEG)
			INVOKE_ASYNC(src, PROC_REF(handle_leg_tying), attacked, user)
			return COMPONENT_CANCEL_ATTACK_CHAIN
		if(BODY_ZONE_R_LEG)
			INVOKE_ASYNC(src, PROC_REF(handle_leg_tying), attacked, user)
			return COMPONENT_CANCEL_ATTACK_CHAIN
		if(BODY_ZONE_PRECISE_GROIN)
			INVOKE_ASYNC(src, PROC_REF(handle_groin_tying), attacked, user)
			return COMPONENT_CANCEL_ATTACK_CHAIN
		if(BODY_ZONE_CHEST)
			INVOKE_ASYNC(src, PROC_REF(handle_chest_tying), attacked, user)
			return COMPONENT_CANCEL_ATTACK_CHAIN
		if(BODY_ZONE_L_ARM)
			INVOKE_ASYNC(src, PROC_REF(handle_arm_tying), attacked, user)
			return COMPONENT_CANCEL_ATTACK_CHAIN
		if(BODY_ZONE_R_ARM)
			INVOKE_ASYNC(src, PROC_REF(handle_arm_tying), attacked, user)
			return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/item/stack/shibari_rope/proc/handle_groin_tying(mob/living/carbon/human/them, mob/living/user)
	if(istype(them.w_uniform, /obj/item/clothing/under/shibari/torso))
		handle_fullbody_tying(them, user)
		return
	else if(them.w_uniform)
		to_chat(user, span_warning(LANG("obj.04028a8f3f1ae47d", null)))
		return
	them.visible_message(span_warning(LANG("obj.ff6149d49310a4aa", list(user, them))),\
		span_userdanger(LANG("obj.48d9b16321514dd2", list(user))),\
		span_hear(LANG("obj.7323275ee798871a", null)))
	if(!do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60, them))
		return
	var/obj/item/stack/shibari_rope/split_rope = null
	var/slow = 0
	if(them.bodyshape & BODYSHAPE_TAUR)
		split_rope = split_stack(2)
		slow = 4
	else
		split_rope = split_stack(1)
	if(!split_rope)
		to_chat(user, span_warning(LANG("obj.ef109b4d520dd4f0", null)))
		return
	shibari_groin = new(src)
	shibari_groin.slowdown = slow
	shibari_groin.set_greyscale(greyscale_colors)
	shibari_groin.glow = glow
	split_rope.forceMove(shibari_groin)
	if(them.equip_to_slot_if_possible(shibari_groin, ITEM_SLOT_ICLOTHING, TRUE, FALSE, TRUE))
		shibari_groin.tightness = tightness
		shibari_groin = null
		them.visible_message(span_warning(LANG("obj.9463486b3ad785b4", list(user, them))),\
			span_userdanger(LANG("obj.cf85d9437f9e0d38", list(user))),\
			span_hear(LANG("obj.89f7878bde847361", null)))



/obj/item/stack/shibari_rope/proc/handle_chest_tying(mob/living/carbon/human/them, mob/living/user)
	if(istype(them.w_uniform, /obj/item/clothing/under/shibari/groin))
		handle_fullbody_tying(them, user)
		return
	else if(them.w_uniform)
		to_chat(user, span_warning(LANG("obj.04028a8f3f1ae47d", null)))
		return
	them.visible_message(span_warning(LANG("obj.5a14de1fee4ba469", list(user, them))),\
		span_userdanger(LANG("obj.54a8c2792a6e4fda", list(user))),\
		span_hear(LANG("obj.7323275ee798871a", null)))
	if(!do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60, them))
		return
	var/obj/item/stack/shibari_rope/split_rope = split_stack(null, 1)
	if(split_rope)
		shibari_body = new(src)
		shibari_body.set_greyscale(greyscale_colors)
		shibari_body.glow = glow
		split_rope.forceMove(shibari_body)
		if(them.equip_to_slot_if_possible(shibari_body, ITEM_SLOT_ICLOTHING, TRUE, FALSE, TRUE))
			shibari_body.tightness = tightness
			shibari_body = null
			them.visible_message(span_warning(LANG("obj.b90cf2849d30fa22", list(user, them))),\
				span_userdanger(LANG("obj.d87d71528481618a", list(user))),\
				span_hear(LANG("obj.89f7878bde847361", null)))
	else
		to_chat(user, span_warning(LANG("obj.ef109b4d520dd4f0", null)))

/obj/item/stack/shibari_rope/proc/handle_arm_tying(mob/living/carbon/human/them, mob/living/user)
	if(them.gloves)
		to_chat(user, span_warning(LANG("obj.04028a8f3f1ae47d", null)))
		return
	them.visible_message(span_warning(LANG("obj.41cea815b10212fb", list(user, them))),\
		span_userdanger(LANG("obj.3fbc887c6b946cfd", list(user))),\
		span_hear(LANG("obj.7323275ee798871a", null)))
	if(!do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60, them))
		return
	var/obj/item/stack/shibari_rope/split_rope = split_stack(null, 1)
	if(split_rope)
		shibari_hands = new(src)
		shibari_hands.set_greyscale(greyscale_colors)
		shibari_hands.glow = glow
		split_rope.forceMove(shibari_hands)
		if(them.equip_to_slot_if_possible(shibari_hands, ITEM_SLOT_GLOVES, TRUE, FALSE, TRUE))
			shibari_hands = null
			them.visible_message(span_warning(LANG("obj.c26396902b5e7048", list(user, them))),\
				span_userdanger(LANG("obj.2142e8af4039cbf6", list(user))),\
				span_hear(LANG("obj.89f7878bde847361", null)))
	else
		to_chat(user, span_warning(LANG("obj.ef109b4d520dd4f0", null)))


/obj/item/stack/shibari_rope/proc/handle_leg_tying(mob/living/carbon/human/them, mob/living/user)
	if(them.shoes)
		to_chat(user, span_warning(LANG("obj.04028a8f3f1ae47d", null)))
		return
	if(them.bodyshape & BODYSHAPE_TAUR)
		to_chat(user, span_warning(LANG("obj.c27a125b8ffefcb0", null)))
		return
	them.visible_message(span_warning(LANG("obj.47a8ad37e6592301", list(user, them))),\
		span_userdanger(LANG("obj.d4c6664769f33565", list(user))),\
		span_hear(LANG("obj.7323275ee798871a", null)))
	if(!do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60, them))
		return
	var/obj/item/stack/shibari_rope/split_rope = split_stack(null, 1)
	if(split_rope)
		shibari_legs = new(src)
		shibari_legs.set_greyscale(greyscale_colors)
		shibari_legs.glow = glow
		split_rope.forceMove(shibari_legs)
		if(them.equip_to_slot_if_possible(shibari_legs, ITEM_SLOT_FEET, TRUE, FALSE, TRUE))
			shibari_legs = null
			them.visible_message(span_warning(LANG("obj.a517124c9618abc6", list(user, them))),\
				span_userdanger(LANG("obj.beea57214ab8dcb4", list(user))),\
				span_hear(LANG("obj.89f7878bde847361", null)))
	else
		to_chat(user, span_warning(LANG("obj.ef109b4d520dd4f0", null)))


/obj/item/stack/shibari_rope/proc/handle_fullbody_tying(mob/living/carbon/human/them, mob/living/user)
	switch(user.zone_selected)
		if(BODY_ZONE_CHEST)
			them.visible_message(span_warning(LANG("obj.5a14de1fee4ba469", list(user, them))),\
				span_userdanger(LANG("obj.54a8c2792a6e4fda", list(user))),\
				span_hear(LANG("obj.7323275ee798871a", null)))
			if(!do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60, them))
				return
			var/slow = 0
			if(them.bodyshape & BODYSHAPE_TAUR)
				slow = 4
			var/obj/item/stack/shibari_rope/split_rope = split_stack(null, 1)
			if(split_rope)
				var/obj/item/clothing/under/shibari/body_rope = them.w_uniform
				if(body_rope.glow == split_rope.glow)
					shibari_fullbody = new(src)
					shibari_fullbody.slowdown = slow
					shibari_fullbody.glow = glow
					split_rope.forceMove(shibari_fullbody)
					for(var/obj/thing in body_rope.contents)
						thing.forceMove(shibari_fullbody)
					shibari_fullbody.set_greyscale(list(greyscale_colors, body_rope.greyscale_colors))
					qdel(them.w_uniform)
					if(them.equip_to_slot_if_possible(shibari_fullbody, ITEM_SLOT_ICLOTHING, TRUE, FALSE, TRUE))
						shibari_fullbody.tightness = tightness
						shibari_fullbody = null
						them.visible_message(span_warning(LANG("obj.b90cf2849d30fa22", list(user, them))),\
							span_userdanger(LANG("obj.d87d71528481618a", list(user))),\
							span_hear(LANG("obj.89f7878bde847361", null)))
				else
					to_chat(user, span_warning(LANG("obj.44de1419a9734334", null)))
					split_rope.forceMove(get_turf(them))
			else
				to_chat(user, span_warning(LANG("obj.ef109b4d520dd4f0", null)))
		if(BODY_ZONE_PRECISE_GROIN)
			them.visible_message(span_warning(LANG("obj.ff6149d49310a4aa", list(user, them))),\
				span_userdanger(LANG("obj.48d9b16321514dd2", list(user))),\
				span_hear(LANG("obj.7323275ee798871a", null)))
			if(!do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60, them))
				return
			var/obj/item/stack/shibari_rope/split_rope = null
			var/slow = 0
			if(them.bodyshape & BODYSHAPE_TAUR)
				split_rope = split_stack(null, 2)
				slow = 4
			else
				split_rope = split_stack(null, 1)
			if(split_rope)
				var/obj/item/clothing/under/shibari/body_rope = them.w_uniform
				if(body_rope.glow == split_rope.glow)
					shibari_fullbody = new(src)
					shibari_fullbody.slowdown = slow
					shibari_fullbody.glow = glow
					split_rope.forceMove(shibari_fullbody)
					for(var/obj/thing in body_rope.contents)
						thing.forceMove(shibari_fullbody)
					shibari_fullbody.set_greyscale(list(body_rope.greyscale_colors, greyscale_colors))
					qdel(them.w_uniform)
					if(them.equip_to_slot_if_possible(shibari_fullbody, ITEM_SLOT_ICLOTHING, TRUE, FALSE, TRUE))
						shibari_fullbody.tightness = tightness
						shibari_fullbody = null
						them.visible_message(span_warning(LANG("obj.9463486b3ad785b4", list(user, them))),\
							span_userdanger(LANG("obj.cf85d9437f9e0d38", list(user))),\
							span_hear(LANG("obj.89f7878bde847361", null)))
				else
					to_chat(user, span_warning(LANG("obj.0b5f985d40382c76", null)))
					split_rope.forceMove(get_turf(them))
			else
				to_chat(user, span_warning(LANG("obj.ef109b4d520dd4f0", null)))

///This part of code required for tightness adjustment. You can change tightness of future shibari bondage on character by clicking on ropes.

/obj/item/stack/shibari_rope/attack_self(mob/user)
	switch(tightness)
		if(ROPE_TIGHTNESS_HIGH)
			tightness = ROPE_TIGHTNESS_LOW
			conditional_pref_sound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 25)
			balloon_alert(user, LANG("obj.45f9a491fdc661a1", null))
		if(ROPE_TIGHTNESS_LOW)
			tightness = ROPE_TIGHTNESS_MED
			conditional_pref_sound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 50)
			balloon_alert(user, LANG("obj.a3c5403ad1f322be", null))
		if(ROPE_TIGHTNESS_MED)
			tightness = ROPE_TIGHTNESS_HIGH
			conditional_pref_sound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 75)
			balloon_alert(user, LANG("obj.35e7e91678d3e486", null))

#undef ROPE_TIGHTNESS_LOW
#undef ROPE_TIGHTNESS_MED
#undef ROPE_TIGHTNESS_HIGH
