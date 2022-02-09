Class {
	#name : #SBLinkedCopy,
	#superclass : #SBBlock,
	#instVars : [
		'link',
		'myUpdate'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLinkedCopy class >> for: aBlock [

	^ self new for: aBlock
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> artefactChanged: aMethodBlock [

	myUpdate ifTrue: [^ self].
	
	aMethodBlock = self ifTrue: [ | oldLink |
		oldLink := link.
		link replaceBy: (link := self firstSubmorph copyBlock).
		link containingArtefact
			triggerEvent: #linkEdited
			withArguments: {oldLink. link}.
		self sandblockEditor markChanged: link containingArtefact.
		
		myUpdate := true.
		[
			SBToggledCode
				comment: ''
				active: 0
				do: {[self sandblockEditor allBlocksDo: [:block | block artefactChanged: link containingArtefact]]}] ensure: [myUpdate := false]].
	
	SBToggledCode comment: '' active: 1 do: {
		[
			(aMethodBlock = link containingArtefact and: [link sourceString ~= self firstSubmorph sourceString]) ifTrue: [
				self firstSubmorph replaceBy: link copyBlock.
				self sandblockEditor markChanged: self]]}
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> artefactSaved: aMethodBlock [

	aMethodBlock = link containingArtefact ifTrue: [self sandblockEditor markSaved: self]
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> binding: aString for: block class: aClass ifPresent: aBlock [

	^ link parentSandblock ifNotNil: [:p | p binding: aString for: block class: aClass ifPresent: aBlock]
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> for: aBlock [

	| artefact |
	artefact := aBlock containingArtefact.
	self assert: artefact notNil.
	
	self addMorphBack: aBlock copyBlock.
	link := aBlock.
	artefact when: #linkEdited send: #updateLinkFrom:to: to: self
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> initialize [

	super initialize.
	
	myUpdate := false.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 4;
		attachDecorator: SBForceMoveDecorator newConfigured
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	self sandblockEditor
		save: link containingArtefact
		tryFixing: aFixBoolean
		quick: aQuickBoolean.
	^ false
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> scopesDo: aBlock [

	link parentSandblock scopesDo: aBlock
]

{ #category : #'as yet unclassified' }
SBLinkedCopy >> updateLinkFrom: oldLink to: newLink [

	oldLink = link ifTrue: [
		link := newLink.
		link sourceString ~= self firstSubmorph sourceString ifTrue: [self firstSubmorph replaceBy: link copyBlock].
		self sandblockEditor ifNotNil: [:e | e markChanged: self]]
]
