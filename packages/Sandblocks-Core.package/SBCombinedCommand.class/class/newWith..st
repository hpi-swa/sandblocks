as yet unclassified
newWith: aCollection

	^ self basicNew
		initialize;
		commands: aCollection;
		yourself