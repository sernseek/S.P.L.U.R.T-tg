// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/pai_card/attack_ghost(mob/user)
	. = ..()
	ghost_activate(user)

/**
 * Checks if the user is allowed to be a pAI, and if so, creates a new pAI mob.
 * Assuming the pAI card itself is empty of a personality.
 */
/obj/item/pai_card/proc/ghost_activate(mob/user)
	if(!SSticker.HasRoundStarted())
		return
	if(pai)
		return
	var/pai_ask = tgui_alert(user, LANG("obj.0314be3cf0ea5649", null), LANG("obj.3c1da715a16e1d9e", null), list("Yes","No"))
	if(pai_ask != "Yes" || QDELETED(src))
		return
	var/pai_ckey = user.ckey
	if(!user.client || !isobserver(user) || is_banned_from(pai_ckey, ROLE_PAI))
		return
	if(!SSpai.candidates[pai_ckey])
		to_chat(user, span_warning(LANG("obj.0b9dc85eec0205c2", null)))
		return
	var/datum/pai_candidate/candidate = SSpai.candidates[pai_ckey]
	var/mob/living/silicon/pai/ghost_pai = new(src)
	ghost_pai.name = candidate.name || pick(GLOB.ninja_names)
	ghost_pai.real_name = ghost_pai.name
	ghost_pai.key = candidate.ckey
	set_personality(ghost_pai)
	SSpai.candidates -= pai_ckey
	return
