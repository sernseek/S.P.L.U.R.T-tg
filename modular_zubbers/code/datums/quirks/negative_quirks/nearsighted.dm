// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/prescription_lenses
	name = "spare lens kit"
	desc = "Little toolbox with some spare prescription lenses, with everything you need to switch out old lenses on glasses."
	icon = 'modular_zubbers/icons/obj/items_and_weapons.dmi'
	icon_state = "prescriptionkit"

/obj/item/prescription_lenses/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /obj/item/clothing/glasses))
		to_chat(user, span_warning(LANG("obj.5516809149967811", null)))
		return ITEM_INTERACT_SKIP_TO_ATTACK

	var/obj/item/clothing/glasses = interacting_with
	if(TRAIT_NEARSIGHTED_CORRECTED in glasses.clothing_traits)
		to_chat(user, span_warning(LANG("obj.658d3f78a9079939", null)))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.ff73f7524650d85d", list(interacting_with))))
	glasses.attach_clothing_traits(TRAIT_NEARSIGHTED_CORRECTED)
	glasses.name = "prescription [glasses.name]"
	glasses.desc += " These seem to have prescription lenses inserted in them."
	qdel(src)
	return ITEM_INTERACT_SUCCESS
