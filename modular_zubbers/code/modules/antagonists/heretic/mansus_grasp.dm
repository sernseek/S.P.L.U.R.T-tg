// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/action/cooldown/spell/touch/mansus_grasp
	desc = "A touch spell that lets you channel the power of the Old Gods through your grip. Requires a Living Heart to use for anything except runes."

/datum/action/cooldown/spell/touch/mansus_grasp/can_hit_with_hand(atom/victim, mob/living/caster)
	. = ..()
	if (!.)
		return FALSE
	if (caster.has_status_effect(/datum/status_effect/void_stealth))
		return FALSE
	var/datum/antagonist/heretic/heretic_datum = GET_HERETIC(caster)
	if (!isturf(victim))
		if (heretic_datum?.has_living_heart() != HERETIC_HAS_LIVING_HEART)
			caster.balloon_alert(caster, LANG("datum.bbf6fa3b48149d92", null))
			return FALSE
		if (heretic_datum.owner?.current && HAS_TRAIT(heretic_datum.owner.current, TRAIT_MANSUS_INHIBITION))
			caster.balloon_alert(caster, LANG("datum.dde82252f3fbf451", null))
			return FALSE
