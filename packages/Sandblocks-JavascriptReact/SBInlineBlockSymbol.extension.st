Extension { #name : #SBInlineBlockSymbol }

{ #category : #'*Sandblocks-JavascriptReact' }
SBInlineBlockSymbol >> addExample [
	<action>
	<actionValidIf: #isSubmorphOfRenderMethod>

	| wrappedOwningClass |
	wrappedOwningClass := SBJsReactComponentWrapper componentNode: (self owningClass ifNil: [^ nil]).
	self halt.
	self flag: #TODO
	"
	ownPositionInClass := classMembers indexOf: self.
	alreadyHasExamples := (classMembers at: ownPositionInClass - 1 ifAbsent: [nil]) isSBJsComponentReplacement.
	alreadyHasExamples
		ifTrue: [ | aSBJsComponentReplacement |
			aSBJsComponentReplacement := classMembers at: ownPositionInClass - 1.
			aSBJsComponentReplacement addNewEmptyExample]
		ifFalse: [ | newExampleMember |
			newExampleMember := (SBJavascript parseElement: 'class {examples = [{componentProps:{}}]}') access children first body member owner owner.
			self owningClassBody firstSubmorph submorphs second
				addMorph: newExampleMember
				atIndex: ownPositionInClass.
			self owningClass applyReplacements]"
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
