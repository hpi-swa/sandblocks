hierarchy
blockBodyNestingDepth

	| d node |
	d := 1.
	node := self.
	
	[(node := node containingBlock) notNil] whileTrue: [
		d := d + 1].
	
	^ d