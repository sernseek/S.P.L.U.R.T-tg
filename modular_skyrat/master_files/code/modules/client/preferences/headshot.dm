// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Hey listen! Imgur doesn't actually work, it's been tested.

/datum/preference/text/headshot
	category = PREFERENCE_CATEGORY_CHARACTER_BASICS
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "headshot"
	maximum_value_length = MAX_MESSAGE_LEN
	/// Assoc list of ckeys and their link, used to cut down on chat spam
	var/list/stored_link = list()
	var/static/link_regex = regex(@"i\.gyazo.com|.\.l3n\.co|static\.f-list\.net/images/|images2\.imgbox\.com|thumbs2\.imgbox\.com|files\.catbox\.moe") // Catbox, Imgbox, Gyazo, Lensdump, or F-List
	var/static/list/valid_extensions = list("jpg", "png", "jpeg") // Regex works fine, if you know how it works

/datum/preference/text/headshot/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["headshot"] = value

/datum/preference/text/headshot/is_valid(value)
	if(!length(value)) // Just to get blank ones out of the way
		return TRUE

	var/find_index = findtext(value, "https://")
	if(find_index != 1)
		to_chat(usr, span_warning(LANG("datum.6cfbbbe41b947cfa", null)))
		return

	if(!findtext(value, "."))
		to_chat(usr, span_warning(LANG("datum.620fcc9e96920cb0", null)))
		return
	var/list/value_split = splittext(value, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	if(!(extension in valid_extensions))
		to_chat(usr, span_warning(LANG("datum.9e53f7a45613ecc6", list(lang_english_list(valid_extensions)))))
		return

	find_index = findtext(value, link_regex)
	if(find_index != 9)
		to_chat(usr, span_warning(LANG("datum.5bae615379f7925a", null)))
		return

	apply_headshot(value)
	return TRUE

/datum/preference/text/headshot/proc/apply_headshot(value)
	if(stored_link[usr.ckey] != value)
		to_chat(usr, span_notice(LANG("datum.7da2af25f60c5607", list(span_bold("do not use a real life photo or use any image that is less than serious.")))))
		to_chat(usr, span_notice(LANG("datum.0d698fa08acf3202", null)))
		to_chat(usr, span_notice(LANG("datum.a013fc59600c1141", null)))
		log_game("[usr] has set their Headshot image to '[value]'.")
	stored_link[usr.ckey] = value
	return TRUE
