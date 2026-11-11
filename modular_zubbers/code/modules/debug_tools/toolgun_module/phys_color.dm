// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/phystool_mode/color_mode
	name = "Color mode"
	desc = "Use LMB to color an object. Use RMB to set default color. Use in hands to choose color."

	var/selected_color

/datum/phystool_mode/color_mode/use_act(mob/user)
	. = ..()
	selected_color = tgui_color_picker(user, LANG("datum.237a34caf7dfdbf2", null), LANG("datum.b4739d45ac78eb49", null)) // BUBBERSTATION EDIT: TGUI COLOR PICKER

/datum/phystool_mode/color_mode/main_act(atom/target, mob/user)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(L.client)
			user.balloon_alert(user, LANG("datum.4d5468a0d8b9ed8c", null))
			return FALSE
	if(!selected_color)
		selected_color = COLOR_WHITE
	target.color = selected_color
	return TRUE

/datum/phystool_mode/color_mode/secondnary_act(atom/target, mob/user)
	. = ..()
	target.color = initial(target.color)
	return TRUE
