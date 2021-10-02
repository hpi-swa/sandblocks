Class {
	#name : #SBTSParseExplore,
	#superclass : #Object,
	#instVars : [
		'stack',
		'cursor',
		'lastOptions',
		'choiceIndices',
		'root'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSParseExplore >> canVisitSymbol: aString [

	^ true
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> explore: aCursor [

	lastOptions := OrderedCollection new.
	choiceIndices := Dictionary new.
	stack := OrderedCollection new.
	cursor := aCursor.
	
	root := self push: (SBInlineBlockSymbol new type: aCursor type factory: aCursor factory).
	self assert: (root advanceParseFrom: aCursor index: 1).
	self halt.
	
	[stack notEmpty] whileTrue: [ | block pair index |
		pair := stack last.
		index := pair first.
		block := pair second.
		(block unbuiltChildrenIn: self)
			at: index
			ifPresent: [:template | | child |
				pair at: 1 put: index + 1.
				child := self push: template.
				block addMorphBack: child.
				(child advanceParseFrom: aCursor index: index) ifFalse: [self restartFromLastChoiceIfDone: [^ nil]]]
			ifAbsent: [
				stack removeLast.
				(block takeParseFrom: aCursor) ifFalse: [self restartFromLastChoiceIfDone: [^ nil]]]].
	^ root
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> hasOptionOnStack: aBlock [

	self flag: #fixme.
	" is it =2? or is it =indexOf(recur)? "
	^ stack anySatisfy: [:pair | (pair second hasSameStructureAs: aBlock) and: [pair first = 2]]
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> indexFor: aBlock [

	^ choiceIndices at: aBlock ifAbsentPut: [1]
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> push: aBlockTemplate [

	| instance |
	instance := aBlockTemplate buildEmpty.
	stack add: {1. instance}.
	aBlockTemplate numAlternatives > 1 ifTrue: [
		self indexFor: instance.
		lastOptions add: {instance. stack collect: [:pair | pair copy]. cursor position}].
	^ instance
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> removeAllMorphsAfter: aMorph in: aParentMorph [

	| delete toDelete |
	delete := false.
	toDelete := OrderedCollection new.
	aParentMorph allMorphsMutableDo: [:m |
		(delete and: [(aMorph hasOwner: m) not])
			ifTrue: [SBToggledCode comment: '' active: 1 do: {[toDelete add: m]. [m delete]}]
			ifFalse: [m = aMorph ifTrue: [delete := true]]].
	toDelete do: #delete
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> restartFromLastChoiceIfDone: aBlock [

	| option choice number |
	lastOptions ifEmpty: [^ aBlock value].
	
	option := lastOptions last.
	choice := option first.
	stack := option second collect: [:pair | pair copy].
	cursor position: option third.
	
	number := choiceIndices at: option first put: (choiceIndices at: choice) + 1.
	self assert: number <= choice numAlternatives.
	number = choice numAlternatives ifTrue: [lastOptions remove: option].
	self assert: (choice ownerChain includes: root).
	choice allMorphsMutableDo: [:m | m ~= choice ifTrue: [m delete]].
	self removeAllMorphsAfter: choice in: root
]
