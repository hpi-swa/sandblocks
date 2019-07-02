as yet unclassified
layout: aMorph in: aRectangle

	| signatureSize signaturePosition receiverSize multiRow |
	aMorph receiver ifNil: [^ aMorph signature bounds: (aRectangle origin extent: aMorph signature minExtent)].
	
	multiRow := self wantsMultiRow: aMorph.
	
	receiverSize := aMorph receiver minExtent.
	aMorph receiver bounds: (aRectangle origin + (multiRow ifTrue: [0 @ 0] ifFalse: [0 @ ((aRectangle height / 2) - (receiverSize y / 2))]) extent: receiverSize).
	
	signatureSize := aMorph signature minExtent.
	signaturePosition := multiRow
		ifTrue: [self indent * aMorph scalingFactor @ (aMorph cellInset * self spaceFactorMultiRow + aMorph receiver height)]
		ifFalse: [aMorph receiver width + aMorph cellInset @ ((aRectangle height / 2) - (signatureSize y / 2)) rounded].
	
	aMorph signature bounds: (aRectangle origin + signaturePosition extent: signatureSize)