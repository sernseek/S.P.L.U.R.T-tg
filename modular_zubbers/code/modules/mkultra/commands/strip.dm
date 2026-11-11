// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/mkultra_command/strip
	name = "Strip"
	description = "Have your enthralled strip for you."
	feedback = "strips off all their clothes."
	trigger = "strip|remove your clothes|derobe|nude"
	phase_requirement = 2
	erp_command = TRUE
	cooldown = 20 SECONDS

/datum/mkultra_command/strip/execute(datum/status_effect/mkultra/status, mob/owner, mob/source, message)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/person = owner
	var/obj/item/items = owner.get_contents()
	for(var/obj/item/stuff in items)
		if(stuff == person.wear_suit)
			person.dropItemToGround(stuff)
			continue
		if(stuff == person.w_uniform)
			person.dropItemToGround(stuff)
			continue
	to_chat(person, span_userlove(LANG("datum.c50ae9abdf4305cd", list(status.get_gender()))))
