// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/carbon/human/attack_ghost(mob/dead/observer/user)
	. = ..()
	if(. || !user.client)
		return
	if(!((isAdminGhostAI(user) || user.client.prefs.read_preference(/datum/preference/toggle/inquisitive_ghost)) && CONFIG_GET(flag/ghost_interaction)))
		return
	ghost_ass_slap(user)

/mob/living/carbon/human/proc/ghost_ass_slap(mob/dead/observer/user)
	// Check if target is alive
	if(stat >= DEAD)
		// Alert ghost and return
		to_chat(user, LANG("mob.15d9908ee8c47c29", list(src)))
		return

	// Check for Personal Space (formally Buns of Steel)
	if(HAS_TRAIT(src, TRAIT_PERSONALSPACE))
		// Display messages
		visible_message(\
			span_danger(LANG("mob.efae6b7fbfb0fac7", list(src))),
			span_danger(LANG("mob.d98a3d8a63e177d6", null)),
			LANG("mob.0fe126f3bc18e949", null), null, user)
		to_chat(user, span_notice(LANG("mob.b83023d52b525a28", list(src))))

		// Play reflect sound
		playsound(src.loc, get_sfx_skyrat(SFX_BULLET_IMPACT_METAL), 50, 1, -1)

		return

	if(!HAS_TRAIT(src, TRAIT_BIMBO))
		unwag_tail()

	// Play slap sound
	conditional_pref_sound(src.loc, 'sound/items/weapons/slap.ogg', 50, 1, -1)

	// Display standard message
	visible_message(\
		span_danger(LANG("mob.89fc64f7268b57c3", list(src))),
		span_notice(LANG("mob.938162ce0f90003d", null)),
		LANG("mob.0cd94d608f0ca6bf", null), null, user)
	to_chat(user, span_notice(LANG("mob.45cb6ad5744c26f9", list(src))))

	// Check for slapping quirk
	if(HAS_TRAIT(src, TRAIT_JIGGLY_ASS))
		// Check for non-con pref
		if(!findtext(client?.prefs.read_preference(/datum/preference/choiced/erp_status_nc), "Yes"))
			// Don't do it
			return

		// Add arousal
		adjust_arousal(10)
