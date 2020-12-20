accessing
state: newState
	| oldState |
	
	oldState := self state.
	(leaveActions at: oldState) do: [ :action | action valueWithEnoughArguments: newState ].
	
	state := newState.
	self ensureTriggerListsFor: newState.
	self resetTimeTransitionsFor: newState.
	
	(enterActions at: self state) do: [ :action | action valueWithEnoughArguments: oldState ]