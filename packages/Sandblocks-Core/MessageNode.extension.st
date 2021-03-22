Extension { #name : #MessageNode }

{ #category : #'*Sandblocks-Core' }
MessageNode >> asCascadePartSandblock [
	
	| msg |
	msg := self asSandblockWithoutSubstitution.
	msg receiver: nil.
	^ msg
]

{ #category : #'*Sandblocks-Core' }
MessageNode >> asSandblock [
	
	| send |
	send := self asSandblockWithoutSubstitution.
	
	" only if we're not in a cascade ... "
	send receiver ifNotNil: [
		SBStSubstitution allSubclassesDo: [:substition |
			((substition matches: send) and: [substition applyAutomatically]) ifTrue: [
				^ (substition newFor: send) pc: self pc]]].
	
	send converterOptionsDo: [:option | | c |
		c := SBConvert new success: [:obj | ^ obj].
		option automatic ifTrue: [option apply: c]].
	
	^ send
]

{ #category : #'*Sandblocks-Core' }
MessageNode >> asSandblockWithoutSubstitution [

	| blockReceiver |
	blockReceiver := originalReceiver asSandblock.
	" the originalReceiver may not have gotten a pc set, so we copy it from the generated receiver "
	(blockReceiver pc = 0 and: [self receiver notNil]) ifTrue: [blockReceiver pc: self receiver pc].
	
	^ SBStMessageSend new
		receiver: blockReceiver
		selector: originalSelector
		arguments: (originalArguments collect: #asSandblock);
		pc: self pc
]
