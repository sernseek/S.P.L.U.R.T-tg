// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/structure/sink/attackby(obj/item/attacking_item, mob/living/user, params)
	if(busy)
		to_chat(user, span_warning(LANG("obj.d5ba1f8cb2273d77", null)))
		return

	if(istype(attacking_item, /obj/item/towel))
		if(reagents.total_volume <= 0)
			to_chat(user, span_notice(LANG("obj.9043fdab29ed6609", list(src))))
			return FALSE

		busy = TRUE
		user.visible_message(span_notice(LANG("obj.34cb5eb06431759b", list(user, attacking_item, src))), span_notice(LANG("obj.4ee1043eeb0ca6b2", list(attacking_item, src))))

		if(!do_after(user, 2 SECONDS, src))
			busy = FALSE
			to_chat(user, span_warning(LANG("obj.1153ba60ee68a0b3", list(attacking_item, src))))
			return FALSE

		var/obj/item/towel/washed_towel = attacking_item

		washed_towel.reagents.remove_all(washed_towel.reagents.total_volume)
		washed_towel.transfer_reagents_to_towel(reagents, washed_towel.reagents.maximum_volume, user)

		washed_towel.set_wet(TRUE)
		washed_towel.make_used(user, silent = TRUE)

		user.visible_message(span_notice(LANG("obj.dd8be228c0009b34", list(user, attacking_item, src))), span_notice(LANG("obj.7f3444e9aaf0375c", list(washed_towel, src))))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)

		busy = FALSE

	else
		return ..()

