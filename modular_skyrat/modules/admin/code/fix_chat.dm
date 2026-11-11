// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
ADMIN_VERB(fix_say, R_ADMIN, "修复说话", "Fix say for the players.", ADMIN_CATEGORY_MAIN)
	for(var/player in GLOB.player_list)
		if(!isnull(player))
			continue

		GLOB.player_list -= player
