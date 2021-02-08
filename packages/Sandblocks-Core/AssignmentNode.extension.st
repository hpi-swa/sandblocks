Extension { #name : #AssignmentNode }

{ #category : #'*Sandblocks-Core' }
AssignmentNode >> asSandblock [

	^ SBStAssignment new
		binding: self variable asSandblock
		value: self value asSandblock;
		pc: self pc;
		yourself
]
