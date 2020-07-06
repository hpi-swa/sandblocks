Class {
	#name : #SandblocksCoreServiceProvider,
	#superclass : #ServiceProvider,
	#category : #'Sandblocks-Core'
}

{ #category : #initialization }
SandblocksCoreServiceProvider class >> initialize [ 
	ServiceRegistry current buildProvider: self new
]
