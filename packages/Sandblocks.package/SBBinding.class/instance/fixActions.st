as yet unclassified
fixActions

	^ self validBinding
		ifTrue: [#()]
		ifFalse: [{
			SBCodeAction
				labeled: 'Declare method temporary' for: self
				do: [:node | node containingMethod body declareTemporaryVariable: node contents].
			SBCodeAction
				labeled: 'Declare block-local variable' for: self
				do: [:node | node containingBlock declareTemporaryVariable: node contents].
			SBCodeAction
				labeled: 'Declare instance variable' for: self
				do: [:node | node sandblockEditor declareInstanceVariable: node contents].
		}]