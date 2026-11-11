// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/uplink_item/species_restricted/lycan_booster
	name = "Lycanthropy Booster"
	desc = "A highly advanced mix of nanomachines and general 'bad vibes' that will significantly boost the combat performance of your \
	Lycan form, granting significant damage resistance, baton resistance, regeneration, and further sharpening your claws. Additionally grants you expert fitness."
	cost = 15
	item = /obj/item/lycan_booster
	restricted_species = list(SPECIES_CURSEKIN)
	surplus = 0

/obj/item/lycan_booster
	name = "lycanthropy booster"
	desc = "A highly advanced mix of nanomachines and general 'bad vibes' that will significantly boost the combat performance of your \
	Lycan form, granting significant damage resistance, baton resistance, regeneration, and further sharpening your claws, along other improvements. \
	Additionally grants you expert fitness."
	icon = 'icons/obj/medical/syringe.dmi'
	icon_state = "dnainjector"
	inhand_icon_state = "dnainjector"
	worn_icon_state = "pen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY

/obj/item/lycan_booster/attack_self(mob/user, modifiers)
	. = ..()

	if (!ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user

	if (!istype(human_user.dna?.species, /datum/species/human/cursekin))
		to_chat(human_user, span_warning(LANG("obj.021e68cadcb2cef5", null)))
		return

	to_chat(human_user, span_bolddanger(LANG("obj.e30ca7bb4503d672", null)))
	human_user.add_gaian_physique()

	qdel(src)

/mob/living/carbon/human/proc/add_gaian_physique()
	ADD_TRAIT(src, TRAIT_GAIAN_PHYSIQUE, SPECIES_TRAIT)

	balloon_alert(src, LANG("mob.0c6ddb2db06d558d", null))
	to_chat(src, span_boldnotice(LANG("mob.430038e44560f0da", null)))
	emote("growl")

	mind?.adjust_experience(/datum/skill/athletics, SKILL_EXP_MASTER, FALSE)
