// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/seed_mesh
	name = "seed mesh"
	desc = "A little mesh that, when paired with sand, has the possibility of filtering out large seeds."
	icon = 'modular_skyrat/modules/ashwalkers/icons/misc_tools.dmi'
	icon_state = "mesh"
	var/static/list/seeds_blacklist = list(
		/obj/item/seeds/lavaland,
	)

/obj/item/seed_mesh/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/stack/ore/glass))
		var/obj/item/stack/ore/ore_item = attacking_item
		if(ore_item.points == 0)
			user.balloon_alert(user, LANG("obj.80034cf0734c7fee", list(ore_item)))
			return

		var/ore_usage = 5
		while(ore_item.amount >= ore_usage)
			var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
			if(!do_after(user, 5 SECONDS * skill_modifier, src))
				user.balloon_alert(user, LANG("obj.e11afae0e63df866", null))
				return

			if(prob(user.mind.get_skill_modifier(/datum/skill/primitive, SKILL_PROBS_MODIFIER)))
				ore_usage = 3

			if(!ore_item.use(ore_usage))
				user.balloon_alert(user, LANG("obj.04cf9a5eae93a37b", list(ore_item)))
				return

			user.mind?.adjust_experience(/datum/skill/primitive, 5)
			if(prob(70))
				user.balloon_alert(user, LANG("obj.a6d3522268b77b91", list(ore_item)))
				continue

			var/spawn_seed = pick(subtypesof(/obj/item/seeds) - seeds_blacklist)
			new spawn_seed(get_turf(src))
			user.mind?.adjust_experience(/datum/skill/primitive, 10)
			user.balloon_alert(user, LANG("obj.c977610f76f3e8b4", list(ore_item)))

	return ..()
