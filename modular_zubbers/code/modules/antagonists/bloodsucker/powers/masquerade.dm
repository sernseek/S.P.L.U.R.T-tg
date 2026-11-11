// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/**
 *	# WITHOUT THIS POWER:
 *
 *	- Mid-Blood: SHOW AS PALE
 *	- Low-Blood: SHOW AS DEAD
 *	- No Heartbeat
 *  - Examine shows actual blood
 *	- Thermal homeostasis (ColdBlooded)
 * 		WITH THIS POWER:
 *	- Normal body temp -- remove Cold Blooded (return on deactivate)
 */

/datum/action/cooldown/bloodsucker/masquerade
	name = "Masquerade"
	desc = "Feign the vital signs of a mortal, and escape both casual and medical notice as the monster you truly are."
	button_icon_state = "power_human"
	power_flags = BP_CONTINUOUS_EFFECT|BP_AM_STATIC_COOLDOWN|BP_AM_COSTLESS_UNCONSCIOUS
	check_flags = NONE
	bloodsucker_check_flags = BP_CANT_USE_IN_FRENZY
	purchase_flags = BLOODSUCKER_DEFAULT_POWER
	bloodcost = 10
	level_current = -1
	cooldown_time = 5 SECONDS
	constant_bloodcost = 0.1

/datum/action/cooldown/bloodsucker/masquerade/get_power_explanation_extended()
	. = list()
	. += LANG("datum.03246613bbcea5bf", null)
	. += LANG("datum.653aa2e7ae6b357f", null)
	. += LANG("datum.ac70988790e6561f", null)
	. += LANG("datum.fd51b0eb1081bf26", null)
	. += LANG("datum.40d40255bf5beb00", null)
	. += LANG("datum.35c91d606498adba", null)

/datum/action/cooldown/bloodsucker/masquerade/ActivatePower(atom/target)
	var/mob/living/carbon/user = owner
	owner.balloon_alert(owner, LANG("datum.9b746749e2832f33", null))
	to_chat(user, span_notice(LANG("datum.53e4bb6c8adb4447", null)))
	to_chat(user, span_warning(LANG("datum.88d6a22d0e63b5da", null)))

	// Give status effect
	user.apply_status_effect(/datum/status_effect/masquerade)

	// Handle Traits
	user.remove_traits(bloodsuckerdatum_power.bloodsucker_traits, BLOODSUCKER_TRAIT)

	ADD_TRAIT(user, TRAIT_MASQUERADE, BLOODSUCKER_TRAIT)
	var/obj/item/bodypart/chest/target_chest = user.get_bodypart(BODY_ZONE_CHEST)
	if(target_chest)
		target_chest.bodypart_flags &= ~BODYPART_UNREMOVABLE
	// Handle organs
	var/obj/item/organ/heart/vampheart = user.get_organ_slot(ORGAN_SLOT_HEART)
	if(vampheart)
		vampheart.Restart()
	var/obj/item/organ/eyes/eyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.flash_protect = initial(eyes.flash_protect)
		eyes.color_cutoffs = initial(eyes.color_cutoffs)
		eyes.sight_flags = initial(eyes.sight_flags)
		user.update_sight()
	return TRUE

/// todo, make bloodsuckerification into it's own proc, ie, eyes, traits, and such
/datum/action/cooldown/bloodsucker/masquerade/DeactivatePower(deactivate_flags)
	. = ..() // activate = FALSE
	if(!.)
		return
	var/mob/living/carbon/user = owner
	owner.balloon_alert(owner, LANG("datum.7198a6a8aee8013b", null))

	// Remove status effect, mutations & diseases that you got while on masq.
	user.remove_status_effect(/datum/status_effect/masquerade)
	for(var/datum/disease/diseases as anything in user.diseases)
		diseases.cure()

	// Handle Traits
	user.add_traits(bloodsuckerdatum_power.bloodsucker_traits, BLOODSUCKER_TRAIT)
	REMOVE_TRAIT(user, TRAIT_MASQUERADE, BLOODSUCKER_TRAIT)
	var/obj/item/bodypart/chest/target_chest = user.get_bodypart(BODY_ZONE_CHEST)
	if(target_chest)
		target_chest.bodypart_flags |= BODYPART_UNREMOVABLE
	// Handle organs
	var/obj/item/organ/heart/vampheart = user.get_organ_slot(ORGAN_SLOT_HEART)
	if(vampheart)
		vampheart.Stop()
	var/obj/item/organ/eyes/eyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.flash_protect = max(initial(eyes.flash_protect) - 1, FLASH_PROTECTION_SENSITIVE)
		eyes.color_cutoffs = BLOODSUCKER_SIGHT_COLOR_CUTOFF
		eyes.sight_flags = SEE_MOBS
		user.update_sight()
	to_chat(user, span_notice(LANG("datum.de46cdb07c5c35a5", null)))

/**
 * # Status effect
 *
 * This is what the Masquerade power gives, handles their bonuses and gives them a neat icon to tell them they're on Masquerade.
 */

/datum/status_effect/masquerade
	id = "masquerade"
	duration = STATUS_EFFECT_PERMANENT
	duration = STATUS_EFFECT_NO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/masquerade

/atom/movable/screen/alert/status_effect/masquerade
	name = "Masquerade"
	desc = "You are currently hiding your identity using the Masquerade power. This halts Vampiric healing."
	icon = 'modular_zubbers/icons/mob/actions/bloodsucker.dmi'
	icon_state = "power_human"
	alerttooltipstyle = "cult"

/atom/movable/screen/alert/status_effect/masquerade/MouseEntered(location,control,params)
	desc = initial(desc)
	return ..()
