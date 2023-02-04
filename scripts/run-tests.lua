local Root = script.Parent.SignalTest
local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)

local Packages = Root.Packages
if not Packages then
	game:GetService("TestService"):Error("Invalid Package configuration. Try running `rotrieve install` to remedy.")
	ProcessService:ExitAsync(1)
end

local runCLI = require(Packages.Dev.Jest).runCLI

local status, result = runCLI(Packages.Signal, {}, { Packages.Signal }):awaitStatus()

if status == "Rejected" then
	print(result)
end

if status == "Resolved" and result.results.numFailedTestSuites == 0 and result.results.numFailedTests == 0 then
	if processServiceExists then
		ProcessService:ExitAsync(0)
	end
end

if processServiceExists then
	ProcessService:ExitAsync(1)
end
