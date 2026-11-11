// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/pen/attack(mob/living/M, mob/living/user, params)
	. = ..()

	if(!. || !istype(M) || !istype(user) || force || user.combat_mode)
		return

	INVOKE_ASYNC(src, PROC_REF(write_on_bodypart), M, user, params) // Necessary because signals??????

/obj/item/pen/proc/write_on_bodypart(mob/living/M, mob/living/user, params)
	var/obj/item/bodypart/selected_bodypart = null

	var/list/obj/item/organ/genital/possible_genitals = list()
	for(var/genital_slot in GLOB.possible_genitals)
		var/obj/item/organ/genital/ORG = M.get_organ_slot(genital_slot)
		if(ORG?.bodypart_overlay.sprite_datum.is_hidden(M))
			continue
		possible_genitals += ORG

	if(length(possible_genitals))
		selected_bodypart = tgui_input_list(user, LANG("obj.bf682f25ca248702", list(user == M ? "your" : "[M]'s", user.zone_selected)), LANG("obj.b88b28ee70359c02", null), possible_genitals)

	if(!selected_bodypart)
		var/obj/item/bodypart/BP = M.get_bodypart(user.zone_selected)
		if(!BP)
			return
		selected_bodypart = M.is_body_part_exposed(BP.body_part) ? BP : null

	if(!selected_bodypart)
		return

	var/writing = tgui_input_text(user, LANG("obj.a946bca606297aa2", null), LANG("obj.b6816b248c0964ff", list(selected_bodypart.name)))
	if(!writing)
		return
	to_chat(user, span_notice(LANG("obj.1dfa7ce80d1ce674", list(writing, user == M ? "your" : "[M]'s", selected_bodypart.name))))
	selected_bodypart.written_text += writing

/obj/item/pen/fountain/centcom
	name = "centcom fountain pen"
	desc = "It's a priceless green fountain pen. The nib is quite sharp. The case is made of emerald and gold, extremely regal. "
	icon = 'modular_zzplurt/icons/obj/service/bureaucracy.dmi'
	icon_state = "pen-centcom"
	colour = "#18610D"
	custom_materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*7.5)

/obj/item/pen/fountain/centcom/silver
	desc = "It's a expensive green fountain pen. The nib is quite sharp. The case is made of emerald and silver, extremely regal. "
	icon_state = "pen-centcom_silver"
	custom_materials = list(/datum/material/silver = SMALL_MATERIAL_AMOUNT*7.5)
