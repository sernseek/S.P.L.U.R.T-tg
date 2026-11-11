// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define BLOODMAG_USE_COST (BLOOD_VOLUME_NORMAL * 0.10) // 10% of standard blood
#define BLOODMAG_USE_COST_FAKE (BLOOD_VOLUME_NORMAL * 0.01) // 1% of standard blood
#define BLOODMAG_CD_TIME 3 SECONDS

//
// Bloodfledge exclusive emag
//
/obj/item/card/emag/bloodfledge
	name = "hemorrhagic sanguinizer"
	desc = "A card with a blood seal attached to some circuitry. Requires special training to use properly."
	icon = 'modular_zzplurt/icons/obj/card.dmi'
	icon_state = "bloodmag"
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.66,
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 2.9,
	)
	// List of allowed types - Unused!
	//var/type_whitelist

	// Can this actually emag things?
	var/unlocked = FALSE

	// Cooldown between uses
	COOLDOWN_DECLARE(bloodmag_cooldown)

// On creation
// Unused feature: type whitelist
/*
/obj/item/card/emag/bloodfledge/Initialize(mapload)
	. = ..()

	// List of object types this emag can affect
	type_whitelist = list(
		typesof(/obj/machinery/chem_dispenser), // Unlocks more reagents
		typesof(/obj/structure/bodycontainer/morgue), // Changes status light
	)
*/

// Emag the bloodmag
/obj/item/card/emag/bloodfledge/emag_act(mob/user, obj/item/card/emag/emag_card)
	// Check if valid
	if(isnull(user) || !istype(emag_card))
		return FALSE

	// Check if already unlocked
	if(unlocked)
		// Alert user and return
		balloon_alert(user, LANG("obj.7d09f139044f50ff", null))
		return FALSE

	// Unlock full functionality
	unlocked = TRUE

	// Alert user
	balloon_alert(user, LANG("obj.6f18f822965ee7e8", null))

	// Alert in chat with reduced range
	user.visible_message(\
		span_notice(LANG("obj.e854de070d2e6797", list(user, emag_card, src))),\
		span_notice(LANG("obj.078ac60ad39a9fb9", list(emag_card, src))),\
		vision_distance = COMBAT_MESSAGE_RANGE
	)

	// Log interaction
	log_combat(user, src, "has upgraded")

// Examine text
/obj/item/card/emag/bloodfledge/examine(mob/user)
	. = ..()

	// Check for bloodfledge
	if(HAS_TRAIT(user, TRAIT_BLOODFLEDGE))
		// Check if unlocked
		if(unlocked)
			// Add unlocked text
			. += span_notice(LANG("obj.1d62998a3e871ac2", null))

		// Item is not unlocked
		else
			// Add fake usage text
			. += span_notice(LANG("obj.79a589becf70b5b8", null))

// Can use check
/obj/item/card/emag/bloodfledge/can_emag(atom/target, mob/user)
	. = ..()

	// Check parent return
	if(!.)
		return FALSE

	// Check for bloodfledge
	if(!HAS_TRAIT(user, TRAIT_BLOODFLEDGE))
		// Warn user and return
		to_chat(user, span_warning(LANG("obj.d455bafb7f7a692c", list(src))))
		return FALSE

	// Check for bloodless
	if(HAS_TRAIT(user, TRAIT_NOBLOOD))
		// Warn user and return
		to_chat(user, span_warning(LANG("obj.dec2251c4806ba9d", list(src))))
		return FALSE

	// Check cooldown
	if(!COOLDOWN_FINISHED(src, bloodmag_cooldown))
		// Warn user and return
		balloon_alert(user, LANG("obj.26defd6f9b56ea97", null))
		return FALSE

	// Check for unlocked state
	if(!unlocked)
		// Give false alerts
		user.visible_message(span_danger(LANG("obj.8a814f0324491944", list(user, target, user.p_their(), src, target))), span_warning(LANG("obj.1083f87d5bc2de57", list(target, target))))
		balloon_alert(user, LANG("obj.eeb2cb364a88f225", null))

		// Start cooldown to prevent spam
		COOLDOWN_START(src, bloodmag_cooldown, BLOODMAG_CD_TIME)

		// Apply color named "Sanguine"
		//target.add_atom_colour("#6D0C0D", WASHABLE_COLOUR_PRIORITY)

		// Define carbon holder
		var/mob/living/carbon/item_mob = user

		// Check if holder exists
		if(item_mob)
			// Cause user to bleed
			item_mob.bleed(BLOODMAG_USE_COST_FAKE)

			// Apply blood to the target
			target.add_mob_blood(item_mob)

		// Return failure
		return FALSE

	// Allow use
	return TRUE

	// Unused feature: type whitelist
	/*
	// Check for compatible object type
	for (var/list/subtypelist in type_whitelist)
		if (target.type in subtypelist)
			return TRUE

	// Interaction is not valid
	// Warn user and return
	balloon_alert(user, "incompatible target!")
	return FALSE
	*/

// Trigger on using
/obj/item/card/emag/bloodfledge/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()

	// Check if successful
	if(. != ITEM_INTERACT_SUCCESS)
		// Do nothing
		return

	// Start cooldown
	COOLDOWN_START(src, bloodmag_cooldown, BLOODMAG_CD_TIME)

	// Define carbon holder
	var/mob/living/carbon/item_mob = user

	// Check if holder exists
	if(item_mob)
		// Cause target to bleed
		item_mob.bleed(BLOODMAG_USE_COST)

		// Apply blood to the target
		interacting_with.add_mob_blood(item_mob)

		// Warn user
		to_chat(user, span_boldwarning(LANG("obj.c4f135cb47962e34", list(src))))

// Suicide action
/obj/item/card/emag/bloodfledge/suicide_act(mob/living/carbon/user)
	// Alert in chat
	user.visible_message(span_suicide(LANG("obj.03211443525f904f", list(user, src))))

	// Gib the user
	user.gib(DROP_ALL_REMAINS)

	// Check if unlocked
	if(unlocked)
		// Explode
		explosion(src, light_impact_range = 1, explosion_cause = src)

		// Delete item
		qdel(src)

	// Return success
	return MANUAL_SUICIDE

#undef BLOODMAG_USE_COST
#undef BLOODMAG_USE_COST_FAKE
#undef BLOODMAG_CD_TIME
