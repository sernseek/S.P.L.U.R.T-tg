// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
ADMIN_VERB(generate_quote_of_the_round, R_DEBUG, "生成本轮名言", "Generates a quote of the round for debug purposes.", ADMIN_CATEGORY_DEBUG)

	if(!SSticker.quote_of_the_round_text)
		SSticker.quote_of_the_round_text = "Bitches ain't shit but hoes and tricks."

	if(!SSticker.quote_of_the_round_attribution)
		SSticker.quote_of_the_round_attribution = "Albert Einstein"

	var/message_to_send = SSticker.generate_quote_of_the_round()

	user << browse(message_to_send,"window='quoteoftheround'")
