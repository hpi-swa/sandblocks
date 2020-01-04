as yet unclassified
rotateAround: aTargetNode

	| child childInsertIndex parent childInsertOwner isLeft |
	parent := aTargetNode parentSandblock.
	isLeft := aTargetNode isLastChild.
	child := isLeft ifTrue: [aTargetNode childSandblocks first] ifFalse: [aTargetNode childSandblocks last].
	childInsertOwner := aTargetNode owner.
	childInsertIndex := childInsertOwner submorphIndexOf: aTargetNode.
	
	parent replaceBy: aTargetNode.
	child replaceBy: parent.
	childInsertOwner addMorph: child asElementNumber: childInsertIndex.
	^ parent