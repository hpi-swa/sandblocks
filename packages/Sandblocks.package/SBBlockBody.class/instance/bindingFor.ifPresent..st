converting
bindingFor: aString ifPresent: aBlock

	temporaries submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	bindings submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	^ (self containingBlock ifNil: [self containingMethod]) bindingFor: aString ifPresent: aBlock