as yet unclassified
precedence

	self selector ifEmpty: [^ 1].
	self selector last = $: ifTrue: [^ 3].
	self selector first canBeIdentifierInitial ifTrue: [^ 1].
	^ 2