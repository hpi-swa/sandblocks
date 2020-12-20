as yet unclassified
addMethods

	(class organization listAtCategoryNamed: savedCategoryName) do: [:method |
			self addMorphBack: ((class lookupSelector: method) asSandblock
				toggleCollapsed;
				hResizing: #spaceFill)]