// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/round_event_control/spider_infestation
	name = "Spider Infestation"
	typepath = /datum/round_event/spider_infestation
	track = EVENT_TRACK_GHOSTSET
	tags = list(TAG_COMBAT, TAG_DESTRUCTIVE, TAG_CHAOTIC)
	weight = 2
	max_occurrences = 2
	min_players = 35
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawns spider eggs, ready to hatch."
	min_wizard_trigger_potency = 5
	max_wizard_trigger_potency = 7

/datum/round_event/spider_infestation
	announce_when = 400
	var/spawncount = 2

/datum/round_event/spider_infestation/setup()
	announce_when = rand(announce_when, announce_when + 50)

/datum/round_event/spider_infestation/announce(fake)
	priority_announce(LANG("datum.9d5038a31b818751", list(station_name())), "Lifesign Alert", ANNOUNCER_ALIENS)

/datum/round_event/spider_infestation/start()
	create_midwife_eggs(spawncount)

/proc/create_midwife_eggs(amount)
	while(amount > 0)
		var/turf/spawn_loc = find_maintenance_spawn(atmos_sensitive = TRUE, require_darkness = TRUE)
		if(isnull(spawn_loc))
			return //Admins will have already been notified of the spawning failure at this point
		var/obj/effect/mob_spawn/ghost_role/spider/midwife/new_eggs = new (spawn_loc)
		new_eggs.amount_grown = 98
		amount--
	log_game("Midwife spider eggs were spawned via an event.")
	return TRUE
