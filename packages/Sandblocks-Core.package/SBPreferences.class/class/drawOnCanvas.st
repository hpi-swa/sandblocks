accessing
drawOnCanvas
	<preference: 'Left-click on canvas begins drawing'
	category: 'sandblocks'
	description: ''
	type: #Boolean>
	^ DrawOnCanvas ifNil: [true]