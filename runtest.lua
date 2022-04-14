-- Run tests

require "test.utils"

local testbenches = require "test.benches"
local testbenchresults = {}

local function newResultsTable(name)
    return {
        name = name,
        passedcnt = 0,
        failedcnt = 0,
        totalcnt = 0,
    }
end

local testbenchtotalresults = newResultsTable("Total")

-- sums r1 and r2 counts into r1
local function sumResultsCounts(r1, r2)
    for _, field in pairs{"passed", "failed", "total"} do
        field = field .. "cnt"
        r1[field] = r1[field] + r2[field]
    end
end

local function pcallMethod(testfunction, testbench)
    local testmethod = function() return testfunction(testbench) end
    return xpcall(testmethod, debug.traceback)
end

local LINEW = 80

local function printTestResultMessage(testbenchname, testname, message)
    local n = math.max(0, LINEW - 2 - testbenchname:len() - testname:len() - message:len())
    print(string.format("%s.%s%s %s", testbenchname, testname, string.rep(".", n), message))
end

for testbenchindex, testbenchname in ipairs(testbenches) do
    local testbench = require(testbenchname)
    local testbenchresult = newResultsTable(testbenchname)
    for testname, testfunction in pairs(testbench) do
        local ok, err = pcallMethod(testfunction, testbench)
        local testresult = {name = testname, ok = ok, err = err}
        if ok then
            printTestResultMessage(testbenchname, testname, "PASS")
            testbenchresult.passedcnt = testbenchresult.passedcnt + 1
        else
            printTestResultMessage(testbenchname, testname, "FAIL")
            testbenchresult.failedcnt = testbenchresult.failedcnt + 1
        end
        testbenchresult.totalcnt = testbenchresult.totalcnt + 1
        testbenchresult[#testbenchresult + 1] = testresult
    end
    testbenchresults[testbenchindex] = testbenchresult
    sumResultsCounts(testbenchtotalresults, testbenchresult)
end

print()

local NCOLUMNS = 4
local COLUMNW = math.floor((LINEW - 3 * (NCOLUMNS - 1)) / NCOLUMNS)
local MCOLUMNW = LINEW - 3 * (NCOLUMNS - 1) - 3 * COLUMNW
local COLUMNS = {}

if NCOLUMNS > 1 then
    COLUMNS[1] = MCOLUMNW
    for i = 2, NCOLUMNS do
        COLUMNS[i] = COLUMNW
    end
end

local function printTableRow(...)
    local fmt = string.format('%%-%ds | %%-%ds | %%-%ds | %%-%ds', table.unpack(COLUMNS))
    print(string.format(fmt, ...))
end

local function printTableRowFromResults(results)
    printTableRow(results.name,
                  results.passedcnt,
                  results.failedcnt,
                  results.totalcnt)
end

local function printTableLine()
    local t = {}
    for i, col in ipairs(COLUMNS) do
        t[i] = string.rep("-", col)
    end
    printTableRow(table.unpack(t))
end

printTableLine()
printTableRow("Testbench", "Passed", "Failed", "Total")
printTableLine()
for testbenchindex, testbenchresult in ipairs(testbenchresults) do
    printTableRowFromResults(testbenchresult)
    printTableLine()
end
printTableRowFromResults(testbenchtotalresults)
printTableLine()

local function printDetailsHeader(testbenchname, testname)
    local n = math.max(0, LINEW - 3 - testbenchname:len() - testname:len())
    local left = math.floor(n/2)
    local right = n - left
    print(string.format("%s %s.%s %s", string.rep("=", left),
                                       testbenchname,
                                       testname,
                                       string.rep("=", right)))
end

for testbenchindex, testbenchresult in ipairs(testbenchresults) do
    for testindex, testresult in ipairs(testbenchresult) do
        if not testresult.ok then
            print()
            printDetailsHeader(testbenchresult.name, testresult.name)
            print()
            print(testresult.err)
        end
    end
end

-- Exit with error code 1 if there is a test fails
for testbenchindex, testbenchresult in ipairs(testbenchresults) do
    for testindex, testresult in ipairs(testbenchresult) do
        if not testresult.ok then
            os.exit(1)
        end
    end
end
