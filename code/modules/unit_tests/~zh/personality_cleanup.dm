/datum/unit_test/personality_cleanup

/datum/unit_test/personality_cleanup/Run()
	var/mob/living/carbon/human/consistent/subject = allocate(/mob/living/carbon/human/consistent)
	var/datum/personality/nt/loyalist/loyal = SSpersonalities.personalities_by_type[/datum/personality/nt/loyalist]
	var/datum/personality/nt/disillusioned/disillusioned = SSpersonalities.personalities_by_type[/datum/personality/nt/disillusioned]
	var/datum/personality/department/analytical/analytical = SSpersonalities.personalities_by_type[/datum/personality/department/analytical]
	subject.clear_personalities()
	subject.add_personality(analytical.type)
	subject.add_personality(analytical.type) // Reapplying a preference must not register signals twice.
	TEST_ASSERT(subject.personalities[analytical.type], "Repeated application must keep the existing personality.")
	subject.clear_personalities()
	subject.add_personality(loyal.type)
	subject.add_personality(disillusioned.type)
	TEST_ASSERT(subject in SSpersonalities.processing_personalities[loyal], "First processing personality should track the mob.")
	TEST_ASSERT(subject in SSpersonalities.processing_personalities[disillusioned], "Second processing personality should track the mob.")
	subject.clear_personalities()
	TEST_ASSERT(!length(subject.personalities), "Clearing personalities must remove every entry.")
	TEST_ASSERT(!(subject in SSpersonalities.processing_personalities[loyal]), "First personality must stop tracking the mob.")
	TEST_ASSERT(!(subject in SSpersonalities.processing_personalities[disillusioned]), "Second personality must stop tracking the mob.")

/datum/unit_test/zombie_stun_signal

/datum/unit_test/zombie_stun_signal/Run()
	var/mob/living/carbon/human/consistent/subject = allocate(/mob/living/carbon/human/consistent)
	var/datum/status_effect/zombie/uninfected/effect = subject.apply_status_effect(/datum/status_effect/zombie/uninfected)
	TEST_ASSERT(effect, "Zombie status should be applied before testing its stun signal.")
	effect.max_stun_length = 5
	TEST_ASSERT_EQUAL(subject.spec_stun(100), 5, "Zombie stun signal must receive and clamp the amount, not the signal source.")
	subject.remove_status_effect(/datum/status_effect/zombie/uninfected)

/datum/unit_test/bubber_arrival_shuttle_loaded

/datum/unit_test/bubber_arrival_shuttle_loaded/Run()
	TEST_ASSERT(locate(/obj/docking_port/mobile/arrivals_skyrat) in SSshuttle.mobile_docking_ports, "The Interlink arrival shuttle must be loaded after shuttle initialization.")
