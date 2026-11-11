// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//handle the big steppy, except nice
/mob/living/proc/handle_micro_bump_helping(mob/living/target)
	if(ishuman(src))
		var/mob/living/carbon/human/user = src

		if(target.pulledby == user)
			return FALSE

		//Micro is on a table.
		var/turf/steppyspot = target.loc
		for(var/thing in steppyspot.contents)
			if(istype(thing, /obj/structure/table))
				return TRUE

		//Both small.
		if(get_size(user) <= RESIZE_A_TINYMICRO && get_size(target) <= RESIZE_A_TINYMICRO)
			now_pushing = 0
			user.forceMove(target.loc)
			return TRUE

		//Doing messages
		if(COMPARE_SIZES(user, target) >= 2) //if the initiator is twice the size of the micro
			now_pushing = 0
			// what the actual fuck sandpoot why was this a forcemove
			target.density = FALSE
			step(user, get_dir(user, target))
			target.density = TRUE

			//Smaller person being stepped on
			if(iscarbon(src))
				if(istype(user) && user.dna.features["taur"] == "Naga" || user.dna.features["taur"] == "Tentacle")
					target.visible_message(span_notice(LANG("mob.505ed50203abf1ed", list(src, target))), span_notice(LANG("mob.c6493896582c3847", list(src))))
				else
					target.visible_message(span_notice(LANG("mob.24f383d0d43f7500", list(src, target))), span_notice(LANG("mob.f7d4be5572b80a7f", list(src))))
				return TRUE

		//Smaller person stepping under a larger person
		if(COMPARE_SIZES(target, user) >= 2)
			user.forceMove(target.loc)
			now_pushing = 0
			micro_step_under(target)
			return TRUE

//Stepping on disarm intent -- TO DO, OPTIMIZE ALL OF THIS SHIT
/mob/living/proc/handle_micro_bump_other(mob/living/target)
	ASSERT(isliving(target))

	// if the target has the preference off, stop the interaction.
	if(get_size(target) > RESIZE_TINY)
		if(target.client?.prefs?.read_preference(/datum/preference/toggle/erp/stomping) == FALSE)
			return FALSE

	if(ishuman(src))
		var/mob/living/carbon/human/user = src

		if(target.pulledby == user)
			return FALSE

	//If on a table, don't
		var/turf/steppyspot = target.loc
		for(var/thing in steppyspot.contents)
			if(istype(thing, /obj/structure/table))
				return TRUE

	//Both small
		if(get_size(user) <= RESIZE_A_TINYMICRO && get_size(target) <= RESIZE_A_TINYMICRO)
			now_pushing = 0
			user.forceMove(target.loc)
			return TRUE

		if(COMPARE_SIZES(user, target) >= 2)
			log_combat(user, target, "stepped on", addition="[resolve_intent_name(user)] trample")
			if((user.mobility_flags & MOBILITY_MOVE) && !user.buckled)
				switch(resolve_intent_name(user))
					if("disarm")
						now_pushing = 0
						user.forceMove(target.loc)
						user.sizediffStamLoss(target)
						user.add_movespeed_modifier(/datum/movespeed_modifier/stomp, TRUE) //Full stop
						addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, remove_movespeed_modifier), MOVESPEED_ID_STOMP, TRUE), 3) //0.3 seconds
						if(iscarbon(user))
							if(istype(user) && user.dna.features["taur"] == "Naga" || user.dna.features["taur"] == "Tentacle")
								target.visible_message(span_danger(LANG("mob.39a6aec9a398ace1", list(src, target))), span_danger(LANG("mob.f9d0d65e98c1955a", list(src))))
							else
								target.visible_message(span_danger(LANG("mob.ab4ef8f699cfe433", list(src, target))), span_danger(LANG("mob.279450f06655272b", list(src))))
							return TRUE

					if("harm")
						now_pushing = 0
						user.forceMove(target.loc)
						user.sizediffStamLoss(target)
						user.sizediffBruteloss(target)
						playsound(loc, 'sound/misc/splort.ogg', 50, 1)
						user.add_movespeed_modifier(/datum/movespeed_modifier/stomp, TRUE)
						addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, remove_movespeed_modifier), MOVESPEED_ID_STOMP, TRUE), 1 SECONDS) //1 second
						//user.Stun(20)
						if(iscarbon(user))
							if(istype(user) && (user.dna.features["taur"] == "Naga" || user.dna.features["taur"] == "Tentacle"))
								target.visible_message(span_danger(LANG("mob.371a14a3764c9719", list(src, target))), span_userdanger(LANG("mob.43228988c43533f6", list(src))))
							else
								target.visible_message(span_danger(LANG("mob.2801f438b29854fd", list(src, target))), span_userdanger(LANG("mob.d840c5158ff92a0a", list(src))))
							return TRUE

					if("grab")
						now_pushing = 0
						user.forceMove(target.loc)
						user.sizediffStamLoss(target)
						user.sizediffStun(target)
						user.add_movespeed_modifier(/datum/movespeed_modifier/stomp, TRUE)
						addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, remove_movespeed_modifier), MOVESPEED_ID_STOMP, TRUE), 7)//About 3/4th a second
						if(iscarbon(user))
							var/feetCover = (user.wear_suit && (user.wear_suit.body_parts_covered & FEET)) || (user.w_uniform && (user.w_uniform.body_parts_covered & FEET) || (user.shoes && (user.shoes.body_parts_covered & FEET)))
							if(feetCover)
								if(user?.dna?.features["taur"] == "Naga" || user?.dna?.features["taur"] == "Tentacle")
									target.visible_message(span_danger(LANG("mob.c09ae88c15cc243e", list(src, target))), span_danger(LANG("mob.31e64365730609cf", list(src))))
								else
									target.visible_message(span_danger(LANG("mob.2f2488e06d260c66", list(src, target))), span_danger(LANG("mob.2b973f5fe48e2459", list(src))))
								return TRUE
							else
								if(user?.dna?.features["taur"] == "Naga" || user?.dna?.features["taur"] == "Tentacle")
									target.visible_message(span_danger(LANG("mob.2fa500a6ce958bf2", list(user, target))), span_userdanger(LANG("mob.c14c5bc8e1e7442c", list(src))))
									//target.mob_pickup_micro_feet(user)
									SEND_SIGNAL(target, COMSIG_MICRO_PICKUP_FEET, user)
								else
									target.visible_message(span_danger(LANG("mob.5f360316c7a4ce15", list(user, target))), span_userdanger(LANG("mob.ab46c26776de1f4b", list(src))))
									//target.mob_pickup_micro_feet(user)
									SEND_SIGNAL(target, COMSIG_MICRO_PICKUP_FEET, user)
								return TRUE

		if(COMPARE_SIZES(target, user) >= 2)
			user.forceMove(target.loc)
			now_pushing = 0
			micro_step_under(target)
			return TRUE

/mob/living/proc/macro_step_around(mob/living/target)
	if(ishuman(src))
		var/mob/living/carbon/human/validmob = src
		if(validmob?.dna?.features["taur"] == "Naga" || validmob?.dna?.features["taur"] == "Tentacle")
			visible_message(span_notice(LANG("mob.505ed50203abf1ed", list(validmob, target))), span_notice(LANG("mob.0ee7592c246d24ed", list(target))))
		else
			visible_message(span_notice(LANG("mob.919ee584ba87ba12", list(validmob, target))), span_notice(LANG("mob.676ec950c863fc15", list(target))))

//smaller person stepping under another person... TO DO, fix and allow special interactions with naga legs to be seen
/mob/living/proc/micro_step_under(mob/living/target)
	if(ishuman(src))
		var/mob/living/carbon/human/validmob = src
		if(validmob?.dna?.features["taur"] == "Naga" || validmob?.dna?.features["taur"] == "Tentacle")
			visible_message(span_notice(LANG("mob.cf4badf93a26ebf7", list(validmob, validmob))), span_notice(LANG("mob.72f5d3ac91995f32", list(target))))
		else
			visible_message(span_notice(LANG("mob.6e447b0054ec2e69", list(validmob, validmob))), span_notice(LANG("mob.fb65e4d94871ac51", list(target))))

//Proc for scaling stamina damage on size difference
/mob/living/carbon/proc/sizediffStamLoss(mob/living/carbon/target)
	var/S = COMPARE_SIZES(src, target) * 25 //macro divided by micro, times 25
	target.Knockdown(S) //final result in stamina knockdown

//Proc for scaling stuns on size difference (for grab intent)
/mob/living/carbon/proc/sizediffStun(mob/living/carbon/target)
	var/T = COMPARE_SIZES(src, target) * 2 //Macro divided by micro, times 2
	target.Stun(T)

//Proc for scaling brute damage on size difference
/mob/living/carbon/proc/sizediffBruteloss(mob/living/carbon/target)
	var/B = COMPARE_SIZES(src, target) * 3 //macro divided by micro, times 3
	target.adjust_brute_loss(B) //final result in brute loss

//Proc for instantly grabbing valid size difference. Code optimizations soon(TM)
/*
/mob/living/proc/sizeinteractioncheck(mob/living/target)
	if(abs(get_effective_size()/target.get_effective_size())>=2.0 && get_effective_size()>target.get_effective_size())
		return FALSE
	else
		return TRUE
*/
//Clothes coming off at different sizes, and health/speed/stam changes as well
