// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/organ/wings/moth
	name = "moth wings"
	desc = "A pair of fuzzy moth wings."
	flight_for_species = list(SPECIES_MOTH)
	///Our associated shadow jaunt spell, for all nightmares
	var/datum/action/cooldown/spell/touch/moth_climb/our_climb
	///Our associated terrorize spell, for antagonist nightmares
	var/datum/action/cooldown/spell/moth_and_dash/our_dash

/obj/item/organ/wings/moth/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()

	if(ismoth(organ_owner))
		our_climb = new(organ_owner)
		our_climb.Grant(organ_owner)

		our_dash = new(organ_owner)
		our_dash.Grant(organ_owner)

/obj/item/organ/wings/moth/on_mob_remove(mob/living/carbon/organ_owner)
	. = ..()
	QDEL_NULL(our_climb)
	QDEL_NULL(our_dash)

/datum/action/cooldown/spell/moth_and_dash
	name = "Flap Wings"
	desc = "Forces your wings to propel you forwards, though exhausting."
	button_icon = 'icons/mob/human/species/moth/moth_wings.dmi'
	button_icon_state = "m_moth_wings_gothic_BEHIND"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED|AB_CHECK_INCAPACITATED
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	antimagic_flags = NONE
	var/jumpdistance = 5 //-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpspeed = 3
	var/datum/weakref/dash_action_ref
	COOLDOWN_DECLARE(dash_cooldown)

/datum/action/cooldown/spell/moth_and_dash/Trigger(trigger_flags, action, atom/target)
	if(!..())
		return FALSE
	if (!isliving(owner))
		return

	var/turf/our_turf = get_turf(owner)
	var/datum/gas_mixture/environment = our_turf.return_air()

	if(environment.return_pressure() < (HAZARD_LOW_PRESSURE))
		to_chat(owner, span_warning(LANG("datum.a8e0a6a8ca35e8bb", null)))
		return

	if(owner.incapacitated)
		return

	if(!COOLDOWN_FINISHED(src, dash_cooldown))
		to_chat(owner, span_warning(LANG("datum.4e4b715772f4909e", null)))
		return

	var/atom/dash_target = get_edge_target_turf(owner, owner.dir) //gets the user's direction

	ADD_TRAIT(owner, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)
	if (owner.throw_at(dash_target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE, callback = TRAIT_CALLBACK_REMOVE(owner, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)))
		playsound(owner, 'sound/mobs/humanoids/moth/moth_flutter.ogg', 50, TRUE, TRUE)
		owner.visible_message(span_warning(LANG("datum.d2e165ec530b1f91", list(usr))))
		COOLDOWN_START(src, dash_cooldown, 6 SECONDS)
		var/mob/living/dash_user = owner
		if(istype(dash_user))
			dash_user.adjust_stamina_loss(40) //Given the risk of flying into things and crashing quite violently, you get four of these. Every one slows you down anyway.
	else
		to_chat(owner, span_warning(LANG("datum.9227c41df31765a4", null)))

/datum/emote/living/mothic_dash
	key = "mdash"
	key_third_person = "mothdash"
	cooldown = 6 SECONDS

/datum/emote/living/mothic_dash/run_emote(mob/living/user, params, type_override, intentional)
	if (ishuman(user) && intentional)
		var/datum/action/cooldown/spell/moth_and_dash/dash_action = locate() in user.actions
		if(dash_action)
			dash_action.Trigger()

	return ..()

/datum/action/cooldown/spell/touch/moth_climb
	name = "Lift Wings"
	desc = "Spreads your wings out to facilitate climbing, though this will be extremely tiring."
	button_icon = 'icons/mob/human/species/moth/moth_wings.dmi'
	button_icon_state = "m_moth_wings_monarch_BEHIND"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED|AB_CHECK_INCAPACITATED
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	antimagic_flags = NONE

	hand_path = /obj/item/climbing_hook/climbing_moth_wings
	draw_message = span_notice("You outstretch your wings, ready to climb upwards.")
	drop_message = span_notice("Your wings tuck back behind you.")

/obj/item/climbing_hook/climbing_moth_wings
	name = "outstretched wings"
	desc = "Useful for climbing up onto high places, though tiresome."
	icon = 'icons/mob/human/species/moth/moth_wings.dmi'
	icon_state = "m_moth_wings_monarch_BEHIND"
	climb_time = 2.5 SECONDS
	force = 0
	throwforce = 0
	climbsound = 'sound/mobs/humanoids/moth/moth_flutter.ogg'

/obj/item/climbing_hook/climbing_moth_wings/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/turf/check_turf = get_turf(user)
	var/datum/gas_mixture/environment = check_turf.return_air()
	if(environment.return_pressure() < (HAZARD_LOW_PRESSURE))
		to_chat(user, span_warning(LANG("obj.a8e0a6a8ca35e8bb", null)))
		return ITEM_INTERACT_BLOCKING
	. = ..()
	qdel(src)
