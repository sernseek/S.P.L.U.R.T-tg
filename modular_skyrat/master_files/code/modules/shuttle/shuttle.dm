/obj/docking_port/mobile
	/// The take off sound to be played
	var/takeoff_sound = sound('modular_skyrat/modules/advanced_shuttles/sound/engine_startup.ogg')
	/// The landing sound to be played
	var/landing_sound = sound('modular_skyrat/modules/advanced_shuttles/sound/engine_landing.ogg')
	/// The sound range coeff for the landing and take off sound effect
	var/sound_range = 20

/obj/docking_port/mobile/proc/bolt_all_doors() // Expensive procs :(
	var/list/turfs = return_ordered_turfs(x, y, z, dir)
	for(var/i in 1 to turfs.len)
		var/turf/checked_turf = turfs[i]
		for(var/obj/machinery/door/airlock/airlock_door in checked_turf)
			if(airlock_door.external)
				airlock_door.close(force_crush = TRUE)
				airlock_door.bolt()

/obj/docking_port/mobile/proc/unbolt_all_doors()
	var/list/turfs = return_ordered_turfs(x, y, z, dir)
	for(var/i in 1 to turfs.len)
		var/turf/checked_turf = turfs[i]
		for(var/obj/machinery/door/airlock/airlock_door in checked_turf)
			if(airlock_door.external)
				airlock_door.unbolt()

/obj/docking_port/mobile/proc/play_engine_sound(atom/distant_source, takeoff)
	if(distant_source)
		for(var/mob/hearing_mob in range(sound_range, distant_source))
			if(hearing_mob?.client)
				var/dist = get_dist(hearing_mob.loc, distant_source.loc)
				var/vol = clamp(50 - ((dist - 7) * 5), 10, 50) // Every tile decreases sound volume by 5
				var/volume_multiplier = hearing_mob.client?.prefs.read_preference(/datum/preference/numeric/volume/sound_ambience_volume)
				if(!volume_multiplier)
					return
				if(takeoff)
					hearing_mob.playsound_local(distant_source, takeoff_sound, vol = vol * volume_multiplier)
				else
					hearing_mob.playsound_local(distant_source, landing_sound, vol = vol * volume_multiplier)

// ZH EDIT ADDITION START - HYPERSPACE_AREA_LEAK
// generate_transit_dock() creates a fresh /area/shuttle/transit ("Hyperspace") for every trip, but
// /obj/docking_port/stationary/transit/Destroy() only frees reserved_area (the turf reservation) and never
// deletes assigned_area, so each trip leaves one more area in GLOB.areas and the teleport list fills with them.
// The area cannot be qdel'd inside Destroy(): SSmapping hands the turfs back asynchronously (reserve_turfs() only
// queues them), so at that point the area still owns turfs and deleting it would leave their loc pointing at a
// deleted area. Instead we wait until it is empty, with a retry cap that falls back to the old behaviour
// (leaving it in place) rather than ever orphaning turfs.
/// Delay between cleanup checks
#define TRANSIT_AREA_CLEANUP_INTERVAL (5 SECONDS)
/// Checks made before giving up
#define TRANSIT_AREA_CLEANUP_MAX_TRIES 12

/area/shuttle/transit
	/// Cleanup checks left before we give up and keep the area
	var/cleanup_tries_left = TRANSIT_AREA_CLEANUP_MAX_TRIES

/// Called by the owning transit dock when it is destroyed; deletes the area once its turfs have been handed back
/area/shuttle/transit/proc/queue_cleanup()
	if(QDELETED(src))
		return
	if(!length(contents))
		qdel(src)
		return
	cleanup_tries_left--
	if(cleanup_tries_left <= 0)
		stack_trace("transit area still holds [length(contents)] turf(s) after cleanup retries; leaving it in place")
		return
	addtimer(CALLBACK(src, PROC_REF(queue_cleanup)), TRANSIT_AREA_CLEANUP_INTERVAL)

/obj/docking_port/stationary/transit/Destroy(force = FALSE)
	// Only on force, matching upstream which does no cleanup at all on a non-forced Destroy()
	var/area/shuttle/transit/stale_area
	if(force)
		stale_area = assigned_area
		assigned_area = null
	. = ..()
	stale_area?.queue_cleanup()
#undef TRANSIT_AREA_CLEANUP_INTERVAL
#undef TRANSIT_AREA_CLEANUP_MAX_TRIES
// ZH EDIT ADDITION END
