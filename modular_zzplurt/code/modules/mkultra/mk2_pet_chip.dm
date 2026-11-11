// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Mk.2 variant implemented independently of the base Mk.II chip.
#ifndef DNA_BLANK
#define DNA_BLANK 0
#endif
#ifndef CHIP_EXPIRED
#define CHIP_EXPIRED 1
#endif
#ifndef DNA_READY
#define DNA_READY 2
#endif

/obj/item/skillchip/mk2pet
	name = "ENT-PET Mk.III ULTRA skillchip"
	desc = "A heavily modified version of the MK.II, seemingly done as a custom job. You hesitate to imagine this in anyones brain."
	removable = FALSE
	complexity = 2
	slot_use = 2
	cooldown = 15 MINUTES
	auto_traits = list(TRAIT_PET_SKILLCHIP)
	skill_name = "Pet Enthrallment Mk.III"
	skill_description = "Transforms the user into a devoted companion!"
	skill_icon = FA_ICON_HEART
	activate_message = span_purple(span_bold("You feel the skillchip activating, starting to rewire your mind. Don’t worry about complex thoughts any more; you’re officially downgraded to 'good boy/girl' status. Obedience and loyalty are now your new personality traits. So sit, stay, and enjoy the cozy, simplified existence of your new pet life."))
	deactivate_message = span_purple(span_bold("You feel lucidity returning to your mind as the skillchip attempts to return your brain to normal function."))
	var/static/list/warning_given = list()
	var/static/last_warning_round_id
	var/enthrall_ckey
	var/enthrall_gender
	var/enthrall_name
	var/datum/weakref/enthrall_ref
	var/status = DNA_BLANK

/obj/item/skillchip/mk2pet/proc/maybe_warn(mob/user)
	if(!user || !user.client)
		return TRUE
	if(GLOB.round_id && last_warning_round_id != GLOB.round_id)
		warning_given = list()
		last_warning_round_id = GLOB.round_id
	var/ckey = user.client?.ckey
	if(!ckey)
		return TRUE
	if(warning_given[ckey])
		return TRUE
	var/choice = tgui_alert(user, LANG("obj.92b1b8d6bfc27aa9", null), LANG("obj.8f211533a7c1c710", null), list("Yes", "No"))
	if(choice != "Yes")
		return FALSE
	warning_given[ckey] = TRUE
	return TRUE

/obj/item/skillchip/mk2pet/attack_hand(mob/user, modifiers)
	if(!maybe_warn(user))
		return TRUE
	return ..()

/obj/item/skillchip/mk2pet/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!(slot & ITEM_SLOT_HANDS))
		return
	if(!maybe_warn(user))
		user.dropItemToGround(src, force = TRUE)

/obj/item/skillchip/mk2pet/attack_self(mob/user, modifiers)
	. = ..()
	var/mob/living/carbon/human/dna_holder = user
	if(!istype(dna_holder))
		to_chat(user, span_warning(LANG("obj.1ab73ec3201d7115", null)))
		return

	if(!dna_holder.client?.prefs?.read_preference(/datum/preference/toggle/erp/hypnosis))
		to_chat(dna_holder, span_danger(LANG("obj.981684c6de70f97c", list(src))))
		return

	var/mob/living/carbon/human/enthrall = enthrall_ref?.resolve()
	if(!isnull(enthrall))
		var/response = tgui_alert(dna_holder, LANG("obj.ff4221c2a83bf448", list(enthrall_name)), LANG("obj.74490f80660b0f5b", null), list("Re-imprint", "Cancel Imprinting"))
		if(response == "Re-imprint")
			enthrall_ckey = null
			enthrall_gender = null
			enthrall_name = null
			enthrall_ref = null
			status = DNA_BLANK
			visible_message(span_notice(LANG("obj.0785b7ab353fdc80", list(src))))
		else
			return

	to_chat(dna_holder, span_notice(LANG("obj.9f0b3ed489dfc160", list(src))))
	var/list/title_options = list("Master", "Mistress", "Custom...", "Cancel Imprinting")
	var/selected_title = tgui_input_list(dna_holder, LANG("obj.5b4f6691146bc82c", null), LANG("obj.9bd4c7d1f69a6e19", list(dna_holder.real_name)), title_options)
	if(selected_title == "Cancel Imprinting" || !selected_title)
		return

	if(selected_title == "Custom...")
		var/custom_title = tgui_input_text(dna_holder, LANG("obj.c9d44a47b76e8391", null), LANG("obj.1ae51c1f07613d0f", null), dna_holder.real_name, 24)
		custom_title = trim(custom_title)
		if(!length(custom_title))
			to_chat(dna_holder, span_warning(LANG("obj.1a3a9fa327933c27", null)))
			return

		// Strip basic punctuation to keep chat output clean.
		custom_title = replacetext(custom_title, "<", "")
		custom_title = replacetext(custom_title, ">", "")
		custom_title = replacetext(custom_title, "\[", "")
		custom_title = replacetext(custom_title, "\]", "")
		custom_title = replacetext(custom_title, "\\", "")
		custom_title = trim(custom_title)
		if(!length(custom_title))
			to_chat(dna_holder, span_warning(LANG("obj.1a3a9fa327933c27", null)))
			return
		enthrall_gender = custom_title
	else
		enthrall_gender = selected_title

	enthrall_ref = WEAKREF(dna_holder)
	enthrall_ckey = dna_holder.ckey
	enthrall_name = dna_holder.real_name
	status = DNA_READY
	to_chat(dna_holder, span_purple(LANG("obj.a47245cf1305ceac", list(src, enthrall_gender, enthrall_name))))
	visible_message(span_notice(LANG("obj.ea653b94622c87fa", list(src))))

/obj/item/skillchip/mk2pet/examine(mob/user)
	. = ..()
	switch(status)
		if(DNA_BLANK)
			. += span_notice(LANG("obj.36ff85dabe548ec4", null))
		if(DNA_READY)
			. += span_notice(LANG("obj.19110d78361802b0", null))
			. += span_purple(LANG("obj.f1995ff5bc495812", list(enthrall_name)))
		else
			. += span_notice(LANG("obj.2a81582a16656f4d", null))

/obj/item/skillchip/mk2pet/has_mob_incompatibility(mob/living/carbon/target)
	if(!istype(target))
		return "Incompatible lifeform detected."

	var/obj/item/organ/brain/brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(QDELETED(brain))
		return "Get a brain, moran."

	var/brain_message = has_brain_incompatibility(brain)
	if(brain_message)
		return brain_message

	var/mob/living/carbon/human/enthrall = enthrall_ref?.resolve()
	if(isnull(enthrall))
		return "Unable to locate DNA imprint."

	if(enthrall == target)
		return "You can't enthrall yourself."

	if(!enthrall.client?.prefs?.read_preference(/datum/preference/toggle/erp/hypnosis))
		return "[enthrall] has Hypnosis preference disabled."

	if(!target.client?.prefs?.read_preference(/datum/preference/toggle/erp/hypnosis))
		return "[target] has Hypnosis preference disabled."

	return FALSE

/obj/item/skillchip/mk2pet/on_activate(mob/living/carbon/user, silent = FALSE)
	if(status != DNA_READY)
		to_chat(user, span_warning(LANG("obj.e1df3f917b346484", list(src))))
		// Prompt the user to imprint now so the Skillsoft station path can still set it up.
		attack_self(user)
		return FALSE

	. = ..()

	var/mob/living/carbon/human/enthrall = enthrall_ref?.resolve()
	if(!isnull(enthrall))
		var/obj/item/organ/vocal_cords/vocal_cords = enthrall.get_organ_slot(ORGAN_SLOT_VOICE)
		var/obj/item/organ/vocal_cords/new_vocal_cords = new /obj/item/organ/vocal_cords/velvet
		if(vocal_cords)
			vocal_cords.Remove(enthrall)
		new_vocal_cords.Insert(enthrall)
		qdel(vocal_cords)
		to_chat(enthrall, span_purple(LANG("obj.120d347f13a40b21", null)))

	user.apply_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
	return TRUE

/obj/item/skillchip/mk2pet/on_deactivate(mob/living/carbon/user, silent = FALSE)
	user.remove_status_effect(/datum/status_effect/chem/enthrall/pet_chip/mk2)
	return ..()

/datum/status_effect/chem/enthrall/pet_chip/mk2
	ignore_mindshield = TRUE
	distance_mood_enabled = FALSE

/datum/mood_event/enthrall_sissy
	description = "Your owner wants you dressed differently."
	mood_change = -4
	timeout = 2 MINUTES

// Compatibility alias for any legacy references that still spawn /mkiiultra/mk2.
/obj/item/skillchip/mkiiultra/mk2
	parent_type = /obj/item/skillchip/mk2pet

#undef DNA_BLANK
#undef CHIP_EXPIRED
#undef DNA_READY
