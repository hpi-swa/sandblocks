examples
exampleSameSize
	SBMorphExample
		setUp: [SBEditor new
				openMorphInView: (SBCodeContainer new
						addMorph: (Morph new color: Color red));
				
				openMorphInView: (SBCodeContainer new
						addMorph: (Morph new color: Color green));
				 yourself]
		cases: {SBMorphExampleCase
				name: 'a'
				caseBlock: [:c | ]}
		extent: 619 @ 574