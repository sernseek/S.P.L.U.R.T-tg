// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//SPLURT EDIT REMOVAL BEGIN - Interactions - Moved climax defines to global defines
/*
#define CLIMAX_VAGINA "Vagina"
#define CLIMAX_PENIS "Penis"
#define CLIMAX_BOTH "Both"
*/
//SPLURT EDIT REMOVAL END

#define CLIMAX_ON_FLOOR "On the floor"
#define CLIMAX_IN_OR_ON "Climax in or on someone"
#define CLIMAX_OPEN_CONTAINER "Fill reagent container"
#define CLIMAX_PORTAL "Through the portal"

// both of these are pretty much arbitrary
#define MIN_CUM_THRESHOLD 5
#define MIN_VAGINA_WETNESS_THRESHOLD 3.33

/mob/living // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	/// Used to prevent nightmare scenarios.
	var/refractory_period

/mob/living/proc/climax(manual = TRUE, mob/living/partner = null, datum/interaction/climax_interaction = null, interaction_position = null) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	if (CONFIG_GET(flag/disable_erp_preferences))
		return

	var/nonhuman_bypass_self = !ishuman(src) && !src.client && !SSinteractions.is_blacklisted(src) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable
	var/nonhuman_bypass_partner = !ishuman(partner) && !partner?.client && !SSinteractions.is_blacklisted(partner) // SPLURT EDIT - INTERACTIONS - All mobs should be interactable

	if(!(client?.prefs?.read_preference(/datum/preference/toggle/erp/autocum) || nonhuman_bypass_self) && !manual)
		return
	if(refractory_period > REALTIMEOFDAY)
		return
	//SPLURT ADDITION START
	// MKUltra cum lock hard block: do not proceed to climax when locked.
	if(GLOB.mkultra_cum_locks && GLOB.mkultra_cum_locks[src])
		visible_message(span_purple(LANG("mob.a625e2c0af47008c", list(src))), span_purple(LANG("mob.82adda6cbd08182d", null)))
		return FALSE
	//SPLURT ADDITION END
	refractory_period = REALTIMEOFDAY + 30 SECONDS
	if(has_status_effect(/datum/status_effect/climax_cooldown) || !(client?.prefs?.read_preference(/datum/preference/toggle/erp) || nonhuman_bypass_self))
		return

	if(HAS_TRAIT(src, TRAIT_NEVERBONER) || has_status_effect(/datum/status_effect/climax_cooldown) || (!has_vagina() && !has_penis()))
		visible_message(span_purple(LANG("mob.65eb8f7ff62cbbf1", list(src))), \
			span_purple(LANG("mob.59077c060edb0956", null)))
		return TRUE

	// Reduce pop-ups and make it slightly more frictionless (lewd).
	var/climax_choice = has_penis() ? CLIMAX_PENIS : CLIMAX_VAGINA

	if(manual)
		var/list/genitals = list()
		if(has_vagina())
			genitals.Add(CLIMAX_VAGINA)
			if(has_penis())
				genitals.Add(CLIMAX_PENIS)
				genitals.Add(CLIMAX_BOTH)
		else if(has_penis())
			genitals.Add(CLIMAX_PENIS)
		climax_choice = tgui_alert(src, LANG("mob.d2fdc32c9c731af9", null), LANG("mob.6136bced200ef277", null), genitals)
	else if(istype(climax_interaction, /datum/interaction) && climax_interaction.cum_genital?.len && climax_interaction.cum_genital[interaction_position])
		climax_choice = climax_interaction.cum_genital[interaction_position]
	conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/end.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
	//SPLURT EDIT ADDITION END
	switch(gender)
		if(MALE)
			conditional_pref_sound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
		if(FEMALE)
			conditional_pref_sound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_f1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)

	// SPLURT EDIT ADDITION
	SEND_SIGNAL(src, COMSIG_MOB_POST_CLIMAX, partner, interaction_position, manual)
	// SPLURT EDIT ADDITION END

	var/self_orgasm = FALSE
	var/self_their = p_their()

	var/obj/item/organ/genital/testicles/testicles = get_organ_slot(ORGAN_SLOT_TESTICLES)
	testicles?.calculate_cumshot()

	if(climax_choice == CLIMAX_PENIS || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/genital/penis/penis = get_organ_slot(ORGAN_SLOT_PENIS)
		if(!(testicles || testicles?.reagents.total_volume < MIN_CUM_THRESHOLD) && ishuman(src)) //If we have no god damn balls, we can't cum anywhere... GET BALLS! , OR theres so little in your balls that nothing comes out... // SPLURT EDIT - Interactions
			visible_message(span_userlove(LANG("mob.6e0187edc6da1516", list(src, self_their))), \
				span_userlove(LANG("mob.f8c5d54c781159d4", null)))

		else if(is_wearing_condom())
			var/obj/item/clothing/sextoy/condom/condom = src:penis // bruh 💀⚰️💀⚰️💀⚰️💀⚰️💀
			condom.condom_use() // condoms probably should become reagent containers at some point
			visible_message(span_userlove(LANG("mob.a1e08d66ff49d273", list(src, self_their, condom))), \
				span_userlove(LANG("mob.02a031057c854063", list(condom))))
			testicles?.reagents.remove_all(testicles.cumshot_size)

		else if(!is_bottomless() && penis.visibility_preference != GENITAL_ALWAYS_SHOW)
			visible_message(span_userlove(LANG("mob.64e23146aa57ab55", list(src, self_their))), \
				span_userlove(LANG("mob.d44b5efa0dc52cf0", null)))
			self_orgasm = TRUE
			testicles?.reagents.remove_all(testicles.cumshot_size)

		else
			var/list/interactable_inrange_mobs = list()
			var/target_choice //SPLURT EDIT CHANGE - Interactions
			// monkey see, monkey do
			var/list/interactable_inrange_open_containers = list()

			// Unfortunately prefs can't be checked here, because byond/tgstation moment.
			for(var/mob/living/iterating_mob in (view(1, src) - src))
				interactable_inrange_mobs[iterating_mob.name] = iterating_mob

			// this should be making a list of cups(?)
			for(var/obj/item/reagent_containers/cup/iterating_open_container in (view(1, src) - src))
				interactable_inrange_open_containers[iterating_open_container.name] = iterating_open_container

			var/list/buttons = list(CLIMAX_ON_FLOOR)
			if(interactable_inrange_mobs.len)
				buttons += CLIMAX_IN_OR_ON

			if(interactable_inrange_open_containers.len)
				buttons += CLIMAX_OPEN_CONTAINER

			// If your using a LustWish portal lets you cum through it
			var/obj/structure/lewd_portal/portal = src.buckled
			if(istype(portal, /obj/structure/lewd_portal))
				buttons += CLIMAX_PORTAL

			var/penis_climax_choice = climax_interaction && !manual ? CLIMAX_IN_OR_ON : tgui_alert(src, LANG("mob.7cd3302cd4ec9632", null), LANG("mob.328dbd2f47a0bbd0", null), buttons) //SPLURT EDIT CHANGE - Interactions

			var/create_cum_decal = FALSE

			if(!penis_climax_choice || penis_climax_choice == CLIMAX_ON_FLOOR)
				create_cum_decal = TRUE
				visible_message(span_userlove(LANG("mob.47e60ad7a8ba60c4", list(src, self_their))), \
					span_userlove(LANG("mob.28062261be0abaec", null)))
				testicles?.reagents.remove_all(testicles.cumshot_size)

			else if(penis_climax_choice == CLIMAX_OPEN_CONTAINER || ((!climax_interaction?.cum_target[interaction_position] || !partner) && climax_interaction?.fluid_transfer_objects.Find(REF(src)))) // SPLURT EDIT - Interactions - Added support for fluid transfer objects
				target_choice = climax_interaction?.fluid_transfer_objects.Find(REF(src)) ? climax_interaction.fluid_transfer_objects[REF(src)].name : tgui_input_list(src, LANG("mob.78e89e0e585daf53", null), LANG("mob.93ab300d3b4b2851", null), interactable_inrange_open_containers) //SPLURT EDIT CHANGE - Interactions
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove(LANG("mob.47e60ad7a8ba60c4", list(src, self_their))), \
						span_userlove(LANG("mob.28062261be0abaec", null)))
					testicles?.reagents.remove_all(testicles.cumshot_size)
				else
					var/obj/item/reagent_containers/cup/target_open_container = interactable_inrange_open_containers[target_choice] || climax_interaction.fluid_transfer_objects[REF(src)] // SPLURT EDIT - Interactions - Added support for fluid transfer objects
					if(target_open_container.is_refillable() && target_open_container.is_drainable())
						// here's where we actually do the cumming(?)
						var/cum_volume = testicles.cumshot_size
						var/total_volume_w_cum = cum_volume + target_open_container.reagents.total_volume
						conditional_pref_sound(get_turf(src), SFX_DESECRATION, 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
						if(target_open_container.reagents.holder_full())
							// its full already
							add_cum_splatter_floor(get_turf(target_open_container))
							visible_message(span_userlove(LANG("mob.b19e3b70701833b5", list(src, target_open_container))), \
								span_userlove(LANG("mob.30345c748f32c46b", list(target_open_container))))
						else
							testicles?.reagents.trans_to(target_open_container, testicles.cumshot_size, transferred_by = src)
							if(total_volume_w_cum > target_open_container.volume)
								// overflow, make the decal
								add_cum_splatter_floor(get_turf(target_open_container))
								visible_message(span_userlove(LANG("mob.6c963fa1f443d537", list(src, self_their, target_open_container))), \
									span_userlove(LANG("mob.de263d6cb4af9abc", list(target_open_container))))
							else
								visible_message(span_userlove(LANG("mob.a9928d9e3c4424d8", list(src, self_their, target_open_container))), \
									span_userlove(LANG("mob.00685b844c8fea1f", list(target_open_container))))
					else
						// cum fail
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.47e60ad7a8ba60c4", list(src, self_their))), \
							span_userlove(LANG("mob.28062261be0abaec", null)))
						testicles?.reagents.remove_all(testicles.cumshot_size)

			else if(penis_climax_choice == CLIMAX_PORTAL)
				to_chat(src, LANG("mob.1628f71d700da119", null))
				portal.relayed_body.visible_message(LANG("mob.ee477d961cef112d", list(portal.relayed_body)))
				add_cum_splatter_floor(get_turf(portal.relayed_body))

			else
				target_choice = climax_interaction && !manual ? partner?.name : tgui_input_list(src, LANG("mob.4beec21eb8965590", null), LANG("mob.93ab300d3b4b2851", null), interactable_inrange_mobs) //SPLURT EDIT CHANGE - Interactions
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove(LANG("mob.47e60ad7a8ba60c4", list(src, self_their))), \
						span_userlove(LANG("mob.28062261be0abaec", null)))
				else
					var/mob/living/target_mob = climax_interaction && !manual && partner ? partner : interactable_inrange_mobs[target_choice] //SPLURT EDIT CHANGE - Interactions
					var/target_mob_them = target_mob.p_them()

					var/list/target_buttons = list()

					if(istype(target_mob, /mob/living/carbon/human))
						var/mob/living/carbon/human/target_human = target_mob
						if(!target_human.wear_mask)
							target_buttons += "mouth"
					else
						target_buttons += "mouth"
					if(target_mob.has_vagina(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_VAGINA
					if(target_mob.has_anus(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_ANUS //SPLURT EDIT CHANGE - Interactions - Changed asshole to anus for consistency
					if(target_mob.has_penis(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_PENIS
						var/obj/item/organ/genital/penis/other_penis = target_mob.get_organ_slot(ORGAN_SLOT_PENIS)
						if(other_penis?.sheath != null && other_penis?.sheath != "None") // SPLURT EDIT - Fix runtime on sim genitals
							target_buttons += "sheath"
					target_buttons += "On [target_mob_them]"

					//SPLURT EDIT CHANGE BEGIN - Interactions
					var/climax_into_choice
					var/interaction_inside = partner?.get_organ_slot(climax_interaction?.cum_target[interaction_position])
					if(!interaction_inside)
						interaction_inside = target_buttons.Find(climax_interaction?.cum_target[interaction_position])
						if(interaction_inside)
							interaction_inside = climax_interaction.cum_target[interaction_position]
					else
						var/obj/item/organ/genital = interaction_inside
						interaction_inside = genital.slot

					if(climax_interaction && !manual && interaction_inside)
						climax_into_choice = climax_interaction.cum_target[interaction_position]
					else if(manual)
						climax_into_choice = tgui_input_list(src, LANG("mob.a90ce281117696da", list(target_mob)), LANG("mob.57ec68b8384177b5", null), target_buttons)
					else
						climax_into_choice = "On [target_mob_them]"

					if(climax_interaction && !manual && climax_interaction.show_climax(src, target_mob, interaction_position))
						create_cum_decal = !interaction_inside
					else if(!climax_into_choice)
					//SPLURT EDIT CHANGE END
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.c112e520b16cc327", list(src))), \
							span_userlove(LANG("mob.28062261be0abaec", null)))
						conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
					else if(climax_into_choice == "On [target_mob_them]")
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.82a775d2165fb8ab", list(src, target_mob))), \
							span_userlove(LANG("mob.967166cec24ac1cb", list(target_mob))))
						conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
					else
						visible_message(
							span_userlove(LANG("mob.98f8dc62fa355055", list(src, self_their, target_mob, climax_into_choice, target_mob_them))),
							span_userlove(LANG("mob.8cccffb856944bd9", list(target_mob, climax_into_choice, target_mob_them))))
						to_chat(target_mob, span_userlove(LANG("mob.a85881eb6949869a", list(climax_into_choice, src, self_their))))
						conditional_pref_sound(get_turf(target_mob), climax_into_choice == "mouth" ? pick('modular_zzplurt/sound/interactions/mouthend (1).ogg', 'modular_zzplurt/sound/interactions/mouthend (2).ogg') : 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
						//SPLURT EDIT ADDITION BEGIN - Genital Inflation and pregnancy
						var/datum/component/interactable/interactable = target_mob.GetComponent(/datum/component/interactable)
						if(interactable)
							interactable.climax_inflate_genital(src, "testicles", climax_into_choice)
						var/client/preference_source = GET_CLIENT(target_mob)
						#ifdef TESTING
						if(!preference_source)
							preference_source = GET_CLIENT(src)
						#endif
						if(ishuman(target_mob) && preference_source && \
							!HAS_TRAIT(src, TRAIT_INFERTILE) && !HAS_TRAIT(target_mob, TRAIT_INFERTILE))
							var/genital_pass = FALSE
							switch(interaction_inside)
								if(ORGAN_SLOT_ANUS)
									genital_pass = preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/anal_insemination)
								if(ORGAN_SLOT_VAGINA)
									genital_pass = preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/vaginal_insemination)
								if(CLIMAX_TARGET_MOUTH)
									genital_pass = preference_source.prefs.read_preference(/datum/preference/toggle/pregnancy/oral_insemination)
							if(genital_pass && prob(preference_source.prefs.read_preference(/datum/preference/numeric/pregnancy/chance)))
								target_mob.apply_status_effect(/datum/status_effect/pregnancy, target_mob, src)
						//SPLURT EDIT ADDITION END

			//SPLURT EDIT CHANGE BEGIN - Interactions
			if(!(climax_interaction?.interaction_modifier_flags & INTERACTION_OVERRIDE_FLUID_TRANSFER) && ishuman(src))
				if(create_cum_decal)
					if(HAS_TRAIT(src, TRAIT_MESSY))
						// Transfer reagents to the turf uisng liquids system
						var/datum/reagents/R = new(testicles.cumshot_size)
						testicles.reagents.trans_to(R, testicles.cumshot_size, transferred_by = src)
						if(partner && partner != src)
							// Get turf between src and partner for directional splatter
							var/turf/T = get_turf(partner)
							T.add_liquid_from_reagents(R, FALSE, 1, get_turf(src), partner)
						else
							var/turf/T = get_turf(src)
							T.add_liquid_from_reagents(R, FALSE, 1)
						qdel(R)
					else
						testicles.reagents.remove_all(testicles.cumshot_size)
						add_cum_splatter_floor(get_turf(src), cum_reagent = testicles.internal_fluid_datum)
				else if(partner || interactable_inrange_mobs[target_choice])
					// Transfer reagents directly to partner
					var/mob/living/target_mob = partner || interactable_inrange_mobs[target_choice]

					var/datum/reagents/R = new(testicles.cumshot_size)

					//Check if the target has custom genital fluids enabled
					if(!(target_mob.client?.prefs?.read_preference(/datum/preference/toggle/erp/custom_genital_fluids) || nonhuman_bypass_partner))
						R.add_reagent(initial(testicles.internal_fluid_datum), testicles.cumshot_size)
						testicles.reagents.remove_all(testicles.cumshot_size)
					else
						testicles.reagents.trans_to(R, testicles.cumshot_size)

					R.trans_to(target_mob, R.total_volume, transferred_by = src, methods = INGEST)
					qdel(R)
				else
					testicles.reagents.remove_all(testicles.cumshot_size)
			//SPLURT EDIT CHANGE END

		try_lewd_autoemote("moan")
		if(climax_choice == CLIMAX_PENIS)
			apply_status_effect(/datum/status_effect/climax)
			apply_status_effect(/datum/status_effect/climax_cooldown)
			if(self_orgasm)
				add_mood_event("orgasm", /datum/mood_event/climaxself)
			if(climax_interaction && !manual)
				climax_interaction.post_climax(src, partner, interaction_position)
			return TRUE

	if(climax_choice == CLIMAX_VAGINA || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/genital/vagina/vagina = get_organ_slot(ORGAN_SLOT_VAGINA)
		//SPLURT EDIT CHANGE BEGIN - Interactions
		if(!is_bottomless() && vagina?.visibility_preference != GENITAL_ALWAYS_SHOW)
			if(vagina?.reagents.total_volume >= MIN_VAGINA_WETNESS_THRESHOLD)
				visible_message(
					span_userlove(LANG("mob.945b0574d3346a04", list(src, self_their, self_their))),
					span_userlove(LANG("mob.e799c6ce774a1f4a", null)))
				self_orgasm = TRUE
			else
				visible_message(
					span_userlove(LANG("mob.945b0574d3346a04", list(src, self_their, self_their))),
					span_userlove(LANG("mob.839da9a6979ceff4", null)))
		else
			var/list/interactable_inrange_mobs = list()
			var/list/interactable_inrange_open_containers = list()
			var/target_choice //SPLURT EDIT CHANGE - Interactions

			for(var/mob/living/iterating_mob in (view(1, src) - src))
				interactable_inrange_mobs[iterating_mob.name] = iterating_mob

			for(var/obj/item/reagent_containers/container in view(1, src))
				if(container.is_open_container() || istype(container, /obj/item/reagent_containers/cup))
					interactable_inrange_open_containers[container.name] = container

			var/list/buttons = list(CLIMAX_ON_FLOOR)
			if(interactable_inrange_mobs.len)
				buttons += CLIMAX_IN_OR_ON
			if(interactable_inrange_open_containers.len)
				buttons += CLIMAX_OPEN_CONTAINER

			// If your using a LustWish portal lets you cum through it
			var/obj/structure/lewd_portal/portal = src.buckled
			if(istype(portal, /obj/structure/lewd_portal))
				buttons += CLIMAX_PORTAL

			var/vagina_climax_choice = climax_interaction && !manual ? CLIMAX_IN_OR_ON : tgui_alert(src, LANG("mob.6b8fffca5753c855", null), LANG("mob.8e08d34d00504ebc", null), buttons)

			var/create_cum_decal = FALSE

			if(!vagina_climax_choice || vagina_climax_choice == CLIMAX_ON_FLOOR)
				create_cum_decal = TRUE
				visible_message(span_userlove(LANG("mob.7dbe182c029337a6", list(src, p_they()))), \
					span_userlove(LANG("mob.8c04090367b18281", null)))
			else if(vagina_climax_choice == CLIMAX_OPEN_CONTAINER || ((!climax_interaction?.cum_target[interaction_position] || !partner) && climax_interaction?.fluid_transfer_objects.Find(REF(src)))) // SPLURT EDIT - Interactions - Added support for fluid transfer objects
				target_choice = climax_interaction?.fluid_transfer_objects.Find(REF(src)) ? climax_interaction.fluid_transfer_objects[REF(src)].name : tgui_input_list(src, LANG("mob.c27260f083f05ef0", null), LANG("mob.93ab300d3b4b2851", null), interactable_inrange_open_containers) // SPLURT EDIT - Interactions - Added support for fluid transfer objects
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove(LANG("mob.e898bc143c681bf4", list(src))), \
						span_userlove(LANG("mob.8544f48fd5bdbf66", null)))
					vagina?.reagents.remove_all(vagina?.reagents.total_volume)
				else
					var/obj/item/reagent_containers/cup/target_open_container = interactable_inrange_open_containers[target_choice] || climax_interaction.fluid_transfer_objects[REF(src)] // SPLURT EDIT - Interactions - Added support for fluid transfer objects
					if(target_open_container.is_refillable() && target_open_container.is_drainable())
						var/squirt_volume = vagina?.reagents.total_volume
						var/total_volume_w_squirt = squirt_volume + target_open_container.reagents.total_volume
						conditional_pref_sound(get_turf(src), SFX_DESECRATION, 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
						if(target_open_container.reagents.holder_full())
							add_cum_splatter_floor(get_turf(target_open_container), female = TRUE)
							visible_message(span_userlove(LANG("mob.fbe1b68a8985f3b0", list(src, target_open_container))), \
								span_userlove(LANG("mob.7e80486f9b59a9a3", list(target_open_container))))
						else
							vagina?.reagents.trans_to(target_open_container, vagina?.reagents.total_volume, transferred_by = src)
							if(total_volume_w_squirt > target_open_container.volume)
								add_cum_splatter_floor(get_turf(target_open_container), female = TRUE)
								visible_message(span_userlove(LANG("mob.49f5d03ded11b10e", list(src, target_open_container))), \
									span_userlove(LANG("mob.6229dea5f4f084fa", list(target_open_container))))
							else
								visible_message(span_userlove(LANG("mob.70b360223ab5487f", list(src, target_open_container))), \
									span_userlove(LANG("mob.82ae21b07e0b72dd", list(target_open_container))))
					else
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.e898bc143c681bf4", list(src))), \
							span_userlove(LANG("mob.8544f48fd5bdbf66", null)))
						vagina?.reagents.remove_all(vagina?.reagents.total_volume)
			else if(vagina_climax_choice == CLIMAX_PORTAL)
				to_chat(src, LANG("mob.652f8eed501fa626", null))
				portal.relayed_body.visible_message(LANG("mob.e898bc143c681bf4", list(portal.relayed_body)))
				add_cum_splatter_floor(get_turf(portal.relayed_body), female = TRUE)
				vagina?.reagents.remove_all(vagina?.reagents.total_volume)
			else
				target_choice = climax_interaction && !manual ? partner.name : tgui_input_list(src, LANG("mob.7e60f515482972da", null), LANG("mob.93ab300d3b4b2851", null), interactable_inrange_mobs)
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove(LANG("mob.7dbe182c029337a6", list(src, p_they()))), \
						span_userlove(LANG("mob.8c04090367b18281", null)))
				else
					var/mob/living/target_mob = climax_interaction && !manual ? partner : interactable_inrange_mobs[target_choice]
					var/target_mob_them = target_mob.p_them()

					var/list/target_buttons = list()

					if(istype(target_mob, /mob/living/carbon/human))
						var/mob/living/carbon/human/target_human = target_mob
						if(!target_human.wear_mask)
							target_buttons += "mouth"
					else
						target_buttons += "mouth"
					if(target_mob.has_vagina(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_VAGINA
					if(target_mob.has_anus(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_ANUS
					if(target_mob.has_penis(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_PENIS
						var/obj/item/organ/genital/penis/other_penis = target_mob.get_organ_slot(ORGAN_SLOT_PENIS)
						if(other_penis?.sheath != null && other_penis?.sheath != "None") // SPLURT EDIT - Fix runtime on sim genitals
							target_buttons += "sheath"
					target_buttons += "On [target_mob_them]"

					var/climax_into_choice
					var/interaction_inside = partner?.get_organ_slot(climax_interaction?.cum_target[interaction_position])
					if(!interaction_inside)
						interaction_inside = target_buttons.Find(climax_interaction?.cum_target[interaction_position])
						if(interaction_inside)
							interaction_inside = climax_interaction.cum_target[interaction_position]
					else
						var/obj/item/organ/genital = interaction_inside
						interaction_inside = genital.slot

					if(climax_interaction && !manual && interaction_inside)
						climax_into_choice = climax_interaction.cum_target[interaction_position]
					else if(manual)
						climax_into_choice = tgui_input_list(src, LANG("mob.c87c6177d4e40ed2", list(target_mob)), LANG("mob.57ec68b8384177b5", null), target_buttons)
					else
						climax_into_choice = "On [target_mob_them]"

					if(climax_interaction && !manual && climax_interaction.show_climax(src, target_mob, interaction_position))
						create_cum_decal = !interaction_inside
					else if(!climax_into_choice)
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.c4ad354edaf85f8b", list(src))), \
							span_userlove(LANG("mob.0c25fde30cf775d1", null)))
						conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
					else if(climax_into_choice == "On [target_mob_them]")
						create_cum_decal = TRUE
						visible_message(span_userlove(LANG("mob.251ec9bf232c4268", list(src, target_mob))), \
							span_userlove(LANG("mob.e3d3be627a3397ac", list(target_mob))))
						conditional_pref_sound(get_turf(src), 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
					else
						visible_message(span_userlove(LANG("mob.ef3226d3eb7130b0", list(src, target_mob, climax_into_choice))), \
							span_userlove(LANG("mob.0d071cedc82c09e1", list(target_mob, climax_into_choice))))
						to_chat(target_mob, span_userlove(LANG("mob.aafe48a0918eaa4c", list(climax_into_choice, src))))
						conditional_pref_sound(get_turf(target_mob), climax_into_choice == "mouth" ? pick('modular_zzplurt/sound/interactions/mouthend (1).ogg', 'modular_zzplurt/sound/interactions/mouthend (2).ogg') : 'modular_zzplurt/sound/interactions/endout.ogg', 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds) //SPLURT EDIT CHANGE - Interactions
						//SPLURT EDIT ADDITION BEGIN - Genital Inflation
						var/datum/component/interactable/interactable = target_mob.GetComponent(/datum/component/interactable)
						if(interactable)
							interactable.climax_inflate_genital(src, "vagina", climax_into_choice)
						//SPLURT EDIT ADDITION END
			if(!(climax_interaction?.interaction_modifier_flags & INTERACTION_OVERRIDE_FLUID_TRANSFER))
				if(create_cum_decal)
					if(HAS_TRAIT(src, TRAIT_MESSY))
						var/datum/reagents/R = new(vagina?.internal_fluid_maximum)
						vagina?.reagents.trans_to(R, vagina?.reagents.total_volume)
						if(partner && partner != src)
							var/turf/T = get_turf(partner)
							T.add_liquid_from_reagents(R, FALSE, 1, get_turf(src), partner)
						else
							var/turf/T = get_turf(src)
							T.add_liquid_from_reagents(R, FALSE, 1)
						qdel(R)
					else
						vagina?.reagents.remove_all(vagina?.reagents.total_volume)
						add_cum_splatter_floor(get_turf(src), female = TRUE, cum_reagent = vagina?.internal_fluid_datum)
				else if(partner || interactable_inrange_mobs[target_choice])
					var/mob/living/target_mob = partner || interactable_inrange_mobs[target_choice]

					var/datum/reagents/R = new(vagina?.internal_fluid_maximum)
					//Check if the target has custom genital fluids enabled
					if(!(target_mob.client?.prefs?.read_preference(/datum/preference/toggle/erp/custom_genital_fluids) || nonhuman_bypass_partner))
						R.add_reagent(initial(vagina?.internal_fluid_datum), vagina?.reagents.total_volume)
						vagina?.reagents.remove_all(vagina?.reagents.total_volume)
					else
						vagina?.reagents.trans_to(R, vagina?.reagents.total_volume)

					R.trans_to(target_mob, R.total_volume, transferred_by = src, methods = INGEST)
					qdel(R)
				else
					vagina?.reagents.remove_all(vagina?.reagents.total_volume)
		//SPLURT EDIT CHANGE END

	apply_status_effect(/datum/status_effect/climax)
	apply_status_effect(/datum/status_effect/climax_cooldown)
	if(self_orgasm)
		add_mood_event("orgasm", /datum/mood_event/climaxself)

	// SPLURT EDIT ADDITION BEGIN - Interactions
	if(climax_interaction && !manual)
		climax_interaction.post_climax(src, partner, interaction_position)
	//SPLURT EDIT ADDITION END
	return TRUE

//SPLURT EDIT REMOVAL BEGIN - Interactions - Moved climax defines to global defines
/*
#undef CLIMAX_VAGINA
#undef CLIMAX_PENIS
#undef CLIMAX_BOTH
*/
//SPLURT EDIT REMOVAL END

#undef CLIMAX_ON_FLOOR
#undef CLIMAX_IN_OR_ON
#undef CLIMAX_OPEN_CONTAINER

#undef MIN_CUM_THRESHOLD
#undef MIN_VAGINA_WETNESS_THRESHOLD
#undef CLIMAX_PORTAL
