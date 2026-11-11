// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/**
 * # Tarkon Produce Orders Console
 *
 * A produce orders console modified to use a specified department account, and only allow express orders
 *
 * This file is based off of order_computer.dm
 * Any changes made to that file should be copied over with discretion
 */

/obj/item/circuitboard/computer/order_console/tarkon
	name = "Tarkon Produce Orders Console"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/computer/order_console/cook/tarkon

/obj/machinery/computer/order_console/cook/tarkon
	name = "Tarkon produce orders console"
	desc = "An interface for ordering fresh produce and other."
	circuit = /obj/item/circuitboard/computer/order_console/tarkon
	blackbox_key = null
	forced_express = TRUE

	/// The account to add balance
	var/credits_account = ACCOUNT_TAR
	/// The resolved bank account
	var/datum/bank_account/synced_bank_account = null

/obj/machinery/computer/order_console/cook/tarkon/post_machine_initialize()
	. = ..()
	synced_bank_account = SSeconomy.get_dep_account(credits_account == "" ? ACCOUNT_CAR : credits_account)

/obj/machinery/computer/order_console/cook/tarkon/ui_data(mob/user)
	var/list/data = ..()
	data["points"] = !synced_bank_account ? 0 : synced_bank_account.account_balance
	return data

/obj/machinery/computer/order_console/cook/tarkon/purchase_items(obj/item/card/id/card, express = FALSE)
	if(!synced_bank_account)
		say(LANG("obj.148b37fb82a1554d", null))
		return FALSE
	var/final_cost = round(get_total_cost() * (express ? express_cost_multiplier : cargo_cost_multiplier))
	if(synced_bank_account.adjust_money(-final_cost, "[name]: Purchase"))
		return TRUE
	say(LANG("obj.eac2f740e586a659", list(credit_type)))
	return FALSE
