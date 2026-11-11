// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/structure/window/fulltile/colony_fabricator
	name = "prefabricated window"
	desc = "A conservatively built metal frame with a thick sheet of space-grade glass slotted into it."
	icon = 'modular_skyrat/modules/colony_fabricator/icons/prefab_window.dmi'
	icon_state = "prefab-0"
	base_icon_state = "prefab"
	fulltile = TRUE
	glass_type = /obj/item/stack/sheet/plastic_wall_panel
	glass_amount = 1
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)

/obj/structure/grille/attackby(obj/item/item_in_question, mob/user, params)
	if(!istype(item_in_question, /obj/item/stack/sheet/plastic_wall_panel))
		return ..()

	if(broken)
		return
	var/obj/item/stack/stack_in_question = item_in_question
	if(stack_in_question.get_amount() < 1)
		to_chat(user, span_warning(LANG("obj.9f79a16eacba52b1", null)))
		return
	var/dir_to_set = SOUTHWEST
	if(!anchored)
		to_chat(user, span_warning(LANG("obj.79102fe36de4f058", list(src))))
		return
	for(var/obj/structure/window/window_on_turf in loc)
		to_chat(user, span_warning(LANG("obj.a3c6a7b7ec1e883d", null)))
		return
	if(!clear_tile(user))
		return
	to_chat(user, span_notice(LANG("obj.1c659472f7175207", null)))
	if(!do_after(user, 1 SECONDS, target = src))
		return
	if(!src.loc || !anchored) //Grille broken or unanchored while waiting
		return
	for(var/obj/structure/window/window_on_turf in loc) //Another window already installed on grille
		return
	if(!clear_tile(user))
		return
	var/obj/structure/window/new_window = new /obj/structure/window/fulltile/colony_fabricator(drop_location())
	new_window.setDir(dir_to_set)
	new_window.state = 0
	stack_in_question.use(1)
	to_chat(user, span_notice(LANG("obj.7a67ae81e5981d09", list(new_window, src))))
