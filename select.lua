-- Selection Algorithms

-----------------------
-- Define module
-----------------------

local Select = {}

-----------------------
-- Public functions
-----------------------

-- Selects minimum value in A
-- If A is empty, returns nil
-- Ignores NaN entirely
function Select:minimum(A)
    local min
    for _, a in ipairs(A) do
        if (a == a) and ((min == nil) or (a < min)) then
            min = a
        end
    end
    return min
end

-- Selects maximum value in A
-- If A is empty, returns nil
-- Ignores NaN entirely
function Select:maximum(A)
    local max
    for _, a in ipairs(A) do
        if (a == a) and ((max == nil) or (a > max)) then
            max = a
        end
    end
    return max
end

-- Partition A[p:r] using pivot at q
-- Modifies A and returns position of pivot (k)
-- If i < k, A[i] < A[k]
-- If i > k, A[i] >= A[k]
function Select:partition(A, p, q, r)
    local n = #A
    assert(1 <= p)
    assert(p <= q)
    assert(q <= r)
    assert(r <= n)
    local k = self:_partition(A, p, q, r)
    assert(p <= k)
    assert(k <= r)
    for i = p, k-1 do
        assert(A[i] < A[k], A[i])
    end
    for i = k+1, r do
        assert(A[i] >= A[k], A[i])
    end
    return k
end

-- Partition A[p:r] using random pivot
-- Modifies A and returns position of pivot
function Select:randomizedPartition(A, p, r)
    assert(1 <= p)
    assert(p <= r)
    return self:_randomizedPartition(A, p, r)
end

-- Get i-th smallest element of A[p:r]
function Select:randomizedSelect(A, p, r, i)
    assert(1 <= p)
    assert(p <= r)
    assert(1 <= i)
    assert(i <= (r - p + 1))
    local a = self:_randomizedSelect(A, p, r, i)
    -- assert(A[i] == a)
    return a
end

-----------------------
-- Private functions
-----------------------

function Select:_swap(A, i, j)
    A[i], A[j] = A[j], A[i]
end

-- function Select:_debugPartition(A, p, r, i, j)
--     local s = '{'
--     for k = p, r do
--         if k == i then
--             s = s .. '(i)'
--         end
--         if k == j then
--             s = s .. '(j)'
--         end
--         s = s .. A[k] .. (k == r and '' or ', ')
--     end
--     s = s .. '}'
--     return s
-- end

function Select:_partition(A, p, q, r)
    local pivot = A[q]
    -- print('pivot =', pivot)
    self:_swap(A, p, q)
    -- print('ini', self:_debugPartition(A, p, r, -1, -1))
    local i = p + 1
    for j = p + 1, r do
        -- print('loop', self:_debugPartition(A, p, r, i, j))
        if A[j] < pivot then
            self:_swap(A, i, j)
            i = i + 1
        end
    end
    -- print('after', self:_debugPartition(A, p, r, i, r))
    self:_swap(A, p, i - 1)
    -- print('end', self:_debugPartition(A, p, r, i, r))
    return i - 1
end

function Select:_randomizedPartition(A, p, r)
    local q = p + math.random(r - p + 1) - 1
    return self:partition(A, p, q, r)
end

function Select:_randomizedSelect(A, p, r, i)
    if p == r then
        return A[p]
    end
    local q = self:randomizedPartition(A, p, r)
    local k = q - p + 1
    if i == k then -- the pivot value is the answer
        return A[q]
    elseif i < k then
        return self:randomizedSelect(A, p, q - 1, i)
    else
        return self:randomizedSelect(A, q + 1, r, i - k)
    end
end

-----------------------
-- Return module
-----------------------

return Select
