// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/proc/lose_some_weight_lardass()
	var/unlucky_victim = "your mother" //debug text that should never trigger but should tell coders that something went wrong without breaking immersion
	var/unlucky_victim_fatty_score = 0
	//Get the fattest person
	for(var/mob/living/carbon/human/possible_fatty as anything in GLOB.human_list)

		if(!possible_fatty.mind)
			continue

		if(possible_fatty.stat == DEAD)
			continue //Too mean

		if(possible_fatty.name != possible_fatty.real_name)
			continue //Not possible to pick up on sensors.

		var/turf/possible_fatty_turf = get_turf(possible_fatty)

		if(!possible_fatty_turf || !is_station_level(possible_fatty_turf.z))
			continue

		var/possible_fatty_score = possible_fatty.nutrition
		if(possible_fatty.has_quirk(/datum/quirk/overweight))
			possible_fatty_score = possible_fatty_score * 1.5 + 1000

		if(possible_fatty_score > unlucky_victim_fatty_score)
			unlucky_victim = "[possible_fatty]" //We don't use .name here because we want "The" to be affixed to it if needed.
			unlucky_victim_fatty_score = possible_fatty_score

	priority_announce(
		LANG("_root.a788b412c6c35f2b", list(station_name(), unlucky_victim)),
		"Biohazard Alert"
	)

/datum/round_event/ghost_role/blob/announce(fake)
	. = ..()
	if(fake)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(lose_some_weight_lardass)), rand(60 SECONDS,180 SECONDS))

/datum/dynamic_ruleset/midround/from_ghosts/blob/false_alarm()
	. = ..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(lose_some_weight_lardass)), rand(60 SECONDS,180 SECONDS))
