as yet unclassified
syncPositionFrom: aMorph to: anotherMorph

	anotherMorph owner layoutPolicy ifNil: [anotherMorph center: aMorph center]