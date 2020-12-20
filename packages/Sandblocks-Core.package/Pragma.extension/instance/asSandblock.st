*Sandblocks-Core
asSandblock

	^ SBPragma new selector: self key arguments: (self arguments collect: [:arg | LiteralNode sandblockForLiteral: arg])