layout
morph: aMorph wantsExpandIn: aVerticalBoolean

	^ {aMorph vResizing = #spaceFill. aMorph hResizing = #spaceFill}
	"((aMorph wantsExpandIn: aBoolean) at: (aBoolean ifTrue: [2] ifFalse: [1]))"