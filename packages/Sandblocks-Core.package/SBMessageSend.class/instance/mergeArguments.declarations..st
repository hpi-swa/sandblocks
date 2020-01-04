accessing
mergeArguments: arguments declarations: declarations

	declarations size = arguments size ifTrue: [^ arguments].
	declarations size < arguments size ifTrue: [^ arguments first: declarations size].
	declarations size > arguments size ifTrue: [^ arguments copyWithAll: ((1 to: declarations size - arguments size) collect: [:i | SBUnknown new])]