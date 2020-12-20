as yet unclassified
example

	SBMorphExample
		setUp: [SBButton new]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m |
					m label: 'Hello' shortcut: $p command do: [nil].
					m owner addMorphBack: (SBButton new icon: (SBIcon iconUndo color: Color black) shortcut: $p asSandblockShortcut do: [nil])])
		}
		extent: 300 @ 300