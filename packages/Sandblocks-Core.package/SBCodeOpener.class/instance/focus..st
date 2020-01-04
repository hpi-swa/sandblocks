as yet unclassified
focus: aMethodOrClass

	aMethodOrClass isBehavior
		ifTrue: [
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass name).
			self focusPanel: 2]
		ifFalse: [
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass methodClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass methodClass name).
			self selectedMethodIndex: (self methods indexOf: aMethodOrClass selector).
			self focusPanel: 3]