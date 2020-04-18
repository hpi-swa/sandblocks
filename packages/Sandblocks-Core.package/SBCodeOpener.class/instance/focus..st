as yet unclassified
focus: aMethodOrClass

	aMethodOrClass isBehavior
		ifTrue: [
			self showingClassSide: aMethodOrClass isClassSide.
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass theNonMetaClass name).
			self focusPanel: 3]
		ifFalse: [
			self showingClassSide: aMethodOrClass methodClass isClassSide.
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass methodClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass methodClass theNonMetaClass name).
			self selectedMethodIndex: (self methods indexOf: aMethodOrClass selector).
			self focusPanel: 3]