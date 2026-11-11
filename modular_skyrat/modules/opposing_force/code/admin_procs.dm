// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
ADMIN_VERB(request_more_opfor, R_FUN, "征集 OPFOR 申请", "Request players sign up for opfor if they have antag on.", ADMIN_CATEGORY_FUN)
	var/confirm = tgui_alert(user, LANG("datum.02f068f7c59fc213", null), LANG("datum.59cb30a2da1db45a", null), list("Yes", "No"))
	if(confirm != "Yes")
		return

	var/asked = 0
	for(var/mob/living/carbon/human/human in GLOB.alive_player_list)
		if(human.client?.prefs?.read_preference(/datum/preference/toggle/be_antag))
			to_chat(human, custom_boxed_message("green_box", span_greentext("The admins are looking for OPFOR players, if you're interested, sign up in the OOC tab!")))
			asked++
	message_admins("[ADMIN_LOOKUP(user)] has requested more OPFOR players! (Asked: [asked] players)")


ADMIN_VERB(view_opfors, R_ADMIN, "查看 OPFOR 申请", "View OPFORs.", ADMIN_CATEGORY_GAME)
	user.mob.client?.view_opfors()

/client/proc/view_opfors()
	if(holder)
		var/list/dat = list("<html>")
		dat += SSopposing_force.get_check_antag_listing()
		dat += "</html>"
		usr << browse(dat.Join(), "window=roundstatus;size=500x500")
		log_admin("[key_name(usr)] viewed OPFORs.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "View OPFORs")
