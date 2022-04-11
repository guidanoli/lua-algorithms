-- Run tests

local testbenches = require "testbenches"
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

print('> Running tests')
print()

-- sums r1 and r2 counts into r1
local function sumResultsCounts(r1, r2)
    for _, field in pairs{'passed', 'failed', 'total'} do
        field = field .. 'cnt'
        r1[field] = r1[field] + r2[field]
    end
end

local function pcallMethod(testfunction, testbench)
    local testmethod = function() return testfunction(testbench) end
    return xpcall(testmethod, debug.traceback)
end

for testbenchindex, testbenchname in ipairs(testbenches) do
    local testbench = require(testbenchname)
    local testbenchresult = newResultsTable(testbenchname)
    for testname, testfunction in pairs(testbench) do
        local ok, err = pcallMethod(testfunction, testbench)
        local testresult = {name = testname, ok = ok, err = err}
        if ok then
            print(string.format('%s.%-20s | PASS', testbenchname, testname))
            testbenchresult.passedcnt = testbenchresult.passedcnt + 1
        else
            print(string.format('%s.%-20s | FAIL', testbenchname, testname))
            testbenchresult.failedcnt = testbenchresult.failedcnt + 1
        end
        testbenchresult.totalcnt = testbenchresult.totalcnt + 1
        testbenchresult[#testbenchresult + 1] = testresult
    end
    testbenchresults[testbenchindex] = testbenchresult
    sumResultsCounts(testbenchtotalresults, testbenchresult)
end

print()
print('> Printing summary')
print()

local function printTableRow(...)
    print(string.format('%-20s | %-20s | %-20s | %-20s', ...))
end

local function printTableRowFromResults(results)
    printTableRow(results.name,
                  results.passedcnt,
                  results.failedcnt,
                  results.totalcnt)
end

local function printTableLine()
    local t = {}
    for i = 1, 4 do
        t[i] = string.rep('-', 20)
    end
    printTableRow(table.unpack(t))
end

printTableRow('Testbench', 'Passed', 'Failed', 'Total')
printTableLine()
for testbenchindex, testbenchresult in ipairs(testbenchresults) do
    printTableRowFromResults(testbenchresult)
    printTableLine()
end
printTableRowFromResults(testbenchtotalresults)

print()
print('> Printing errors')
print()

local function printDetailsHeader(testbenchname, testname)
    local n = math.max(0, 80 - testbenchname:len() - testname:len())
    local left = math.floor(n/2)
    local right = n - left
    print(string.format('%s %s.%s %s', string.rep('=', left),
                                       testbenchname,
                                       testname,
                                       string.rep('=', right)))
end

for testbenchindex, testbenchresult in ipairs(testbenchresults) do
    for testindex, testresult in ipairs(testbenchresult) do
        if not testresult.ok then
            printDetailsHeader(testbenchresult.name, testresult.name)
            print()
            print(testresult.err)
            print()
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
