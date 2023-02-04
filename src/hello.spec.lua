return function()
	local hello = require(script.Parent.hello)

	it("should issue a greeting", function()
		local greeting = hello()

		local helloString = greeting:find("Hello")
		expect(helloString).to.be.ok()

		local nameString = greeting:find("Signal")
		expect(nameString).to.be.ok()
	end)
end