*Sandblocks
asSandblock
	
	| send |
	send := self asMessageSandblock.
	
	SBSubstitution allSubclassesDo: [:substition |
		(substition matches: send) ifTrue: [
			^ (substition newFrom: send) pc: self pc]].
	
	^ send