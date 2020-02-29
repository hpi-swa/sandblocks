as yet unclassified
exampleMorphToMorph

	SBMorphExample
		setUp: [SBConnectorLine new lineType: #curve]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m | 
					m
						connect: (Morph new
							 color: Color red;
							 openInWorld: m owner;
							 position: 139 @ 164)
						to: (Morph new
							 color: Color red;
							 openInWorld: m owner;
							 position: 317 @ 47)])
		}
		extent: 407 @ 264