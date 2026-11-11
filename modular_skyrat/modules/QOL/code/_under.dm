// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/under/item_ctrl_click(mob/user)
	. = ..()
	if(has_sensor == HAS_SENSORS)
		sensor_mode = SENSOR_COORDS
		to_chat(usr, span_notice(LANG("obj.0339532693cede07", null)))
