// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/food/fried_chicken/burn()
	visible_message(span_notice(LANG("obj.289ca80782eeabb7", null)))
	new /obj/item/food/lava_chicken(loc)
	qdel(src)
