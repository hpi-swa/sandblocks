Class {
	#name : #SBTSParseExplore,
	#superclass : #Object,
	#instVars : [
		'stack',
		'lastOptions',
		'choiceIndices',
		'root',
		'stream'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSParseExplore >> canDelete: m [

	^ stream contents noneSatisfy: [:pair | pair second isMorph and: [m hasOwner: pair second]]
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> canVisitSymbol: aString [

	^ true
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> expandSymbol: aSymbolBlock [

	^ aSymbolBlock = root
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> explore: aStream type: aString factory: aFactory [

	lastOptions := OrderedCollection new.
	choiceIndices := Dictionary new.
	stack := OrderedCollection new.
	stream := aStream.
	
	root := self push: (SBToggledCode
		comment: ''
		active: 1
		do: {[aFactory getTemplate: aString]. [SBInlineBlockSymbol new type: aString factory: aFactory]}).
	
	[stack notEmpty] whileTrue: [ | block pair index |
		pair := stack last.
		index := pair first.
		block := pair second.
		(block unbuiltChildrenIn: self)
			at: index
			ifPresent: [:template | | child |
				pair at: 1 put: index + 1.
				child := self push: template.
				self assert: block submorphCount < (block unbuiltChildrenIn: self) size.
				block addMorphBack: child]
			ifAbsent: [
				stack removeLast.
				(stream atEnd and: [stack isEmpty]) ifTrue: [^ root].
				(block buildWithFields: stream alternatives: Dictionary new) ifFalse: [self restartFromLastChoiceIfDone: [^ nil]].
				(stack isEmpty and: [stream atEnd not]) ifTrue: [self restartFromLastChoiceIfDone: [^ nil]]]].
	
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
	(aBlockTemplate numAlternativesIn: self) > 1 ifTrue: [
		self indexFor: instance.
		lastOptions add: {instance. stack collect: [:pair | pair copy]. stream position}].
	^ instance
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> removeAllMorphsAfter: aMorph in: aParentMorph [

	| delete toDelete |
	delete := false.
	toDelete := OrderedCollection new.
	aParentMorph allMorphsMutableDo: [:m |
		(delete and: [(aMorph hasOwner: m) not])
			ifTrue: [
				SBToggledCode
					comment: ''
					active: 1
					do: {[(self canDelete: m) ifTrue: [toDelete add: m]]. [m delete]}]
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
	stream position: option third.
	
	number := choiceIndices at: option first put: (choiceIndices at: choice) + 1.
	self assert: number <= (choice numAlternativesIn: self).
	number = (choice numAlternativesIn: self) ifTrue: [lastOptions remove: option].
	self assert: (choice ownerChain includes: root).
	choice allMorphsMutableDo: [:m | m ~= choice ifTrue: [(self canDelete: m) ifTrue: [m delete]]].
	self removeAllMorphsAfter: choice in: root
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> skipOptionIn: aBlock [

	| number |
	number := (choiceIndices at: aBlock) + 1.
	choiceIndices at: aBlock put: number.
	number >= (aBlock numAlternativesIn: self) ifTrue: [lastOptions removeAllSuchThat: [:option | option first = aBlock]]
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> stream [

	^ stream
]

{ #category : #'as yet unclassified' }
SBTSParseExplore >> streamContainsBlock [

	^ true
]
