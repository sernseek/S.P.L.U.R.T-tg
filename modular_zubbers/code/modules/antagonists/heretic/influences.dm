// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define MONSTER_SPAWN_CHANCE_PER_SEC 0.01 // really itll only happen if noone ever gets to it
#define SANITY_DECREASE_PER_SEC -5

/mob/living/basic/heretic_summon/maid_in_the_mirror
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile_obstacles

/obj/effect/visible_heretic_influence
	var/static/list/spawnable_mobs = list(
		/mob/living/basic/heretic_summon/stalker = 10,
		/mob/living/basic/heretic_summon/raw_prophet/ruins = 30,
		/mob/living/basic/heretic_summon/maid_in_the_mirror = 10,
		/mob/living/basic/heretic_summon/rust_walker = 10,
		/mob/living/basic/heretic_summon/fire_shark/wild = 10,
	)
	/// Have we spawned our monster?
	var/spawned_monster = FALSE

/obj/effect/visible_heretic_influence/examine(mob/living/user)
	. = ..()

	. += span_warning(LANG("obj.1cd5b141a250a232", list(EXAMINE_HINT("anomaly neutralizer"))))

/obj/effect/visible_heretic_influence/Initialize(mapload)
	. = ..()

	START_PROCESSING(SSobj, src)

/obj/effect/temp_visual/circle_wave/heretic_monster_spawn
	color = COLOR_GREEN
	duration = 0.5 SECONDS
	amount_to_scale = 2

/obj/effect/visible_heretic_influence/process(seconds_per_tick)
	for (var/mob/living/iter_living in get_hearers_in_view(7, src))
		if (IS_HERETIC_OR_MONSTER(iter_living))
			continue
		if (iter_living.can_block_magic(MAGIC_RESISTANCE|MAGIC_RESISTANCE_MIND, charge_cost = 0))
			continue
		iter_living.mob_mood?.sanity -= SANITY_DECREASE_PER_SEC
		if (SPT_PROB(2, seconds_per_tick))
			to_chat(iter_living, span_warning(LANG("obj.1d1066cad30da430", list(src))))
			iter_living.adjust_hallucinations_up_to(10 SECONDS, 60 SECONDS)

	if (!spawned_monster && SPT_PROB(MONSTER_SPAWN_CHANCE_PER_SEC, seconds_per_tick))
		var/mob/living/basic/heretic_summon/typepath = pick_weight(spawnable_mobs)
		var/mob/living/basic/heretic_summon/new_mob = new typepath(get_turf(src))
		new_mob.set_faction(list(FACTION_HERETIC_WILD))
		new /obj/effect/temp_visual/circle_wave/heretic_monster_spawn(get_turf(src))
		playsound(get_turf(src),'sound/effects/magic/repulse.ogg', 100, TRUE)

		visible_message(span_bolddanger(LANG("obj.011d7f63f3567837", list(src))))

		spawned_monster = TRUE

/obj/effect/heretic_influence/verify_user_can_see(mob/user)
	return IS_HERETIC(user) // override so ALL heretics can see em

#undef MONSTER_SPAWN_CHANCE_PER_SEC
#undef SANITY_DECREASE_PER_SEC
