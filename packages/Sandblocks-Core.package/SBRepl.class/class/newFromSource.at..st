as yet unclassified
newFromSource: aString at: aPoint

	^ (self newFromSource: aString named: 'REPL')
		position: aPoint;
		yourself