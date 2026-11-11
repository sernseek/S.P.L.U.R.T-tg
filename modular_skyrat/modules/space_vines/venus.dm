// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/basic/venus_human_trap/start_pulling(atom/movable/movable_target, state, force, supress_message)
	if(isliving(movable_target))
		to_chat(src, span_boldwarning(LANG("mob.6fef0bef2aacbaf9", null)))
		return
	return ..()
