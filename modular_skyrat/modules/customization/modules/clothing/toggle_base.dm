// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/component/toggle_clothes
	var/toggled = FALSE
	var/toggled_icon_state

/datum/component/toggle_clothes/Initialize(toggled_icon_state)
	if(!isclothing(parent))
		return COMPONENT_INCOMPATIBLE

	if(!toggled_icon_state)
		return COMPONENT_INCOMPATIBLE

	src.toggled_icon_state = toggled_icon_state

	RegisterSignal(parent, COMSIG_CLICK_ALT, PROC_REF(clothing_toggle))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(handle_examine))

/datum/component/toggle_clothes/proc/handle_examine(datum/source, mob/user, list/examine_text)
	SIGNAL_HANDLER
	examine_text += span_notice(LANG("datum.f02d08bac03792e0", null))

/datum/component/toggle_clothes/proc/clothing_toggle(obj/item/clothing/source, mob/living/clicker)
	SIGNAL_HANDLER

	var/original_icon_state = initial(source.icon_state)
	if(source.post_init_icon_state)
		original_icon_state = initial(source.post_init_icon_state)
	toggled = !toggled
	source.icon_state = (toggled ? toggled_icon_state : original_icon_state)
	to_chat(clicker, LANG("datum.b56511b13a3a6db0", list(source)))
	if(source.loc == clicker)
		clicker.update_clothing(source.slot_flags)
	source.update_appearance(UPDATE_ICON)
	return CLICK_ACTION_SUCCESS
