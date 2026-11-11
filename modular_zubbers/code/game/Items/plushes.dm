// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/toy/plush/attack_self(mob/user)
	. = ..()
	if(stuffed)
		if(HAS_TRAIT(user, TRAIT_MONOPHOBIA))
			to_chat(user, span_notice(LANG("obj.bf0c736cd2965868", null)))

	else
		if(HAS_TRAIT(user, TRAIT_MONOPHOBIA))
			to_chat(user, span_warning(LANG("obj.1bf9264550231e13", null)))
