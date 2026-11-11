// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/bloodcrawl_bottle
	name = "bloodlust in a bottle"
	desc = "Drinking this will give you unimaginable powers... and mildly disgust you because of it's metallic taste."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "vial"

/obj/item/bloodcrawl_bottle/attack_self(mob/user)
	to_chat(user, span_notice(LANG("obj.22c5d6e89754245e", list(src))))
	var/datum/action/cooldown/spell/jaunt/bloodcrawl/new_spell =  new(user)
	new_spell.Grant(user)
	user.log_message("learned the spell bloodcrawl ([new_spell])", LOG_ATTACK, color="orange")
	qdel(src)
