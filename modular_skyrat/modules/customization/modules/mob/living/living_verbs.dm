// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
GLOBAL_VAR_INIT(temporary_flavor_text_indicator, generate_temporary_flavor_text_indicator())

/proc/generate_temporary_flavor_text_indicator()
	var/mutable_appearance/temporary_flavor_text_indicator = mutable_appearance('modular_skyrat/modules/indicators/icons/temporary_flavor_text_indicator.dmi', "flavor", FLY_LAYER)
	temporary_flavor_text_indicator.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	return temporary_flavor_text_indicator

GAME_VERB_DESC(/mob/living, set_temporary_flavor, "设置临时风味文本", "Allows you to set a temporary flavor text.", "IC")
	if(IS_UNCONSCIOUS_OR_CRIT(src))
		to_chat(src, span_warning(LANG("mob.a3ef0a20fc538af4", null)))
		return

	var/msg = tgui_input_text(src, LANG("mob.3b4f7fa20fd17927", null), LANG("mob.bfbb9785cda3b2ae", null), temporary_flavor_text, max_length = MAX_FLAVOR_LEN, multiline = TRUE)
	if(msg == null)
		return

	// Turn empty input into no flavor text
	var/result = msg || null
	temporary_flavor_text = result
	update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

/mob/living/update_overlays()
	. = ..()
	if (temporary_flavor_text)
		. += GLOB.temporary_flavor_text_indicator
