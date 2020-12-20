as yet unclassified
colorForBlock: aBlock
	
	aBlock isBlockBody ifTrue: [^ ((0.55 to: 1.0 by: 0.1) collect: [:g | Color r: 0.2 g: g b: 0.7 alpha: 0.9]) atPingPong: aBlock blockBodyNestingDepth].
	^ ((0.7 to: 1.0 by: 0.2) collect: [:g | Color gray: g]) atPingPong: aBlock localNestingDepth