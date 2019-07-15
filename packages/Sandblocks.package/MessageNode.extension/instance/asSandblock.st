*Sandblocks
asSandblock
	
	| send |
	send := self asMessageSandblock.
	
	" only if we're not in a cascade ... "
	send receiver ifNotNil: [
		SBSubstitution allSubclassesDo: [:substition |
			(substition matches: send) ifTrue: [
				^ (substition newFrom: send) pc: self pc]]].
	
	^ send