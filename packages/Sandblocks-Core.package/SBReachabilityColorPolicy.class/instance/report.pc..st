as yet unclassified
report: aMethod pc: aNumber

	(methods at: (self hash: aMethod) ifAbsentPut: [IdentitySet new]) add: aNumber