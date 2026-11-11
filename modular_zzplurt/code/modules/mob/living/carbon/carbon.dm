// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Liquid Panty Dropper effect
/mob/living/carbon/proc/clothing_burst(throw_clothes = FALSE)
	// Variable for if the action succeeded
	var/user_disrobed = FALSE

	// Get worn items
	var/items = get_contents()

	// Iterate over worn items
	for(var/obj/item/item_worn in items)
		// Ignore non-mob (storage)
		if(!ismob(item_worn.loc))
			continue

		// Ignore held items
		if(is_holding(item_worn))
			continue

		// Check for anything covering a body part
		if(!item_worn.body_parts_covered)
			continue

		// Don't drop items that require time to take off
		if (item_worn.breakouttime)
			continue

		// Drop the target item
		if (!dropItemToGround(item_worn))
			continue

		user_disrobed = TRUE
		// Throw item to a random spot
		if(throw_clothes)
			item_worn.throw_at(pick(oview(7,get_turf(src))),10,1)

	// When successfully disrobing a target
	if(user_disrobed)
		// Display a chat message
		visible_message(span_userlove(LANG("mob.f02cf5cc64a4811b", list(src, p_their()))), span_userlove(LANG("mob.6e9c1ca15db3fb4d", null)))

		// Play the ripped poster sound
		playsound(loc, 'sound/items/poster/poster_ripped.ogg', 50, 1)
