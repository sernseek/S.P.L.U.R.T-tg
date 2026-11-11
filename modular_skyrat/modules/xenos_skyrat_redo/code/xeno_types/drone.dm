// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// SKYRAT MODULE SKYRAT_XENO_REDO

/mob/living/carbon/alien/adult/skyrat/drone
	name = "alien drone"
	desc = "As plain looking as you could call an alien with armored black chitin and large claws."
	caste = "drone"
	maxHealth = 200
	health = 200
	icon_state = "aliendrone"
	melee_damage_lower = 15
	melee_damage_upper = 20
	next_evolution = /mob/living/carbon/alien/adult/skyrat/praetorian
	default_organ_types_by_slot = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/alien,
		ORGAN_SLOT_XENO_HIVENODE = /obj/item/organ/alien/hivenode,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/alien,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/alien,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/alien,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/alien,
		ORGAN_SLOT_XENO_PLASMAVESSEL = /obj/item/organ/alien/plasmavessel/large,
		ORGAN_SLOT_XENO_RESINSPINNER = /obj/item/organ/alien/resinspinner,
		ORGAN_SLOT_XENO_ACIDGLAND = /obj/item/organ/alien/acid,
	)

/mob/living/carbon/alien/adult/skyrat/drone/Initialize(mapload)
	. = ..()
	GRANT_ACTION(/datum/action/cooldown/alien/skyrat/heal_aura)

/datum/action/cooldown/alien/skyrat/heal_aura
	name = "Healing Aura"
	desc = "Friendly xenomorphs in a short range around yourself will receive passive healing."
	button_icon_state = "healaura"
	plasma_cost = 100
	cooldown_time = 90 SECONDS
	/// Is the healing aura currently active or not
	var/aura_active = FALSE
	/// How long the healing aura should last
	var/aura_duration = 30 SECONDS
	/// How far away the healing aura should reach
	var/aura_range = 5
	/// How much brute/burn individually the healing aura should heal each time it fires
	var/aura_healing_amount = 5
	/// What color should the + particles caused by the healing aura be
	var/aura_healing_color = COLOR_BLUE_LIGHT
	/// The healing aura component itself that the ability uses
	var/datum/component/aura_healing/aura_healing_component

/datum/action/cooldown/alien/skyrat/heal_aura/Activate()
	. = ..()
	if(aura_active)
		owner.balloon_alert(owner, LANG("datum.aadb480b2b261fbf", null))
		return FALSE
	owner.balloon_alert(owner, LANG("datum.e81b0d623dabc53e", null))
	to_chat(owner, span_danger(LANG("datum.95bce89709c1d36c", list(aura_duration / 10))))
	addtimer(CALLBACK(src, PROC_REF(aura_deactivate)), aura_duration)
	aura_active = TRUE
	aura_healing_component = owner.AddComponent(/datum/component/aura_healing, range = aura_range, requires_visibility = TRUE, brute_heal = aura_healing_amount, burn_heal = aura_healing_amount, limit_to_trait = TRAIT_XENO_HEAL_AURA, healing_color = aura_healing_color)
	return TRUE

/datum/action/cooldown/alien/skyrat/heal_aura/proc/aura_deactivate()
	if(!aura_active)
		return
	aura_active = FALSE
	QDEL_NULL(aura_healing_component)
	owner.balloon_alert(owner, LANG("datum.285ca5e8149dccfd", null))
