as yet unclassified
check

	| newValue |
	newValue := target perform: selector.
	(newValue ~= lastValue and: [morph notNil]) ifTrue: [
		action value: newValue value: morph.
		lastValue := newValue]