Extension { #name : #MorphicHaloDispatcher }

{ #category : #'*Sandblocks-Core-override' }
MorphicHaloDispatcher >> dispatchHalo: event transferInwardsFrom: currentTarget [

	| localEvent world |
	"Note that a halo usually attaches to the outermost (or top) renderer in a composition around the rendered morph. Thus, we have to lookup that inner (or rendered) morph first when transferring the halo inwards in the hierarchy of submorphs."
	currentTarget renderedMorph submorphsDo: [:nextTarget |
		localEvent := event transformedBy: (nextTarget transformedFrom: currentTarget).
		(nextTarget fullContainsPoint: localEvent position) ifTrue: [
			nextTarget wantsHaloFromClick
				ifTrue: [^ self invokeHalo: localEvent on: nextTarget]
				ifFalse: [(nextTarget rejectsEvent: event) ifFalse: [^ self dispatchHalo: localEvent transferInwardsFrom: nextTarget]]]].
	
	"We're at the bottom most level; throw the event back up to the root to find recipient"
	event hand removeHalo.
	Preferences maintainHalos ifFalse: [
		(world := currentTarget world) ifNil: [^ false].
		localEvent := event transformedBy: (currentTarget transformedFrom: world) inverseTransformation.
		world processEvent: localEvent resetHandlerFields].
	
	^ false
]
