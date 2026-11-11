// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define NARRATE_RANGE_SAME_TILE "Same Tile"
#define NARRATE_RANGE_ONE_TILE "1-Tile Range"
#define NARRATE_RANGE_MAX "Max Range"
#define NARRATE_RANGE_CUSTOM "Custom Range"

GAME_VERB_DESC(/mob/living, narrate, "旁白", "Allows you to send a narration message to a target or area", "IC")
	usr.emote("narrate")

/datum/emote/narrate
	name = "IC Narrate"
	key = "narrate"
	message = null

/datum/emote/narrate/run_emote(mob/living/user, params, type_override = null, intentional = TRUE)
	if(GLOB.say_disabled)	// This is here to try to identify lag problems
		to_chat(user, span_danger(LANG("datum.b79ad8a388d1b3a4", null)))
		return

	if(IS_UNCONSCIOUS_OR_CRIT(user))
		to_chat(user, span_warning(LANG("datum.eca8b42e19b8e527", null)))
		return

	if(user.client.prefs?.muted & MUTE_IC)
		to_chat(user, span_danger(LANG("datum.52d0317fd997c539", null)))
		return

	var/message = tgui_input_text(user, LANG("datum.6872f43bdd6ce2b2", null), LANG("datum.7491658163f8dab0", null), null, MAX_MESSAGE_LEN, TRUE)
	if(!message)
		return

	// Account for AI projecting on a holopad
	var/atom/movable/user_mob_or_hologram = GLOB.hologram_impersonators[user] || user

	var/list/viewers = get_hearers_in_view(world.view, user_mob_or_hologram)
	viewers -= GLOB.dead_mob_list
	viewers.Remove(user_mob_or_hologram)
	for(var/mob/mob in viewers) // Filters out the AI eye and clientless mobs.
		if(isaicamera(mob) || !mob.client)
			viewers.Remove(mob)

	var/list/targets = list(NARRATE_RANGE_SAME_TILE, NARRATE_RANGE_ONE_TILE, NARRATE_RANGE_MAX, NARRATE_RANGE_CUSTOM) + viewers
	var/target = tgui_input_list(user, LANG("datum.153e9cb537804b6c", null), LANG("datum.eb4c7c3f77033760", null), targets)

	switch(target)
		if(NARRATE_RANGE_SAME_TILE)
			target = 0
		if(NARRATE_RANGE_ONE_TILE)
			target = 1
		if(NARRATE_RANGE_MAX)
			target = 7
		if(NARRATE_RANGE_CUSTOM)
			target = tgui_input_number(user, LANG("datum.843348a41bd328d8", null), LANG("datum.26ec3bb2e6c5fa35", null), max_value = world.view)
	if(isnull(target))
		return

	user.log_message(message, LOG_EMOTE)
	user.show_message(span_narrate("[message]"))

	// Handle target = range
	if(isnum(target))
		// Regenerate viewer list, people may have moved out of range since
		viewers = get_hearers_in_view(target, user_mob_or_hologram) - GLOB.dead_mob_list - user
		for(var/obj/effect/overlay/holo_pad_hologram/holo in viewers)
			if(holo.Impersonation?.client)
				viewers |= holo.Impersonation

		for(var/mob/receiver in viewers)
			receiver.show_message(span_narrate("[message] \n\ (Narration: [user])"), MSG_VISUAL)
	// Handle target = an individual
	else
		var/mob/target_mob = astype(target, /obj/effect/overlay/holo_pad_hologram)?.Impersonation || target
		if(!istype(target_mob))
			return // Target was neither a hologram with an impersonation attached, or a mob
		if(get_dist(user_mob_or_hologram.loc, target_mob.loc) > world.view)
			to_chat(user, span_warning(LANG("datum.2f628ad4f4fe03c4", null)))
			return
		target_mob.show_message(span_narrate("[message] \n\ (Narration: [user])"), MSG_VISUAL)

#undef NARRATE_RANGE_MAX
#undef NARRATE_RANGE_SAME_TILE
#undef NARRATE_RANGE_ONE_TILE
#undef NARRATE_RANGE_CUSTOM
