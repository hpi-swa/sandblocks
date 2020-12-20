compilation cue protocol
sourceString

	^ String streamContents: [:s | self writeSourceOn: s]