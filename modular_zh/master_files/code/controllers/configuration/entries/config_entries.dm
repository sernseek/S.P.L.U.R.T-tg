// ZH EDIT - fork config entries (i18n, BYOND account age check).
// i18n: 全服默认界面语言（en / zh-Hans）。用于广播文本（visible_message 等）与 name/desc 等。
// 在 config 文件里写一行：I18N_SERVER_LOCALE zh-Hans
/datum/config_entry/string/i18n_server_locale
	default = LANGUAGE_LOCALE_EN


// i18n: 是否启用聊天落地层（HTML 切块 + 精确反查 + 模板逆匹配）。默认关。
// 在 config 文件里写一行：I18N_CHAT_FALLBACK TRUE
/datum/config_entry/flag/i18n_chat_fallback
	default = FALSE

// i18n: 是否启用「运行期漏翻采集」（默认关）。全服 locale≠en 时把经过所有翻译层后仍是英文的
// 多词串去重记入 [log_directory]/i18n_misses.log，离线聚合归类见 tools/i18n/miss-scan.mjs。
// 在 config 文件里写一行：I18N_LOG_MISSES TRUE
/datum/config_entry/flag/i18n_log_misses
	default = FALSE

/datum/config_entry/flag/i18n_log_misses/ValidateAndSet(str_val)
	. = ..()
	if(.)
		GLOB.i18n_log_misses = config_entry_value

/// Stops external BYOND member page lookups for account creation dates.
/datum/config_entry/flag/disable_byond_account_age_check
	default = FALSE
