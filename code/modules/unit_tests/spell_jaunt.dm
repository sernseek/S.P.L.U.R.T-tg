/// Tests Shadow Walk can be entered and exited
/datum/unit_test/shadow_jaunt

/datum/unit_test/shadow_jaunt/Run()
	var/mob/living/carbon/human/jaunter = allocate(/mob/living/carbon/human/consistent)
	var/datum/action/cooldown/spell/jaunt/shadow_walk/walk = allocate(/datum/action/cooldown/spell/jaunt/shadow_walk, jaunter)
	walk.light_threshold = INFINITY // ZH EDIT - isolate the enter/exit test from variable room lighting
	walk.Grant(jaunter)

	var/turf/jaunt_turf = jaunter.loc
	TEST_ASSERT(istype(jaunt_turf), "Jaunter was not allocated to a turf, instead to [jaunt_turf || "nullspace"].")
	// ZH EDIT ADDITION START - make the test independent of the shared room's lighting state
	var/created_lighting = !jaunt_turf.lighting_object
	if(created_lighting)
		jaunt_turf.lighting_build_overlay()
	// ZH EDIT ADDITION END
	TEST_ASSERT(walk.IsAvailable(), "Unit test room is not suitable to test [walk].")

	walk.Trigger()

	TEST_ASSERT_NOTEQUAL(jaunter.loc, jaunt_turf, "Jaunter's loc did not change on casting [walk].")
	TEST_ASSERT(istype(jaunter.loc, walk.jaunt_type), "Jaunter failed to enter jaunt on casting [walk].")

	walk.next_use_time = -1
	walk.Trigger()

	TEST_ASSERT_EQUAL(jaunter.loc, jaunt_turf, "Jaunter failed to exit jaunt on exiting [walk].")
	if(created_lighting) // ZH EDIT ADDITION - restore the shared room
		jaunt_turf.lighting_clear_overlay() // ZH EDIT ADDITION
