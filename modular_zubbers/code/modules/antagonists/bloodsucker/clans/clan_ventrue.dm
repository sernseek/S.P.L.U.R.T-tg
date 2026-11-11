// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
///The maximum level a Ventrue Bloodsucker can be, before they have to level up their ghoul instead.
#define VENTRUE_MAX_POWERS 3

/datum/bloodsucker_clan/ventrue
	name = CLAN_VENTRUE
	description = "The Ventrue Clan is extremely snobby with their meals, and refuse to drink blood from people without a mind. \n\
		You may have up to %MAX_POWERS% powers, anything further will be ranks to spend on their Favorite Ghoul through a Persuasion Rack. \n\
		The Favorite Ghoul will slowly turn more Vampiric this way, until they finally lose their last bits of Humanity. \n\
		Once you finish your embracing, the newly sired vampire will become just a ghoul, and you'll be able to sire another bloodsucker."
	clan_objective = /datum/objective/bloodsucker/embrace
	join_icon_state = "ventrue"
	join_description = "Lose the ability to drink from mindless mobs, can't level up or gain new powers, \
		instead you raise a ghoul into a Bloodsucker."
	blood_drink_type = BLOODSUCKER_DRINK_SNOBBY
	level_cost = BLOODSUCKER_LEVELUP_PERCENTAGE_VENTRUE

/datum/bloodsucker_clan/ventrue/New(datum/antagonist/bloodsucker/owner_datum)
	. = ..()
	description = replacetext(description, "%MAX_POWERS%", VENTRUE_MAX_POWERS)

/datum/bloodsucker_clan/ventrue/proc/has_enough_abilities()
	var/power_count = 0
	for(var/datum/action/cooldown/bloodsucker/power in bloodsuckerdatum.powers)
		if(!(power.purchase_flags & BLOODSUCKER_DEFAULT_POWER))
			power_count++
	if(power_count >= VENTRUE_MAX_POWERS)
		return TRUE
	return FALSE

/datum/bloodsucker_clan/ventrue/spend_rank(datum/antagonist/bloodsucker/source, cost_rank = TRUE, blood_cost)
	if(has_enough_abilities())
		to_chat(bloodsuckerdatum.owner.current, span_danger(LANG("datum.cfd925edc05adb4d", list(VENTRUE_MAX_POWERS))))
		return FALSE
	. = ..()

/datum/bloodsucker_clan/ventrue/proc/finish_spend_rank(datum/antagonist/ghoul/ghouldatum, cost_rank, blood_cost)
	finalize_spend_rank(bloodsuckerdatum, cost_rank, blood_cost)
	ghouldatum.LevelUpPowers()

/datum/bloodsucker_clan/ventrue/interact_with_ghoul(datum/antagonist/bloodsucker/source, datum/antagonist/ghoul/favorite/ghouldatum)
	. = ..()
	if(.)
		return TRUE
	if(!istype(ghouldatum))
		return FALSE
	to_chat(bloodsuckerdatum.owner.current, span_warning(LANG("datum.621674e745dbe6e8", list(ghouldatum.owner.current))))
	to_chat(bloodsuckerdatum.owner.current, span_warning(LANG("datum.62719c09bf0b4132", list(bloodsuckerdatum.GetUnspentRank() >= 1 ? "a unspent Rank" : "[bloodsuckerdatum.get_level_cost()] Blood Thickening Points"))))

	var/static/list/rank_options = list(
		"Yes" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_yes"),
		"No" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_no"),
	)
	var/rank_response = show_radial_menu(bloodsuckerdatum.owner.current, ghouldatum.owner.current, rank_options, radius = 36, require_near = TRUE)
	if(rank_response == "Yes")
		if(!bloodsuckerdatum.GetUnspentRank() >= 1 && !source.blood_level_gain(FALSE))
			to_chat(bloodsuckerdatum.owner.current, span_danger(LANG("datum.a73e3e036527ecb7", list(ghouldatum.owner.current))))
			return FALSE
		return ghoul_level(ghouldatum)
	return FALSE

/datum/bloodsucker_clan/ventrue/proc/ghoul_level(datum/antagonist/ghoul/favorite/ghouldatum)
	var/list/options = list_available_powers(ghouldatum.bloodsucker_powers)
	var/mob/living/carbon/human/target = ghouldatum.owner.current
	var/datum/action/cooldown/bloodsucker/choice = choose_powers(
		"You have the opportunity to level up your Favorite Ghoul. Select a power you wish them to receive.",
		"A wise master's hand is neccesary",
		options
	)
	if(!choice)
		return FALSE
	var/power_name = initial(choice.name)
	if(!ghouldatum.BuyPower(choice, ghouldatum.bloodsucker_powers))
		bloodsuckerdatum.owner.current.balloon_alert(bloodsuckerdatum.owner.current, LANG("datum.26fe0f51d1357001", list(target, power_name)))
		return FALSE
	bloodsuckerdatum.owner.current.balloon_alert(bloodsuckerdatum.owner.current, LANG("datum.7efa8caca76dc302", list(power_name)))
	to_chat(bloodsuckerdatum.owner.current, span_notice(LANG("datum.291faa3b586aeb05", list(target, power_name))))

	target.balloon_alert(target, LANG("datum.76fbe9e4e2a2744b", list(power_name)))
	to_chat(target, span_notice(LANG("datum.af5c65ea128d18bf", list(power_name))))

	ghouldatum.ghoul_level++
	finish_spend_rank(ghouldatum, TRUE, FALSE)
	bloodsuckerify(ghouldatum)
	return TRUE

/datum/bloodsucker_clan/ventrue/proc/bloodsuckerify(datum/antagonist/ghoul/favorite/ghouldatum)
	var/mob/living/carbon/human/target = ghouldatum.owner.current
	var/stage = ghouldatum.ghoul_level
	var/list/traits_possible = list(
		list(TRAIT_COLDBLOODED, TRAIT_NOBREATH, TRAIT_AGEUSIA),
		list(TRAIT_NOCRITDAMAGE, TRAIT_NOSOFTCRIT, TRAIT_SLEEPIMMUNE, TRAIT_VIRUSIMMUNE),
		list(TRAIT_NOHARDCRIT, TRAIT_HARDLY_WOUNDED)
	)
	var/traits_to_add = length(traits_possible) >= stage ? traits_possible[stage] : list()
	switch(stage)

		if(1)
			to_chat(target, span_notice(LANG("datum.222c4609ca3d19a0", null)))

		if(2)
			to_chat(target, span_notice(LANG("datum.3e9fa5683c9069dd", null)))
			if(ishuman(target))
				var/mob/living/carbon/human/human_target = target
				human_target.skin_tone = "albino"

		if(3)
			to_chat(target, span_notice(LANG("datum.67d98b194a7af3b9", null)))

		if(4 to INFINITY)
			var/datum/antagonist/bloodsucker/bloodsucker_target = IS_BLOODSUCKER(target)
			if(!bloodsucker_target)
				to_chat(target, span_notice(LANG("datum.a949cfcd7d132cd2", null)))
				// Unfavorites you, so the ventrue isn't stuck with you forever
				var/powers_to_transfer = list()
				// Get rid of the favorite datum and replace with a normal ghoul datum
				if(ghouldatum)
					ghouldatum.silent = TRUE
					for(var/datum/power as anything in ghouldatum.bloodsucker_powers)
						powers_to_transfer += power.type
					target.mind.remove_antag_datum(/datum/antagonist/ghoul/favorite)
				else
					target.remove_traits(assoc_to_values(traits_to_add), GHOUL_TRAIT)


				var/datum/antagonist/bloodsucker/vamp = new()
				vamp.ventrue_sired = bloodsuckerdatum
				bloodsucker_target = target.mind.add_antag_datum(vamp)
				bloodsucker_target.BuyPowers(powers_to_transfer)
				// Check for the recuperate power and remove it if they have it
				bloodsuckerdatum.owner.current.add_mood_event("madevamp", /datum/mood_event/madevamp)


	if(ghouldatum && QDELETED(ghouldatum) && length(traits_to_add))
		target.add_traits(traits_to_add, GHOUL_TRAIT)
		ghouldatum.traits += traits_to_add

/datum/bloodsucker_clan/ventrue/favorite_ghoul_gain(datum/antagonist/bloodsucker/source, datum/antagonist/ghoul/ghouldatum)
	to_chat(source.owner.current, span_announce(LANG("datum.ad3bf54339352c22", null)))
	ghouldatum.BuyPower(/datum/action/cooldown/bloodsucker/distress)

/datum/bloodsucker_clan/ventrue/is_valid_ghoul(datum/antagonist/ghoul/ghoul_type)
	. = ..()
	if(!.)
		return FALSE
	var/datum/antagonist/ghoul/favorite = /datum/antagonist/ghoul/favorite
	if(ghoul_type != favorite)
		// no ghoul slots and trying to make a non-favorite ghoul, don't softlock yourself
		if(bloodsuckerdatum.free_ghoul_slots() < 1 && !bloodsuckerdatum.special_ghouls[initial(favorite.special_type)])
			to_chat(bloodsuckerdatum.owner.current, span_danger(LANG("datum.b082d43e1fc425c1", null)))
			return FALSE
	return TRUE

#undef VENTRUE_MAX_POWERS
