as yet unclassified
relevantFramesFrom: aContext

	| ctx |
	ctx := aContext.
	self flag: #todo. " domain-tied to AEs "
	
	" go up until we find the AE's invocation "
	^ Array streamContents: [:stream |
		[ctx notNil and: [ctx selector ~= #invokeCallback:oldValue:newValue:]] whileTrue: [
			stream nextPut: (SBCodeContext forPreviousOf: ctx).
			ctx := ctx sender]]