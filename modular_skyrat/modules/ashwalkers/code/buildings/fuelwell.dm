// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//CODE CREDIT TO JJPARK-KB
//Infinite welding fuel source, lets ashwalkers have infinite fuel without needing high-tech welders.

/obj/structure/sink/fuel_well
	name = "fuel well"
	desc = "A bubbling pool of fuel. This would probably be valuable, had bluespace technology not destroyed the need for fossil fuels 200 years ago."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "puddle-oil"
	dispensedreagent = /datum/reagent/fuel
	color = "#742912"	//Gives it a weldingfuel hue

/obj/structure/sink/fuel_well/Initialize(mapload)
	.=..()
	create_reagents(20)
	reagents.add_reagent(dispensedreagent, 20)

/obj/structure/sink/fuel_well/attack_hand(mob/user, list/modifiers)
	flick("puddle-oil-splash",src)
	reagents.expose(user, TOUCH, 20) //Covers target in 20u of fuel.
	to_chat(user, span_notice(LANG("obj.3c9abb5455d9b98f", null)))

/obj/structure/sink/fuel_well/attackby(obj/item/O, mob/living/user, params)
	flick("puddle-oil-splash",src)
	if(O.tool_behaviour == TOOL_SHOVEL) //attempt to deconstruct the puddle with a shovel //attempt to deconstruct the puddle with a shovel
		to_chat(user, LANG("obj.acd02742b024df60", null))
		O.play_tool_sound(src)
		deconstruct()
		return 1
	if(istype(O, /obj/item/reagent_containers)) //Refilling bottles with oil
		var/obj/item/reagent_containers/RG = O
		if(RG.is_refillable())
			if(!RG.reagents.holder_full())
				RG.reagents.add_reagent(dispensedreagent, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
				to_chat(user, span_notice(LANG("obj.3adf2506e97dc688", list(RG, src))))
				return TRUE
			to_chat(user, span_notice(LANG("obj.03adc6e9eaa5eda9", list(RG))))
			return FALSE
	if(O.tool_behaviour == TOOL_WELDER)
		if(!reagents.has_reagent(/datum/reagent/fuel))
			to_chat(user, span_warning(LANG("obj.acd296d8b46ae0a0", list(src))))
			return
		var/obj/item/weldingtool/W = O
		if(istype(W) && !W.welding)
			if(W.reagents.has_reagent(/datum/reagent/fuel, W.max_fuel))
				to_chat(user, span_warning(LANG("obj.c927127059a90967", list(W.name))))
				return
			reagents.trans_to(W, W.max_fuel, transferred_by = user)
			user.visible_message(span_notice(LANG("obj.3f21aaca699f8ff3", list(user, user.p_their(), W.name))), span_notice(LANG("obj.e125cbe727e270a3", list(W))))
			playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
			W.update_appearance()
		return
	else
		return ..()
