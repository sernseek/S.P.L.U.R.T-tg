/datum/unit_test/splurt_i18n

/datum/unit_test/splurt_i18n/Run()
	if(GLOB.i18n_server_locale != LANGUAGE_LOCALE_ZH_HANS)
		return
	var/message = mkultra_cmd_text("cum_lock", "lock_master", list("target" = "TestName"))
	TEST_ASSERT(findtext(message, "TestName"), "Localized MKUltra messages must retain substituted player names.")
	TEST_ASSERT(!findtext(message, "{target}"), "MKUltra message placeholders must be replaced.")
	TEST_ASSERT(!findtext(message, "You lock"), "MKUltra messages must be localized before substituting names.")
