//This is a fully self-contained module having everything necessary to function within a citadel-code server except icons and a way to obtain them. You're welcome, coders.
/datum/component/storage/concrete/pockets/schoolgirl
	max_items = 2
	max_w_class = WEIGHT_CLASS_SMALL
	attack_hand_interact = FALSE

/obj/item/key/zipperkey
	name = "zipper key"
	desc = "A fairly innocuous key."

/obj/item/clothing/under/schoolgirl/locked
	name = "blue schoolgirl uniform"
	desc = "An extremely cute schoolgirl uniform. It appears to have a locking zipper."
	icon_state = "schoolgirl"
	item_state = "schoolgirl"
	item_color = "schoolgirl"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	has_sensor = NO_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/schoolgirl
	var/locked = FALSE
	var/perma = FALSE
	var/mob/wearer = null
	var/breakchance = 5

/obj/item/clothing/under/schoolgirl/locked/Initialize()
	. = ..()
	new /obj/item/key/zipperkey(src)


/obj/item/clothing/under/schoolgirl/locked/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_W_UNIFORM)
		wearer = user
		lock(user)

/obj/item/clothing/under/schoolgirl/locked/dropped(mob/user)
	. = ..()
	wearer = null

/obj/item/clothing/under/schoolgirl/locked/proc/lock(mob/user)
	locked = TRUE
	item_flags = NODROP
	if(perma)
		to_chat(wearer, "<span class='warning'>As you zip up the outfit, the zipper clacks into place. It seems it has locked at the top of the track.")
		return
	to_chat(wearer,"<span class='notice'>As you zip up the outfit, the zipper clicks into place. It seems it has locked at the top of the track.")



/obj/item/clothing/under/schoolgirl/locked/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/screwdriver) && !istype(I, /obj/item/screwdriver/power) && locked)
		if(perma)
			to_chat(user,"<span class='notice'>The lock doesn't seem to want to turn. Perhaps it's broken?</span>")
			return
		if(locked && !prob(breakchance+25))
			locked = FALSE
			to_chat(user,"<span class='notice'>You jam the screwdriver in, unlocking the outfit.</span>")
			item_flags = null
			breakchance += 1
			return
		else if(locked && !prob(breakchance))
			locked = TRUE
			to_chat(user,"<span class='notice'>You jam the screwdriver in, but it does not unlock the outfit.</span>")
			breakchance += 1
			return
		else if(locked)
			perma = TRUE
			to_chat(user,"<span class='warning'>You jam the screwdriver in, accidentally breaking the lock!</span>")
			return
		else if(istype(I, /obj/item/screwdriver/nuke))
			perma = TRUE
			to_chat(user,"<span class='warning'>You fiddle with the locking mechanism, sabotaging it!</span>")
			return
		to_chat(user,"<span class='notice'>The lock has been damaged beyond repair, there's no way to open it.</span>")
	if(istype(I, /obj/item/key/zipperkey))
		if(perma)
			to_chat(user,"<span class='notice'>The lock doesn't seem to want to turn. Perhaps it's broken?</span>")
			return
		if(locked)
			locked = FALSE
			to_chat(user,"<span class='notice'>You unlock the outfit.</span>")
			item_flags = null

/obj/item/clothing/under/schoolgirl/locked/attack_hand(mob/user)
	if(locked)
		to_chat(user, "<span class='warning'>You try to unzip the outfit, but the zipper won't budge!</span> You'll have to unlock it first.")
		return
	..()

/obj/item/clothing/under/schoolgirl/locked/red
	name = "red schoolgirl uniform"
	icon_state = "schoolgirlred"
	item_state = "schoolgirlred"
	item_color = "schoolgirlred"

/obj/item/clothing/under/schoolgirl/locked/orange
	name = "orange schoolgirl uniform"
	icon_state = "schoolgirlorange"
	item_state = "schoolgirlorange"
	item_color = "schoolgirlorange"

/obj/item/clothing/under/schoolgirl/locked/green
	name = "green schoolgirl uniform"
	icon_state = "schoolgirlgreen"
	item_state = "schoolgirlgreen"
	item_color = "schoolgirlgreen"