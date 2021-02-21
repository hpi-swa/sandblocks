Class {
	#name : #SBInterfaces,
	#superclass : #Object,
	#category : #'Sandblocks-Core'
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

{ #category : #core }
SBInterfaces class >> topLevel [

	^ #(isSandblock isTopLevel)
]

{ #category : #core }
SBInterfaces class >> viewer [

	^ #(isViewer)
]
