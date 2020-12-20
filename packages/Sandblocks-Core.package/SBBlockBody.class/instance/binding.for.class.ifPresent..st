converting
binding: aString for: block class: aClass ifPresent: aBlock

	temporaries submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	bindings submorphs detect: [:s | s contents = aString] ifFound: [:s | ^ aBlock value: s] ifNone: [].
	^ super binding: aString for: block class: aClass ifPresent: aBlock