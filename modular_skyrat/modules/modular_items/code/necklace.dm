// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//DEFAULT NECK ITEMS OVERRIDE//
/obj/item/clothing/neck
	w_class = WEIGHT_CLASS_SMALL

//ASHWALKER TRANSLATOR NECKLACE//
#define LANGUAGE_TRANSLATOR "translator"
/obj/item/clothing/neck/necklace/ashwalker
	name = "ashen necklace"
	desc = "A necklace crafted from ash, connected to the Necropolis through the core of a Legion. This imbues overdwellers with an unnatural understanding of Ashtongue, the native language of Lavaland, while worn."
	icon = 'modular_skyrat/master_files/icons/obj/clothing/neck.dmi'
	icon_state = "ashnecklace"
	worn_icon = 'modular_skyrat/master_files/icons/mob/clothing/neck.dmi'
	icon_state = "ashnecklace"
	w_class = WEIGHT_CLASS_SMALL //allows this to fit inside of pockets.

/obj/item/clothing/neck/necklace/ashwalker/cursed
	name = "cursed ashen necklace"
	desc = "A necklace crafted from ash, connected to the Necropolis through the core of a Legion. This imbues overdwellers with an unnatural understanding of Ashtongue, the native language of Lavaland, while worn. Cannot be removed!"

/obj/item/clothing/neck/necklace/ashwalker/cursed/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

//uses code from the pirate hat.
/obj/item/clothing/neck/necklace/ashwalker/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot & ITEM_SLOT_NECK)
		user.grant_language(/datum/language/ashtongue/, source = LANGUAGE_TRANSLATOR)
		to_chat(user, span_boldnotice(LANG("obj.39327431fd995359", null)))

/obj/item/clothing/neck/necklace/ashwalker/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_NECK) == src && !QDELETED(src)) //This can be called as a part of destroy
		user.remove_language(/datum/language/ashtongue/, source = LANGUAGE_TRANSLATOR)
		to_chat(user, span_boldnotice(LANG("obj.1df4a36bd6de74c0", null)))

//ASHWALKER TRANSLATOR NECKLACE END//

#undef LANGUAGE_TRANSLATOR
