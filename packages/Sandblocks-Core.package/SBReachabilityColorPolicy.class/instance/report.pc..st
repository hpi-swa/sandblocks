as yet unclassified
report: aMethod pc: aNumber

	(methods at: aMethod ifAbsentPut: [IdentitySet new]) add: aNumber