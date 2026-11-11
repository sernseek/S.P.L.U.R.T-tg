// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/tgs_chat_command/restart
	name = "restart"
	help_text = "Forces a restart on the server"
	admin_only = TRUE

/datum/tgs_chat_command/restart/Run(datum/tgs_chat_user/sender)
	. = new /datum/tgs_message_content("Restarting.")
	to_chat(world, span_boldwarning(LANG("datum.9eff6d8f695a13bc", list(sender.friendly_name))))
	send2adminchat("Server", "[sender.friendly_name] forced a restart.")
	addtimer(CALLBACK(src, PROC_REF(DoEndProcess)), 1 SECONDS)

/datum/tgs_chat_command/restart/proc/DoEndProcess()
	world.TgsEndProcess()
