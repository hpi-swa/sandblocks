Class {
	#name : #SBExplorer,
	#superclass : #SBBlock,
	#instVars : [
		'object',
		'label',
		'wrapper'
	],
	#category : #'Sandblocks-Explorer'
}

{ #category : #'as yet unclassified' }
SBExplorer class >> on: anObject [

	^ self new on: anObject wrapper: nil; yourself
]

{ #category : #'as yet unclassified' }
SBExplorer class >> on: anObject field: aField [

	^ (self on: anObject) field: aField
]

{ #category : #'as yet unclassified' }
SBExplorer class >> on: anObject wrapper: aWrapper [

	^ self on: anObject wrapper: aWrapper
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
SBExplorer >> containingArtefact [

	^ self
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

	^ "self object sandblockColor"Color r: 0.95 g: 0.95 b: 0.95
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
SBExplorer >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	"| newObject |
	newObject := aBlock unpackSelection object.
	self on: newObject.
	field ifNotNil: [field setValueFor: field inspector to: newObject].
	self select.
	self toggleCollapsed.
	^ true"
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

{ #category : #testing }
SBExplorer >> isCollapsed [

	^ self submorphCount = 1
]

{ #category : #testing }
SBExplorer >> isEditor [

	^ true
]

{ #category : #testing }
SBExplorer >> isTopLevel [

	^ true
]

{ #category : #testing }
SBExplorer >> isViewer [

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
SBExplorer >> objectInterfaceAt: aNumber adding: aBoolean [

	^ SBInterfaces topLevel
]

{ #category : #'as yet unclassified' }
SBExplorer >> on: anObject wrapper: aWrapper [

	| row icon |
	self removeAllMorphs.
	
	object := anObject.
	wrapper := aWrapper ifNil: [ObjectExplorerWrapper with: object model: self].
	
	row := SBRow new cellGap: 4 withScalingFactor.
	row addMorphBack: (wrapper hasContents
		ifTrue: [
			SBIcon iconChevron_right
				on: #click send: #toggleCollapsed to: self;
				small;
				yourself]
		ifFalse: [
			Morph new
				color: Color transparent;
				extent: 1 @ 1]).
	icon := wrapper icon.
	icon = (ToolIcons icons at: #blank) ifFalse: [row addMorphBack: icon asMorph].
	row addMorphBack: (label := SBStringMorph new contents: (anObject printString truncateWithElipsisTo: 40)).
	
	self addMorphBack: row
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

	"| newObject |
	self label isSandblock ifFalse: [^ false].
	newObject := self label evaluate.
	self on: newObject.
	field ifNotNil: [field setValueFor: field inspector to: newObject].
	self select.
	self toggleCollapsed.
	^ true"
]

{ #category : #'as yet unclassified' }
SBExplorer >> startInputAt: aNumber replacingContents: aBoolean [

	"| new |
	new := [self object printString parseAsSandblockWithoutSubstitution] on: SyntaxErrorNotification do: [:error | 
		self newNullBlock].
	self sandblockEditor do: ((SBReplaceCommand newFor: self)
		target: self label;
		replacer: new;
		shouldMergeWithNext: true).
	self sandblockEditor replaceInput: new.
	^ new startInputAt: aNumber replacingContents: false"
]

{ #category : #'as yet unclassified' }
SBExplorer >> toggleCollapsed [
	<action>

	| caption |
	caption := self firstSubmorph.
	self isCollapsed not
		ifTrue: [
			label clearEmphasis.
			self firstSubmorph firstSubmorph changeIconName: #'iconChevron_right'.
			self
				removeAllMorphs;
				addMorphBack: caption]
		ifFalse: [
			wrapper hasContents ifTrue: [
				label bold.
				self firstSubmorph firstSubmorph changeIconName: #'iconChevron_down'.
				object explorerContents do: [:contents |
					self addMorphBack: (SBRow new
						cellGap: 4 withScalingFactor;
						layoutInset: (SBEdgeInsets left: 12 withScalingFactor right: 0 top: 0 bottom: 0);
						addMorphBack: (SBStringMorph new contents: contents itemName);
						addMorphBack: (SBExplorer on: contents object))]]]
]

{ #category : #'as yet unclassified' }
SBExplorer >> typeFor: aBlock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBExplorer >> update [

	self isCollapsed ifTrue: [^ self].
	
	(self submorphs viewFrom: 2 to: self submorphCount)
		with: object explorerContents
		do: [:row :contents |
			row submorphs second object == contents object
				ifTrue: [row submorphs second update]
				ifFalse: [
					row submorphs second replaceBy: (SBExplorer on: contents object wrapper: contents)]]
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
