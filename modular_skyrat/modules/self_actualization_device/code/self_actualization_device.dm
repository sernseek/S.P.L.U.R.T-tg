// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// Possible states of player consent for using the machine.
#define NO_CONSENT 0
#define CONSENT_GRANTED 1
#define WAITING_PLAYER 2
/// How long does it take to break out of the machine?
#define BREAKOUT_TIME 5 SECONDS
/// The interval that advertisements are said by the machine's speaker.
#define ADVERT_TIME 14 SECONDS

/datum/design/board/self_actualization_device
	name = "Machine Design (Self-Actualization Device)"
	desc = "The circuit board for a Self-Actualization Device by Veymed: A Family Company."
	id = "self_actualization_device"
	build_path = /obj/item/circuitboard/machine/self_actualization_device
	category = list(RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/circuitboard/machine/self_actualization_device
	name = "Self-Actualization Device"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/self_actualization_device
	req_components = list()

/obj/machinery/self_actualization_device
	name = "Self-Actualization Device"
	desc = "A state of the art medical device that can restore someone's physical appearance to the last known DNA database backup."
	icon = 'modular_skyrat/modules/self_actualization_device/icons/self_actualization_device.dmi'
	icon_state = "sad_open"
	circuit = /obj/item/circuitboard/machine/self_actualization_device
	state_open = FALSE
	density = TRUE
	active_power_usage = 240 KILO WATTS
	idle_power_usage = 24 KILO WATTS
	/// Is someone being processed inside of the machine?
	var/processing = FALSE
	/// How long does the machine take to work?
	var/processing_time = 30 SECONDS
	/// wzhzhzh
	var/datum/looping_sound/microwave/sound_loop
	/// Has the player consented to the DNA change
	var/player_consent = NO_CONSENT
	/// A list containing advertisements that the machine says while working.
	var/static/list/advertisements = list(\
	"Thank you for using the Self-Actualization Device, brought to you by Veymed, because you asked for it.", \
	"The Self-Actualization device is not to be used by the elderly without direct adult supervision. Veymed is not liable for any and all injuries sustained under unsupervised usage of the Self-Actualization Device.", \
	"The Self-Actualization Device is not to be used un-cleaned. Thanks to its non-stick coating, cleaning up after a failed rejuvenation is easy as cleaning a microwave. Blood just doesn't stick!", \
	"Before using the Self-Actualization Device, remove any and all metal devices, or you might make the term 'ironman' a bit too literal!" , \
	"Remember, this is not cloning! Self-Actualization is a legally distinct, Veymed patent pending procedure. Still have questions? Call your nearest Veymed Representative to requisition more information about the Self-Actualization Device!" , \
	"Coming soon... Self-Actualization Device: Colony Fabricator Edition! Flat-packed and better in every way, with no medical expertise required! It's so easy, it's like cheating! Contact your nearest Veymed Representative to find out more!" \
	)
	COOLDOWN_DECLARE(advert_time)
	COOLDOWN_DECLARE(sad_processing_time)

/obj/machinery/self_actualization_device/examine_more(mob/user)
	. = ..()

	. += LANG("obj.82376ad9f3b1ba8d", null)

	return .

/obj/machinery/self_actualization_device/Initialize(mapload)
	. = ..()
	sound_loop = new(src, FALSE)
	register_context()
	update_appearance()

/obj/machinery/self_actualization_device/Destroy()
	QDEL_NULL(sound_loop)
	return ..()

/obj/machinery/self_actualization_device/update_appearance(updates)
	. = ..()
	if(isnull(occupant))
		icon_state = state_open ? "sad_open" : "sad_empty"
	else
		switch(player_consent)
			if(WAITING_PLAYER)
				icon_state = "sad_validating"
			if(CONSENT_GRANTED)
				icon_state = "sad_on"
			if(NO_CONSENT)
				icon_state = "sad_occupied"

/obj/machinery/self_actualization_device/close_machine(atom/movable/target, density_to_set = TRUE)
	..()
	playsound(src, 'sound/machines/click.ogg', 50)
	if(!occupant)
		return FALSE
	if(!ishuman(occupant))
		occupant.forceMove(drop_location())
		set_occupant(null)
		return FALSE
	to_chat(occupant, span_notice(LANG("obj.1d4849e619e6913a", list(src))))
	addtimer(CALLBACK(src, PROC_REF(get_consent)), 4 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)
	update_appearance()

/obj/machinery/self_actualization_device/examine(mob/user)
	. = ..()
	. += span_info(LANG("obj.778843e42d0b2b0f", list(display_power(active_power_usage), DisplayTimeText(processing_time))))

	if(processing)
		. += span_notice(LANG("obj.5510129cab92578c", list(DisplayTimeText(COOLDOWN_TIMELEFT(src, sad_processing_time), 2))))
	else
		. += span_notice(LANG("obj.fda1a027f1258376", list(state_open ? "close" : "open")))
		if(!isnull(occupant) && !state_open)
			. += span_notice(LANG("obj.ff1221b3467849ff", null))

/obj/machinery/self_actualization_device/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(!processing)
		context[SCREENTIP_CONTEXT_LMB] = LANG("obj.e929428c8aef275f", list(state_open ? "Close" : "Open"))
	if(!isnull(occupant) && !state_open && !processing)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Start machine"

	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/self_actualization_device/interact(mob/user)
	if(state_open)
		close_machine()
		return

	if(!processing)
		open_machine()
		return

/obj/machinery/self_actualization_device/click_alt(mob/user)
	if(!powered() || !occupant || state_open || processing)
		return CLICK_ACTION_BLOCKING

	user.visible_message(span_notice(LANG("obj.c6842664dc0d26dc", list(user, src))), span_notice(LANG("obj.85e7cc687a81a65b", list(src))))
	get_consent()
	return CLICK_ACTION_SUCCESS

/obj/machinery/self_actualization_device/process(seconds_per_tick)
	if(!processing)
		return

	if(!powered() && occupant && processing)
		eject_old_you(damaged_goods = TRUE)
		return

	if(!powered() || !occupant || !iscarbon(occupant))
		open_machine()
		return

	if(player_consent != CONSENT_GRANTED) // breakout
		processing = FALSE
		return

	if(COOLDOWN_FINISHED(src, sad_processing_time))
		eject_new_you()
		return

	if(COOLDOWN_FINISHED(src, advert_time))
		COOLDOWN_START(src, advert_time, rand(ADVERT_TIME, ADVERT_TIME * 2))
		say(pick(advertisements))
		playsound(loc, 'sound/machines/chime.ogg', 30, FALSE)

	use_energy(active_power_usage)

/// Asks the player if they want to consent to the rejuvenation procedure (replacing their DNA with what they currently have selected in character preferences.)
/obj/machinery/self_actualization_device/proc/get_consent()
	if(state_open || !occupant || !powered())
		return

	if(!ishuman(occupant))
		return

	if(player_consent != NO_CONSENT)
		return

	playsound(loc, 'sound/machines/chime.ogg', 30, FALSE)
	say(LANG("obj.c197023035b9be8c", null))
	var/mob/living/carbon/human/human_occupant = occupant
	if(!isnull(human_occupant.ckey) && isnull(human_occupant.client)) // player mob, currently disconnected
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, FALSE)
		say(LANG("obj.290ba6cf33b04801", null))
		return

	player_consent = WAITING_PLAYER
	update_appearance()

	// defaults to rejecting it unless specified otherwise
	if(tgui_alert(occupant, LANG("obj.849efc777f2c2ba8", null), LANG("obj.b77e9c6037c3333e", null), list("Yes", "No"), timeout = 10 SECONDS) == "Yes")
		player_consent = CONSENT_GRANTED
		say(LANG("obj.d44835f5666f8fc8", list(DisplayTimeText(processing_time), display_power(active_power_usage))))
		to_chat(occupant, span_warning(LANG("obj.233cda98b945e47a", list(DisplayTimeText(processing_time)))))
		set_light(l_range = 1.5, l_power = 1.2, l_on = TRUE)
		sound_loop.start()
		COOLDOWN_START(src, sad_processing_time, processing_time)
		COOLDOWN_START(src, advert_time, rand(ADVERT_TIME * 0.75, ADVERT_TIME * 1.25))
		processing = TRUE
		update_appearance()
	else
		player_consent = NO_CONSENT
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, FALSE)
		say(LANG("obj.5618fe74191b092d", null))
		update_appearance()

/// Ejects the occupant after asking them if they want to accept the rejuvenation. If yes, they exit as their preferences character.
/obj/machinery/self_actualization_device/proc/eject_new_you()
	player_consent = NO_CONSENT
	set_light(l_on = FALSE)
	sound_loop.stop()
	processing = FALSE
	if(state_open || !occupant || !powered())
		return

	var/mob/living/carbon/human/patient = occupant
	var/original_name = patient.dna.real_name

	patient.client?.prefs?.safe_transfer_prefs_to_with_damage(patient, visuals_only = TRUE)
	patient.dna.update_dna_identity()
	// SPLURT ADDITION START - Fix of naga with shoes
	var/taur_mode = patient.get_taur_mode()
	if((taur_mode & STYLE_TAUR_SNAKE) && (patient.shoes))
		patient.dropItemToGround(patient.shoes, TRUE)
	// SPLURT ADDITION END - Fix of naga with shoes
	patient.updateappearance()
	patient.wash(CLEAN_SCRUB)
	if(patient.dna.real_name != original_name)
		log_game("[key_name(patient)] has used the Self-Actualization Device at [loc_name(src)], changed the name of their character. \
		Original Name: [original_name], New Name: [patient.dna.real_name].")
	else
		log_game("[key_name(patient)] has used the Self-Actualization Device at [loc_name(src)].")

	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
	say(LANG("obj.1b818e47021a5f69", null))
	open_machine()
	SSquirks.OverrideQuirks(patient, patient.client, spawn_items = FALSE)

/// Ejection and shut down of the machine, used before the preferences have been applied to the player. Damage optional.
/obj/machinery/self_actualization_device/proc/eject_old_you(damaged_goods = FALSE)
	player_consent = NO_CONSENT
	set_light(l_on = FALSE)
	sound_loop.stop()
	processing = FALSE

	if(damaged_goods)
		var/mob/living/carbon/human/victim_living = occupant
		var/damage = (rand(75, 150))
		victim_living.emote("scream")
		victim_living.apply_damage(0.2 * damage, BURN, BODY_ZONE_HEAD, wound_bonus = 7)
		victim_living.apply_damage(0.4 * damage, BURN, BODY_ZONE_CHEST, wound_bonus = 21)
		victim_living.apply_damage(0.10 * damage, BURN, BODY_ZONE_L_LEG, wound_bonus = 14)
		victim_living.apply_damage(0.10 * damage, BURN, BODY_ZONE_R_LEG, wound_bonus = 14)
		victim_living.apply_damage(0.10 * damage, BURN, BODY_ZONE_L_ARM, wound_bonus = 14)
		victim_living.apply_damage(0.10 * damage, BURN, BODY_ZONE_R_ARM, wound_bonus = 14)
		victim_living.visible_message(span_warning(LANG("obj.403793f7807ec14a", list(src, victim_living))), span_danger(LANG("obj.35d55ceee0db8d79", list(src))))

	open_machine()

/// The player can break out of the SAD if they've changed their mind about using it.
/obj/machinery/self_actualization_device/container_resist_act(mob/living/user)
	if(state_open)
		return

	if(COOLDOWN_TIMELEFT(src, sad_processing_time) < BREAKOUT_TIME)
		to_chat(user, span_warning(LANG("obj.493da65abe3fa762", null)))
		return

	to_chat(user, span_notice(LANG("obj.58177e73a518ae0f", null)))
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_notice(LANG("obj.485787b2b8d67ec7", list(user, src))), \
		span_notice(LANG("obj.43ad33b141e25411", list(src, DisplayTimeText(BREAKOUT_TIME)))), \
		span_hear(LANG("obj.a1d9c5733c600b1c", list(src))))
	user.emote("scream")

	if(do_after(user, BREAKOUT_TIME, target = src))
		if(!user || !IS_UNCONSCIOUS_OR_CRIT(user) || user.loc != src || state_open)
			return
		user.visible_message(span_warning(LANG("obj.37696909131e91b5", list(user, src))), \
			span_notice(LANG("obj.81c31f6b9b00625a", list(src))))
		eject_old_you(damaged_goods = TRUE)

/obj/machinery/self_actualization_device/screwdriver_act(mob/living/user, obj/item/used_item)
	. = TRUE
	if(..())
		return

	if(occupant)
		to_chat(user, span_warning(LANG("obj.297417466fc8e075", list(src))))
		return

	if(default_deconstruction_screwdriver(user, used_item))
		update_appearance()
		return

	return FALSE

/obj/machinery/self_actualization_device/crowbar_act(mob/living/user, obj/item/used_item)
	if(occupant)
		to_chat(user, span_warning(LANG("obj.297417466fc8e075", list(src))))
		return

	if(default_deconstruction_crowbar(used_item))
		return TRUE

#undef NO_CONSENT
#undef CONSENT_GRANTED
#undef WAITING_PLAYER
#undef BREAKOUT_TIME
#undef ADVERT_TIME
