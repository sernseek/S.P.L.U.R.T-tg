// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/weldingtool/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!status && interacting_with.is_refillable())
		reagents.trans_to(interacting_with, reagents.total_volume, transferred_by = user)
		to_chat(user, span_notice(LANG("obj.0dbc49ea6c308c76", list(src, interacting_with))))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	if(!ishuman(interacting_with))
		return NONE
	if(user.combat_mode)
		return NONE

	return try_heal(interacting_with, user)

/obj/item/weldingtool/proc/try_heal(atom/interacting_with, mob/living/user)
	var/mob/living/carbon/carbon_patient = interacting_with
	var/obj/item/bodypart/preferred_limb = carbon_patient.get_bodypart(check_zone(user.zone_selected))
	if(isnull(preferred_limb) || !IS_ROBOTIC_LIMB(preferred_limb))
		return NONE
	if(!(preferred_limb.brute_dam > 0))
		balloon_alert(user, LANG("obj.aca69bd8ad34eb10", null))
		return ITEM_INTERACT_BLOCKING
	var/list/damaged_limbs = list()
	for(var/obj/item/bodypart/limb as anything in carbon_patient.bodyparts)
		if(isnull(limb) || !IS_ROBOTIC_LIMB(limb) || !(limb.brute_dam > 0))
			continue
		damaged_limbs += limb
	return try_auto_heal(interacting_with, user, damaged_limbs, preferred_limb)

/obj/item/weldingtool/proc/try_auto_heal(atom/interacting_with, mob/living/user, list/damaged_limbs, preferred_limb)
	var/mob/living/carbon/human/attacked_humanoid = interacting_with
	var/obj/item/bodypart/repaired = (preferred_limb in damaged_limbs) ? preferred_limb : damaged_limbs[1]
	if(!(repaired.brute_dam > 0))
		var/list/updated_damaged_limbs = damaged_limbs
		updated_damaged_limbs.Remove(repaired)
		if(!length(damaged_limbs))
			user.balloon_alert(user, LANG("obj.e1212a63fd027dd4", null))
			return ITEM_INTERACT_SUCCESS
		user.balloon_alert(user, LANG("obj.cb8f1b84c12d115a", list(updated_damaged_limbs[1])))
		INVOKE_ASYNC(src, PROC_REF(try_auto_heal), interacting_with, user, updated_damaged_limbs, preferred_limb)
		return

	user.visible_message(span_notice(LANG("obj.102599de4328c6cc", list(user, attacked_humanoid == user ? user.p_their() : "[attacked_humanoid]'s", repaired.name))),
		span_notice(LANG("obj.d9ca7e1b8b4542ea", list(attacked_humanoid == user ? "your" : "[attacked_humanoid]'s", repaired.name))))
	var/use_delay = 1 SECONDS
	if(user == attacked_humanoid)
		use_delay = 5 SECONDS

	if(!use_tool(attacked_humanoid, user, use_delay, volume=50, amount=1))
		return ITEM_INTERACT_BLOCKING

	repaired.heal_damage(brute = 15, burn = 0, required_bodytype = BODYTYPE_ROBOTIC)
	user.visible_message(span_notice(LANG("obj.86960026de3ed0f9", list(user, attacked_humanoid, repaired.name))), \
		span_notice(LANG("obj.f43dceda0a2ff8ed", list(attacked_humanoid == user ? "your" : "[attacked_humanoid]'s", repaired.name))))

	INVOKE_ASYNC(src, PROC_REF(try_auto_heal), interacting_with, user, damaged_limbs, preferred_limb)
	return ITEM_INTERACT_SUCCESS

/obj/item/weldingtool/experimental/bluespace
	name = "bluespace welder"
	desc = "The welding tool that you shouldn't have. Power of the (bluespace) sun, right on your hip."
	icon = 'modular_zubbers/icons/obj/tools.dmi'
	icon_state = "bst_welder"
	lefthand_file = 'modular_zubbers/icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'modular_zubbers/icons/mob/inhands/equipment/tools_righthand.dmi'
	inhand_icon_state = "bst_welder"
	inside_belt_icon_state = null
	toolspeed = 0.05
	max_fuel = 100
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = INDESTRUCTIBLE|LAVA_PROOF|FIRE_PROOF|UNACIDABLE|ACID_PROOF
	custom_materials = null

	light_range = 1
	light_power = 1
	light_color = LIGHT_COLOR_HALOGEN

/obj/item/weldingtool/experimental/bluespace/process()
	if(get_fuel() <= max_fuel)
		reagents.add_reagent(/datum/reagent/fuel, 1)
	..()
