as yet unclassified
exampleSameSize
	SBMorphExample
		setUp: [SBEditor new
				openMorph: (SBCodeContainer new
						addMorph: (Morph new color: Color red));
				
				openMorph: (SBCodeContainer new
						addMorph: (Morph new color: Color green));
				 yourself]
		cases: {SBMorphExampleCase
				name: 'a'
				caseBlock: [:c | ]}
		extent: 619 @ 574