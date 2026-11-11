// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/sextoy/portal_panties
	name = "portal panties"
	desc = "A pair of panties with bluespace tech allowing lovers to hump at a distance. Needs to be paired with a portal fleshlight before use."
	icon = 'modular_zzplurt/icons/obj/lewd/fleshlight.dmi'
	icon_state = "portal_panties"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/underwear.dmi' //TODO: Add a worn icon for this item
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_MASK
	extra_slot_flags = ITEM_SLOT_UNDERWEAR
	lewd_slot_flags = LEWD_SLOT_PENIS | LEWD_SLOT_VAGINA | LEWD_SLOT_ANUS
	clothing_flags = INEDIBLE_CLOTHING
	var/obj/item/clothing/sextoy/portal_fleshlight/linked_fleshlight = null
	var/current_target = null
	var/equipped_slot = null
	/// Whether the panties' wearer is anonymous
	var/anonymous = FALSE

/obj/item/clothing/sextoy/portal_panties/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/clothing/sextoy/portal_panties/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Pick up"
		context[SCREENTIP_CONTEXT_RMB] = "Toggle anonymous mode"
		context[SCREENTIP_CONTEXT_ALT_LMB] = linked_fleshlight ? "Unlink fleshlight" : "No fleshlight linked"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/clothing/sextoy/portal_fleshlight))
		context[SCREENTIP_CONTEXT_LMB] = "Link fleshlight"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/clothing/sextoy/portal_panties/examine(mob/user)
	. = ..()
	if(!linked_fleshlight)
		. += span_notice(LANG("obj.a56752b9b87555eb", null))
		return

	. += span_notice(LANG("obj.9eafd5fbe5336184", list(equipped_slot ? "on" : "off", equipped_slot ? "open" : "closed")))
	if(equipped_slot)
		. += span_notice(LANG("obj.8b2a8a06643e8aab", list(current_target)))

	. += span_notice(LANG("obj.b32e6b5ade3ba402", null))
	. += span_notice(LANG("obj.767f5d832507da08", null))
	. += span_notice(LANG("obj.26e1029b5f8ca3a4", null))

/obj/item/clothing/sextoy/portal_panties/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	var/obj/item/clothing/sextoy/portal_fleshlight/portal_toy = W
	if(!istype(portal_toy))
		return
	portal_toy.link_panties(src, user)

/obj/item/clothing/sextoy/portal_panties/lewd_equipped(mob/living/carbon/human/user, slot, initial)
	. = ..()
	update_target(user, slot)

/obj/item/clothing/sextoy/portal_panties/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	update_target(user, slot)

/obj/item/clothing/sextoy/portal_panties/dropped(mob/living/carbon/human/user)
	. = ..()
	update_target(user)

/obj/item/clothing/sextoy/portal_panties/proc/update_target(mob/living/carbon/human/user, slot)
	if(!istype(user))
		return

	equipped_slot = slot

	switch(slot)
		if(ITEM_SLOT_UNDERWEAR)
			if(ismob(loc))
				var/mob/living/carbon/human/H = loc
				if(H.has_vagina())
					current_target = ORGAN_SLOT_VAGINA
				else if(H.has_penis())
					current_target = ORGAN_SLOT_PENIS
				else
					current_target = ORGAN_SLOT_ANUS
		if(ITEM_SLOT_MASK)
			current_target = BODY_ZONE_PRECISE_MOUTH
		if(ORGAN_SLOT_PENIS)
			current_target = ORGAN_SLOT_PENIS
		if(ORGAN_SLOT_VAGINA)
			current_target = ORGAN_SLOT_VAGINA
		if(ORGAN_SLOT_ANUS)
			current_target = ORGAN_SLOT_ANUS
		else
			current_target = null

	if(linked_fleshlight)
		linked_fleshlight.update_appearance()
	else if(slot in list(ITEM_SLOT_UNDERWEAR, ITEM_SLOT_MASK, ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS))
		audible_message(LANG("obj.a31e23785cc68a0a", list(icon2html(src, hearers(src)))))
		playsound(src, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(user, span_notice(LANG("obj.af2d3b15299b6d43", null)))

/obj/item/clothing/sextoy/portal_panties/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .

	anonymous = !anonymous
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	balloon_alert(user, LANG("obj.8ef36c07ada1b62e", list(anonymous ? "ON" : "OFF")))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/sextoy/portal_panties/click_alt(mob/user)
	if(!linked_fleshlight)
		to_chat(user, span_warning(LANG("obj.b5f4a5acd325e3fd", list(src))))
		return CLICK_ACTION_BLOCKING

	var/choice = tgui_alert(user, LANG("obj.c750f19333af9580", null), LANG("obj.949d5fd81fecb420", null), list("Yes", "No"))
	if(choice != "Yes")
		return CLICK_ACTION_BLOCKING

	to_chat(user, span_notice(LANG("obj.7ee9ab86d9920328", list(src))))
	linked_fleshlight.unlink_panties()

/obj/item/clothing/sextoy/portal_panties/Destroy()
	if(linked_fleshlight)
		linked_fleshlight.unlink_panties()
		linked_fleshlight = null
	return ..()
