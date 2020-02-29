as yet unclassified
exampleMorphToMorphAlign

	SBMorphExample
		setUp: [SBConnectorLine new lineType: #curve]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m | 
					m
						connect: (Morph new
							 color: Color green;
							 openInWorld: m owner;
							 position: 88 @ 54)
						align: #left
						to: (Morph new
							 color: Color red;
							 openInWorld: m owner;
							 position: 294 @ 150)
						align: #bottom])
		}
		extent: 407 @ 264