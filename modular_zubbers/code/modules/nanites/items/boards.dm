// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/circuitboard/machine/nanite_chamber
	name = "Nanite Chamber (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/nanite_chamber
	req_components = list(
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/servo = 1
	)

/obj/item/circuitboard/machine/nanite_program_hub
	name = "Nanite Program Hub (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/nanite_program_hub
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/servo = 1)

/obj/item/circuitboard/machine/nanite_programmer
	name = "Nanite Programmer (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/nanite_programmer
	req_components = list(
		/obj/item/stock_parts/servo = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/scanning_module = 1
	)

/obj/item/circuitboard/machine/public_nanite_chamber
	name = "Public Nanite Chamber (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/public_nanite_chamber
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/servo = 1
	)
	var/cloud_id = 1

/obj/item/circuitboard/machine/public_nanite_chamber/multitool_act(mob/living/user)
	. = ..()
	var/new_cloud = tgui_input_number(user, LANG("obj.e937a6be59cc1412", list(NANITE_MIN_CLOUD_ID+1, NANITE_MAX_CLOUD_ID)), LANG("obj.bdf2a2959aef8f62", null), cloud_id, NANITE_MAX_CLOUD_ID, NANITE_MIN_CLOUD_ID+1, 0,)
	if(!isnum(new_cloud))
		return
	cloud_id = clamp(round(new_cloud, 1), NANITE_MIN_CLOUD_ID+1, NANITE_MAX_CLOUD_ID)

/obj/item/circuitboard/machine/public_nanite_chamber/examine(mob/user)
	. = ..()
	. += LANG("obj.416dd8138445fdf0", list(cloud_id))

/obj/item/circuitboard/computer/nanite_chamber_control
	name = "Nanite Chamber Control (Computer Board)"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/nanite_chamber_control

/obj/item/circuitboard/computer/nanite_cloud_controller
	name = "Nanite Cloud Control (Computer Board)"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/nanite_cloud_controller
