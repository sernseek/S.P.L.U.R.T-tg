// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/gun/ballistic/automatic/bulwark
	name = "\improper NTS-24 \"Bulwark\" Assault Rifle"
	desc = "A rare command-grade rifle issued only to Nanotrasen Private Security Captains, seldom seen in the field. \
		Its deployment signals immediate escalation beyond routine operations. Featuring a polished wooden grip and a large \
		Nanotrasen logo emblazoned on the stock, the Bulwark blends legacy styling with modern design. More than a weapon, \
		it's a clear mark of authority. Chambered in 6.8mm Caseless."
	icon = 'modular_zzplurt/icons/obj/weapons/guns/ballistic_64x32.dmi'
	lefthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_zzplurt/icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "bulwark"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "bulwark"
	accepted_magazine_type = /obj/item/ammo_box/magazine/c68
	fire_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_shot.ogg'
	rack_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_rack.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/general/bolt_drop.ogg'
	eject_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_eject.ogg'
	eject_empty_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_eject.ogg'
	load_sound = 'modular_zzplurt/sound/items/weapons/gun/bulwark_insert.ogg'
	burst_delay = 2
	can_suppress = TRUE
	empty_indicator = TRUE
	burst_size = 1
	actions_types = list()
	mag_display = TRUE

/obj/item/gun/ballistic/automatic/bulwark/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.25 SECONDS)

/obj/item/gun/ballistic/automatic/bulwark/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/gun/ballistic/automatic/bulwark/examine_more(mob/user)
	. = ..()

	. += LANG("obj.76dfe5d7250825fe", null)

	return .

/obj/item/gun/ballistic/automatic/bulwark/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 28, \
		overlay_y = 12)

/obj/item/gun/energy/taser/underbarrel
	name = "\improper NT underbarrel taser"
	desc = "A compact Nanotrasen taser module designed for rifle mounting."
	use_cyborg_cell = FALSE
	cell_type = /obj/item/stock_parts/power_store/cell/crap

	var/recharge_cooldown_end = 0
	var/active = FALSE

/obj/item/gun/energy/taser/underbarrel/Initialize(mapload)
	. = ..()
	if(!cell)
		cell = new cell_type(src)
	START_PROCESSING(SSobj, src)

/obj/item/gun/energy/taser/underbarrel/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/energy/taser/underbarrel/give_gun_safeties()
	return

/obj/item/gun/energy/taser/underbarrel/process()
	if(active)
		return

	if(world.time < recharge_cooldown_end)
		return

	if(cell && cell.charge < cell.maxcharge)
		cell.give(500)

	var/obj/item/gun/ballistic/automatic/bulwark/taser/parent = loc
	if(parent)
		parent.update_taser_overlay()


/obj/item/gun/energy/taser/underbarrel/try_fire_gun(atom/target, mob/living/user, params)
	if(!cell || cell.charge <= 0)
		to_chat(user, span_warning(LANG("obj.83dc46eb3475197e", null)))
		return FALSE

	if(active)
		to_chat(user, span_warning(LANG("obj.b55d3175006168b6", null)))
		return FALSE

	active = TRUE

	var/result = ..()

	if(!result)
		active = FALSE
		return FALSE

	var/obj/item/gun/ballistic/automatic/bulwark/taser/parent = loc
	if(parent)
		parent.update_taser_overlay()

	if(cell && cell.charge <= 0)
		recharge_cooldown_end = world.time + 100
		to_chat(user, span_warning(LANG("obj.ccd4917091f5fa77", null)))

	addtimer(CALLBACK(src, PROC_REF(reset_active), user), 100)

	return TRUE

/obj/item/gun/energy/taser/underbarrel/proc/reset_active(mob/user)
	if(!active)
		return

	active = FALSE

	if(world.time >= recharge_cooldown_end)
		recharge_cooldown_end = world.time + 150

	var/obj/item/gun/ballistic/automatic/bulwark/taser/parent = loc
	if(parent)

		parent.fire_lock_until = world.time + 30

		addtimer(CALLBACK(parent, "notify_recovered", user), 30)

		parent.update_taser_overlay()

/obj/item/gun/ballistic/automatic/bulwark/taser
	name = "\improper NTS-24-T \"Bulwark\" Assault Rifle"
	desc = "A rare command-grade rifle issued only to Nanotrasen Private Security Captains, seldom seen in the field. \
	Its deployment signals immediate escalation beyond routine operations. Featuring a polished wooden grip and a large \
	Nanotrasen logo emblazoned on the stock, the Bulwark blends legacy styling with modern design. More than a weapon, \
	it's a clear mark of authority. This variant includes an underslung taser. Chambered in 6.8mm Caseless."

	var/obj/item/gun/energy/taser/underbarrel/underbarrel
	var/mutable_appearance/taser_overlay
	var/fire_lock_until = 0
	var/last_warning = 0

/obj/item/gun/ballistic/automatic/bulwark/taser/Initialize(mapload)
	. = ..()
	underbarrel = new /obj/item/gun/energy/taser/underbarrel(src)
	update_taser_overlay()

/obj/item/gun/ballistic/automatic/bulwark/taser/Destroy()
	QDEL_NULL(underbarrel)
	return ..()

/obj/item/gun/ballistic/automatic/bulwark/taser/proc/is_tasing()
	return underbarrel && underbarrel.active

/obj/item/gun/ballistic/automatic/bulwark/taser/proc/notify_recovered(mob/user)
	if(user)
		to_chat(user, span_notice(LANG("obj.f0f8551143f31949", null)))

/obj/item/gun/ballistic/automatic/bulwark/taser/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(is_tasing())
		if(world.time > last_warning + 10)
			last_warning = world.time
			to_chat(user, span_warning(LANG("obj.d0d13ad1af8a2fd5", null)))
		return FALSE

	if(world.time < fire_lock_until)
		if(world.time > last_warning + 10)
			last_warning = world.time
			var/time_left = round((fire_lock_until - world.time) / 10)
			to_chat(user, span_warning(LANG("obj.6219b112941cf200", list(time_left))))
		return FALSE

	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		if(underbarrel)
			var/result = underbarrel.try_fire_gun(target, user, params)
			update_taser_overlay()
			return result

	return ..()

/obj/item/gun/ballistic/automatic/bulwark/taser/proc/update_taser_overlay()
	if(taser_overlay)
		cut_overlay(taser_overlay)
		taser_overlay = null

	if(underbarrel && underbarrel.cell)
		if(underbarrel.cell.charge > 0)
			taser_overlay = mutable_appearance(icon, "bulwark_taser_loaded")
		else
			taser_overlay = mutable_appearance(icon, "bulwark_taser_empty")

	if(taser_overlay)
		add_overlay(taser_overlay)

/obj/item/gun/ballistic/automatic/bulwark/taser/examine(mob/user)
	. = ..()

	if(underbarrel && underbarrel.cell)
		var/percent = round((underbarrel.cell.charge / underbarrel.cell.maxcharge) * 100)

		. += LANG("obj.03b9c41e875c21a8", list(percent))

		if(world.time < underbarrel.recharge_cooldown_end)
			var/time_left = round((underbarrel.recharge_cooldown_end - world.time) / 10)
			. += LANG("obj.41561a8dfc0d5992", list(time_left))
	else
		. += LANG("obj.618675c3d32d8251", null)

/obj/item/gun/ballistic/automatic/bulwark/taser/add_seclight_point()
	return
