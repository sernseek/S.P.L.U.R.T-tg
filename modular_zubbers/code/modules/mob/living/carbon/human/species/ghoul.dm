// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/species/ghoul
	name = "\improper Ghoul"
	id = SPECIES_GHOUL
	examine_limb_id = SPECIES_GHOUL
	can_have_genitals = FALSE
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_RADIMMUNE,
		TRAIT_CAN_STRIP,
		TRAIT_EASYDISMEMBER,
		TRAIT_EASILY_WOUNDED,
		TRAIT_LITERATE,
		TRAIT_FIXED_MUTANT_COLORS,
	)

	payday_modifier = 1.0
	stunmod = 1.25
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	mutanttongue = /obj/item/organ/tongue/ghoul
	fixed_mut_color = "#FFFFFF"

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant/ghoul,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant/ghoul,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant/ghoul,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant/ghoul,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant/ghoul,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant/ghoul,
	)

	bodytemp_normal = T20C

	// The chest and head cannot be turned into meat.
	// Also, the head needs to be normal for hair to work.

	/// Body parts that the ghoul can pull off or have reattached.
	var/static/list/swappable_parts = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

/datum/species/ghoul/get_species_description()
	return list(placeholder_description,)

/datum/species/ghoul/on_species_gain(mob/living/carbon/new_ghoul, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()

	if(ishuman(new_ghoul))
		var/mob/living/carbon/human/human_ghoul = new_ghoul

		RegisterSignal(human_ghoul, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(attach_meat))
		human_ghoul.part_default_head = /obj/item/bodypart/head/mutant/ghoul
		human_ghoul.part_default_chest = /obj/item/bodypart/chest/mutant/ghoul
		human_ghoul.part_default_l_arm = /obj/item/bodypart/arm/left/mutant/ghoul
		human_ghoul.part_default_r_arm = /obj/item/bodypart/arm/right/mutant/ghoul
		human_ghoul.part_default_l_leg = /obj/item/bodypart/leg/left/mutant/ghoul
		human_ghoul.part_default_r_leg = /obj/item/bodypart/leg/right/mutant/ghoul

/datum/species/ghoul/on_species_loss(mob/living/carbon/human/former_ghoul, datum/species/new_species, pref_load)
	. = ..()

	UnregisterSignal(former_ghoul, COMSIG_ATOM_ITEM_INTERACTION)
	former_ghoul.part_default_head = /obj/item/bodypart/head
	former_ghoul.part_default_chest = /obj/item/bodypart/chest
	former_ghoul.part_default_l_arm = /obj/item/bodypart/arm/left
	former_ghoul.part_default_r_arm = /obj/item/bodypart/arm/right
	former_ghoul.part_default_l_leg = /obj/item/bodypart/leg/left
	former_ghoul.part_default_r_leg = /obj/item/bodypart/leg/right

/*
* ATTACK PROCS
*/

/datum/species/ghoul/disarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if (user != target)
		return ..()

	var/target_zone = user.zone_selected
	var/obj/item/bodypart/affecting = user.get_bodypart(check_zone(user.zone_selected)) //stabbing yourself always hits the right target

	if (!(target_zone in swappable_parts) || !affecting)
		return ..()

	if (user.handcuffed)
		to_chat(user, span_alert(LANG("datum.ac619cad1cefbd49", null)))
		return FALSE

	// Robotic limbs cannot be detatched this way.
	if (!IS_ORGANIC_LIMB(affecting))
		to_chat(user, LANG("datum.f64eacb9d2a0ffab", null))
		return FALSE

	user.visible_message(LANG("datum.5f800618f1300c64", list(user, p_their(), affecting.name)), span_notice(LANG("datum.b7e14cd9775bd44f", list(affecting.name))))
	if (!do_after(user, 3 SECONDS, target))
		return FALSE

	user.visible_message(LANG("datum.9550d59999df9690", list(user, affecting.name)), span_notice(LANG("datum.0c8a4ff0c5c24ae3", list(affecting.name))))
	playsound(get_turf(user), 'sound/effects/meatslap.ogg', 40, 1)

	var/obj/item/I = affecting.drop_limb()
	if (istype(I, /obj/item/food/meat/slab))
		user.put_in_hands(I)

	new /obj/effect/temp_visual/dir_setting/bloodsplatter(target.loc, target.dir)
	target.add_splatter_floor(target.loc)
	target.bleed(60)

	return TRUE

/datum/species/ghoul/proc/attach_meat(mob/living/carbon/human/target, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER

	if(!istype(target))
		return NONE

	// Meat can be used as a suitable limb replacement.
	if(target.stat == DEAD || !istype(tool, /obj/item/food/meat/slab))
		return NONE

	var/target_zone = user.zone_selected
	if(target.get_bodypart(target_zone))
		return NONE

	if(!(target_zone in swappable_parts))
		return NONE

	user.visible_message(LANG("datum.a00150e51d0c9bc4", list(user, tool, target)), span_notice(LANG("datum.a7d6a4cadc2240ec", list(tool, target == user ? "your" : "[target]'s"))))

	ASYNC
		if(do_after(user, 3 SECONDS, target))
			var/obj/item/bodypart/new_limb = target.newBodyPart(target_zone, FALSE)
			target.visible_message(LANG("datum.436af93d600b1a01", list(target, new_limb.name)), span_notice(LANG("datum.997dc0b98a24bc09", list(new_limb.name))))
			new_limb.try_attach_limb(target)
			qdel(tool)
			playsound(get_turf(target), 'sound/effects/meatslap.ogg', 50, 1)

	return ITEM_INTERACT_SUCCESS

/mob/living/carbon
	var/obj/item/bodypart/head/part_default_head = /obj/item/bodypart/head
	var/obj/item/bodypart/chest/part_default_chest = /obj/item/bodypart/chest
	var/obj/item/bodypart/arm/left/part_default_l_arm = /obj/item/bodypart/arm/left
	var/obj/item/bodypart/arm/right/part_default_r_arm = /obj/item/bodypart/arm/right
	var/obj/item/bodypart/leg/left/part_default_l_leg = /obj/item/bodypart/leg/left
	var/obj/item/bodypart/leg/right/part_default_r_leg = /obj/item/bodypart/leg/right

/datum/species/ghoul/get_species_lore()
	return list(placeholder_lore)

/datum/species/ghoul/prepare_human_for_preview(mob/living/carbon/human/human)
	regenerate_organs(human, src, visual_only = TRUE)
	human.update_body(TRUE)
