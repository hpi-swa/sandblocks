Debugging-Environment for Object Mutations in Web-APIs
======================================================

The category `Sandblocks-RatPack` contains an implementation for experimental tools for debugging webserver routes in RatPack. To use the RatPack integration for Sandblocks, the webserver class has to inherit from `SBRPApplication` instead of `RPApplication`.

An example can be found here: `Sandblocks-RatPack-Examples >> WebshopApp`

Features
--------
Integration of RatPack routes as specialized blocks for methods including specialized tooling:
  - Request tracker for received requests on a specific route
  - Sending of empty requests
  - Resending of tracked requests
  - Details about a tracked request containing:
    - Call stack profiling data
    - Timings
    - Request and response data
    - Model-object access logs
    - Route / Handler details

The request analytics provide multiple utility methods for collecting object accesses in the call stack to aid debugging faulty data processing.

Dependencies
------------
- Sandblocks (https://github.com/tom95/sandblocks)
- RatPack (https://github.com/hpi-swa-teaching/RatPack2.0)
- MessageSendRecorder (https://github.com/hpi-swa/MessageSendRecorder)

Known Issues
------------
- Request analytics currently only work on routes which do not use templating (e.g. API routes)
