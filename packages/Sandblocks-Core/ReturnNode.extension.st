Extension { #name : #ReturnNode }

{ #category : #'*Sandblocks-Core' }
ReturnNode >> asSandblock [
	
	^ SBStReturn new
		expression: self expr asSandblock;
		pc: self pc;
		yourself
]
