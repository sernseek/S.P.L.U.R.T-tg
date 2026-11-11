// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/handmirror
	name = "hand mirror"
	desc = "A cheap plastic hand mirror. Useful for shaving and self-diagnoses"
	icon = 'modular_zzplurt/icons/obj/items_and_weapons.dmi'
	icon_state = "handmirror"
	w_class = WEIGHT_CLASS_SMALL
	force = 2
	throwforce = 2
	throw_speed = 3
	throw_range = 6

/obj/item/handmirror/attack_self(mob/user)
	ADD_TRAIT(user, TRAIT_SELF_AWARE, "mirror_trait")
	to_chat(user, span_notice(LANG("obj.c9564ec0feac9de3", null)))
	sleep(15 SECONDS)
	REMOVE_TRAIT(user, TRAIT_SELF_AWARE, "mirror_trait")
