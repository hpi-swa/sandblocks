*Sandblocks-Core
asCascadePartSandblock
	
	| msg |
	msg := self asSandblock.
	msg receiver: nil.
	^ msg