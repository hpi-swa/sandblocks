as yet unclassified
writeSourceOn: aStream

	self submorphs
		do: [:m |
			(m isKindOf: SBTextMorph)
				ifTrue: [aStream nextPutAll: m contents]
				ifFalse: [m writeSourceOn: aStream]]
		separatedBy: [aStream space]