// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/heretic_knowledge/codex_morbus
	drafting_tier = 0 // disabled for now. might revisit it. i dont want to deal with it rn LMFAO
	unreachable = TRUE

/obj/item/codex_cicatrix/morbus/Initialize(mapload)
	. = ..()

	if (check_holidays(APRIL_FOOLS) || prob(1))
		name = "Codex Morbius"
		desc = LANG("obj.e32642e1b55d26a2", null)

/datum/heretic_knowledge/curse/curse(mob/living/carbon/human/chosen_mob, obj/item/codex_cicatrix/morbus/cursing_book)
	. = ..()

	chosen_mob.balloon_alert_to_viewers(LANG("datum.b547866c80c7d55d", null))
	to_chat(chosen_mob, span_boldwarning(LANG("datum.7c56b7c6fa102d9f", null)))

/datum/heretic_knowledge/curse/transmutation
	duration = 5 MINUTES // infinit efor no fucking reason in tgcode oml

/datum/heretic_knowledge/curse/corrosion
	duration = 20 SECONDS

/obj/item/codex_cicatrix/morbus/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.48e15957fa0edc60", list(EXAMINE_HINT("right-click"), EXAMINE_HINT("curse"))))
