// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
GAME_VERB(/client, check_antag_tickets, "查看反派工单", "OOC")
	var/antag_ticket_rate = CONFIG_GET(number/antag_tickets_per_update)

	if(!antag_ticket_rate)
		to_chat(src,span_notice(LANG("client.7d4c251377aa8356", null)))
		return

	var/antag_ticket_count = get_antag_tickets()
	var/antag_ticket_gain = antag_ticket_multiplier()*antag_ticket_rate

	to_chat(src,span_notice(LANG("client.fcc07b597e33fb99", list(antag_ticket_count, antag_ticket_gain >= 0 ? "gaining" : "losing", abs(antag_ticket_gain), DisplayTimeText(SSblackbox.wait,1)))))

GAME_VERB(/client, antag_tickets_info, "什么是反派工单？", "OOC")
	var/antag_ticket_rate = CONFIG_GET(number/antag_tickets_per_update)

	if(!antag_ticket_rate)
		to_chat(src, span_notice(LANG("client.e4dd55bae34246ac", null)))
		return

	var/information = "\
	Antag tickets are a way to balance playtime between being an antagonist and being a non-antagonist. \
	Having more antag tickets makes you more likely to be chosen as an antagonist, while having less makes you less likely to be chosen as one. \
	Antag tickets are gained when you're playing as a crew role while not being an antagonist, while antag tickets are spent when you're playing as an antagonist. \
	Note that as an antagonist, you do not lose antag tickets when you're handcuffed, restrained, dead, crit, incapacitated, or in prison."

	to_chat(src,span_notice(information))
