// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/head/domina_cap
	name = "dominant cap"
	desc = "For special types of inspections."
	icon_state = "dominacap"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_hats.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_hats.dmi'
	supports_variations_flags = NONE

//message when equipping that thing
/obj/item/clothing/head/domina_cap/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(src == user.head)
		to_chat(user, span_purple(LANG("obj.45b37ba15fc2c01b", null)))

//message when unequipping that thing
/obj/item/clothing/head/domina_cap/dropped(mob/living/carbon/human/user)
	. = ..()
	if(src == user.head)
		to_chat(user, span_purple(LANG("obj.7d35038710219422", null)))
