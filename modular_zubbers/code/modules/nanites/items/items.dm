// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/nanite_scanner
	name = "nanite scanner"
	icon = 'modular_zubbers/icons/obj/devices/nanite_devices.dmi'
	icon_state = "nanite_scanner"
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	desc = "A hand-held body scanner able to detect nanites and their programming."
	custom_materials = list(/datum/material/glass = 500, /datum/material/iron = 500)
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7

/obj/item/nanite_scanner/attack(mob/living/M, mob/living/carbon/human/user)
	user.visible_message(
		span_notice(LANG("obj.4ad9216e40631098", list(user, M))),
		span_notice(LANG("obj.79e787219ae48215", list(M)))
	)

	add_fingerprint(user)

	var/response = SEND_SIGNAL(M, COMSIG_NANITE_SCAN, user, TRUE)
	if(!response)
		to_chat(user, span_info(LANG("obj.532e0bf981260def", null)))

/obj/item/storage/box/disks_nanite
	name = "nanite program disks box"
	illustration = "disk_kit"

/obj/item/storage/box/disks_nanite/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/disk/nanite_program(src)

/obj/item/nanite_injector
	name = "nanite injector"
	desc = "Injects nanites into the user."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'modular_zubbers/icons/obj/devices/nanite_devices.dmi'
	icon_state = "nanite_remote"

/obj/item/nanite_injector/attack_self(mob/user)
	user.AddComponent(/datum/component/nanites, 150)
