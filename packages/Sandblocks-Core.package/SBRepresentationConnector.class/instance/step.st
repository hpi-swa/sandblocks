stepping
step

	| newSource |
	newSource := from object.
	(lastSource ~~ newSource and: [from isInWorld]) ifTrue: [
		(currentRepresentation matches: from object) ifTrue: [
			lastSource := newSource.
			to replace: newSource]]