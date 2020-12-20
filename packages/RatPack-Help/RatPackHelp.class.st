Class {
	#name : #RatPackHelp,
	#superclass : #CustomHelp,
	#category : #'RatPack-Help'
}

{ #category : #accessing }
RatPackHelp class >> bookName [

	^'RatPack Help'
]

{ #category : #pages }
RatPackHelp class >> introduction [
	
	^HelpTopic
		title: 'Introduction'
		contents:
'RatPack 2.0

RatPack is a simplistic implementation of the Sinatra concept on top of KomHttpServer for Squeak/Smalltalk.

The main repository as well as the license can be found at: https://github.com/hpi-swa-teaching/RatPack2.0' readStream nextChunkText
]

{ #category : #accessing }
RatPackHelp class >> pages [

	^#(introduction #RatPackUsage RatPackMiddleware)
]

{ #category : #accessing }
RatPackHelp class >> priority [

	^ 1 "at the top"
]
