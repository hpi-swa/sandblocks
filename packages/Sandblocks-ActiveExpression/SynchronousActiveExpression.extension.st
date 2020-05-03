Extension { #name : #SynchronousActiveExpression }

{ #category : #'*Sandblocks-ActiveExpression' }
SynchronousActiveExpression >> afterInvokeDo: aBlock [
]

{ #category : #'*Sandblocks-ActiveExpression' }
SynchronousActiveExpression >> lastSideEffects [

	^ #()
]

{ #category : #'*Sandblocks-ActiveExpression' }
SynchronousActiveExpression >> subject [

	^ subject
]

{ #category : #'*Sandblocks-ActiveExpression' }
SynchronousActiveExpression >> subject: anObject [

	subject := anObject
]
