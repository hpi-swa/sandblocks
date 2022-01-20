Class {
	#name : #BaselineOfSandblocks,
	#superclass : #BaselineOf,
	#category : #BaselineOfSandblocks
}

{ #category : #'as yet unclassified' }
BaselineOfSandblocks class >> createSAR [

	| preamble zip |
	zip := ZipArchive new.
	preamble := String streamContents: [:preambleStream |
	    preambleStream
	        nextPutAll: '| loader |
	loader := MCVersionLoader new.';
	        cr.
	    (((self project version: 'baseline') allPackagesForSpecNamed: #default) collect: #name) do: [:name | | stream version |
	        stream := RWBinaryOrTextStream on: (String new: 10000).
	        version := MCVersion
	            package: (MCPackage named: name)
	            info: ((MCPackage named: 'Sandblocks-Core') workingCopy ancestry ancestors
					ifNotEmpty: #first
					ifEmpty: [MCVersionInfo name: name, '-generated.1' id: UUID new message: '' date: Date today time: Time now author: 'generated' ancestors: #()]).
	        version fileOutOn: stream.
	        (zip addString: stream contents as: name, '.mcz') desiredCompressionLevel: 0.
	        preambleStream
	            nextPutAll: 'loader addVersion: (MCMczReader versionFromStream: (self memberNamed: ''';
	            nextPutAll: name;
	            nextPutAll: '.mcz'') contentStream).';
	            cr].
	    preambleStream nextPutAll: 'loader load.'].
	zip addString: preamble as: 'install/preamble'.
	zip writeToFileNamed: 'sandblocks.sar'
]

{ #category : #'as yet unclassified' }
BaselineOfSandblocks class >> projectVersion [

	^ '0.0.0'
]

{ #category : #baseline }
BaselineOfSandblocks >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec
			baseline: 'ActiveExpressions'
				with: [spec repository: 'github://active-expressions/active-expressions-squeak:master/src'];
			baseline: 'RatPack'
				with: [spec repository: 'github://hpi-swa-teaching/RatPack:develop/packages'];
			baseline: 'QoppaS' with: [spec repository: 'github://hpi-swa-lab/QoppaS/packages'];
			baseline: 'Ohm' with: [spec repository: 'github://hpi-swa/Ohm-S:master/packages'];
			baseline: 'SimulationStudio' with: [
				spec
					repository: 'github://LinqLover/SimulationStudio/packages';
					loads: #('SimulationStudio-Base' 'SimulationStudio-Sandbox')];
			package: 'SVG-Morphic' with: [spec repository: 'http://www.squeaksource.com/SVGMorph'];
			package: 'PoppyPrint-Core' with: [spec repository: 'github://tom95/poppy-print/packages'].
		
		spec
			package: 'Sandblocks-Core' with: [
				spec
					requires: #('SVG-Morphic' 'Sandblocks-Morphs' 'Sandblocks-Utils' 'Sandblocks-Layout' 'squeak6-compat');
					postLoadDoIt: #postLoadCore];
			package: 'Sandblocks-Smalltalk'
				with: [spec requires: #('Sandblocks-Core' 'PoppyPrint-Core' 'squeak6-simulation')];
			package: 'Sandblocks-Explorer' with: [spec requires: #('Sandblocks-Core')];
			package: 'Sandblocks-Watch' with: [spec requires: 'Sandblocks-Core'];
			package: 'Sandblocks-Debugger' with: [spec requires: 'Sandblocks-Core'];
			package: 'Sandblocks-Plugin-StLivePreview' with: [spec requires: #('Sandblocks-Smalltalk')];
			package: 'Sandblocks-Utils';
			package: 'Sandblocks-Layout';
			package: 'Sandblocks-Morphs';
			package: 'Sandblocks-Drawing' with: [spec requires: 'Sandblocks-Core'];
			package: 'Sandblocks-Ohm'
				with: [spec requires: #('Sandblocks-Core' 'Ohm' 'Sandblocks-Smalltalk')];
			package: 'Sandblocks-CustomJavascript'
				with: [spec requires: #('Sandblocks-Core' 'Sandblocks-Representation' 'Ohm')];
			package: 'Sandblocks-Scheme'
				with: [spec requires: #('Sandblocks-Core' 'Sandblocks-Representation' 'QoppaS')];
			package: 'Sandblocks-Compiler' with: [spec requires: 'Sandblocks-Core'];
			package: 'Sandblocks-Babylonian'
				with: [spec requires: #('Sandblocks-Core' 'Sandblocks-Smalltalk')];
			package: 'Sandblocks-Tutorial' with: [spec requires: 'default'];
			package: 'Sandblocks-Representation'
				with: [spec requires: #('Sandblocks-Core' 'squeak6-simulation')];
			package: 'Sandblocks-RatPack' with: [spec requires: #('default' 'RatPack')];
			package: 'Sandblocks-ActiveExpression' with: [spec requires: #('default' 'ActiveExpressions')];
			package: 'JumpingCubes' with: [spec requires: #('Sandblocks-ActiveExpression')].
		
		spec group: 'squeak6-compat' with: #().
		spec group: 'squeak6-simulation' with: #().
		spec for: #'squeak6.x' do: [
			spec
				package: 'Sandblocks-Squeak6Fixes';
				package: 'Sandblocks-Simulation' with: [spec requires: #('Sandblocks-Core' 'SimulationStudio')];
				group: 'squeak6-compat' with: #('Sandblocks-Squeak6Fixes');
				group: 'squeak6-simulation' with: #('Sandblocks-Simulation')].
		
		spec
			group: 'default'
				with: #('Sandblocks-Core' 'Sandblocks-Smalltalk' 'Sandblocks-Debugger' 'Sandblocks-Morphs' 'Sandblocks-Explorer' 'Sandblocks-Watch' 'Sandblocks-Drawing' 'Sandblocks-Representation' 'Sandblocks-Compiler' 'Sandblocks-Plugin-StLivePreview' 'Sandblocks-Babylonian' 'Sandblocks-CustomJavascript' 'Sandblocks-Scheme' 'Sandblocks-Ohm');
			group: 'tutorial' with: #('Sandblocks-Tutorial');
			group: 'withActiveExpressions' with: #('Sandblocks-ActiveExpression' 'JumpingCubes');
			group: 'withRatPack' with: #('Sandblocks-RatPack')]
]

{ #category : #scripts }
BaselineOfSandblocks >> postLoadCore [
	"Add block editor to 'what to show' menu"

	CodeHolder addSandblocksDefault: false
]

{ #category : #baseline }
BaselineOfSandblocks >> projectClass [
	^ Smalltalk
		at: #MetacelloCypressBaselineProject
		ifAbsent: [super projectClass]
]
