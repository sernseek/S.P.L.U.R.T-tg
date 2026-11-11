// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// For applying a normalization
/obj/item/clothing/proc/normalize_mob_size(mob/living/carbon/human/resizer)
	if(resizer.normalized)
		to_chat(resizer, span_danger(LANG("obj.421f5254e997d98d", null)))
		playsound(resizer, 'sound/machines/buzz/buzz-sigh.ogg', 50, 1)
		return
	playsound(resizer, 'sound/effects/magic.ogg', 50, 1)
	flash_lighting_fx(3, 3, LIGHT_COLOR_PURPLE)
	resizer.visible_message(span_warning(LANG("obj.7dd9a6d076777735", list(resizer))), span_notice(LANG("obj.19f1a98c1d3d82d9", null)))
	if(resizer.get_quirk(/datum/quirk/oversized))
		resizer.remove_quirk(/datum/quirk/oversized)
	else
		//SPLURT EDIT CHANGE BEGIN - SIZECODE - Prefer update_size so size HP/mob_size hooks apply
		//resizer.update_transform(RESIZE_DEFAULT_SIZE / resizer?.client?.prefs?.read_preference(/datum/preference/numeric/body_size)) - SPLURT EDIT - ORIGINAL
		resizer.update_size(RESIZE_DEFAULT_SIZE)
		//SPLURT EDIT CHANGE END
	resizer.normalized = TRUE

/// For removing a normalization, and reverting back to normal
/obj/item/clothing/proc/denormalize_mob_size(mob/living/carbon/human/resizer)
	if(resizer.normalized)
		playsound(resizer,'sound/items/weapons/emitter2.ogg', 50, 1)
		flash_lighting_fx(3, 3, LIGHT_COLOR_YELLOW)
		resizer.visible_message(span_warning(LANG("obj.41c6d9b5e2d3570a", list(resizer))), span_notice(LANG("obj.44ce323eef39f139", null)))
		for(var/quirk in resizer?.client?.prefs?.all_quirks)
			if(quirk == "Oversized")
				resizer.add_quirk(/datum/quirk/oversized, announce = FALSE)
				break
		if(!resizer.get_quirk(/datum/quirk/oversized))
			//SPLURT EDIT CHANGE BEGIN - SIZECODE - Prefer update_size so size HP/mob_size hooks apply
			//resizer.update_transform(resizer?.client?.prefs?.read_preference(/datum/preference/numeric/body_size)) - SPLURT EDIT - ORIGINAL
			resizer.update_size(resizer?.client?.prefs?.read_preference(/datum/preference/numeric/body_size) || RESIZE_DEFAULT_SIZE)
			//SPLURT EDIT CHANGE END
		resizer.normalized = FALSE
