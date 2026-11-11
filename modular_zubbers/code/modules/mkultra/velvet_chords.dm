// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/organ/vocal_cords/velvet
	name = "velvet chords"
	desc = "The voice from these want to make you drift off, sleep, and obey."
	icon = 'modular_zubbers/icons/obj/vocal_cords.dmi'
	icon_state = "velvet_chords"
	actions_types = list(/datum/action/item_action/organ_action/velvet)
	spans = list("velvet")

/datum/action/item_action/organ_action/velvet
	name = "Velvet Chords"
	desc = "Speak in a sultry tone. Right click to see all commands."
	var/obj/item/organ/vocal_cords/velvet/chords

/datum/action/item_action/organ_action/velvet/New(Target)
	. = ..()
	chords = Target

/datum/action/item_action/organ_action/velvet/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(trigger_flags & TRIGGER_SECONDARY_ACTION)
		ui_interact(clicker)
		return ..()
	var/command = tgui_input_text(owner, LANG("datum.89635dead2b5fa69", null), LANG("datum.a4e844da7c4e52d5", null), max_length = MAX_MESSAGE_LEN)
	if(!command)
		return FALSE
	if(QDELETED(src) || QDELETED(owner))
		return FALSE
	for(var/mob/living/people in get_hearers_in_view(DEFAULT_VIEW_RANGE, owner))
		var/datum/status_effect/mkultra/status = people.has_status_effect(/datum/status_effect/mkultra)
		if(isnull(status))
			continue
		if(status.enchanter != owner)
			continue
		if(!status.listener(owner, command))
			return FALSE
	owner.say(LANG("datum.4744c02d0184bdbc", list(command)))


