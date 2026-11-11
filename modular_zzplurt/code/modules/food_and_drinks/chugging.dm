// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/reagent_containers/cup
	var/beingChugged = FALSE // For checking

/obj/item/reagent_containers/cup/try_drink(mob/living/target_mob, mob/living/user, obj/target)
	var/original_gulp_size = gulp_size

	if(!canconsume(target_mob, user))
		return ..()

	if(!is_drainable())
		return ..()

	if(!reagents || !reagents.total_volume)
		return ..()

	/* //already being checked in canconsume
	if(!istype(target_mob))
		return ..()
	*/

	if(target_mob == user && user.zone_selected == BODY_ZONE_PRECISE_MOUTH && !beingChugged)
		beingChugged = TRUE
		user.visible_message(span_notice(LANG("obj.f29cf96269ccfbb3", list(user, src))), \
			span_notice(LANG("obj.98635752f317d07b", list(src))))
		if(!do_after(user, 3 SECONDS, target_mob))
			beingChugged = FALSE
			return
		if(!reagents || !reagents.total_volume)
			beingChugged = FALSE
			return
		gulp_size = 50
		user.visible_message(span_notice(LANG("obj.5b2c376e9b0e2a4c", list(user, src))), \
			span_notice(LANG("obj.a40bbec97a2552b9", list(src))))
		beingChugged = FALSE

	. = ..()

	gulp_size = original_gulp_size
