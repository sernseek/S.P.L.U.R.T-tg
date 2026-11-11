// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//////////////////////
//     BLOODBAG     //
//////////////////////

#define BLOODBAG_GULP_SIZE 5

/obj/item/reagent_containers/blood
	var/being_drunk = FALSE

/// Taken from drinks.dm
/obj/item/reagent_containers/blood/attack(mob/living/victim, mob/living/attacker, params)
	if(!can_drink(victim, attacker) || being_drunk)
		return
	being_drunk = TRUE
	if(victim != attacker)
		// show to both victim and attacker
		INVOKE_ASYNC(src, GLOBAL_PROC_REF(do_after), victim, 5 SECONDS, attacker)
		do_after(victim, 5 SECONDS, attacker)
		if(!do_after(attacker, 5 SECONDS, victim))
			being_drunk = FALSE
			return
		attacker.visible_message(
			span_notice(LANG("obj.b3bb80245649eb28", list(attacker, victim, src))),
			span_notice(LANG("obj.41e3b93300c22c66", list(src, victim))))
		reagents.trans_to(victim, BLOODBAG_GULP_SIZE, transferred_by = attacker, methods = INGEST)
		playsound(victim.loc, 'sound/items/drink.ogg', 30, 1)
		being_drunk = FALSE
		return TRUE

	while(do_after(victim, 1 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE, extra_checks = CALLBACK(src, PROC_REF(can_drink), attacker, victim)))
		victim.visible_message(
			span_notice(LANG("obj.8f16bc4b40a5bfbd", list(victim, src))),
			span_notice(LANG("obj.7adc06892390bf7a", list(src))),
		)
		reagents.trans_to(victim, BLOODBAG_GULP_SIZE, transferred_by = attacker, methods = INGEST)
		playsound(victim.loc, 'sound/items/drink.ogg', 30, 1)
	being_drunk = FALSE
	return TRUE

#undef BLOODBAG_GULP_SIZE

/obj/item/reagent_containers/blood/proc/can_drink(mob/living/victim, mob/living/attacker)
	if(!canconsume(victim, attacker))
		return FALSE
	if(!reagents || !reagents.total_volume)
		to_chat(victim, span_warning(LANG("obj.02d482cc1aef0cef", list(src))))
		return FALSE
	return TRUE

///Bloodbag of Bloodsucker blood (used by Ghouls only)
/obj/item/reagent_containers/blood/o_minus/bloodsucker
	name = "blood pack"
	blood_type = null
	list_reagents = list(/datum/reagent/blood/bloodsucker = 200)

/obj/item/reagent_containers/blood/o_minus/bloodsucker/examine(mob/user)
	. = ..()
	if(user.mind.has_antag_datum(/datum/antagonist/ex_ghoul) || user.mind.has_antag_datum(/datum/antagonist/ghoul/revenge))
		. += span_notice(LANG("obj.87ef18f83d04f1c8", null))

//////////////////////
//      STAKES      //
//////////////////////
/obj/item/stack/sheet/mineral/wood/attackby(obj/item/item, mob/user, params)
	if(!item.get_sharpness())
		return ..()
	user.visible_message(
		span_notice(LANG("obj.cbc8c4f220de722f", list(user, src))),
		span_notice(LANG("obj.f7cccbd079eea9c0", list(src))),
		span_hear(LANG("obj.a69f0992d2050a49", null)),
	)
	// 5 Second Timer
	if(!do_after(user, 5 SECONDS, src, NONE, TRUE))
		return
	// Make Stake
	var/obj/item/stake/new_item = new(user.loc)
	user.visible_message(
		span_notice(LANG("obj.a6b24881e658b5e9", list(user, src))),
		span_notice(LANG("obj.6113c6df4b6193c1", list(src))),
	)
	// Prepare to Put in Hands (if holding wood)
	var/obj/item/stack/sheet/mineral/wood/wood_stack = src
	var/replace = (user.get_inactive_held_item() == wood_stack)
	// Use Wood
	wood_stack.use(1)
	// If stack depleted, put item in that hand (if it had one)
	if(!wood_stack && replace)
		user.put_in_hands(new_item)

// TODO move this into bloodsuckerdatum
/// Do I have a stake in my heart?
/mob/living/proc/am_staked()
	var/obj/item/bodypart/chosen_bodypart = get_bodypart(BODY_ZONE_CHEST)
	var/obj/item/stake/stake = locate() in chosen_bodypart.embedded_objects
	return stake

/mob/living/proc/get_stakes()
	var/obj/item/bodypart/chosen_bodypart = get_bodypart(BODY_ZONE_CHEST)
	if(!chosen_bodypart)
		return FALSE
	var/list/stakes = list()
	for(var/obj/item/embedded_stake in chosen_bodypart.embedded_objects)
		if(istype(embedded_stake, /obj/item/stake))
			stakes += list(embedded_stake)
	return stakes

/datum/embedding/stake
	embed_chance = 20

/obj/item/stake
	name = "wooden stake"
	desc = "A simple wooden stake carved to a sharp point."
	icon = 'modular_zubbers/icons/obj/equipment/stakes.dmi'
	icon_state = "wood"
	inhand_icon_state = "wood"
	lefthand_file = 'modular_zubbers/icons/mob/inhands/weapons/bloodsucker_lefthand.dmi'
	righthand_file = 'modular_zubbers/icons/mob/inhands/weapons/bloodsucker_righthand.dmi'
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("staked", "stabbed", "tore into")
	attack_verb_simple = list("staked", "stabbed", "tore into")
	sharpness = SHARP_EDGED
	embed_data = /datum/embedding/stake
	force = 6
	throwforce = 10
	max_integrity = 30
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 3)

	///Time it takes to embed the stake into someone's chest.
	var/staketime = 5 SECONDS
	var/kills_blodsuckers = FALSE

/obj/item/stake/examine_more(mob/user)
	. = ..()
	. += span_notice(LANG("obj.2efe38388e3fdc15", list(src)))
	if(IS_BLOODSUCKER(user))
		. += span_warning(LANG("obj.ce698ff22d8cdce2", list(src)))

/obj/item/stake/attack(mob/living/target, mob/living/user, params)
	. = ..()
	if(.)
		return
	// Invalid Target, or not targetting the chest?
	if(check_zone(user.zone_selected) != BODY_ZONE_CHEST)
		return
	if(target == user)
		return
	if(!target.can_be_staked()) // Oops! Can't.
		to_chat(user, span_danger(LANG("obj.aa47eef26afda469", list(target))))
		return
	if(HAS_TRAIT(target, TRAIT_PIERCEIMMUNE))
		to_chat(user, span_danger(LANG("obj.cb8e15408d4298b5", list(target))))
		return

	to_chat(user, span_notice(LANG("obj.56c636790a19ba3c", list(target))))
	playsound(user, 'sound/effects/magic/Demon_consume.ogg', 50, 1)
	if(!do_after(user, staketime, target, extra_checks = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon, can_be_staked)))) // user / target / time / uninterruptable / show progress bar / extra checks
		return
	// Drop & Embed Stake
	user.visible_message(
		span_danger(LANG("obj.c3334307f3eae0cd", list(user.name, src, target))),
		span_danger(LANG("obj.c83d3f655e418030", list(src, target))),
	)
	playsound(get_turf(target), 'sound/effects/splat.ogg', 40, 1)
	if(force_embed(target, target.get_bodypart(BODY_ZONE_CHEST))) //and if it embeds successfully in their chest, cause a lot of pain
		target.apply_damage(max(10, force * 1.2), BRUTE, BODY_ZONE_CHEST, wound_bonus = 0, sharpness = TRUE)
		on_stake_embed(target, user)

/obj/item/stake/proc/on_stake_embed(mob/living/target, mob/living/user)
	return

/obj/item/stake/hardened/silver/on_stake_embed(mob/living/target, mob/living/user)
	var/obj/item/organ/heart/heart = target.get_organ_slot(ORGAN_SLOT_HEART)
	if(!heart)
		return
	target.visible_message(
		span_danger(LANG("obj.a9ca382dec165f75", list(src.name, target, heart.name))),
		span_userdanger(LANG("obj.08207bd4b2002ee4", list(src.name, heart.name))),
	)
	qdel(heart)

/obj/item/stake/force_embed(mob/living/carbon/victim, obj/item/bodypart/target_limb)
	. = ..()
	if(!.)
		return .
	SEND_SIGNAL(target_limb, COMSIG_BODYPART_STAKED, TRUE)
	SEND_SIGNAL(victim, COMSIG_MOB_STAKED, TRUE)
	return .

///Can this target be staked? If someone stands up before this is complete, it fails. Best used on someone stationary.
/mob/living/proc/can_be_staked()
	return FALSE

/mob/living/carbon/can_be_staked()
	if(body_position == LYING_DOWN)
		return TRUE
	return FALSE

/datum/embedding/stake/hardened
	embed_chance = 35
	fall_chance = 0

/// Created by welding and acid-treating a simple stake.
/obj/item/stake/hardened
	name = "hardened stake"
	desc = "A wooden stake carved to a sharp point and hardened by fire."
	icon_state = "hardened"
	force = 8
	throwforce = 12
	armour_penetration = 10
	embed_data = /datum/embedding/stake/hardened
	staketime = 12 SECONDS
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/stake/hardened/examine_more(mob/user)
	. = ..()
	. += span_notice(LANG("obj.28d881d260015c33", list(src)))

/datum/embedding/stake/silver
	embed_chance = 0 // we want it to only be embeddable manually
	fall_chance = 0

/obj/item/stake/hardened/silver
	name = "silver stake"
	desc = "Polished and sharp at the end. For when some mofo is always trying to iceskate uphill."
	icon_state = "silver"
	inhand_icon_state = "silver"
	siemens_coefficient = 1
	force = 9
	armour_penetration = 25
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver = SHEET_MATERIAL_AMOUNT)
	embed_data = /datum/embedding/stake/silver
	staketime = 15 SECONDS

/obj/item/stake/hardened/silver/examine_more(mob/user)
	. = ..()
	. += span_notice(LANG("obj.fbd055132b2dbcd3", list(src)))

//////////////////////
//     ARCHIVES     //
//////////////////////

/**
 *	# Archives of the Kindred:
 *+
 *	A book that can only be used by Curators.
 *	When used on a player, after a short timer, will reveal if the player is a Bloodsucker, including their real name and Clan.
 *	This book should not work on Bloodsuckers using the Masquerade ability.
 *	If it reveals a Bloodsucker, the Curator will then be able to tell they are a Bloodsucker on examine (Like a Ghoul).
 *	Reading it normally will allow Curators to read what each Clan does, with some extra flavor text ones.
 *
 *	Regular Bloodsuckers won't have any negative effects from the book, while everyone else will get burns/eye damage.
 */
/obj/item/book/kindred
	name = "\improper Book of Nod"
	starting_title = "the Book of Nod"
	desc = "Cryptic documents explaining hidden truths behind Undead beings. It is said only Curators can decipher what they really mean."
	icon = 'modular_zubbers/icons/obj/structures/vamp_obj.dmi'
	lefthand_file = 'modular_zubbers/icons/mob/inhands/weapons/bloodsucker_lefthand.dmi'
	righthand_file = 'modular_zubbers/icons/mob/inhands/weapons/bloodsucker_righthand.dmi'
	icon_state = "kindred_book"
	starting_author = "dozens of generations of Curators"
	unique = TRUE
	throw_speed = 1
	throw_range = 10
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	///Boolean on whether the book is currently being used, so you can only use it on one person at a time.
	COOLDOWN_DECLARE(bloodsucker_check_cooldown)
	var/cooldown_time = 1 MINUTES

/obj/item/book/kindred/Initialize(mapload)
	. = ..()
	SSpoints_of_interest.make_point_of_interest(src)

/obj/item/book/kindred/carving_act(mob/living/user, obj/item/tool)
	to_chat(user, span_notice(LANG("obj.3015b80ca90575d1", list(starting_title))))
	return ITEM_INTERACT_BLOCKING

///Attacking someone with the book.
/obj/item/book/kindred/afterattack(mob/living/target, mob/living/user, flag, params)
	. = ..()
	if(!user.can_read(src) || (target == user) || !ismob(target))
		return
	if(!HAS_TRAIT(user.mind, TRAIT_BLOODSUCKER_HUNTER))
		if(IS_BLOODSUCKER(user))
			to_chat(user, span_notice(LANG("obj.b802618810e361c1", list(src))))
			return
		to_chat(user, span_warning(LANG("obj.2b668b8f27535b14", list(src))))
		user.apply_damage(3, BURN, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		return

	if(!COOLDOWN_FINISHED(src, bloodsucker_check_cooldown))
		user.balloon_alert(user, LANG("obj.0f70cb20e7a15836", null))
		addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, balloon_alert), user, "You feel your head clear up."), cooldown_time)
		return
	user.balloon_alert_to_viewers(user, LANG("obj.5a22d862e94eb76b", null))
	user.balloon_alert(target, LANG("obj.04618441d938e31c", list(src)))
	if(!do_after(user, 3 SECONDS, target, timed_action_flags = NONE, show_progress = TRUE))
		to_chat(user, span_notice(LANG("obj.f97f81590c4a451d", list(src))))
		return
	COOLDOWN_START(src, bloodsucker_check_cooldown, cooldown_time)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = IS_BLOODSUCKER(target)
	// Are we a Bloodsucker | Are we on Masquerade. If one is true, they will fail.
	if(IS_BLOODSUCKER(target) && !HAS_TRAIT(target, TRAIT_MASQUERADE))
		if(bloodsuckerdatum.broke_masquerade)
			to_chat(user, span_warning(LANG("obj.ab8178ffc91a2ab7", list(target, bloodsuckerdatum.return_full_name()))))
			return
		to_chat(user, span_warning(LANG("obj.6e0080d91bb52fe2", list(target, bloodsuckerdatum.return_full_name(), bloodsuckerdatum.my_clan ? "is part of the [bloodsuckerdatum.my_clan]!" : "is not part of a clan."))))
		bloodsuckerdatum.break_masquerade()
	else
		to_chat(user, span_notice(LANG("obj.99105d0fb50f53f9", list(target))))

/obj/item/book/kindred/attack_self(mob/living/user)
	if(user.mind && !(HAS_TRAIT(user.mind, TRAIT_BLOODSUCKER_HUNTER) || IS_BLOODSUCKER(user)))
		to_chat(user, span_warning(LANG("obj.865ef58eb00a5d50", null)))
		user.set_eye_blur_if_lower(10 SECONDS)
		return
	ui_interact(user)

/obj/item/book/kindred/ui_interact(mob/living/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "KindredBook", name)
		ui.open()

/obj/item/book/kindred/ui_static_data(mob/user)
	var/data = list()

	for(var/datum/bloodsucker_clan/clans as anything in subtypesof(/datum/bloodsucker_clan))
		var/clan_data = list()
		clan_data["clan_name"] = initial(clans.name)
		clan_data["clan_desc"] = initial(clans.description)
		data["clans"] += list(clan_data)

	return data

/obj/structure/displaycase/curator
	desc = "This book was found inside a coffin of a long dead Curator. It is said to be able to reveal the true nature of those who feed upon mankind."
	start_showpiece_type = /obj/item/book/kindred
	req_access = list(ACCESS_LIBRARY)


/// just a typepath to specify that it's monkey-owned, used for the heart thief objective
/obj/item/organ/heart/monkey

/obj/item/organ/heart/examine_more(mob/user)
	. = ..()
	var/datum/antagonist/bloodsucker/vampire = IS_BLOODSUCKER(user)
	if(!vampire)
		return
	var/datum/objective/steal_n_of_type/heart_thief = locate() in vampire?.objectives
	if(!heart_thief)
		return
	if(heart_thief.check_if_valid_item(src))
		. += span_notice(LANG("obj.d89aaa8b4239089a", list(src.name)))
	else
		. += span_notice(LANG("obj.f179f561cb94bfc0", list(src.name)))
