// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/sbeacondrop/carrot
	name = "carrot phone"
	icon = 'icons/obj/antags/syndicate_tools.dmi'
	icon_state = "suspiciousphone"
	desc = "A cell phone with an in-coming call from someone simply labelled 'Lady Jab'. A small sticker on the back notes that any calls to French overlords will incur a 5 credit service charge."
	w_class = WEIGHT_CLASS_SMALL
	droptype = /obj/item/storage/backpack/satchel/bunnysatchel

/obj/item/sbeacondrop/carrot/attack_self(mob/user)
	if(user)
		to_chat(user, span_notice(LANG("obj.806fabd56c8667a1", null)))
		new droptype( user.loc )
		playsound(src, 'sound/mobs/non-humanoids/mouse/mousesqueek.ogg', 100, TRUE, TRUE)
		qdel(src)
	return
