Class {
	#name : #SBPyFilepath,
	#superclass : #SBInlineBlockReplace,
	#category : #'Sandblocks-Python'
}

{ #category : #'as yet unclassified' }
SBPyFilepath class >> matchPython: aDictionary [
	<lang: #python match: '(call
	(identifier) @open
    (argument_list
    	(string) @path))'>

	(aDictionary at: 'open') contents = 'open' ifFalse: [^ nil].
	
	^ SBReplaceCommand new
		target: (aDictionary at: 'path');
		replacer: (self new
			factory: (aDictionary at: 'path') factory;
			path: (aDictionary at: 'path') contents)
]

{ #category : #'as yet unclassified' }
SBPyFilepath >> choose [
	<action>

	| path |
	path := UIManager default chooseFileMatching: '*'.
	path ifNil: [^ self].
	self contents: path
]

{ #category : #'as yet unclassified' }
SBPyFilepath >> contents [

	^ self submorphs second contents
]

{ #category : #'as yet unclassified' }
SBPyFilepath >> contents: aString [

	self submorphs second contents: aString
]

{ #category : #'as yet unclassified' }
SBPyFilepath >> initialize [

	super initialize.
	
	self
		layoutInset: 4;
		cellGap: 4
]

{ #category : #'as yet unclassified' }
SBPyFilepath >> path: aString [

	self addMorphBack: (SBIcon iconFile on: #click send: #choose to: self).
	self addMorphBack: (SBOwnTextMorph new contents: aString)
]

{ #category : #'as yet unclassified' }
SBPyFilepath >> type [

	^ 'string'
]

{ #category : #'as yet unclassified' }
SBPyFilepath >> writeSourceOn: aStream [

	aStream nextPutAll: '"'.
	aStream nextPutAll: self contents.
	aStream nextPutAll: '"'
]
