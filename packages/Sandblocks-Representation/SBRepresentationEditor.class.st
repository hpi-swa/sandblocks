Class {
	#name : #SBRepresentationEditor,
	#superclass : #SBBlock,
	#instVars : [
		'object',
		'hasUnsavedChanges',
		'argumentBlock'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> argumentBlock [

	^ self submorphs second submorphs second
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> arguments [

	^ {self argumentBlock}
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> binding: aString for: block class: aClass ifPresent: aBlock [

	aString = self argumentBlock contents ifTrue: [^ aBlock value: self argumentBlock].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> capabilitiesFrom: aClass [

	^ (aClass class methodDict values select: [:method |
		(method selector beginsWith: 'is') and: [method selector isUnary]]) collect: #selector
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> capabilitiesList [

	^ self submorphs last submorphs second
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> class: aClass [

	object := aClass.
	self classLabel contents: ((aClass ifNotNil: #name) ifNil: ['']).
	self
		addMorph: (aClass class methodDict at: #matches: ifPresent: [:method | method methodNode body asSandblock] ifAbsent: [SBStBlockBody empty])
		asElementNumber: 4.
	self
		addMorph: (aClass class methodDict at: #newFor: ifPresent: [:method | method methodNode body asSandblock] ifAbsent: [SBStBlockBody empty])
		asElementNumber: 6
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> classLabel [

	^ self submorphs first submorphs second
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> constructorBlock [

	^ self submorphs sixth
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> initialize [

	super initialize.
	hasUnsavedChanges := false.
	self
		layoutInset: 4;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		addMorphBack: (SBRow new
			addMorphBack: (SBStringMorph new contents: 'Representation:');
			addMorphBack: SBTextBubble new);
		addMorphBack: (SBRow new
			addMorphBack: (SBStringMorph new contents: 'Match against: ');
			addMorphBack: (SBStName new
				autoCast: [];
				contents: 'anObject';
				behavior: SBStDeclarationForMethodArgument new;
				yourself));
		addMorphBack: (SBStringMorph new contents: 'Matcher:');
		addMorphBack: (SBStringMorph new contents: 'Constructor:');
		addMorphBack: (SBRow new
			addMorphBack: (SBStringMorph new contents: 'Capabilities: ');
			addMorphBack: SBStArray new);
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> matcherBlock [

	^ self submorphs fourth
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> object [

	^ object
]

{ #category : #'as yet unclassified' }
SBRepresentationEditor >> saveTryFixing: aBoolean quick: anotherBoolean [

	(object isNil or: [object name ~= self classLabel contents]) ifTrue: [ | class |
		class := SBStClass new.
		object
			ifNotNil: [class class: object]
			ifNil: [
				class
					category: 'Sandblocks-Representation';
					superClassName: 'SBRepresentation'].
		class className: self classLabel contents.
		(class saveTryFixing: aBoolean quick: anotherBoolean) ifFalse: [^ false].
		object := class relatedClass].
	object class compile: 'newFor: ', self argumentBlock contents, '

', self constructorBlock prettySourceString allButFirst allButLast.
	object class compile: 'matches: ', self argumentBlock contents, '
', self matcherBlock prettySourceString allButFirst allButLast.
	self capabilitiesList submorphsDo: [:symbol | object class compile: symbol contents, ' ^ true'].
	((self capabilitiesFrom: object) copyWithoutAll: ((self capabilitiesList submorphs collect: #contents) collect: #asSymbol)) do: [:selector | object class removeSelector: selector].
	^ true
]
