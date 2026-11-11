// ZH EDIT ADDITION - I18N - 便衣 ID 卡的职务名本地化。
//
// 父类 update_label() 早就把 assignment 过了 lang_reverse_text（cards_ids.dm），但这个子类
// **整个覆盖**了该 proc、用 `fake.assignment` 另拼一遍名字，于是漏掉了那一步 —— 同一个界面里
// 普通 ID 显示「(病毒学家)」、便衣 ID 显示「(Virologist)」。
//
// 只动显示名：trim/alt_trim 与 fake.assignment 本身不变，按它比较/取值的逻辑照旧拿英文。
/obj/item/card/id/advanced/plainclothes/update_label()
	. = ..()
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE || !trim_assignment_override)
		return
	var/datum/id_trim/fake = SSid_access.trim_singletons_by_path[alt_trim]
	if(isnull(fake))
		return
	var/name_string = registered_name ? LANG("obj.ad9060a5947cb211", list(registered_name)) : initial(name)
	name = "[name_string] ([lang_reverse_text(fake.assignment)])"
