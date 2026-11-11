// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/round_event/gravity_generator_blackout
	announce_when = 3
	start_when = 1
	announce_chance = 100

/datum/round_event/gravity_generator_blackout/announce(fake)
	priority_announce(LANG("datum.e58eb96ec11d7abe", list(station_name())), LANG("datum.9245c6e22bc89b75", list(command_name())), ANNOUNCER_GRAVGENBLACKOUT)
