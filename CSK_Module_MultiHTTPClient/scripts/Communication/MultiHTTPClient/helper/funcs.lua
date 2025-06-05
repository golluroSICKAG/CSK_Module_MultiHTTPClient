---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find helper functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

local nameOfModule = 'CSK_MultiHTTPClient'

local funcs = {}
-- Providing standard JSON functions
funcs.json = require('Communication/MultiHTTPClient/helper/Json')
-- Default parameters for instances of module
funcs.defaultParameters = require('Communication/MultiHTTPClient/MultiHTTPClient_Parameters')

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to create a deep copy of a table
---@param origTable auto[] Content to copy
---@return auto[] res Clone of table
local function copy(origTable)
  if type(origTable) ~= 'table' then
    return origTable
  end

  local s = {}
  local res = setmetatable({}, getmetatable(origTable))
  s[origTable] = res
  for k, v in pairs(origTable) do
    res[copy(k, s)] = copy(v, s)
  end
  return res
end
funcs.copy = copy

--- Function to get size of table
---@param content auto[] Content
---@return int size Size of table
local function getTableSize(content)
  local count = 0
  for _ in pairs(content) do
    count = count + 1
  end
  return count
end
funcs.getTableSize = getTableSize

--- Function to create a list with numbers
---@param size int Size of the list
---@return string list List of numbers
local function createStringListBySize(size)
  local list = "["
  if size >= 1 then
    list = list .. '"' .. tostring(1) .. '"'
  end
  if size >= 2 then
    for i=2, size do
      list = list .. ', ' .. '"' .. tostring(i) .. '"'
    end
  end
  list = list .. "]"
  return list
end
funcs.createStringListBySize = createStringListBySize

--- Function to convert a table into a Container object
---@param content auto[] Lua Table to convert to Container
---@return Container cont Created Container
local function convertTable2Container(content)
  local cont = Container.create()
  for key, value in pairs(content) do
    if type(value) == 'table' then
      cont:add(key, convertTable2Container(value), nil)
    else
      cont:add(key, value, nil)
    end
  end
  return cont
end
funcs.convertTable2Container = convertTable2Container

--- Function to convert a Container into a table
---@param cont Container Container to convert to Lua table
---@return auto[] data Created Lua table
local function convertContainer2Table(cont)
  local data = {}
  local containerList = Container.list(cont)
  local containerCheck = false
  if tonumber(containerList[1]) then
    containerCheck = true
  end
  for i=1, #containerList do

    local subContainer

    if containerCheck then
      subContainer = Container.get(cont, tostring(i) .. '.00')
    else
      subContainer = Container.get(cont, containerList[i])
    end
    if type(subContainer) == 'userdata' then
      if Object.getType(subContainer) == "Container" then

        if containerCheck then
          table.insert(data, convertContainer2Table(subContainer))
        else
          data[containerList[i]] = convertContainer2Table(subContainer)
        end

      else
        if containerCheck then
          table.insert(data, subContainer)
        else
          data[containerList[i]] = subContainer
        end
      end
    else
      if containerCheck then
        table.insert(data, subContainer)
      else
        data[containerList[i]] = subContainer
      end
    end
  end
  return data
end
funcs.convertContainer2Table = convertContainer2Table

--- Function to get content list out of table
---@param data string[] Table with data entries
---@return string sortedTable Sorted entries as string, internally seperated by ','
local function createContentList(data)
  local sortedTable = {}
  for key, _ in pairs(data) do
    table.insert(sortedTable, key)
  end
  table.sort(sortedTable)
  return table.concat(sortedTable, ',')
end
funcs.createContentList = createContentList

--- Function to get content list as JSON string
---@param data string[] Table with data entries
---@return string sortedTable Sorted entries as JSON string
local function createJsonList(data)
  local sortedTable = {}
  for key, _ in pairs(data) do
    table.insert(sortedTable, key)
  end
  table.sort(sortedTable)
  return funcs.json.encode(sortedTable)
end
funcs.createJsonList = createJsonList

--- Function to create a list from table
---@param content string[] Table with data entries
---@return string list String list
local function createStringListBySimpleTable(content)
  local list = "["
  if #content >= 1 then
    list = list .. '"' .. content[1] .. '"'
  end
  if #content >= 2 then
    for i=2, #content do
      list = list .. ', ' .. '"' .. content[i] .. '"'
    end
  end
  list = list .. "]"
  return list
end
funcs.createStringListBySimpleTable = createStringListBySimpleTable

-- Function to create a string list for dropdown menu from list of strings
local function createStringListFromList(list)
  local stringList = "["
  local first = true
  for _, entity in ipairs(list) do
    if not first then
      stringList = stringList .. ", "
    end
    first = false
    stringList = stringList .. '"' .. entity .. '"'
  end
  stringList = stringList .. "]"
  return stringList
end
funcs.createStringListFromList = createStringListFromList

local function addTabs(str, tab)
  if tab > 0 then
    for _=1, tab do
      str = '\t' .. str
    end
  end
  return str
end
local function min(arr)
  if #arr == 0 then
    return nil
  end
  table.sort(arr)
  return arr[1]
end

local function jsonLine2Table(intiStr, startInd, tab, resStr)
  if not intiStr then return '' end
  if not startInd then startInd = 1 end
  if not tab then tab = 0 end
  if not resStr then resStr = '' end
  local compArray = {}
  local nextSqBrOp = string.find(intiStr, '%[', startInd)
  if nextSqBrOp then table.insert(compArray, nextSqBrOp) end
  local nextSqBrCl = string.find(intiStr, '%]', startInd)
  if nextSqBrCl then table.insert(compArray, nextSqBrCl) end
  local nextCuBrCl = string.find(intiStr, '}', startInd)
  if nextCuBrCl then table.insert(compArray, nextCuBrCl) end
  local nextCuBrOp = string.find(intiStr, '{', startInd)
  if nextCuBrOp then table.insert(compArray, nextCuBrOp) end
  local nextComma = string.find(intiStr, ',', startInd)
  if nextComma then table.insert(compArray, nextComma) end
  local minVal = min(compArray)
  if minVal then
    local currentSymbol = string.sub(intiStr, minVal, minVal)
    local content = ''
    if startInd < minVal then
      content = string.sub(intiStr, startInd, minVal-1)
    end
    if minVal == nextCuBrOp or minVal == nextSqBrOp then
      resStr = resStr .. addTabs(content .. currentSymbol .. '\n', tab)
      tab = tab + 1

    elseif minVal == nextCuBrCl or minVal == nextSqBrCl then
      resStr = resStr .. addTabs(content, tab) .. '\n' 
      tab = tab - 1
      resStr = resStr .. addTabs(currentSymbol, tab)
    elseif nextComma and minVal == nextComma then
      if content == '' then
        resStr = resStr.. currentSymbol .. '\n'
      else
        resStr = resStr .. addTabs(content .. currentSymbol .. '\n', tab)
      end
    end
    resStr = jsonLine2Table(intiStr, minVal+1, tab, resStr)
  end
  return resStr
end
funcs.jsonLine2Table = jsonLine2Table

--- Function to compare table content. Optionally will fill missing values within content table with values of defaultTable
---@param content auto Data to check
---@param defaultTable auto Reference data
---@return auto[] content Update of data
local function checkParameters(content, defaultTable)
  for key, value in pairs(defaultTable) do
    if type(value) == 'table' then
      if content[key] == nil then
        _G.logger:info(nameOfModule .. ": Created missing parameters table '" .. tostring(key) .. "'")
        content[key] = {}
      end
      content[key] = checkParameters(content[key], defaultTable[key])
    elseif content[key] == nil then
      _G.logger:info(nameOfModule .. ": Missing parameter '" .. tostring(key) .. "'. Adding default value '" .. tostring(defaultTable[key]) .. "'")
      content[key] = defaultTable[key]
    end
  end
  return content
end
funcs.checkParameters = checkParameters

return funcs

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************