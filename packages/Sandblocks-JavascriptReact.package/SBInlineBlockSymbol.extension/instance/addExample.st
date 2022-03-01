*Sandblocks-JavascriptReact
addExample
	<action>
	<actionValidIf: #isSubmorphOfRenderMethod>

	| wrappedOwningClass |
	wrappedOwningClass := SBJsReactComponentWrapper componentNode: (self owningClass ifNil: [^ nil]).
	wrappedOwningClass existingExamples
		ifNotNil: [:aSBTSFieldAccessor | aSBTSFieldAccessor element addNewEmptyExample]
		ifNil: [ | positionInClass newExampleMember |
			positionInClass := wrappedOwningClass positionOfMember: self.
			newExampleMember := (SBJavascript parseElement: 'class {examples = [{componentProps:{}}]}') access body member owner.
			self owningClassBody firstSubmorph submorphs second
				addMorph: newExampleMember
				atIndex: positionInClass.
			self owningClass applyReplacements]