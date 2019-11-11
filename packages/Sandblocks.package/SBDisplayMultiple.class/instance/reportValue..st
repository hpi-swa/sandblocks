as yet unclassified
reportValue: anObject

	| new |
	new := self lastSubmorph.
	new reportValue: anObject.
	self addMorph: new asElementNumber: 2