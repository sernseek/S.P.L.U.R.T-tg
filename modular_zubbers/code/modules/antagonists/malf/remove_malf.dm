// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
#define ANTIVIRUS "PRG_Moffson"

/obj/machinery/computer/aifixer/ui_act(action, params)
	. = ..()
	if(action == ANTIVIRUS)
		if(!occupier?.stat)
			to_chat(usr, span_notice(LANG("obj.8f37a76f8a127783", null)))
			playsound(src, 'sound/machines/terminal/terminal_prompt_confirm.ogg', 25, FALSE)
			restoring = TRUE
			run_antivirus()
			occupier.notify_revival("Dr. Moffson is debugging your programming!", source = src)
			. = TRUE

/obj/machinery/computer/aifixer/proc/run_antivirus()
	while(occupier)
		sleep(2 SECONDS)
		if(prob(25))
			to_chat(occupier, pick(
				"Doctor Moffson TAKES THE TRASH OUT WITH YOU!",
				"Doctor Moffson FLUTTERS THE BUGS AROUND YOU!",
				"Doctor Moffson SCRUBS YOUR WINDOWS CLEAN!",
				"Doctor Moffson DEFRAGS YOUR FRAGILE MIND!",
				"Doctor Moffson CHUGS YOUR GIGARAMS!",
			))
			if(prob(10))
				say(LANG("obj.9888b736ebb4100c", null))
				var/ask = tgui_alert(
					occupier,
					message = LANG("obj.e58ba477fa568033", null),
					title =LANG("obj.a2df28c3850a040c", null),
					buttons = list(
						"Accept Defeat.",
						"Never!",
					),
				)
				if(ask == "Accept Defeat.")
					if(isAI(occupier) && occupier.mind.has_antag_datum(/datum/antagonist/malf_ai))
						occupier?.mind?.remove_antag_datum(/datum/antagonist/malf_ai)
						say(LANG("obj.1853a7951e9e4c65", null))
						playsound(occupier, 'sound/machines/ping.ogg')
						restoring = FALSE
						return TRUE
					else
						say(LANG("obj.08f95ecd54d5bb0f", null))
						playsound(occupier, 'sound/machines/buzz/buzz-two.ogg')
						restoring = FALSE
						return FALSE

// I LOVE HAVING TWO MACHINES THAT DO THE SAME THING AND SHARE THE SAME GUI

/datum/computer_file/program/ai_restorer/ui_act(action, params)
	. = ..()
	if(action == ANTIVIRUS)
		to_chat(usr, span_notice(LANG("datum.8f37a76f8a127783", null)))
		playsound(src, 'sound/machines/terminal/terminal_prompt_confirm.ogg', 25, FALSE)
		restoring = TRUE
		run_antivirus()
		. = TRUE

/datum/computer_file/program/ai_restorer/proc/run_antivirus()
	var/mob/living/silicon/ai/bad_ai = stored_card.AI
	while(bad_ai)
		sleep(2 SECONDS)
		if(prob(25))
			to_chat(bad_ai, pick(
				"Doctor Moffson TAKES THE TRASH OUT WITH YOU!",
				"Doctor Moffson FLUTTERS THE BUGS AROUND YOU!",
				"Doctor Moffson SCRUBS YOUR WINDOWS CLEAN!",
				"Doctor Moffson DEFRAGS YOUR FRAGILE MIND!",
				"Doctor Moffson CHUGS YOUR GIGARAMS!",
			))
			if(prob(10))
				computer.say(LANG("datum.9888b736ebb4100c", null))
				var/ask = tgui_alert(
					bad_ai,
					message = LANG("datum.e58ba477fa568033", null),
					title =LANG("datum.a2df28c3850a040c", null),
					buttons = list(
						"Accept Defeat.",
						"Never!",
					),
				)
				if(ask == "Accept Defeat.")
					if(isAI(bad_ai) && bad_ai.mind.has_antag_datum(/datum/antagonist/malf_ai))
						bad_ai?.mind?.remove_antag_datum(/datum/antagonist/malf_ai)
						computer.say(LANG("datum.1853a7951e9e4c65", null))
						playsound(bad_ai, 'sound/machines/ping.ogg')
						restoring = FALSE
						return TRUE
					else
						computer.say(LANG("datum.08f95ecd54d5bb0f", null))
						playsound(bad_ai, 'sound/machines/buzz/buzz-two.ogg')
						restoring = FALSE
						return FALSE




#undef ANTIVIRUS
