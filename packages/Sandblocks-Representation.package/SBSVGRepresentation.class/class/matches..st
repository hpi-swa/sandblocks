as yet unclassified
matches: anObject

	^ (anObject isKindOf: XMLDocument) and: [(anObject root attributeAt: 'xmlns') = 'http://www.w3.org/2000/svg']