Class {
	#name : #SBFileReference,
	#superclass : #SBTextBubble,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBFileReference >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBFileReference >> hasOSProcess [

	^ (Smalltalk at: #OSProcess) notNil
]

{ #category : #'as yet unclassified' }
SBFileReference >> object [

	^ FileStream readOnlyFileNamed: self contents
]

{ #category : #'as yet unclassified' }
SBFileReference >> openFileInOS: aString [

	^ (Smalltalk at: #OSProcess) waitForCommand: ((Smalltalk at: #OSProcess) isUnixMac
		ifTrue: ['open ']
		ifFalse: ['xdg-open ']), aString
]

{ #category : #'as yet unclassified' }
SBFileReference >> openFolderInOS [
	<action>
	<actionValidIf: #hasOSProcess>

	self openFileInOS: (FileDirectory on: self contents) containingDirectory fullName
]

{ #category : #'as yet unclassified' }
SBFileReference >> openInOS [
	<action>
	<actionValidIf: #hasOSProcess>

	self openFileInOS: self contents
]
