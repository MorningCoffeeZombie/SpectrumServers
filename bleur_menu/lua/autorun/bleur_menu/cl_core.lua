surface.CreateFont( "bleur_menu18", {
	font = "Tahoma", 
	size = 18, 
	weight = 750, 
	antialias = true, 
	additive = true,
} )

surface.CreateFont( "bleur_menu16", {
	font = "Tahoma", 
	size = 16, 
	weight = 750, 
	antialias = true, 
	additive = true,
} )

surface.CreateFont( "bleur_menu14", {
	font = "Tahoma", 
	size = 14, 
	weight = 750, 
	antialias = true, 
	additive = true,
} )

surface.CreateFont( "bleur_menu14thin", {
	font = "Tahoma", 
	size = 14, 
	weight = 250, 
	antialias = true, 
	additive = true,
} )

surface.CreateFont( "bleur_menu12", {
	font = "Tahoma", 
	size = 12, 
	weight = 250, 
	antialias = true, 
	additive = true,
} )

function bleur:drawCircle( x, y, radius, smoothness, color )
	local circle = {}
	for i = 0, 360, smoothness do
		circle[ #circle + 1 ] = 
		{ 
			x = x + math.sin( -math.rad( i ) ) * radius,
			y = y + math.cos( -math.rad( i ) ) * radius,
		}
	end
	draw.NoTexture()
	surface.SetDrawColor( color )
	surface.DrawPoly( circle )
end

local blur = Material( "pp/blurscreen" )
function bleur:drawBlur( x, y, w, h, layers, density, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

function bleur:drawPanelBlur( panel, layers, density, alpha )
	local x, y = panel:LocalToScreen( 0, 0 )

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

function bleur:drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end

function bleur:show()
	--Load player saved settings
	if file.Exists( "bleur_settings.txt", "DATA" ) then
		bleur.settings = util.JSONToTable( file.Read( "bleur_settings.txt", "DATA" ) )
	end
	bleur.menu = vgui.Create( "bleur_menu" ) 
end
net.Receive( "bleur_showmenu", function()
	bleur:show()
end )

timer.Simple( 1, function()
	function GAMEMODE:ShowSpare2( ply )
	end
end )