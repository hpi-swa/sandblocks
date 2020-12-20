as yet unclassified
undo

	wrapUndo ifNotNil: [wrapUndo value: outer value: targets].
	
	outer replaceBy: targets first.
	
	targets viewAllButFirst withIndexDo: [:target :index |
		targetOldOwner addMorph: target asElementNumber: targetOldIndex + index].
	
	^ targets first