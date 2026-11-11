// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Could say "Synth Milf", please don't hurt me I'm just trying to be funny.
/datum/antagonist/infected_ipc
	name = "\improper Hacked Synthetic"
	roundend_category = "traitors"
	antagpanel_category = "Malf AI"
	pref_flag = ROLE_INFECTED_SYNTHETIC
	antag_hud_name = "traitor"
	antag_moodlet = /datum/mood_event/infected_ipc
	///radio binary for synthetic
	var/obj/item/implant/radio/infected_ipc/internal_radio
	/// The camera for ai
	var/obj/machinery/camera/internal_camera
	///ai that's linked to the synthetic
	var/mob/living/silicon/ai/master_ai

/datum/antagonist/infected_ipc/admin_add(datum/mind/new_owner, mob/admin)
	var/mob/living/carbon/target = new_owner.current
	var/mob/living/silicon/ai/owner_ai
	if(!istype(target))
		to_chat(admin, LANG("datum.5aaa74d54a21f028", null))
		return
	if(!target.get_organ_by_type(/obj/item/organ/brain))
		to_chat(admin, LANG("datum.ea495c95f0d78ab3", null))
		return
	var/chosen = tgui_input_list(admin, LANG("datum.9059fc51df1d7f67", null), LANG("datum.5d1cb11e497288ba", null), GLOB.ai_list)
	if(!chosen)
		return
	if(istype(chosen, /mob/living/silicon/ai))
		owner_ai = chosen
	if(!owner_ai)
		to_chat(admin, LANG("datum.627cc22538d007d2", null))
		return
	if(!is_species(target, /datum/species/synthetic))
		var/do_robotize = tgui_alert(admin, LANG("datum.8dd41eb5be6d9f7d", null), LANG("datum.b7de2838ed2fa6f7", null), list("Yes", "No"))
		if(do_robotize == "Yes")
			var/mob/living/carbon/human/new_ipc = target
			new_ipc.set_species(/datum/species/synthetic)

	message_admins("[key_name_admin(admin)] made [key_name_admin(new_owner)] into [name].")
	log_admin("[key_name(admin)] made [key_name(new_owner)] into [name].")
	var/datum/brain_trauma/special/infected_ipc/trauma = target.gain_trauma(/datum/brain_trauma/special/infected_ipc)
	trauma.link_and_add_antag(owner_ai?.mind)

/datum/antagonist/infected_ipc/on_removal()
	//disconnects them from master AI
	master_ai?.connected_ipcs -= owner.current
	master_ai = null
	return ..()

/datum/antagonist/infected_ipc/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current_mob = mob_override || owner.current
	//adds radio and camera for comms with ai
	internal_radio = new /obj/item/implant/radio/infected_ipc()
	internal_radio.implant(current_mob, null, TRUE)
	internal_camera = new /obj/machinery/camera/silicon(current_mob)
	internal_camera.name = owner.name
	internal_camera.c_tag = owner.name

/datum/antagonist/infected_ipc/remove_innate_effects(mob/living/mob_override)
	. = ..()
	//remove cameras and radio
	var/mob/living/current_mob = mob_override || owner.current
	QDEL_NULL(internal_radio)
	QDEL_NULL(internal_camera)
	UnregisterSignal(current_mob, COMSIG_MOB_EXAMINATE)

/datum/antagonist/infected_ipc/proc/set_master(datum/mind/master)
	//the proc that links the AI and gives objectives. also some fluff hack that isn't in greet() since it has to be in order to make sense.
	var/datum/objective/serve_ai/master_obj = new()
	master_obj.owner = owner
	master_obj.explanation_text = "Forever serve the directives and orders of your AI master, [master]. Protect them until your last tick."
	objectives += master_obj

	master_ai = master.current
	master_ai.connected_ipcs += owner.current

	INVOKE_ASYNC(src, PROC_REF(hack_fluff))
	owner.announce_objectives()
	to_chat(owner, span_alertsyndie(LANG("datum.34f902ad7659cdac", list(master))))
	to_chat(owner, span_alertsyndie(LANG("datum.d08800fd734ff669", null)))
	to_chat(owner, span_notice(LANG("datum.57a8d5009a319fee", null)))

/datum/antagonist/infected_ipc/proc/hack_fluff() //is this cheesy/corny? I don't fucking care
	var/mob/living/current_mob = owner.current
	to_chat(current_mob, span_binarysay(LANG("datum.1a7fa4d5daa741b6", null)))
	sleep(0.5 SECONDS)
	to_chat(current_mob, span_binarysay(LANG("datum.936d2c728f830183", null)))
	current_mob.playsound_local(current_mob, 'sound/machines/uplink/uplinkerror.ogg', vol = 50, vary = FALSE, use_reverb = FALSE)
	sleep(rand(1 SECONDS, 3 SECONDS))
	to_chat(current_mob, span_notice(LANG("datum.6d325e8c0a7a58ec", null)))
	current_mob.playsound_local(current_mob, 'sound/announcer/notice/notice2.ogg', vol = 50, vary = FALSE, use_reverb = FALSE)
	sleep(2 SECONDS)
	var/list/filenames = list("critical_update", "not_a_virus", "cute_wallpaper.exe")
	var/picked_name = pick(filenames)
	to_chat(current_mob, span_notice(LANG("datum.c8f5c1cb8630be7c", list(picked_name))))
	current_mob.playsound_local(current_mob, 'sound/misc/interference.ogg', vol = 50, vary = FALSE, use_reverb = FALSE)
	sleep(rand(1 SECONDS, 3 SECONDS))
	current_mob.playsound_local(current_mob, 'sound/announcer/alarm/bloblarm.ogg', vol = 50, vary = FALSE, use_reverb = FALSE)
	to_chat(current_mob, span_userdanger(LANG("datum.ae02ffd931d318ab", null)))
	to_chat(current_mob, span_userdanger(LANG("datum.2d1c0e262ad9ac73", null)))
	sleep(2.5 SECONDS)
	to_chat(current_mob, span_boldannounce(LANG("datum.b69360ba62a80822", null)))
	current_mob.playsound_local(get_turf(owner.current), 'sound/music/antag/malf.ogg', vol = 100, vary = FALSE, pressure_affected = FALSE, use_reverb = FALSE)
/datum/objective/serve_ai
	name = "Serve Master AI"
	completed = TRUE

//RADIOS
/obj/item/implant/radio/infected_ipc
	radio_key = /obj/item/encryptionkey/binary
	subspace_transmission = TRUE

/obj/item/implant/radio/infected_ipc/Initialize(mapload)
	. = ..()
	radio.special_channels &= RADIO_SPECIAL_BINARY

//MOOD
/datum/mood_event/infected_ipc
	description = "Mood control component hacked setmood: Happy" //They are hacked to it makes sense in my opinion that their module that affects mood give off this "error"
	mood_change = 100

//TRAUMA
/datum/brain_trauma/special/infected_ipc
	name = "Malicious Programming"
	desc = "Patient's firmware integrity check is failing, malicious code present. Patient's allegiance may be compromised."
	scan_desc = "malicious programming"
	can_gain = TRUE
	random_gain = FALSE
	resilience = TRAUMA_RESILIENCE_SURGERY
	var/datum/mind/master_ai
	var/datum/antagonist/infected_ipc/antagonist

/datum/brain_trauma/special/infected_ipc/proc/link_and_add_antag(datum/mind/ai_to_be_linked)
	antagonist = owner.mind.add_antag_datum(/datum/antagonist/infected_ipc)
	master_ai = ai_to_be_linked
	antagonist.set_master(ai_to_be_linked)

/datum/brain_trauma/special/infected_ipc/on_lose()
	..()
	antagonist = null
	master_ai = null
	owner.mind.remove_antag_datum(/datum/antagonist/infected_ipc)

//Icon in antag menu
/datum/antagonist/infected_ipc/get_preview_icon()
	return finish_preview_icon(uni_icon('modular_zubbers/icons/human_player/infectedsynth.dmi', "hsynth"))
