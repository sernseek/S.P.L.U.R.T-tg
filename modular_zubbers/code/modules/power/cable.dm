// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/stack/cable_coil/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with))
		return NONE

	if(user.combat_mode)
		return NONE

	return try_heal(interacting_with, user)

/obj/item/stack/cable_coil/proc/try_heal(atom/interacting_with, mob/living/user)
	var/mob/living/carbon/human/carbon_patient = interacting_with
	var/obj/item/bodypart/preferred_limb = carbon_patient.get_bodypart(check_zone(user.zone_selected))
	var/obj/item/clothing/under/uniform = carbon_patient.w_uniform
	if(uniform?.has_sensor == BROKEN_SENSORS)
		if(uniform?.repair_sensors(user))
			return ITEM_INTERACT_SUCCESS
	if(isnull(preferred_limb) || !IS_ROBOTIC_LIMB(preferred_limb))
		return NONE
	if(!(preferred_limb.burn_dam > 0))
		balloon_alert(user, LANG("obj.aca69bd8ad34eb10", null))
		return ITEM_INTERACT_BLOCKING
	var/list/damaged_limbs = list()
	for(var/obj/item/bodypart/limb as anything in carbon_patient.bodyparts)
		if(isnull(limb) || !IS_ROBOTIC_LIMB(limb) || !(limb.burn_dam > 0))
			continue
		damaged_limbs += limb
	return try_auto_heal(interacting_with, user, damaged_limbs, preferred_limb)

/obj/item/stack/cable_coil/proc/try_auto_heal(atom/interacting_with, mob/living/user, list/damaged_limbs, preferred_limb)
	var/mob/living/carbon/human/attacked_humanoid = interacting_with
	var/obj/item/bodypart/repaired = (preferred_limb in damaged_limbs) ? preferred_limb : damaged_limbs[1]
	if(!(repaired.burn_dam > 0))
		var/list/updated_damaged_limbs = damaged_limbs
		updated_damaged_limbs.Remove(repaired)
		if(!length(damaged_limbs))
			user.balloon_alert(user, LANG("obj.e1212a63fd027dd4", null))
			return ITEM_INTERACT_SUCCESS
		user.balloon_alert(user, LANG("obj.cb8f1b84c12d115a", list(updated_damaged_limbs[1])))
		INVOKE_ASYNC(src, PROC_REF(try_auto_heal), interacting_with, user, updated_damaged_limbs, preferred_limb)
		return

	user.visible_message(span_notice(LANG("obj.78934db067cefedc", list(user, attacked_humanoid == user ? user.p_their() : "[attacked_humanoid]'s", repaired.name))),
		span_notice(LANG("obj.ddb7d553243966bb", list(attacked_humanoid == user ? "your" : "[attacked_humanoid]'s", repaired.name))))
	var/use_delay = 1 SECONDS
	if(user == attacked_humanoid)
		use_delay = 5 SECONDS

	if(!do_after(user, use_delay, attacked_humanoid))
		return ITEM_INTERACT_BLOCKING

	repaired.heal_damage(brute = 0, burn = 15, required_bodytype = BODYTYPE_ROBOTIC)
	user.visible_message(span_notice(LANG("obj.ee4cc5e5a120f9cd", list(user, attacked_humanoid, repaired.name))), \
		span_notice(LANG("obj.6fc0446008d1eaaf", list(attacked_humanoid == user ? "your" : "[attacked_humanoid]'s", repaired.name))))

	if (use(1) && amount > 0)
		INVOKE_ASYNC(src, PROC_REF(try_auto_heal), interacting_with, user, damaged_limbs, preferred_limb)
	return ITEM_INTERACT_SUCCESS
