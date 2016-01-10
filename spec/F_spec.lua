describe("string interpolation", function()
	local F = require "F"
	local assert = assert
	it("works in all sorts of scoping", function()
		assert.same("foo", F'{"foo"}')
		do
			local x = "foo"
			assert.same("foo", F'{x}')
		end
		do
			local x = "foo"
			(function()
				assert.same("foo", F'{x}')
			end)()
		end
		do
			(function()
				local x = "foo"
				return function()
					assert.same("foo", F'{x}')
				end
			end)()()
		end
	end);
	(_VERSION == "Lua 5.1" and it or pending)("works with setfenv'd functions", function()
		setfenv(1, {x = "foo"})
		assert.same("foo", x)
		assert.same("foo", F'{x}')
	end);
	(_VERSION == "Lua 5.1" and pending or it)("works with _ENV scopes", function()
		do
			local _ENV = {x = "foo"}
			assert.same("foo", F'{x}')
		end
		do
			local _ENV = {x = "foo"}
			(function()
				assert.same("foo", F'{x}')
			end)()
		end
		do
			(function()
				local _ENV = {x = "foo"}
				return function()
					assert.same("foo", F'{x}')
				end
			end)()()
		end
		do
			(function()
				local _ENV = {x = "foo"}
				return function()
					assert.same("foo", x) -- reference the upvalue
					assert.same("foo", F'{x}')
				end
			end)()()
		end
	end)
end)
