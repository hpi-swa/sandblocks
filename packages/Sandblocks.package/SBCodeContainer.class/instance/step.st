as yet unclassified
step

	self owner submorphsDo: [:morph |
		(morph ~= self and: [self bounds intersects: morph bounds]) ifTrue: [
			morph position: morph position + ((morph center - self center) normalized * 10)]]