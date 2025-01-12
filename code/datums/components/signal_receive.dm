/datum/component/signal_receive
	var/signal_frequency
	var/code
	var/datum/callback/can_trigger
	var/datum/callback/on_trigger

/datum/component/signal_receive/Initialize(signal_frequency, code, datum/callback/on_trigger, datum/callback/can_trigger)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.on_trigger = on_trigger
	src.can_trigger = can_trigger
	RegisterSignal(parent, list(COMSIG_RADIO_CHANGE_CODE), PROC_REF(change_code))
	RegisterSignal(parent, list(COMSIG_RADIO_CHANGE_FREQUENCY), PROC_REF(change_frequency))
	RegisterSignal(parent, list(COMSIG_RADIO_RECEIVE_SIGNAL), PROC_REF(handle_signal))

/datum/component/signal_receive/proc/handle_signal(source, datum/signal/signal, receive_method, receive_param)
	SIGNAL_HANDLER
	if(can_trigger && !can_trigger.Invoke(source))
		return
	on_trigger.Invoke(source, signal, receive_method, receive_param)

/datum/component/signal_receive/proc/change_code(source, code)
	SIGNAL_HANDLER
	src.code = code
/datum/component/signal_receive/proc/change_frequency(source, signal_frequency)
	SIGNAL_HANDLER
	src.signal_frequency = signal_frequency
