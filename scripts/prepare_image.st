| browserWindow |
FileStream startUp: true.
TranscriptStream redirectToStdOut: true.
Deprecation showDeprecationWarnings: false.

"Load Babylonian into image"
(Smalltalk at: #MetacelloPlatform) current authorName: 'sbGenerated'.

(Smalltalk at: #Metacello) new
  baseline: 'Sandblocks';
  repository: 'tonel:///home/runner/work/sandblocks/sandblocks/packages';
  load: #default.

"Prepare Image a little bit"
Preferences disable: #showSharedFlaps.
PluggableSystemWindow allInstances do: #abandon.
PreferenceWizardMorph allInstances do: #abandon.

BaselineOfSandblocks createSAR.

SBEditor open.
CodeHolder addSandblocks.

"Wrap up the image and save it"
TranscriptStream redirectToStdOut: false.
Deprecation suppressed: false.

SmalltalkImage current snapshot: true andQuit: true.
