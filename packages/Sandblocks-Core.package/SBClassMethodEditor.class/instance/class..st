as yet unclassified
class: aClass

	self addMorphBack: (SBClass newFor: aClass at: 0 @ 0).
	
	SBToggledCode
		comment: ''
		active: 2
		do: {
			[
				aClass methodDict valuesDo: [:method |
					self addMorphBack: ((SBMethod newFor: method at: 0 @ 0)
						toggleCollapsed;
						hResizing: #spaceFill;
						yourself)]].
			[
				aClass organization categories do: [:category |
					self addMorphBack: (SBMethodCategory new class: aClass category: category collapsed: aClass methodDict size > 20)]]
		}