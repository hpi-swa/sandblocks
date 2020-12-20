as yet unclassified
deleteCommandFor: aBlock

	aBlock = self body ifTrue: [^ nil].
	
	^ signature deleteCommandFor: aBlock