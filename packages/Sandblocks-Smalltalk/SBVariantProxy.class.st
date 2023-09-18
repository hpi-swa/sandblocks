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

{ #category : #callbacks }
SBVariantProxy >> artefactChanged: anArtefact [

	anArtefact = self ifTrue: [ self updateOriginalWithOwnValues ].
		
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
	
	variantThatNeedsChanging ifNil: [self delete. ^ self].
	
	original replaceBy: (original := self firstSubmorph copyBlock).
	variantThatNeedsChanging replaceValuesFrom: original copyBlock.
	self sandblockEditor markChanged: self containedMethod
]

{ #category : #callbacks }
SBVariantProxy >> updateSelfAfterMethodUpdate: newMethod [
		
	| variantThatMaybeChanged |
	variantThatMaybeChanged := newMethod detectVariant: original.
	
	variantThatMaybeChanged ifNil: [self delete. ^ self].
	
	(variantThatMaybeChanged sourceString ~= self firstSubmorph sourceString)
		ifTrue: [
			original := variantThatMaybeChanged.
			self firstSubmorph replaceBy: original copyBlock.
			self sandblockEditor markChanged: self]
				
]
