// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
ADMIN_VERB(blacklist_xmas_item, R_ADMIN, "将圣诞礼物物品加入黑名单", "Take away a gift, you monster.", ADMIN_CATEGORY_GAME)
	var/item_to_ban = tgui_input_text(user, LANG("datum.6a6daa16724f9c27", null), LANG("datum.c9e89f55bce0f2ae", null), max_length = 128)
	var/pathed_item = text2path(item_to_ban)
	if(ispath(pathed_item))
		LAZYADD(GLOB.xmas_gift_blacklist, item_to_ban)
		log_admin("[key_name(user)] added [item_to_ban] to the Christmas blacklist.")
		message_admins("[key_name(user)] added [item_to_ban] to the Christmas blacklist!")
	BLACKBOX_LOG_ADMIN_VERB("Blacklist Xmas Gift Item")
