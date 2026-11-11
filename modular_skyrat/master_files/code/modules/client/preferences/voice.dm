/// The option for not having a voice.

/datum/preference/choiced/voice/init_possible_values()
	if(SStts.tts_enabled)
		return list(TTS_VOICE_NONE) + SStts.available_speakers

	if(fexists("data/cached_tts_voices.json"))
		var/list/text_data = rustg_file_read("data/cached_tts_voices.json")
		var/list/cached_data = json_decode(text_data)
		if(!cached_data)
			return list("invalid")

		return list(TTS_VOICE_NONE) + cached_data

	return list("invalid")

/datum/preference/choiced/voice/apply_to_human(mob/living/carbon/human/target, value)
	value = SStts.resolve_voice(value)
	// Check against the live list: cached_values may still hold the previous round's list.
	if(SStts.tts_enabled && value != TTS_VOICE_NONE && !(value in SStts.available_speakers))
		value = SStts.random_tts_voice(target.gender) // As a failsafe

	target.voice = value == TTS_VOICE_NONE ? "" : value
/datum/preference/choiced/voice/deserialize(input, datum/preferences/preferences)
	// Voices retired by a TTS model change map onto their replacement instead of a random voice.
	input = SStts.resolve_voice(input)
	// Until the TTS server answers, keep the saved voice instead of judging it by a stale list.
	if(!SStts.voice_list_is_live() && istext(input) && length(input))
		return input
	return ..(input, preferences)

/datum/preference/choiced/voice/compile_constant_data()
	. = ..()
	var/list/display_names = SStts.voice_display_names(.["choices"])
	if(display_names)
		.[CHOICED_PREFERENCE_DISPLAY_NAMES] = display_names
