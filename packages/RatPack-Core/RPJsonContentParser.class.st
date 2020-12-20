Class {
	#name : #RPJsonContentParser,
	#superclass : #RPContentParser,
	#category : #'RatPack-Core'
}

{ #category : #'as yet unclassified' }
RPJsonContentParser class >> parse: aJsonString [

	^ Json readFrom: (ReadStream on: aJsonString)
]
