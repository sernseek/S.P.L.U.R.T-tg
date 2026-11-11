// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/action/cooldown/spell/cosmic_rune/before_cast(atom/cast_on)
	. = ..()

	owner.balloon_alert_to_viewers(LANG("datum.49de2b469b03b919", null))
	if (!do_after(owner, 5 SECONDS, owner, IGNORE_HELD_ITEM))
		return SPELL_CANCEL_CAST
