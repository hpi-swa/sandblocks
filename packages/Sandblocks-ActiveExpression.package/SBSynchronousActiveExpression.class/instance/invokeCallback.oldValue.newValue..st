as yet unclassified
invokeCallback: aBlock oldValue: old newValue: new

	| tracer res |
	AlreadySimulating == true
		ifTrue: [^ super invokeCallback: aBlock oldValue: old newValue: new].
	
	[AlreadySimulating := true.
	tracer := SBTracingSimulator new.
	
	aBlock argumentCount > 2 ifTrue: [self error: 'Callback requires too many arguments'].
	
	res := nil.
	tracer simulate: [
		aBlock argumentCount = 0 ifTrue: [res := aBlock value].
		aBlock argumentCount = 1 ifTrue: [res := aBlock valueWithArguments: {new}].
		aBlock argumentCount = 2 ifTrue: [res := aBlock valueWithArguments: {old. new}]].
	
	lastSideEffects := tracer sideEffects.
	
	^ res] ensure: [AlreadySimulating := false]