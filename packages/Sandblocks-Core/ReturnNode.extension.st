Extension { #name : #ReturnNode }

{ #category : #'*Sandblocks-Core' }
ReturnNode >> asSandblock [
	
	^ SBReturn new
		expression: self expr asSandblock;
		pc: self pc;
		yourself
]
