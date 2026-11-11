// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define POINT_TYPE_CARGO "cargo"
#define POINT_TYPE_SCIENCE "science"

/obj/machinery/research_table
	name = "Sex Research Rack"
	desc = "The rack with silicone padding and plenty of straps for subject restraining.\
	\nA lot of sensors are connected to this device that record the state of the body during orgasm. Well, you know... For scientific purposes...\
	\nYeah..... I fucking LOVE science."
	icon = 'modular_zzplurt/icons/obj/research_rack.dmi'
	icon_state = "rack_better"
	can_buckle = TRUE
	density = TRUE
	buckle_lying = 90
	pass_flags_self = PASSTABLE | LETPASSTHROW
	layer = TABLE_LAYER
	obj_flags = CAN_BE_HIT | IGNORE_DENSITY
	pass_flags = LETPASSTHROW //You can throw objects over this, despite it's density.")
	circuit = /obj/item/circuitboard/machine/research_table
	var/self_unbuckle_time = 3 MINUTES
	var/static/list/users = list()
	var/tier = 1
	var/configured = FALSE
	var/point_type = POINT_TYPE_SCIENCE
	var/max_repeat_usage = 3
	//var/slaver_mode = FALSE slavers dont exist on splurt anymore leaving it here for all of you to see

/obj/machinery/research_table/examine(mob/user)
	. = ..()
	if(configured)
		. += span_notice(LANG("obj.150a1ea92ea4f180", list(max_repeat_usage * tier)))
	switch(point_type)
		if(POINT_TYPE_SCIENCE)
			. += span_notice(LANG("obj.b5892a864c97291f", null))
		else
			. += span_notice(LANG("obj.99e88b3668a2aec3", null))
	if(!configured && !panel_open)
		. += span_notice(LANG("obj.abc037a43e28b6b3", null))
	if(panel_open)
		. += span_notice(LANG("obj.e8e0632f81b86f15", null))

/obj/machinery/research_table/multitool_act(mob/living/user, obj/item/I)
	if(!user.combat_mode)
		if(panel_open)
			user.visible_message(span_notice(LANG("obj.fa37c7d690bc878a", list(user, src))), span_notice(LANG("obj.fa255344118f8dd2", list(src))))
			if(do_after(user, 5 SECONDS, src))
				point_type = point_type == POINT_TYPE_SCIENCE ? POINT_TYPE_CARGO : POINT_TYPE_SCIENCE
				var/generation_message = null
				switch(point_type)
					if(POINT_TYPE_SCIENCE)
						generation_message = "generate research points for science"
					else
						generation_message = "generate money for cargo"
				user.visible_message(span_notice(LANG("obj.8c56a9abc8dc808f", list(user, src))), span_notice(LANG("obj.196a58da2e562e6d", list(src, generation_message))))
			else
				to_chat(user, span_warning(LANG("obj.47857b028691edc5", null)))
			return TRUE
		else
			user.visible_message(span_notice(LANG("obj.4c794cdf919cc71e", list(user, src))), span_notice(LANG("obj.39d1d63211699a0d", list(src))))
			if(do_after(user, 5 SECONDS, src))
				configured = !configured
				user.visible_message(span_notice(LANG("obj.35c6d4e2f938b839", list(user, src))), span_notice(LANG("obj.4521b75a4a825f0d", list(configured ? "configured" : "not configured"))))
			else
				to_chat(user, span_warning(LANG("obj.47857b028691edc5", null)))
			return TRUE
	. = ..()

/obj/machinery/research_table/screwdriver_act(mob/living/user, obj/item/I)
	return default_deconstruction_screwdriver(user, icon_state, icon_state, I)

/obj/machinery/research_table/crowbar_act(mob/living/user, obj/item/I)
	return default_deconstruction_crowbar(I, FALSE)

/obj/machinery/research_table/mouse_drop_receive(mob/living/M, mob/living/user, params)
	if(istype(M))
		if(get_turf(M) != get_turf(src) && user.stat == STABLE)
			var/message = M == user ? "[M] climbs on the [src]." : "[user] puts [M] on the [src]."
			var/self_message = M == user ? "You climb on the [src]." : "You put [M] on the [src]."
			visible_message(message, self_message)
			M.forceMove(get_turf(src))
		. = ..()
		if(. && !configured) // Successfully buckled, not configured.
			say(LANG("obj.45a9c4910ee82d19", null))
	return

/obj/machinery/research_table/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(QDELETED(buckled_mob) || QDELETED(user))
		return
	if(!handle_unbuckling(buckled_mob, user))
		if(buckled_mob == user)
			to_chat(user, span_warning(LANG("obj.23b7578467c0666a", null)))
		else
			to_chat(user, span_warning(LANG("obj.ab3c10dc947752a4", list(buckled_mob))))
		return
	UnregisterSignal(buckled_mob, COMSIG_MOB_POST_CLIMAX)
	say(LANG("obj.1bbc847f6bc47249", null))
	return ..()

/obj/machinery/research_table/proc/handle_unbuckling(mob/living/buckled_mob, user)
	if(buckled_mob == user)
		if(do_after(user, self_unbuckle_time, src))
			return TRUE
		else
			return FALSE
	return TRUE

/obj/machinery/research_table/buckle_mob(mob/living/buckled_mob, force, check_loc)
	RegisterSignal(buckled_mob, COMSIG_MOB_POST_CLIMAX, PROC_REF(on_climax))
	say(LANG("obj.363a81bdc899ca4e", null))
	. = ..()

/obj/machinery/research_table/RefreshParts()
	. = ..()
	// looks like you can just stack random shit into it to make it better lol!!!
	var/parts = 0
	tier = 0
	for(var/obj/item/stock_parts/part in component_parts)
		tier += part.rating
		parts++
	tier /= parts

/obj/machinery/research_table/proc/on_climax(mob/living/carbon/buckled_mob, mob/living/partner, interaction_position, manual)
	if(!configured)
		say(LANG("obj.a288a13337d693c6", null))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, 1)
		return
	if(!istype(buckled_mob))
		say(LANG("obj.763fdf1cc6363aab", null))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, 1)
		return
	if(buckled_mob == partner)
		say(LANG("obj.1a965be90cc9f129", null))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, 1)
		return
	if(users[buckled_mob.name] > (max_repeat_usage * tier))
		say(LANG("obj.eee83cce0a808737", null))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, 1)
		return
	users[buckled_mob.name] += 1
	var/points_awarded = 0

	// little bonus if you... if you have interesting body traits
	// I don't stack these on purpose for "balancing"
	// study the physiological effects of sex or something
	if(buckled_mob.has_quirk(TRAIT_RESTORATIVE_METABOLISM) || buckled_mob.has_quirk(TRAIT_BODY_MORPHER) || buckled_mob.has_quirk(TRAIT_UNDEAD))
		points_awarded += rand(1,5)

	// study the psychological effects of sex or something
	// uncomment this as soon as you merge the other PR pretty please
	if(buckled_mob.has_quirk(TRAIT_HYPERSEXUAL))
		points_awarded += rand(1,5)

	// if you are pregnant i guess its interesting to see whats up?
	var/datum/status_effect/pregnancy/prego = buckled_mob.has_status_effect(/datum/status_effect/pregnancy)
	if(prego)
		points_awarded += prego.pregnancy_stage + rand(0,5)

	for(var/obj/item/organ/genital/genital in buckled_mob.organs)
		if(istype(genital, /obj/item/organ/genital/testicles))
			var/obj/item/organ/genital/testicles/testies = genital
			points_awarded += testies.cumshot_size
		// if breasts are filled. add points
		else if(istype(genital, /obj/item/organ/genital/breasts))
			var/obj/item/organ/genital/breasts/boob = genital
			var/datum/reagent/consumable/milk/milk_reg = boob.internal_fluid_datum
			if(istype(milk_reg))
				points_awarded += milk_reg.volume

		points_awarded += genital.genital_size
	points_awarded *= tier
	points_awarded *= CONFIG_GET(number/sex_table_multiplier)
	switch(point_type)
		if(POINT_TYPE_SCIENCE)
			var/datum/techweb/station_techweb = locate(/datum/techweb/science) in SSresearch.techwebs
			if(station_techweb)
				station_techweb.add_point_list(list(TECHWEB_POINT_TYPE_GENERIC = points_awarded))
			else
				say(LANG("obj.97318dfca34c1478", null))
		else
			var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
			if(D)
				D.adjust_money(points_awarded)
	if(points_awarded)
		var/add_s = points_awarded == 1 ? "" : "s"
		say(LANG("obj.ab49da724cc6bd2e", list(points_awarded, point_type == POINT_TYPE_SCIENCE ? "point" : "credit", add_s)))
		var/list/quotes = list(
			"Thank you for your contribution to science!" = 72,
			"Goooooood boooooy!" = 16,
			"That's a big one." = 10,
			"Oh yeah we like that..." = 2,
		)
		say(pick_weight(quotes))

		// thank you.
		if(points_awarded >= 100) // idk this value probably needs tweaking
			// you did an AWESOME job and therefore you get a nice sound effect played
			var/list/awesome_sounds = list(
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Awesome_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Congratulations_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Epic_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Flawless_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_ThatsAmazing_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_ThatsIncredible_02.ogg',
				'modular_zzplurt/sound/machines/research_table/EpicGameEncouragementPhrases_Victory_02.ogg'
			)
			playsound(src, pick(awesome_sounds), 30, 1)
		else
			playsound(src, 'sound/machines/chime.ogg', 30, 1)

	// YOU FUCKING SUCK AT SEX
	else
		say(LANG("obj.ecd06bdb28341bd5", list(point_type == POINT_TYPE_SCIENCE ? "points" : "credits"))) // Probably has no genitals at all
		playsound(src, 'sound/machines/buzz/buzz-two.ogg', 30, 1)

#undef POINT_TYPE_CARGO
#undef POINT_TYPE_SCIENCE
