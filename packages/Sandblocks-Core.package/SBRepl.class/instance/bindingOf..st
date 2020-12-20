compilation cue protocol
bindingOf: aString

	aString = 'sbEditor' ifTrue: [^ #sbEditor -> self sandblockEditor].

	^ (self getOrCreateLocalBinding: aString) binding