// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/heretic_knowledge/emag_hand
	name = "The Blacksmith's Hammer"
	desc = "Sacrifice a set of wirecutters and a diamond to enhance your mansus grasp with the ability to cause malfunctiong (emagging) on right click for one use."
	gain_text = "The Blacksmith is the creator, but also the destroyer, the corruptor. Nothing knows machines and their intricacies as he does."
	required_atoms = list(
		/obj/item/wirecutters = 1,
		/obj/item/stack/sheet/mineral/diamond = 1,
	)
	drafting_tier = 1
	research_tree_icon_path = 'icons/obj/card.dmi'
	research_tree_icon_state = "emag"

/datum/heretic_knowledge/emag_hand/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	if (HAS_TRAIT(user, TRAIT_EMAGGING_HAND))
		user.balloon_alert(user, LANG("datum.438a3c05d12934de", null))
		return FALSE
	return TRUE

/datum/heretic_knowledge/emag_hand/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	ADD_TRAIT(user, TRAIT_EMAGGING_HAND, "emag_hand")
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK_SECONDARY, PROC_REF(emag_on_mansus_grasp_secondary))
	to_chat(user, span_warning(LANG("datum.de8826b9814f90d6", null)))
	return TRUE

/datum/heretic_knowledge/emag_hand/proc/emag_on_mansus_grasp_secondary(mob/living/source, atom/target)
	SIGNAL_HANDLER

	if (!target.emag_act(source))
		return

	REMOVE_TRAIT(source, TRAIT_EMAGGING_HAND, "emag_hand")
	UnregisterSignal(source, COMSIG_HERETIC_MANSUS_GRASP_ATTACK_SECONDARY)
	to_chat(source, span_warning(LANG("datum.4513cda76e08788f", list(target))))
