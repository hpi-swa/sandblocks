as yet unclassified
exampleConnectorType

	SBMorphExample
		setUp: [SBConnectorLine new connectorType: #dots]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m |  | morph |
					m color: (Color r: 0.4 g: 0.4 b: 0.4).
					m
						connect: (Morph new
							color: Color green;
							position: 40 @ 40;
							openInWorld: m owner)
						to: (Morph new
							color: Color yellow;
							position: 177 @ 148;
							openInWorld: m owner)])
		}
		extent: 300 @ 300