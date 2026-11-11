// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define INFINITE_CHARGES -1

/obj/item/traitor_announcer
	name = "odd device"
	desc = "Hmm... what is this for?"
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE
	special_desc = "A remote that can be used to transmit a fake announcement of your own design."
	icon = 'icons/obj/devices/scanner.dmi'
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	icon_state = "inspector"
	worn_icon_state = "salestagger"
	inhand_icon_state = "electronic"
	///How many uses does it have? -1 for infinite
	var/uses = 1

/proc/try_user_announce(mob/living/user, list/available_sounds = GLOB.announcer_keys)
	//build our announcement
	var/origin = reject_bad_text(tgui_input_text(user, LANG("_root.a18f70bf254e4106", null), LANG("_root.a13897ade2fbeac1", null), get_area_name(user), max_length = 28))
	if(!origin)
		user.balloon_alert(user, LANG("_root.7f313aa2d7137006", null))
		return FALSE
	var/audio_key = tgui_input_list(user, LANG("_root.e7e98abf04eb39c7", null), LANG("_root.adb840f2439d7466", null), available_sounds, ANNOUNCER_INTERCEPT)
	if(!audio_key)
		user.balloon_alert(user, LANG("_root.498862e2f8b97802", null))
		return FALSE
	var/color = tgui_input_list(user, LANG("_root.e55458310124f68d", null), LANG("_root.59ef58ac133b02af", null), ANNOUNCEMENT_COLORS, "default")
	if(!color)
		user.balloon_alert(user, LANG("_root.cba9924c57671034", null))
		return FALSE
	var/title = reject_bad_text(tgui_input_text(user, LANG("_root.0d9126fb7f3f99ac", null), LANG("_root.fa4ed425405e3026", null), max_length = 42))
	if(!title)
		user.balloon_alert(user, LANG("_root.355e60205342e8bb", null))
		return FALSE
	var/input = reject_bad_text(tgui_input_text(user, LANG("_root.f8e65aaf61ada8df", null), LANG("_root.d40536e84d989596", null), max_length = 512, multiline = TRUE))
	if(!input)
		user.balloon_alert(user, LANG("_root.76fac4a8183a3d8f", null))
		return FALSE
	//treat voice
	var/list/message_data = user.treat_message(input)
	//send
	priority_announce(
		text = message_data["message"],
		title = title,
		sound = audio_key,
		has_important_message = TRUE,
		sender_override = origin,
		color_override = color,
		encode_text = FALSE,
		encode_title = FALSE
	)

	deadchat_broadcast(" made a fake priority announcement from [span_name("[get_area_name(usr, TRUE)]")].", span_name("[user.real_name]"), user, message_type=DEADCHAT_ANNOUNCEMENT)
	user.log_talk("\[Message title\]: [title], \[Message\]: [input], \[Audio key\]: [audio_key]", LOG_TELECOMMS, tag = "priority announcement")
	message_admins("[ADMIN_LOOKUPFLW(user)] has made a fake announcement of [input].")

	return TRUE

/obj/item/traitor_announcer/attack_self(mob/living/user, modifiers)
	. = ..()
	//can we use this?
	if(!isliving(user) || (uses == 0))
		user.balloon_alert(user, LANG("obj.e8ff683378b87f0a", null))
		return

	var/result = try_user_announce(user)
	if(result)
		if(uses != INFINITE_CHARGES)
			uses--

// Adminbus
/obj/item/traitor_announcer/infinite
	uses = -1

#undef INFINITE_CHARGES
