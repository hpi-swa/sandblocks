Class {
	#name : #RPModel,
	#superclass : #Object,
	#instVars : [
		'object',
		'metadata'
	],
	#category : #'RatPack-Core'
}

{ #category : #validation }
RPModel class >> checkRefClassContainsInstanceVariable: aString [
	
	self refClass instVarIndexFor: aString asString 
			ifAbsent: [^false ]. 
	^true
]

{ #category : #'metadata handling' }
RPModel class >> constructMetadata: aDictionary [

	| dict |
	dict := Dictionary new.
	self metaDataVariables do: [ :key | dict at: key put: (aDictionary at: key)].
	^dict
]

{ #category : #'metadata handling' }
RPModel class >> constructModel: aDictionary [

	^ self new: (self reconstructObject: aDictionary) 
			with: (self constructMetadata: aDictionary) 
]

{ #category : #'object conversion' }
RPModel class >> createAttributeDictionaryFor: anObject [

	| dictionary |
	(self validateObject: anObject) ifFalse: [self notify: 'No valid object for creating an attribute dictionary for this model!'].
	dictionary := Dictionary new.
	self dataTypes keysDo: [:key |
			dictionary at: key put: (anObject instVarNamed: key)].
	^ dictionary
	
]

{ #category : #'object conversion' }
RPModel class >> createHtmlTemplateFor: anObject [

	| aHtmlString |
	aHtmlString := '<table border="1"><tr><td><b>Name:</b></td><td><b>Value:</b></td></tr>'.
	self dataTypes keys do: [:each |
			aHtmlString := aHtmlString, '<tr><td>', (each value), '</td><td>', (anObject instVarNamed: each value), '</td></tr>'].
	^ (aHtmlString, '</table>')
]

{ #category : #'object conversion' }
RPModel class >> createJsonFor: anObject [

	^ (self createAttributeDictionaryFor: anObject) asJsonString

]

{ #category : #'object conversion' }
RPModel class >> createObject: aJson [

	| aJsonObject |
	(self validateJson: aJson) 
		ifFalse: [self notify: 'Invalid Json! Could not create Object on ' , self name].
	
	aJsonObject := Json readFrom: (ReadStream on: aJson from: 1 to: (aJson size)).	
	^ self initializeObjectFrom: aJsonObject
]

{ #category : #'object conversion' }
RPModel class >> createObjectFrom: aDictionary [

	(self validateForCreation: aDictionary) 
		ifFalse: [self notify: 'Invalid input for creation! Could not create Object on ' , self name].
	
	^ self initializeObjectFrom: aDictionary.
]

{ #category : #accesing }
RPModel class >> dataTypes [
	"Create a dictionary on class side with variablename->#( datatype . defaultValue) . 
	Datatypes:
		VARCHAR(size)
		INT

	Example:
	^ Dictionary newFrom: { 'var1'->#( 'VARCHAR(30)'   default) .
							'var2'->#( 'INT PRIMARY KEY' ) }
	"
	self subclassResponsibility
]

{ #category : #'object conversion' }
RPModel class >> defaultJson [
	
	| jsonDict |
	jsonDict := IdentityDictionary new.
	self dataTypes keysDo: [:key | jsonDict at: key put: (self defaultValues at: key ifAbsent: [''])].
	^ jsonDict asJsonString
]

{ #category : #routing }
RPModel class >> defaultRoute [

	self subclassResponsibility  
]

{ #category : #accesing }
RPModel class >> defaultValues [
	
	self subclassResponsibility
]

{ #category : #accesing }
RPModel class >> getDefaultValueFor: anAttributeName [

	^self defaultValues at: (anAttributeName asSymbol)
		ifAbsent: [self notify: 'No defaultvalue set for ', anAttributeName, '.']
]

{ #category : #accesing }
RPModel class >> idColumnName [ 

	^ #id
]

{ #category : #'object conversion' }
RPModel class >> initializeObjectFrom: aJsonObject [

	| newObject |
	
	newObject := self refClass new.
	self dataTypes keysDo: 
		[:key | newObject instVarNamed: key put: (aJsonObject at: key 
								ifAbsent: [self defaultValues at: key])].
	^ newObject
]

{ #category : #'metadata handling' }
RPModel class >> metaDataVariables [

	^ #(#id)
]

{ #category : #initialize }
RPModel class >> new: anObjcet with: someMetadata [ 

	^ self basicNew 
		metadata: someMetadata;
		object: anObjcet;
	yourself
]

{ #category : #routing }
RPModel class >> overridesDefaultRoute [

	^ false
]

{ #category : #'object conversion' }
RPModel class >> reconstructObject: aDictionary [

	| newObject |
	newObject := self refClass new.

	self dataTypes keys do: [:each | 
		newObject instVarNamed: each asSymbol put: (aDictionary at: each asSymbol )].

	^ newObject
]

{ #category : #accesing }
RPModel class >> refClass [

	self subclassResponsibility 
]

{ #category : #'meta datas' }
RPModel class >> structureAsJson [
	"returns datatypes and modelname as JsonString"

	^ '{"', (self name), '":{"dataTypes":{',
		((self dataTypes associations collect: [:each |
		each asJsonString]) joinSeparatedBy: ','), '}}}'
]

{ #category : #accesing }
RPModel class >> tableName [
	"Returns the name of a Table as Symbol! 
	Override with:
		^ self refClass name 
	or with other for individual name. "

	^ self subclassResponsibility 
]

{ #category : #'object conversion' }
RPModel class >> updateObject: aRPModelClassObject with: anObject [ 

	(self validateUpdateObject: anObject)
		ifFalse: [self notify: 'Invalid Json! Could not create Object on ' , self name].
	anObject keys
		do: [:key | aRPModelClassObject instVarNamed: key put: (anObject at: key)].
	^ aRPModelClassObject
]

{ #category : #validation }
RPModel class >> validateForCreation: aDictionary [
	| allAttributes givenAttributes attributesWithDefault |

	allAttributes := self dataTypes keys asOrderedCollection.
	givenAttributes := aDictionary keys asOrderedCollection.
	attributesWithDefault := self defaultValues keys. 

	^ (givenAttributes, attributesWithDefault) asSet = (allAttributes asSet)
]

{ #category : #validation }
RPModel class >> validateJson: aJson [
	| allAttributes jsonObject givenAttributes attributesWithDefault |
	jsonObject := Json readFrom: (ReadStream on: aJson from: 1 to: (aJson size)).

	allAttributes := self dataTypes keys asOrderedCollection.
	givenAttributes := jsonObject keys asOrderedCollection.
	attributesWithDefault := self defaultValues keys. 

	^ (givenAttributes, attributesWithDefault) asSet = (allAttributes asSet)
]

{ #category : #validation }
RPModel class >> validateObject: aObject [

	| neededAttritbutes allAttributes |

	neededAttritbutes := self dataTypes keys asOrderedCollection copy.
	allAttributes := aObject class allInstVarNames. 
	
	^ allAttributes asSet includesAllOf: neededAttritbutes asSet 	
]

{ #category : #validation }
RPModel class >> validateRefClass [

	^ self dataTypes keys detect: [:variable |
			(self checkRefClassContainsInstanceVariable: variable) not] 
			ifNone: [true]
]

{ #category : #validation }
RPModel class >> validateUpdateObject: anObject [
	| allAttributes givenAttributes |
	allAttributes := self dataTypes keys asOrderedCollection.
	givenAttributes := anObject keys asOrderedCollection.

	^ givenAttributes allSatisfy: [ :each | ((allAttributes indexOf: each) > 0). ]
]

{ #category : #converting }
RPModel >> asDict [

	| jsonDict |
	jsonDict := Dictionary new.
	jsonDict at: #object put: self objectAsDict.
	jsonDict at: #metadata put: self metadata.
	^ jsonDict
]

{ #category : #converting }
RPModel >> asJson [

	^ self asDict asJsonString
]

{ #category : #accessing }
RPModel >> metadata [

	^ metadata
]

{ #category : #accessing }
RPModel >> metadata: someMetadata [
	metadata := someMetadata
]

{ #category : #converting }
RPModel >> metadataAsJson [

	| stream |
	stream := WriteStream on: String new.
	self metadata jsonWriteOn: stream.
	^ stream contents
]

{ #category : #accessing }
RPModel >> object [

	^ object
]

{ #category : #accessing }
RPModel >> object: anObject [

	object := anObject
]
