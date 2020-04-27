stepping
installEventBroadcasterFor: aMorph

	aMorph eventHandler
		ifNotNil: [self assert: (aMorph eventHandler isKindOf: SBEventBroadcast)]
		ifNil: [aMorph eventHandler: SBEventBroadcast new].
	
	^ aMorph eventHandler