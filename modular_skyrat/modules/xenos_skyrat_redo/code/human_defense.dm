// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// SKYRAT MODULE SKYRAT_XENO_REDO

/mob/living/carbon/human/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	. = ..()
	if(!.)
		return

	if(LAZYACCESS(modifiers, RIGHT_CLICK)) //Always drop item in hand, if no item, get stun instead.
		var/obj/item/mob_held_item = get_active_held_item()
		var/disarm_damage = rand(user.melee_damage_lower * 1.5, user.melee_damage_upper * 1.5)

		if(mob_held_item)

			if(check_block(user, damage = 0, attack_text = "[user.name]"))
				playsound(loc, 'sound/items/weapons/parry.ogg', 25, TRUE, -1) //Audio feedback to the fact you just got blocked
				apply_damage(disarm_damage / 2, STAMINA)
				visible_message(span_danger(LANG("mob.037cd05a333459e3", list(user, src))), \
					span_danger(LANG("mob.b6efcc7002a14b4d", list(user))), span_hear(LANG("mob.b8189c1ed616b3a4", null)), null, user)
				to_chat(user, span_warning(LANG("mob.58bf0cb652c40ee0", list(src))))
				return FALSE

			playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 25, TRUE, -1) //The sounds of these are changed so the xenos can actually hear they are being non-lethal
			Knockdown(3 SECONDS)
			apply_damage(disarm_damage, STAMINA)
			visible_message(span_danger(LANG("mob.b28257ff017a2b6e", list(user, src))), \
				span_userdanger(LANG("mob.f835f12eb2f64f6a", list(user))), span_hear(LANG("mob.5c62ec13ae99a18d", null)), null, user)
			to_chat(user, span_danger(LANG("mob.f940e5d333cedcf7", list(src))))
			return TRUE

		else
			playsound(loc, 'sound/effects/hit_kick.ogg', 25, TRUE, -1)
			apply_damage(disarm_damage, STAMINA)
			log_combat(user, src, "tackled")
			visible_message(span_danger(LANG("mob.694c58a4f0ee8898", list(user, src))), \
							span_userdanger(LANG("mob.cdbc888efca61e86", list(user))), span_hear(LANG("mob.7314bbd171d7d8b7", null)), null, user)
			to_chat(user, span_danger(LANG("mob.366dfec36069609e", list(src))))

		return TRUE

	if(user.combat_mode)
		if(w_uniform)
			w_uniform.add_fingerprint(user)

		var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(user.zone_selected))

		if(!affecting)
			affecting = get_bodypart(BODY_ZONE_CHEST)

		var/armor_block = run_armor_check(affecting, MELEE,"","",10)

		playsound(loc, 'sound/items/weapons/slice.ogg', 25, TRUE, -1)
		visible_message(span_danger(LANG("mob.f626309960b4cb84", list(user, src))), \
						span_userdanger(LANG("mob.69901f7d4c5703dd", list(user))), span_hear(LANG("mob.0a6af96cd2e31bc4", null)), null, user)
		to_chat(user, span_danger(LANG("mob.131938c9a2fead1f", list(src))))
		log_combat(user, src, "attacked")

		if(!dismembering_strike(user, user.zone_selected)) //Dismemberment successful
			return TRUE

		apply_damage(damage, BRUTE, affecting, armor_block)
