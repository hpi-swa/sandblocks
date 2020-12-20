as yet unclassified
size: aNumber
	
	| newArray |
	(newArray := (Array new: aNumber withAll: 0)).
	(newArray replaceFrom: (((aNumber - (array size)) + 1) max: 1) to: (newArray size) with: array startingAt: ((((array size) - aNumber) + 1) max: 1)).
	(array := newArray).
	(cursor := (array size - 1))