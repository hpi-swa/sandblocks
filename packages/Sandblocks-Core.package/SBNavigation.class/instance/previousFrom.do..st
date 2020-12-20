as yet unclassified
previousFrom: aMorph do: aBlock

	^ (self previousFrom: aMorph) ifNotNil: [:b | aBlock value: b]