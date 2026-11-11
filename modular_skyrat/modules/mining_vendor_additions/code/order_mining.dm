// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/orderable_item/mining/survival_bodybag
	purchase_path = /obj/item/bodybag/environmental
	cost_per_order = 500

/datum/orderable_item/mining/suit_voucher
	purchase_path = /obj/item/suit_voucher
	cost_per_order = 2000

/obj/item/kinetic_crusher/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_OBJ_RESKIN, PROC_REF(on_reskin))

/obj/item/kinetic_crusher/proc/on_reskin(mob/our_mob)
	SIGNAL_HANDLER
	if(icon_state == "crusher_glaive")
		name = "proto-kinetic glaive"
		desc = LANG("obj.75b5a736be2a4091", null)
		attack_verb_continuous = list("slices", "slashes", "cleaves", "chops", "stabs")
		attack_verb_simple = list("slice", "slash", "cleave", "chop", "stab")
		inhand_x_dimension = 64
		inhand_y_dimension = 64
		our_mob.update_held_items()
