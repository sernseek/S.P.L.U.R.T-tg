// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/mecha_part_fabricator/interdyne
	name="Syndicate Branded Exosuit Fabricator"
	link_on_init = FALSE
	circuit=/obj/machinery/mecha_part_fabricator/interdyne

/obj/machinery/mecha_part_fabricator/interdyne/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	if(user.has_faction(ROLE_SYNDICATE))
		obj_flags |= EMAGGED
		for(var/found_illegal_mech_nods in SSresearch.techweb_nodes)
			var/datum/techweb_node/illegal_mech_node = SSresearch.techweb_nodes[found_illegal_mech_nods]
			if(!illegal_mech_node?.illegal_mech_node)
				continue
			for(var/id in illegal_mech_node.design_ids)
				var/datum/design/illegal_mech_design = SSresearch.techweb_design_by_id(id)
//				illegal_local_designs |= illegal_mech_design // Fix this if it's broken after.
				cached_designs |= illegal_mech_design
		say(LANG("obj.f32ee1d20a572fff", null))
		playsound(src, 'sound/machines/uplink/uplinkerror.ogg', 50, TRUE)
		update_static_data_for_all_viewers()
		return TRUE
	else
		to_chat(user, span_warning(LANG("obj.d94d5d618fcd22cd", null)))
		return FALSE

/obj/item/circuitboard/machine/mechfab/interdyne
	name = "Syndicate Exosuit Fabricator"
	build_path = /obj/machinery/mecha_part_fabricator/interdyne

