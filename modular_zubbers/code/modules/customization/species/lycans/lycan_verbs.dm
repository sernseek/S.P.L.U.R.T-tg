// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/action/cooldown/spell/beast_form
	name = "Toggle Beast Form"
	desc = "Transform between human and lycan form."
	button_icon = 'modular_zubbers/code/modules/customization/species/lycans/lycan_verbs.dmi'
	button_icon_state = "lycan_form"

#ifndef TESTING
	cooldown_time = 30 SECONDS
#else
	cooldown_time = 1 SECONDS // I don't wanna wait
#endif
	antimagic_flags = SPELL_REQUIRES_NO_ANTIMAGIC
	spell_requirements = NONE

/datum/action/cooldown/spell/beast_form/proc/update_button_state(new_state) //This makes it so that the button icon changes dynamically based on ears being up or not.
	button_icon_state = new_state
	owner.update_action_buttons()

/datum/action/cooldown/spell/beast_form/cast(atom/target)
	. = ..()
	owner.visible_message(span_warning(LANG("datum.c29ff448b8d2b33b", list(owner))), span_danger(LANG("datum.b7188ef46c06540b", null)))
	playsound(owner, 'sound/effects/wounds/crack1.ogg', 50)
	if(!do_after(owner, delay = 1.5 SECONDS)) //SPLURT EDIT ADD - Action timer; no jumpscaring people mid fight with it
		return // SPLURT ADD
	var/obj/item/organ/brain/lycan/brain = owner?.get_organ_slot(ORGAN_SLOT_BRAIN)
	brain.toggle_beast_form(target)
	if(!HAS_TRAIT(owner, TRAIT_BEAST_FORM))
		update_button_state("lycan_form")
	else
		update_button_state("human_form")
