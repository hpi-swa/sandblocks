*Sandblocks-Core
asSandblock
	
	| send |
	send := self asSandblockWithoutSubstitution.
	
	" only if we're not in a cascade ... "
	send receiver ifNotNil: [
		SBSubstitution allSubclassesDo: [:substition |
			((substition matches: send) and: [substition applyAutomatically]) ifTrue: [
				^ (substition newFor: send) pc: self pc]]].
	
	^ send