// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/posialert
	name = "automated positronic alert console"
	desc = "A console that will ping when a positronic personality is available for download."
	icon = 'modular_skyrat/modules/positronic_alert_console/icons/terminals.dmi'
	icon_state = "posialert"
	// to create a cooldown so if roboticists are tired of ghosts
	COOLDOWN_DECLARE(robotics_cooldown)
	/// the reason that the console is muted (player decided)
	var/mute_reason
	// to create a cooldown so ghosts cannot spam it
	COOLDOWN_DECLARE(ghost_cooldown)
	/// The encryption key typepath that will be used by the console.
	var/radio_key = /obj/item/encryptionkey/headset_sci
	/// The radio used to send messages over the science channel.
	var/obj/item/radio/radio

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/posialert, 28)

/obj/machinery/posialert/examine(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, robotics_cooldown))
		. += span_notice(LANG("obj.59e2f47422905cfd", list(COOLDOWN_TIMELEFT(src, robotics_cooldown) * 0.1)))
		. += span_notice(LANG("obj.9bb8a3c71f70ffd3", list(mute_reason)))
	. += span_notice(LANG("obj.33f99fac9cebcbb0", null))

/obj/machinery/posialert/Initialize(mapload)
	. = ..()
	radio = new(src)
	radio.keyslot = new radio_key
	radio.set_listening(FALSE)
	radio.recalculateChannels()

/obj/machinery/posialert/Destroy()
	QDEL_NULL(radio)
	. = ..()

/obj/machinery/posialert/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!COOLDOWN_FINISHED(src, robotics_cooldown))
		COOLDOWN_RESET(src, robotics_cooldown)
		to_chat(user, span_notice(LANG("obj.3ba19649097fe817", list(src))))
		return
	mute_reason = null
	mute_reason = stripped_input(user, LANG("obj.69649b801c5a7042", null), LANG("obj.ab3e96b0b4c47e00", null), "", 20)
	if(!mute_reason)
		to_chat(user, span_warning(LANG("obj.7aca210e3407bd96", list(src))))
		return
	COOLDOWN_START(src, robotics_cooldown, 5 MINUTES)
	to_chat(user, span_notice(LANG("obj.079df7a0c7237843", list(src))))

/obj/machinery/posialert/attack_ghost(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, robotics_cooldown))
		to_chat(user, span_warning(LANG("obj.aa401517679c6e02", list(src, COOLDOWN_TIMELEFT(src, robotics_cooldown) * 0.1))))
		to_chat(user, span_warning(LANG("obj.15266a2ae73b69de", list(src, mute_reason))))
		return
	if(!COOLDOWN_FINISHED(src, ghost_cooldown))
		to_chat(user, span_warning(LANG("obj.3b4f1cdc0ffd7a48", list(src, COOLDOWN_TIMELEFT(src, ghost_cooldown) * 0.1))))
		return
	COOLDOWN_START(src, ghost_cooldown, 30 SECONDS)
	flick("posialertflash",src)
	say(LANG("obj.fff6b55e7c9c2ac2", null))
	radio.talk_into(src, LANG("obj.fff6b55e7c9c2ac2", null), RADIO_CHANNEL_SCIENCE)
	playsound(loc, 'sound/machines/ping.ogg', 50)
