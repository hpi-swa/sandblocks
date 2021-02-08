Extension { #name : #MethodNode }

{ #category : #'*Sandblocks-Core' }
MethodNode >> asSandblock [

	| method |
	method := SBStMethod new
		selector: self selector arguments: (self arguments collect: #asSandblock) class: self methodClass;
		body: (self block asMethodBodySandblock temporaries: (self temporaries collect: #asSandblock));
		yourself.
	
	SBStMethodSubstitution allSubclassesDo: [:substitution | 
		(substitution matches: method) ifTrue: [^ substitution newFrom: method]].
	
	self properties pragmas reverseDo: [:pragma |
		method body prependStatement: pragma asSandblock].
	
	^ method
]
