// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Definition of the fishing mystery box subtype
/obj/structure/mystery_box/fishing
	// When adding new jobs to the blacklist, follow this formate and use a "," . (e.g. JOB_PRISONER, JOB_MIME)
	var/list/blacklisted_jobs = list(JOB_PRISONER)

// Override of the attack_hand method for the fishing mystery box
/obj/structure/mystery_box/fishing/attack_hand(mob/living/user, list/modifiers)
	if(user.mind?.assigned_role.title in blacklisted_jobs)
		to_chat(user, span_warning(LANG("obj.f05ac587a166826e", list(user.mind.assigned_role.title))))
		return

	// Call the parent attack_hand method if the user's job is not blacklisted
	return ..()
