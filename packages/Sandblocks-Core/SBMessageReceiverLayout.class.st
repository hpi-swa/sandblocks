Class {
	#name : #SBMessageReceiverLayout,
	#superclass : #SBLayoutPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMessageReceiverLayout >> indent [

	^ 12
]

{ #category : #'as yet unclassified' }
SBMessageReceiverLayout >> layout: aMorph in: aRectangle [

	| signaturePosition |
	aMorph receiver ifNil: [^ aMorph signature layoutInBounds: (aRectangle origin extent: aMorph signature minExtent)].
	
	self measureLayoutFor: aMorph width: aRectangle width do: [:receiverSize :signatureSize :multiRow |
		aMorph receiver layoutInBounds: (aRectangle origin + (multiRow ifTrue: [0 @ 0] ifFalse: [0 @ ((aRectangle height / 2) - (receiverSize y / 2))]) extent: receiverSize).
		
		signaturePosition := multiRow
			ifTrue: [self indent * aMorph scalingFactor @ (aMorph cellGap * self spaceFactorMultiRow + aMorph receiver height)]
			ifFalse: [aMorph receiver width + aMorph cellGap @ ((aRectangle height / 2) - (signatureSize y / 2)) rounded].
	
		aMorph signature layoutInBounds: (aRectangle origin + signaturePosition extent: signatureSize)].
]

{ #category : #'as yet unclassified' }
SBMessageReceiverLayout >> measureLayoutFor: aMorph width: aNumber do: aBlock [

	| multiRow receiverSize signatureSize |
	receiverSize := (aMorph receiver preferredSizeForWidth: aNumber) minSize.
	signatureSize := (aMorph signature preferredSizeForWidth: aNumber - receiverSize x) naturalSize.
	multiRow := receiverSize x + signatureSize x + aMorph cellGap < aNumber.
	
	^ aBlock value: receiverSize value: signatureSize value: multiRow
]

{ #category : #'as yet unclassified' }
SBMessageReceiverLayout >> minExtentOf: aMorph in: aRectangle [

	| r s |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	aMorph receiver ifNil: [^ minExtentCache := aMorph signature minExtent].
	
	r := aMorph receiver minExtent.
	s := aMorph signature minExtent.
	
	^ minExtentCache := (self wantsMultiRow: aMorph)
		ifTrue: [(r x max: s x + (self indent * aMorph scalingFactor)) @ (r y + s y + (aMorph cellGap * self spaceFactorMultiRow))]
		ifFalse: [(r x + s x + aMorph cellGap) @ (r y max: s y)]
]

{ #category : #'as yet unclassified' }
SBMessageReceiverLayout >> preferredSizeFor: aMorph width: aNumber [

	^ self measureLayoutFor: aMorph width: aNumber do: [:receiverSize :signatureSize :multiRow |
		multiRow
			ifTrue: [SBSizeRequest fixed: (receiverSize x + signatureSize x + aMorph cellGap) @ (receiverSize y max: signatureSize y)]
			ifFalse: [SBSizeRequest fixed: (receiverSize x max: signatureSize x + (self indent * aMorph scalingFactor)) @ (receiverSize y + signatureSize y + (aMorph cellGap * self spaceFactorMultiRow))]]
]

{ #category : #'as yet unclassified' }
SBMessageReceiverLayout >> spaceFactorMultiRow [

	" extra space for multi row, for more clarity "
	^ 1
]

{ #category : #'as yet unclassified' }
SBMessageReceiverLayout >> wantsMultiRow: aMorph [

	| signatureExtent receiverExtent |
	signatureExtent := aMorph signature minExtent.
	receiverExtent := aMorph receiver minExtent.
	
	^ (signatureExtent y > 100 withScalingFactor or: [
		signatureExtent x > 400 withScalingFactor and: [receiverExtent x > 100 withScalingFactor]]) or: [
		(signatureExtent x > 200 and: [receiverExtent x > 200 withScalingFactor]) or: [
			receiverExtent x > 80 and: [signatureExtent y > 80 withScalingFactor]]]
]
