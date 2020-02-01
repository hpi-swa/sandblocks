as yet unclassified
example

	SBMorphExample
		setUp: [JumpingCubes new]
		cases: {
			(SBMorphExampleCase
				name: 'example'
				caseBlock: [:m | 
					m submorphs second value: 3.
					(m submorphs at: 11) value: 3.
					m world doOneCycleNow.
					m firstSubmorph simulateMouseDown.
					m firstSubmorph simulateMouseUp])
		}
		extent: 265 @ 245