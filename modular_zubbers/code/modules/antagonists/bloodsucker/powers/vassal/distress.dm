// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/action/cooldown/bloodsucker/distress
	name = "Distress"
	desc = "Injure yourself, allowing you to make a desperate call for help to your Master."
	button_icon_state = "power_distress"
	power_explanation = "Distress:\n\
		Use this Power from anywhere and your Master Bloodsucker will instantly be alerted of your location."
	power_flags = NONE
	check_flags = NONE
	purchase_flags = NONE
	bloodcost = 10
	cooldown_time = 10 SECONDS
	level_current = -1

/datum/action/cooldown/bloodsucker/distress/ActivatePower(trigger_flags)
	. = ..()
	var/turf/open/floor/target_area = get_area(owner)
	var/datum/antagonist/ghoul/ghouldatum = owner.mind.has_antag_datum(/datum/antagonist/ghoul)

	owner.balloon_alert(owner, LANG("datum.d0ca0009b19814f0", null))
	to_chat(ghouldatum.master.owner, LANG("datum.4563428fec27c2d6", list(owner, target_area)))

	var/mob/living/user = owner
	user.adjust_brute_loss(10)
	return TRUE
