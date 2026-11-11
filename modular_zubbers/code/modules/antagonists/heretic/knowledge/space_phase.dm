// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/heretic_knowledge/spell/space_phase
	desc = "Grants you Space Phase, a spell that allows you to move freely through space. \
		You can only phase in and out when you are on a space or misc turf. Has a short windup period before activating."

/datum/action/cooldown/spell/jaunt/space_crawl/before_cast(atom/cast_on)
	. = ..()

	if (!is_jaunting(owner))
		owner.balloon_alert_to_viewers(LANG("datum.a7487fc5ada6b975", null))
		if (!do_after(owner, 2 SECONDS, owner, IGNORE_HELD_ITEM|IGNORE_SLOWDOWNS|IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE))
			return SPELL_CANCEL_CAST
