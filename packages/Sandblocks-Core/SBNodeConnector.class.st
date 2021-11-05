Class {
	#name : #SBNodeConnector,
	#superclass : #SBConnectorLine,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNodeConnector >> mouseDown: anEvent [
	self from withDecorator: SBConnectDecorator do: [:decorator | decorator removeConnector: self]
]
