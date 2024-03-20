--MIT License
--
--Copyright (c) 2023 SICK AG
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.

---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

-- 
-- CreationTemplateVersion: 3.6.0
--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

-- If app property "LuaLoadAllEngineAPI" is FALSE, use this to load and check for required APIs
-- This can improve performance of garbage collection

_G.availableAPIs = require('Communication/MultiHTTPClient/helper/checkAPIs') -- can be used to adjust function scope of the module related on available APIs of the device
-----------------------------------------------------------
-- Logger
_G.logger = Log.SharedLogger.create('ModuleLogger')
_G.logHandle = Log.Handler.create()
_G.logHandle:attachToSharedLogger('ModuleLogger')
_G.logHandle:setConsoleSinkEnabled(false) --> Set to TRUE if CSK_Logger is not used
_G.logHandle:setLevel("ALL")
_G.logHandle:applyConfig()
-----------------------------------------------------------

-- Loading script regarding MultiHTTPClient_Model
-- Check this script regarding MultiHTTPClient_Model parameters and functions
local multiHTTPClient_Model = require('Communication/MultiHTTPClient/MultiHTTPClient_Model')

local multiHTTPClient_Instances = {} -- Handle all instances
table.insert(multiHTTPClient_Instances, multiHTTPClient_Model.create(1)) -- Create at least 1 instance

-- Load script to communicate with the MultiHTTPClient_Model UI
-- Check / edit this script to see/edit functions which communicate with the UI
local multiHTTPClientController = require('Communication/MultiHTTPClient/MultiHTTPClient_Controller')
multiHTTPClientController.setMultiHTTPClient_Instances_Handle(multiHTTPClient_Instances) -- share handle of instances

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--[[
--- Function to show how this module could be used
local function setup()

  CSK_MultiHTTPClient.setRequestMode('POST')
  CSK_MultiHTTPClient.setRequestEndpoint('http://192.168.0.1/api/crown/DateTime/setDateTime')

  CSK_MultiHTTPClient.setRequestName('TestRequest')
  CSK_MultiHTTPClient.setRequestRegisteredEvent('TestApp.OnNewTrigger') -- Needs to be served by another app...
  CSK_MultiHTTPClient.setRequestBody('{"data":{"year": 1986,"month": 3,"day": 2,"hour": 10,"minute": 11,"second": 12}}')
  CSK_MultiHTTPClient.addEditRequestViaUI()
  CSK_MultiHTTPClient.setMaxQueueSize(10)

  local function getResponse(response)
    print(response)
  end

  if Script.isServedAsEvent('CSK_MultiHTTPClient.OnNewResponse1_TestRequest') then
    Script.register("CSK_MultiHTTPClient.OnNewResponse1_TestRequest", getResponse)
  end
end
]]

--- Function to react on startup event of the app
local function main()

  multiHTTPClientController.setMultiHTTPClient_Model_Handle(multiHTTPClient_Model) -- share handle of Model

  ----------------------------------------------------------------------------------------
  -- INFO: Please check if module will eventually load inital configuration triggered via
  --       event CSK_PersistentData.OnInitialDataLoaded
  --       (see internal variable _G.multiHTTPClient_Model.parameterLoadOnReboot)
  --       If so, the app will trigger the "OnDataLoadedOnReboot" event if ready after loading parameters
  --
  ----------------------------------------------------------------------------------------

  --setup() --> just for docu, see above
  CSK_MultiHTTPClient.setSelectedInstance(1)
  CSK_MultiHTTPClient.pageCalled() -- Update UI

end
Script.register("Engine.OnStarted", main)

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************