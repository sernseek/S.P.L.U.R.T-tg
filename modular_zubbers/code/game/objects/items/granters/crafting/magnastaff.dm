// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/book/granter/crafting_recipe/stunstaff_prime
	name = "diary of a lonely warden"
	desc = "A relatively clean diary. It reeks of pepperspray and copper."
	crafting_recipe_types = list(
		/datum/crafting_recipe/stunstaff_prime
	)
	icon_state = "book1"
	remarks = list(
		"It gets pretty lonely sitting in the brig all shift, doesn't it...?",
		"With all that time on time on your hands, you're bound to come up with something.",
		"A more effective way to apply police brutality...",
		"Overcharge the capacitors... apply a titanium reinforcement...",
		"Why not just use a gun instead?",
		"Ah yes, jam the staff right into an APC. What could go wrong?",
		"It recharges HOW fast between attacks?",
	)

/obj/item/book/granter/crafting_recipe/stunstaff_prime/recoil(mob/living/user)
	to_chat(user, span_warning(LANG("obj.00d3a38ea0112407", null)))
	qdel(src)
