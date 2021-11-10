Class {
	#name : #SBJsModule,
	#superclass : #SBJsBlockScope,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsModule class >> example [

	^ SBJsModule fromString: 'const path = require("path");
const fs = require("fs");
fs.readFileSync(path.join("User", "me"), (text, err) => {
	if (err) {
		return console.error(err);
	}
	console.log(text);
})'
]

{ #category : #'as yet unclassified' }
SBJsModule class >> fromString: aString [

	| reader result |
	reader := SBJsGrammar semanticAction: SBJsSemantic new.
	result := reader grammar match: aString startingFrom: #File.
	result failed ifTrue: [result failure signal].
	^ reader value: result
]

{ #category : #'as yet unclassified' }
SBJsModule >> binding: aString for: block class: aClass ifPresent: aBlock [

	| globals |
	globals := #('console' 'window' 'true' 'false' 'undefined' 'null' 'this' 'require' 'Math').
	globals detect: [:global | global = aString] ifFound: [:inst | ^ aBlock value: inst] ifNone: [].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBJsModule >> body [

	^ self
]

{ #category : #'as yet unclassified' }
SBJsModule >> body: aMorph [

	self removeAllMorphs.
	self addMorphBack: aMorph
]

{ #category : #'as yet unclassified' }
SBJsModule >> header [

	^ #()
]

{ #category : #'as yet unclassified' }
SBJsModule >> initialize [

	super initialize.
	
	self
		layoutInset: 8;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new;
		addMorphBack: self newNullBlock
]

{ #category : #'as yet unclassified' }
SBJsModule >> insertStatementAboveOrBelow: anAboveBoolean [

	| statement |
	statement := self newNullBlock.
	self sandblockEditor
		do: (SBInsertCommand new
			index: (anAboveBoolean ifTrue: [2] ifFalse: [self body submorphCount + 1]);
			container: self body;
			morph: statement;
			shouldMergeWithNext: true;
			yourself);
		startInput: statement at: 1 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBJsModule >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> isEditor [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> isMethod [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> isStatement [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsModule >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> layoutInset [

	^ self floating ifTrue: [8] ifFalse: [0]
]

{ #category : #'as yet unclassified' }
SBJsModule >> sandblockBlockColorIfAbsent: aBlock [

	^ self preferredColor
]

{ #category : #'as yet unclassified' }
SBJsModule >> saveTryFixing: aBoolean quick: aQuickBoolean [

	(self tryFixingMethod: aBoolean) ifFalse: [^ false].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> statements: aCollection [

	self body removeAllMorphs.
	self body addAllMorphs: aCollection
]

{ #category : #'as yet unclassified' }
SBJsModule >> tryFixingMethod: aFixBoolean [

	self allBlocksDo: [:block |
		block valid ifFalse: [
			aFixBoolean ifFalse: [^ false] ifTrue: [
				block tryFixIfFail: [^ false].
				" we had to apply a fix, start over (tree might have changed) "
				^ self tryFixingMethod: aFixBoolean]]].
	^ true
]

{ #category : #'as yet unclassified' }
SBJsModule >> writeSourceOn: aStream [

	self statements do: [:s | s writeSourceOn: aStream] separatedBy: [aStream nextPut: $;; cr]
]
