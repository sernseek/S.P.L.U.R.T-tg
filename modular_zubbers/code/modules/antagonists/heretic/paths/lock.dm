// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/heretic_labyrinth_handbook/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.087e4bf6484ecc94", null))

/datum/heretic_knowledge_tree_column/lock
	description = list(
		"The Path of Lock revolves around access, area denial, theft and gadgets.",
		"Pick this path if you are new to heretic, or want a less confrontational playstyle and more interested in being a slippery rat.",
	)

/obj/effect/lock_portal/Initialize(mapload, target, invert = FALSE)
	. = ..()

	RegisterSignal(src, COMSIG_ATOM_HOLYATTACK, PROC_REF(on_holy_attack))

/obj/effect/lock_portal/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.05286e79d7aecd1f", null))
	. += span_notice(LANG("obj.b04e3baaaca93af4", null))

/obj/effect/lock_portal/proc/on_holy_attack(datum/source, obj/item/weapon)
	SIGNAL_HANDLER

	visible_message(span_warning(LANG("obj.c29e161464d42695", list(weapon, src))))
	qdel(src)

/datum/status_effect/caretaker_refuge
	duration = 60 SECONDS

/datum/action/cooldown/spell/caretaker
	name = "Caretaker's Last Refuge"
	desc = "Shifts you into the Caretaker's Refuge, rendering you translucent and intangible. \
		While in the Refuge your movement is unrestricted, but you cannot use your hands or cast any spells. \
		You cannot enter the Refuge while near other sentient beings, \
		and you can be removed from it upon contact with antimagical artifacts. \
		Lasts for one minute."

/datum/action/cooldown/spell/pointed/burglar_finesse/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/turf/in_LOS = get_hearers_in_LOS(cast_range, owner)
	if (!(cast_on in in_LOS))
		owner.balloon_alert(owner, LANG("datum.bb5a69ab6a6cc3b0", null))
		return SPELL_CANCEL_CAST
