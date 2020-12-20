*Sandblocks-Core
asSandblock

	| send |
	send := self asSandblockWithoutSubstitution.
	
	SBSubstitution allSubclassesDo: [:substitution |
		(substitution matchesCascades and: [substitution matches: send]) ifTrue: [
			^ (substitution newFor: send) pc: self pc]].
	
	^ send