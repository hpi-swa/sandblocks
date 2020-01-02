as yet unclassified
newFrom: aBlock

	^ self new
		identifier: aBlock arguments second contents asNumber;
		expression: aBlock arguments first