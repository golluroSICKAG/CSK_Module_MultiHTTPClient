# Changelog
All notable changes to this project will be documented in this file.

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