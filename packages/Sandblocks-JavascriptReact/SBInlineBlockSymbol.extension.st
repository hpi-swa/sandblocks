Extension { #name : #SBInlineBlockSymbol }

{ #category : #'*Sandblocks-JavascriptReact' }
SBInlineBlockSymbol >> addExample [
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
]

{ #category : #'*Sandblocks-JavascriptReact' }
SBInlineBlockSymbol >> isSubmorphOfRenderMethod [

	^ self type = 'method_definition' and: [self access children first contents = 'render']
]

{ #category : #'*Sandblocks-JavascriptReact' }
SBInlineBlockSymbol >> owningClass [

	^ self ownerOfType: 'class_declaration'
]

{ #category : #'*Sandblocks-JavascriptReact' }
SBInlineBlockSymbol >> owningClassBody [

	^ self ownerOfType: 'class_body'
]
