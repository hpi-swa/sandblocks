Extension { #name : #CascadeNode }

{ #category : #'*Sandblocks-Core' }
CascadeNode >> asSandblock [

	| send |
	send := self asSandblockWithoutSubstitution.
	
	SBSubstitution allSubclassesDo: [:substitution |
		(substitution matchesCascades and: [substitution matches: send]) ifTrue: [
			^ (substitution newFrom: send) pc: self pc]].
	
	^ send
]

{ #category : #'*Sandblocks-Core' }
CascadeNode >> asSandblockWithoutSubstitution [

	^ SBCascade new
		receiver: self receiver asSandblock
		messages: (self messages collect: #asCascadePartSandblock)
]

{ #category : #'*Sandblocks-Core' }
CascadeNode >> originalReceiver [

	^ receiver
]
