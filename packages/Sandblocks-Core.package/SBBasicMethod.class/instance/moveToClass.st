as yet unclassified
moveToClass
	<action>

	^ UIManager default chooseClassOrTrait ifNotNil: [:class | | classOrInstanceSide |
		(classOrInstanceSide := UIManager default chooseFrom: {'Instance Side'. 'Class Side'}) ~= 0 ifTrue: [
			self sandblockEditor do: ((SBMoveMethodCommand newFor: self)
				method: self;
				toClass: (classOrInstanceSide = 2 ifTrue: [class class] ifFalse: [class])).
			self clearCache]]