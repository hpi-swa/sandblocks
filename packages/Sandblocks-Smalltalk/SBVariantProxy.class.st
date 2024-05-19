Class {
	#name : #SBVariantProxy,
	#superclass : #SBBlock,
	#instVars : [
		'original',
		'containedMethod'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'instance creation' }
SBVariantProxy class >> for: aVariant [

	^ self new for: aVariant
]

{ #category : #accessing }
SBVariantProxy >> activeIndex [

	^ original activeIndex
]

{ #category : #callbacks }
SBVariantProxy >> artefactChanged: anArtefact [
	
	anArtefact = self ifTrue: [self updateOriginalWithOwnValues ].
		
	(anArtefact = self containedMethod)
		ifTrue: [ self updateSelfAfterMethodUpdate: anArtefact ]
]

{ #category : #callbacks }
SBVariantProxy >> artefactSaved: anArtefact [

	anArtefact = self containedMethod ifTrue: [self sandblockEditor markSaved: self]
]

{ #category : #'ast helpers' }
SBVariantProxy >> binding: aString for: block class: aClass ifPresent: aBlock [
	
	^ original binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #accessing }
SBVariantProxy >> changeActiveIndexTo: aNewIndex [

	self firstSubmorph switchToAlternativeWithoutSaving: aNewIndex.
	self updateOriginalWithOwnValues
	
	
]

{ #category : #accessing }
SBVariantProxy >> containedMethod [

	^ containedMethod
]

{ #category : #initialization }
SBVariantProxy >> for: aVariant [

	containedMethod := aVariant containingArtefact.
	self assert: containedMethod notNil.
	
	original := aVariant.
	self addMorphBack: original copyBlock.
]

{ #category : #accessing }
SBVariantProxy >> id [

	^ original id
]

{ #category : #initialization }
SBVariantProxy >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 4;
		attachDecorator: SBForceMoveDecorator newConfigured
]

{ #category : #testing }
SBVariantProxy >> isArtefact [

	^ true
]

{ #category : #testing }
SBVariantProxy >> isVariantProxy [

	^ true
]

{ #category : #accessing }
SBVariantProxy >> original [

	^ original
]

{ #category : #'artefact protocol' }
SBVariantProxy >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	self sandblockEditor
		save: self containedMethod
		tryFixing: aFixBoolean
		quick: aQuickBoolean.
	^ false
]

{ #category : #'ast helpers' }
SBVariantProxy >> scopesDo: aBlock [

	original scopesDo: aBlock
]

{ #category : #callbacks }
SBVariantProxy >> updateOriginalWithOwnValues [

	| variantThatNeedsChanging |
	variantThatNeedsChanging := self containedMethod detectVariant: original.
	variantThatNeedsChanging ifNil: [^self delete].
	
	original replaceBy: (original := self firstSubmorph copyBlock).
	"If a double click on the widget occured and it replaced itself with code or text"
	original isVariant ifFalse: [
			self containedMethod save.
			^ self delete].
	
	variantThatNeedsChanging replaceValuesFrom: original copyBlock.
	self containedMethod isInEditor
		ifTrue: [self sandblockEditor markChanged: self containedMethod] 
		ifFalse: [self containedMethod save].
	
]

{ #category : #callbacks }
SBVariantProxy >> updateSelfAfterMethodUpdate: newMethod [
		
	| variantThatMaybeChanged |
	variantThatMaybeChanged := newMethod detectVariant: original.
	containedMethod := newMethod.
	
	variantThatMaybeChanged ifNil: [^self delete].
	
	(variantThatMaybeChanged sourceString ~= self firstSubmorph sourceString)
		ifTrue: [
			original := variantThatMaybeChanged.
			self firstSubmorph replaceBy: original copyBlock.
			self sandblockEditor markChanged: self]
				
]
