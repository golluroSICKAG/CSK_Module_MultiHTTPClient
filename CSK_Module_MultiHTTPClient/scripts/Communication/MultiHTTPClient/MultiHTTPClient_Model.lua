---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find the module definition
-- including its parameters and functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************
local nameOfModule = 'CSK_MultiHTTPClient'

-- Create kind of "class"
local multiHTTPClient = {}
multiHTTPClient.__index = multiHTTPClient

multiHTTPClient.styleForUI = 'None' -- Optional parameter to set UI style
multiHTTPClient.version = Engine.getCurrentAppVersion() -- Version of module

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to react on UI style change
local function handleOnStyleChanged(theme)
  multiHTTPClient.styleForUI = theme
  Script.notifyEvent("MultiHTTPClient_OnNewStatusCSKStyle", multiHTTPClient.styleForUI)
end
Script.register('CSK_PersistentData.OnNewStatusCSKStyle', handleOnStyleChanged)

--- Function to create new instance
---@param multiHTTPClientInstanceNo int Number of instance
---@return table[] self Instance of multiHTTPClient
function multiHTTPClient.create(multiHTTPClientInstanceNo)

  local self = {}
  setmetatable(self, multiHTTPClient)

  self.multiHTTPClientInstanceNo = multiHTTPClientInstanceNo -- Number of this instance
  self.multiHTTPClientInstanceNoString = tostring(self.multiHTTPClientInstanceNo) -- Number of this instance as string
  self.helperFuncs = require('Communication/MultiHTTPClient/helper/funcs') -- Load helper functions

  -- Create parameters etc. for this module instance
  self.activeInUI = false -- Check if this instance is currently active in UI

  -- Check if CSK_PersistentData module can be used if wanted
  self.persistentModuleAvailable = CSK_PersistentData ~= nil or false

  -- Check if CSK_UserManagement module can be used if wanted
  self.userManagementModuleAvailable = CSK_UserManagement ~= nil or false

  -- Default values for persistent data
  -- If available, following values will be updated from data of CSK_PersistentData module (check CSK_PersistentData module for this)
  self.parametersName = 'CSK_MultiHTTPClient_Parameter' .. self.multiHTTPClientInstanceNoString -- name of parameter dataset to be used for this module
  self.parameterLoadOnReboot = false -- Status if parameter dataset should be loaded on app/device reboot

  -- Temporarly request parameters
  self.requestMode = 'POST' -- Request mode like 'PUT', 'POST', 'GET', ...
  self.requestEndpoint = 'http://192.168.0.10/api/crown/DateTime/getDateTime' -- Endpoint of request
  self.requestPort = 80 -- Port for request
  self.requestName = 'NameOfRequest' -- Name of request to use
  self.requestContent = '' -- Content payload of request
  self.requestContentType = 'application/json' -- Type of payload content
  self.requestPeriodic = false -- Status if request should be triggered periodically
  self.requestPeriod = 1000 -- Time in ms for trigger cycle
  self.headerKeyList = '' -- List of header keys
  self.headerKey = '' -- Name of header key
  self.headerValue = '' -- Value of header key
  self.headers = {} -- Table of headers
  self.registeredEvent = '' -- If thread internal function should react on external event, define it here, e.g. 'CSK_OtherModule.OnNewInput'

  self.selectedRequest = nil -- Currently selected request
  self.selectedHeaderKey = '' -- Currently selected header key

  self.key = '1234567890123456' -- Key to encrypt passwords, should be adapted!

  -- Parameters to be saved permanently if wanted
  self.parameters = {}
  self.parameters = self.helperFuncs.defaultParameters.getParameters() -- Load default parameters

  -- Instance specific parameters
  self.parameters.caBundleFileName = 'public/CSK_HTTPClient/CABundle_Instance' .. self.multiHTTPClientInstanceNoString .. '.pem' -- Location of CA bundle file
  self.parameters.clientCertificateFileName = 'public/CSK_HTTPClient/ClientCertificate_Instance' .. self.multiHTTPClientInstanceNoString .. '.' -- Location of client certification file
  self.parameters.clientCertificateKeyFileName = 'public/CSK_HTTPClient/ClientCertificateKey_Instance' .. self.multiHTTPClientInstanceNoString .. '.' -- Path to file containing the client’s private key
  self.currentDevice = Engine.getTypeName() -- Name of device module is running on
  if self.currentDevice == 'Webdisplay' then
    self.parameters.interface = 'ETH1' -- Interface to use for HTTP client
  else
    local interfaceList = Ethernet.Interface.getInterfaces()
    if multiHTTPClientInstanceNo > #interfaceList then
      self.parameters.interface = interfaceList[1]
    else
      self.parameters.interface = interfaceList[multiHTTPClientInstanceNo]
    end
  end

  -- Parameters to give to the processing script
  self.multiHTTPClientProcessingParams = Container.create()
  self.multiHTTPClientProcessingParams:add('multiHTTPClientInstanceNumber', multiHTTPClientInstanceNo, "INT")
  self.multiHTTPClientProcessingParams:add('key', self.key, "STRING")
  self.multiHTTPClientProcessingParams:add('interface', self.parameters.interface)
  self.multiHTTPClientProcessingParams:add('clientActivated', self.parameters.clientActivated, "BOOL")
  self.multiHTTPClientProcessingParams:add('clientAuthentication', self.parameters.clientAuthentication, "BOOL")
  self.multiHTTPClientProcessingParams:add('caBundleFileName', self.parameters.caBundleFileName, 'STRING')
  self.multiHTTPClientProcessingParams:add('clientCertificateType', self.parameters.clientCertificateType, 'STRING')
  self.multiHTTPClientProcessingParams:add('clientCertificateFileName', self.parameters.clientCertificateFileName, 'STRING')
  self.multiHTTPClientProcessingParams:add('clientCertificateKeyType', self.parameters.clientCertificateKeyType, 'STRING')
  self.multiHTTPClientProcessingParams:add('clientCertificateKeyFileName', self.parameters.clientCertificateKeyFileName, 'STRING')
  self.multiHTTPClientProcessingParams:add('clientCertificateKeyPassphrase', self.parameters.clientCertificateKeyPassphrase, 'STRING')
  self.multiHTTPClientProcessingParams:add('hostnameVerification', self.parameters.hostnameVerification, "BOOL")
  self.multiHTTPClientProcessingParams:add('peerVerification', self.parameters.peerVerification, "BOOL")
  self.multiHTTPClientProcessingParams:add('cookieStore', self.parameters.cookieStore, "STRING")
  self.multiHTTPClientProcessingParams:add('proxyEnabled', self.parameters.proxyEnabled, "BOOL")
  self.multiHTTPClientProcessingParams:add('proxyUsername', self.parameters.proxyUsername, "STRING")
  self.multiHTTPClientProcessingParams:add('proxyPassword', self.parameters.proxyPassword, "STRING")
  self.multiHTTPClientProcessingParams:add('proxyURL', self.parameters.proxyURL, "STRING")
  self.multiHTTPClientProcessingParams:add('proxyPort', self.parameters.proxyPort, "INT")
  self.multiHTTPClientProcessingParams:add('extendedResponse', self.parameters.extendedResponse, 'BOOL')
  self.multiHTTPClientProcessingParams:add('verboseMode', self.parameters.verboseMode, 'BOOL')
  self.multiHTTPClientProcessingParams:add('queueSize', self.parameters.queueSize, 'INT')

  self.multiHTTPClientProcessingParams:add('requestMode', self.requestMode, 'STRING')
  self.multiHTTPClientProcessingParams:add('requestEndpoint', self.requestEndpoint, 'STRING')
  self.multiHTTPClientProcessingParams:add('requestPort', self.requestPort, 'INT')
  self.multiHTTPClientProcessingParams:add('requestContentType', self.requestContentType, 'STRING')
  self.multiHTTPClientProcessingParams:add('requestContent', self.requestContent, 'STRING')
  self.multiHTTPClientProcessingParams:add('requestPeriodic', self.requestPeriodic, 'BOOL')
  self.multiHTTPClientProcessingParams:add('requestPeriod', self.requestPeriod, 'INT')
  self.multiHTTPClientProcessingParams:add('registeredEvent', self.registeredEvent, "STRING")

  -- Handle processing
  Script.startScript(self.parameters.processingFile, self.multiHTTPClientProcessingParams)

  return self
end

return multiHTTPClient

--*************************************************************************
--********************** End Function Scope *******************************
--*************************************************************************