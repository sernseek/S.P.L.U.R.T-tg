// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/structure/chalkboard
	name = "Chalkboard"
	icon = 'modular_zubbers/icons/obj/structures/chalkboard.dmi'
	icon_state = "chalkboard"
	maptext_width = 64
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 20)
	//The text that is written on the chalkboard. Cleared when erased.
	var/written_text = ""
	//This is a Chalkboard.

/obj/structure/chalkboard/examine(mob/user)
	. = ..()
	. += LANG("obj.910bf6d2b6c9cea2", null)
	if(written_text)
		. += LANG("obj.73f3a4d5ceb266a4", null)
		. += LANG("obj.9cd8fadece4c3f2d", list(written_text))
		. += LANG("obj.f2d8510ad640f8aa", null)

//We want people to be able to write on it, so a left click interaction.
/obj/structure/chalkboard/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	//We begin by allowing our player to write on the chalkboard using the white crayon.
	if(istype(attacking_item, /obj/item/toy/crayon/white))
		if(length_char(written_text) < MAX_MESSAGE_LEN) //Check to see if the written text is too long before continuing
			var/input_message = tgui_input_text(user, LANG("obj.c122a323a11758fa", null), LANG("obj.356af4387c97b36f", null), max_length = CHAT_MESSAGE_MAX_LENGTH, multiline = TRUE)
			if(do_after(user, 5 SECONDS, target = src))
				written_text += "[input_message]\n"
				say(input_message, sanitize = FALSE)
				if(length_char(written_text))
					icon_state = "chalkboard_filled"
					update_appearance()
		else
			to_chat(user, span_warning(LANG("obj.5f943c3b636b0467", null)))
	else if(istype(attacking_item, /obj/item/toy/crayon/green)) //What are you, stupid?
		tgui_input_text(user, LANG("obj.c122a323a11758fa", null), LANG("obj.356af4387c97b36f", null), max_length = CHAT_MESSAGE_MAX_LENGTH, multiline = TRUE) //Fake them out.
		if(do_after(user, 5 SECONDS, target = src))
			to_chat(user, span_warning(LANG("obj.24c1dd89a2c0e29e", null)))
			if(ishuman(user))
				var/mob/living/carbon/human/idiot = user
				idiot.add_mood_event("chalkboard", /datum/mood_event/green_idiot)
	else to_chat(user, span_warning(LANG("obj.92642b4cb4672ffa", null)))

/obj/structure/chalkboard/attack_hand_secondary(mob/user)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	to_chat(user, span_warning(LANG("obj.6500f076d29baa8a", null)))
	if(!written_text)
		to_chat(user, span_warning(LANG("obj.bbcc3d6c416ee53d", null)))
		if(ishuman(user))
			var/mob/living/carbon/human/papper = user
			papper.add_mood_event("chalkboard", /datum/mood_event/cathartic_eraser)
	else if(do_after(user, 5 SECONDS, target = src))
		written_text = ""
		icon_state = "chalkboard"
		update_appearance()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/chalkboard/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(obj_flags & NO_DEBRIS_AFTER_DECONSTRUCTION)
		return FALSE
	to_chat(user, span_notice(LANG("obj.08e1925c5d86f79d", list(src))))
	if(tool.use_tool(src, user, 4 SECONDS, volume=50))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct()
	return ITEM_INTERACT_SUCCESS

/obj/structure/chalkboard/handle_deconstruct(disassembled = TRUE)
	. = ..()
	if(!(obj_flags & NO_DEBRIS_AFTER_DECONSTRUCTION))
		new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)
	qdel(src)

/datum/mood_event/cathartic_eraser
	description = "Gave the chalkboard a few paps with the eraser. It makes you feel a little better."
	mood_change = 1
	timeout = 1 MINUTES

/datum/mood_event/green_idiot
	description = "I tried to write on the chalkboard, which is green, with a green crayon. I feel dumb."
	mood_change = -1
	timeout = 1 MINUTES
