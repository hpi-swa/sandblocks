as yet unclassified
callPrimitive: pimIndex
	"SqueakV3PlusClosures:	239 11101111	iiiiiiii   jjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjjj * 256)
	 NewsqueakV4:				249 11111001	iiiiiiii   jjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjjj * 256)
	 SistaV1:					248 11111000 iiiiiiii mjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjj * 256)
									m=1 means inlined primitive, no hard return after execution."
	^ currentContext callPrimitive: pimIndex