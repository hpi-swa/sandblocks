as yet unclassified
writeSourceOn: aStream

	| i |
	i :=  0.
	self submorphs
		do: [:m |
			i even
				ifTrue: [aStream nextPutAll: m contents]
				ifFalse: [m writeSourceOn: aStream].
			i := i + 1]
		separatedBy: [aStream space]