// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define POWERLESS_DURATION 10 MINUTES

// prevents the sm from generating power for x time - maybe a longer term effect too
/datum/objective/heretic_wildcard/supermatter
	name = "drain supermatter"
	explanation_text = "Perform the Reclaim Light ritual on the station's supermatter engine."
	knowledge_to_gain = list(/datum/heretic_knowledge/supermatter_ritual)
	finish_text = "The Watchwoman grants you her boon for the reclamation of the Light. You find your mind expanding..."
	max_progress = 1
	knowledge_per_progress = 2

/datum/heretic_knowledge/supermatter_ritual
	name = "Reclaim Light"
	desc = "Perform this ritual in the SM chamber to complete your tertiary objective, obtain knowledge points, and neuter the supermatter for 10 minutes. \
	Can only be performed once, and is a lengthy ritual."
	unreachable = TRUE
	required_atoms = list()
	research_tree_icon_path = 'icons/obj/machines/engine/supermatter.dmi'
	research_tree_icon_state = "sm"

/datum/heretic_knowledge/supermatter_ritual/can_be_invoked(datum/antagonist/heretic/invoker)
	return invoker?.wildcard_obj?.is_finished() == FALSE

/datum/heretic_knowledge/supermatter_ritual/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	for (var/obj/machinery/power/supermatter_crystal/iter_crys in range(1, loc))
		return TRUE
	to_chat(user, span_warning(LANG("datum.5d9b0c1ce4b7d84f", null)))
	return FALSE

/datum/heretic_knowledge/supermatter_ritual/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()

	var/datum/antagonist/heretic/our_heretic = GET_HERETIC(user)
	if (isnull(our_heretic))
		stack_trace("Somehow got no heretic on a SM ritual. [user]")
		return FALSE

	var/obj/machinery/power/supermatter_crystal/crys
	for (var/obj/machinery/power/supermatter_crystal/iter_crys in range(1, loc))
		crys = iter_crys
		break

	if (isnull(crys))
		return FALSE

	to_chat(user, span_warning(LANG("datum.0645c51c7593fc52", null)))
	if (!do_after(user, 20 SECONDS, crys, IGNORE_HELD_ITEM))
		to_chat(user, span_boldwarning(LANG("datum.333227f962e7fcb3", null)))
		return FALSE

	crys.cursed = TRUE
	crys.update_appearance(UPDATE_OVERLAYS)
	addtimer(CALLBACK(crys, TYPE_PROC_REF(/obj/machinery/power/supermatter_crystal, clear_curse)), POWERLESS_DURATION)

	priority_announce(
		LANG("datum.14dca34c1c16e537", list(POWERLESS_DURATION / 10)),
		"CentCom Thaumatergy Monitor",
		'sound/machines/engine_alert/engine_alert3.ogg'
	)

	our_heretic.wildcard_obj?.increment_progress(our_heretic, crys)

/obj/machinery/power/supermatter_crystal
	/// If TRUE, 30% of the crystal's energy will be drained every tick. Used by a heretic ritual.
	var/cursed = FALSE

/obj/machinery/power/supermatter_crystal/proc/clear_curse()
	if (cursed)
		priority_announce("The thaumatergic anomaly has dissipated, crystal output readings have normalized.", "Anomaly Cleared")

	cursed = FALSE
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/power/supermatter_crystal/update_overlays()
	. = ..()

	if (cursed)
		. += mutable_appearance('icons/mob/effects/heretic_aura.dmi', "heretic_aura")

/obj/machinery/power/supermatter_crystal/examine(mob/user)
	. = ..()

	if (cursed)
		. += span_boldwarning(LANG("obj.d061058f750a015a", null))

#undef POWERLESS_DURATION
