// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/hand_item/bonkinghand
	name = "bonking hand"
	desc = "Time to bonk someone over the head in comedic fashion."
	inhand_icon_state = "nothing"
	attack_verb_continuous = list("bonks")
	attack_verb_simple = list("bonk")
	hitsound = 'sound/effects/snap.ogg'

/obj/item/hand_item/bonkinghand/Initialize(mapload)
	. = ..()

/obj/item/hand_item/bonkinghand/attack(mob/living/bonked, mob/living/carbon/human/user)
	var/bonk_volume = 75
	var/obj/item/bodypart/bonkers_hand = user.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
	var/obj/item/bodypart/head/bonk_victims_head = bonked.get_bodypart(BODY_ZONE_HEAD)
	if(user.zone_selected != BODY_ZONE_HEAD)
		to_chat(user, span_warning(LANG("obj.f0f5043cc1f0ef54", null)))
		return

	if(issilicon(bonked))
		if(bonkers_hand?.receive_damage( 5, 0 )) // 5 brute damage
			user.update_damage_overlays()
		user.visible_message(
			span_danger(LANG("obj.16f930cf482c6729", list(user, bonked))),
			span_notice(LANG("obj.cba3dccea0c3db08", list(bonked))),
			span_hear(LANG("obj.b992749c086fdc95", null)),
		)
		playsound(bonked, 'sound/items/weapons/smash.ogg', bonk_volume, TRUE, -1)

	else if(bonk_victims_head)
		if(bonk_victims_head.biological_state & BIO_METAL)
			if(bonkers_hand?.receive_damage( 5, 0 )) // 5 brute damage
				user.update_damage_overlays()
			user.visible_message(
				span_danger(LANG("obj.16f930cf482c6729", list(user, bonked))),
				span_notice(LANG("obj.cba3dccea0c3db08", list(bonked))),
				span_hear(LANG("obj.b992749c086fdc95", null)),
			)
			playsound(bonked, 'sound/items/weapons/smash.ogg', bonk_volume, FALSE, -1)

		else
			user.visible_message(
				span_danger(LANG("obj.e4bb341e772c3b0e", list(user, bonked))),
				span_notice(LANG("obj.e88eca2a3fa2482d", list(bonked))),
				span_hear(LANG("obj.61fef7f5828ed971", null)),
			)
			playsound(bonked, 'modular_zubbers/code/modules/emotes/sound/effects/bonk.ogg', bonk_volume, FALSE, -1)
	else
		to_chat(user, span_warning(LANG("obj.8bab7a215af783f9", null)))
		return
	qdel(src)
// Successful takes will qdel our hand after
/obj/item/hand_item/bonkinghand/on_offer_taken(mob/living/carbon/offerer, mob/living/carbon/taker)
	. = ..()
	if(!.)
		return

	qdel(src)

