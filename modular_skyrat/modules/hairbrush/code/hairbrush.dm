// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Hairbrushes

/obj/item/hairbrush
	name = "hairbrush"
	desc = "A small, circular brush with an ergonomic grip for efficient brush application."
	icon = 'modular_skyrat/modules/hairbrush/icons/hairbrush.dmi'
	icon_state = "brush"
	inhand_icon_state = "inhand"
	lefthand_file = 'modular_skyrat/modules/hairbrush/icons/inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/hairbrush/icons/inhand_right.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/brush_speed = 3 SECONDS

/obj/item/hairbrush/attack(mob/target, mob/user)
	if(target.stat == DEAD)
		to_chat(usr, span_warning(LANG("obj.227e6d840edff6e2", null)))
		return
	brush(target, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/// Brushes someone, giving them a small mood boost
/obj/item/hairbrush/proc/brush(mob/living/target, mob/user)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/bodypart/head = human_target.get_bodypart(BODY_ZONE_HEAD)

		// Don't brush if you can't reach their head or cancel the action
		if(!head)
			to_chat(user, span_warning(LANG("obj.14898dbc2bd48c2f", list(human_target))))
			return
		if(human_target.is_mouth_covered(ITEM_SLOT_HEAD))
			to_chat(user, span_warning(LANG("obj.4d58e6cb106da067", list(human_target, human_target.p_their()))))
			return
		if(!do_after(user, brush_speed, human_target))
			return

		// Do 1 brute to their head if they're bald. Should've been more careful.
		if(human_target.hairstyle == "Bald" || human_target.hairstyle == "Skinhead" && is_species(human_target, /datum/species/human)) //It can be assumed most anthros have hair on them!
			human_target.visible_message(span_warning(LANG("obj.cc2f542f32643ad9", list(usr, human_target))), span_warning(LANG("obj.c2c51632c0ba4e2c", list(human_target))))
			head.receive_damage(1)
			return

		// Brush their hair
		if(human_target == user)
			human_target.visible_message(span_notice(LANG("obj.2575757e60bca3ff", list(usr, usr.p_their()))), span_notice(LANG("obj.e476b3273abab935", null)))
			human_target.add_mood_event("brushed", /datum/mood_event/brushed/self)
		else
			user.visible_message(span_notice(LANG("obj.5bffa0b271087da9", list(usr, human_target))), span_notice(LANG("obj.208e63528927ebf5", list(human_target))), ignored_mobs=list(human_target))
			human_target.show_message(span_notice("[usr] brushes your hair!"), MSG_VISUAL)
			human_target.add_mood_event("brushed", /datum/mood_event/brushed, user)

	else if(istype(target, /mob/living/basic/pet))
		if(!do_after(usr, brush_speed, target))
			return
		to_chat(user, span_notice(LANG("obj.35c16eebc711d357", list(target, target.p_their(), target.p_them()))))
		var/mob/living/living_user = user
		if(istype(living_user))
			living_user.add_mood_event("brushed", /datum/mood_event/brushed/pet, target)
