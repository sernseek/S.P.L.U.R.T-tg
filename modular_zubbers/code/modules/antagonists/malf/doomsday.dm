// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/doomsday_device/trigger_doomsday()
	for(var/obj/machinery/power/apc/power as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/apc))
		if(is_station_level(power.z))
			explosion(power, light_impact_range = 15, explosion_cause = src, adminlog = TRUE)
			sleep(1)
	to_chat(world, span_bold(LANG("obj.427dbcd0fe1ed590", null)))
	SSticker.force_ending = FORCE_END_ROUND

/proc/test_doomsday()
	var/obj/machinery/doomsday_device/device = new()
	device.trigger_doomsday()
