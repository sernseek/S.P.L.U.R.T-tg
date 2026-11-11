// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/reagent_containers/cup/beaker/eldritch/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.6845321c9f6c018f", list(EXAMINE_HINT("eldritch essence"))))
