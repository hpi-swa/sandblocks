"
A SBCodeAccordion is a code container that contains a number of code lenses. When clicked, it may focus a single code lens.
"
Class {
	#name : #SBCodeAccordion,
	#superclass : #SBCodeContainer,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCodeAccordion class >> newFor: aCollection [

	| accordion |
	accordion := self new.
	aCollection do: [:method | accordion addMorphBack: method asSandblock].
	^ accordion
]

{ #category : #'as yet unclassified' }
SBCodeAccordion class >> newForStack: aCollection [

	| y accordion |
	accordion := self new.
	y := 0.
	aCollection do: [:context | | methodBlock |
		methodBlock := SBCodeLens forContext: context.
		methodBlock fullBounds.
		accordion addMorphBack: methodBlock.
		methodBlock position: 0 @ y.
		y := y + methodBlock height].
	
	^ accordion
]

{ #category : #testing }
SBCodeAccordion >> canDeleteChild: aBlock [

	^ true
]

{ #category : #helper }
SBCodeAccordion >> checkExclusiveFocusTo: aBlock [

	| lens |
	aBlock ifNotNil: [
		lens := aBlock containingFloat.
		(lens notNil and: [lens owner = self and: [lens ~= aBlock]]) ifTrue: [
			lens expand.
			self submorphsDo: [:morph | morph = lens ifFalse: [morph collapseCompletely]]]]
]

{ #category : #testing }
SBCodeAccordion >> noteNewOwner: aMorph [

	super noteNewOwner: aMorph.
	aMorph sandblockEditor when: #selectionChanged send: #checkExclusiveFocusTo: to: self
]
