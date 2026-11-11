// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
ADMIN_VERB(ping_deadmins, R_ADMIN, "提醒已卸任的管理员", "Send a notification and message to all currently de-adminned admins.", ADMIN_CATEGORY_MAIN)
	var/message = tgui_input_text(user, LANG("datum.dd6283964a217696", null), LANG("datum.88e41915e909dbae", null), "Need help with tickets...", max_length = 256)
	if(!message)
		return

	var/list/admins_notified = list()
	for(var/ckey in GLOB.deadmins)
		var/client/deadmin_client = GLOB.directory[ckey]
		if(!deadmin_client)
			continue
		to_chat(
			deadmin_client,
			fieldset_block(
				span_adminhelp("[user.key] is requesting help"),
				span_adminsay(message),
				"boxed_message red_box"),
			type = MESSAGE_TYPE_SYSTEM,
			confidential = TRUE,
		)
		SEND_SOUND(deadmin_client, sound('sound/effects/adminhelp.ogg'))
		admins_notified += ckey

	log_admin("[key_name_admin(user)] pinged [length(admins_notified)] ([admins_notified.Join(", ")]) de-adminned admin(s) with message: [message]")
	message_admins("[key_name_admin(user)] pinged [length(admins_notified)] ([admins_notified.Join(", ")]) de-adminned admin(s) with message: [message]")
