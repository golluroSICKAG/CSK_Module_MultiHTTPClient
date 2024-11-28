--*****************************************************************
-- Here you will find all the required content to provide specific
-- features of this module via the 'CSK FlowConfig'.
--*****************************************************************

require('Communication.MultiHTTPClient.FlowConfig.MultiHTTPClient_SendRequest')

-- Reference to the multiHTTPClient_Instances handle
local multiHTTPClient_Instances

--- Function to react if FlowConfig was updated
local function handleOnClearOldFlow()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    for i = 1, # multiHTTPClient_Instances do
      if multiHTTPClient_Instances[i].parameters.flowConfigPriority then
        CSK_MultiHTTPClient.clearFlowConfigRelevantConfiguration()
        break
      end
    end
  end
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)

--- Function to get access to the multiHTTPClient_Instances
---@param handle handle Handle of multiHTTPClient_Instances object
local function setMultiHTTPClient_Instances_Handle(handle)
  multiHTTPClient_Instances = handle
end

return setMultiHTTPClient_Instances_Handle