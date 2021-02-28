Class {
	#name : #SBExplorerBlock,
	#superclass : #SBMorphWrapperBlock,
	#instVars : [
		'object'
	],
	#category : #'Sandblocks-RatPack'
}

{ #category : #'initialize-release' }
SBExplorerBlock class >> newFor: anObject [

	^ self new
		object: anObject;
		yourself
]

{ #category : #accessing }
SBExplorerBlock >> body [

	^ self submorphNamed: #body
]

{ #category : #initialization }
SBExplorerBlock >> buildBody [

	self addMorphBack: ((self newExplorerTreeMorphFor: self object)
		name: #body;
		yourself).
]

{ #category : #actions }
SBExplorerBlock >> explore [

	<action>
	self object explore
]

{ #category : #initialization }
SBExplorerBlock >> initialize [

	super initialize.
	self addDependent: self.
	self extent: 420@140.
]

{ #category : #utils }
SBExplorerBlock >> newExplorerTreeMorphFor: anObject [

	^ (ToolBuilder build: (ObjectExplorer explore: anObject)) submorphs third
]

{ #category : #accessing }
SBExplorerBlock >> object [
	^ object
]

{ #category : #accessing }
SBExplorerBlock >> object: anObject [
	object := anObject.
	self changed: #object.
]

{ #category : #updating }
SBExplorerBlock >> update: aSymbol [

	aSymbol == #object ifTrue: [self buildBody].
]
