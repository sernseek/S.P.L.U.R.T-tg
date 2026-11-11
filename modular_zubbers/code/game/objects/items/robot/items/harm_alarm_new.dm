// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define HARM_ALARM_NO_SAFETY_COOLDOWN (60 SECONDS)
#define HARM_ALARM_SAFETY_COOLDOWN (20 SECONDS)

/obj/item/harmalarm/bubbers
	desc = "Releases a harmless blast that confuses most organics. Use in case of hostile blue whales."
	var/alarm_phrase = "HARM"

/obj/item/harmalarm/bubbers/click_alt(mob/living/user)
	var/str = reject_bad_text(tgui_input_text(user, LANG("obj.b91956c809fa4f53", null), LANG("obj.f2cfa33c2e6b01c3", null), alarm_phrase, MAX_NAME_LEN)) //Limit of 42 characters.
	if(!str)
		to_chat(user, span_warning(LANG("obj.7b1614ecfc89ed38", null)))
		return
	if(length(str) <= 2)
		to_chat(user, span_warning(LANG("obj.3f336d43f1e4f382", null)))
		return
	alarm_phrase = str
	to_chat(user, span_notice(LANG("obj.d9a5086b3d767b24", list(str))))

/obj/item/harmalarm/bubbers/attack_self(mob/user)
	var/safety = !(obj_flags & EMAGGED)
	if (!COOLDOWN_FINISHED(src, alarm_cooldown))
		to_chat(user, LANG("obj.9306fd19eb9e8682", null))
		return

	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(!robot_user.cell || robot_user.cell.charge < 1200)
			to_chat(user, span_warning(LANG("obj.949e51ce1af4c78b", null)))
			return
		robot_user.cell.charge -= 1000
		if(robot_user.emagged)
			safety = FALSE

	if(safety == TRUE)
		user.visible_message(LANG("obj.e54f5dedf29910a6", list(user)), \
			span_userdanger(LANG("obj.e12a98a6c1c14979", list(iscyborg(user) ? "you" : "and confuses you"))), \
			span_danger(LANG("obj.b3d71be9caa8faed", null)))
		for(var/mob/living/carbon/carbon in get_hearers_in_view(9, user))
			if(carbon.get_ear_protection())
				continue
			carbon.adjust_confusion(6 SECONDS)

		audible_message("<blink><font face='Franklin Gothic Medium' size='6'>[alarm_phrase]</font></blink>")
		playsound(get_turf(src), 'modular_zubbers/sound/ai/alan_davies.ogg', 70)
		COOLDOWN_START(src, alarm_cooldown, HARM_ALARM_SAFETY_COOLDOWN)
		user.log_message("used a Cyborg Harm Alarm", LOG_ATTACK)
		if(iscyborg(user))
			var/mob/living/silicon/robot/robot_user = user
			to_chat(robot_user.connected_ai, "<br>[span_notice("NOTICE - 'HARM ALARM' used by: [user]")]<br>")
	else
		user.audible_message("<font color='red' size='9'>[alarm_phrase]</font>")
		for(var/mob/living/carbon/carbon in get_hearers_in_view(9, user))
			var/bang_effect = carbon.soundbang_act(2, 0, 0, 5)
			switch(bang_effect)
				if(1)
					carbon.adjust_confusion(5 SECONDS)
					carbon.adjust_stutter(20 SECONDS)
					carbon.adjust_jitter(20 SECONDS)
				if(2)
					carbon.Paralyze(40)
					carbon.adjust_confusion(10 SECONDS)
					carbon.adjust_stutter(30 SECONDS)
					carbon.adjust_jitter(50 SECONDS)
		playsound(get_turf(src), 'sound/machines/warning-buzzer.ogg', 130, 3)
		COOLDOWN_START(src, alarm_cooldown, HARM_ALARM_NO_SAFETY_COOLDOWN)
		user.log_message("used an emagged Cyborg Harm Alarm", LOG_ATTACK)

#undef HARM_ALARM_NO_SAFETY_COOLDOWN
#undef HARM_ALARM_SAFETY_COOLDOWN
