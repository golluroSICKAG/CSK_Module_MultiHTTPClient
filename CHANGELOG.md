# Changelog
All notable changes to this project will be documented in this file.

## Release 2.2.0

### New features
- Basic authentication setup
- New function 'sendRequest'
- Check if persistent data to load provides all relevant parameters. Otherwise add default values

### Improvements
- 'sendInternalRequest' returns now the HTTP response
- FlowConfig handling
- Minor docu improvements

### Bugfix
- FlowConfig priority was not instance specific
- Legacy bindings of ValueDisplay elements and FileUpload feature within UI did not work if deployed with VS Code AppSpace SDK
- UI differs if deployed via Appstudio or VS Code AppSpace SDK
- Fullscreen icon of iFrame was visible

## Release 2.1.0

### New features
- Protocol (HTTP, HTTPS) selectable within FlowConfig block

### Improvements
- Do not automatically select new added request within UI table (might confuse user)
- Sort preconfigured requests within UI in alphabetic order

### Bugfix
- Adds multiple 'http://' to endpoint

## Release 2.0.0

### New features
- Supports FlowConfig feature to set source to forward via HTTP request
- Added 'Localhost' as interface to perform internal HTTP requests
- Provide version of module via 'OnNewStatusModuleVersion'
- Function 'getParameters' to provide PersistentData parameters
- Check if features of module can be used on device and provide this via 'OnNewStatusModuleIsActive' event / 'getStatusModuleActive' function
- Function to 'resetModule' to default setup

### Improvements
- Added parameters to 'addRequest'-function
- Added ENUMs for RequestMode
- New UI design available (e.g. selectable via CSK_Module_PersistentData v4.1.0 or higher), see 'OnNewStatusCSKStyle'
- check if instance exists if selected
- 'loadParameters' returns its success
- 'sendParameters' can control if sent data should be saved directly by CSK_Module_PersistentData
- Added UI icon and browser tab information

### Bugfix
- Error if module is not active but 'getInstancesAmount' was called

## Release 1.0.0
- Initial commit