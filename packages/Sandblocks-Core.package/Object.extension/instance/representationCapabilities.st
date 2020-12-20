*Sandblocks-Core
representationCapabilities

	| set |
	SBExample self: [Morph new] args: [{}] label: 'simple'.
	set := Set new.
	self representationsDo: [:repr |
		set addAll: (repr class methodDictionary values collect: #selector)].
	set
		remove: #matches: ifAbsent: [nil];
		remove: #newFor: ifAbsent: [nil].
	^ set