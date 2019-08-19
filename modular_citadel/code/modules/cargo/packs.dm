//supply packs

/datum/supply_pack/misc/kinkmate
	name = "Kinkmate construction kit"
	cost = 2000
	contraband = TRUE
	contains = list(/obj/item/vending_refill/kink, /obj/item/circuitboard/machine/kinkmate)
	crate_name = "Kinkmate construction kit"


//Food and livestocks

/datum/supply_pack/organic/critter/kiwi
	name = "Space kiwi Crate"
	cost = 2000
	contains = list( /mob/living/simple_animal/kiwi)
	crate_name = "space kiwi crate"


//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/misc/jukebox
	name = "Jukebox"
	cost = 35000
	contains = list(/obj/machinery/jukebox)
	crate_name = "Jukebox"

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// Armory Stuff ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security/armory/autoshotgun
	name = "Auto-Shotgun Crate"
	cost = 10000
	contains = list(/obj/item/gun/ballistic/shotgun/automatic,
					/obj/item/gun/ballistic/shotgun/automatic)

/datum/supply_pack/security/armory/shotgunammo
	name = "Shotgun Ammunition"
	cost = 1500
	contains = list(/obj/item/storage/box/lethalshot,
					/obj/item/storage/box/lethalshot,
					/obj/item/storage/box/lethalshot)