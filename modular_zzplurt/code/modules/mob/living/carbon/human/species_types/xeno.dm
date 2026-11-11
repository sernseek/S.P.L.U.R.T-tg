// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/species/xeno
	heatmod = 1.5
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant/xenohybrid,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant/xenohybrid,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant/xenohybrid,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant/xenohybrid,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant/xenohybrid,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant/xenohybrid
	)

/datum/species/xeno/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE)
	. = ..()
	var/datum/action/innate/reconstitute_form/reconstitute_form = new(human_who_gained_species)
	var/datum/action/cooldown/sonar_ping/sonar_ping = new(human_who_gained_species)
	reconstitute_form.Grant(human_who_gained_species)
	sonar_ping.Grant(human_who_gained_species)
	human_who_gained_species.add_movespeed_modifier(/datum/movespeed_modifier/xenochimera)

/datum/species/xeno/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	var/datum/action/innate/reconstitute_form/reconstitute_form = locate() in C.actions // (for the record, "C" isnt better)
	qdel(reconstitute_form)
	C.remove_movespeed_modifier(/datum/movespeed_modifier/xenochimera)

/datum/movespeed_modifier/xenochimera
	multiplicative_slowdown = -0.1

#define ACTION_STATE_STANDBY 0
#define ACTION_STATE_PREPARING 1

/obj/item/organ/brain/xeno_hybrid/Initialize(mapload) //speech bubble addition
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "alien", BUBBLE_ICON_PRIORITY_ORGAN)

/datum/action/innate/reconstitute_form
	name = "Reconstitute Form"
	button_icon = 'modular_zzplurt/icons/hud/actions.dmi'
	button_icon_state = "stasis"
	var/action_state = ACTION_STATE_STANDBY
	var/revive_timer = 0
	var/is_dead = FALSE
	COOLDOWN_DECLARE(revive_cd)

/datum/action/innate/reconstitute_form/Trigger(mob/clicker, trigger_flags)
	if(!..())
		return FALSE

	var/mob/living/carbon/human/owner = src.owner
	switch(action_state)
		if(ACTION_STATE_STANDBY)
			if(!COOLDOWN_FINISHED(src, revive_cd))
				to_chat(owner, span_warning(LANG("datum.b9bb7aeb5e95dc4a", list(DisplayTimeText(COOLDOWN_TIMELEFT(src, revive_cd))))))
				return FALSE

			is_dead = (owner.stat == DEAD)
			var/time = is_dead ? 5 MINUTES : 30 SECONDS
			var/alert = is_dead ? LANG("datum.87c8715f072e2b96", null) : LANG("datum.2ba8e3a0b4c253f1", null)

			if(tgui_alert(owner, alert, LANG("datum.397d97d731c620a0", null), list("Yes", "No")) != "Yes")
				return FALSE

			to_chat(owner, span_notice(LANG("datum.850f714723436b70", list(DisplayTimeText(time)))))

			if(is_dead)
				RegisterSignal(owner, COMSIG_LIVING_REVIVE, PROC_REF(on_revive))
			else
				owner.Stun(time)

			revive_timer = addtimer(CALLBACK(src, PROC_REF(execute_reconstitution)), time, TIMER_UNIQUE | TIMER_STOPPABLE)

			action_state = ACTION_STATE_PREPARING
			button_icon_state = "regenerating"
			build_all_button_icons()
			return TRUE

		if(ACTION_STATE_PREPARING)
			to_chat(owner, span_warning(LANG("datum.a923eda8e789831c", list(DisplayTimeText(timeleft(revive_timer))))))
			return FALSE

/datum/action/innate/reconstitute_form/proc/on_revive(mob/living/source, full_heal_flags)
	SIGNAL_HANDLER

	if(revive_timer)
		deltimer(revive_timer)
		revive_timer = 0

	to_chat(owner, span_notice(LANG("datum.7c10391d68cdd996", null)))
	UnregisterSignal(owner, COMSIG_LIVING_REVIVE)
	action_state = ACTION_STATE_STANDBY
	button_icon_state = "stasis"
	build_all_button_icons()

/datum/action/innate/reconstitute_form/proc/execute_reconstitution()
	var/mob/living/carbon/human/owner = src.owner
	if(!owner)
		return

	revive_timer = 0

	// Apply the changes based on character preferences (like self-actualization device)
	owner.client?.prefs?.safe_transfer_prefs_to_with_damage(owner, visuals_only = TRUE)
	owner.dna.update_dna_identity()
	var/taur_mode = owner.get_taur_mode()
	if((taur_mode & STYLE_TAUR_SNAKE) && (owner.shoes))
		owner.dropItemToGround(owner.shoes, TRUE)
	owner.updateappearance()
	owner.wash(CLEAN_SCRUB)

	// Drop items and create viscera for the transformation
	for(var/obj/item/wielded in owner)
		owner.dropItemToGround(wielded, force = TRUE, silent = TRUE)

	new /obj/effect/gibspawner/human(get_turf(owner), owner)

	if(is_dead)
		to_chat(owner, span_notice(LANG("datum.15be8141d578eb51", null)))
		owner.revive(HEAL_ALL)
		owner.visible_message(span_danger(LANG("datum.b558e9a8cb97ac97", list(owner))))
		owner.visible_message(LANG("datum.60b171338a41ce8d", null))

		UnregisterSignal(owner, COMSIG_LIVING_REVIVE)
		COOLDOWN_START(src, revive_cd, 5 MINUTES)
		is_dead = FALSE
	else
		to_chat(owner, span_notice(LANG("datum.61943fec4de780fe", null)))
		owner.visible_message(span_danger(LANG("datum.26150344506e209b", list(owner, owner.p_their()))))
		COOLDOWN_START(src, revive_cd, 30 SECONDS)

	action_state = ACTION_STATE_STANDBY
	button_icon_state = "stasis"
	build_all_button_icons()

	if(isethereal(owner))
		var/datum/status_effect/grouped/bodypart_effect/ethereal_glow/glow_status = owner.has_status_effect(/datum/status_effect/grouped/bodypart_effect/ethereal_glow)
		if(!isnull(glow_status))
			glow_status.refresh_light_color()

	SSquirks.OverrideQuirks(owner, owner.client)

#undef ACTION_STATE_STANDBY
#undef ACTION_STATE_PREPARING
