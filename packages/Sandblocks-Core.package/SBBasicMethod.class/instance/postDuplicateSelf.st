as yet unclassified
postDuplicateSelf

	currentSelector asSymbol isBinary ifTrue: [^ self shouldBeImplemented].
	
	self currentSelector: 'copy', currentSelector capitalized.
	self selector: self currentSelector arguments: self arguments class: self methodClass.
	
	super postDuplicateSelf.
	
	self
		hasUnsavedChanges: true;
		detachDecorators: SBMoveDecorator;
		attachDecorator: SBMoveDecorator new