// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/silicon/Topic(href, href_list)
	. = ..()
	if(href_list["open_door"])
		var/obj/machinery/door/airlock/door = locate(href_list["open_door"]) in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door/airlock)
		var/mob/living/requester = locate(href_list["user"]) in GLOB.mob_list

		if(!requester)
			return
		if(!door)
			return
		fulfill_door_request(requester, door, href_list["action"])

/// Allows the AI to interact somewhat with a door if the requester can be tracked by cameras and the AI can normally access it.
/mob/living/silicon/proc/fulfill_door_request(mob/living/requester, obj/machinery/door/airlock/door, action)
	if(!istype(requester))
		return
	if(!istype(door))
		return

	if(!COOLDOWN_FINISHED(door, answer_cd))
		to_chat(src, span_warning(LANG("mob.3bc179f87582d09f", null)))
		return

	if(!requester.can_track(src))
		to_chat(src, span_notice(LANG("mob.40687e4161505c3e", null)))
		return
	if(door.aiControlDisabled != AI_WIRE_NORMAL)
		to_chat(src, span_notice(LANG("mob.0560a91488ef35cb", null)))
		return

	COOLDOWN_START(door, answer_cd, 10 SECONDS)

	switch(action)
		if("open")
			if(door.locked)
				door.unbolt()
			door.open()
			playsound(door, 'sound/machines/ping.ogg', 50, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			to_chat(src, LANG("mob.ba6e08b6b44de91f", list(door, requester)))
		if("bolt")
			if(!door.locked)
				door.bolt()
				door.visible_message(span_danger(LANG("mob.28973015bf0bf1b5", list(src))), vision_distance = COMBAT_MESSAGE_RANGE)
		if("shock")
			door.set_electrified(MACHINE_DEFAULT_ELECTRIFY_TIME)
			playsound(door, 'sound/machines/buzz/buzz-sigh.ogg', 25, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			door.visible_message(span_notice(LANG("mob.bef91bba1cc000b5", list(src))), vision_distance = COMBAT_MESSAGE_RANGE)
		if("deny")
			playsound(door, 'sound/machines/buzz/buzz-sigh.ogg', 25, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			door.visible_message(span_notice(LANG("mob.bef91bba1cc000b5", list(src))), vision_distance = COMBAT_MESSAGE_RANGE)
			to_chat(src, LANG("mob.39ee28ea9c163d53", list(requester)))
