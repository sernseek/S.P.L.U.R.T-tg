// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Ported from NOVA.
//if a Cyborg clicks a hat, they try to put it on
/obj/item/clothing/head/attack_robot_secondary(mob/living/silicon/robot/user, list/modifiers)
	. = ..()
	if(. != SECONDARY_ATTACK_CALL_NORMAL)
		return

	if(!Adjacent(user))
		return

	balloon_alert(user, LANG("obj.f7525ae383b36c26", null))
	if(!do_after(user, 3 SECONDS, src))
		return
	if(QDELETED(src) || !Adjacent(user) || user.incapacitated)
		return
	user.place_on_head(src)
	balloon_alert(user, LANG("obj.7fa4e2ca4ba18e5b", null))

// if a borg right clicks themself, they try to drop their hat
/mob/living/silicon/robot/attack_robot_secondary(mob/user, list/modifiers)
	. = ..()
	if(. != SECONDARY_ATTACK_CALL_NORMAL)
		return

	if(user != src || isnull(hat))
		return

	balloon_alert(user, LANG("mob.0ab66d35300f2db2", null))
	if(!do_after(user, 3 SECONDS, src))
		return
	if(QDELETED(src) || !Adjacent(user) || user.incapacitated || isnull(hat))
		return
	hat.forceMove(get_turf(src))
	hat = null
	update_icons()
	balloon_alert(user, LANG("mob.ffcaa5c006f5f6cc", null))

/mob/living/silicon/robot/shell/get_status_tab_items()
	. = ..()
	. += LANG("mob.4d314b4f0dda38f6", list(length(mainframe.connected_robots)))
	for(var/r in mainframe.connected_robots)
		var/mob/living/silicon/robot/connected_robot = r
		var/robot_status = "Nominal"
		if(connected_robot.shell)
			robot_status = "AI SHELL"
		else if(IS_UNCONSCIOUS_OR_CRIT(connected_robot) || !connected_robot.client)
			robot_status = "OFFLINE"
		else if(!connected_robot.cell || connected_robot.cell.charge <= 0)
			robot_status = "DEPOWERED"
		//Name, Health, Battery, Model, Area, and Status! Everything an AI wants to know about its borgies!
		. += list(list("[connected_robot.name]: ",
			"S.Integrity: [connected_robot.health]% | \
			Cell: [connected_robot.cell ? "[display_energy(connected_robot.cell.charge)]/[display_energy(connected_robot.cell.maxcharge)]" : "Empty"] | \
			Model: [connected_robot.designation] | Loc: [get_area_name(connected_robot, TRUE)] | \
			Status: [robot_status]",
			"src=[REF(src)];track_cyborg=[text_ref(connected_robot)]",
		))
