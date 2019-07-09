// Job ID Card Sprite s
/obj/item/card/id
	icon = 'modular_shadow/icons/obj/card.dmi'

/obj/item/card/id/job/ce
	icon_state = "CE"

/obj/item/card/id/job/cmo
	icon_state = "CMO"

/obj/item/card/id/job/hos
	icon_state = "HoS"

/obj/item/card/id/job/rd
	icon_state = "RD"

/obj/item/card/id/job/cargo
	icon_state = "cargo"

/obj/item/card/id/job/clown
	icon_state = "clown"

/obj/item/card/id/job/engineering
	icon_state = "engineering"

/obj/item/card/id/job/medical
	icon_state = "medical"

/obj/item/card/id/job/mime
	icon_state = "mime"

/obj/item/card/id/job/science
	icon_state = "research"

/obj/item/card/id/job/sec
	icon_state = "security"

/obj/item/card/id/job/nt
	icon_state = "nanotrasen"

/obj/item/card/id/job/nt
	icon_state = "nanotrasen"

// Misc IDs
/obj/item/card/id/admin
	name = "admin ID card"
	desc = "If you see this, please yell at a coder"
	icon_state = "admin"
	registered_name = "Admin"
	assignment = "Test"

/obj/item/card/id/admin/Initialize(mapload)
	access = get_all_accesses()+get_all_centcom_access()+get_all_syndicate_access() // I know this is hacky
	..()

// ERT
/obj/item/card/id/ert
	name = "ERT ID"
	icon_state = "ERT_empty"

/obj/item/card/id/ert/Commander
	icon_state = "ERT_leader"

/obj/item/card/id/ert/Security
	icon_state = "ERT_security"

/obj/item/card/id/ert/Engineering
	icon_state = "ERT_engineering"

/obj/item/card/id/ert/Medical
	icon_state = "ERT_medical"