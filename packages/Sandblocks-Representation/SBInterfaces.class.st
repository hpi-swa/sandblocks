Class {
	#name : #SBInterfaces,
	#superclass : #Object,
	#category : #'Sandblocks-Representation'
}

{ #category : #core }
SBInterfaces class >> always [

	^ #()
]

{ #category : #core }
SBInterfaces class >> block [

	^ #(isSandblock)
]

{ #category : #core }
SBInterfaces class >> editor [

	^ #(isEditor)
]

{ #category : #core }
SBInterfaces class >> form [

	^ #(isForm)
]

{ #category : #core }
SBInterfaces class >> morph [

	^ {#isMorph}
]

{ #category : #core }
SBInterfaces class >> never [

	^ {[:o | false]}
]

{ #category : #smalltalk }
SBInterfaces class >> stBlock [

	^ self stExpression, #(isMessageSend)
]

{ #category : #smalltalk }
SBInterfaces class >> stClassEditor [

	^ {#className: understood. #isArtefact understood. #instanceVariables understood. #classVariables understood}
]

{ #category : #smalltalk }
SBInterfaces class >> stExpression [

	^ #(isSandblock isSmalltalk isExpression)
]

{ #category : #smalltalk }
SBInterfaces class >> stMessagePart [

	^ #(isSandblock isSmalltalk isMessagePart)
]

{ #category : #smalltalk }
SBInterfaces class >> stMethod [

	^ #(isSandblock isArtefact isSmalltalk isMethod)
]

{ #category : #smalltalk }
SBInterfaces class >> stName [

	^ #(isSandblock isSmalltalk isName)
]

{ #category : #smalltalk }
SBInterfaces class >> topLevel [

	^ #(isSandblock isTopLevel)
]

{ #category : #core }
SBInterfaces class >> viewer [

	^ #(isViewer)
]
