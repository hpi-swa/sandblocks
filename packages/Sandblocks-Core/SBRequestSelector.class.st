Class {
	#name : #SBRequestSelector,
	#superclass : #SBBlock,
	#instVars : [
		'editor',
		'cancelled',
		'colorPolicy'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRequestSelector class >> open [

	^ self run: self new setEmpty
]

{ #category : #'as yet unclassified' }
SBRequestSelector class >> openForSelector: aString arguments: aCollection [

	^ self run: (self new setSelector: aString arguments: aCollection)
]

{ #category : #'as yet unclassified' }
SBRequestSelector class >> openForSnippet: aBlock [

	^ self run: (self new setForSnippet: aBlock)
]

{ #category : #'as yet unclassified' }
SBRequestSelector class >> run: aRequest [

	| window |
	window := aRequest openInWindow.
	aRequest resizeToFit.
	window center: ActiveHand position.
	
	[window world notNil] whileTrue: [window outermostWorldMorph doOneCycle].
	
	^ aRequest cancelled ifTrue: [nil] ifFalse: [{aRequest selector. aRequest arguments}]
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> arguments [

	^ editor method arguments
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> cancelled [

	^ cancelled
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> color [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> colorPolicy [

	^ colorPolicy
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> initialize [

	super initialize.
	
	cancelled := true.
	colorPolicy := SBDefaultColorPolicy new.
	
	self
		changeTableLayout;
		color: Color white;
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		addMorphBack: (editor := SBEditor new
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			saveAction: [cancelled := false. self owner delete])
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> parentSandblock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> resizeToFit [

	editor resizeToFit
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> sandblockEditor [

	^ self
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> selector [

	^ editor method selector
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> setEmpty [

	editor openMorphInView: (SBMethod new
		selector: ''
		arguments: #()
		class: UndefinedObject).
	
	editor startInput: editor method at: 1 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> setForSnippet: aCollectionOfBlocks [

	| arguments |
	arguments := aCollectionOfBlocks gather: #resolveLocalBindings.
	arguments := ((KeyedSet keyBlock: #name) addAll: arguments; yourself) asArray.
	
	editor method: (SBMethod new
		selector: (arguments collect: [:arg | ':']) join
		arguments: (arguments collect: [:arg | SBName contents: arg contents])
		class: aCollectionOfBlocks first containingArtefact methodClass).
	
	editor startInput: editor method at: 1 replacingContents: true
]

{ #category : #'as yet unclassified' }
SBRequestSelector >> setSelector: aString arguments: aCollection [

	editor openMorphInView: (SBMethod new
		selector: aString
		arguments: aCollection veryDeepCopy
		class: UndefinedObject).
	
	editor startInput: editor method at: 1 replacingContents: false
]
