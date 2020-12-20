as yet unclassified
exampleMorphToSelf

	SBMorphExample
		setUp: [SBConnectorLine new lineType: #line]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m |  | morph |
					m color: Color red.
					morph := Morph new position: 100 @ 100.
					m connect: morph to: morph.
					morph openInWorld: m owner])
		}
		extent: 407 @ 264