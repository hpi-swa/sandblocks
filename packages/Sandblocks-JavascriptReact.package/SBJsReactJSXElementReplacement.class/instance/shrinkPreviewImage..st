replacing
shrinkPreviewImage: aForm

	aForm height > (aForm width * 2)
		ifTrue: [aForm height > 100 ifTrue: [^ aForm scaledToHeight: 100]]
		ifFalse: [aForm width > 200 ifTrue: [^ aForm scaledToWidth: 200]].
	^ aForm