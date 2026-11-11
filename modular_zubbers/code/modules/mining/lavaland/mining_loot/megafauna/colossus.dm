// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/organ/vocal_cords/colossus/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/mob/living/silicon/robot/robot = interacting_with
	if(!istype(robot))
		return NONE
	if(!robot.opened)
		to_chat(user, span_warning(LANG("obj.dea439f75f010c39", list(robot))))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.8ce99939bf01b695", list(src, robot))))
	var/datum/action/cooldown/spell/voice_of_god/voice = new
	voice.Grant(robot)
	if(!user.dropItemToGround(src, TRUE, TRUE))
		to_chat(user, span_notice(LANG("obj.eb126ddd862a7737", list(src))))
		return ITEM_INTERACT_BLOCKING
	forceMove(robot)
	RegisterSignal(robot, COMSIG_BORG_SAFE_DECONSTRUCT, PROC_REF(on_silicon_decon))
	return ITEM_INTERACT_SUCCESS

/obj/item/organ/vocal_cords/colossus/proc/on_silicon_decon()
	forceMove(get_turf(loc))
