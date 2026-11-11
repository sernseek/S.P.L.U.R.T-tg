// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define MODLIMB_TIME_ADJUST 40

/datum/quirk/modularlimbs
	name = "Modular Limbs"
	desc = "You've undergone an experimental ligament hook surgery, allowing your limbs to be attached and detached easily. Unfortunately, this means everyone else can alter your limbs too!"
	value = 0
	gain_text = span_notice("Your limbs feel like they could come off with a bit of effort.")
	lose_text = span_notice("Your limbs feel more firmly attached.")
	medical_record_text = "Patient has detachable limbs."
	mob_trait = TRAIT_MODULAR_LIMBS
	icon = FA_ICON_PUZZLE_PIECE

/datum/quirk/modularlimbs/add(client/client_source)
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Add new quirk verb
	ASSIGN_GAME_VERB(quirk_mob, /mob/living, alterlimbs)

	// Add limb modification traits
	quirk_mob.add_traits(list(
		TRAIT_EASYDISMEMBER,
		TRAIT_LIMBATTACHMENT,
	), TRAIT_MODULAR_LIMBS)

	// Self-amputation ability from Autotomy genetic
	// Define quirk action
	var/datum/action/cooldown/spell/modularlimbs/quirk_action = new

	// Grant quirk action
	quirk_action.Grant(quirk_holder)

/datum/quirk/modularlimbs/remove()
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Remove quirk verb
	UNASSIGN_GAME_VERB(quirk_mob, /mob/living, alterlimbs)

	// Remove limb modification traits
	quirk_mob.remove_traits(list(
		TRAIT_EASYDISMEMBER,
		TRAIT_LIMBATTACHMENT,
	), TRAIT_MODULAR_LIMBS)

	// Define quirk action
	var/datum/action/cooldown/spell/modularlimbs/quirk_action = new

	// Revoke quirk action
	quirk_action.Remove(quirk_holder)

// Variant of self amputation spell
/datum/action/cooldown/spell/modularlimbs
	// More descriptive text, with warning
	name = "Eject a random limb"
	desc = "Eject a random limb from your body."
	button_icon_state = "autotomy"

	cooldown_time = 1 SECONDS
	spell_requirements = NONE

	// Default ability background
	background_icon = 'icons/mob/actions/backgrounds.dmi'
	background_icon_state = ACTION_BUTTON_DEFAULT_BACKGROUND
	overlay_icon = 'icons/mob/actions/backgrounds.dmi'
	overlay_icon_state = null

/datum/action/cooldown/spell/modularlimbs/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/modularlimbs/cast(mob/living/carbon/cast_on)
	. = ..()
	if(HAS_TRAIT(cast_on, TRAIT_NODISMEMBER))
		to_chat(cast_on, span_notice(LANG("datum.46d68b019691a839", null)))
		return

	if(cast_on.handcuffed)
		to_chat(cast_on, span_alert(LANG("datum.ac619cad1cefbd49", null)))
		return

	var/list/parts = list()
	for(var/obj/item/bodypart/to_remove as anything in cast_on.bodyparts)
		if(to_remove.body_zone == BODY_ZONE_HEAD || to_remove.body_zone == BODY_ZONE_CHEST)
			continue
		if(to_remove.bodypart_flags & BODYPART_UNREMOVABLE)
			continue
		parts += to_remove

	if(!length(parts))
		to_chat(cast_on, span_notice(LANG("datum.e23c223d110e6937", null)))
		return

	var/obj/item/bodypart/to_remove = pick(parts)
	to_remove.drop_limb()
	playsound(cast_on, 'sound/effects/cartoon_sfx/cartoon_pop.ogg', 70)

// New verb to alter limbs
GAME_VERB_PROC_SRC_DESC(/mob/living, alterlimbs, view(), "改造肢体", "Remove or attach a limb!", "IC")
	// Define mobs involved
	var/mob/living/carbon/human/mob_initiator = usr
	var/mob/living/carbon/human/mob_target = src

	// Check for self-interacting
	// This causes a runtime error
	if(mob_initiator == mob_target)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning(LANG("mob.5db537519cdb2447", null)))
		return

	// Check if initiator is adjacent
	if(!mob_target.Adjacent(mob_initiator))
		// Alert initiator and return
		to_chat(mob_initiator, span_warning(LANG("mob.179f2299189e04b4", list(mob_target))))
		return

	// Note: Limb attachment is redundant with TRAIT_LIMBATTACHMENT

	// Define item held by initiator
	var/obj/item/held_initiator = mob_initiator.get_active_held_item()
	var/obj/item/bodypart/part_held = held_initiator

	// Check if held item is a body part
	if(part_held)
		// Check if a limb already exists
		if(mob_target.get_bodypart(part_held.body_zone))
			// Alert initiator and return
			to_chat(mob_initiator, span_warning(LANG("mob.cdec13170b3acd51", list(mob_target.p_They(), mob_target.p_have()))))
			return

		// Limb does not already exist!
		// Alert target of interaction attempt
		mob_target.visible_message(span_warning(LANG("mob.5048758c5208c855", list(mob_initiator, part_held, mob_target))), span_userdanger(LANG("mob.3f6a4e8f6971162c", list(mob_initiator, part_held))))

		// Attempt interaction timer
		if(do_after(mob_initiator, MODLIMB_TIME_ADJUST, target = mob_target))
			// Attempt to attach limb
			part_held.try_attach_limb(mob_target)

			// Alert users and return
			mob_target.visible_message(span_warning(LANG("mob.70227f004cd1379d", list(mob_initiator, part_held, mob_target))), span_warning(LANG("mob.51eead3c6d5c3cc5", list(mob_initiator, part_held.name))))
			return

		// Interaction timer failed
		else
			// Alert users and return
			to_chat(mob_initiator, span_warning(LANG("mob.f724cbb22984f4f5", list(mob_target))))
			return

	// Initiator is not holding a body part!

	// Check for valid target region
	if(mob_initiator.zone_selected == BODY_ZONE_CHEST || mob_initiator.zone_selected == BODY_ZONE_HEAD)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning(LANG("mob.26196b188b0e8b80", null)))
		return
	if(mob_initiator.zone_selected == BODY_ZONE_PRECISE_GROIN || mob_initiator.zone_selected == BODY_ZONE_PRECISE_EYES || mob_initiator.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning(LANG("mob.bf561a3e10f42073", null)))
		return

	// Define target body part
	var/obj/item/bodypart/part_target = mob_target.get_bodypart(mob_initiator.zone_selected)

	// Check if the limb exists to be removed
	if(!part_target)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning(LANG("mob.aa3c6946ae8d0611", list(mob_target.p_They(), mob_target.p_are()))))
		return

	// Check if part is irremovable
	if(part_target.bodypart_flags & BODYPART_UNREMOVABLE)
		// Alert initiator and return
		to_chat(mob_initiator, span_warning(LANG("mob.70cd188f71b9dd2c", list(mob_target.p_Their()))))
		return

	// Region is valid and has a limb!

	// Define body part name
	var/part_name = part_target.name

	// Alert users of interaction attempt
	mob_target.visible_message(span_warning(LANG("mob.6033612e71a4039c", list(mob_initiator, mob_target, part_name))), span_userdanger(LANG("mob.3400700c674f0833", list(mob_initiator, part_name))))

	// Attempt interaction timer
	if(do_after(mob_initiator, MODLIMB_TIME_ADJUST, target = mob_target))
		// Define target again
		var/obj/item/bodypart/part_target_check = mob_target.get_bodypart(mob_initiator.zone_selected)

		// Check if redefined target matches
		if(part_target != part_target_check)
			// Alert initiator and return
			to_chat(mob_initiator, span_warning(LANG("mob.fd12b54adfe66690", null)))
			return

		// Remove targeted limb
		part_target_check.drop_limb()

		// Play sound effect
		// Taken from admin panel
		playsound(mob_target, 'sound/effects/cartoon_sfx/cartoon_pop.ogg', 70)

		// Update target's equipment
		mob_target.update_equipment_speed_mods()

		// Alert users and return
		mob_target.visible_message(span_warning(LANG("mob.5baa4769d05d64dc", list(mob_initiator, mob_target, part_name))), span_userdanger(LANG("mob.7b4fcfd44afe5212", list(mob_initiator, part_name))))
		return

	// Interaction timer failed
	else
		// Alert users and return
		to_chat(mob_initiator, span_warning(LANG("mob.f724cbb22984f4f5", list(mob_target))))
		return

#undef MODLIMB_TIME_ADJUST
