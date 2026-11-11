// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/controller/subsystem/shuttle/proc/fleshmind_call(ai_name)
	if(EMERGENCY_IDLE_OR_RECALLED)
		SSshuttle.emergency.request()
		priority_announce(LANG("datum.226b7a52705ec461", list(ai_name)), "Emergency Shuttle", ANNOUNCER_SHUTTLECALLED, "Priority")
	emergency_no_recall = TRUE
