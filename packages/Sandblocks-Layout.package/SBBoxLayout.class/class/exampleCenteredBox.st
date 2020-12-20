examples
exampleCenteredBox

	| window loginPage loginBox |
	loginBox := (PHPage new vertical: true; align: #(center center)) color: Color green; minSize: 100 asPoint.
	loginPage := PHPage new color: Color red; add: loginBox.
	window := PHTopLevel new size: 600 asPoint; padding: 0; add: loginPage.
	window openInWorld