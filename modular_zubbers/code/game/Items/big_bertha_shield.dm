// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/shield/big_bertha
	name = "Big Bertha"
	desc = "A shield so fat and heavy, it should block just about anything, as long as you have the stamina for it."
	icon = 'modular_zubbers/icons/obj/big_bertha_shield.dmi'
	lefthand_file = 'modular_zubbers/icons/mob/inhands/big_bertha_both.dmi'
	righthand_file = 'modular_zubbers/icons/mob/inhands/big_bertha_both.dmi'
	icon_state = "big_bertha"
	block_chance = 100
	slot_flags = null
	force = 12
	throwforce = 3
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_continuous = list("shoves", "bashes","berthas")
	attack_verb_simple = list("shove", "bash","bertha")
	armor_type = /datum/armor/big_bertha
	block_sound = 'sound/items/weapons/block_shield.ogg'
	breakable_by_damage = FALSE
	item_flags = IMMUTABLE_SLOW | SLOWS_WHILE_IN_HAND
	slowdown = 2
	transparent = FALSE

/obj/item/shield/big_bertha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands = TRUE)
	RemoveElement(/datum/element/disarm_attack)

/obj/item/shield/big_bertha/on_shield_block(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)

	. = ..()

	if(damage < 10) //Most things that deal 10 or more damage are heavy, like toolboxes.
		return

	if(prob(owner.get_stamina_loss()))
		owner.visible_message(
			span_warning(LANG("obj.597dc5c10e64e5f8", list(attack_text, hitby, owner))),
			span_userdanger(LANG("obj.02b74e95b578edd0", list(attack_text, hitby))),
			span_notice(LANG("obj.f4a69f8888a0a376", null)),
			COMBAT_MESSAGE_RANGE
		)
		owner.Knockdown(2 SECONDS) //The shield saved you, but at what cost?

	owner.adjust_stamina_loss(damage*0.5)
	owner.set_jitter_if_lower(1 SECONDS)
	owner.Immobilize(1 SECONDS)


/datum/armor/big_bertha
	melee = 100
	bullet = 100
	laser = 75
	bomb = 50
	fire = 80
	acid = 70
