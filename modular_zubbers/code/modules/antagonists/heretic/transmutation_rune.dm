// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/effect/heretic_rune/add_fingerprint(...)
	return

/obj/effect/heretic_rune/add_fingerprint_list(...)
	return

/obj/effect/heretic_rune/wash(clean_types)
	. = ..()

	if (. || clean_types & CLEAN_SCRUB)
		qdel(src)

/obj/effect/heretic_rune/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.a93d020ab9913970", list(EXAMINE_HINT("mansus grasp"), EXAMINE_HINT("rituals"))))
	if (IS_HERETIC(user))
		. += span_notice(LANG("obj.49ab82e0b5bb8dd5", list(EXAMINE_HINT("Drop items"))))
	. += span_notice(LANG("obj.56d23b0696dcc00c", list(EXAMINE_HINT("soap"), EXAMINE_HINT("antimagic item"))))
