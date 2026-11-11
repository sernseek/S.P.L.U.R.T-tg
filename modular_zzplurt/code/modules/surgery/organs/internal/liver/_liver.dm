// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/organ/liver/examine(mob/user)
	. = ..()

	if(HAS_MIND_TRAIT(user, TRAIT_ENTRAILS_READER) || isobserver(user))
		if(HAS_TRAIT(src, TRAIT_CARGO_METABOLISM))
			. += span_info(LANG("obj.a67661b97c9ee3b8", null))
