Class {
	#name : #SBVariant,
	#superclass : #SBStSubstitution,
	#instVars : [
		'name',
		'widget'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBVariant class >> example [

	SBMorphExample
		setUp: [self new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 300 @ 300.
	
	
]

{ #category : #'as yet unclassified' }
SBVariant class >> instanceSuggestion [

	^ [self newEmpty]
]

{ #category : #'as yet unclassified' }
SBVariant class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ aBlock receiver isBinding
		and: [aBlock receiver contents = 'SBVariant']
		and: [aBlock selector = 'named:associations:do:']
]

{ #category : #nil }
SBVariant class >> named: aString alternatives: aCollectionOfNamedBlocks activeIndex: aNumber [

	^ self new
		name: aString
		alternatives: aCollectionOfNamedBlocks
		activeIndex: aNumber
		
]

{ #category : #nil }
SBVariant class >> named: aString associations: aCollectionOfAssociations activeIndex: aNumber [

	^ aNumber > 0 ifTrue: [(aCollectionOfAssociations at: aNumber) value value] ifFalse: [nil]
		
]

{ #category : #'as yet unclassified' }
SBVariant class >> newEmpty [

	^ self new
]

{ #category : #'as yet unclassified' }
SBVariant class >> newFor: aBlock [

	^ self
		named: aBlock arguments first contents
		alternatives: (aBlock arguments second childSandblocks collect: [:anAssociation | SBNamedBlock block: (anAssociation arguments first) named: (anAssociation receiver contents)])
		activeIndex: aBlock arguments third parsedContents
]

{ #category : #'as yet unclassified' }
SBVariant class >> registerShortcuts: aProvider [

	aProvider registerShortcut: $f command do: #replaceSelfWithChosen.
	
]

{ #category : #'as yet unclassified' }
SBVariant >> active [

	^ self widget active
]

{ #category : #'as yet unclassified' }
SBVariant >> activeBlock [

	^ self widget activeBlock
]

{ #category : #'as yet unclassified' }
SBVariant >> activeIndex [

	^ self widget activeIndex
]

{ #category : #'as yet unclassified' }
SBVariant >> alternatives [

	^ self widget namedBlocks
]

{ #category : #'as yet unclassified' }
SBVariant >> color [

	^ Color transparent
]

{ #category : #'as yet unclassified' }
SBVariant >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBVariant >> initialize [

	super initialize.
	
	name := SBLabel new
		contents: 'variant X';
		layoutInset: 5 @ 5;
		vResizing: #shrinkWrap.
	widget := SBTabView
		namedBlocks: {SBNamedBlock block: (SBStBlockBody emptyWithDeclarations: {'a'. 'c'}) named: 'Code'}
		activeIndex: 1.
	
	widget when: #deletedLastTab send: #replaceSelfWithBlock: to: self.
	widget when: #changedActive send: #updateResize to: self.
	
	
	self
		layoutInset: 0;
		cellGap: 2.0;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #leftToRight;
		addAllMorphsBack: {name. widget}
]

{ #category : #'as yet unclassified' }
SBVariant >> name [

	^ name contents
]

{ #category : #'as yet unclassified' }
SBVariant >> name: aString [
	name contents: aString
]

{ #category : #'as yet unclassified' }
SBVariant >> named: aString alternatives: aCollectionOfNamedBlocks activeIndex: aNumber [

	self name: aString.
	self widget namedBlocks: aCollectionOfNamedBlocks activeIndex: aNumber
]

{ #category : #'as yet unclassified' }
SBVariant >> namedBlocks [ 

	^ self widget namedBlocks 
]

{ #category : #'as yet unclassified' }
SBVariant >> replaceSelfWithBlock: aNamedBlock [
	
	self replaceBlock: aNamedBlock block lastSubmorph
]

{ #category : #'as yet unclassified' }
SBVariant >> replaceSelfWithChosen [ 
	
	<action>
	self replaceSelfWithBlock: self active
]

{ #category : #'as yet unclassified' }
SBVariant >> updateResize [

	name vResizing: #shrinkWrap.
	widget lastSubmorph vResizing: #spaceFill.
	widget lastSubmorph hResizing: #spaceFill.
	self vResizing: #shrinkWrap.
	
	" mark a change"
	self flag: #todo. "replace with proper undo commands in tab view -jb"
	"self sandblockEditor do: (SBDoItCommand new artefact: self parentSandblock)."
]

{ #category : #'as yet unclassified' }
SBVariant >> widget [

	^ widget
]

{ #category : #'as yet unclassified' }
SBVariant >> writeSourceOn: aStream [

	aStream nextPutAll: '(SBVariant named: '.
	self name storeOn: aStream.
	aStream nextPutAll: ' associations: {'.
	self alternatives
		do: [:aNamedBlock |
			aNamedBlock name storeOn: aStream.
			aStream nextPutAll: ' -> ['.
			aNamedBlock block lastSubmorph writeSourceOn: aStream.
			aStream nextPut: $].
			]
		separatedBy: [aStream nextPut: $.].
	aStream nextPutAll: '} activeIndex: '.
	self activeIndex storeOn: aStream.
	aStream nextPutAll: ')'
]
