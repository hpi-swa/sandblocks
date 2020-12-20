as yet unclassified
newFor: aBlock

	^ self new
		x: aBlock receiver y: aBlock arguments first;
		type: Point