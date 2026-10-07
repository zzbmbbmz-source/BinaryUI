local Cleanup = {}
Cleanup.__index = Cleanup

function Cleanup.new()
    return setmetatable({_tasks={}, _destroyed=false}, Cleanup)
end

function Cleanup:Add(task)
    if self._destroyed then
        pcall(function() task() end)
        return task
    end
    table.insert(self._tasks, task)
    return task
end

function Cleanup:Destroy()
    if self._destroyed then return end
    self._destroyed=true
    for i=#self._tasks,1,-1 do
        local task=self._tasks[i]
        pcall(function()
            if type(task)=="function" then task()
            elseif task and task.Destroy then task:Destroy()
            elseif task and task.Disconnect then task:Disconnect() end
        end)
    end
    table.clear(self._tasks)
end

return Cleanup
