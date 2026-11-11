// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Numbing effects

/datum/reagent/consumable/ethanol/drunken_espatier
	metabolized_traits = list(TRAIT_ANALGESIA)

//Changeling balancing
/datum/reagent/medicine/rezadone/expose_mob(mob/living/carbon/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!istype(exposed_mob))
		return
	if(HAS_TRAIT_FROM(exposed_mob, TRAIT_HUSK, CHANGELING_DRAIN) && (exposed_mob.reagents.get_reagent_amount(/datum/reagent/medicine/rezadone) + reac_volume >= 20))//Costs a little more than a normal husk
		exposed_mob.cure_husk(CHANGELING_DRAIN)
		exposed_mob.visible_message(LANG("datum.59ebe686b0ab3f84", list(exposed_mob, exposed_mob)))

/datum/reagent/medicine/regen_jelly/expose_mob(mob/living/carbon/human/exposed_mob, reac_volume)
	. = ..()
	if(!istype(exposed_mob) || (reac_volume < 0.5))
		return

	exposed_mob.update_body_parts()
