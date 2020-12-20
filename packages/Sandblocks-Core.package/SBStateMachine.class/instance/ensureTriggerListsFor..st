private
ensureTriggerListsFor: aState

	signalTransitions at: aState ifAbsentPut: [Dictionary new].
	conditionalTransitions at: aState ifAbsentPut: [Dictionary new].
	timeTransitions at: aState ifAbsentPut: [Dictionary new].
	leaveActions at: aState ifAbsentPut: [OrderedCollection new].
	enterActions at: aState ifAbsentPut: [OrderedCollection new]