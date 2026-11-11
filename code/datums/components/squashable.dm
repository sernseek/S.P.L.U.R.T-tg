// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
///This component allows something to be when crossed, for example for cockroaches.
/datum/component/squashable
	///Chance on crossed to be squashed
	var/squash_chance = 50
	///How much brute is applied when mob is squashed
	var/squash_damage = 1
	///Squash flags, for extra checks etcetera.
	var/squash_flags = NONE
	///Special callback to call on squash instead, for things like hauberoach
	var/datum/callback/on_squash_callback
	///signal list given to connect_loc
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	COOLDOWN_DECLARE(squish_cooldown) // BUBBER EDIT


/datum/component/squashable/Initialize(squash_chance, squash_damage, squash_flags, squash_callback)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	if(squash_chance)
		src.squash_chance = squash_chance
	if(squash_damage)
		src.squash_damage = squash_damage
	if(squash_flags)
		src.squash_flags = squash_flags
	if(!src.on_squash_callback && squash_callback)
		on_squash_callback = CALLBACK(parent, squash_callback)

	AddComponent(/datum/component/connect_loc_behalf, parent, loc_connections)
	if(squash_callback) // BUBBER EDIT BEGIN- NO ROACHES SQUISHING EACH OTHER FOR THE OTHER EDIT
		return
	RegisterSignal(parent, COMSIG_LIVING_MOB_BUMPED, PROC_REF(on_entered))// BUBBER EDIT END - MICRO BALANCE

/datum/component/squashable/Destroy(force)
	on_squash_callback = null
	return ..()

///Handles the squashing of the mob
/datum/component/squashable/proc/on_entered(turf/source_turf, atom/movable/crossing_movable)
	SIGNAL_HANDLER
	if(istype(crossing_movable, /obj)) // BUBBER EDIT -  don't get knocked down by items
		return

	if(parent == crossing_movable)
		return

	var/mob/living/parent_as_living = parent
	if((squash_flags & SQUASHED_DONT_SQUASH_IN_CONTENTS) && !isturf(parent_as_living.loc))
		return

	if((squash_flags & SQUASHED_SHOULD_BE_DOWN) && parent_as_living.body_position != LYING_DOWN)
		//BUBBER EDIT - Light step/walk/bots dont knock down
		if(isliving(crossing_movable))
			var/mob/living/crossing_mob = crossing_movable
			if((crossing_mob.move_intent == MOVE_INTENT_WALK) || HAS_TRAIT(crossing_mob, TRAIT_LIGHT_STEP) || isbot(crossing_mob))
				return
		//BUBBER EDIT END
		parent_as_living.Knockdown(1 SECONDS) // BUBBER EDIT - MICRO BALANCE
		return

	var/should_squash = ((squash_flags & SQUASHED_ALWAYS_IF_DEAD) && parent_as_living.stat == DEAD) || prob(squash_chance)

	if(should_squash && on_squash_callback)
		if(on_squash_callback.Invoke(parent_as_living, crossing_movable))
			return //Everything worked, we're done!
	if(isliving(crossing_movable))
		var/mob/living/crossing_mob = crossing_movable
		if(crossing_mob.mob_size > MOB_SIZE_SMALL && !(crossing_mob.movement_type & MOVETYPES_NOT_TOUCHING_GROUND))
			if(HAS_TRAIT(crossing_mob, TRAIT_PACIFISM) || (crossing_mob.move_intent == MOVE_INTENT_WALK) || HAS_TRAIT(crossing_mob, TRAIT_LIGHT_STEP)) // BUBBER EDIT
				crossing_mob.visible_message(span_notice(LANG("datum.24f383d0d43f7500", list(crossing_mob, parent_as_living))), span_notice(LANG("datum.699d1be7a93c961b", list(parent_as_living, parent_as_living.p_them())))) //BUBBER EDIT - Added pronouns
				return
			if(should_squash)
				crossing_mob.visible_message(span_notice(LANG("datum.998839f36449eae6", list(crossing_mob, parent_as_living))), span_notice(LANG("datum.502196ac90c4a1ae", list(parent_as_living))))
				Squish(parent_as_living)
				playsound(parent_as_living, 'sound/effects/blob/attackblob.ogg', 50, TRUE) // BUBBER EDIT
			else
				parent_as_living.visible_message(span_notice(LANG("datum.97492c6a4c39fd79", list(parent_as_living))))
	else if(isstructure(crossing_movable))
		if(should_squash)
			crossing_movable.visible_message(span_notice(LANG("datum.52abe7fd2d90659b", list(parent_as_living, crossing_movable))))
			Squish(parent_as_living)
		else
			parent_as_living.visible_message(span_notice(LANG("datum.97492c6a4c39fd79", list(parent_as_living))))

/datum/component/squashable/proc/Squish(mob/living/target)
	if(squash_flags & SQUASHED_SHOULD_BE_GIBBED)
		target.gib(DROP_ALL_REMAINS)
	else
		if(COOLDOWN_FINISHED(src, squish_cooldown))// BUBBER EDIT
			target.take_bodypart_damage(squash_damage, wound_bonus = 5)// BUBBER EDIT
			target.AddElement(/datum/element/squish, 20 SECONDS) // BUBBER EDIT
			COOLDOWN_START(src, squish_cooldown, 20 SECONDS)// BUBBER EDIT


/datum/component/squashable/UnregisterFromParent()
	. = ..()
	qdel(GetComponent(/datum/component/connect_loc_behalf))
