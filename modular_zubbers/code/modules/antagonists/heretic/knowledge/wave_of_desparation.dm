// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/heretic_knowledge/spell/opening_blast
	drafting_cost = 3

/datum/action/cooldown/spell/aoe/wave_of_desperation
	cooldown_time = 10 MINUTES
	focusless_inhibitable = TRUE

/datum/action/cooldown/spell/aoe/wave_of_desperation/cast(atom/cast_on)
	. = ..()

	owner.visible_message(span_boldwarning(LANG("datum.1e7f02ca578a0eef", list(owner, owner.p_them()))))
	owner.visible_message(span_boldnotice(LANG("datum.8a07279d726f694a", null)))
