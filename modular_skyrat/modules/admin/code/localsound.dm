// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define SHELLEO_ERRORLEVEL 1
#define SHELLEO_STDOUT 2
#define SHELLEO_STDERR 3

#define COOLDOWN_LOCAL_INTERNET_SOUND "local_internet_sound"

///Takes an input from either proc/play_web_sound or the request manager and runs it through youtube-dl and prompts the user before playing it to the server.
/proc/localweb_sound(mob/user, input, credit, range = null)
	if(!check_rights(R_SOUND))
		return
	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(user, span_boldwarning(LANG("_root.bcedd86309a2f9c7", null)), confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
		return
	var/localweb_sound_url = ""
	var/stop_localweb_sounds = FALSE
	var/list/music_extra_data = list()
	var/duration = 0
	if(istext(input))
		var/shell_scrubbed_input = shell_url_scrub(input)
		var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height <= 360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
		var/errorlevel = output[SHELLEO_ERRORLEVEL]
		var/stdout = output[SHELLEO_STDOUT]
		var/stderr = output[SHELLEO_STDERR]
		if(errorlevel)
			to_chat(user, span_boldwarning(LANG("_root.7f433afa09abb1b8", null)), confidential = TRUE)
			to_chat(user, span_warning("[stderr]"), confidential = TRUE)
			return
		var/list/data
		try
			data = json_decode(stdout)
		catch(var/exception/e)
			to_chat(user, span_boldwarning(LANG("_root.90011bf6512ba392", null)), confidential = TRUE)
			to_chat(user, span_warning("[e]: [stdout]"), confidential = TRUE)
			return
		if (data["url"])
			localweb_sound_url = data["url"]
		var/title = "[data["title"]]"
		var/webpage_url = title
		if (data["webpage_url"])
			webpage_url = "<a href=\"[data["webpage_url"]]\">[title]</a>"
		music_extra_data["duration"] = DisplayTimeText(data["duration"] * 1 SECONDS)
		music_extra_data["link"] = data["webpage_url"]
		music_extra_data["artist"] = data["artist"]
		music_extra_data["upload_date"] = data["upload_date"]
		music_extra_data["album"] = data["album"]
		duration = data["duration"] * 1 SECONDS
		if (duration > 10 MINUTES)
			if((tgui_alert(user, LANG("_root.1ac0e2fa908134f7", null), LANG("_root.d01106144c48ee81", null), list("No", "Yes", "Cancel")) != "Yes"))
				return
		var/res = tgui_alert(user, LANG("_root.a45d69f3a69bd759", list(title)), LANG("_root.b76504689c52bd90", null), list("Yes", "No", "Cancel"))
		switch(res)
			if("Yes")
				music_extra_data["title"] = data["title"]
			if("No")
				music_extra_data["link"] = "Song Link Hidden"
				music_extra_data["title"] = "Song Title Hidden"
				music_extra_data["artist"] = "Song Artist Hidden"
				music_extra_data["upload_date"] = "Song Upload Date Hidden"
				music_extra_data["album"] = "Song Album Hidden"
			if("Cancel", null)
				return
		var/anon = tgui_alert(user, LANG("_root.50f4492c1968ce16", null), LANG("_root.eda2ecd34450c2ab", null), list("Yes", "No", "Cancel"))
		switch(anon)
			if("Yes")
				if(res == "Yes")
					to_chat(world, span_boldannounce(LANG("_root.9c36f13dd6691879", list(user.key, webpage_url))), confidential = TRUE)
				else
					to_chat(world, span_boldannounce(LANG("_root.1260de325bcbe021", list(user.key))), confidential = TRUE)
			if("No")
				if(res == "Yes")
					to_chat(world, span_boldannounce(LANG("_root.a1470eab011aa2d2", list(webpage_url))), confidential = TRUE)
			if("Cancel", null)
				return
		if(credit)
			to_chat(world, span_boldannounce(credit), confidential = TRUE)
		SSblackbox.record_feedback("nested tally", "played_url", 1, list("[user.ckey]", "[input]"))
		log_admin("[key_name(user)] played local web sound: [input]")
		message_admins("[key_name(user)] played local web sound: [input]")
	else
		//pressed ok with blank
		log_admin("[key_name(user)] stopped local web sounds.")

		message_admins("[key_name(user)] stopped local web sounds.")
		localweb_sound_url = null
		stop_localweb_sounds = TRUE
	if(localweb_sound_url && !findtext(localweb_sound_url, GLOB.is_http_protocol))
		tgui_alert(user, LANG("_root.622d4b7b7639f0f9", null), LANG("_root.294348b251b82273", null), list("OK"))
		to_chat(user, span_boldwarning(LANG("_root.5c67a399943d4a9f", null)), confidential = TRUE)

		return
	if(localweb_sound_url || stop_localweb_sounds)
		var/list/players = GLOB.player_list
		if (range)
			players = list()
			for (var/mob/listening_mob in hearers(range, user))
				if (listening_mob.client)
					players += listening_mob
		for(var/mob/player_mob as anything in players)
			if(player_mob.client.prefs.read_preference(/datum/preference/numeric/volume/sound_midi) > 0)
				if(!stop_localweb_sounds)
					player_mob.client.tgui_panel?.play_music(localweb_sound_url, music_extra_data)
				else
					player_mob.client.tgui_panel?.stop_music()

	S_TIMER_COOLDOWN_START(SStimer, COOLDOWN_LOCAL_INTERNET_SOUND, duration)

	BLACKBOX_LOG_ADMIN_VERB("Play Local Internet Sound")

ADMIN_VERB(play_localweb_sound, R_SOUND, "播放本地网络音效", "Play a given internet sound players within specified range.", ADMIN_CATEGORY_FUN)
	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(src, span_boldwarning(LANG("datum.bcedd86309a2f9c7", null)), confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
		return

	if(S_TIMER_COOLDOWN_TIMELEFT(SStimer, COOLDOWN_LOCAL_INTERNET_SOUND))
		if(tgui_alert(usr, LANG("datum.58373547a487c124", list(DisplayTimeText(S_TIMER_COOLDOWN_TIMELEFT(SStimer, COOLDOWN_LOCAL_INTERNET_SOUND), 1))), LANG("datum.8cff532b1397b801", null), list("No","Yes")) != "Yes")
			return

	var/web_sound_input = tgui_input_text(usr, LANG("datum.b5e0747fb3c45215", null), LANG("datum.9bd40a28ff84a8f2", null), null)

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning(LANG("datum.e44f9a249381f364", null)), confidential = TRUE)
			to_chat(src, span_warning(LANG("datum.2e6069899c408f79", null)), confidential = TRUE)
			return
		var/number_input = tgui_input_number(usr, LANG("datum.33186933e26f2878", null), LANG("datum.9bd40a28ff84a8f2", null), null)
		localweb_sound(usr, web_sound_input, range = number_input)
	else
		localweb_sound(usr, null, null, null)

#undef SHELLEO_ERRORLEVEL
#undef SHELLEO_STDOUT
#undef SHELLEO_STDERR
#undef COOLDOWN_LOCAL_INTERNET_SOUND
