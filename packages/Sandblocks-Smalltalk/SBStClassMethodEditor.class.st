Class {
	#name : #SBStClassMethodEditor,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> class: aClass [

	self addMorphBack: (SBStClass newFor: aClass at: 0 @ 0).
	
	SBToggledCode
		comment: ''
		active: 2
		do: {
			[
				aClass methodDict valuesDo: [:method |
					self addMorphBack: ((SBStMethod newFor: method at: 0 @ 0)
						toggleCollapsed;
						hResizing: #spaceFill;
						yourself)]].
			[
				aClass organization categories do: [:category |
					self addMorphBack: (SBStMethodCategory new class: aClass category: category collapsed: aClass methodDict size > 20)]]
		}
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> deleteCommandFor: aBlock [

	aBlock childIndex < 2 ifTrue: [^ nil].
	self sandblockEditor do: (SBCombinedCommand newWith: {
		((SBStDeleteMethodCategoryCommand newFor: self)
			category: aBlock category;
			class: self firstSubmorph relatedClass).
		((SBDeleteCommand newFor: self) target: aBlock)
	})
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> initialize [

	super initialize.
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellGap: 4;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: (SBStMethodCategory new class: self firstSubmorph object category: 'untitled' collapsed: false);
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> isEditor [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true])
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> object [

	^ self firstSubmorph relatedClass
]

{ #category : #'as yet unclassified' }
SBStClassMethodEditor >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	^ false
]
