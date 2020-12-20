as yet unclassified
newFor: anObject


	^ MIMEDocument
		contentType: 'image/png'
		content: (ByteArray streamContents: [:stream | PNGReadWriter putForm: anObject onStream: stream])