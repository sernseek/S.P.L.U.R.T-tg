// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/carbon/human/safeword()
	. = ..()

	if(istype(loc, /obj/item/dogborg/sleeper))
		var/obj/item/dogborg/sleeper/this_sleeper = loc

		var/confirmation = alert(src, LANG("mob.30f6125c0fe4c3db", null), LANG("mob.12b8b62577b6fe1e", null), "Confirm", "Cancel")
		if(!confirmation == "Confirm" || loc != this_sleeper)
			return
		// Ejecting the sleeper's occupant. There you go buddy cham pal friend bucko friend pal chum
		this_sleeper.go_out(src)
		message_admins("[src] 'OOC Escape'-d from a dogborg sleeper.")
		log_ooc("[src] 'OOC Escape'-d from a dogborg sleeper.")
