replacing
replacementFor: aJsxSelfClosingElement withComponentWrapper: aSBJsReactComponentWrapper withExampleImage: aForm

	self componentWrapper: aSBJsReactComponentWrapper.
	
	^ self
		factory: SBJavascript instance;
		removeAllMorphs;
		addMorphBack: (SBColumn new
			addMorphBack: aForm asMorph;
			addMorphBack: aJsxSelfClosingElement buildCopy;
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap);
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself