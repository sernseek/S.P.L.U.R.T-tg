// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/disk/bitrunning/prefs
	name = "DeForest biological simulation disk"
	desc = "A disk containing the biological simulation data necessary to load custom characters into bitrunning domains."

	w_class = WEIGHT_CLASS_SMALL

	var/datum/preferences/loaded_preference

	var/include_loadout = FALSE

/obj/item/disk/bitrunning/prefs/examine(mob/user)
	. = ..()
	if(!isnull(loaded_preference))
		var/name = loaded_preference.read_preference(/datum/preference/name/real_name)
		. += LANG("obj.27bbe64db7229144", list(name, (include_loadout ? "enabled" : "disabled")))
		. += span_notice(LANG("obj.99d92fac378ee26a", null))

/obj/item/disk/bitrunning/prefs/item_ctrl_click(mob/user)
	include_loadout = !include_loadout // We just switch this around. Elegant!
	balloon_alert(user, include_loadout ? "Loadout enabled" : "Loadout disabled")

/obj/item/disk/bitrunning/prefs/attack_self(mob/user, modifiers)
	. = ..()

	var/list/prefdata_names = user.client.prefs?.create_character_profiles()
	if(isnull(prefdata_names))
		return

	var/response = tgui_alert(user, message = LANG("obj.50483b4a4935c1ba", null), title = LANG("obj.536d495c60514292", null), buttons = list("Yes", "No"))
	if(isnull(response) || response == "No")
		return
	var/choice = tgui_input_list(user, message = LANG("obj.3cb78ece2f701bcf", null),  title = LANG("obj.2b0ff9114b6c7fec", null), items = prefdata_names)
	if(isnull(choice) || !user.is_holding(src))
		return

	loaded_preference = new(user.client)
	loaded_preference.load_character(prefdata_names.Find(choice))

	balloon_alert(user, LANG("obj.816d1546e9d6a7c5", null))
	to_chat(user, span_notice(LANG("obj.49b767518078a295", list(choice))))

/datum/outfit/job/bitrunner
	r_pocket = /obj/item/disk/bitrunning/prefs

/datum/orderable_item/bitrunning_tech/pref_item
	cost_per_order = 500
	purchase_path = /obj/item/disk/bitrunning/prefs
	desc = "This disk contains a program that lets you load in custom characters."
