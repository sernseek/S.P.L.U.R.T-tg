// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/reagent_containers/cup/phylactery/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.6296c652f08bc3b8", list(EXAMINE_HINT("curse rituals"))))
