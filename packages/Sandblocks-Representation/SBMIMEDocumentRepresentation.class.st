Class {
	#name : #SBMIMEDocumentRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBMIMEDocumentRepresentation class >> eagerNewFor: anObject [

	^ ByteArray new: 1
]

{ #category : #'as yet unclassified' }
SBMIMEDocumentRepresentation class >> isMIMEDocument [ ^ true
]

{ #category : #'as yet unclassified' }
SBMIMEDocumentRepresentation class >> matches: anObject [
^ anObject isForm
]

{ #category : #'as yet unclassified' }
SBMIMEDocumentRepresentation class >> newFor: anObject [


	^ MIMEDocument
		contentType: 'image/png'
		content: (ByteArray streamContents: [:stream | PNGReadWriter putForm: anObject onStream: stream])
]
