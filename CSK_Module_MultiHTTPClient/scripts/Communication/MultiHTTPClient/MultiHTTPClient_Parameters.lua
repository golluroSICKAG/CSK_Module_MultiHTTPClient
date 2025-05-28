---@diagnostic disable: redundant-parameter, undefined-global

--***************************************************************
-- Inside of this script, you will find the relevant parameters
-- for this module and its default values
--***************************************************************

local functions = {}

local function getParameters()
  local multiHTTPClientParameters = {}

  multiHTTPClientParameters.flowConfigPriority = CSK_FlowConfig ~= nil or false -- Status if FlowConfig should have priority for FlowConfig relevant configurations
  multiHTTPClientParameters.processingFile = 'CSK_MultiHTTPClient_Processing' -- which file to use for processing (will be started in own thread)
  multiHTTPClientParameters.clientActivated = false -- Set if HTTP client should be active
  multiHTTPClientParameters.interface = '' -- Interface to use for HTTP client (must be set individually)
  multiHTTPClientParameters.proxyEnabled = false -- Status if proxy is enabled
  multiHTTPClientParameters.proxyUsername = '' -- Username for proxy
  multiHTTPClientParameters.proxyPassword = '' -- Password for proxy
  multiHTTPClientParameters.proxyURL = '' -- Proxy URL
  multiHTTPClientParameters.proxyPort = 8080 -- Proxy port
  multiHTTPClientParameters.hostnameVerification = false -- Status if HTTP client should use hostname verification
  multiHTTPClientParameters.peerVerification = false -- Status if HTTP client should use peer verification
  multiHTTPClientParameters.cookieStore = '' -- File where the client’s cookies should be stored stored in 'public/CSK_HTTPClient/'

  multiHTTPClientParameters.basicAuthentication = false -- Status if HTTP basic authentication should be used
  multiHTTPClientParameters.basicAuthenticationUser = '' -- Username for HTTP basic authentication
  multiHTTPClientParameters.basicAuthenticationPassword = '' -- Password for HTTP basic authentication

  multiHTTPClientParameters.clientAuthentication = false -- Status if HTTP client authentification is enabled
  multiHTTPClientParameters.caBundleFileName = 'public/CSK_HTTPClient/CABundle_InstanceX.pem' -- Location of CA bundle file (must be set individually)
  multiHTTPClientParameters.clientCertificateActive = false -- Status if client authentication should be used 
  multiHTTPClientParameters.clientCertificateType = 'pem' -- Format of client certificate, like 'pem', 'der', 'pkcs#12'
  multiHTTPClientParameters.clientCertificateFileName = 'public/CSK_HTTPClient/ClientCertificate_InstanceX.' -- Location of client certification file (must be set individually)
  multiHTTPClientParameters.clientCertificateKeyType = 'pem' -- Format of client certificate, like 'pem', 'der'
  multiHTTPClientParameters.clientCertificateKeyFileName = 'public/CSK_HTTPClient/ClientCertificateKey_InstanceX.' -- Path to file containing the client’s private key (must be set individually)
  multiHTTPClientParameters.clientCertificateKeyPassphrase = '' -- Optional passphrase for the private key

  multiHTTPClientParameters.extendedResponse = false -- Status if reponse should include extended information like header keys, etc.
  multiHTTPClientParameters.verboseMode = false -- Status if HTTP client should run in verbose mode
  multiHTTPClientParameters.queueSize = 5 -- Size of max queue for requests before stopping to execute new requests

  multiHTTPClientParameters.requests = {} -- Table of requests to save
  --[[ Sample of request parameters:
  requestParameters = {
    requestName = ..., -- Name of request
    requestMode = ..., -- Mode of request
    requestEndpoint = ..., -- Endpoint URL of request
    requestPort = ..., -- Port of request
    requestContent = ..., -- Content of request (body payload)
    requestContentType = ..., -- Type of content
    requestPeriodic = ..., -- Status if request should be triggered periodically
    requestPeriod = ..., -- Cycle time for periodical request
    headers = {...}, -- Table of header keys + values
    registeredEvent = ... -- Event to register to execute request (optionally forwarding data of event via request content)
  }]]

  return multiHTTPClientParameters
end
functions.getParameters = getParameters

return functions