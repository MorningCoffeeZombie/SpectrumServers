surface.CreateFont( "TitlesFont", {
	font = "Roboto Th",
	size = 36,
	weight = 400,
	antialias = true
} )

local PANEL = {}

function PANEL:Init()
	self:SetPos( 0, 28 )
	self:SetSize( 800, 480 )
end

function PANEL:Paint()
	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,0 ) )
end

function PANEL:Title( text )
	self.Title = vgui.Create("DLabel", self)
	self.Title:SetText( text )
	self.Title:SetFont( "TitlesFont" )
	self.Title:SetPos( 300, 18 )
	self.Title:SizeToContents()
	self.Title:SetColor(Color(255, 255, 255))
end
derma.DefineControl("DCustomPanel", "Custom Panel", PANEL, "DPanel")