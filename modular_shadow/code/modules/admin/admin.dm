/client/proc/change_auto_shuttle_call() // Adjusts the time when the shuttle is going to be called.
    set category = "Server"
    set name = "Adjust Shuttle Autocall"

    if(!check_rights(R_SERVER))
        return

    var/time_before = SSshuttle.auto_call / 600 // Autocall timer before in minutes; 600 deciseconds = 1 minute :(
    var/time_after = input("Please Input when the shuttle should be called in minutes.") as num

    SSshuttle.auto_call = time_after * 600
    SSshuttle.autoEnd() // Has a if check built in, checks if the current time is over specified time and calls the shuttle if so

    message_admins("<span class='adminnotice'>[key_name_admin(usr)] adjusted the shuttle autocall timer from [time_before] to [time_after] minutes.</span>")
    log_admin("Adjust Shuttle Call: [key_name(usr)] adjusted the auto shuttle call.")

/client/proc/toggle_auto_shuttle_call() // Turns Autocall for the Shuttle on or off.
    set category = "Server"
    set name = "Toggle Shuttle Autocall"

    if(!check_rights(R_SERVER))
        return

    if(SSshuttle.auto_call_allowed)
        SSshuttle.auto_call_allowed = FALSE
        message_admins("<span class='adminnotice'>[key_name_admin(usr)] toggled the shuttle autocall OFF.</span>")
    else
        SSshuttle.auto_call_allowed = TRUE
        message_admins("<span class='adminnotice'>[key_name_admin(usr)] toggled the shuttle autocall ON.</span>")
        SSshuttle.autoEnd() // autoEnd() checks if the time passed with a if check by itself, so let's check once badmins turn it back on

    log_admin("Adjust Shuttle Call: [key_name(usr)] toggled the auto shuttle call.")