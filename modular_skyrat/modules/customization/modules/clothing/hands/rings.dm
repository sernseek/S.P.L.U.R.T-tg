// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/gloves/ring
	icon = 'modular_skyrat/master_files/icons/obj/ring.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/hands.dmi'
	name = "gold ring"
	desc = "A tiny gold ring, sized to wrap around a finger."
	gender = NEUTER
	w_class = WEIGHT_CLASS_TINY
	icon_state = "ringgold"
	inhand_icon_state = null
	worn_icon_state = "gring"
	body_parts_covered = 0
	resistance_flags = FIRE_PROOF
	strip_delay = 4 SECONDS
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/ring/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide(LANG("obj.792c2a0b525e9d8a", list(src, user.p_their(), user, src))))
	return OXYLOSS


/obj/item/clothing/gloves/ring/diamond
	name = "diamond ring"
	desc = "An expensive ring, studded with a diamond. Cultures have used these rings in courtship for a millenia."
	icon_state = "ringdiamond"
	worn_icon_state = "dring"

/obj/item/clothing/gloves/ring/diamond/attack_self(mob/user)
	user.visible_message(span_warning(LANG("obj.5b9c53144ecd2ed1", list(user, src))),span_warning(LANG("obj.a2e1c01e3ba95ed5", list(src))))

/obj/item/clothing/gloves/ring/silver
	name = "silver ring"
	desc = "A tiny silver ring, sized to wrap around a finger."
	icon_state = "ringsilver"
	worn_icon_state = "sring"
