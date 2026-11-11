// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/under/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	if(has_sensor == NO_SENSORS || has_sensor == BROKEN_SENSORS)
		return

	if(severity <= EMP_HEAVY)
		break_sensors()

	else
		sensor_mode = clamp(sensor_mode + pick(-1,1), SENSOR_OFF, SENSOR_COORDS)
		if(ismob(loc))
			var/mob/wearing_mob = loc
			to_chat(wearing_mob, span_warning(LANG("obj.5c868fece63a5cde", list(src))))

	update_wearer_status()
