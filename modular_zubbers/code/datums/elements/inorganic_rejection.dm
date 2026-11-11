// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/element/inorganic_rejection
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/inorganic_rejection/Attach(mob/living/target)
	. = ..()
	if(!istype(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(organ_reject))

/datum/element/inorganic_rejection/Detach(mob/living/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_CARBON_GAIN_ORGAN)

/datum/element/inorganic_rejection/proc/organ_reject(mob/living/source, obj/item/organ/inserted)
	SIGNAL_HANDLER
	if(isnull(source))
		return
	var/obj/item/organ/insert_organ = inserted
	if(istype(insert_organ, /obj/item/organ/heart/gland)) /// So we don't reject abductor organs.
		return
	if(!(insert_organ.organ_flags & ORGAN_ROBOTIC))
		return
	addtimer(CALLBACK(src, PROC_REF(reject_now), source, inserted), 1 SECONDS)

/datum/element/inorganic_rejection/proc/reject_now(mob/living/source, obj/item/organ/organ)
	organ.Remove(source)
	organ.forceMove(get_turf(source))
	to_chat(source, span_danger(LANG("datum.427ddff45515f6df", list(organ))))
	organ.balloon_alert_to_viewers(LANG("datum.c10edb676d93174f", null), vision_distance = 1)
