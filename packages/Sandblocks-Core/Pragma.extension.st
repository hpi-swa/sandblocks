Extension { #name : #Pragma }

{ #category : #'*Sandblocks-Core' }
Pragma >> asSandblock [

	^ SBStPragma new selector: self key arguments: (self arguments collect: [:arg | LiteralNode sandblockForLiteral: arg])
]
