Extension { #name : #CompiledCode }

{ #category : #'*Sandblocks-Core' }
CompiledCode >> sandblocksFastHash [

	" return a number that can act as a faster hash than the default that actually considers bytecodes as well "
	^ self selector hash bitXor: self class hash
]
