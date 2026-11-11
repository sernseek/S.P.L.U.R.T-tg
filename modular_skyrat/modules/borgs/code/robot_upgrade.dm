// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// Use this file to add UPGRADES to borgs, the standard items will go in the modular robot_items.dm

/*
*	ADVANCED MEDICAL CYBORG UPGRADES
*/

/// Advanced Surgery Tools
/obj/item/borg/upgrade/surgerytools
	name = "medical cyborg advanced surgery tools"
	desc = "An upgrade to the Medical model cyborg's surgery loadout, replacing non-advanced tools with their advanced counterpart."
	icon_state = "module_medical"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical)
	model_flags = BORG_MODEL_MEDICAL
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT,
	)

	items_to_add = list(/obj/item/scalpel/advanced,
						/obj/item/retractor/advanced,
						/obj/item/cautery/advanced,
						/obj/item/blood_filter/advanced,
						/obj/item/healthanalyzer/advanced,
						)
	items_to_remove = list(
						/obj/item/borg/cyborg_omnitool/medical,
						/obj/item/borg/cyborg_omnitool/medical, // Twice because you get two
						/obj/item/blood_filter,
						/obj/item/healthanalyzer,
						)

/*
*	ADVANCED ENGINEERING CYBORG UPGRADES
*/

/// Advanced Materials
#define ENGINEERING_CYBORG_CHARGE_PER_STACK 1000

/datum/robot_energy_storage/plasteel
	name = "Plasteel Processor"
	recharge_rate = 0
	max_energy = ENGINEERING_CYBORG_CHARGE_PER_STACK * 50

/datum/robot_energy_storage/titanium
	name = "Titanium Processor"
	recharge_rate = 0
	max_energy = ENGINEERING_CYBORG_CHARGE_PER_STACK * 50

/obj/item/stack/sheet/plasteel/cyborg
	cost = ENGINEERING_CYBORG_CHARGE_PER_STACK
	is_cyborg = TRUE
	source = /datum/robot_energy_storage/plasteel
	custom_materials = list(
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/iron=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/uranium=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT * 3,
	)

/obj/item/stack/sheet/titaniumglass/cyborg
	cost = ENGINEERING_CYBORG_CHARGE_PER_STACK
	is_cyborg = TRUE
	source = /datum/robot_energy_storage/titanium

#undef ENGINEERING_CYBORG_CHARGE_PER_STACK

/obj/item/borg/upgrade/advanced_materials
	name = "engineering advanced materials processor"
	desc = "allows a cyborg to synthesize and store advanced materials"
	icon_state = "module_engineer"
	model_type = list(/obj/item/robot_model/engineering)
	model_flags = BORG_MODEL_ENGINEERING
	custom_materials = list(
		/datum/material/titanium=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/iron=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/uranium=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass=SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plasma=SHEET_MATERIAL_AMOUNT * 3,
	)

	items_to_add = list(/obj/item/stack/sheet/plasteel/cyborg,
						/obj/item/stack/sheet/titaniumglass/cyborg,
						)

/obj/item/borg/upgrade/advanced_materials/deactivate(mob/living/silicon/robot/borg, mob/living/user)
	. = ..()
	for(var/datum/robot_energy_storage/plasteel/plasteel_energy in borg.model.storages)
		qdel(plasteel_energy)
	for(var/datum/robot_energy_storage/titanium/titanium_energy in borg.model.storages)
		qdel(titanium_energy)

/*
*	ADVANCED MINING CYBORG UPGRADES
*/

/// Welder
/obj/item/borg/upgrade/welder
	name = "mining cyborg welder upgrade"
	desc = "A normal welder with a larger tank for cyborgs."
	icon_state = "module_miner"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/miner)
	model_flags = BORG_MODEL_MINER
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 1,
	)

	items_to_add = list(/obj/item/weldingtool/largetank/cyborg)

/*
*	ADVANCED CARGO CYBORG UPGRADES
*/
/datum/design/borg_upgrade_clamp
	name = "Improved Integrated Hydraulic Clamp Module"
	id = "borg_upgrade_clamp"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/better_clamp
	materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO,
	)

/obj/item/borg/upgrade/better_clamp
	name = "improved integrated hydraulic clamp"
	desc = "An improved hydraulic clamp to allow for bigger packages to be picked up as well!"
	icon = 'modular_skyrat/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_cargo"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/cargo)
	model_flags = BORG_MODEL_CARGO
	custom_materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
	)

	items_to_add = list(/obj/item/borg/hydraulic_clamp/better)

/datum/design/borg_upgrade_cargo_tele
	name = "Cargo teleporter module"
	id = "borg_upgrade_cargo_tele"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/cargo_tele
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/plastic = SMALL_MATERIAL_AMOUNT * 5, /datum/material/uranium = SMALL_MATERIAL_AMOUNT * 5)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO
	)

/obj/item/borg/upgrade/cargo_tele
	name = "cargo teleporter module"
	desc = "Allows you to upgrade a cargo cyborg with the cargo teleporter"
	icon = 'modular_skyrat/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_cargo"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/cargo)
	model_flags = BORG_MODEL_CARGO
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/plastic = SMALL_MATERIAL_AMOUNT * 5, /datum/material/uranium = SMALL_MATERIAL_AMOUNT * 5)

	items_to_add = list(/obj/item/cargo_teleporter)

/datum/design/borg_upgrade_forging
	name = "Forging module"
	id = "borg_upgrade_forging"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/forging
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/uranium = SMALL_MATERIAL_AMOUNT * 5)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO
	)

/obj/item/borg/upgrade/forging
	name = "cyborg forging module"
	desc = "Allows you to upgrade a cargo cyborg with forging gear"
	icon = 'modular_skyrat/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_cargo"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/cargo)
	model_flags = BORG_MODEL_CARGO
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/uranium = SMALL_MATERIAL_AMOUNT * 5)

	items_to_add = list(/obj/item/forging/hammer,
						/obj/item/forging/billow,
						/obj/item/forging/tongs,
						/obj/item/borg/forging_setup,
						)

/*
* SERVICE CYBORG UPGRADES
*/

/datum/design/borg_upgrade_artistic
	name = "Artistic module"
	id = "borg_upgrade_artistic"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/artistic
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2,
					/datum/material/glass = SMALL_MATERIAL_AMOUNT * 2)
	construction_time = 10 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SERVICE
	)

/obj/item/borg/upgrade/artistic
	name = "borg artistic module"
	desc = "Allows you to upgrade a cyborg with tools for creating art."
	icon_state = "module_general"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2)
	items_to_add = list(
			/obj/item/pen,
			/obj/item/toy/crayon/spraycan/borg,
			/obj/item/instrument/guitar,
			/obj/item/instrument/piano_synth,
			/obj/item/stack/pipe_cleaner_coil/cyborg,
			/obj/item/chisel,
			)

/*
*	UNIVERSAL CYBORG UPGRADES
*/

/// ShapeShifter
/obj/item/borg/upgrade/borg_shapeshifter
	name = "cyborg shapeshifter module"
	desc = "An experimental device which allows a cyborg to disguise themself into another type of cyborg."
	icon_state = "module_general"
	custom_materials = list(
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2,
	)

	items_to_add = list(/obj/item/borg_shapeshifter)

/// Quadborg time
/obj/item/borg/upgrade/affectionmodule
	name = "borg affection module"
	desc = "A module that upgrades the ability of borgs to display affection."
	icon_state = "module_peace"

	items_to_add = list(/obj/item/quadborg_tongue,
						/obj/item/quadborg_nose)
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/quadborg_tongue/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/mob/living/silicon/robot/borg = user
	var/mob/living/mob = interacting_with
	if(!istype(mob))
		return ITEM_INTERACT_BLOCKING
	if(HAS_TRAIT(interacting_with, TRAIT_AFFECTION_AVERSION)) // Checks for Affection Aversion trait
		to_chat(user, span_warning(LANG("obj.d3e97a9e657f2bdf", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING
	if(check_zone(borg.zone_selected) == "head")
		borg.visible_message(span_warning(LANG("obj.22e854db74824fe7", list(borg, mob))), span_notice(LANG("obj.07757fa27ae5c807", list(mob))))
	else
		borg.visible_message(span_warning(LANG("obj.2494f9fd4d69745d", list(borg, mob))), span_notice(LANG("obj.2d2621f96ecbc845", list(mob))))
	playsound(borg, 'sound/effects/blob/attackblob.ogg', 50, 1)
	return ITEM_INTERACT_SUCCESS

/obj/item/quadborg_nose/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(HAS_TRAIT(interacting_with, TRAIT_AFFECTION_AVERSION)) // Checks for Affection Aversion trait
		to_chat(user, span_warning(LANG("obj.6f4e619cb0499679", list(interacting_with))))
		return ITEM_INTERACT_BLOCKING

	do_attack_animation(interacting_with, null, src)
	user.visible_message(span_notice(LANG("obj.a4ccf845338f5b03", list(user, pick("nuzzles", "pushes", "boops"), interacting_with.name))))
	return ITEM_INTERACT_SUCCESS

/// The Shrinkening
/mob/living/silicon/robot
	var/hasShrunk = FALSE

// Added checks for borg models who come from the Zoolander Center for Borgs Who Can't Upgrade Good
/obj/item/borg/upgrade/expand/action(mob/living/silicon/robot/borg, mob/living/user = usr)
	if(TRAIT_R_EXPANDER_BLOCKED in borg.model.model_features)
		to_chat(usr, span_warning(LANG("obj.396e90828d9baffd", null)))
		return FALSE

	if(borg.model.type == /obj/item/robot_model)
		to_chat(usr, span_warning(LANG("obj.90bae6cefd102396", null)))
		return FALSE

	return ..()

/obj/item/borg/upgrade/shrink
	name = "borg shrinker"
	desc = "A cyborg resizer, it makes a cyborg small."
	icon_state = "module_general"
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 4,
	)

/obj/item/borg/upgrade/shrink/action(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(!. || HAS_TRAIT(borg, TRAIT_NO_TRANSFORM))
		return FALSE

	if(borg.model.type == /obj/item/robot_model)
		to_chat(usr, span_warning(LANG("obj.90bae6cefd102396", null)))
		return FALSE

	if(borg.hasShrunk)
		to_chat(usr, span_warning(LANG("obj.cd8c9ce8be7848e7", null)))
		return FALSE

	if(TRAIT_R_SMALL in borg.model.model_features)
		to_chat(usr, span_warning(LANG("obj.81a5b808764cd3a6", null)))
		return FALSE

	ADD_TRAIT(borg, TRAIT_NO_TRANSFORM, REF(src))
	var/prev_lockcharge = borg.lockcharge
	borg.SetLockdown(TRUE)
	borg.set_anchored(TRUE)
	do_smoke(4, src, loc, smoke_type = /datum/effect_system/fluid_spread/smoke)
	sleep(0.2 SECONDS)
	for(var/i in 1 to 4)
		playsound(borg, pick(
			'sound/items/tools/drill_use.ogg',
			'sound/items/tools/jaws_cut.ogg',
			'sound/items/tools/jaws_pry.ogg',
			'sound/items/tools/welder.ogg',
			'sound/items/tools/ratchet.ogg',
			), 80, TRUE, -1)
		sleep(1.2 SECONDS)
	if(!prev_lockcharge)
		borg.SetLockdown(FALSE)
	borg.set_anchored(FALSE)
	REMOVE_TRAIT(borg, TRAIT_NO_TRANSFORM, REF(src))
	borg.hasShrunk = TRUE
	borg.update_transform(0.75)

/obj/item/borg/upgrade/shrink/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if (.)
		if (borg.hasShrunk)
			borg.hasShrunk = FALSE
			borg.update_transform(4/3)

/// Syndijack
/obj/item/borg/upgrade/transform/syndicatejack
	name = "borg module picker (Syndicate)"
	desc = "Allows you to to turn a cyborg into a experimental syndicate cyborg."
	icon_state = "module_illegal"
	new_model = /obj/item/robot_model/syndicatejack

/obj/item/borg/upgrade/transform/syndicatejack/action(mob/living/silicon/robot/cyborg, user = usr) // Only usable on emagged cyborgs. In exchange. makes you unable to get locked down or detonated.
	if(cyborg.emagged)
		return ..()

/// Dominatrix time
/obj/item/borg/upgrade/dominatrixmodule
	name = "borg dominatrix module"
	desc = "A module that greatly upgrades the ability of borgs to display affection."
	icon = 'modular_skyrat/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_lust"
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	custom_price = 0

	items_to_add = list(/obj/item/kinky_shocker,
						/obj/item/clothing/mask/leatherwhip,
						/obj/item/spanking_pad,
						/obj/item/tickle_feather,
						/obj/item/clothing/erp_leash,
						/obj/item/clicker
						)

/// Cyborgs are bad at dancing too
/obj/item/borg/upgrade/waddle_module
	name = "borg waddle module"
	desc = "A module that puts a little spring in each borg's step"
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)

/obj/item/borg/upgrade/waddle_module/action(mob/living/silicon/robot/borg, mob/living/user)
	. = ..()
	if(.)
		borg.add_quirk(/datum/quirk/waddle)

/obj/item/borg/upgrade/waddle_module/deactivate(mob/living/silicon/robot/borg, mob/living/user)
	. = ..()
	if(.)
		borg.remove_quirk(/datum/quirk/waddle)
