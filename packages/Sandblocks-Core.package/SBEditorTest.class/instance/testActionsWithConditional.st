as yet unclassified
testActionsWithConditional

	| block |
	block := SBMockBlock new.
	self editorFor: block.
	self assert: ((block validActions collect: #selector) includes: #mockAction).
	self deny: ((block validActions collect: #selector) includes: #conditionalMockAction).
	block actionValid: true.
	self assert: ((block validActions collect: #selector) includes: #conditionalMockAction)