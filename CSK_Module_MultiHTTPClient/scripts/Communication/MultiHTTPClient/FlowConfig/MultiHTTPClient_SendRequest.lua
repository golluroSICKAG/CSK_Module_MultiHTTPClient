-- Block namespace
local BLOCK_NAMESPACE = 'MultiHTTPClient_FC.SendRequest'
local nameOfModule = 'CSK_MultiHTTPClient'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function sendRequest(handle, source)

  local instance = Container.get(handle, 'Instance')
  local requestName = Container.get(handle, 'RequestName')
  local mode = Container.get(handle, 'Mode')
  local endpoint = Container.get(handle, 'Endpoint')
  local port = Container.get(handle, 'Port')

  -- Check if amount of instances is valid
  -- if not: add multiple additional instances
  while true do
    local amount = CSK_MultiHTTPClient.getInstancesAmount()
    if amount < instance then
      CSK_MultiHTTPClient.addInstance()
    else
      CSK_MultiHTTPClient.setSelectedInstance(instance)

      CSK_MultiHTTPClient.addRequest(requestName, mode, endpoint, port, source, false)
      break
    end
  end

  return 'CSK_MultiHTTPClient.OnNewResponse' .. tostring(instance) .. '_' .. tostring(requestName)
end
Script.serveFunction(BLOCK_NAMESPACE .. '.sendRequest', sendRequest)

--*************************************************************
--*************************************************************

local function create(instance, requestName, mode, endpoint, port)

  local fullInstanceName = tostring(instance) .. tostring(requestName)

  -- Check if same instance is already configured
  if instance < 1 or nil ~= instanceTable[fullInstanceName] then
    _G.logger:warning(nameOfModule .. ': Instance invalid or already in use, please choose another one')
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable[instance] = instance
    Container.add(handle, 'Instance', instance)
    Container.add(handle, 'RequestName', requestName)
    Container.add(handle, 'Mode', mode)
    Container.add(handle, 'Endpoint', endpoint)
    Container.add(handle, 'Port', port)
    return handle
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. '.create', create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)