// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// no examine hint, its obvious when being used & is a more "sneaky" tool

/obj/item/coin/eldritch/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if (. & ITEM_INTERACT_SUCCESS)
		return

	if (!istype(interacting_with, /obj/machinery/door))
		return NONE

	var/obj/machinery/door/target_door = interacting_with
	if (!target_door.panel_open)
		balloon_alert(user, LANG("obj.0592e3eb3ddef312", null))
		return ITEM_INTERACT_BLOCKING

	user.balloon_alert_to_viewers(LANG("obj.17727a95bd59572a", null))
	if (!do_after(user, 3 SECONDS, target_door))
		balloon_alert(user, LANG("obj.ead1643bd0b9e823", null))
		return ITEM_INTERACT_BLOCKING

	if (!target_door.emag_act(user))
		return ITEM_INTERACT_BLOCKING

	user.balloon_alert_to_viewers(LANG("obj.5c3ad0feb9911fcc", null))
	qdel(src)
	return ITEM_INTERACT_SUCCESS
