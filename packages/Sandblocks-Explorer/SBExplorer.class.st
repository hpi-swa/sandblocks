Class {
	#name : #SBExplorer,
	#superclass : #SBBlock,
	#instVars : [
		'inspector',
		'object',
		'hasUnsavedChanges',
		'label',
		'field'
	],
	#category : #'Sandblocks-Explorer'
}

{ #category : #'as yet unclassified' }
SBExplorer class >> on: anObject [

	^ self new on: anObject; yourself
]

{ #category : #'as yet unclassified' }
SBExplorer class >> on: anObject field: aField [

	^ (self on: anObject) field: aField
]

{ #category : #'as yet unclassified' }
SBExplorer >> browse [
	<action>

	self object class browse
]

{ #category : #'as yet unclassified' }
SBExplorer >> cacheType: aClass for: aBlock [
]

{ #category : #'as yet unclassified' }
SBExplorer >> canCopy [

	^ false
]

{ #category : #'as yet unclassified' }
SBExplorer >> childSandblocksDo: aBlock [

	self label isSandblock ifTrue: [aBlock value: self label].
	
	self submorphs from: 2 to: self submorphCount do: [:row |
		aBlock value: row submorphs second]
]

{ #category : #'as yet unclassified' }
SBExplorer >> containingArtefact [

	^ self
]

{ #category : #'as yet unclassified' }
SBExplorer >> contextAcceptedRepresentationAt: aNumber [

	^ #isToplevelMorph
]

{ #category : #actions }
SBExplorer >> copyString [
	<action>
	
	Clipboard clipboardText: self object printString
]

{ #category : #'as yet unclassified' }
SBExplorer >> declarations [

	^ #()
]

{ #category : #'as yet unclassified' }
SBExplorer >> deleteCommandFor: aBlock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBExplorer >> doubleClick: anEvent [

	self toggleCollapsed
]

{ #category : #'as yet unclassified' }
SBExplorer >> drawnColor [

	^ self object sandblockColor
]

{ #category : #'as yet unclassified' }
SBExplorer >> ensureExpanded [

	self isCollapsed ifTrue: [self toggleCollapsed]
]

{ #category : #'as yet unclassified' }
SBExplorer >> evaluate [

	^ self object
]

{ #category : #'as yet unclassified' }
SBExplorer >> evaluateWith: anObject for: aReceiverObject [

	^ object
]

{ #category : #'as yet unclassified' }
SBExplorer >> evaluationContext [

	^ nil
]

{ #category : #'as yet unclassified' }
SBExplorer >> evaluationReceiver [

	^ self object
]

{ #category : #'as yet unclassified' }
SBExplorer >> field: aField [

	field := aField
]

{ #category : #'as yet unclassified' }
SBExplorer >> handleDroppedBlock: aBlock event: anEvent [

	| newObject |
	newObject := aBlock object representationThat: #isObject.
	self on: newObject.
	field ifNotNil: [field setValueFor: field inspector to: newObject].
	self select.
	self toggleCollapsed.
	^ true
]

{ #category : #'as yet unclassified' }
SBExplorer >> hasUnsavedChanges [

	^ hasUnsavedChanges
]

{ #category : #'as yet unclassified' }
SBExplorer >> hasUnsavedChanges: aBoolean [

	hasUnsavedChanges := aBoolean
]

{ #category : #'as yet unclassified' }
SBExplorer >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 2 withScalingFactor;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBExplorer >> isCollapsed [

	^ self submorphCount = 1
]

{ #category : #'as yet unclassified' }
SBExplorer >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBExplorer >> label [

	^ self firstSubmorph lastSubmorph
]

{ #category : #'as yet unclassified' }
SBExplorer >> object [

	^ object
]

{ #category : #'as yet unclassified' }
SBExplorer >> object: anObject [

	object := anObject
]

{ #category : #'as yet unclassified' }
SBExplorer >> objectInterface [

	^ SBInterfaces topLevel
]

{ #category : #'as yet unclassified' }
SBExplorer >> on: anObject [

	self removeAllMorphs.
	
	inspector := anObject inspectorClass on: anObject.
	object := anObject.
	self addMorphBack: (SBRow new
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBIcon iconBars
			on: #startDrag send: #pickUp: to: self;
			small;
			yourself);
		addMorphBack: (label := SBStringMorph new contents: (anObject asString truncateWithElipsisTo: 40)))
]

{ #category : #'as yet unclassified' }
SBExplorer >> printOn: aStream [

	aStream nextPutAll: 'explorer on '.
	aStream nextPutAll: (self object printStringLimitedTo: 40)
]

{ #category : #'as yet unclassified' }
SBExplorer >> relatedClass [

	^ self object class
]

{ #category : #'as yet unclassified' }
SBExplorer >> replace: anObject [

	self on: anObject
]

{ #category : #'as yet unclassified' }
SBExplorer >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	| newObject |
	self label isSandblock ifFalse: [^ false].
	newObject := self label evaluate.
	self on: newObject.
	field ifNotNil: [field setValueFor: field inspector to: newObject].
	self select.
	self toggleCollapsed.
	^ true
]

{ #category : #'as yet unclassified' }
SBExplorer >> startInputAt: aNumber replacingContents: aBoolean [

	| new |
	new := [self object printString parseAsSandblockWithoutSubstitution] on: SyntaxErrorNotification do: [:error | 
		self newNullBlock].
	self sandblockEditor do: ((SBReplaceCommand newFor: self)
		target: self label;
		replacer: new;
		shouldMergeWithNext: true).
	self sandblockEditor replaceInput: new.
	^ new startInputAt: aNumber replacingContents: false
]

{ #category : #'as yet unclassified' }
SBExplorer >> toggleCollapsed [
	<action>

	| caption |
	caption := self firstSubmorph.
	self isCollapsed not
		ifTrue: [
			label clearEmphasis.
			self
				removeAllMorphs;
				addMorphBack: caption]
		ifFalse: [
			label bold.
			inspector streamFieldsOn: (SBImmediateStream with: [:field | 
				(#(#all #self) includes: field type) ifFalse: [
					self addMorphBack: (SBRow new
						cellGap: 4 withScalingFactor;
						layoutInset: (SBEdgeInsets left: 12 withScalingFactor right: 0 top: 0 bottom: 0);
						addMorphBack: (SBStringMorph new contents: field name asString);
						addMorphBack: (SBExplorer on: ([field getValueFor: inspector] on: Error do: [nil]) field: (field inspector: inspector)))]])]
]

{ #category : #'as yet unclassified' }
SBExplorer >> typeFor: aBlock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBExplorer >> update [

	| fields |
	self isCollapsed ifTrue: [^ self].
	
	fields := Array streamContents: [:stream |
		inspector streamFieldsOn: (SBImmediateStream with: [:subfield |
			(#(#all #self) includes: subfield type) ifFalse: [stream nextPut: subfield]])].
	
	(self submorphs viewFrom: 2 to: self submorphCount)
		with: fields
		do: [:row :subField | | newObject |
			newObject := [subField getValueFor: inspector] on: Error do: [nil].
			row submorphs second object == newObject
				ifTrue: [row submorphs second update]
				ifFalse: [
					row submorphs second replaceBy: (SBExplorer on: newObject field: (subField inspector: inspector))]]
]

{ #category : #'as yet unclassified' }
SBExplorer >> veryDeepCopyWith: aCopier [

	" ensure that we not duplicate our observed object, this may consequences and will usually not be our intent "
	| oldObject copy |
	oldObject := object.
	object := nil.
	copy := super veryDeepCopyWith: aCopier.
	object := oldObject.
	copy object: object.
	^ copy
]

{ #category : #'as yet unclassified' }
SBExplorer >> wantsInteractiveErrorCorrection [

	^ false
]
