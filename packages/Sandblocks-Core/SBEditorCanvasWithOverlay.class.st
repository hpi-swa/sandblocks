Class {
	#name : #SBEditorCanvasWithOverlay,
	#superclass : #Morph,
	#instVars : [
		'canvas',
		'overlay'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> addMorphToOverlay: aMorph [
	
	self overlay addMorphBack: aMorph
]

{ #category : #accessing }
SBEditorCanvasWithOverlay >> canvas [

	^ canvas
]

{ #category : #accessing }
SBEditorCanvasWithOverlay >> canvas: anObject [

	canvas := anObject.
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> defersHaloOnClickTo: aMorph [
	
	^ aMorph ~= self scroller 
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> defersHaloToInterior [ 
	
	^ true
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> defersHaloToInteriorMorph:  aMorph [
	
	^ aMorph ~= self scroller 
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> initialize [ 
	
	super initialize.
	
	self
		layoutPolicy: SBOverlayLayout new;
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		color: Color transparent;
		canvas: (SBEditorCanvas new
			color: Color transparent;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself);
		addMorphBack: self canvas;
		overlay: (SBEditorCanvasOverlay new
			color: Color transparent;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself);
		addMorphFront: self overlay.
		
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> instantlyScrollToShow: aBlock [
	
	^ self canvas instantlyScrollToShow: aBlock
]

{ #category : #accessing }
SBEditorCanvasWithOverlay >> overlay [

	^ overlay
]

{ #category : #accessing }
SBEditorCanvasWithOverlay >> overlay: anObject [

	overlay := anObject.
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> removeIndicatorFor: aMorph [
	
	self overlay submorphsDo: [:anIndicator | anIndicator target == aMorph ifTrue: [anIndicator abandon]]
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> scrollToShow: aBlock [
	
	^ self canvas scrollToShow: aBlock
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> scroller [ 
	
	^ self canvas
]

{ #category : #'as yet unclassified' }
SBEditorCanvasWithOverlay >> transform [  
	
	^ self canvas transform
]
