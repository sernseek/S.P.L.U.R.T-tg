// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Alt method of removing the cell
/mob/living/silicon/robot/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	if(!opened)
		return ..()
	if(!wiresexposed)
		if(!cell)
			balloon_alert(user, LANG("mob.0210855e097c27b8", null))
			return TRUE
		balloon_alert(user, LANG("mob.d17f808dc26b600d", null))
		tool.play_tool_sound(src, 100)
		if(!tool.use_tool(src, user, 3 SECONDS) || !opened)
			balloon_alert(user, LANG("mob.c67b5d274d6e724b", null))
			return TRUE
		tool.play_tool_sound(src, 100)
		balloon_alert(user, LANG("mob.0dfdca6e675f39e2", null))
		cell.forceMove(drop_location())
		diag_hud_set_borgcell()
	return TRUE
