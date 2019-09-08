/datum/status_effect/incapacitating/knockdown/on_creation(mob/living/new_owner, set_duration, updating_canmove, override_hardstun, override_stamdmg)
	if(iscarbon(new_owner) && (isnum(set_duration) || isnum(override_hardstun)))
		if(istype(new_owner.buckled, /obj/vehicle/ridden))
			var/obj/buckl = new_owner.buckled
			buckl.unbuckle_mob(new_owner)
		new_owner.resting = TRUE
		new_owner.adjustStaminaLoss(isnull(override_stamdmg)? set_duration*0.25 : override_stamdmg)
		if(isnull(override_hardstun) && (set_duration > 80))
			set_duration = set_duration*0.01
			return ..()
		else if(!isnull(override_hardstun))
			set_duration = override_hardstun
			return ..()
		else if(updating_canmove)
			new_owner.update_canmove()
		qdel(src)
	else
		. = ..()
