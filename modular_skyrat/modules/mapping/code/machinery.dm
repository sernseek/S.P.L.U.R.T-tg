// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//For ruin-specific machines --- limitied/unique functions, or functions mimicked from normal machines.
//Think along the lines of a console with lore or a fuse box that needs x fuses to activate --- or, just a retextured GPS Computer, like the first item

/* ----------------- Computers ----------------- */
/obj/item/gps/computer/space //Subtype that runs pod computer code, with a texture to blend better with normal walls
	icon = 'modular_skyrat/modules/mapping/icons/machinery/gps_computer.dmi'	//needs its own file for pixel size ;-;
	name = "gps computer"
	icon_state = "pod_computer"
	anchored = TRUE
	density = TRUE
	pixel_y = -5    //I dunno why this sprite lines up differently, but this is a better value to line this one up in a way that looks built into a wall
	gpstag = SPACE_SIGNAL_GPSTAG	//really the only non-aesthetic change, gives the space ruin GPS signal

/obj/item/gps/computer/space/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(I.use_tool(src, user, 20, volume=50))
		user.visible_message(span_warning(LANG("obj.64d85c99dc62f8de", list(user, src))),
			span_notice(LANG("obj.c234e380f56e7a65", list(src))), span_hear(LANG("obj.f070a678bd67cf40", null)))
		deconstruct(TRUE)
	return TRUE

/obj/item/gps/computer/space/atom_deconstruct(disassembled)
	. = ..()
	new /obj/item/gps/spaceruin(loc)	//really the only non-aesthetic change, gives the space ruin GPS signal

/obj/item/gps/computer/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	attack_self(user)
