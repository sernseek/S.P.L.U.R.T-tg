// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define WHITELISTFILE "[global.config.directory]/whitelist.txt"

GLOBAL_LIST(whitelist)

/proc/load_whitelist()
	GLOB.whitelist = list()
	for(var/line in world.file2list(WHITELISTFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.whitelist += ckey(line)

	if(!GLOB.whitelist.len)
		GLOB.whitelist = null

/proc/check_whitelist(ckey)
	if(!GLOB.whitelist)
		return FALSE
	. = (ckey in GLOB.whitelist)

ADMIN_VERB(whitelist_player, R_BAN, "将 ckey 加入白名单", "Adds a ckey to the Whitelist file.", ADMIN_CATEGORY_MAIN)
	var/input_ckey = input(LANG("datum.9437c28d9b1c393f", null)) as null|text
	// The ckey proc "santizies" it to be its "true" form
	var/canon_ckey = ckey(input_ckey)
	if(!input_ckey || !canon_ckey)
		return
	// Dont add them to the whitelist if they are already in it
	if(canon_ckey in GLOB.whitelist)
		return

	GLOB.whitelist += canon_ckey
	rustg_file_append("\n[input_ckey]", WHITELISTFILE)

	message_admins("[input_ckey] has been whitelisted by [key_name(user)]")
	log_admin("[input_ckey] has been whitelisted by [key_name(user)]")

ADMIN_VERB_CUSTOM_EXIST_CHECK(whitelist_player)
	return CONFIG_GET(flag/usewhitelist)

#undef WHITELISTFILE
