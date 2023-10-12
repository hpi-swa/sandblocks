Extension { #name : #Point }

{ #category : #'*Sandblocks-Core' }
Point >> adaptToEdgeInsets: anEdgeInsets andSend: aSymbol [

	^ SBEdgeInsets
		left: (anEdgeInsets left perform: aSymbol with: self x)
		right: (anEdgeInsets right perform: aSymbol with: self x)
		top: (anEdgeInsets top perform: aSymbol with: self y)
		bottom: (anEdgeInsets bottom perform: aSymbol with: self y)
]

{ #category : #'*Sandblocks-Core' }
Point >> adaptToEdgeInsetsAndAdd: anEdgeInsets [

	^ SBEdgeInsets
		left: anEdgeInsets left + self x
		right: anEdgeInsets right + self x
		top: anEdgeInsets top + self y
		bottom: anEdgeInsets bottom + self y
]

{ #category : #'*Sandblocks-Core' }
Point >> asEdgeInsets [

	^ SBEdgeInsets
		left: self x
		right: self x
		top: self y
		bottom: self y
]

{ #category : #'*Sandblocks-Core' }
Point class >> fromSide: aSymbol [

	aSymbol = #left ifTrue: [^ -1 @ 0].
	aSymbol = #right ifTrue: [^ 1 @ 0].
	aSymbol = #top ifTrue: [^ 0 @ -1].
	aSymbol = #bottom ifTrue: [^ 0 @ 1].
	self error: 'invalid side'
]

{ #category : #'*Sandblocks-Core' }
Point >> rotatedBy: anAngleNumber [

	^ self rotateBy: anAngleNumber about: 0 @ 0
]

{ #category : #'*Sandblocks-Core' }
Point >> sbScaled [

	^ self x sbScaled @ self y sbScaled
]

{ #category : #'*Sandblocks-Core' }
Point >> scalarTowards: aSymbol [

	aSymbol = #left ifTrue: [^ self x].
	aSymbol = #right ifTrue: [^ self x negated].
	aSymbol = #top ifTrue: [^ self y].
	aSymbol = #bottom ifTrue: [^ self y].
	self error: 'invalid side'
]
