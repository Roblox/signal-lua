local Root = script.Parent["SignalTest"]

local TestEZ = require(Root.Packages.Dev.TestEZ)

-- Run all tests, collect results, and report to stdout.
TestEZ.TestBootstrap:run(
	{ Root.Packages["Signal"] },
	TestEZ.Reporters.TextReporter
)
