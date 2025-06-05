---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

--***************************************************************
-- Inside of this script, you will find the necessary functions,
-- variables and events to communicate with the MultiHTTPClient_Model and _Instances
--***************************************************************

--**************************************************************************
--************************ Start Global Scope ******************************
--**************************************************************************
local nameOfModule = 'CSK_MultiHTTPClient'

local funcs = {}

-- Timer to update UI via events after page was loaded
local tmrMultiHTTPClient = Timer.create()
tmrMultiHTTPClient:setExpirationTime(300)
tmrMultiHTTPClient:setPeriodic(false)

local multiHTTPClient_Model -- Reference to model handle
local multiHTTPClient_Instances -- Reference to instances handle
local selectedInstance = 1 -- Which instance is currently selected
local helperFuncs = require('Communication/MultiHTTPClient/helper/funcs')
local json = require('Communication/MultiHTTPClient/helper/Json')

-- ************************ UI Events Start ********************************
-- Only to prevent WARNING messages, but these are only examples/placeholders for dynamically created events/functions
----------------------------------------------------------------
local function emptyFunction()
end
Script.serveFunction("CSK_MultiHTTPClient.sendRequestNUM", emptyFunction)

Script.serveEvent('CSK_MultiHTTPClient.OnNewResponseNUM', 'MultiHTTPClient_OnNewResponseNUM')
Script.serveEvent("CSK_MultiHTTPClient.OnNewResponseNUM_NAME", "MultiHTTPClient_OnNewResponseNUM_NAME")
Script.serveEvent("CSK_MultiHTTPClient.OnNewValueToForwardNUM", "MultiHTTPClient_OnNewValueToForwardNUM")
Script.serveEvent("CSK_MultiHTTPClient.OnNewValueUpdateNUM", "MultiHTTPClient_OnNewValueUpdateNUM")
----------------------------------------------------------------

-- Real events
--------------------------------------------------
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusModuleVersion', 'MultiHTTPClient_OnNewStatusModuleVersion')
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusCSKStyle', 'MultiHTTPClient_OnNewStatusCSKStyle')
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusModuleIsActive', 'MultiHTTPClient_OnNewStatusModuleIsActive')
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusClientActivated', 'MultiHTTPClient_OnNewStatusClientActivated')

Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusBasicAuthentication', 'MultiHTTPClient_OnNewStatusBasicAuthentication')
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusBasicAuthenticationUser', 'MultiHTTPClient_OnNewStatusBasicAuthenticationUser')

Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusClientAuthentication', 'MultiHTTPClient_OnNewStatusClientAuthentication')

Script.serveEvent('CSK_MultiHTTPClient.OnNewClientCertificateType', 'MultiHTTPClient_OnNewClientCertificateType')
Script.serveEvent('CSK_MultiHTTPClient.OnNewClientCertificateKeyType', 'MultiHTTPClient_OnNewClientCertificateKeyType')
Script.serveEvent('CSK_MultiHTTPClient.OnNewCookieStore', 'MultiHTTPClient_OnNewCookieStore')

Script.serveEvent('CSK_MultiHTTPClient.OnNewProxyEnableStatus', 'MultiHTTPClient_OnNewProxyEnableStatus')
Script.serveEvent('CSK_MultiHTTPClient.OnNewProxyUsername', 'MultiHTTPClient_OnNewProxyUsername')
Script.serveEvent('CSK_MultiHTTPClient.OnNewProxyPassword', 'MultiHTTPClient_OnNewProxyPassword')
Script.serveEvent('CSK_MultiHTTPClient.OnNewProxyURL', 'MultiHTTPClient_OnNewProxyURL')
Script.serveEvent('CSK_MultiHTTPClient.OnNewProxyPort', 'MultiHTTPClient_OnNewProxyPort')
Script.serveEvent('CSK_MultiHTTPClient.OnNewHostnameVerification', 'MultiHTTPClient_OnNewHostnameVerification')
Script.serveEvent('CSK_MultiHTTPClient.OnNewPeerVerification', 'MultiHTTPClient_OnNewPeerVerification')
Script.serveEvent('CSK_MultiHTTPClient.OnNewInterfaceDropdown', 'MultiHTTPClient_OnNewInterfaceDropdown')
Script.serveEvent('CSK_MultiHTTPClient.OnNewInterface', 'MultiHTTPClient_OnNewInterface')
Script.serveEvent('CSK_MultiHTTPClient.OnNewVerboseMode', 'MultiHTTPClient_OnNewVerboseMode')
Script.serveEvent('CSK_MultiHTTPClient.OnNewQueueSize', 'MultiHTTPClient_OnNewQueueSize')

Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestsTable', 'MultiHTTPClient_OnNewRequestsTable')
Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestName', 'MultiHTTPClient_OnNewRequestName')
Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestEndpoint', 'MultiHTTPClient_OnNewRequestEndpoint')
Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestMode', 'MultiHTTPClient_OnNewRequestMode')
Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestPort', 'MultiHTTPClient_OnNewRequestPort')
Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestPeriodicStatus', 'MultiHTTPClient_OnNewRequestPeriodicStatus')
Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestPeriod', 'MultiHTTPClient_OnNewRequestPeriod')
Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestContent', 'MultiHTTPClient_OnNewRequestContent')
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusRequestContentDisabled', 'MultiHTTPClient_OnNewStatusRequestContentDisabled')
Script.serveEvent('CSK_MultiHTTPClient.OnNewResponseMessage', 'MultiHTTPClient_OnNewResponseMessage')
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusRegisteredEvent', 'MultiHTTPClient_OnNewStatusRegisteredEvent')

Script.serveEvent('CSK_MultiHTTPClient.OnNewHeaderList', 'MultiHTTPClient_OnNewHeaderList')
Script.serveEvent('CSK_MultiHTTPClient.OnNewSelectedHeader', 'MultiHTTPClient_OnNewSelectedHeader')
Script.serveEvent('CSK_MultiHTTPClient.OnNewHeaderKey', 'MultiHTTPClient_OnNewHeaderKey')
Script.serveEvent('CSK_MultiHTTPClient.OnNewHeaderValue', 'MultiHTTPClient_OnNewHeaderValue')

Script.serveEvent('CSK_MultiHTTPClient.OnNewRequestContentType', 'MultiHTTPClient_OnNewRequestContentType')
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusExtendedResponse', 'MultiHTTPClient_OnNewStatusExtendedResponse')

Script.serveEvent("CSK_MultiHTTPClient.OnNewStatusLoadParameterOnReboot", "MultiHTTPClient_OnNewStatusLoadParameterOnReboot")
Script.serveEvent("CSK_MultiHTTPClient.OnPersistentDataModuleAvailable", "MultiHTTPClient_OnPersistentDataModuleAvailable")
Script.serveEvent("CSK_MultiHTTPClient.OnNewParameterName", "MultiHTTPClient_OnNewParameterName")
Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusFlowConfigPriority', 'MultiHTTPClient_OnNewStatusFlowConfigPriority')

Script.serveEvent("CSK_MultiHTTPClient.OnNewInstanceList", "MultiHTTPClient_OnNewInstanceList")
Script.serveEvent("CSK_MultiHTTPClient.OnNewProcessingParameter", "MultiHTTPClient_OnNewProcessingParameter")
Script.serveEvent("CSK_MultiHTTPClient.OnNewSelectedInstance", "MultiHTTPClient_OnNewSelectedInstance")
Script.serveEvent("CSK_MultiHTTPClient.OnDataLoadedOnReboot", "MultiHTTPClient_OnDataLoadedOnReboot")

Script.serveEvent("CSK_MultiHTTPClient.OnUserLevelOperatorActive", "MultiHTTPClient_OnUserLevelOperatorActive")
Script.serveEvent("CSK_MultiHTTPClient.OnUserLevelMaintenanceActive", "MultiHTTPClient_OnUserLevelMaintenanceActive")
Script.serveEvent("CSK_MultiHTTPClient.OnUserLevelServiceActive", "MultiHTTPClient_OnUserLevelServiceActive")
Script.serveEvent("CSK_MultiHTTPClient.OnUserLevelAdminActive", "MultiHTTPClient_OnUserLevelAdminActive")


-- ************************ UI Events End **********************************


--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--[[Future useage
--- Announcing list of events and functions to be used externally
local function announceExternalEventsAndFunctions()
  local moduleName = 'HTTPClient'
  local sourceEvents = {}
  local eventsDataInfos = {}
  local sinkFunctions = {}
  local functionsDataInfos = {}
  for i = 1, #multiHTTPClient_Instances do
    for _, requestDescription in ipairs(multiHTTPClient_Instances[i].parameters.requests) do
      if requestDescription.sourceEvent then
        table.insert(sourceEvents, requestDescription.sourceEvent)
        table.insert(eventsDataInfos, requestDescription.sourceEventInfo)
      end
      if requestDescription.sinkFunction then
        table.insert(sinkFunctions, requestDescription.sinkFunction)
        table.insert(functionsDataInfos, requestDescription.sinkFunctionInfo)
      end
    end
  end
end
]]

--- Get a list of all interfaces available
---@return string list List of interfaces
local function createInterfaceList()
  if multiHTTPClient_Instances[1].currentDevice == 'Webdisplay' then
    return helperFuncs.createStringListFromList({'ETH1'})
  else
    local interfaceList = Ethernet.Interface.getInterfaces()
    table.insert(interfaceList, 'Localhost')
    return helperFuncs.createStringListFromList(interfaceList)
  end
end

--- Get content of a table with all added requests
---@return string content Table content
local function getRequestsTableContent()
  local tableContent = {}
  local tableSize = helperFuncs.getTableSize(multiHTTPClient_Instances[selectedInstance].parameters.requests)

  if tableSize == 0 then
    local tableRow = {
      RequestNo = '-',
      Name = '-',
      Mode = '-',
      Endpoint = '-',
      Port = '-',
      Event = '-',
      Periodic = '-',
      Period = '-',
      selected = false
    }
    table.insert(tableContent, tableRow)
  else
    local orderedTable = {}
    for n in pairs(multiHTTPClient_Instances[selectedInstance].parameters.requests) do
      table.insert(orderedTable, n)
    end
    table.sort(orderedTable)

    local id = 1
    for _, value in ipairs(orderedTable) do
      local requestDescription = multiHTTPClient_Instances[selectedInstance].parameters.requests[value]
      local tableRow = {
        RequestNo = tostring(id),
        Name = requestDescription.requestName,
        Mode = requestDescription.requestMode,
        Endpoint = requestDescription.requestEndpoint,
        Port = requestDescription.requestPort,
        Event = requestDescription.registeredEvent,
        Periodic = requestDescription.requestPeriodic,
        Period = requestDescription.requestPeriod,
        selected = (multiHTTPClient_Instances[selectedInstance].selectedRequest == requestDescription.requestName)
      }
      table.insert(tableContent, tableRow)
      id = id + 1
    end
  end
  return json.encode(tableContent)
end

-- Functions to forward logged in user roles via CSK_UserManagement module (if available)
-- ***********************************************
--- Function to react on status change of Operator user level
---@param status boolean Status if Operator level is active
local function handleOnUserLevelOperatorActive(status)
  Script.notifyEvent("MultiHTTPClient_OnUserLevelOperatorActive", status)
end

--- Function to react on status change of Maintenance user level
---@param status boolean Status if Maintenance level is active
local function handleOnUserLevelMaintenanceActive(status)
  Script.notifyEvent("MultiHTTPClient_OnUserLevelMaintenanceActive", status)
end

--- Function to react on status change of Service user level
---@param status boolean Status if Service level is active
local function handleOnUserLevelServiceActive(status)
  Script.notifyEvent("MultiHTTPClient_OnUserLevelServiceActive", status)
end

--- Function to react on status change of Admin user level
---@param status boolean Status if Admin level is active
local function handleOnUserLevelAdminActive(status)
  Script.notifyEvent("MultiHTTPClient_OnUserLevelAdminActive", status)
end
-- ***********************************************

--- Function to forward data updates from instance threads to Controller part of module
---@param eventname string Eventname to use to forward value
---@param value auto Value to forward
local function handleOnNewValueToForward(eventname, value)
  Script.notifyEvent(eventname, value)
end

--- Optionally: Only use if needed for extra internal objects -  see also Model
--- Function to sync paramters between instance threads and Controller part of module
---@param instance int Instance new value is coming from
---@param parameter string Name of the paramter to update/sync
---@param value auto Value to update
---@param selectedObject int? Optionally if internal parameter should be used for internal objects
local function handleOnNewValueUpdate(instance, parameter, value, selectedObject)
    multiHTTPClient_Instances[instance].parameters.internalObject[selectedObject][parameter] = value
end

--- Function to get access to the multiHTTPClient_Model object
---@param handle handle Handle of multiHTTPClient_Model object
local function setMultiHTTPClient_Model_Handle(handle)
  multiHTTPClient_Model = handle
  Script.releaseObject(handle)
end
funcs.setMultiHTTPClient_Model_Handle = setMultiHTTPClient_Model_Handle

--- Function to get access to the multiHTTPClient_Instances object
---@param handle handle Handle of multiHTTPClient_Instances object
local function setMultiHTTPClient_Instances_Handle(handle)
  multiHTTPClient_Instances = handle
  if multiHTTPClient_Instances[selectedInstance].userManagementModuleAvailable then
    -- Register on events of CSK_UserManagement module if available
    Script.register('CSK_UserManagement.OnUserLevelOperatorActive', handleOnUserLevelOperatorActive)
    Script.register('CSK_UserManagement.OnUserLevelMaintenanceActive', handleOnUserLevelMaintenanceActive)
    Script.register('CSK_UserManagement.OnUserLevelServiceActive', handleOnUserLevelServiceActive)
    Script.register('CSK_UserManagement.OnUserLevelAdminActive', handleOnUserLevelAdminActive)
  end
  Script.releaseObject(handle)

  for i = 1, #multiHTTPClient_Instances do
    Script.register("CSK_MultiHTTPClient.OnNewValueToForward" .. tostring(i) , handleOnNewValueToForward)
  end

  for i = 1, #multiHTTPClient_Instances do
    Script.register("CSK_MultiHTTPClient.OnNewValueUpdate" .. tostring(i) , handleOnNewValueUpdate)
  end

end
funcs.setMultiHTTPClient_Instances_Handle = setMultiHTTPClient_Instances_Handle

--- Function to update user levels
local function updateUserLevel()
  if multiHTTPClient_Instances[selectedInstance].userManagementModuleAvailable then
    -- Trigger CSK_UserManagement module to provide events regarding user role
    CSK_UserManagement.pageCalled()
  else
    -- If CSK_UserManagement is not active, show everything
    Script.notifyEvent("MultiHTTPClient_OnUserLevelAdminActive", true)
    Script.notifyEvent("MultiHTTPClient_OnUserLevelMaintenanceActive", true)
    Script.notifyEvent("MultiHTTPClient_OnUserLevelServiceActive", true)
    Script.notifyEvent("MultiHTTPClient_OnUserLevelOperatorActive", true)
  end
end

--- Function to send all relevant values to UI on resume
local function handleOnExpiredTmrMultiHTTPClient()

  Script.notifyEvent("MultiHTTPClient_OnNewStatusModuleVersion", 'v' .. multiHTTPClient_Model.version)
  Script.notifyEvent("MultiHTTPClient_OnNewStatusCSKStyle", multiHTTPClient_Model.styleForUI)
  Script.notifyEvent("MultiHTTPClient_OnNewStatusModuleIsActive", _G.availableAPIs.default and _G.availableAPIs.specific)

  if _G.availableAPIs.default and _G.availableAPIs.specific then

    updateUserLevel()

    Script.notifyEvent("MultiHTTPClient_OnNewInstanceList", helperFuncs.createStringListBySize(#multiHTTPClient_Instances))
    Script.notifyEvent('MultiHTTPClient_OnNewSelectedInstance', selectedInstance)
    Script.notifyEvent('MultiHTTPClient_OnNewInterfaceDropdown', createInterfaceList())
    Script.notifyEvent('MultiHTTPClient_OnNewInterface', multiHTTPClient_Instances[selectedInstance].parameters.interface)

    Script.notifyEvent('MultiHTTPClient_OnNewStatusClientActivated', multiHTTPClient_Instances[selectedInstance].parameters.clientActivated)
    Script.notifyEvent('MultiHTTPClient_OnNewStatusClientAuthentication', multiHTTPClient_Instances[selectedInstance].parameters.clientAuthentication)

    Script.notifyEvent('MultiHTTPClient_OnNewStatusBasicAuthentication', multiHTTPClient_Instances[selectedInstance].parameters.basicAuthentication)
    Script.notifyEvent('MultiHTTPClient_OnNewStatusBasicAuthenticationUser', multiHTTPClient_Instances[selectedInstance].parameters.basicAuthenticationUser)

    Script.notifyEvent('MultiHTTPClient_OnNewClientCertificateType', multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateType)
    Script.notifyEvent('MultiHTTPClient_OnNewClientCertificateKeyType', multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateKeyType)
    Script.notifyEvent('MultiHTTPClient_OnNewCookieStore', multiHTTPClient_Instances[selectedInstance].parameters.cookieStore)

    Script.notifyEvent('MultiHTTPClient_OnNewProxyEnableStatus', multiHTTPClient_Instances[selectedInstance].parameters.proxyEnabled)
    Script.notifyEvent('MultiHTTPClient_OnNewProxyUsername', multiHTTPClient_Instances[selectedInstance].parameters.proxyUsername)
    Script.notifyEvent('MultiHTTPClient_OnNewProxyPassword', multiHTTPClient_Instances[selectedInstance].parameters.proxyPassword)
    Script.notifyEvent('MultiHTTPClient_OnNewProxyURL', multiHTTPClient_Instances[selectedInstance].parameters.proxyURL)
    Script.notifyEvent('MultiHTTPClient_OnNewProxyPort', multiHTTPClient_Instances[selectedInstance].parameters.proxyPort)
    Script.notifyEvent('MultiHTTPClient_OnNewVerboseMode', multiHTTPClient_Instances[selectedInstance].parameters.verboseMode)
    Script.notifyEvent('MultiHTTPClient_OnNewQueueSize', multiHTTPClient_Instances[selectedInstance].parameters.queueSize)
    Script.notifyEvent('MultiHTTPClient_OnNewHostnameVerification', multiHTTPClient_Instances[selectedInstance].parameters.hostnameVerification)
    Script.notifyEvent('MultiHTTPClient_OnNewPeerVerification', multiHTTPClient_Instances[selectedInstance].parameters.peerVerification)

    Script.notifyEvent('MultiHTTPClient_OnNewRequestEndpoint', multiHTTPClient_Instances[selectedInstance].requestEndpoint)
    Script.notifyEvent('MultiHTTPClient_OnNewRequestMode', multiHTTPClient_Instances[selectedInstance].requestMode)
    Script.notifyEvent('MultiHTTPClient_OnNewRequestPort', multiHTTPClient_Instances[selectedInstance].requestPort)

    Script.notifyEvent('MultiHTTPClient_OnNewHeaderList', helperFuncs.createJsonList(multiHTTPClient_Instances[selectedInstance].headers))
    Script.notifyEvent('MultiHTTPClient_OnNewSelectedHeader', multiHTTPClient_Instances[selectedInstance].selectedHeaderKey)
    if multiHTTPClient_Instances[selectedInstance].headers[multiHTTPClient_Instances[selectedInstance].selectedHeaderKey] then
      Script.notifyEvent('MultiHTTPClient_OnNewHeaderKey', multiHTTPClient_Instances[selectedInstance].headerKey)
      Script.notifyEvent('MultiHTTPClient_OnNewHeaderValue', multiHTTPClient_Instances[selectedInstance].headerValue)
    else
      Script.notifyEvent('MultiHTTPClient_OnNewHeaderKey', '')
      Script.notifyEvent('MultiHTTPClient_OnNewHeaderValue', '')
    end

    Script.notifyEvent('MultiHTTPClient_OnNewStatusRequestContentDisabled', multiHTTPClient_Instances[selectedInstance].requestMode == ('GET' or 'DELETE'))
    Script.notifyEvent('MultiHTTPClient_OnNewRequestContent', multiHTTPClient_Instances[selectedInstance].requestContent)
    Script.notifyEvent('MultiHTTPClient_OnNewRequestContentType', multiHTTPClient_Instances[selectedInstance].requestContentType)

    Script.notifyEvent('MultiHTTPClient_OnNewStatusExtendedResponse', multiHTTPClient_Instances[selectedInstance].parameters.extendedResponse)
    Script.notifyEvent('MultiHTTPClient_OnNewResponseMessage', '')

    Script.notifyEvent('MultiHTTPClient_OnNewRequestName', multiHTTPClient_Instances[selectedInstance].requestName)
    Script.notifyEvent("MultiHTTPClient_OnNewStatusRegisteredEvent", multiHTTPClient_Instances[selectedInstance].registeredEvent)
    Script.notifyEvent('MultiHTTPClient_OnNewRequestPeriodicStatus', multiHTTPClient_Instances[selectedInstance].requestPeriodic)
    Script.notifyEvent('MultiHTTPClient_OnNewRequestPeriod', multiHTTPClient_Instances[selectedInstance].requestPeriod)
    Script.notifyEvent('MultiHTTPClient_OnNewRequestsTable', getRequestsTableContent())

    Script.notifyEvent("MultiHTTPClient_OnNewStatusLoadParameterOnReboot", multiHTTPClient_Instances[selectedInstance].parameterLoadOnReboot)
    Script.notifyEvent("MultiHTTPClient_OnPersistentDataModuleAvailable", multiHTTPClient_Instances[selectedInstance].persistentModuleAvailable)
    Script.notifyEvent("MultiHTTPClient_OnNewParameterName", multiHTTPClient_Instances[selectedInstance].parametersName)
    Script.notifyEvent("MultiHTTPClient_OnNewStatusFlowConfigPriority", multiHTTPClient_Instances[selectedInstance].parameters.flowConfigPriority)
  end
end
Timer.register(tmrMultiHTTPClient, "OnExpired", handleOnExpiredTmrMultiHTTPClient)

-- ********************* UI Setting / Submit Functions Start ********************

local function pageCalled()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    updateUserLevel() -- try to hide user specific content asap
  end
  tmrMultiHTTPClient:start()
  return ''
end
Script.serveFunction("CSK_MultiHTTPClient.pageCalled", pageCalled)

local function setSelectedInstance(instance)
  if #multiHTTPClient_Instances >= instance then
    selectedInstance = instance
    _G.logger:fine(nameOfModule .. ": New selected instance = " .. tostring(selectedInstance))
    multiHTTPClient_Instances[selectedInstance].activeInUI = true
    Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'activeInUI', true)
    multiHTTPClient_Instances[selectedInstance].selectedRequest = nil
    handleOnExpiredTmrMultiHTTPClient()
  else
    _G.logger:warning(nameOfModule .. ": Selected instance does not exist.")
  end
end
Script.serveFunction("CSK_MultiHTTPClient.setSelectedInstance", setSelectedInstance)

local function setClientActivated(state)
  _G.logger:fine(nameOfModule .. ": Set 'clientActivated' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(state))
  multiHTTPClient_Instances[selectedInstance].parameters.clientActivated = state
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'clientActivated', state)
  Script.notifyEvent('MultiHTTPClient_OnNewStatusClientActivated', multiHTTPClient_Instances[selectedInstance].parameters.clientActivated)
end
Script.serveFunction('CSK_MultiHTTPClient.setClientActivated', setClientActivated)

local function setInterface(interface)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'interface' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(interface))
    multiHTTPClient_Instances[selectedInstance].parameters.interface = interface
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'interface', multiHTTPClient_Instances[selectedInstance].parameters.interface)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setInterface', setInterface)

local function setHostnameVerification(state)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'hostnameVerification' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(state))
    multiHTTPClient_Instances[selectedInstance].parameters.hostnameVerification = state
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'hostnameVerification',multiHTTPClient_Instances[selectedInstance].parameters.hostnameVerification)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setHostnameVerification', setHostnameVerification)

local function setPeerVerification(state)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'peerVerification' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(state))
    multiHTTPClient_Instances[selectedInstance].parameters.peerVerification = state
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'peerVerification',multiHTTPClient_Instances[selectedInstance].parameters.peerVerification)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setPeerVerification', setPeerVerification)

local function setBasicAuthentication(status)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'basicAuthentication' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(status))
    multiHTTPClient_Instances[selectedInstance].parameters.basicAuthentication = status
    Script.notifyEvent('MultiHTTPClient_OnNewStatusBasicAuthentication', status)
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'basicAuthentication', status)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setBasicAuthentication', setBasicAuthentication)

local function setBasicAuthenticationUser(user)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'basicAuthenticationUser' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(user))
    multiHTTPClient_Instances[selectedInstance].parameters.basicAuthenticationUser = user
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'basicAuthenticationUser', user)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setBasicAuthenticationUser', setBasicAuthenticationUser)

local function setBasicAuthenticationPassword(password)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'basicAuthenticationPassword' of instance" .. tostring(selectedInstance))
    multiHTTPClient_Instances[selectedInstance].parameters.basicAuthenticationPassword = password
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'basicAuthenticationPassword', password)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setBasicAuthenticationPassword', setBasicAuthenticationPassword)

local function setClientAuthentication(state)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'clientAuthentication' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(state))
    multiHTTPClient_Instances[selectedInstance].parameters.clientAuthentication = state
    Script.notifyEvent('MultiHTTPClient_OnNewStatusClientAuthentication', state)
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'clientAuthentication', state)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setClientAuthentication', setClientAuthentication)

local function setCABundleFile(success)
  if success then
    if not File.isdir('/public/CSK_HTTPClient') then
      File.mkdir('/public/CSK_HTTPClient')
    end
    local copySuccess = File.copy('/ram/caBundle.pem', 'public/CSK_HTTPClient/CABundle_Instance' .. tostring(selectedInstance) .. '.pem')
    if multiHTTPClient_Instances[selectedInstance].parameters.clientAuthentication then
      Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'clientAuthentication', true)
    end
    if copySuccess then
      _G.logger:fine(nameOfModule .. ": CA_Bundle file upload successfull.")
    else
      _G.logger:warning(nameOfModule .. ": Copy of internal CA_Bundle did not work.")
    end
  else
    _G.logger:warning(nameOfModule .. ": CA_Bundle file upload did not work.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setCABundleFile', setCABundleFile)

local function setClientCertificateFile(success)
  if success then
    if not File.isdir('/public/CSK_HTTPClient') then
      File.mkdir('/public/CSK_HTTPClient')
    end
    local copySuccess = File.copy('/ram/ClientCertificate.bin', multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateFileName .. multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateType)
    if multiHTTPClient_Instances[selectedInstance].parameters.clientAuthentication then
      Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'clientAuthentication', true)
    end
    if copySuccess then
      _G.logger:fine(nameOfModule .. ": Client certificate file upload successfull.")
    else
      _G.logger:warning(nameOfModule .. ": Copy of internal client certificate did not work.")
    end
  else
    _G.logger:warning(nameOfModule .. ": Client certificate file upload did not work.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setClientCertificateFile', setClientCertificateFile)

local function setClientCertificateKeyFile(success)
  if success then
    if not File.isdir('/public/CSK_HTTPClient') then
      File.mkdir('/public/CSK_HTTPClient')
    end
    local copySuccess = File.copy('/ram/ClientCertificateKey.bin', multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateKeyFileName .. multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateKeyType)
    if multiHTTPClient_Instances[selectedInstance].parameters.clientAuthentication then
      Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'clientAuthentication', true)
    end
    if copySuccess then
      _G.logger:fine(nameOfModule .. ": Client certificate key file upload successfull.")
    else
      _G.logger:warning(nameOfModule .. ": Copy of internal client certificate key did not work.")
    end
  else
    _G.logger:warning(nameOfModule .. ": Client certificate file key upload did not work.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setClientCertificateKeyFile', setClientCertificateKeyFile)

local function setClientCertificateType(certType)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'clientCertificateType' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(certType))
    multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateType = certType
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'clientCertificateType', certType)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setClientCertificateType', setClientCertificateType)

local function setClientCertificateKeyType(keyType)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'clientCertificateKeyType' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(keyType))
    multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateKeyType = keyType
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'clientCertificateKeyType', keyType)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setClientCertificateKeyType', setClientCertificateKeyType)

local function setClientCertificateKeyPassphrase(passphrase)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'clientCertificateKeyPassphrase' of instance" .. tostring(selectedInstance))
    multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateKeyPassphrase = Cipher.AES.encrypt(passphrase, multiHTTPClient_Instances[selectedInstance].key)
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'clientCertificateKeyPassphrase', multiHTTPClient_Instances[selectedInstance].parameters.clientCertificateKeyPassphrase)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setClientCertificateKeyPassphrase', setClientCertificateKeyPassphrase)

local function setCookieStore(filename)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    if not File.isdir('/public/CSK_HTTPClient') then
      File.mkdir('/public/CSK_HTTPClient')
    end
    _G.logger:fine(nameOfModule .. ": Set filename of 'cookieStore' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(filename))
    multiHTTPClient_Instances[selectedInstance].parameters.cookieStore = filename
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'cookieStore', filename)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setCookieStore', setCookieStore)

local function setProxyEnabledStatus(state)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'proxyEnabled' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(state))
    multiHTTPClient_Instances[selectedInstance].parameters.proxyEnabled = state
    Script.notifyEvent('MultiHTTPClient_OnNewProxyEnableStatus', multiHTTPClient_Instances[selectedInstance].parameters.proxyEnabled)
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'proxyEnabled', multiHTTPClient_Instances[selectedInstance].parameters.proxyEnabled)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setProxyEnabledStatus', setProxyEnabledStatus)

local function setProxyURL(proxyURL)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'proxyURL' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(proxyURL))
    multiHTTPClient_Instances[selectedInstance].parameters.proxyURL = proxyURL
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'proxyURL', multiHTTPClient_Instances[selectedInstance].parameters.proxyURL)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setProxyURL', setProxyURL)

local function setProxyPort(proxyPort)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'proxyPort' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(proxyPort))
    multiHTTPClient_Instances[selectedInstance].parameters.proxyPort = proxyPort
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'proxyPort', multiHTTPClient_Instances[selectedInstance].parameters.proxyPort)
  else
      _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setProxyPort', setProxyPort)

local function setProxyUsername(proxyUsername)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'proxyUsername' of instance" .. tostring(selectedInstance) .. ' = ' .. tostring(proxyUsername))
    multiHTTPClient_Instances[selectedInstance].parameters.proxyUsername = proxyUsername
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'proxyUsername', multiHTTPClient_Instances[selectedInstance].parameters.proxyUsername)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setProxyUsername', setProxyUsername)

local function setProxyPassword(proxyPassword)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'proxyPassword' of instance" .. tostring(selectedInstance))
    multiHTTPClient_Instances[selectedInstance].parameters.proxyPassword = Cipher.AES.encrypt(proxyPassword, multiHTTPClient_Instances[selectedInstance].key)
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'proxyPassword', multiHTTPClient_Instances[selectedInstance].parameters.proxyPassword)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setProxyPassword', setProxyPassword)

local function setVerboseMode(status)
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == false then
    _G.logger:fine(nameOfModule .. ": Set 'verboseMode' to " .. tostring(status))
    multiHTTPClient_Instances[selectedInstance].parameters.verboseMode = status
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'verboseMode', status)
  else
    _G.logger:fine(nameOfModule .. ": Client currently active. No setup possible.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setVerboseMode', setVerboseMode)

local function setMaxQueueSize(size)
  _G.logger:fine(nameOfModule .. ": Set 'queueSize' to " .. tostring(size))
  multiHTTPClient_Instances[selectedInstance].parameters.queueSize = size
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'queueSize', size)
end
Script.serveFunction('CSK_MultiHTTPClient.setMaxQueueSize', setMaxQueueSize)

local function setRequestMode(mode)
  _G.logger:fine(nameOfModule .. ": Set 'requestMode' to " .. tostring(mode))
  multiHTTPClient_Instances[selectedInstance].requestMode = mode
  Script.notifyEvent('MultiHTTPClient_OnNewStatusRequestContentDisabled', mode == ('GET' or 'DELETE'))
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'requestMode', mode)
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestMode', setRequestMode)

local function setRequestEndpoint(endpoint)
  _G.logger:fine(nameOfModule .. ": Set 'requestEndpoint' to " .. tostring(endpoint))
  multiHTTPClient_Instances[selectedInstance].requestEndpoint = endpoint
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'requestEndpoint', endpoint)
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestEndpoint', setRequestEndpoint)

local function setRequestPort(port)
  _G.logger:fine(nameOfModule .. ": Set 'requestPort' to " .. tostring(port))
  multiHTTPClient_Instances[selectedInstance].requestPort = port
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'requestPort', port)
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestPort', setRequestPort)

local function sendRequestViaUI()
  if multiHTTPClient_Instances[selectedInstance].parameters.clientActivated == true then
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'sendRequest')
  else
    _G.logger:fine(nameOfModule .. ": Client currently not active.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.sendRequestViaUI', sendRequestViaUI)

local function selectRequestHeaderKey(selection)
  _G.logger:fine(nameOfModule .. ": Select header key = " .. tostring(selection))
  multiHTTPClient_Instances[selectedInstance].selectedHeaderKey = selection
  multiHTTPClient_Instances[selectedInstance].headerKey = selection
  multiHTTPClient_Instances[selectedInstance].headerValue = multiHTTPClient_Instances[selectedInstance]['headers'][selection]

  Script.notifyEvent('MultiHTTPClient_OnNewHeaderKey', multiHTTPClient_Instances[selectedInstance].headerKey)
  Script.notifyEvent('MultiHTTPClient_OnNewHeaderValue', multiHTTPClient_Instances[selectedInstance].headerValue)
end
Script.serveFunction('CSK_MultiHTTPClient.selectRequestHeaderKey', selectRequestHeaderKey)

local function setRequestHeaderKey(key)
  _G.logger:fine(nameOfModule .. ": Set 'headerKey' to " .. tostring(key))
  multiHTTPClient_Instances[selectedInstance].headerKey = key
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestHeaderKey', setRequestHeaderKey)

local function setRequestHeaderValue(value)
  _G.logger:fine(nameOfModule .. ": Set 'headerValue' to " .. tostring(value))
  multiHTTPClient_Instances[selectedInstance].headerValue = value
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestHeaderValue', setRequestHeaderValue)

local function addHeader()
  _G.logger:fine(nameOfModule .. ": Add header key = " .. tostring(multiHTTPClient_Instances[selectedInstance]['headerKey']) .. " with value = " .. tostring(multiHTTPClient_Instances[selectedInstance]['headerValue']))
  multiHTTPClient_Instances[selectedInstance].headers[multiHTTPClient_Instances[selectedInstance]['headerKey']] = multiHTTPClient_Instances[selectedInstance]['headerValue']
  multiHTTPClient_Instances[selectedInstance].selectedHeaderKey = multiHTTPClient_Instances[selectedInstance]['headerKey']
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'headerUpdate', multiHTTPClient_Instances[selectedInstance]['headerKey'], multiHTTPClient_Instances[selectedInstance]['headerValue'])
  handleOnExpiredTmrMultiHTTPClient()
end
Script.serveFunction('CSK_MultiHTTPClient.addHeader', addHeader)

local function deleteHeader()
  _G.logger:fine(nameOfModule .. ": Delete header key = " .. tostring(multiHTTPClient_Instances[selectedInstance]['headerKey']))
  multiHTTPClient_Instances[selectedInstance].headers[multiHTTPClient_Instances[selectedInstance]['headerKey']] = nil
  collectgarbage()
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'deleteHeader', multiHTTPClient_Instances[selectedInstance]['headerKey'])

  local check = false
  for key, _ in pairs(multiHTTPClient_Instances[selectedInstance].headers) do
    selectRequestHeaderKey(key)
    check = true
    break
  end

  if check == false then
    multiHTTPClient_Instances[selectedInstance].selectedHeaderKey = ''
  end
  handleOnExpiredTmrMultiHTTPClient()
end
Script.serveFunction('CSK_MultiHTTPClient.deleteHeader', deleteHeader)

local function setRequestContentType(contentType)
  _G.logger:fine(nameOfModule .. ": Set 'requestContentType' to " .. tostring(contentType))
  multiHTTPClient_Instances[selectedInstance].requestContentType = contentType
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'requestContentType', contentType)
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestContentType', setRequestContentType)

local function setRequestContent(content)
  _G.logger:fine(nameOfModule .. ": Set 'requestContent' to " .. tostring(content))
  multiHTTPClient_Instances[selectedInstance].requestContent = content
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'requestContent', content)
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestContent', setRequestContent)

local function setRequestName(name)
  _G.logger:fine(nameOfModule .. ": Set 'requestName' to " .. tostring(name))
  multiHTTPClient_Instances[selectedInstance].requestName = name
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestName', setRequestName)

local function setRequestRegisteredEvent(event)
  multiHTTPClient_Instances[selectedInstance].registeredEvent = event
  Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'registeredEvent', event)
end
Script.serveFunction("CSK_MultiHTTPClient.setRequestRegisteredEvent", setRequestRegisteredEvent)

local function setRequestPeriodicState(state)
  _G.logger:fine(nameOfModule .. ": Set 'requestPeriodic' to " .. tostring(state))
  multiHTTPClient_Instances[selectedInstance].requestPeriodic = state
  Script.notifyEvent("MultiHTTPClient_OnNewRequestPeriodicStatus", state)
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'requestPeriodic', state)
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestPeriodicState', setRequestPeriodicState)

local function setRequestPeriod(period)
  _G.logger:fine(nameOfModule .. ": Set 'requestPeriod' to " .. tostring(period))
  multiHTTPClient_Instances[selectedInstance].requestPeriod = period
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'requestPeriod', period)
end
Script.serveFunction('CSK_MultiHTTPClient.setRequestPeriod', setRequestPeriod)

--- Function to create new request based on currently configured request parameters
---@return auto[] requestParameters Parameters of request
local function createRequestParameters()
  local requestParameters = {
    requestName = multiHTTPClient_Instances[selectedInstance].requestName,
    requestMode = multiHTTPClient_Instances[selectedInstance].requestMode,
    requestEndpoint = multiHTTPClient_Instances[selectedInstance].requestEndpoint,
    headers = helperFuncs.copy(multiHTTPClient_Instances[selectedInstance].headers),
    requestPort = multiHTTPClient_Instances[selectedInstance].requestPort,
    requestContent = multiHTTPClient_Instances[selectedInstance].requestContent,
    requestContentType = multiHTTPClient_Instances[selectedInstance].requestContentType,
    registeredEvent = multiHTTPClient_Instances[selectedInstance].registeredEvent,
    requestPeriodic = multiHTTPClient_Instances[selectedInstance].requestPeriodic,
    requestPeriod = multiHTTPClient_Instances[selectedInstance].requestPeriod
  }
  return requestParameters
end

local function addRequest(name, mode, endpoint, port, event, periodic, period, protocol)

  if name ~= '' then
    if multiHTTPClient_Instances[selectedInstance].parameters.requests[name] then
      _G.logger:fine(nameOfModule .. ": Request with this name already exists.")
    else
      _G.logger:fine(nameOfModule .. ": Add request to instance" .. tostring(selectedInstance))

      local httpIncluded = string.find(endpoint, 'http') or string.find(endpoint, 'https')

      multiHTTPClient_Instances[selectedInstance].requestName = name
      multiHTTPClient_Instances[selectedInstance].requestMode = mode
      if httpIncluded then
        multiHTTPClient_Instances[selectedInstance].requestEndpoint = endpoint
      else
        if protocol == 'HTTPS' then
          multiHTTPClient_Instances[selectedInstance].requestEndpoint = 'https://' .. endpoint
        else
          multiHTTPClient_Instances[selectedInstance].requestEndpoint = 'http://' .. endpoint
        end
      end
      multiHTTPClient_Instances[selectedInstance].requestPort = port
      multiHTTPClient_Instances[selectedInstance].registeredEvent = event or ''
      multiHTTPClient_Instances[selectedInstance].requestPeriodic = periodic
      multiHTTPClient_Instances[selectedInstance].requestPeriod = period or 0

      local requestToAdd = createRequestParameters()
      multiHTTPClient_Instances[selectedInstance].parameters.requests[multiHTTPClient_Instances[selectedInstance].requestName] = requestToAdd

      local requestData = helperFuncs.convertTable2Container(multiHTTPClient_Instances[selectedInstance].parameters.requests[multiHTTPClient_Instances[selectedInstance].requestName])
      Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'addRequest', requestData)

      multiHTTPClient_Instances[selectedInstance].requestName = ''
      Script.notifyEvent('MultiHTTPClient_OnNewRequestName', multiHTTPClient_Instances[selectedInstance].requestName)
      Script.notifyEvent('MultiHTTPClient_OnNewRequestsTable', getRequestsTableContent())

      --announceExternalEventsAndFunctions() -- future usage
    end
  else
    _G.logger:fine(nameOfModule .. ": No name to create request.")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.addRequest', addRequest)

local function updateRequest(requestName)
  _G.logger:fine(nameOfModule .. ": Update request " .. tostring(requestName) .. " of instance" .. tostring(selectedInstance))
  local requestToReplace = createRequestParameters()
  multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName] = requestToReplace

  local requestData = helperFuncs.convertTable2Container(multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName])
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'updateRequest', requestData, requestName)
  --announceExternalEventsAndFunctions() -- future usage
end
Script.serveFunction('CSK_MultiHTTPClient.updateRequest', updateRequest)

local function addEditRequestViaUI()
  if multiHTTPClient_Instances[selectedInstance].selectedRequest then
    if multiHTTPClient_Instances[selectedInstance].parameters.requests[multiHTTPClient_Instances[selectedInstance].selectedRequest].requestName == multiHTTPClient_Instances[selectedInstance].requestName then
      updateRequest(multiHTTPClient_Instances[selectedInstance].selectedRequest)
    else
      _G.logger:fine(nameOfModule .. ": Not possible to change request name. Delete request and create a new one.")
    end
  else
    addRequest(multiHTTPClient_Instances[selectedInstance].requestName, multiHTTPClient_Instances[selectedInstance].requestMode, multiHTTPClient_Instances[selectedInstance].requestEndpoint, multiHTTPClient_Instances[selectedInstance].requestPort, multiHTTPClient_Instances[selectedInstance].registeredEvent, multiHTTPClient_Instances[selectedInstance].requestPeriodic, multiHTTPClient_Instances[selectedInstance].requestPeriod)
  end
  handleOnExpiredTmrMultiHTTPClient()
end
Script.serveFunction('CSK_MultiHTTPClient.addEditRequestViaUI', addEditRequestViaUI)

local function removeRequest()
  if multiHTTPClient_Instances[selectedInstance].selectedRequest then
    _G.logger:fine(nameOfModule .. ": Remove request " .. tostring(multiHTTPClient_Instances[selectedInstance].selectedRequest) .. " of instance" .. tostring(selectedInstance))
    multiHTTPClient_Instances[selectedInstance].parameters.requests[multiHTTPClient_Instances[selectedInstance].selectedRequest] = nil
    Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'removeRequest', multiHTTPClient_Instances[selectedInstance].selectedRequest)
    multiHTTPClient_Instances[selectedInstance].selectedRequest = nil
    collectgarbage()
    handleOnExpiredTmrMultiHTTPClient()
    --announceExternalEventsAndFunctions() -- future usage
  else
    _G.logger:fine(nameOfModule .. ": Request not available to remove")
  end
end
Script.serveFunction('CSK_MultiHTTPClient.removeRequest', removeRequest)

local function setSelectedRequest(requestName)
  if multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName] then
    _G.logger:fine(nameOfModule .. ": Select request " .. tostring(requestName) .. " of instance" .. tostring(selectedInstance))
    multiHTTPClient_Instances[selectedInstance].selectedRequest = requestName
    multiHTTPClient_Instances[selectedInstance].requestName = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].requestName
    multiHTTPClient_Instances[selectedInstance].requestMode = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].requestMode
    multiHTTPClient_Instances[selectedInstance].requestEndpoint = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].requestEndpoint
    multiHTTPClient_Instances[selectedInstance].requestPort = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].requestPort
    multiHTTPClient_Instances[selectedInstance].requestContent = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].requestContent
    multiHTTPClient_Instances[selectedInstance].requestContentType = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].requestContentType
    multiHTTPClient_Instances[selectedInstance].requestPeriodic = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].requestPeriodic
    multiHTTPClient_Instances[selectedInstance].requestPeriod = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].requestPeriod
    multiHTTPClient_Instances[selectedInstance].headers = helperFuncs.copy(multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].headers)
    multiHTTPClient_Instances[selectedInstance].registeredEvent = multiHTTPClient_Instances[selectedInstance].parameters.requests[requestName].registeredEvent
  else
    _G.logger:fine(nameOfModule .. ": Deselect request.")
    multiHTTPClient_Instances[selectedInstance].selectedRequest = nil
    multiHTTPClient_Instances[selectedInstance].requestName = ''
  end
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'selectedRequest', multiHTTPClient_Instances[selectedInstance].selectedRequest)
  handleOnExpiredTmrMultiHTTPClient()
end
Script.serveFunction('CSK_MultiHTTPClient.setSelectedRequest', setSelectedRequest)

local function setSelectedRequestViaUI(jsonRowData)
  local rowData = json.decode(jsonRowData)
  if rowData.Name ~= '-' then
    if rowData.selected == false then
      setSelectedRequest(rowData.Name)
    else
      multiHTTPClient_Instances[selectedInstance].selectedRequest = nil
      multiHTTPClient_Instances[selectedInstance].requestName = ''
      Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'selectedRequest', multiHTTPClient_Instances[selectedInstance].selectedRequest)
      handleOnExpiredTmrMultiHTTPClient()
    end
  end
end
Script.serveFunction('CSK_MultiHTTPClient.setSelectedRequestViaUI', setSelectedRequestViaUI)

local function setExtendedResponse(status)
  _G.logger:fine(nameOfModule .. ": Set 'extendedResponse' to " .. tostring(status))
  multiHTTPClient_Instances[selectedInstance].extendedResponse = status
  Script.notifyEvent("MultiHTTPClient_OnNewProcessingParameter", selectedInstance, 'extendedResponse', status)
end
Script.serveFunction('CSK_MultiHTTPClient.setExtendedResponse', setExtendedResponse)

local function getInstancesAmount ()
  if multiHTTPClient_Instances then
    return #multiHTTPClient_Instances
  else
    return 0
  end
end
Script.serveFunction("CSK_MultiHTTPClient.getInstancesAmount", getInstancesAmount)

local function addInstance()
  _G.logger:fine(nameOfModule .. ": Add instance")
  table.insert(multiHTTPClient_Instances, multiHTTPClient_Model.create(#multiHTTPClient_Instances+1))
  Script.deregister("CSK_MultiHTTPClient.OnNewValueToForward" .. tostring(#multiHTTPClient_Instances) , handleOnNewValueToForward)
  Script.register("CSK_MultiHTTPClient.OnNewValueToForward" .. tostring(#multiHTTPClient_Instances) , handleOnNewValueToForward)
  Script.deregister("CSK_MultiHTTPClient.OnNewValueUpdate" .. tostring(#multiHTTPClient_Instances) , handleOnNewValueUpdate)
  Script.register("CSK_MultiHTTPClient.OnNewValueUpdate" .. tostring(#multiHTTPClient_Instances) , handleOnNewValueUpdate)
  multiHTTPClient_Instances[selectedInstance].selectedRequest = nil
  setSelectedInstance(#multiHTTPClient_Instances)
  handleOnExpiredTmrMultiHTTPClient()
end
Script.serveFunction('CSK_MultiHTTPClient.addInstance', addInstance)

local function resetInstances()
  _G.logger:fine(nameOfModule .. ": Reset instances.")
  setSelectedInstance(1)
  local totalAmount = #multiHTTPClient_Instances
  while totalAmount > 1 do
    Script.releaseObject(multiHTTPClient_Instances[totalAmount])
    multiHTTPClient_Instances[totalAmount] =  nil
    totalAmount = totalAmount - 1
  end
  handleOnExpiredTmrMultiHTTPClient()
end
Script.serveFunction('CSK_MultiHTTPClient.resetInstances', resetInstances)

local function getStatusModuleActive()
  return _G.availableAPIs.default and _G.availableAPIs.specific
end
Script.serveFunction('CSK_MultiHTTPClient.getStatusModuleActive', getStatusModuleActive)

local function clearFlowConfigRelevantConfiguration()
  for i = 1, #multiHTTPClient_Instances do
    if multiWebSocketClient_Instances[i].parameters.flowConfigPriority then
      for key, value in pairs(multiHTTPClient_Instances[i].parameters.requests) do
        setSelectedRequest(key)
        removeRequest()
      end
    end
  end
end
Script.serveFunction('CSK_MultiHTTPClient.clearFlowConfigRelevantConfiguration', clearFlowConfigRelevantConfiguration)

local function getParameters(instanceNo)
  if instanceNo <= #multiHTTPClient_Instances then
    return helperFuncs.json.encode(multiHTTPClient_Instances[instanceNo].parameters)
  else
    return ''
  end
end
Script.serveFunction('CSK_MultiHTTPClient.getParameters', getParameters)

-- *****************************************************************
-- Following function can be adapted for CSK_PersistentData module usage
-- *****************************************************************

local function setParameterName(name)
  _G.logger:fine(nameOfModule .. ": Set parameter name = " .. tostring(name))
  multiHTTPClient_Instances[selectedInstance].parametersName = name
end
Script.serveFunction("CSK_MultiHTTPClient.setParameterName", setParameterName)

local function sendParameters(noDataSave)
  if multiHTTPClient_Instances[selectedInstance].persistentModuleAvailable then
    CSK_PersistentData.addParameter(helperFuncs.convertTable2Container(multiHTTPClient_Instances[selectedInstance].parameters), multiHTTPClient_Instances[selectedInstance].parametersName)

    -- Check if CSK_PersistentData version is >= 3.0.0
    if tonumber(string.sub(CSK_PersistentData.getVersion(), 1, 1)) >= 3 then
      CSK_PersistentData.setModuleParameterName(nameOfModule, multiHTTPClient_Instances[selectedInstance].parametersName, multiHTTPClient_Instances[selectedInstance].parameterLoadOnReboot, tostring(selectedInstance), #multiHTTPClient_Instances)
    else
      CSK_PersistentData.setModuleParameterName(nameOfModule, multiHTTPClient_Instances[selectedInstance].parametersName, multiHTTPClient_Instances[selectedInstance].parameterLoadOnReboot, tostring(selectedInstance))
    end
    _G.logger:fine(nameOfModule .. ": Send MultiHTTPClient parameters with name '" .. multiHTTPClient_Instances[selectedInstance].parametersName .. "' to CSK_PersistentData module.")
    if not noDataSave then
      CSK_PersistentData.saveData()
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
end
Script.serveFunction("CSK_MultiHTTPClient.sendParameters", sendParameters)

local function loadParameters()
  if multiHTTPClient_Instances[selectedInstance].persistentModuleAvailable then
    local data = CSK_PersistentData.getParameter(multiHTTPClient_Instances[selectedInstance].parametersName)
    if data then
      _G.logger:info(nameOfModule .. ": Loaded parameters for multiHTTPClientObject " .. tostring(selectedInstance) .. " from CSK_PersistentData module.")
      multiHTTPClient_Instances[selectedInstance].parameters = helperFuncs.convertContainer2Table(data)

      multiHTTPClient_Instances[selectedInstance].parameters = helperFuncs.checkParameters(multiHTTPClient_Instances[selectedInstance].parameters, helperFuncs.defaultParameters.getParameters())

      -- If something needs to be configured/activated with new loaded data
      Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'fullSetup', data)
      --announceExternalEventsAndFunctions() -- future usage
      CSK_MultiHTTPClient.pageCalled()
      tmrMultiHTTPClient:start()
      return true
    else
      _G.logger:warning(nameOfModule .. ": Loading parameters from CSK_PersistentData module did not work.")
      tmrMultiHTTPClient:start()
      return false
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
    tmrMultiHTTPClient:start()
    return false
  end
end
Script.serveFunction("CSK_MultiHTTPClient.loadParameters", loadParameters)

local function setLoadOnReboot(status)
  multiHTTPClient_Instances[selectedInstance].parameterLoadOnReboot = status
  _G.logger:fine(nameOfModule .. ": Set new status to load setting on reboot: " .. tostring(status))
  Script.notifyEvent("MultiHTTPClient_OnNewStatusLoadParameterOnReboot", status)
end
Script.serveFunction("CSK_MultiHTTPClient.setLoadOnReboot", setLoadOnReboot)

local function setFlowConfigPriority(status)
  multiHTTPClient_Instances[selectedInstance].parameters.flowConfigPriority = status
  _G.logger:fine(nameOfModule .. ": Set new status of FlowConfig priority: " .. tostring(status))
  Script.notifyEvent("MultiHTTPClient_OnNewStatusFlowConfigPriority", multiHTTPClient_Instances[selectedInstance].parameters.flowConfigPriority)
end
Script.serveFunction('CSK_MultiHTTPClient.setFlowConfigPriority', setFlowConfigPriority)

--- Function to react on initial load of persistent parameters
local function handleOnInitialDataLoaded()

  if _G.availableAPIs.default and _G.availableAPIs.specific then

    _G.logger:fine(nameOfModule .. ': Try to initially load parameter from CSK_PersistentData module.')
    if string.sub(CSK_PersistentData.getVersion(), 1, 1) == '1' then

      _G.logger:warning(nameOfModule .. ': CSK_PersistentData module is too old and will not work. Please update CSK_PersistentData module.')

      for j = 1, #multiHTTPClient_Instances do
        multiHTTPClient_Instances[j].persistentModuleAvailable = false
      end
    else
      -- Check if CSK_PersistentData version is >= 3.0.0
      if tonumber(string.sub(CSK_PersistentData.getVersion(), 1, 1)) >= 3 then
        local parameterName, loadOnReboot, totalInstances = CSK_PersistentData.getModuleParameterName(nameOfModule, '1')
        -- Check for amount if instances to create
        if totalInstances then
          local c = 2
          while c <= totalInstances do
            addInstance()
            c = c+1
          end
        end
      end

      if not multiHTTPClient_Instances then
        return
      end

      for i = 1, #multiHTTPClient_Instances do
        local parameterName, loadOnReboot = CSK_PersistentData.getModuleParameterName(nameOfModule, tostring(i))

        if parameterName then
          multiHTTPClient_Instances[i].parametersName = parameterName
          multiHTTPClient_Instances[i].parameterLoadOnReboot = loadOnReboot
        end

        if multiHTTPClient_Instances[i].parameterLoadOnReboot then
          setSelectedInstance(i)
          loadParameters()
        end
      end
      Script.notifyEvent('MultiHTTPClient_OnDataLoadedOnReboot')
    end
  end
end
Script.register("CSK_PersistentData.OnInitialDataLoaded", handleOnInitialDataLoaded)

local function resetModule()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    clearFlowConfigRelevantConfiguration()
    for i = 1, #multiHTTPClient_Instances do
      setClientActivated(false)
    end
    pageCalled()
  end
end
Script.serveFunction('CSK_MultiHTTPClient.resetModule', resetModule)
Script.register("CSK_PersistentData.OnResetAllModules", resetModule)

-- *************************************************
-- END of functions for CSK_PersistentData module usage
-- *************************************************

return funcs

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************

