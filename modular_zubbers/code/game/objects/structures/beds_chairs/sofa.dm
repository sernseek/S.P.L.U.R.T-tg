// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// Looking through pillows on sofas when rightclicked
/obj/structure/chair/sofa/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!ishuman(user) || !user.ckey)
		return
	balloon_alert(user, LANG("obj.df40312dc5c6570b", null))
	to_chat(user, span_alert(LANG("obj.fa9e1215f765f64f", null)))
	if(do_after(user, 10 SECONDS, src))
		if(prob(10))
			balloon_alert(user, LANG("obj.69fadbfddfc8a2f7", null))
			if(prob(1))
				do_sparks(5, TRUE, loc, spark_type = /datum/effect_system/basic/spark_spread/quantum)
				new /obj/item/disk/nuclear/fake(loc)
			else
				// New epic way of making money. Totally
				new /obj/item/coin/iron(loc)
		else
			balloon_alert(user, LANG("obj.c9ed5d89e1fa7c64", null))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
