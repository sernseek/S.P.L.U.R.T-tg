// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Copy and paste of monkey's super kitty ears
/obj/item/organ/ears/cat/super
	name = "Super Kitty Ears"
	desc = "A pair of kitty ears that harvest the true energy of cats. Mrow!"
	icon = 'modular_zubbers/icons/obj/clothing/head/costume.dmi'
	icon_state = "superkitty"
	decay_factor = 0
	damage_multiplier = 0.5 // SUPER
	organ_flags = ORGAN_HIDDEN
	/// The instance of kitty form spell given to the user.
	/// The spell will be initialized using the initial typepath.
	var/datum/action/cooldown/spell/shapeshift/kitty/kitty_spell = /datum/action/cooldown/spell/shapeshift/kitty

/obj/item/organ/ears/cat/super/Initialize(mapload)
	if(ispath(kitty_spell))
		kitty_spell = new kitty_spell(src)
	else
		stack_trace("kitty_spell is invalid typepath ([kitty_spell || "null"])")
	return ..()

/obj/item/organ/ears/cat/super/Destroy()
	QDEL_NULL(kitty_spell)
	return ..()

/obj/item/organ/ears/cat/super/attack(mob/target_mob, mob/living/carbon/user, obj/target)
	if(target_mob != user || !implant_on_use(user))
		return ..()

/obj/item/organ/ears/cat/super/attack_self(mob/user, modifiers)
	implant_on_use(user)
	return ..()

/obj/item/organ/ears/cat/super/on_mob_insert(mob/living/carbon/ear_owner)
	. = ..()
	kitty_spell.Grant(ear_owner)

/obj/item/organ/ears/cat/super/on_mob_remove(mob/living/carbon/ear_owner, special = FALSE)
	. = ..()
	kitty_spell.Remove(ear_owner)

// Stole this from demon heart hard, but hey it works
/obj/item/organ/ears/cat/super/proc/implant_on_use(mob/living/carbon/user)
	if(!iscarbon(user) || !user.is_holding(src))
		return FALSE
	user.visible_message(
		span_warning(LANG("obj.cf4e12028ada5cd8", list(user, src, user.p_their(), user.p_their()))),
		span_danger(LANG("obj.e2d912994b9deb19", list(src))),
	)
	playsound(user, 'sound/effects/meow1.ogg', 50, TRUE)

	user.visible_message(
		span_warning(LANG("obj.98bfbb1312d2a180", list(src, user))),
		span_userdanger(LANG("obj.11438dd196c9accf", null)),
	)

	user.temporarilyRemoveItemFromInventory(src, force = TRUE)
	Insert(user)
	return TRUE

// Super syndi kitty ears!
/obj/item/organ/ears/cat/super/syndie
	kitty_spell = /datum/action/cooldown/spell/shapeshift/kitty/syndie
