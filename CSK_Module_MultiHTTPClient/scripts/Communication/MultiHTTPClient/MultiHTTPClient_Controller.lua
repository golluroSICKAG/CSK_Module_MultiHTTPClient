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

-- ************************ UI Events Start ********************************
-- Only to prevent WARNING messages, but these are only examples/placeholders for dynamically created events/functions
----------------------------------------------------------------
local function emptyFunction()
end
Script.serveFunction("CSK_MultiHTTPClient.processInstanceNUM", emptyFunction)

Script.serveEvent("CSK_MultiHTTPClient.OnNewResultNUM", "MultiHTTPClient_OnNewResultNUM")
Script.serveEvent("CSK_MultiHTTPClient.OnNewValueToForwardNUM", "MultiHTTPClient_OnNewValueToForwardNUM")
Script.serveEvent("CSK_MultiHTTPClient.OnNewValueUpdateNUM", "MultiHTTPClient_OnNewValueUpdateNUM")
----------------------------------------------------------------

-- Real events
--------------------------------------------------
-- Script.serveEvent("CSK_MultiHTTPClient.OnNewEvent", "MultiHTTPClient_OnNewEvent")
Script.serveEvent('CSK_MultiHTTPClient.OnNewResult', 'MultiHTTPClient_OnNewResult')

Script.serveEvent('CSK_MultiHTTPClient.OnNewStatusRegisteredEvent', 'MultiHTTPClient_OnNewStatusRegisteredEvent')

Script.serveEvent("CSK_MultiHTTPClient.OnNewStatusLoadParameterOnReboot", "MultiHTTPClient_OnNewStatusLoadParameterOnReboot")
Script.serveEvent("CSK_MultiHTTPClient.OnPersistentDataModuleAvailable", "MultiHTTPClient_OnPersistentDataModuleAvailable")
Script.serveEvent("CSK_MultiHTTPClient.OnNewParameterName", "MultiHTTPClient_OnNewParameterName")

Script.serveEvent("CSK_MultiHTTPClient.OnNewInstanceList", "MultiHTTPClient_OnNewInstanceList")
Script.serveEvent("CSK_MultiHTTPClient.OnNewProcessingParameter", "MultiHTTPClient_OnNewProcessingParameter")
Script.serveEvent("CSK_MultiHTTPClient.OnNewSelectedInstance", "MultiHTTPClient_OnNewSelectedInstance")
Script.serveEvent("CSK_MultiHTTPClient.OnDataLoadedOnReboot", "MultiHTTPClient_OnDataLoadedOnReboot")

Script.serveEvent("CSK_MultiHTTPClient.OnUserLevelOperatorActive", "MultiHTTPClient_OnUserLevelOperatorActive")
Script.serveEvent("CSK_MultiHTTPClient.OnUserLevelMaintenanceActive", "MultiHTTPClient_OnUserLevelMaintenanceActive")
Script.serveEvent("CSK_MultiHTTPClient.OnUserLevelServiceActive", "MultiHTTPClient_OnUserLevelServiceActive")
Script.serveEvent("CSK_MultiHTTPClient.OnUserLevelAdminActive", "MultiHTTPClient_OnUserLevelAdminActive")

-- ...

-- ************************ UI Events End **********************************

--[[
--- Some internal code docu for local used function
local function functionName()
  -- Do something

end
]]

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

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
  -- Script.notifyEvent("MultiHTTPClient_OnNewEvent", false)

  updateUserLevel()

  Script.notifyEvent('MultiHTTPClient_OnNewSelectedInstance', selectedInstance)
  Script.notifyEvent("MultiHTTPClient_OnNewInstanceList", helperFuncs.createStringListBySize(#multiHTTPClient_Instances))

  Script.notifyEvent("MultiHTTPClient_OnNewStatusRegisteredEvent", multiHTTPClient_Instances[selectedInstance].parameters.registeredEvent)

  Script.notifyEvent("MultiHTTPClient_OnNewStatusLoadParameterOnReboot", multiHTTPClient_Instances[selectedInstance].parameterLoadOnReboot)
  Script.notifyEvent("MultiHTTPClient_OnPersistentDataModuleAvailable", multiHTTPClient_Instances[selectedInstance].persistentModuleAvailable)
  Script.notifyEvent("MultiHTTPClient_OnNewParameterName", multiHTTPClient_Instances[selectedInstance].parametersName)

  -- ...
end
Timer.register(tmrMultiHTTPClient, "OnExpired", handleOnExpiredTmrMultiHTTPClient)

-- ********************* UI Setting / Submit Functions Start ********************

local function pageCalled()
  updateUserLevel() -- try to hide user specific content asap
  tmrMultiHTTPClient:start()
  return ''
end
Script.serveFunction("CSK_MultiHTTPClient.pageCalled", pageCalled)

local function setSelectedInstance(instance)
  selectedInstance = instance
  _G.logger:info(nameOfModule .. ": New selected instance = " .. tostring(selectedInstance))
  multiHTTPClient_Instances[selectedInstance].activeInUI = true
  Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'activeInUI', true)
  tmrMultiHTTPClient:start()
end
Script.serveFunction("CSK_MultiHTTPClient.setSelectedInstance", setSelectedInstance)

local function getInstancesAmount ()
  return #multiHTTPClient_Instances
end
Script.serveFunction("CSK_MultiHTTPClient.getInstancesAmount", getInstancesAmount)

local function addInstance()
  _G.logger:info(nameOfModule .. ": Add instance")
  table.insert(multiHTTPClient_Instances, multiHTTPClient_Model.create(#multiHTTPClient_Instances+1))
  Script.deregister("CSK_MultiHTTPClient.OnNewValueToForward" .. tostring(#multiHTTPClient_Instances) , handleOnNewValueToForward)
  Script.register("CSK_MultiHTTPClient.OnNewValueToForward" .. tostring(#multiHTTPClient_Instances) , handleOnNewValueToForward)
  handleOnExpiredTmrMultiHTTPClient()
end
Script.serveFunction('CSK_MultiHTTPClient.addInstance', addInstance)

local function resetInstances()
  _G.logger:info(nameOfModule .. ": Reset instances.")
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

local function setRegisterEvent(event)
  multiHTTPClient_Instances[selectedInstance].parameters.registeredEvent = event
  Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'registeredEvent', event)
end
Script.serveFunction("CSK_MultiHTTPClient.setRegisterEvent", setRegisterEvent)

--- Function to share process relevant configuration with processing threads
local function updateProcessingParameters()
  Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'activeInUI', true)

  Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'registeredEvent', multiHTTPClient_Instances[selectedInstance].parameters.registeredEvent)

  --Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'value', multiHTTPClient_Instances[selectedInstance].parameters.value)

  -- optionally for internal objects...
  --[[
  -- Send config to instances
  local params = helperFuncs.convertTable2Container(multiHTTPClient_Instances[selectedInstance].parameters.internalObject)
  Container.add(data, 'internalObject', params, 'OBJECT')
  Script.notifyEvent('MultiHTTPClient_OnNewProcessingParameter', selectedInstance, 'FullSetup', data)
  ]]

end

-- *****************************************************************
-- Following function can be adapted for CSK_PersistentData module usage
-- *****************************************************************

local function setParameterName(name)
  _G.logger:info(nameOfModule .. ": Set parameter name = " .. tostring(name))
  multiHTTPClient_Instances[selectedInstance].parametersName = name
end
Script.serveFunction("CSK_MultiHTTPClient.setParameterName", setParameterName)

local function sendParameters()
  if multiHTTPClient_Instances[selectedInstance].persistentModuleAvailable then
    CSK_PersistentData.addParameter(helperFuncs.convertTable2Container(multiHTTPClient_Instances[selectedInstance].parameters), multiHTTPClient_Instances[selectedInstance].parametersName)

    -- Check if CSK_PersistentData version is >= 3.0.0
    if tonumber(string.sub(CSK_PersistentData.getVersion(), 1, 1)) >= 3 then
      CSK_PersistentData.setModuleParameterName(nameOfModule, multiHTTPClient_Instances[selectedInstance].parametersName, multiHTTPClient_Instances[selectedInstance].parameterLoadOnReboot, tostring(selectedInstance), #multiHTTPClient_Instances)
    else
      CSK_PersistentData.setModuleParameterName(nameOfModule, multiHTTPClient_Instances[selectedInstance].parametersName, multiHTTPClient_Instances[selectedInstance].parameterLoadOnReboot, tostring(selectedInstance))
    end
    _G.logger:info(nameOfModule .. ": Send MultiHTTPClient parameters with name '" .. multiHTTPClient_Instances[selectedInstance].parametersName .. "' to CSK_PersistentData module.")
    CSK_PersistentData.saveData()
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

      -- If something needs to be configured/activated with new loaded data
      updateProcessingParameters()
      CSK_MultiHTTPClient.pageCalled()
    else
      _G.logger:warning(nameOfModule .. ": Loading parameters from CSK_PersistentData module did not work.")
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
  tmrMultiHTTPClient:start()
end
Script.serveFunction("CSK_MultiHTTPClient.loadParameters", loadParameters)

local function setLoadOnReboot(status)
  multiHTTPClient_Instances[selectedInstance].parameterLoadOnReboot = status
  _G.logger:info(nameOfModule .. ": Set new status to load setting on reboot: " .. tostring(status))
end
Script.serveFunction("CSK_MultiHTTPClient.setLoadOnReboot", setLoadOnReboot)

--- Function to react on initial load of persistent parameters
local function handleOnInitialDataLoaded()

  _G.logger:info(nameOfModule .. ': Try to initially load parameter from CSK_PersistentData module.')
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
Script.register("CSK_PersistentData.OnInitialDataLoaded", handleOnInitialDataLoaded)

return funcs

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************

