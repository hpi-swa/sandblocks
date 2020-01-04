*Sandblocks-Core
asSandblock
	
	| send |
	send := self asSandblockWithoutSubstitution.
	
	" only if we're not in a cascade ... "
	send receiver ifNotNil: [
		SBSubstitution allSubclassesDo: [:substition |
			(substition matches: send) ifTrue: [
				^ (substition newFrom: send) pc: self pc]]].
	
	^ send