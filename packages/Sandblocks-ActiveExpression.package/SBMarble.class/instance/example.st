as yet unclassified
example

	SBMorphExample
		setUp: [SBMarble new]
		cases: {
			(SBMorphExampleCase
				name: 'test'
				caseBlock: [:m :world | m subject: ((Morph new openInWorld: world) position: world position); value: 5])
		}
		extent: 100 @ 100