Class {
	#name : #SBVariant,
	#superclass : #SBStSubstitution,
	#instVars : [
		'name',
		'widget'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #testing }
SBVariant class >> example [

	SBMorphExample
		setUp: [self new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 300 @ 300.
	
	
]

{ #category : #suggestions }
SBVariant class >> instanceSuggestion [

	^ [self newEmpty]
]

{ #category : #testing }
SBVariant class >> matches: aBlock [

	(super matches: aBlock) ifFalse: [^ false].
	
	^ aBlock receiver isBinding
		and: [aBlock receiver contents = 'SBVariant']
		and: [aBlock selector = 'named:associations:activeIndex:']
]

{ #category : #'instance creation' }
SBVariant class >> named: aString alternatives: aCollectionOfNamedBlocks activeIndex: aNumber [

	^ self new
		named: aString
		alternatives: aCollectionOfNamedBlocks
		activeIndex: aNumber
		
]

{ #category : #'instance creation' }
SBVariant class >> named: aString associations: aCollectionOfAssociations activeIndex: aNumber [

	^ aNumber > 0 ifTrue: [(aCollectionOfAssociations at: aNumber) value value] ifFalse: [nil]
		
]

{ #category : #'instance creation' }
SBVariant class >> newEmpty [

	^ self new
]

{ #category : #'instance creation' }
SBVariant class >> newFor: aBlock [

	^ self
		named: aBlock arguments first contents
		alternatives: (aBlock arguments second childSandblocks collect: [:anAssociation | SBNamedBlock block: (anAssociation arguments first) named: (anAssociation receiver contents)])
		activeIndex: aBlock arguments third parsedContents
]

{ #category : #shortcuts }
SBVariant class >> registerShortcuts: aProvider [

	aProvider registerShortcut: $f command do: #replaceSelfWithChosen.
	
]

{ #category : #accessing }
SBVariant >> active [

	^ self widget active
]

{ #category : #accessing }
SBVariant >> activeBlock [

	^ self widget activeBlock
]

{ #category : #accessing }
SBVariant >> activeIndex [

	^ self widget activeIndex
]

{ #category : #accessing }
SBVariant >> alternatives [

	^ self widget namedBlocks
]

{ #category : #accessing }
SBVariant >> color [

	^ Color transparent
]

{ #category : #accessing }
SBVariant >> drawnColor [

	^ Color white
]

{ #category : #initialization }
SBVariant >> initialize [

	super initialize.
	
	name := SBLabel new
		contents: 'variant X';
		layoutInset: 5 @ 5;
		hResizing: #spaceFill.
	self widget: (SBTabView
		namedBlocks: {SBNamedBlock block: (SBStBlockBody emptyWithDeclarations: {'a'. 'c'}) named: 'Code'}
		activeIndex: 1).
	
	
	self
		layoutInset: 0;
		cellGap: 2.0;
		listDirection: #topToBottom;
		changeTableLayout;
		addAllMorphsBack: {name. widget};
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #accessing }
SBVariant >> name [

	^ name contents
]

{ #category : #accessing }
SBVariant >> name: aString [
	name contents: aString
]

{ #category : #initialization }
SBVariant >> named: aString alternatives: aCollectionOfNamedBlocks activeIndex: aNumber [

	self name: aString.
	self widget namedBlocks: aCollectionOfNamedBlocks activeIndex: aNumber
]

{ #category : #accessing }
SBVariant >> namedBlocks [ 

	^ self widget namedBlocks 
]

{ #category : #actions }
SBVariant >> replaceSelfWithBlock: aNamedBlock [
	
	"As deleting the last tab also deletes the tab view, we gotta recreate it"
	self widget: (SBTabView namedBlocks: {aNamedBlock} activeIndex: 1).
	self addMorphBack: widget.
	
	self sandblockEditor do: (SBUnwrapConsecutiveCommand new 
									target: self; 
									unwrapped: {widget activeBlock lastSubmorph})
]

{ #category : #actions }
SBVariant >> replaceSelfWithChosen [ 
	
	<action>
	self sandblockEditor do: (SBUnwrapConsecutiveCommand new 
									target: self; 
									unwrapped: {self activeBlock lastSubmorph})
]

{ #category : #ui }
SBVariant >> updateResize [

	self hResizing: #shrinkWrap.
	name hResizing: #spaceFill
	
]

{ #category : #accessing }
SBVariant >> widget [

	^ widget
]

{ #category : #accessing }
SBVariant >> widget: aSBTabView [

	
	widget := aSBTabView.
	
	widget when: #deletedLastTab send: #replaceSelfWithBlock: to: self.
	widget when: #changedActive send: #updateResize to: self
]

{ #category : #printing }
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
