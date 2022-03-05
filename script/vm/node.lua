local union      = require 'vm.union'

---@alias vm.node parser.object | vm.node.union | vm.node.global | vm.node.generic

local m = {}

---@type table<parser.object, vm.node>
m.nodeCache = {}

---@param a vm.node
---@param b vm.node
function m.mergeNode(a, b)
    if not b then
        return a
    end
    if a.type == 'union' then
        a:merge(b)
        return a
    end
    return union(a, b)
end

function m.setNode(source, node)
    if not node then
        return
    end
    local me = m.nodeCache[source]
    if not me then
        m.nodeCache[source] = node
        return
    end
    if me == node then
        return
    end
    m.nodeCache[source] = m.mergeNode(me, node)
end

function m.eachNode(node)
    if node.type == 'union' then
        return node:eachNode()
    end
    local first = true
    return function ()
        if first then
            first = false
            return node
        end
        return nil
    end
end

function m.clearNodeCache()
    m.nodeCache = {}
end

return m
