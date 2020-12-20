as yet unclassified
matches: aBlock

	(super matches: aBlock) ifFalse: [^ false].

	^ aBlock isConstructor: 'replace:with:' for: self