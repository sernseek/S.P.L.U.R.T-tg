// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Cyborg inducer. Uses up the cyborg's internal battery.
// Ported from BlueMoon, original code by FelixRuin (kudos to him)

#define POWER_TRANSFER 5000
#define MINIMAL_CHARGE_TRESHOLD 0.2
#define CHARGE_TRESHOLD 0.2
#define IND_STATUS_IDLE TRUE
#define IND_STATUS_CHARGING FALSE

/obj/item/borg/cyborg_inducer
	name = "modular inducer"
	desc = "A tool for inductively charging internal power cells."
	icon = 'icons/obj/tools.dmi'
	icon_state = "inducer-engi"
	force = 7
	w_class = WEIGHT_CLASS_SMALL

	/// What is this inducer doing now?
	var/status = IND_STATUS_IDLE
	/// Can you use this inducer to charge weapon cells?
	var/can_charge_guns = FALSE
	/// The cyborg's internal cell
	var/obj/item/stock_parts/power_store/cell/internal_cell
	/// This inducer's coefficient
	var/coefficient = 1
	/// Is this inducer currently recharging?
	var/recharging = FALSE

/obj/item/borg/cyborg_inducer/examine(mob/user)
	. = ..()
	internal_cell = get_cell()
	if(internal_cell)
		. += LANG("obj.589e2c6c7dd919cb", list(display_energy(internal_cell.charge)))
	else
		. += LANG("obj.8c974432c0cbbb96", null)


/obj/item/borg/cyborg_inducer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!can_be_used(user))
		return NONE
	if(recharge(interacting_with, user))
		return ITEM_INTERACT_BLOCKING
	return NONE

/obj/item/borg/cyborg_inducer/proc/induce(obj/item/stock_parts/power_store/cell/target, coefficient)
	internal_cell = get_cell()
	if(!target || target.charge >= target.maxcharge)
		return
	var/totransfer = min(internal_cell.charge, (POWER_TRANSFER * coefficient), internal_cell.maxcharge * CHARGE_TRESHOLD)
	var/transferred = target.give(totransfer)
	if(transferred > 0)
		internal_cell.use(transferred)
		internal_cell.update_icon()
		target.update_icon()

/obj/item/borg/cyborg_inducer/get_cell()
	var/mob/living/silicon/robot/cyborg = loc
	if(istype(cyborg))
		return cyborg.cell
	return null

/obj/item/borg/cyborg_inducer/proc/can_be_used(mob/user)
	internal_cell = get_cell()
	if(!internal_cell)
		to_chat(user, LANG("obj.923126c77b7d7b4b", null))
		return FALSE

	if(!internal_cell.charge)
		to_chat(user, LANG("obj.436967113699299d", null))
		return FALSE
	return TRUE

/obj/item/borg/cyborg_inducer/proc/recharge(atom/movable/this_atom, mob/user)
	if(isturf(this_atom))
		return FALSE
	if(this_atom.get_cell() == get_cell())
		to_chat(user, LANG("obj.df1d99e1771b0d32", null))
		return FALSE
	if(status == IND_STATUS_CHARGING)
		return TRUE

	status = IND_STATUS_CHARGING
	internal_cell = get_cell()

	if(this_atom.get_cell())
		if(istype(this_atom, /obj/item/gun/energy) && !can_charge_guns)
			to_chat(user, LANG("obj.5ac600494da14628", null))
			return FALSE
		var/obj/item/stock_parts/power_store/cell/this_cell = this_atom.get_cell()
		var/done_any = FALSE

		if(this_cell.charge >= this_cell.maxcharge)
			to_chat(user, LANG("obj.00964eed74685d03", list(this_atom)))
			recharging = FALSE
			status = IND_STATUS_IDLE
			return TRUE
		user.visible_message(LANG("obj.e705cbfadeaf87ca", list(user, this_atom, src)),LANG("obj.178d38ec00275a3c", list(this_atom, src)))
		while(this_cell.charge < this_cell.maxcharge)
			if(do_after(user, 10, target = user) && internal_cell.charge && (internal_cell.maxcharge * MINIMAL_CHARGE_TRESHOLD < internal_cell.charge))
				done_any = TRUE
				induce(this_cell, coefficient)
				do_sparks(1, FALSE, this_atom)
				this_atom.update_icon()
			else
				break
		if(done_any)
			user.visible_message(LANG("obj.1ab0f1dd75c9dfaa", list(user, this_atom)),LANG("obj.8fe68680a4a6cb0d", list(this_atom)))
		recharging = FALSE
		status = IND_STATUS_IDLE
		return TRUE
	recharging = FALSE
	status = IND_STATUS_IDLE

#undef POWER_TRANSFER
#undef MINIMAL_CHARGE_TRESHOLD
#undef CHARGE_TRESHOLD
#undef IND_STATUS_IDLE
#undef IND_STATUS_CHARGING
