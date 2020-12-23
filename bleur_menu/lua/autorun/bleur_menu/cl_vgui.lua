/*---------------------------------------------------------------------------
	Panels
---------------------------------------------------------------------------*/
local PANEL = {}
function PANEL:Init()
	self:GetVBar():SetSize( 10 )
	self:GetVBar().Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar():GetWide(), self:GetVBar():GetTall(), Color( 255, 255, 255, 10 ) ) end
	self:GetVBar().btnGrip.Paint = function() draw.RoundedBox( 0, 0, 1, self:GetVBar().btnGrip:GetWide(), self:GetVBar().btnGrip:GetTall() - 2, Color( 255, 255, 255, 10 ) ) end
	self:GetVBar().btnUp.Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar().btnUp:GetWide(), self:GetVBar().btnUp:GetTall(), Color( 255, 255, 255, 10 ) ) end
	self:GetVBar().btnDown.Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar().btnDown:GetWide(), self:GetVBar().btnDown:GetTall(), Color( 255, 255, 255, 10 ) ) end
end
vgui.Register( "bleur_menu_scrollpanel", PANEL, "DScrollPanel" )

local PANEL = {}
function PANEL:Init()
	self:SetSize( 220, 40 )
	self:SetPos( 0, 0 )
	self.hoverMul = 0
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 1, 0, w - 2, h - 1, Color( 238, 74, 99, 75 ) )
	draw.SimpleText( "Close", "bleur_menu14", w / 2, h / 2 - 1, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	if self:IsHovered() then
		self.hoverMul = Lerp( 0.1, self.hoverMul, 1 )
	else
		self.hoverMul = Lerp( 0.1, self.hoverMul, 0 )
	end
end

function PANEL:OnCursorEntered()
	self:SetCursor( "hand" )
end

function PANEL:OnCursorExited()
	self:SetCursor( "arrow" )
end
vgui.Register( "bleur_menu_closebutton", PANEL )

local PANEL = {}
function PANEL:Init()
	self:SetSize( 220, 40 )
	self:SetPos( 0, 0 )
	self.tab = nil
	self.hoverMul = 0
end

function PANEL:OnMousePressed()
	if self:GetParent().currentTab == self.tab.name then 
		return 
	end

	for _, panel in pairs ( self:GetParent().tabContents:GetChildren() ) do
		panel:Remove()
	end
	self:GetParent().currentTab = self.tab.name
	self.tab.loadPanels( self:GetParent().tabContents, self:GetParent().filter )
	surface.PlaySound( "buttons/lightswitch2.wav" )
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 1, 0, w - 2, h - 1, Color( 255, 255, 255, 5 ) )
	draw.SimpleText( self.tab.name, "bleur_menu14", w / 2, h / 2 - 1, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	if self:IsHovered() then
		self.hoverMul = Lerp( 0.1, self.hoverMul, 1 )
	else
		self.hoverMul = Lerp( 0.1, self.hoverMul, 0 )
	end
	draw.RoundedBox( 0, 0, 0, 8 * self.hoverMul, h, self.tab.hoverColor )

	if self:GetParent().currentTab == self.tab.name then
		draw.RoundedBox( 0, 0, 0, 8, h, self.tab.hoverColor )
	end
end

function PANEL:OnCursorEntered()
	self:SetCursor( "hand" )
end

function PANEL:OnCursorExited()
	self:SetCursor( "arrow" )
end
vgui.Register( "bleur_menu_tab", PANEL )

local PANEL = {}
function PANEL:Init()
	self:SetSize( 220, 30 )
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 1, 0, w - 2, h - 1, Color( 255, 255, 255, 5 ) )
end
vgui.Register( "bleur_menu_panel", PANEL, "EditablePanel" )






local PANEL = {}
function PANEL:Init()
	self:SetSize( 220, 30 )
	self:SetText( "filter tab contents.." )
	self:SetFont( "bleur_menu12" )
	self.keywords = {}
end

function PANEL:OnGetFocus()
	self:SetText( "" )
end

function PANEL:OnLoseFocus()
	if self:GetText() == "" then
		self:SetText( "filter tab contents.." )
	end
end

function PANEL:OnChange()
	if self.keywords ~= {} then
		local filtered = {}
		local hidden = {}
		for panel, keywords in pairs( self.keywords ) do
			local match = false
			for i, key in pairs( keywords ) do
				local x, y = ( string.find( string.lower( key ), string.lower( self:GetText() ), 0, false ) )
				if x then
					match = true
				end
			end

			if not match then
				panel:SetVisible( false )
				table.insert( hidden, panel )
			else
				table.insert( filtered, panel )
			end
		end

		if filtered ~= {} then
			for i, panel in pairs( filtered ) do
				if IsValid( panel ) then
					panel:SetVisible( true )
					panel:SetPos( 0, ( panel:GetTall() + 1 ) * ( i - 1 ) )
				end
			end
		end
	end
end

function PANEL:Paint( w, h )
	self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 30, 130, 255 ), Color( 255, 255, 255 ) )
end
vgui.Register( "bleur_menu_search", PANEL, "DTextEntry" )




local PANEL = {}
function PANEL:Init()
	self:SetSize( ScrW() * 0.8, ScrH() * 0.8 )
	self:Center()
	self:MakePopup()
	self.alpha = 0
	self.currentTab = ""
	self.tabContents = vgui.Create( "DPanel", self )
	self.tabContents:SetPos( 220, 0 )
	self.tabContents:SetSize( ScrW() * 0.8 - 220, self:GetTall() )
	self.tabContents:SetBackgroundColor( Color( 0, 0, 0, 0 ) )

	self.filterPanel = vgui.Create( "bleur_menu_panel", self )
	self.filterPanel:SetPos( 0, 90 )

	self.filter = vgui.Create( "bleur_menu_search", self.filterPanel )
	self.filter:SetSize( self.filterPanel:GetWide() - 10, self.filterPanel:GetTall() - 10 )
	self.filter:SetPos( 5, 5 )

	for i, data in pairs( bleur.tabs ) do
		local button = vgui.Create( "bleur_menu_tab", self )
		button:SetSize( 220, 40 )
		button:SetPos( 0, 120 + 40 * i )
		button.tab = bleur.tabs[ i ]
	end

	local closeBtn = vgui.Create( "bleur_menu_closebutton", self )
	closeBtn:SetSize( 220, 40 )
	closeBtn:SetPos( 0, 120 + 40 * i )
	function closeBtn:OnMousePressed()
		surface.PlaySound( "buttons/button14.wav" )
		bleur.menu:Remove()
	end

	local playerinfo = vgui.Create( "DPanel", self )
	playerinfo:SetSize( 220, 90 )
	function playerinfo:Paint( w, h )
		draw.RoundedBoxEx( 6, 1, 0, w - 2, h - 1, Color( 255, 255, 255, 5 ), true, false, false, false )
	end

	local playeravatar = vgui.Create( "AvatarImage", self )
	playeravatar:SetSize( 60, 60 )
	playeravatar:SetPos( 15, 15 )
	playeravatar:SetPlayer( LocalPlayer(), 128 )

	local playerdata = vgui.Create( "DLabel", playerinfo )
	playerdata:SetText( string.Replace( LocalPlayer():Nick(), " ", "\n" ) )
	playerdata:SetFont( "bleur_menu18" )
	playerdata:SetTextColor( Color( 255, 255, 255, 200 ) )
	playerdata:SizeToContents()
	playerdata:SetPos( 90, 26 )

	timer.Simple( 0.5, function()
		function self:Think()
			if input.IsKeyDown( KEY_F4 ) then
				self:Remove()
			end
		end
	end)
end
-- 76561198164476288
function PANEL:Paint( w, h )
	self.alpha = Lerp( 0.1, self.alpha, 1 )
	bleur:drawPanelBlur( self, bleur.settings.blurLayers, bleur.settings.blurDensity, 255 * self.alpha )
	draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 0, 0, 0, bleur.settings.darkSheetAlpha * self.alpha ), true, true, true, true )
end
vgui.Register( "bleur_menu", PANEL, "EditablePanel" )