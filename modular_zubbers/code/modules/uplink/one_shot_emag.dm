// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/item/card/emag/one_shot
	name = "cryptographic sequencer"
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list(JOB_DETECTIVE, JOB_HEAD_OF_SECURITY)
	special_desc = "Upon inspection you can instantly tell this is a real cryptographic sequencer commonly traded in bulk for cheap at countless blackmarkets. They are known for their unreliability and breaking after just one use from their shoddy construction."
	/// How many uses does it have left?
	var/charges = 1
	/// Who summoned this?
	var/caller

/obj/item/card/emag/one_shot/examine(mob/user)
	. = ..()
	if(user == caller)
		. += span_notice(LANG("obj.3b32092266747dd8", null))
	else
		. += span_notice(LANG("obj.ec046da557dae7c6", null))

/obj/item/card/emag/one_shot/can_emag(atom/target, mob/user)
	if(charges <= 0)
		balloon_alert(user, LANG("obj.4084453b1390cccb", null))
		return FALSE
	use_charge(user)
	return TRUE

/obj/item/card/emag/one_shot/proc/use_charge(mob/user)
	balloon_alert(user, LANG("obj.b19f3e97c19eda51", null))
	charges --
