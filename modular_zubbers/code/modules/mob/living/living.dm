// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living
	/// Normalized is a check for instances where more than one accessory of jewelry is worn. For all intensive purposes, only the first worn accessory stores the user's size.
	var/normalized = FALSE
	///Effect from hold up
	var/obj/effect/overlay/gunpoint_effect/lock_on_effect

/// Toggle admin frozen
/mob/living/proc/toggle_admin_freeze(client/admin)
	admin_frozen = !admin_frozen

	if(admin_frozen)
		SetStun(INFINITY, ignore_canstun = TRUE)
	else
		SetStun(0, ignore_canstun = TRUE)

	if(client && admin)
		to_chat(src, span_userdanger(LANG("mob.83a8fdc1647745c2", list(!admin_frozen ? "un" : ""))))
		log_admin("[key_name(admin)] toggled admin-freeze on [key_name(src)].")
		message_admins("[key_name_admin(admin)] toggled admin-freeze on [key_name_admin(src)].")

/// Toggle admin sleeping
/mob/living/proc/toggle_admin_sleep(client/admin)
	admin_sleeping = !admin_sleeping

	if(admin_sleeping)
		SetSleeping(INFINITY)
	else
		SetSleeping(0)

	if(client && admin)
		to_chat(src, span_userdanger(LANG("mob.18c5821daf5ed26f", list(!admin_sleeping ? "un": ""))))
		log_admin("[key_name(admin)] toggled admin-sleep on [key_name(src)].")
		message_admins("[key_name_admin(admin)] toggled admin-sleep on [key_name_admin(src)].")
