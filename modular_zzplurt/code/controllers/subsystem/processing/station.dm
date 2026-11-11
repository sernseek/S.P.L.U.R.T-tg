// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/controller/subsystem/processing/station
	announcer = /datum/centcom_announcer/default/lait

/datum/controller/subsystem/processing/station/proc/set_announcer(datum/centcom_announcer/new_announcer)
	QDEL_NULL(announcer)
	announcer = announcers[new_announcer]

ADMIN_VERB(set_announcer, R_FUN, "设置播报员", "Sets the station announcer to a new type", ADMIN_CATEGORY_FUN)
	var/list/announcer_choices = subtypesof(/datum/centcom_announcer)
	var/datum/centcom_announcer/announcer_choice = tgui_input_list(usr, LANG("datum.b60169789de6daa5", null), LANG("datum.64b29782f2c835d7", null), announcer_choices)
	if(!announcer_choice)
		return
	SSstation.set_announcer(announcer_choice)
	message_admins("Admin [key_name_admin(usr)] has set the station announcer to [announcer_choice].")
