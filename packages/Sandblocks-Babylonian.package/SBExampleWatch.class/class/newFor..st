as yet unclassified
newFor: aBlock

	^ self new
		identifier: aBlock arguments second contents asNumber;
		expression: aBlock arguments first