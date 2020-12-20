as yet unclassified
focus: aMethodOrClass

	aMethodOrClass ifNil: [^ self].
	
	aMethodOrClass isBehavior
		ifTrue: [
			self showingClassSide: aMethodOrClass isClassSide.
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass theNonMetaClass name) moved: false.
			self selectedMethodIndex: 1.
			self focusPanel: 3]
		ifFalse: [
			self showingClassSide: aMethodOrClass methodClass isClassSide.
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass methodClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass methodClass theNonMetaClass name).
			self selectedMethodIndex: (self methods indexOf: aMethodOrClass selector) moved: false.
			self focusPanel: 3]