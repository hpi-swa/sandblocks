as yet unclassified
nextFrom: aMorph do: aBlock

	^ (self nextFrom: aMorph) ifNotNil: [:b | aBlock value: b]