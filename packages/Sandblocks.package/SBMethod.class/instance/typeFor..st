as yet unclassified
typeFor: aBlock

	^ typeCache ifNil: [nil] ifNotNil: [typeCache at: aBlock ifAbsent: [nil]]