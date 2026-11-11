// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/hand_item/kisser/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!HAS_TRAIT(user, TRAIT_HYPNO_KISS) || !iscarbon(interacting_with) || (user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		return ranged_interact_with_atom(interacting_with, user, modifiers)

	visible_message(LANG("obj.4d75523b7e129568", list(user)))
	if(!do_after(user, 2 SECONDS, interacting_with))
		visible_message(LANG("obj.059b3fc2694831e5", list(user)))
		return ITEM_INTERACT_BLOCKING

	var/mob/living/carbon/victim = interacting_with

	if(user)
		log_combat(user, victim, "[user] hypno kissed [victim]", src)
		user.visible_message(span_danger(LANG("obj.1748519183ca1e09", list(user, victim, victim))), span_danger(LANG("obj.4bcada7fd303f472", list(victim))))

	if(!victim.hypnosis_vulnerable())
		to_chat(victim, span_hypnophrase(LANG("obj.efbe806b4d934cf7", null)))
		victim.adjust_confusion_up_to(10 SECONDS, 20 SECONDS)
		victim.adjust_dizzy_up_to(20 SECONDS, 40 SECONDS)
		victim.adjust_drowsiness_up_to(20 SECONDS, 40 SECONDS)
		victim.adjust_pacifism(10 SECONDS)
	else
		victim.apply_status_effect(/datum/status_effect/trance, 20 SECONDS, TRUE)

