// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//////////////////////////////////////
///////ENTHRAL VELVET CHORDS//////////
//////////////////////////////////////

//Heavily modified voice of god code
/obj/item/organ/vocal_cords/velvet
	name = "Velvet chords"
	desc = "The voice spoken from these just make you want to drift off, sleep and obey."
	icon = 'modular_zubbers/icons/obj/vocal_cords.dmi'
	icon_state = "velvet_chords"
	actions_types = list(/datum/action/item_action/organ_action/velvet)
	spans = list("velvet")

/datum/action/item_action/organ_action/velvet
	name = "Velvet chords"
	var/obj/item/organ/vocal_cords/velvet/cords = null

/datum/action/item_action/organ_action/velvet/New(Target)
	..()
	cords = target

/datum/action/item_action/organ_action/velvet/IsAvailable(feedback = TRUE)
	return TRUE

/datum/action/item_action/organ_action/velvet/Trigger(mob/clicker, trigger_flags)
	. = ..()
	var/command = input(owner, LANG("datum.ac7b89974be8a46d", null), LANG("datum.a4e844da7c4e52d5", null))
	if(QDELETED(src) || QDELETED(owner))
		return
	if(!command)
		return
	owner.say(LANG("datum.4744c02d0184bdbc", list(command)))

/obj/item/organ/vocal_cords/velvet/can_speak_with()
	return TRUE

/obj/item/organ/vocal_cords/velvet/handle_speech(message) //actually say the message
	owner.say(message, spans = spans, sanitize = FALSE)
	velvetspeech(message, owner, 1)

//////////////////////////////////////
///////////FermiChem//////////////////
//////////////////////////////////////
//Removed span_list from input arguments.
/proc/velvetspeech(message, mob/living/user, base_multiplier = 1, message_admins = FALSE, debug = FALSE)
	//SPLURT: centralize command handling so Mk.2 chips use modular commands and originals keep their flow.
	return mkultra_handle_base_commands(message, user, base_multiplier, message_admins, debug)

