Extension { #name : #SBInterfaces }

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stBlock [

	^ self stExpression, #(isBlockBody)
]

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stCanAppearInBlock [

	^ #(isSandblock isSmalltalk canAppearInBlockBody)
]

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stClass [

	^ {#isBehavior}
]

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stClassEditor [

	^ {#className: understood. #isArtefact understood. #instanceVariables understood. #classVariables understood}
]

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stExpression [

	^ #(isSandblock isSmalltalk isExpression)
]

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stMessage [

	^ #(isSandblock isSmalltalk isMessageSend)
]

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stMessagePart [

	^ #(isSandblock isSmalltalk isMessagePart)
]

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stMethod [

	^ #(isSandblock isArtefact isSmalltalk isMethod)
]

{ #category : #'*Sandblocks-Smalltalk' }
SBInterfaces class >> stName [

	^ #(isSandblock isSmalltalk isName)
]
