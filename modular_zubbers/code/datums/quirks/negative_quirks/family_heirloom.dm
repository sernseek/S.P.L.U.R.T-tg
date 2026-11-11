// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/// Typecache of types that cannot be marked as heirlooms.
GLOBAL_LIST_INIT(invalid_heirloom_types, typecacheof(list(
	/obj/item/card/id,
	/obj/item/disk/nuclear,
)))

/datum/quirk/item_quirk/family_heirloom
	/// The temporary mark action we give to users who have opted out of random items.
	var/datum/action/mark_family_heirloom/mark_action
	always_spawn_item = TRUE

/datum/quirk/item_quirk/family_heirloom/remove()
	. = ..()

	QDEL_NULL(mark_action)

/datum/quirk/item_quirk/family_heirloom/Destroy()
	. = ..()

	QDEL_NULL(mark_action)

/datum/quirk_constant_data/family_heirloom
	associated_typepath = /datum/quirk/item_quirk/family_heirloom
	customization_options = list(/datum/preference/toggle/random_heirloom)

/datum/preference/toggle/random_heirloom
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "random_heirloom_toggle"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	default_value = TRUE

/datum/preference/toggle/random_heirloom/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/action/mark_family_heirloom
	name = "Mark Held Item As Heirloom"
	desc = "Use to mark your held item as your family heirloom. Does not work on existing heirlooms."

/datum/action/mark_family_heirloom/Trigger(mob/clicker, trigger_flags)
	. = ..()

	if (!.)
		return FALSE

	if (!isliving(owner))
		return FALSE
	var/mob/living/living_owner = owner

	var/datum/quirk/item_quirk/family_heirloom/quirk = locate() in living_owner.quirks
	if (isnull(quirk))
		stack_trace("someone has the family heirloom action without the trait... wack. [owner]")
		owner.balloon_alert(owner, LANG("datum.366c57cdbfee5530", null))
		return FALSE

	var/obj/item/held_item = living_owner.get_active_held_item()

	if (isnull(held_item))
		living_owner.balloon_alert(living_owner, LANG("datum.a616effe84072d5e", null))
		return FALSE

	if (HAS_TRAIT(held_item, TRAIT_NODROP))
		living_owner.balloon_alert(living_owner, LANG("datum.fc2edcde18b02b28", null))
		return FALSE

	if (GLOB.invalid_heirloom_types[held_item.type])
		living_owner.balloon_alert(living_owner, LANG("datum.e049e68f7b02b28b", null))
		return FALSE

	if (held_item.GetComponent(/datum/component/heirloom))
		living_owner.balloon_alert(living_owner, LANG("datum.881977abd074c305", null))
		return FALSE

	// valid heirloom

	var/new_name = tgui_input_text(
		clicker,
		LANG("datum.8d746b23c45f2918", list(held_item)),
		LANG("datum.7e421362027f5cea", null),
		max_length = 50,
		timeout = 60 SECONDS
	)

	var/new_desc = tgui_input_text(
		clicker,
		LANG("datum.26c371f0df761288", list(held_item)),
		LANG("datum.f0b3d7cb3fcf8fa6", null),
		max_length = 256,
		multiline = TRUE,
		timeout = 60 SECONDS,
	)

	var/list/names = splittext(living_owner.real_name, " ")
	var/family_name = names[names.len]

	if (new_name)
		held_item.name = "[new_name] ([held_item.name])"
		ADD_TRAIT(held_item, TRAIT_WAS_RENAMED, REF(quirk))
		held_item.AddElement(/datum/element/examined_when_worn)
		SEND_SIGNAL(held_item, COMSIG_NAME_CHANGED)
	if (new_desc)
		held_item.desc = "[new_desc]"

	held_item.AddComponent(/datum/component/heirloom, living_owner.mind, family_name)
	living_owner.add_mob_memory(/datum/memory/key/quirk_heirloom, protagonist = living_owner, heirloom_name = initial(held_item.name))

	owner.balloon_alert(owner, LANG("datum.bc223153e3ef5648", null))
	quirk.heirloom = WEAKREF(held_item)
	quirk.mark_action = null
	qdel(src)
