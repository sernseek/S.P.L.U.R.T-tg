// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Showers are known for their hackable electrical components
/obj/machinery/shower/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()

	// Check if valid
	if(isnull(user) || !istype(emag_card))
		return FALSE

	// Check for bloodmag
	if(emag_card.type == /obj/item/card/emag/bloodfledge)
		// Check if reagent is already blood
		if(reagent_id == /datum/reagent/blood)
			// Alert user
			balloon_alert(user, LANG("obj.d438ec583396e7b4", null))

		else
			// Set new reagent type
			reagent_id = /datum/reagent/blood

			// Clear old reagents
			reagents.clear_reagents()

			// Add new reagent
			reagents.add_reagent(reagent_id, reagent_capacity)

			// Create balloon alert
			balloon_alert(user, LANG("obj.086299ca781cd5f3", null))

			// Alert in chat with reduced range
			user.visible_message(\
				span_notice(LANG("obj.0304953ea271a74a", list(user, user.p_their(), emag_card, src))),\
				span_notice(LANG("obj.d558b575ae47afd7", list(emag_card, src))),\
				vision_distance = COMBAT_MESSAGE_RANGE
			)

			// Log interaction
			user.log_message("has sanguinized a shower.", LOG_ATTACK)
