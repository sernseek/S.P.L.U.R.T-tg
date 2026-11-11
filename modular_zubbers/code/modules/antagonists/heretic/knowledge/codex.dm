// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/heretic_knowledge/codex_cicatrix
	desc = "Allows you to transmute a book, any pen, and your pick from any carcass (animal or human), leather, or hide to create a Codex Cicatrix. \
		The Codex Cicatrix can be used when draining influences to drain them faster, but comes at greater risk of being noticed. \
		It can also be used to draw and remove transmutation runes easier, and as a spell focus in a pinch. Very useful for opening ways."

/obj/item/codex_cicatrix/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.dc3cdcbe88e62033", null))
	. += span_notice(LANG("obj.b8f4de839e95ecd8", null))
