// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/breastpump
	name = "breast pump"
	icon = 'modular_zubbers/icons/obj/lewd.dmi'
	icon_state = "breastpump"
	desc = "A breast pump, designed to take beakers or cups to help assist lactating patients."
	w_class = WEIGHT_CLASS_SMALL
	/// Only allowed to input beaker or cup type objects
	var/list/allowed_containers = list(/obj/item/reagent_containers/cup/beaker, /obj/item/reagent_containers/cup/glass)
	/// The presently-inserted container.
	var/obj/item/reagent_containers/cup/container
	/// Flags used by the injection/draw
	var/inject_flags = NONE
	/// Can you hotswap beakers? - Yes
	var/quickload = TRUE


/obj/item/breastpump/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/breastpump/examine(mob/user)
	. = ..()
	if(container)
		. += LANG("obj.51df6eecbe87ab34", list(container, container.reagents.total_volume))
	else
		. += LANG("obj.3fe29183a6a5a229", null)

/obj/item/breastpump/proc/unload_container(obj/object, mob/user)
	if(!object)
		to_chat(user, span_notice(LANG("obj.fbc41acbad8e2cae", null)))
		return

	container.forceMove(user.loc)
	user.put_in_hands(container)
	to_chat(user, span_notice(LANG("obj.cbed32661d4c054a", list(object, src))))
	container = null
	update_icon()
	playsound(loc, 'sound/items/weapons/empty.ogg', 50, 1)

/obj/item/breastpump/proc/insert_container(obj/item/new_container, mob/living/user)
	var/atom/quickswap_loc = new_container.loc
	if(!user.transferItemToLoc(new_container, src))
		return FALSE
	if(!isnull(container))
		if(quickswap_loc == user)
			user.put_in_hands(container)
		else
			container.forceMove(quickswap_loc)
	container = new_container
	user.visible_message(span_notice(LANG("obj.ba8a2dbbbc555acf", list(user, src))), span_notice(LANG("obj.cca0f3fd45fd3903", list(container, src))))
	playsound(loc, 'sound/items/weapons/autoguninsert.ogg', 35, 1)
	update_appearance()

/obj/item/breastpump/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!is_type_in_list(tool, allowed_containers))
		to_chat(user, span_notice(LANG("obj.3bc3980699d30bad", list(src))))
		return NONE
	if(isnull(container) || quickload)
		insert_container(tool, user)
		return ITEM_INTERACT_SUCCESS
	to_chat(user, span_warning(LANG("obj.cb8c9888dd31bcd6", list(src))))
	return ITEM_INTERACT_BLOCKING

/obj/item/breastpump/proc/try_pump(atom/target, mob/user)
	if(!target.reagents)
		return FALSE

	if(isliving(target))
		var/mob/living/living_target = target
		if(!living_target.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE|inject_flags))
			return FALSE

	return TRUE

/obj/item/breastpump/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!target.reagents)
		return NONE
	if(!src.container)
		to_chat(user, span_warning(LANG("obj.f7016ad0bba9a143", null)))
		return ITEM_INTERACT_BLOCKING
	if(!try_pump(target, user))
		return ITEM_INTERACT_BLOCKING
	if(target != user)
		to_chat(user, span_warning(LANG("obj.fec200f172a942dd", null)))
		return ITEM_INTERACT_BLOCKING

	SEND_SIGNAL(target, COMSIG_LIVING_TRY_SYRINGE_WITHDRAW, user)

	if(src.container.reagents.holder_full())
		to_chat(user, span_notice(LANG("obj.8e2d390ca03cb226", list(src))))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/organ/genital/breasts/breasts = user.get_organ_slot(ORGAN_SLOT_BREASTS)

	if (breasts == null)
		to_chat(user, span_notice(LANG("obj.1915fd242055cf15", list(user))))
		return ITEM_INTERACT_BLOCKING

	if (breasts.reagents.total_volume <= 0)
		to_chat(user, span_notice(LANG("obj.376eeb52d186315c", list(user))))
		return ITEM_INTERACT_BLOCKING

	var/fluid_multiplier = 3

	if(user.has_status_effect(/datum/status_effect/climax))
		fluid_multiplier = 5

	to_chat(user, span_notice(LANG("obj.f7c6812426fd09ef", list(src))))
	var/trans = breasts.reagents.trans_to(src.container, 1 * fluid_multiplier, transferred_by = user) // transfer from, transfer to - who cares?
	if(trans)
		to_chat(user, span_notice(LANG("obj.24df3147e3d1fd89", list(src.container, trans, src.container.reagents.total_volume))))
	return ITEM_INTERACT_SUCCESS

/obj/item/breastpump/attack_hand(mob/living/user)
	if(user && loc == user && user.is_holding(src))
		if(user.incapacitated)
			return
		else if(!container)
			. = ..()
			return
		else
			unload_container(container,user)
	else
		. = ..()

/obj/item/breastpump/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.f52471bacefa7fad", null))


