// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/element/mob_holder/micro

/datum/element/mob_holder/micro/Attach(datum/target, worn_state, alt_worn, right_hand, left_hand, inv_slots = NONE, proctype, escape_on_find)
	. = ..()

	RegisterSignal(target, COMSIG_CLICK_ALT, PROC_REF(mob_try_pickup_micro), TRUE)
	RegisterSignal(target, COMSIG_MICRO_PICKUP_FEET, PROC_REF(mob_pickup_micro_feet))
	RegisterSignal(target, COMSIG_MOB_RESIZED, PROC_REF(on_resize))

/datum/element/mob_holder/micro/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_MICRO_PICKUP_FEET)

/datum/element/mob_holder/micro/proc/on_resize(mob/living/micro, new_size, old_size)
	var/obj/item/mob_holder/holder = micro.loc
	if(istype(holder))
		var/mob/living/living = get_atom_on_turf(micro.loc, /mob/living)
		if(living && (COMPARE_SIZES_WITH_LIMBLOSS(living, micro)) < 2.0)
			living.visible_message(span_warning(LANG("datum.d4ea72a1c709590e", list(living, micro, micro.p_they()))),
								span_warning(LANG("datum.d24fd6dec20e545e", list(living, living.p_they()))))
			holder.release()
		else if(!istype(living)) // Somehow a inside a mob_holder and the mob_holder isn't inside any livings? release.
			holder.release()

/datum/element/mob_holder/micro/on_examine(mob/living/source, mob/user, list/examine_list)
	if(ishuman(user) && !istype(source.loc, /obj/item/mob_holder) && (COMPARE_SIZES_WITH_LIMBLOSS(user, source)) >= 2.0)
		examine_list += span_notice(LANG("datum.1eee54ce2e929de7", list(source.p_they(FALSE))))

/// Do not inherit from /mob_holder, interactions are different.
/datum/element/mob_holder/micro/on_requesting_context_from_item(
	obj/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)

	LAZYSET(context, SCREENTIP_CONTEXT_ALT_LMB, "Pick up")
	return CONTEXTUAL_SCREENTIP_SET

/datum/element/mob_holder/micro/proc/mob_pickup_micro(mob/living/source, mob/user)
	var/obj/item/mob_holder/micro/holder = new(get_turf(source), source, worn_state, alt_worn, right_hand, left_hand, inv_slots)
	if(!holder)
		return

	user.put_in_hands(holder)
	return

//shoehorned (get it?) and lazy way to do instant foot pickups cause haha funny.
/datum/element/mob_holder/micro/proc/mob_pickup_micro_feet(mob/living/source, mob/user)
	var/obj/item/mob_holder/micro/holder = new(get_turf(source), source, worn_state, alt_worn, right_hand, left_hand, inv_slots)
	if(!holder)
		return
	user.equip_to_slot(holder, ITEM_SLOT_FEET)
	return

/datum/element/mob_holder/micro/proc/mob_try_pickup_micro(mob/living/carbon/source, mob/living/carbon/user)
	if(!ishuman(user) || !user.Adjacent(source) || user.incapacitated)
		return FALSE
	if(!(resolve_intent_name(user) == "grab"))
		return FALSE
	if(source == user)
		to_chat(user, span_warning(LANG("datum.4d8b681893d5fd03", null)))
		source.balloon_alert(user, LANG("datum.369180ccf02029ea", null))
		return FALSE
	if(COMPARE_SIZES_WITH_LIMBLOSS(user, source) < 2.0)
		to_chat(user, span_warning(LANG("datum.b2551b4503d1f440", null)))
		source.balloon_alert(user, LANG("datum.61304af5c216da73", null))
		return FALSE
	if(user.get_active_held_item())
		to_chat(user, span_warning(LANG("datum.86b9ca924a677805", null)))
		source.balloon_alert(user, LANG("datum.9706f865a7d0ec0e", null))
		return FALSE
	if(source.buckled)
		to_chat(user, span_warning(LANG("datum.65a86c2bb81ec41e", list(source))))
		source.balloon_alert(user, LANG("datum.e3e5c1bbc7f129b4", null))
		return FALSE
	source.visible_message(span_warning(LANG("datum.18956a90cc32caec", list(user, source))), \
					span_userdanger(LANG("datum.888a29e85f0b019e", list(user))))
	source.balloon_alert(user, LANG("datum.b2070feb5414ff7d", null))
	var/time_required = COMPARE_SIZES_WITH_LIMBLOSS(source, user) * 4 SECONDS //Scale how fast the pickup will be depending on size difference
	if(!do_after(user, time_required, source))
		return FALSE

	if(user.get_active_held_item())
		to_chat(user, span_warning(LANG("datum.86b9ca924a677805", null)))
		source.balloon_alert(user, LANG("datum.bbe07969987bc043", null))
		return FALSE
	if(source.buckled)
		to_chat(user, span_warning(LANG("datum.65a86c2bb81ec41e", list(source))))
		source.balloon_alert(user, LANG("datum.087b0ddb157f3e2a", null))
		return FALSE

	source.visible_message(span_warning(LANG("datum.c2e065881f530597", list(user, source))),
					span_userdanger(LANG("datum.9e73efeb39769da9", list(user))))
	source.drop_all_held_items()
	mob_pickup_micro(source, user)
	return TRUE

/obj/item/mob_holder/micro
	name = "micro"
	desc = "Another person, small enough to fit in your hand."
	icon = null
	icon_state = null
	worn_icon = null
	inhand_icon_state = null
	lefthand_file = null
	righthand_file = null
	slot_flags = ITEM_SLOT_FEET | ITEM_SLOT_HEAD | ITEM_SLOT_ID | ITEM_SLOT_BACK | ITEM_SLOT_NECK
	w_class = null //handled by their size
	item_flags = INEDIBLE_CLOTHING

/obj/item/mob_holder/micro/Initialize(mapload, mob/living/M, worn_state, head_icon, lh_icon, rh_icon, worn_slot_flags)
	. = ..()
	item_flags &= ~ABSTRACT
	//Updating the visuals when the mob updates doesn't work (it disappears)
	//RegisterSignals(held_mob, list(COMSIG_CARBON_APPLY_OVERLAY, COMSIG_CARBON_REMOVE_OVERLAY, COMSIG_ATOM_EXAMINE), PROC_REF(update_visuals))

/obj/item/mob_holder/micro/release(display_messages = TRUE)
	if(!held_mob)
		if(!QDELETED(src))
			qdel(src)
		return FALSE

	var/mob/living/released_mob = held_mob
	var/turf/release_turf = get_turf(src)
	if(isliving(loc))
		var/mob/living/captor = loc
		if(display_messages)
			to_chat(captor, span_warning(LANG("obj.9eb18c65843ff813", list(released_mob))))
		captor.dropItemToGround(src)
		release_turf = get_turf(src) || get_turf(captor)

	UnregisterSignal(released_mob, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM))
	held_mob = null

	if(!release_turf)
		release_turf = get_turf(released_mob)
	if(!release_turf)
		release_turf = get_turf(loc)
	if(!release_turf)
		CRASH("/obj/item/mob_holder/micro/release could not resolve a turf for [released_mob]")

	released_mob.forceMove(release_turf)
	released_mob.reset_perspective()
	released_mob.setDir(SOUTH)
	if(display_messages)
		released_mob.visible_message(span_warning(LANG("obj.25d2d428894d454c", list(released_mob))))
	if(!QDELETED(src))
		qdel(src)
	return TRUE

/obj/item/mob_holder/micro/Destroy()
	UnregisterSignal(src, COMSIG_ATOM_EXAMINE)
	. = ..()

/obj/item/mob_holder/micro/examine(mob/user)
	return held_mob.examine(user)

/obj/item/mob_holder/micro/container_resist_act(mob/living/resisting)
	if(resisting.incapacitated)
		to_chat(resisting, span_warning(LANG("obj.1cee50d0b26f94bc", null)))
		return
	var/mob/living/carrier = get_atom_on_turf(src, /mob/living)
	visible_message(span_warning(LANG("obj.4a3991d53a3eeca3", list(resisting, carrier))))
	var/time_required = COMPARE_SIZES(carrier, resisting) / 4 SECONDS //Scale how fast the resisting will be depending on size difference
	if(!do_after(resisting, time_required, carrier, IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM))
		if(!resisting || resisting.stat != STABLE || resisting.loc != src)
			return
		visible_message(span_warning(LANG("obj.de38840965ca7ae3", list(src))))
		return
	visible_message(span_warning(LANG("obj.4d099317b5c894a8", list(src, carrier))))
	release()

/obj/item/mob_holder/micro/relaymove(mob/living/mover, direction)
	if(mover==held_mob)
		return
	return ..() //This prevents movemement while being held
	// This looks like a bandaid solution but it works at least; Would probably be better off in its parent file

/obj/item/mob_holder/micro/assume_air(datum/gas_mixture/giver)
	var/turf/location = get_turf(src)
	return location.assume_air(giver)

/obj/item/mob_holder/micro/remove_air(amount)
	var/turf/location = get_turf(src)
	return location.remove_air(amount)

/obj/item/mob_holder/micro/return_air()
	var/turf/location = get_turf(src)
	return location.return_air()

/obj/item/mob_holder/micro/mouse_drop_dragged(atom/M, mob/user, src_location, over_location, params)
	. = ..()
	if(M != usr)
		return
	if(usr == src)
		return
	if(!Adjacent(usr))
		return
	if(istype(M,/mob/living/silicon/ai))
		return
	var/mob/living/carbon/human/O = held_mob
	if(istype(O))
		O.MouseDrop(usr)

/obj/item/mob_holder/micro/attack_self(mob/living/user)
	if(world.time <= user.next_click)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/mob/living/carbon/human/M = held_mob
	if(istype(M))
		switch(resolve_intent_name(user))
			if("harm") //TO:DO, rework all of these interactions to be a lot more in depth
				user.visible_message(span_danger(LANG("obj.0409d7a5642570f9", list(user, M))),
								span_danger(LANG("obj.62f897f672abee6f", list(M))),
								null,
								null,
								list(M)
				)
				to_chat(M, span_userdanger(LANG("obj.05a4f26a5ba2570d", list(user))))
				playsound(loc, 'sound/items/weapons/punch1.ogg', 50, 1)
				M.adjust_brute_loss(5)
			if("disarm")

				user.visible_message(span_danger(LANG("obj.53aad83d266bf0a9", list(user, M))),
								span_danger(LANG("obj.ab93d4dca42912fb", list(M))),
								null,
								null,
								list(M)
				)
				to_chat(M, span_userdanger(LANG("obj.6e8faea3b5be0561", list(user))))
				playsound(loc, 'sound/effects/bodyfall/bodyfall1.ogg', 50, 1)
				M.adjust_stamina_loss(10)
			if("grab")
				user.visible_message(span_danger(LANG("obj.038f6f791c5ba618", list(user, M))),
								span_danger(LANG("obj.cfae203acb6253f7", list(M))),
								null,
								null,
								list(M)
				)
				to_chat(M, span_userdanger(LANG("obj.820ad56921d8fc21", list(user))))
				playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 50, 1)
				M.adjust_oxy_loss(5)
			else
				M.help_shake_act(user)

/obj/item/mob_holder/micro/attacked_by(obj/item/I, mob/living/user)
	return held_mob?.attacked_by(I, user) || ..()

/mob/living/Adjacent(atom/neighbor)
	. = ..()
	var/obj/item/mob_holder/micro/micro_holder = loc
	if(istype(micro_holder))
		return micro_holder.Adjacent(neighbor)

/obj/item/mob_holder/micro/attack(mob/living/eater, mob/living/holder)
	var/datum/component/vore/vore = holder.GetComponent(/datum/component/vore)
	if(!vore)
		return ..()

	if(holder == eater) // Parent wants to eat pulled
		vore.vore_other(held_mob)
	else
		vore.feed_other_to_other(eater, held_mob)

/obj/item/mob_holder/micro/Exited(mob/living/totally_not_vored, direction)
	// Transferred to a belly? Get rid of this before it puts us on the floor
	if(istype(totally_not_vored.loc, /obj/vore_belly))
		held_mob = null
		qdel(src)
	return ..()

/obj/item/mob_holder/micro/GetAccess()
	. = ..()
	var/obj/item/held = held_mob.get_active_held_item()
	if(held)
		. += held.GetAccess()
	var/mob/living/carbon/human/human_micro = held_mob
	if(istype(human_micro))
		. += human_micro.wear_id?.GetAccess()

/obj/item/mob_holder/micro/GetID()
	. = ..()
	if(.)
		return
	var/obj/item/held = held_mob.get_active_held_item()
	if(isidcard(held))
		return held
	var/mob/living/carbon/human/human_micro = held_mob
	if(istype(human_micro) && isidcard(human_micro.wear_id))
		return human_micro.wear_id

/obj/item/mob_holder/micro/update_visuals(mob/living/carbon/human/tiny_person)
	. = ..()
	transform = null

// And right here i throw all of those error sprites in the trash
/obj/item/mob_holder/micro/build_worn_icon(
	default_layer = 0,
	default_icon_file = null,
	isinhands = FALSE,
	female_uniform = NO_FEMALE_UNIFORM,
	override_state = null,
	override_file = null,
	bodyshape = NONE,
	mutant_styles = NONE,
)
	return null

GAME_VERB_SRC_DESC(/obj/item/mob_holder/micro, interact_with_held, view(), "与手持对象互动", "Perform an interaction with the held mob.", "IC")
	if(!held_mob)
		to_chat(usr, span_warning(LANG("obj.1e83e0bf89dd63ad", null)))
		return

	var/datum/component/interactable/menu = held_mob.GetComponent(/datum/component/interactable)
	if(!menu)
		to_chat(usr, span_warning(LANG("obj.35bd446abe3458c2", list(held_mob))))
		return

	menu.open_interaction_menu(held_mob, usr)
