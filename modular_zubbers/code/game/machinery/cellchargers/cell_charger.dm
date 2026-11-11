// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/cell_charger/click_alt(mob/user)
	. = ..()
	if(. || !charging)
		return
	to_chat(user, span_notice(LANG("obj.aba7bd73c693c3fc", null)))
	removecell(drop_location())
	return CLICK_ACTION_SUCCESS

/obj/machinery/cell_charger/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.44eddf6a74d7144f", null))
