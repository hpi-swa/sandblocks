Class {
	#name : #SBStClassNameInput,
	#superclass : #SBComboBox,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStClassNameInput >> activate [
	<action>

	
	self promptChangeClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> class: aClass [

	self contents: aClass name
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> doubleClick: anEvent [

	self promptChangeClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> object [

	^ self selectedClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> objectInterface [

	^ SBInterfaces stClass
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> printOn: aStream [

	aStream nextPutAll: 'class input '.
	aStream print: self object
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> promptChangeClass [

	(UIManager default chooseClassOrTrait) ifNotNil: [:class |
		self selectedClass: class]
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> selectedClass [

	^ object
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> selectedClass: aClass [

	self sandblockEditor do: (SBMutatePropertyCommand new
		target: self;
		selector: #object;
		value: aClass)
]

{ #category : #'as yet unclassified' }
SBStClassNameInput >> wantsInput [

	^ false
]
