as yet unclassified
example

	SBMorphExample
		setUp: [
			SBEditor newFor: SBStateMachineEditor >> #exampleStateMachine]
		cases: {
			SBMorphExampleCase name: 'example 1' caseBlock: [:e | e]
		}
		extent: 535 @ 537