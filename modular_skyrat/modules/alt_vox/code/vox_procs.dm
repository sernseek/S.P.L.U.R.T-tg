// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Make sure that the code compiles with AI_VOX undefined
#ifdef AI_VOX
#define VOX_DELAY 300

/mob/living/silicon/ai
	/// The currently selected VOX Announcer voice.
	var/vox_type = VOX_BMS
	/// The list of available VOX Announcer voices to choose from.
	var/list/vox_voices = list(VOX_HL, VOX_NORMAL, VOX_BMS)
	/// The VOX word(s) that were previously inputed.
	var/vox_word_string
	/// Can the AI purchase the nuke as a malf
	var/can_purchase_nuke = FALSE

GAME_VERB_DESC(/mob/living/silicon/ai, announcement_help, "公告帮助", "Display a list of vocal words to announce to the crew.", "AI Commands")
	if(incapacitated)
		return

	var/dat = {"
	<font class='bad'>WARNING:</font> Misuse of the announcement system will get you job banned.<BR><BR>
	Here is a list of words you can type into the 'Announcement' button to create sentences to vocally announce to everyone on the same level at you.<BR>
	<UL><LI>You can also click on the word to PREVIEW it.</LI>
	<LI>You can only say 30 words for every announcement.</LI>
	<LI>Do not use punctuation as you would normally, if you want a pause you can use the full stop and comma characters by separating them with spaces, like so: 'Alpha . Test , Bravo'.</LI>
	<LI>Numbers are in word format, e.g. eight, sixty, etc </LI>
	<LI>Sound effects begin with an 's' before the actual word, e.g. scensor</LI>
	<LI>Use Ctrl+F to see if a word exists in the list.</LI></UL><HR>
	"}
	switch(vox_type)
		if(VOX_NORMAL)
			var/index = 0
			for(var/word in GLOB.vox_sounds)
				index++
				dat += "<A href='byond://?src=[REF(src)];say_word=[word]'>[capitalize(word)]</A>"
				if(index != GLOB.vox_sounds.len)
					dat += " / "
		if(VOX_HL)
			var/index = 0
			for(var/word in GLOB.vox_sounds_hl)
				index++
				dat += "<A href='byond://?src=[REF(src)];say_word=[word]'>[capitalize(word)]</A>"
				if(index != GLOB.vox_sounds_hl.len)
					dat += " / "
		if(VOX_MIL)
			var/index = 0
			for(var/word in GLOB.vox_sounds_mil)
				index++
				dat += "<A href='byond://?src=[REF(src)];say_word=[word]'>[capitalize(word)]</A>"
				if(index != GLOB.vox_sounds_mil.len)
					dat += " / "
		if(VOX_BMS)
			var/index = 0
			for(var/word in GLOB.vox_sounds_bms)
				index++
				dat += "<A href='byond://?src=[REF(src)];say_word=[word]'>[capitalize(word)]</A>"
				if(index != GLOB.vox_sounds_bms.len)
					dat += " / "

	var/datum/browser/popup = new(src, "announce_help", "Announcement Help", 500, 400)
	popup.set_content(dat)
	popup.open()


/mob/living/silicon/ai/proc/announcement()
	var/static/announcing_vox = 0 // Stores the time of the last announcement
	if(announcing_vox > world.time)
		to_chat(src, span_notice(LANG("mob.fa4aec516cfc855c", list(DisplayTimeText(announcing_vox - world.time)))))
		return

	var/message = input(src, LANG("mob.6ded948c828c2778", null), LANG("mob.4893e36f7545bce4", null), src.last_announcement) as text|null

	if(!message || announcing_vox > world.time)
		return

	last_announcement = message

	if(incapacitated)
		return

	if(control_disabled)
		to_chat(src, span_warning(LANG("mob.24013b93d3625801", null)))
		return

	var/list/words = splittext(trim(message), " ")
	var/list/incorrect_words = list()

	if(words.len > 30)
		words.len = 30

	switch(vox_type)
		if(VOX_NORMAL)
			for(var/word in words)
				word = LOWER_TEXT(trim(word))
				if(!word)
					words -= word
					continue
				if(!GLOB.vox_sounds[word])
					incorrect_words += word
		if(VOX_HL)
			for(var/word in words)
				word = LOWER_TEXT(trim(word))
				if(!word)
					words -= word
					continue
				if(!GLOB.vox_sounds_hl[word])
					incorrect_words += word
		if(VOX_MIL)
			for(var/word in words)
				word = LOWER_TEXT(trim(word))
				if(!word)
					words -= word
					continue
				if(!GLOB.vox_sounds_mil[word])
					incorrect_words += word
		if(VOX_BMS)
			for(var/word in words)
				word = LOWER_TEXT(trim(word))
				if(!word)
					words -= word
					continue
				if(!GLOB.vox_sounds_bms[word])
					incorrect_words += word

	if(incorrect_words.len)
		to_chat(src, span_notice(LANG("mob.5d25ab4d5a21f99b", list(english_list(incorrect_words)))))
		return

	announcing_vox = world.time + VOX_DELAY

	log_game("[key_name(src)] made a vocal announcement with the following message: [message].")
	log_talk(message, LOG_SAY, tag="VOX Announcement")

	var/list/players = list()
	var/turf/ai_turf = get_turf(src)
	for(var/mob/player_mob as anything in GLOB.player_list)
		var/turf/player_turf = get_turf(player_mob)
		if(is_valid_z_level(ai_turf, player_turf))
			players += player_mob
	minor_announce(capitalize(message), LANG("mob.e26edfe5c99a7125", list(name)), players = players, should_play_sound = CALLBACK(GLOBAL_PROC_REF(does_target_have_vox_off)))

	for(var/word in words)
		play_vox_word(word, ai_turf, null, vox_type)


/proc/play_vox_word(word, ai_turf, mob/only_listener, vox_type)

	word = LOWER_TEXT(word)
	var/sound_file
	var/vox_volume_mod = 1
	switch(vox_type)
		if(VOX_HL)
			if(GLOB.vox_sounds_hl[word])
				sound_file = GLOB.vox_sounds_hl[word]
				vox_volume_mod = 0.75
		if(VOX_MIL)
			if(GLOB.vox_sounds_mil[word])
				sound_file = GLOB.vox_sounds_mil[word]
				vox_volume_mod = 0.50 // My poor ears...
		if(VOX_BMS)
			if(GLOB.vox_sounds_bms[word])
				sound_file = GLOB.vox_sounds_bms[word]
		else
			if(GLOB.vox_sounds[word])
				sound_file = GLOB.vox_sounds[word]

// If there is no single listener, broadcast to everyone in the same z level
	if(!only_listener)
		// Play voice for all mobs in the z level
		for(var/mob/player_mob in GLOB.player_list)
			var/pref_volume = safe_read_pref(player_mob.client, /datum/preference/numeric/volume/sound_ai_vox)
			pref_volume *= vox_volume_mod
			if(HAS_TRAIT(player_mob, TRAIT_DEAF) || !pref_volume)
				continue

			var/turf/player_turf = get_turf(player_mob)
			if(!is_valid_z_level(ai_turf, player_turf))
				continue

			var/sound/voice = sound(sound_file, wait = 1, channel = CHANNEL_VOX, volume = pref_volume)
			voice.status = SOUND_STREAM
			SEND_SOUND(player_mob, voice)

	else
		var/pref_volume = safe_read_pref(only_listener.client, /datum/preference/numeric/volume/sound_ai_vox)
		var/sound/voice = sound(sound_file, wait = 1, channel = CHANNEL_VOX, volume = pref_volume)
		voice.status = SOUND_STREAM
		SEND_SOUND(only_listener, voice)

	return TRUE

/proc/does_target_have_vox_off(mob/target)
	return !safe_read_pref(target.client, /datum/preference/numeric/volume/sound_ai_vox)

GAME_VERB_DESC(/mob/living/silicon/ai, switch_vox, "切换沃克斯语音", "Switch your VOX announcement voice!", "AI Commands")
	if(incapacitated)
		return
	var/selection = tgui_input_list(src, LANG("mob.9a2655f50b096f86", null), LANG("mob.e1b6c58dcb4a6bda", null), vox_voices)
	if(selection == null)
		return
	vox_type = selection

	to_chat(src, LANG("mob.403e8ab99ab4a818", list(vox_type)))


GAME_VERB_DESC(/mob/living/silicon/ai, display_word_string, "显示词串", "Display the list of recently pressed vox lines.", "AI Commands")
	if(incapacitated)
		return

	to_chat(src, vox_word_string)

GAME_VERB_DESC(/mob/living/silicon/ai, clear_word_string, "清除词串", "Clear recent vox words.", "AI Commands")
	vox_word_string = ""

#undef VOX_DELAY
#endif
