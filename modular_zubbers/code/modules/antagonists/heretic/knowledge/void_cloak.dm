// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/heretic_knowledge/void_cloak
	desc = "Allows you to transmute a glass shard, a bedsheet, and any outer clothing item (such as armor or a suit jacket) \
		to create a Void Cloak. While the hood is down, the cloak protects you from space. \
		While the hood is up, the cloak is disguised as a gear harness. It also provide decent armor and \
		has pockets which can hold one of your blades, various ritual components (such as organs), and small heretical trinkets."

/obj/item/clothing/suit/hooded/cultrobes/void
	hood_up_affix = ""

/obj/item/clothing/suit/hooded/cultrobes/void/make_invisible(datum/source, obj/item/item, slot)
	if(isliving(loc))
		loc.remove_traits(list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTCOLD), REF(src))
		REMOVE_TRAIT(loc, TRAIT_RESISTLOWPRESSURE, REF(src))
		loc.balloon_alert(loc, LANG("obj.3bdb409b8659c821", null))
		loc.visible_message(span_notice(LANG("obj.c9b4a64a97a9d20c", list(loc))))

	name = /obj/item/clothing/suit/misc/suit_harness::name
	desc = /obj/item/clothing/suit/misc/suit_harness::desc
	icon = /obj/item/clothing/suit/misc/suit_harness::icon
	icon_state = /obj/item/clothing/suit/misc/suit_harness::icon_state
	worn_icon = /obj/item/clothing/suit/misc/suit_harness::worn_icon
	worn_icon_state = /obj/item/clothing/suit/misc/suit_harness::worn_icon_state

	update_appearance()
	update_slot_icon()

/obj/item/clothing/suit/hooded/cultrobes/void/make_visible(datum/source, obj/item/item, slot)
	if(isliving(loc))
		loc.add_traits(list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTCOLD), REF(src))
		loc.balloon_alert(loc, LANG("obj.22eedd86eb95eba9", null))
		loc.visible_message(span_notice(LANG("obj.bf8a7b81c5e6ba6e", list(loc))))

	name = initial(src.name)
	desc = initial(src.desc)
	icon = initial(src.icon)
	icon_state = initial(src.icon_state)
	worn_icon = initial(src.worn_icon)
	worn_icon_state = initial(src.worn_icon_state)

	update_appearance()
	update_slot_icon()

/obj/item/clothing/suit/hooded/cultrobes/void/examine(mob/user)
	. = ..()

	if (hood_up && IS_HERETIC(user))
		. += span_notice(LANG("obj.22bbf4d04de1a0f1", list(EXAMINE_HINT("Void Cloak"))))
