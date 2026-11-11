// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/carbon/human/get_medhud_examine_info(mob/living/user, datum/record/crew/target_record)
	. = ..()

	if (target_record?.past_medical_records)
		. += LANG("mob.068e479e35c3c007", list(REF(src), world.time))
	if (target_record?.past_general_records)
		. += LANG("mob.66dc1bfb01f57d56", list(REF(src), world.time))

/mob/living/carbon/human/get_sechud_examine_info(mob/living/user, datum/record/crew/target_record)
	. = ..()

	if (target_record?.past_security_records)
		. += LANG("mob.02f6be9a30450e5c", list(REF(src), world.time))
	if (target_record?.past_general_records)
		. += LANG("mob.66dc1bfb01f57d56", list(REF(src), world.time))
