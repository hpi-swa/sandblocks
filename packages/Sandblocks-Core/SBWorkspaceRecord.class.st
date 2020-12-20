Class {
	#name : #SBWorkspaceRecord,
	#superclass : #Object,
	#instVars : [
		'name',
		'workspaceString',
		'date',
		'lastUsed'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #accessing }
SBWorkspaceRecord >> date [
	^ date
]

{ #category : #accessing }
SBWorkspaceRecord >> date: aDateAndTime [

	date := aDateAndTime.
	lastUsed := lastUsed ifNotNil: [aDateAndTime max: lastUsed] ifNil: [aDateAndTime]
]

{ #category : #accessing }
SBWorkspaceRecord >> lastUsed [

	^ lastUsed
]

{ #category : #accessing }
SBWorkspaceRecord >> lastUsed: aDateAndTime [

	lastUsed := aDateAndTime
]

{ #category : #accessing }
SBWorkspaceRecord >> name [
	^ name
]

{ #category : #accessing }
SBWorkspaceRecord >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SBWorkspaceRecord >> open [

	lastUsed := DateAndTime now.
	(Compiler evaluate: self workspaceString)
		workspace: self;
		openInWindow
]

{ #category : #accessing }
SBWorkspaceRecord >> printOn: aStream [

	aStream nextPutAll: lastUsed "relativeP"printString.
	aStream nextPutAll: ' - '.
	aStream nextPutAll: name
]

{ #category : #'as yet unclassified' }
SBWorkspaceRecord >> updateFrom: anEditor [

	self
		 workspaceString: anEditor storeString;
		 lastUsed: DateAndTime now
]

{ #category : #accessing }
SBWorkspaceRecord >> workspaceString [
	^ workspaceString
]

{ #category : #accessing }
SBWorkspaceRecord >> workspaceString: anObject [
	workspaceString := anObject
]
