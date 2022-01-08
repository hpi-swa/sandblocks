Extension { #name : #SBLabel }

{ #category : #'*Sandblocks-Smalltalk' }
SBLabel >> asToggledCode: converter [
	<convert>

	converter
		if: [
			[
				self contents parseAsSandblock.
				true]
				on: Error
				do: [false]]
		do: [
			SBToggledCode new
				comment: ''
				active: 0
				do: {SBStBlockBody new statements: {self contents parseAsSandblock asSandblock}}]
]

{ #category : #'*Sandblocks-Smalltalk' }
SBLabel >> isSmalltalk [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBLabel >> updatePCFrom: anObject [
]
