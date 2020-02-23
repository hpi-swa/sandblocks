as yet unclassified
exampleMorphToMorphAlign

	SBMorphExample
		setUp: [SBConnectorLine new lineType: #line]
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
							 openInWorld: m owner;
							 position: 294 @ 150)
						align: #bottom])
		}
		extent: 407 @ 264