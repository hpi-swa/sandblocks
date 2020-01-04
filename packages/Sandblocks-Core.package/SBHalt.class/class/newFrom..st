as yet unclassified
newFrom: aBlock

	^ self new active: (aBlock selector ~= #deactivated)