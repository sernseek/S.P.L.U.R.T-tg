// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/clothing/wrists/clockwork_watch
	name = "steampunk watch"
	desc = "A stylish steampunk watch made out of thousands of tiny cogwheels."
	gender = MALE
	icon_state = "clockwork_slab"
	body_parts_covered = HAND_LEFT | ARM_LEFT
	attack_verb_simple = list("showed the time to")

/obj/item/clothing/wrists/clockwork_watch/examine(mob/user)
	. = ..()
	. += span_info(LANG("obj.7a025a3420f27f29", list(server_timestamp(ic_time = TRUE, twelve_hour_clock = user.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour)))))
	if(user.is_literate())
		. += span_info(LANG("obj.f5c79a87073cc118", list(round_timestamp())))

/obj/item/clothing/wrists/clockwork_watch/attack(mob/target, mob/user)
	. = ..()
	to_chat(target, span_info(LANG("obj.7a025a3420f27f29", list(server_timestamp(ic_time = TRUE, twelve_hour_clock = user.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))))))
