// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/controller/subsystem/gamemode/proc/send_trait_report()
	. = "<b><i>Central Command Status Summary</i></b><hr>"
	// We don't want to roll all three goals every shift, so randomly choose how many we'll do, weighted towards doing none.
	var/list/total_goal_weights = list(
		"0" = 65,
		"1" = 20,
		"2" = 10,
		"3" = 5)
	SSstation.generate_station_goals(text2num(pick_weight(total_goal_weights))) // Yes, this is bad, but I can't use straight nums for assoc list keys. Sue me.

	var/list/station_goals = SSstation.get_station_goals()

	if(!length(station_goals))
		. = "<hr><b>No assigned goals.</b><BR>"
	else
		. += generate_station_goal_report(station_goals)
	if(!SSstation.station_traits.len)
		. = "<hr><b>No identified shift divergencies.</b><BR>"
	else
		. += generate_station_trait_report()

	. += LANG("datum.35f364f202fb38e5", null)

	print_command_report(., "Central Command Status Summary", announce = FALSE)
	priority_announce(LANG("datum.ebf1c56be62f263f", list(station_name())), "Divergency Report", ANNOUNCER_COMMAND_REPORT) // SPLURT EDIT



/*
 * Generate a list of station goals available to purchase to report to the crew.
 *
 * Returns a formatted string all station goals that are available to the station.
 */
/datum/controller/subsystem/gamemode/proc/generate_station_goal_report(list/station_goals)
	. = "<hr><b>Special Orders for [station_name()]:</b><BR>"
	var/list/goal_reports = list()
	for(var/datum/station_goal/station_goal as anything in station_goals)
		station_goal.on_report()
		goal_reports += station_goal.get_report()

	. += goal_reports.Join("<hr>")
	return
/*
 * Generate a list of active station traits to report to the crew.
 *
 * Returns a formatted string of all station traits (that are shown) affecting the station.
 */
/datum/controller/subsystem/gamemode/proc/generate_station_trait_report()
	if(!SSstation.station_traits.len)
		return
	. = "<hr><b>Identified shift divergencies:</b><BR>"
	for(var/datum/station_trait/station_trait as anything in SSstation.station_traits)
		if(!station_trait.show_in_report)
			continue
		. += "[station_trait.get_report()]<BR>"
	return

/*/datum/controller/subsystem/gamemode/proc/generate_station_goals()
	var/list/possible = subtypesof(/datum/station_goal)
	var/goal_weights = 0
	while(possible.len && goal_weights < 1) // station goal budget is 1
		var/datum/station_goal/picked = pick_n_take(possible)
		goal_weights += initial(picked.weight)
		SSstation.goals_by_type += new picked // does this still work?
*/
