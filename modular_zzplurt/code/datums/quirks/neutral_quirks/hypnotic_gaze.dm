// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define HYPNOEYES_COOLDOWN_NORMAL 3 SECONDS
#define HYPNOEYES_COOLDOWN_BRAINWASH 30 SECONDS
#define HYPNOEYES_ACTION_TIME 5 SECONDS
#define HYPNOEYES_SLEEP_TIME 2 MINUTES
#define HYPNOEYES_DROWSINESS 40

// REMOVED QUIRK - Disabled in favor of new NIFSoft method
// This file still contains the action
/datum/quirk/hypnotic_gaze
	name = "Hypnotic Gaze"
	desc = "Prolonged eye contact with you can place a viewer into a highly-suggestible hypnotic trance."
	value = 0
	gain_text = span_purple("Your eyes glimmer hypnotically...")
	lose_text = span_purple("Your eyes return to normal.")
	medical_record_text = "Patient's eyes exhibits soporific effects. Additional testing may be necessary."
	mob_trait = TRAIT_HYPNOTIC_GAZE
	icon = FA_ICON_FAN
	erp_quirk = TRUE
	hidden_quirk = TRUE

/datum/quirk/hypnotic_gaze/add(client/client_source)
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	// Add quirk ability action datum
	var/datum/action/cooldown/hypnotize/act_hypno = new
	act_hypno.Grant(quirk_mob)

	// Add status effect
	quirk_holder.apply_status_effect(/datum/status_effect/quirk_examine/hypnotic_gaze)

/datum/quirk/hypnotic_gaze/remove()
	// Define quirk mob
	var/mob/living/carbon/human/quirk_mob = quirk_holder

	if(QDELETED(quirk_mob))
		return

	// Remove quirk ability action datum
	var/datum/action/cooldown/hypnotize/act_hypno = locate() in quirk_mob.actions
	act_hypno.Remove(quirk_mob)

	// Remove status effect
	quirk_holder.remove_status_effect(/datum/status_effect/quirk_examine/hypnotic_gaze)

// Examine text status effect
/datum/status_effect/quirk_examine/hypnotic_gaze
	id = QUIRK_EXAMINE_HYPNOTIC_GAZE

// Set effect examine text
/datum/status_effect/quirk_examine/hypnotic_gaze/get_examine_text()
	return span_purple("[owner.p_Their()] eyes glimmer with an entrancing power.")

//
// Actions
//

/datum/action/cooldown/hypnotize
	name = "Hypnotize"
	desc = "Stare deeply into someone's eyes, drawing them into a hypnotic slumber."
	transparent_when_unavailable = TRUE
	cooldown_time = HYPNOEYES_COOLDOWN_NORMAL

	// New icons
	background_icon = 'modular_skyrat/master_files/icons/mob/actions/action_backgrounds.dmi'
	background_icon_state = "android"
	button_icon = 'modular_skyrat/master_files/icons/mob/actions/actions_nif.dmi'
	button_icon_state = "hypnotize"

	// Should this create a brainwashed victim?
	// Currently unused in this codebase
	var/mode_brainwash = FALSE

	// Terminology used
	var/term_hypno = "hypnotize"
	var/term_suggest = "suggestion"

// Upgraded variant
/datum/action/cooldown/hypnotize/brainwash
	name = "Brainwash"
	desc = "Stare deeply into someone's eyes, converting them into a loyal mind slave."
	cooldown_time = HYPNOEYES_COOLDOWN_BRAINWASH

	// Should this create a brainwashed victim?
	mode_brainwash = TRUE

	// Terminology used
	term_hypno = "brainwash"
	term_suggest = "command"

/datum/action/cooldown/hypnotize/IsAvailable(feedback)
	. = ..()

	// Check parent return
	if(!.)
		return FALSE

	// Check for carbon owner
	if(!iscarbon(owner))
		// Warn user and return
		to_chat(owner, span_warning(LANG("datum.83b2111fac2e6acc", null)))
		return FALSE

	// Define action owner
	var/mob/living/carbon/human/action_owner = owner

	// Check if owner has eye protection
	if(action_owner.get_eye_protection() > 0)
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.2b9e69e2895540e4", null)))
		return FALSE

	// Define owner's eyes
	var/obj/item/organ/eyes/owner_eyes = owner.get_organ_slot(ORGAN_SLOT_EYES)

	// Check if eyes exist
	if(!istype(owner_eyes))
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.f51d1d7de89fce6c", null)))
		return FALSE

	// Check if owner is blind
	if(action_owner.is_blind())
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.dd9f27221f364aeb", list(owner_eyes))))
		return FALSE

	// All checks passed
	return TRUE

/datum/action/cooldown/hypnotize/proc/set_brainwash(set_to = FALSE)
	// Check if state will change
	if(mode_brainwash == set_to)
		// Do nothing
		return

	// Set new variable
	mode_brainwash = set_to

	// Define toggle message
	var/toggle_message = "experiences an error?"

	// Define log message type
	var/log_message_type = "somehow screwed up"

	// Check if brainwashing
	if(mode_brainwash)
		// Set ability text
		name = "Brainwash"
		desc = LANG("datum.ab60e9730e06de67", null)

		// Set cooldown time
		cooldown_time = HYPNOEYES_COOLDOWN_BRAINWASH

		// Set terminology
		term_hypno = "brainwash"
		term_suggest = "command"

		// Set message suffix
		toggle_message = "suddenly feels more intense!"

		// Set log message type
		log_message_type = "GAINED"

	// Not brainwashing
	else
		// Set ability text
		name = "Hypnotize"
		desc = LANG("datum.fcba9f224e8a90b6", null)

		// Set cooldown time
		cooldown_time = HYPNOEYES_COOLDOWN_NORMAL

		// Set terminology
		term_hypno = "hypnotize"
		term_suggest = "suggestion"

		// Set message suffix
		toggle_message = "fades back to normal levels..."

		// Set log message type
		log_message_type = "LOST"

	// Update buttons
	owner.update_action_buttons()

	// Reset cooldown time
	StartCooldown()

	// Alert user
	to_chat(owner, span_warning(LANG("datum.acbc813e755f8344", list(toggle_message))))

	// Log interaction
	log_admin("[key_name(owner)] [log_message_type] hypnotic brainwashing powers.")

/datum/action/cooldown/hypnotize/Activate()
	// Define action owner
	var/mob/living/carbon/human/action_owner = owner

	// Define target
	var/grab_target = action_owner.pulling

	// Check for target
	if(!grab_target)
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.afd14500cbd8fd4b", null)))
		return

	// Check for cyborg
	if(iscyborg(grab_target))
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.184ceb00c95fd7ef", list(term_hypno))))
		return

	// Check for alien
	// Taken from eyedropper check
	if(isalien(grab_target))
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.da40cb59976bb93d", list(grab_target))))
		return

	// Check for carbon human target
	if(!ishuman(grab_target))
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.021f9f543f510b34", null)))
		return

	// Check if target is alive
	if(!isliving(grab_target))
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.b16c56a7f802dee3", list(term_hypno))))
		return

	// Check for aggressive grab
	if(action_owner.grab_state < GRAB_AGGRESSIVE)
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.3bb72bd331a21a7b", list(term_hypno, grab_target))))
		return

	// Define target
	var/mob/living/carbon/human/action_target = grab_target

	// Check for sleep
	if(action_target.IsSleeping())
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.53e8f7f8589f0ecf", list(term_hypno, action_target, action_target.p_theyre()))))
		return

	// Check if target has a mind
	if(!action_target.mind)
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.60a15d00de7bc451", list(grab_target))))
		return

	/* Unused: Replaced by get_eye_protection
	// Check if target's eyes are obscured
	// ... by headwear
	if((action_target.head && action_target.head.flags_cover & HEADCOVERSEYES))
		// Warn the user, then return
		to_chat(action_owner, span_warning("[action_target]'s eyes are obscured by [action_target.head]."))
		return

	// ... by a mask
	else if((action_target.wear_mask && action_target.wear_mask.flags_cover & MASKCOVERSEYES))
		// Warn the user, then return
		to_chat(action_owner, span_warning("[action_target]'s eyes are obscured by [action_target.wear_mask]."))
		return

	// ... by glasses
	else if((action_target.glasses && action_target.glasses.flags_cover & GLASSESCOVERSEYES))
		// Warn the user, then return
		to_chat(action_owner, span_warning("[action_target]'s eyes are obscured by [action_target.glasses]."))
		return
	*/

	// Check if target has eye protection
	if(action_target.get_eye_protection())
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.48004c896bf3522a", list(action_target, term_hypno, action_target.p_them()))))
		to_chat(action_target, span_notice(LANG("datum.13302d6cfbdddc58", list(action_owner))))
		return

	// Check if target is blind
	if(action_target.is_blind())
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.07a389274c98aa1b", list(action_target))))
		return

	// Check for mental anti-magic
	// This should not apply to the Hallowed quirk!
	if(action_target.can_block_magic(MAGIC_RESISTANCE_MIND))
		// Warn the users, then return
		to_chat(action_owner, span_warning(LANG("datum.935daca84b95d400", list(action_target, action_target.p_They(), action_target.p_s()))))
		to_chat(action_target, span_notice(LANG("datum.3cfe772130de4ae9", list(action_owner, action_owner.p_them()))))
		return

	// Check if client has denied hypnosis preference
	if(action_target.client?.prefs.read_preference(/datum/preference/choiced/erp_status_hypno) == "No")
		// Warn the users, then return
		to_chat(action_owner, span_warning(LANG("datum.072ff654216d3b70", list(action_target, action_target.p_their()))))
		to_chat(action_target, span_notice(LANG("datum.f6ac2361ed5f627a", list(action_owner))))
		return

	// Check for mindshield implant
	if(HAS_TRAIT(action_target, TRAIT_MINDSHIELD))
		// Warn the users, then return
		to_chat(action_owner, span_warning(LANG("datum.078830ea920dc803", list(action_target, action_target.p_their()))))
		to_chat(action_target, span_notice(LANG("datum.1882d9982d25f054", list(action_owner))))
		return

	// Check if target mind is unconvertable
	if(HAS_MIND_TRAIT(action_target, TRAIT_UNCONVERTABLE))
		// Warn the users, then return
		to_chat(action_owner, span_warning(LANG("datum.0be3651f13f098b9", list(action_target, action_target.p_them()))))
		to_chat(action_target, span_notice(LANG("datum.86dd4b2c9ffdc410", list(action_owner))))
		return

	// Check for sleep immunity
	// This is required for SetSleeping to trigger
	if(HAS_TRAIT(action_target, TRAIT_SLEEPIMMUNE) || !(action_target.status_flags & CANUNCONSCIOUS))
		// Warn the users, then return
		to_chat(action_owner, span_warning(LANG("datum.c02f6c848f68b71d", list(action_target, action_target.p_them()))))
		to_chat(action_target, span_notice(LANG("datum.ab6fc54f821ab8e1", list(action_owner))))
		return

	// Check for combat mode
	if(action_target.combat_focus)
		// Warn the users, then return
		to_chat(action_owner, span_warning(LANG("datum.31353a543a11f5f2", list(action_target, action_target.p_them(), action_target.p_their()))))
		to_chat(action_target, span_notice(LANG("datum.8f72e011d45f513e", list(action_owner))))
		return

	// Display chat messages
	to_chat(action_owner, span_notice(LANG("datum.3119ed1e140888e4", list(action_target))))
	to_chat(action_target, span_warning(LANG("datum.9a77798c6267b4ed", list(action_owner))))

	// Try to perform action timer
	if(!do_after(action_owner, HYPNOEYES_ACTION_TIME, action_target))
		// Action timer was interrupted
		// Warn the user, then return
		to_chat(action_owner, span_warning(LANG("datum.5915acf95f544717", list(action_target, term_hypno, action_target.p_them()))))
		to_chat(action_target, span_notice(LANG("datum.e4a30e55c20e7245", list(action_owner))))
		return

	// Define blank response
	var/input_consent

	// Check for non-consensual setting
	if(!findtext(action_target.client?.prefs.read_preference(/datum/preference/choiced/erp_status_nc), "Yes"))
		// Non-consensual is NOT enabled
		// Define warning suffix
		var/warning_target = (mode_brainwash ? LANG("datum.1fa8e88f5942f9ac", list(action_owner)) : LANG("datum.114a4699aab42726", null))

		// Prompt target for consent response
		input_consent = alert(action_target, LANG("datum.18f79dd470194a34", list(action_owner, term_suggest, warning_target)), LANG("datum.d9547f3371f46edf", null), "Yes", "No")

	// When consent is denied
	if(input_consent == "No")
		// Warn the users, then return
		to_chat(action_owner, span_warning(LANG("datum.b369aac2c3183e94", list(action_target, term_hypno, action_target.p_them(), action_target.p_they()))))
		to_chat(action_target, span_notice(LANG("datum.80dc13ddc7b04b67", list(action_owner))))
		return

	// Display local message
	action_target.visible_message(span_warning(LANG("datum.9ac83e3b04be990f", list(action_target))), span_danger(LANG("datum.4c29b887c6922c29", list(action_owner, term_suggest))))

	// Set sleeping
	action_target.SetSleeping(HYPNOEYES_SLEEP_TIME)

	// Set drowsiness if below value
	action_target.set_drowsiness_if_lower(HYPNOEYES_DROWSINESS)

	// Define warning suffix
	var/warning_owner = (mode_brainwash ? LANG("datum.bdfa250806449140", null) : LANG("datum.c320c98a3c4e8186", list(action_target.p_they(), action_target.p_their())))

	// Prompt action owner for response
	var/input_suggestion = input(LANG("datum.5ce211c54bdafd69", list(term_suggest, action_target, action_target.p_them(), warning_owner)), LANG("datum.2ac650fdcd2cd265", list(term_suggest)), null, null)

	// Check if input text exists
	if(!input_suggestion)
		// Alert user of no input
		to_chat(action_owner, LANG("datum.6c30956d3ecee0fc", list(action_target, term_suggest)))

		// Remove sleep, then return
		action_target.SetSleeping(0)
		return

	// Sanitize input text
	input_suggestion = sanitize(input_suggestion)

	// Check if brainwash mode
	if(mode_brainwash)
		// Create brainwash objective
		brainwash(action_target, input_suggestion)

	// Not in brainwash mode
	else
		// Display message to target
		to_chat(action_target, span_reallybig(span_hypnophrase("...[input_suggestion]...")))

	// Start cooldown
	StartCooldown()

	// Display message to action owner
	to_chat(action_owner, LANG("datum.83290e4ff6729102", list(term_suggest, action_target)))

	// Play a sound effect
	conditional_pref_sound(action_target, 'sound/effects/magic/smoke.ogg', 20, 1)

	// Display local message
	action_target.visible_message(span_warning(LANG("datum.6b47c804ca61d7d2", list(action_target))), span_danger(LANG("datum.a9e1be82854fe491", list(action_owner))))

	// Remove sleep, then return
	action_target.SetSleeping(0)

	// Add logging
	message_admins("[ADMIN_LOOKUPFLW(action_owner)] hypnotized [ADMIN_LOOKUPFLW(action_target)] with the suggestion '[input_suggestion]'.")
	owner.log_message("hypnotized [key_name(action_target)] with the suggestion '[input_suggestion]'", LOG_GAME)

	return

#undef HYPNOEYES_COOLDOWN_NORMAL
#undef HYPNOEYES_COOLDOWN_BRAINWASH
#undef HYPNOEYES_ACTION_TIME
#undef HYPNOEYES_SLEEP_TIME
#undef HYPNOEYES_DROWSINESS
