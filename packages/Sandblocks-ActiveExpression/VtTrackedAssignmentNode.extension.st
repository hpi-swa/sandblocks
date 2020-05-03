Extension { #name : #VtTrackedAssignmentNode }

{ #category : #'*Sandblocks-ActiveExpression' }
VtTrackedAssignmentNode >> asSandblock [

	^ SBAssignment new
		binding: self variable asSandblock
		value: self value asSandblock;
		pc: self pc;
		yourself
]
