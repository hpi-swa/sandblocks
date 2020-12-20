Class {
	#name : #RPImageDatabase,
	#superclass : #RPDatabase,
	#instVars : [
		'modelDictinary',
		'idDictionary'
	],
	#category : #'RatPack-Core'
}

{ #category : #'table handling' }
RPImageDatabase >> createTableFor: anRPModelClass [
	
	| modelName | 
	modelName := anRPModelClass name.
	(self modelDictionary includesKey: modelName)
		ifTrue: [self notify:  'Model already exists! ' , modelName].

	self modelDictionary at: (modelName) put: (IdentityDictionary new).
	self idDictionary at: modelName put: 1 

	
	
]

{ #category : #'object handling' }
RPImageDatabase >> deleteObject: anId from: aRPModelClass [
	
	| objects |
	objects := (self modelDictionary at: aRPModelClass name).
	objects removeKey: (anId asString asSymbol)
]

{ #category : #'table handling' }
RPImageDatabase >> dropTableFor:  aRPModelClass [

	self modelDictionary removeKey: (aRPModelClass name) ifAbsent: [].
]

{ #category : #'object handling' }
RPImageDatabase >> getAllReconstructedObjects: anRPModelClass [ 
	
	| objectsFromClass |
	objectsFromClass := self modelDictionary at: (anRPModelClass name)
				ifAbsent: [self notify:  anRPModelClass name, ' not found!'].
	^ objectsFromClass collect:[:each | anRPModelClass constructModel: each]
]

{ #category : #'object handling' }
RPImageDatabase >> getNextIdForModel: aRPModelClass [

	| modelName id |
	modelName := aRPModelClass name.
	id := self idDictionary at: modelName.
	self idDictionary at: modelName put: id + 1.
	^ id
]

{ #category : #accessing }
RPImageDatabase >> idDictionary [

	^ idDictionary ifNil: [ idDictionary := IdentityDictionary new ]
]

{ #category : #accessing }
RPImageDatabase >> idDictionary: anObject [

	idDictionary := anObject
]

{ #category : #'object handling' }
RPImageDatabase >> loadModelObject: anId from: anRPModelClass [
	
	| object |

	object := (self modelDictionary at: (anRPModelClass name)) at: (anId asString asSymbol) 
		ifAbsent: [self notify:  anRPModelClass name, ' not found!'].
	
	^ anRPModelClass constructModel: object
]

{ #category : #'object handling' }
RPImageDatabase >> loadModelObjectsOf: anRPModelClass [

	^ (self getAllReconstructedObjects: anRPModelClass) asOrderedCollection

]

{ #category : #accessing }
RPImageDatabase >> modelDictionary [

	^ modelDictinary ifNil: [ modelDictinary := IdentityDictionary new ]
]

{ #category : #accessing }
RPImageDatabase >> modelDictionary: anObject [

	modelDictinary := anObject
]

{ #category : #'object handling' }
RPImageDatabase >> persist: anObject from: anRPModelClass [

	| newId |
	newId := self getNextIdForModel:  anRPModelClass.

	self writeObject: anObject from: anRPModelClass  withId: newId.
	^ newId
]

{ #category : #'object handling' }
RPImageDatabase >> update: anObject with: anId from: anRPModelClass [
	
	self writeObject: anObject from: anRPModelClass withId: (anId asNumber)
	

	
	
]

{ #category : #'object handling' }
RPImageDatabase >> writeObject: anObject from: anRPModelClass withId: anId [
	| entry |
	entry := (anRPModelClass createAttributeDictionaryFor: anObject).
	entry at: anRPModelClass idColumnName put: anId.

	(self modelDictionary at: anRPModelClass name ) 
			at: (anId asString asSymbol)
			put: entry.
	
]
