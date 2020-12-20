hierarchy
nestingDepth

	| d node |
	d := 1.
	node := self.
	
	[node isArtefact not and: [node parentSandblock notNil]] whileTrue: [
		node := node parentSandblock.
		d := d + 1].
	
	^ d