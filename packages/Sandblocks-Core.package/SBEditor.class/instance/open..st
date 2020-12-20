actions
open: anObject

	^ self allBlocksDetect: [:morph | morph isSandblock and: [morph object = anObject]]
		ifFound: #select
		ifNone: [
		 	anObject
				representIn: self
				as: #isToplevelMorph
				near: scroll offset + (self extent // 2)]