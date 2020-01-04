as yet unclassified
with: aCollection and: anotherCollection do: aBlock separatedBy: anotherBlock 
	aBlock value: aCollection first value: anotherCollection first.
	2
		to: aCollection size
		do: [:index | 
			anotherBlock value.
			aBlock
				value: (aCollection at: index)
				value: (anotherCollection at: index)]