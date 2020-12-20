as yet unclassified
handleDroppedBlock: aBlock event: anEvent

	| insertCommand changeCategoryCommand |
	SBExample
		self: [
			SBMethodCategory new class: FrameRateMorph category: 'stepping and presenter' collapsed: false]
		args: [{(FrameRateMorph >> #step) asSandblock. nil}]
		label: 'example'.
	insertCommand := (SBInsertCommand newFor: self)
		index: 2;
		morph: ((aBlock object representationThat: #isMethodBlock)
			toggleCollapsed;
			hResizing: #spaceFill;
			yourself);
		container: self.
	changeCategoryCommand := (SBChangeMethodCategoryCommand newFor: self)
		method: aBlock object;
		category: self firstSubmorph contents;
		class: class.
	self sandblockEditor do: (SBCombinedCommand newWith: (aBlock isSelection
		ifTrue: [
			{
				changeCategoryCommand.
				((SBDeleteCommand newFor: self) target: aBlock sourceBlock).
				insertCommand
			}]
		ifFalse: [{changeCategoryCommand. insertCommand}]))