*Sandblocks-Core
asCascadePartSandblock
	
	| msg |
	msg := self asSandblockWithoutSubstitution.
	msg receiver: nil.
	^ msg