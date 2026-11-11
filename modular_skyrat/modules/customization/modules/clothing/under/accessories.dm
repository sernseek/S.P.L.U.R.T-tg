// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/accessory/badge
	name = "detective's badge"
	desc = "Security Department detective's badge, made from gold."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "badge"
	slot_flags = ITEM_SLOT_NECK
	attachment_slot = CHEST

	var/stored_name
	var/badge_string = "Corporate Security"

	drop_sound = 'modular_skyrat/master_files/sound/items/drop/ring.ogg'
	pickup_sound = 'modular_skyrat/master_files/sound/items/pickup/ring.ogg'

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/accessories.dmi'
	desc = "A faded badge, backed with leather. It bears the emblem of the Forensic division."
	icon_state = "goldbadge"

/obj/item/clothing/accessory/badge/proc/set_name(new_name)
	stored_name = new_name
	name = "[lang_reverse_text(initial(name))] ([stored_name])"  // i18n: initial(name) 会覆盖掉已反查的中文名

/obj/item/clothing/accessory/badge/proc/set_desc(mob/living/carbon/human/H)

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, LANG("obj.fb943151aefaf33a", null))
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message(span_notice(LANG("obj.15bd911374c246cc", list(user, src.name, stored_name, badge_string))),span_notice(LANG("obj.f2be5adc7115bda6", list(src.name, stored_name, badge_string))))
		else
			user.visible_message(span_notice(LANG("obj.29ea95093e76c281", list(user, src.name, badge_string))),span_notice(LANG("obj.d1ebdd6d2a442c37", list(src.name, badge_string))))

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message(span_danger(LANG("obj.574f1ad77c55d0ae", list(user, M, src))),span_danger(LANG("obj.186df07a5aa2639e", list(M, src))))
		user.do_attack_animation(M)

// Sheriff Badge (toy)
/obj/item/clothing/accessory/badge/sheriff
	name = "sheriff badge"
	desc = "This town ain't big enough for the two of us, pardner."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "sheriff"

/obj/item/clothing/accessory/badge/sheriff/attack_self(mob/user as mob)
	user.visible_message(LANG("obj.e4163f943b91d0cd", list(user)),\
		LANG("obj.7ce0f99d6313ea1c", null))

/obj/item/clothing/accessory/badge/sheriff/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message(span_danger(LANG("obj.2684d6f84bb7b15a", list(user, M))),span_danger(LANG("obj.d128b8a93752b2b8", list(M))))
		user.do_attack_animation(M)

//.Holobadges.
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as THE LAW."
	icon_state = "holobadge_lopland"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/accessories.dmi'

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/accessories.dmi'

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, LANG("obj.97f2822f37cb7bf0", null))
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(remaining_charges, mob/user)
	if(obj_flags & EMAGGED)
		balloon_alert(user, LANG("obj.e609804d7a1296f4", null))
		return FALSE

	obj_flags |= EMAGGED
	balloon_alert(user, LANG("obj.8e75287a9f7a8cfa", null))
	to_chat(user, span_danger(LANG("obj.9a38cfb5527e58b5", null)))
	return TRUE

/obj/item/clothing/accessory/badge/holo/attackby(obj/item/object as obj, mob/user as mob)
	if(istype(object, /obj/item/card/id))

		var/obj/item/card/id/id_card = null

		if(istype(object, /obj/item/card/id))
			id_card = object

		if((ACCESS_SECURITY in id_card.access) || (obj_flags & EMAGGED))
			to_chat(user, LANG("obj.f801131d0303ba94", null))
			set_name(user.real_name)
			badge_string = id_card.assignment
		else
			to_chat(user, LANG("obj.9de51e4b3d8b49b9", list(src)))
		return
	..()

/obj/item/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."

/obj/item/storage/box/holobadge/PopulateContents()
	. = ..()
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo/cord(src)
	new /obj/item/clothing/accessory/badge/holo/cord(src)
	return

/obj/item/clothing/accessory/badge/holo/warden
	name = "warden's holobadge"
	desc = "A silver corporate security badge. Stamped with the words 'Warden.'"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "silverbadge"
	slot_flags = ITEM_SLOT_NECK

/obj/item/clothing/accessory/badge/holo/hos
	name = "head of security's holobadge"
	desc = "An immaculately polished gold security badge. Labeled 'Head of Security.'"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "goldbadge"
	slot_flags = ITEM_SLOT_NECK

/obj/item/clothing/accessory/badge/holo/detective
	name = "detective's holobadge"
	desc = "An immaculately polished gold security badge on leather. Labeled 'Detective.'"
	icon = 'modular_skyrat/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "marshalbadge"
	slot_flags = ITEM_SLOT_NECK

/obj/item/storage/box/holobadge/hos
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."

/obj/item/storage/box/holobadge/hos/PopulateContents()
	. = ..()
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo(src)
	new /obj/item/clothing/accessory/badge/holo/warden(src)
	new /obj/item/clothing/accessory/badge/holo/detective(src)
	new /obj/item/clothing/accessory/badge/holo/detective(src)
	new /obj/item/clothing/accessory/badge/holo/hos(src)
	new /obj/item/clothing/accessory/badge/holo/cord(src)
	return

