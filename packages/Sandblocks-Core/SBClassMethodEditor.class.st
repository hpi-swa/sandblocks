Class {
	#name : #SBClassMethodEditor,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> class: aClass [

	self addMorphBack: (SBClass newFor: aClass at: 0 @ 0).
	
	SBToggledCode
		comment: ''
		active: 2
		do: {
			[
				aClass methodDict valuesDo: [:method |
					self addMorphBack: ((SBMethod newFor: method at: 0 @ 0)
						toggleCollapsed;
						hResizing: #spaceFill;
						yourself)]].
			[
				aClass organization categories do: [:category |
					self addMorphBack: (SBMethodCategory new class: aClass category: category collapsed: aClass methodDict size > 20)]]
		}
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> deleteCommandFor: aBlock [

	aBlock childIndex < 2 ifTrue: [^ nil].
	self sandblockEditor do: (SBCombinedCommand newWith: {
		((SBDeleteMethodCategoryCommand newFor: self)
			category: aBlock category;
			class: self firstSubmorph relatedClass).
		((SBDeleteCommand newFor: self) target: aBlock)
	})
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> hasUnsavedChanges [

	^ false
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> hasUnsavedChanges: aBoolean [

	
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> initialize [

	super initialize.
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		cellGap: 4;
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: (SBMethodCategory new class: self firstSubmorph object category: 'untitled' collapsed: false);
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> isEditor [

	^ true
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true])
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> object [

	^ self firstSubmorph relatedClass
]

{ #category : #'as yet unclassified' }
SBClassMethodEditor >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	^ false
]
