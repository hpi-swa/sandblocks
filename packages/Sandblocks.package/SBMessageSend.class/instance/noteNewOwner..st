as yet unclassified
noteNewOwner: aMorph

	aMorph isCascade and: [(aMorph submorphIndexOf: self) > 1] ifTrue: [self receiver ifNotNil: #delete]