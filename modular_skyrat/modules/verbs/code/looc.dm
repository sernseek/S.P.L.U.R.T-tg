// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//GAME_VERB_DESC(/client, looc, "LOOC", "Local OOC, seen only by those in view.", "OOC", msg as text)
GAME_VERB_DESC(/client, looc, "LOOC", "Local OOC, seen only by those in view.", "OOC")
	VERB_ARG(msg, VERB_ARG_TYPE_TEXT, VERB_ARG_SOURCE_INPUT)
	looc_message(msg)

//GAME_VERB_DESC(/client, looc_wallpierce, "LOOC (Wallpierce)", "Local OOC, seen by anyone within 7 tiles of you.", "OOC", msg as text)
GAME_VERB_DESC(/client, looc_wallpierce, "LOOC（穿墙）", "Local OOC, seen by anyone within 7 tiles of you.", "OOC")
	VERB_ARG(msg, VERB_ARG_TYPE_TEXT, VERB_ARG_SOURCE_INPUT)
	looc_message(msg, TRUE)

/client/proc/looc_message(msg, wall_pierce)
	if(GLOB.say_disabled)
		to_chat(usr, span_danger(LANG("client.b79ad8a388d1b3a4", null)))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!holder)
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger(LANG("client.0ac8d871ec557817", null)))
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, span_boldannounce(LANG("client.79757764083cac05", null)))
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(prefs.muted & MUTE_LOOC)
			to_chat(src, span_danger(LANG("client.ef695a827f17ce96", null)))
			return
		if(is_banned_from(ckey, BAN_LOOC))
			to_chat(src, span_warning(LANG("client.a65462e36457a2c9", null)))
			return
		if(mob.stat == DEAD)
			to_chat(src, span_danger(LANG("client.ccffee2a65fad185", null)))
			return
		if(istype(mob, /mob/dead))
			to_chat(src, span_danger(LANG("client.a156ab3bb4f30d1a", null)))
			return

	msg = emoji_parse(msg)

	mob.log_talk(msg,LOG_OOC, tag="LOOC")
	var/list/heard
	if(wall_pierce)
		heard = get_hearers_in_looc_range(mob.get_top_level_mob())
	else
		heard = get_hearers_in_view(LOOC_RANGE, mob.get_top_level_mob())

	//so the ai can post looc text
	if(istype(mob, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/ai = mob
		if(wall_pierce)
			heard = get_hearers_in_looc_range(ai.eyeobj)
		else
			heard = get_hearers_in_view(LOOC_RANGE, ai.eyeobj)
	//so the ai can see looc text
	for(var/mob/living/silicon/ai/ai as anything in GLOB.ai_list)
		if(ai.client && !(ai in heard) && (ai.eyeobj in heard))
			heard += ai

	var/list/admin_seen = list()
	for(var/mob/hearing in heard)
		if(!hearing.client)
			continue
		var/client/hearing_client = hearing.client

		var/is_holder = hearing_client.holder
		if (is_holder)
			admin_seen[hearing_client] = TRUE
			// dont continue here, still need to show runechat


		if (isobserver(hearing) && !is_holder)
			continue //ghosts dont hear looc, apparantly

		// do the runetext here so admins can still get the runetext
		if(mob.runechat_prefs_check(hearing) && hearing.client?.prefs.read_preference(/datum/preference/toggle/enable_looc_runechat))
			// EMOTE is close enough. We don't want it to treat the raw message with languages.
			// I wish it didn't include the asterisk but it's modular this way.
			hearing.create_chat_message(mob, raw_message = "(LOOC: [msg])", runechat_flags = EMOTE_MESSAGE)

		if (is_holder)
			continue //admins are handled afterwards

		if(holder && isdead(src.mob)) // Admins ghosted display ckey
			to_chat(hearing_client, span_looc(span_prefix(LANG("client.a8a8497952cfab3d", list(wall_pierce ? " (WALL PIERCE)" : "", src.ckey, msg)))))
		else
			to_chat(hearing_client, span_looc(span_prefix(LANG("client.a8a8497952cfab3d", list(wall_pierce ? " (WALL PIERCE)" : "", src.mob.name, msg)))))

	for(var/client/cli_client as anything in GLOB.admins)
		if (admin_seen[cli_client])
			to_chat(cli_client, span_looc(LANG("client.ddee0ba1f4b4d727", list(ADMIN_FLW(usr), wall_pierce ? " (WALL PIERCE)" : "", src.key, src.mob.name, msg))))
		else if (cli_client.prefs.read_preference(/datum/preference/toggle/admin/see_looc))
			to_chat(cli_client, span_rlooc(LANG("client.a21ff7fd649bce92", list(ADMIN_FLW(usr), wall_pierce ? " (WALL PIERCE)" : "", src.key, src.mob.name, msg))))
