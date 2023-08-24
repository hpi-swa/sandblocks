Class {
	#name : #SBVariant,
	#superclass : #SBStSubstitution,
	#instVars : [
		'name',
		'widget',
		'id'
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
		and: [aBlock selector = self matchingSelector]
]

{ #category : #constants }
SBVariant class >> matchingSelector [

	^ #named:associations:activeIndex:id:
]

{ #category : #'instance creation' }
SBVariant class >> named: aString alternatives: aCollectionOfNamedBlocks activeIndex: aNumber [

	^ self new
		named: aString
		alternatives: aCollectionOfNamedBlocks
		activeIndex: aNumber
		
]

{ #category : #'instance creation' }
SBVariant class >> named: aString alternatives: aCollectionOfNamedBlocks activeIndex: aNumber id: uuid [

	^ self new
		named: aString
		alternatives: aCollectionOfNamedBlocks
		activeIndex: aNumber
		id: uuid
		
]

{ #category : #'instance creation' }
SBVariant class >> named: aString associations: aCollectionOfAssociations activeIndex: aNumber id: uuid [

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
		id: aBlock arguments fourth contents
]

{ #category : #shortcuts }
SBVariant class >> registerShortcuts: aProvider [

	aProvider registerShortcut: $f command do: #replaceSelfWithChosen.
	
]

{ #category : #comparing }
SBVariant >> = otherVariant [

	^ otherVariant class = self class and: [otherVariant id = self id]
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

{ #category : #comparing }
SBVariant >> alternativesEqual: otherAlternatives [

	"Private"
	"Does a cheap version of python's zip and then allSatisfy:"
	| areSame |
	areSame := true.
	^ self alternatives size = otherAlternatives size and: [
		(1 to: self alternatives size) do: [:index | 
			areSame := areSame and: [(self alternatives at: index) = (otherAlternatives at: index)]]. 		areSame]
]

{ #category : #accessing }
SBVariant >> color [

	^ Color transparent
]

{ #category : #accessing }
SBVariant >> drawnColor [

	^ Color white
]

{ #category : #accessing }
SBVariant >> id [
	^ id
]

{ #category : #accessing }
SBVariant >> id: anObject [
	id := anObject
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
	id := UUID new asString. 
	
	self
		layoutInset: 0;
		cellGap: 2.0;
		listDirection: #topToBottom;
		changeTableLayout;
		addAllMorphsBack: {name. widget};
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #testing }
SBVariant >> isVariant [ 

	^ true
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

{ #category : #initialization }
SBVariant >> named: aString alternatives: aCollectionOfNamedBlocks activeIndex: aNumber id: uuid [

	self id: uuid.
	self named: aString alternatives: aCollectionOfNamedBlocks activeIndex: aNumber
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

{ #category : #initialization }
SBVariant >> replaceValuesFrom: anotherVariant [

	self named: anotherVariant name alternatives: anotherVariant alternatives activeIndex: anotherVariant activeIndex  
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
	aStream nextPutAll: ' id: '.
	self id storeOn: aStream.
	aStream nextPutAll: ')'
]
