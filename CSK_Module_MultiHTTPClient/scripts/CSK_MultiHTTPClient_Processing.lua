---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

-- If App property "LuaLoadAllEngineAPI" is FALSE, use this to load and check for required APIs
-- This can improve performance of garbage collection
local availableAPIs = require('Communication/MultiHTTPClient/helper/checkAPIs') -- check for available APIs
-----------------------------------------------------------
local nameOfModule = 'CSK_MultiHTTPClient'
--Logger
_G.logger = Log.SharedLogger.create('ModuleLogger')

-- Load helper funcs
local helperFuncs = require('Communication/MultiHTTPClient/helper/funcs')
local json = require('Communication/MultiHTTPClient/helper/Json')

local scriptParams = Script.getStartArgument() -- Get parameters from model

local multiHTTPClientInstanceNumber = scriptParams:get('multiHTTPClientInstanceNumber') -- number of this instance
local multiHTTPClientInstanceNumberString = tostring(multiHTTPClientInstanceNumber) -- number of this instance as string

-- Event to notify result of processing
Script.serveEvent("CSK_MultiHTTPClient.OnNewResponse" .. multiHTTPClientInstanceNumberString, "MultiHTTPClient_OnNewResponse" .. multiHTTPClientInstanceNumberString, 'string')
-- Event to forward content from this thread to Controller to show e.g. on UI
Script.serveEvent("CSK_MultiHTTPClient.OnNewValueToForward".. multiHTTPClientInstanceNumberString, "MultiHTTPClient_OnNewValueToForward" .. multiHTTPClientInstanceNumberString, 'string, auto')
-- Event to forward update of e.g. parameter update to keep data in sync between threads
Script.serveEvent("CSK_MultiHTTPClient.OnNewValueUpdate" .. multiHTTPClientInstanceNumberString, "MultiHTTPClient_OnNewValueUpdate" .. multiHTTPClientInstanceNumberString, 'int, string, auto, int:?')

local processingParams = {}
processingParams.key = scriptParams:get('key')
processingParams.interface = scriptParams:get('interface')
processingParams.activeInUI = false
processingParams.clientActivated = scriptParams:get('clientActivated')
processingParams.hostnameVerification = scriptParams:get('hostnameVerification')
processingParams.peerVerification = scriptParams:get('peerVerification')
processingParams.cookieStore = scriptParams:get('cookieStore')
processingParams.clientAuthentication = scriptParams:get('clientAuthentication')
processingParams.caBundleFileName = scriptParams:get('caBundleFileName')
processingParams.clientCertificateType = scriptParams:get('clientCertificateType')
processingParams.clientCertificateFileName = scriptParams:get('clientCertificateFileName')
processingParams.clientCertificateKeyType = scriptParams:get('clientCertificateKeyType')
processingParams.clientCertificateKeyFileName = scriptParams:get('clientCertificateKeyFileName')
processingParams.clientCertificateKeyPassphrase = scriptParams:get('clientCertificateKeyPassphrase')

processingParams.proxyEnabled = scriptParams:get('proxyEnabled')
processingParams.proxyURL = scriptParams:get('proxyURL')
processingParams.proxyPort = scriptParams:get('proxyPort')
processingParams.proxyUsername = scriptParams:get('proxyUsername')
processingParams.proxyPassword = scriptParams:get('proxyPassword')

processingParams.extendedResponse = scriptParams:get('extendedResponse')
processingParams.verboseMode = scriptParams:get('verboseMode')
processingParams.queueSize = scriptParams:get('queueSize')

--- Parameters of temporarly configured request
processingParams.requests = {}
processingParams.headers = {}

processingParams.requestMode = scriptParams:get('requestMode')
processingParams.requestEndpoint = scriptParams:get('requestEndpoint')
processingParams.requestPort = scriptParams:get('requestPort')
processingParams.requestContent = scriptParams:get('requestContent')
processingParams.requestContentType = scriptParams:get('requestContentType')
processingParams.requestPeriodic = scriptParams:get('requestPeriodic')
processingParams.requestPeriod = scriptParams:get('requestPeriod')
processingParams.registeredEvent = scriptParams:get('registeredEvent')

local clientObject = nil -- HTTPClient object
local request = HTTPClient.Request.create() -- Response to execute

local selectedRequest = nil -- Currently selected request
local timers = {} -- Internally used timers to trigger periodic requests
local timerFunctions = {} -- Internally used functions to execute periodic requests
local eventFunctions = {} -- Internally used functions to execute event triggered requests
local timerQueues = {} -- Internally queues to check for waiting timer triggers
local eventQueues = {} -- Internally queues to check for waiting event triggers

--- Parameters of currently selected preconfigured request
local selectedRequestParameter = {}

-----------------------------------------

--- Function to load parameters of a specific preconfigured request for temporarly used request
---@param requestName string Name of preconfigured request
local function setTempSpecificRequest(requestName)
  processingParams.requestMode = processingParams.requests[requestName]['requestMode']
  processingParams.requestEndpoint = processingParams.requests[requestName]['requestEndpoint']
  processingParams.requestPort = processingParams.requests[requestName]['requestPort']
  processingParams.requestContent = processingParams.requests[requestName]['requestContent']
  processingParams.requestContentType = processingParams.requests[requestName]['requestContentType']
  processingParams.requestPeriodic = processingParams.requests[requestName]['requestPeriodic']
  processingParams.requestPeriod = processingParams.requests[requestName]['requestPeriod']
  processingParams.headers = processingParams.requests[requestName]['headers']
  processingParams.registeredEvent = processingParams.requests[requestName]['registeredEvent']
end

--- Function to load parameters of a specific preconfigured request
---@param requestName string Name of preconfigured request
local function setSpecificRequest(requestName)
  selectedRequestParameter.requestName = requestName
  selectedRequestParameter.requestMode = processingParams.requests[requestName]['requestMode']
  selectedRequestParameter.requestEndpoint = processingParams.requests[requestName]['requestEndpoint']
  selectedRequestParameter.requestPort = processingParams.requests[requestName]['requestPort']
  selectedRequestParameter.requestContent = processingParams.requests[requestName]['requestContent']
  selectedRequestParameter.requestContentType = processingParams.requests[requestName]['requestContentType']
  selectedRequestParameter.requestPeriodic = processingParams.requests[requestName]['requestPeriodic']
  selectedRequestParameter.requestPeriod = processingParams.requests[requestName]['requestPeriod']
  selectedRequestParameter.headers = processingParams.requests[requestName]['headers']
  selectedRequestParameter.registeredEvent = processingParams.requests[requestName]['registeredEvent']
end

--- Function to update setup of HTTP client
local function updateClient()

  if clientObject then
    -- Free old HTTP client
    Script.releaseObject(clientObject)
    clientObject = nil
    collectgarbage()
  end
  clientObject = HTTPClient.create()

  clientObject:setVerbose(processingParams.verboseMode)
  if processingParams.clientAuthentication then
    if File.exists(processingParams.caBundleFileName) then
      clientObject:setCABundle(processingParams.caBundleFileName)
      _G.logger:fine(nameOfModule .. ": CA_Bundle active.")
    else
      _G.logger:warning(nameOfModule .. ": No CA_Bundle file available.")
    end

    if File.exists(processingParams.clientCertificateFileName .. processingParams.clientCertificateType) and File.exists(processingParams.clientCertificateKeyFileName .. processingParams.clientCertificateKeyType) then
      if processingParams.clientCertificateKeyPassphrase ~= '' then
        clientObject:setClientCertificate(processingParams.clientCertificateFileName .. processingParams.clientCertificateType, processingParams.clientCertificateKeyFileName .. processingParams.clientCertificateKeyType, Cipher.AES.decrypt(processingParams.clientCertificateKeyPassphrase, processingParams.key))
      else
        clientObject:setClientCertificate(processingParams.clientCertificateFileName .. processingParams.clientCertificateType, processingParams.clientCertificateKeyFileName .. processingParams.clientCertificateKeyType)
      end
      _G.logger:fine(nameOfModule .. ": Client authentication active.")
    else
      _G.logger:warning(nameOfModule .. ": No client authentication files available.")
    end

  end
  if processingParams.cookieStore ~= '' then
    clientObject:setCookieStore('public/CSK_HTTPClient/' .. processingParams.cookieStore)
  end
  clientObject:setHostnameVerification(processingParams.hostnameVerification)
  clientObject:setPeerVerification(processingParams.peerVerification)
  if processingParams.interface ~= "Localhost" then
    clientObject:setInterface(processingParams.interface)
  end
  if processingParams.proxyEnabled then
    clientObject:setProxy(processingParams.proxyURL, processingParams.proxyPort)
    clientObject:setProxyAuth(processingParams.proxyUsername, Cipher.AES.decrypt(processingParams.proxyPassword, processingParams.key))
  end
end
updateClient()

--- Function to prepare request
---@param params auto[] Table with all relevant request parameters
local function updateInternalRequest(params)
  request = HTTPClient.Request.create()

  -- Optionally add headers
  for key, value in pairs(params.headers) do
    request:addHeader(key, value)
  end

  request:setPort(params.requestPort)
  request:setMethod(params.requestMode)
  request:setURL(params.requestEndpoint)

  -- Optionally add content payload
  if params.requestMode ~= 'GET' and params.requestMode ~= 'DELETE' then
    if params.requestContent ~= '' then
      request:setContentType(params.requestContentType)
      request:setContentBuffer(params.requestContent)
    end
  end
end

--- Function to execute a request
---@param tempRequestActive bool Status if it is just a temporarly configured request or a preconfigured one
---@param showResponse bool Status if repsonse should be notified as event (e.g. to show it on UI)
---@param eventName string Name of event to notify the response
local function sendRequest(tempRequestActive, showResponse, eventName)

  local timerQueueSize = 0
  local eventQueueSize = 0

  if tempRequestActive then
    updateInternalRequest(processingParams)
  else
    updateInternalRequest(selectedRequestParameter)
    if timerQueues[selectedRequestParameter.requestName] then
      timerQueueSize = timerQueues[selectedRequestParameter.requestName]:getSize()
    end
    if eventQueues[selectedRequestParameter.requestName] then
      eventQueueSize = eventQueues[selectedRequestParameter.requestName]:getSize()
    end
  end

  if timerQueueSize >= processingParams.queueSize-1 or eventQueueSize >= processingParams.queueSize-1 then
    _G.logger:warning(nameOfModule .. ": Internal request queue too high '(Timer:" .. tostring(timerQueueSize) .. '/Events:' .. tostring(eventQueueSize) .. ")'. Will skip new requests...")
  else
    local tic = DateTime.getTimestamp()
    local response = clientObject:execute(request)
    local procTime = DateTime.getTimestamp() - tic

    local success = HTTPClient.Response.getSuccess(response)
    _G.logger:fine(nameOfModule .. ": Response success =  " .. tostring(success))

    -- Check response
    local responseMessage = 'After ' .. tostring(procTime) .. 'ms --> ' .. 'Request success = ' .. tostring(success) .. '\n'
    responseMessage = responseMessage .. 'Code: ' .. HTTPClient.Response.getStatusCode(response) .. '\n'

    if success then
      -- Check if extended information of the response should be shown
      if processingParams.extendedResponse then
        responseMessage = responseMessage .. 'Request content type: ' .. HTTPClient.Response.getContentType(response) .. '\n'

        local tempKeys = HTTPClient.Response.getHeaderKeys(response)
        for _, headerKeys in pairs(tempKeys) do

          local suc, tempValues = HTTPClient.Response.getHeaderValues(response, headerKeys)
          for _, headerValue in pairs(tempValues) do
            responseMessage = responseMessage .. 'Header-key: ' .. headerKeys .. ' = ' .. headerValue .. '\n'
          end
        end
      end

      responseMessage = responseMessage .. helperFuncs.jsonLine2Table(HTTPClient.Response.getContent(response)) .. '\n'
    else
      local error = HTTPClient.Response.getError(response)
      local errorDetail = HTTPClient.Response.getErrorDetail(response)
      responseMessage = responseMessage .. 'Error = ' .. error .. '\n' .. 'Error details = ' .. errorDetail .. '\n'
    end
    if eventName then
      Script.notifyEvent(eventName, responseMessage)
    else
      Script.notifyEvent("MultiHTTPClient_OnNewResponse" .. multiHTTPClientInstanceNumberString, responseMessage)
    end

    if processingParams.activeInUI then
      if showResponse then
        Script.notifyEvent("MultiHTTPClient_OnNewValueToForward" .. multiHTTPClientInstanceNumberString, "MultiHTTPClient_OnNewResponseMessage", responseMessage)
      end
    end
  end
end

--- Function to set timer if request should be executed periodically
---@param requestName string Name of preconfigured request
local function setTimer(requestName)

  if not timers[requestName] then
    local tmr = Timer.create()
    tmr:setExpirationTime(processingParams.requestPeriod)
    tmr:setPeriodic(true)

    local function callRequest()
      if processingParams.clientActivated then
        setSpecificRequest(requestName)
        if selectedRequest == requestName then
          sendRequest(false, true, "MultiHTTPClient_OnNewReponse" .. multiHTTPClientInstanceNumberString .. '_' .. processingParams.requests[requestName].requestName)
        else
          sendRequest(false, false, "MultiHTTPClient_OnNewReponse" .. multiHTTPClientInstanceNumberString .. '_' .. processingParams.requests[requestName].requestName)
        end
      end
    end
    timerFunctions[requestName] = callRequest

    timers[requestName] = tmr
    Timer.register(timers[requestName], 'OnExpired', timerFunctions[requestName])
  else
    timers[requestName]:setExpirationTime(processingParams.requestPeriod)
  end
  Timer.start(timers[requestName])
end

--- Function to stop timer
---@param requestName string Name of preconfigured request
local function stopTimer(requestName)

  if timers[requestName] then
    Timer.stop(timers[requestName])
  end
end

--- Function to delete header key
---@param value string Key to delete
local function deleteHeader(value)
  if processingParams.headers[value] then
    processingParams.headers[value] = nil
  end
  collectgarbage()
end

--- Function to create functions if request should be executed via event trigger
---@param requestName string Name of preconfigured request
local function setRegisteredEvent(requestName)

  if not eventFunctions[requestName] then
    local function callRequest(optPayload)
      if processingParams.clientActivated then
        if optPayload then
          processingParams.requests[requestName].requestContent = optPayload
        end
        setSpecificRequest(requestName)
        if selectedRequest == requestName then
          sendRequest(false, true, "MultiHTTPClient_OnNewReponse" .. multiHTTPClientInstanceNumberString .. '_' .. processingParams.requests[requestName].requestName)
        else
          sendRequest(false, false, "MultiHTTPClient_OnNewReponse" .. multiHTTPClientInstanceNumberString .. '_' .. processingParams.requests[requestName].requestName)
        end
      end
    end
    eventFunctions[requestName] = callRequest
  end
  Script.register(processingParams.requests[requestName].registeredEvent, eventFunctions[requestName])
end

local function clearQueues(requestName)
  if timerQueues[requestName] then
    timerQueues[requestName]:clear()
  end
  if eventQueues[requestName] then
    eventQueues[requestName]:clear()
  end
end

local function createQueue(requestName)

  if timerFunctions[requestName] then
    if not timerQueues[requestName] then
      timerQueues[requestName] = Script.Queue.create()
      timerQueues[requestName]:setMaxQueueSize(processingParams.queueSize)
    else
      timerQueues[requestName]:clear()
    end
    timerQueues[requestName]:setFunction(timerFunctions[requestName])
  end

  if eventFunctions[requestName] then
    if not eventQueues[requestName] then
      eventQueues[requestName] = Script.Queue.create()
      eventQueues[requestName]:setMaxQueueSize(processingParams.queueSize)
    else
      eventQueues[requestName]:clear()
    end
    eventQueues[requestName]:setFunction(eventFunctions[requestName])
  end
end

local function setQueueSize()
  for key, value in pairs(timerQueues) do
    timerQueues[key]:clear()
    timerQueues[key]:setMaxQueueSize(processingParams.queueSize)
  end
  for key, value in pairs(eventQueues) do
    eventQueues[key]:clear()
    eventQueues[key]:setMaxQueueSize(processingParams.queueSize)
  end
end

--- Function to delete a request
---@param requestName string Name of selected request
local function clearRequest(requestName)
  stopTimer(requestName)
  timers[requestName] = nil
  timerFunctions[requestName] = nil
  clearQueues(requestName)
  timerQueues[requestName] = nil
  eventQueues[requestName] = nil

  if processingParams.requests[requestName].registeredEvent ~= '' then
    Script.deregister(processingParams.requests[requestName].registeredEvent, eventFunctions[requestName])
  end

  processingParams.requests[requestName] = nil
  selectedRequest = nil
  collectgarbage()
end

--- Function to add request
---@param content auto[] Parameters to set
local function addRequest(content)
  processingParams.requests[content.requestName] = content

  if not Script.isServedAsEvent("CSK_MultiHTTPClient.OnNewResponse" .. multiHTTPClientInstanceNumberString .. '_' .. content.requestName) then
    -- Event to notify result of processing
    Script.serveEvent("CSK_MultiHTTPClient.OnNewResponse" .. multiHTTPClientInstanceNumberString .. '_' .. content.requestName, "MultiHTTPClient_OnNewReponse" .. multiHTTPClientInstanceNumberString .. '_' .. content.requestName, 'string')
  end

  if content.registeredEvent ~= '' then
    setRegisteredEvent(content.requestName)
  end

  if content.requestPeriodic == true then
    setTimer(content.requestName)
  end

  if content.registeredEvent ~= '' or content.requestPeriodic == true then
    createQueue(content.requestName)
  end
end

--- Function to update parameters of a selected request
---@param requestName string Name of selected request
---@param content auto[] New parameters to set
local function updateRequest(requestName, content)

  clearQueues(requestName)

  processingParams.requests[requestName].requestMode = content['requestMode']
  processingParams.requests[requestName].requestEndpoint = content['requestEndpoint']
  processingParams.requests[requestName].requestPort = content['requestPort']
  processingParams.requests[requestName].requestContent = content['requestContent']
  processingParams.requests[requestName].requestContentType = content['requestContentType']
  processingParams.requests[requestName].requestPeriodic = content['requestPeriodic']
  processingParams.requests[requestName].requestPeriod = content['requestPeriod']
  processingParams.requests[requestName].headers = content['headers']

  if content['requestPeriodic'] == true then
    setTimer(requestName)
  else
    stopTimer(requestName)
  end

  if processingParams.requests[requestName].registeredEvent ~= '' then
    Script.deregister(processingParams.requests[requestName].registeredEvent, eventFunctions[requestName])
  end

  if content['registeredEvent'] ~= '' then
    processingParams.requests[requestName].registeredEvent = content['registeredEvent']
    setRegisteredEvent(requestName)
  end

  if content.registeredEvent ~= '' or content.requestPeriodic == true then
    createQueue(content.requestName)
  end
end

local function fullSetup(parameters)

  for key, value in pairs(processingParams.requests) do
    clearRequest(key)
  end

  processingParams.requests = {}
  processingParams.headers = {}
  collectgarbage()

  processingParams.interface = parameters.interface
  processingParams.clientActivated = parameters.clientActivated
  processingParams.hostnameVerification = parameters.hostnameVerification
  processingParams.peerVerification = parameters.peerVerification
  processingParams.clientAuthentication = parameters.clientAuthentication
  processingParams.cookieStore = parameters.cookieStore
  processingParams.proxyEnabled = parameters.proxyEnabled
  processingParams.proxyURL = parameters.proxyURL
  processingParams.proxyPort = parameters.proxyPort
  processingParams.proxyUsername = parameters.proxyUsername
  processingParams.proxyPassword = parameters.proxyPassword
  processingParams.extendedResponse = parameters.extendedResponse
  processingParams.verboseMode = parameters.verboseMode

  for key, value in pairs(parameters.requests) do
    processingParams.requestPeriod = parameters.requests[key].requestPeriod
    addRequest(value)
  end
  updateClient()
end

--- Function to handle updates of processing parameters from Controller
---@param multiHTTPClientNo int Number of instance to update
---@param parameter string Parameter to update
---@param value auto? Value of parameter to update
---@param value2 auto? 2nd value of parameter to update
local function handleOnNewProcessingParameter(multiHTTPClientNo, parameter, value, value2)

  if multiHTTPClientNo == multiHTTPClientInstanceNumber then -- set parameter only in selected script

    if value ~= nil then
      if value2 ~= nil then
        _G.logger:fine(nameOfModule .. ": Update parameter '" .. parameter .. "' of multiHTTPClientInstanceNo." .. tostring(multiHTTPClientNo) .. " to value = " .. tostring(value) .. ' + value 2 = ' .. tostring(value2))
      else
        _G.logger:fine(nameOfModule .. ": Update parameter '" .. parameter .. "' of multiHTTPClientInstanceNo." .. tostring(multiHTTPClientNo) .. " to value = " .. tostring(value))
      end      
    else
      _G.logger:fine(nameOfModule .. ": Update parameter '" .. parameter .. "' of multiHTTPClientInstanceNo." .. tostring(multiHTTPClientNo))
    end

    if parameter == 'addRequest' then
      local values = helperFuncs.convertContainer2Table(value)
      addRequest(values)

    elseif parameter == 'updateRequest' then
      local values = helperFuncs.convertContainer2Table(value)
      updateRequest(value2, values)

    elseif parameter == 'removeRequest' then
      clearRequest(value)

    elseif parameter == 'sendRequest' then
      if processingParams.clientActivated then
        sendRequest(true, true)
      end

    elseif parameter == 'headerUpdate' then
      processingParams.headers[value] = value2

    elseif parameter == 'deleteHeader' then
      deleteHeader(value)

    elseif parameter == 'selectedRequest' then
      if value then
        selectedRequest = value
        setTempSpecificRequest(value)
      else
        selectedRequest = nil
      end

    elseif parameter == 'fullSetup' then
      local parameters = helperFuncs.convertContainer2Table(value)
      fullSetup(parameters)

    else
      processingParams[parameter] = value

      if parameter == 'clientActivated' then
        updateClient()
      end

      if parameter == 'queueSize' then
        setQueueSize()
      end
    end
  elseif parameter == 'activeInUI' then
    processingParams[parameter] = false
  end
end
Script.register("CSK_MultiHTTPClient.OnNewProcessingParameter", handleOnNewProcessingParameter)
