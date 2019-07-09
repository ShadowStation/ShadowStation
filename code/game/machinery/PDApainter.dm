/obj/machinery/pdapainter
	name = "\improper PDA & ID Painter"
	desc = "A machine capable of coloring PDAs and IDs with ease. Insert an ID card or PDA and pick a color scheme."
	icon = 'icons/obj/pda.dmi'
	icon_state = "coloriser"
	density = TRUE
	max_integrity = 200
	var/obj/item/pda/storedpda = null
	var/obj/item/card/id/storedid = null
	var/pda_icons = list(
		"Assistant" = "pda",
		"Atmospheric Technician" = "pda-atmos",
		"Bartender" = "pda-bartender",
		"Botanist" = "pda-hydro",
		"Captain" = "pda-captain",
		"Cargo Technician" = "pda-cargo",
		"Chaplain" = "pda-chaplain",
		"Chemist" = "pda-chemistry",
		"Chief Medical Officer" = "pda-cmo",
		"Chief Engineer" = "pda-ce",
		"Clown" = "pda-clown",
		"Cook" = "pda-cook",
		"Curator" = "pda-library",
		"Detective" = "pda-detective",
		"Engineer" = "pda-engineer",
		"Geneticist" = "pda-genetics",
		"Head of Personnel" = "pda-hop",
		"Head of Security" = "pda-hos",
		"Internal Affairs Agent" = "pda-laweyr",
		"Janitor" = "pda-janitor",
		"Medical Doctor" = "pda-medical",
		"Mime" = "pda-mime",
		"Quartermaster" = "pda-qm",
		"Research Director" = "pda-rd",
		"Roboticist" = "pda-robotocist",
		"Scienctist" = "pda-science",
		"Security Officer" = "pda-security",
		"Shaft Miner" = "pda-miner",
		"Virologist" = "pda-virology",
		"Warden" = "pda-warden"
	)
	var/id_icons = list(
		"Assistant" = "id",
		"Captain" = "gold",
		"Cargo" = "cargo",
		"Chief Engineer" = "CE",
		"Chief Medical Officer" = "CMO",
		"Clown" = "clown",
		"Engineering" = "engineering",
		"Head of Personnel" = "silver",
		"Head of Security" = "HoS",
		"Medical" = "medical",
		"Mime" = "mime",
		"Research Director" = "RD",
		"Science" = "research",
		"Security" = "security")


/obj/machinery/pdapainter/update_icon()
	cut_overlays()

	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		return

	if(storedpda)
		add_overlay("[initial(icon_state)]-pda-in")

	if(storedid)
		add_overlay("[initial(icon_state)]-id-in")

	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

	return

/obj/machinery/pdapainter/Destroy()
	QDEL_NULL(storedpda)
	QDEL_NULL(storedid)
	return ..()

/obj/machinery/pdapainter/on_deconstruction()
	if(storedpda)
		storedpda.forceMove(loc)
		storedpda = null
	if(storedid)
		storedid.forceMove(loc)
		storedid = null

/obj/machinery/pdapainter/contents_explosion(severity, target)
	if(storedpda)
		storedpda.ex_act(severity, target)
	if(storedid)
		storedid.ex_act(severity, target)

/obj/machinery/pdapainter/handle_atom_del(atom/A)
	if(A == storedpda)
		storedpda = null
		update_icon()
	if(A == storedid)
		storedpda = null
		update_icon()

/obj/machinery/pdapainter/attackby(obj/item/O, mob/user, params)
	if(default_unfasten_wrench(user, O))
		power_change()
		return

	else if(istype(O, /obj/item/pda))
		if(storedpda)
			to_chat(user, "<span class='warning'>There is already a PDA inside!</span>")
			return
		else if(!user.transferItemToLoc(O, src))
			return
		storedpda = O
		O.add_fingerprint(user)
		update_icon()

	else if(istype(O, /obj/item/card/id))
		if(storedid)
			to_chat(user, "<span class='warning'>There is already an ID card inside!</span>")
			return
		else if(!user.transferItemToLoc(O, src))
			return
		storedid = O
		O.loc = src
		O.add_fingerprint(user)
		update_icon()

	else if(istype(O, /obj/item/weldingtool) && user.a_intent != INTENT_HARM)
		if(stat & BROKEN)
			if(!O.tool_start_check(user, amount=0))
				return
			user.visible_message("[user] is repairing [src].", \
							"<span class='notice'>You begin repairing [src]...</span>", \
							"<span class='italics'>You hear welding.</span>")
			if(O.use_tool(src, user, 40, volume=50))
				if(!(stat & BROKEN))
					return
				to_chat(user, "<span class='notice'>You repair [src].</span>")
				stat &= ~BROKEN
				obj_integrity = max_integrity
				update_icon()
		else
			to_chat(user, "<span class='notice'>[src] does not need repairs.</span>")
	else
		return ..()

/obj/machinery/pdapainter/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!(stat & BROKEN))
			stat |= BROKEN
			update_icon()

/obj/machinery/pdapainter/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(storedpda || storedid)
		if(storedpda)
			var/newpdaskin
			newpdaskin = input(user, "Select a PDA skin!", "PDA Painting") as null|anything in pda_icons
			if(!newpdaskin)
				return
			if(!in_range(src, user))
				return
			if(!storedpda)
				return
			storedpda.icon_state = pda_icons[newpdaskin]
			ejectpda()

		if(storedid)
			var/newidskin
			newidskin = input(user, "Select an ID skin!", "ID Painting") as null|anything in id_icons

			if(!newidskin)
				return
			if(!in_range(src, user))
				return
			if(!storedid)//is the ID still there?
				return
			storedid.icon_state = id_icons[newidskin]
			ejectid()
	else
		to_chat(user, "<span class='notice'>[src] is empty.</span>")


/obj/machinery/pdapainter/AltClick(mob/user)
	if(usr.stat || usr.restrained() || !usr.canmove)
		return
	if(storedpda || storedid)
		ejectid()
		ejectpda()
		to_chat(usr, "<span class='notice'>You eject the contents.</span>")
	else
		to_chat(usr, "<span class='notice'>[src] is empty.")

/obj/machinery/pdapainter/proc/ejectpda()
	if(storedpda)
		storedpda.loc = get_turf(src.loc)
		storedpda = null
		update_icon()

/obj/machinery/pdapainter/proc/ejectid()
	if(storedid)
		storedid.loc = get_turf(src.loc)
		storedid = null
		update_icon()

/obj/machinery/pdapainter/power_change()
	..()
	update_icon()