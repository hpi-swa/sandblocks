replacing
example: aJsObject componentWrapper: aSBJsReactComponentWrapper

	| keyValuePairs componentPreviewImage jsxString componentProps |
	componentProps := self componentPropsFromExampleObject: aJsObject.
	keyValuePairs := self keyValuesOfExampleObject: componentProps.
	self componentWrapper: aSBJsReactComponentWrapper.
	
	jsxString := self
		jsxStringForProps: keyValuePairs
		withComponentName: aSBJsReactComponentWrapper componentName.
	
	componentPreviewImage := SBJsReactExampleScreenshotTaker
		takeScreenshotOf: aSBJsReactComponentWrapper
		withExample: aJsObject
		withExtent: 1000 @ 1000.
	componentPreviewImage := self shrinkPreviewImage: componentPreviewImage.
	
	^ self
		removeAllMorphs;
		addMorphBack: (SBColumn new
			addMorphBack: componentPreviewImage asMorph;
			addMorphBack: (SBJavascript parseElement: jsxString);
			changeTableLayout;
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap);
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself