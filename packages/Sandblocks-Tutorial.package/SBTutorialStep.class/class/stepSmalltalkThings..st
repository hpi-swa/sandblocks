as yet unclassified
stepSmalltalkThings: anEditor

	SBTutorialStep new
		title: 'Smalltalk Things';
		addAction: #wrapInDynamicArray;
		addAction: #wrapInBlock;
		addAction: #wrapInReturn;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [
						5 = 2 ifTrue: (Transcript showln: 'true') ifFalse: [123].
						65 do: [:each | each].
						Morph new]
					in: anEditor.
				step
					addStep: 'Wrap the ifTrue: branch in a block by selecting the whole message send via shift+K, then press [.'
					checkCondition: [:editor |
						method statements first arguments first isBlockBody].
				step
					addStep: 'Next, wrap the 65 in an array by pressing {. Note that the yellow outline indicates that #do: is not understood by 65.'
					checkCondition: [:editor | method statements second receiver isArrayBlock].
				step
					addStep: 'Finally, wrap the last statement in a return by pressing ^.'
					checkCondition: [:editor | method statements last isReturn]]