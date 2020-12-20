Class {
	#name : #RPDatabase,
	#superclass : #Object,
	#category : #'RatPack-Core'
}

{ #category : #connection }
RPDatabase >> connectTo: aDBName on: aHost at: aPort as: aUser with: aPassword [ 

	self subclassResponsibility
]

{ #category : #'table handling' }
RPDatabase >> createTableFor: aRPModelClass [

	self subclassResponsibility 
]

{ #category : #'object handling' }
RPDatabase >> deleteObject: anId from: aModel [

	self subclassResponsibility  
]

{ #category : #'table handling' }
RPDatabase >> dropTableFor: aRPModelClass [

	self subclassResponsibility 
]

{ #category : #'object handling' }
RPDatabase >> loadModelObject: anId from: aRPModelClass [

	self subclassResponsibility 
]

{ #category : #'object handling' }
RPDatabase >> loadModelObjectsOf: aRPModelClass [

	self subclassResponsibility 
]

{ #category : #'object handling' }
RPDatabase >> persist: anObject from: aRPModelClass [

	self subclassResponsibility  
]

{ #category : #'object handling' }
RPDatabase >> update: anObject with: anId from: aRPModelClass [

	self subclassResponsibility 
]
