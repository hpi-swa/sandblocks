Extension { #name : #Number }

{ #category : #'*Sandblocks-Core' }
Number >> adaptToEdgeInsets: anEdgeInsets andSend: aSymbol [

	^ SBEdgeInsets
		left: (anEdgeInsets left perform: aSymbol with: self)
		right: (anEdgeInsets right perform: aSymbol with: self)
		top: (anEdgeInsets top perform: aSymbol with: self)
		bottom: (anEdgeInsets right perform: aSymbol with: self)
]

{ #category : #'*Sandblocks-Core' }
Number >> adaptToEdgeInsetsAndAdd: anEdgeInsets [

	^ SBEdgeInsets
		left: anEdgeInsets left + self
		right: anEdgeInsets right + self
		top: anEdgeInsets top + self
		bottom: anEdgeInsets bottom + self
]

{ #category : #'*Sandblocks-Core' }
Number >> asEdgeInsets [

	^ SBEdgeInsets
		left: self
		right: self
		top: self
		bottom: self
]

{ #category : #'*Sandblocks-Core' }
Number >> sbScaled [

	^ (self * RealEstateAgent scaleFactor) rounded
]
