as yet unclassified
codeActions

	^ super codeActions, {
		(SBCodeAction
			labeled: 'Move to class ...'
			for: self
			do: [:node | 
				UIManager default chooseClassOrTrait ifNotNil: [:class |  | classOrInstanceSide |
					(classOrInstanceSide := UIManager default chooseFrom: {'Instance Side'. 'Class Side'}) ~= 0 ifTrue: [
						node sandblockEditor do: ((SBMoveMethodCommand newFor: self)
							method: self;
							toClass: (classOrInstanceSide = 2 ifTrue: [class class] ifFalse: [class]))]]])
	}