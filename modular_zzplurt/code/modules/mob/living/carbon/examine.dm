// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/carbon/proc/get_size_examine_info(mob/living/user)
	. = list()

	var/t_He = p_They()

	//Approximate character height based on current sprite scale
	var/dispSize = round(12*get_size(src, TRUE)) // gets the character's sprite size percent and converts it to the nearest half foot
	var/dispSizeMetric = round(183*get_size(src, TRUE)); // gets the character's sprite size percent and converts it to the nearest cm
	if(dispSize % 2) // returns 1 or 0. 1 meaning the height is not exact and the code below will execute, 0 meaning the height is exact and the else will trigger.
		dispSize = dispSize - 1 //makes it even
		dispSize = dispSize / 2 //rounds it out
		. += LANG("mob.67c3c7abd2244786", list(t_He, dispSize, dispSizeMetric))
	else
		dispSize = dispSize / 2
		. += LANG("mob.b9b0f3fba97907e9", list(t_He, dispSize, dispSizeMetric))
