/*---------------------------------------------------------------------------
	bleur.tabs
---------------------------------------------------------------------------*/
bleur.tabs = {}
bleur.tabs[ 0 ] = { name = "Работы", hoverColor = Color( 80, 201, 198 ), loadPanels = function( parent, filter )
	local scrollPanel = vgui.Create( "bleur_menu_scrollpanel", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )

	filter.keywords = {}
	for i, data in pairs( RPExtraTeams ) do
		local job = vgui.Create( "DPanel", scrollPanel )
		job:SetSize( scrollPanel:GetWide(), 60 )
		job:SetPos( 0, 0 + ( 61 * ( i - 1 ) ) )
		job.hoverMul = 0

		filter.keywords[ job ] = { data.name, data.command, data.category }

		function job:OnMousePressed()
			if type( data.model ) == "table" and table.Count( data.model ) > 1 then
				local modelSelect = vgui.Create( "DPanel" )
				modelSelect:SetSize( 10 + #data.model * 52, 60 )
				modelSelect:Center()
				modelSelect:MakePopup()
				modelSelect.alpha = 0

				function modelSelect:Paint( w, h )
					self.alpha = Lerp( 0.1, self.alpha, 1 )
					bleur:drawPanelBlur( self, bleur.settings.blurLayers, bleur.settings.blurDensity, 255 * self.alpha )
					draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 0, 0, 0, bleur.settings.darkSheetAlpha * self.alpha ), true, true, true, true )
					draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
					for n = 1, #data.model do
						draw.RoundedBox( 0, 5 + ( n - 1 ) * 52, 5, 50, 50, Color( 255, 255, 255, 5 ) )
					end
				end

				for j, mdl in pairs( data.model ) do
					local model = vgui.Create( "DModelPanel", modelSelect )
					model:SetSize( 50, 50 )
					model:SetPos( 5 + ( j - 1 ) * 52, 5 )
					model:SetModel( mdl )
					model:SetFOV( 45 )
					model:SetCamPos( Vector( 20, 15, 64 ) )
					model:SetLookAt( Vector( 0, 0, 64 ) )
					function model:LayoutEntity() 
						return false 
					end

					function model:OnMousePressed()
						DarkRP.setPreferredJobModel( i, mdl )
						modelSelect:Remove()

						timer.Simple( 0.25, function()
							if data.vote then
								RunConsoleCommand( "say", "/vote" .. data.command )
							else
								RunConsoleCommand( "say", "/" .. data.command )
							end
						end )
					end
				end
			else
				timer.Simple( 0.25, function()
					if data.vote then
						RunConsoleCommand( "say", "/vote" .. data.command )
					else
						RunConsoleCommand( "say", "/" .. data.command )
					end
				end )
			end
			bleur.menu:Remove()
		end

		function job:OnCursorEntered()
			self:SetCursor( "hand" )
		end

		function job:OnCursorExited()
			self:SetCursor( "arrow" )
		end

		function job:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			draw.RoundedBox( 0, 5, 5, 50, 50, Color( 255, 255, 255, 5 ) )
			surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
			surface.SetMaterial( bleur.materials.job )
			surface.DrawTexturedRect( 60, 9, 16, 16 )
			surface.SetMaterial( bleur.materials.salary )
			surface.DrawTexturedRect( 60, 35, 16, 16 )

			if data.max > 0 then
				surface.SetMaterial( bleur.materials.jobsOccupied )
				surface.DrawTexturedRect( 120, 35, 16, 16 )

				for j = 1, data.max do
					surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
					if j <= team.NumPlayers( i ) then
						surface.SetDrawColor( Color( 255, 255, 255, 200 ) )
					end
					surface.SetMaterial( bleur.materials.man )
					surface.DrawTexturedRect( 120 + ( 18 * j ), 35, 16, 16 )
				end
			end
			draw.SimpleText( data.name, "bleur_menu16", 80, 9, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "$" .. data.salary, "bleur_menu16", 80, 35, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			if self:IsHovered() then
				self.hoverMul = Lerp( 0.1, self.hoverMul, 1 )
			else
				self.hoverMul = Lerp( 0.1, self.hoverMul, 0 )
			end
			draw.RoundedBox( 0, 0, 0, 5 * self.hoverMul, h, Color( data.color.r, data.color.g, data.color.b, 255 ) )
		end

		local model = vgui.Create( "DModelPanel", job )
		model:SetSize( 50, 50 )
		model:SetPos( 5, 5 )
		model:SetFOV( 45 )
		model:SetCamPos( Vector( 20, 15, 64 ) )
		model:SetLookAt( Vector( 0, 0, 64 ) )
		local text = string.Replace( data.description, "\t", "" )
		if #data.weapons > 0 then
			text = text .. "\n\nWeapons: " .. string.Implode( ", ", data.weapons )
		end
		model:SetTooltip( text )
		if type( data.model ) == "string" then
			model:SetModel( data.model )
		else
			model:SetModel( table.Random( data.model ) )
		end
		function model:LayoutEntity() 
			return false 
		end

		local icons = 0
		if #data.weapons > 0 then
			local icon = vgui.Create( "DImage", job )
			icon:SetSize( 32, 32 )
			icon:SetPos( job:GetWide() - 54 - ( 40 * icons ), job:GetTall() / 2 - 16 )
			icon:SetMaterial( bleur.materials.weapons )
			icon:SetImageColor( Color( 255, 255, 255, 25 ) )
			icons = icons + 1
		end
		if data.hasLicense then
			local icon = vgui.Create( "DImage", job )
			icon:SetSize( 32, 32 )
			icon:SetPos( job:GetWide() - 54 - ( 40 * icons ), job:GetTall() / 2 - 16 )
			icon:SetMaterial( bleur.materials.gunLicense )
			icon:SetImageColor( Color( 255, 255, 255, 25 ) )
			icons = icons + 1
		end
		if data.vote then
			local icon = vgui.Create( "DImage", job )
			icon:SetSize( 32, 32 )
			icon:SetPos( job:GetWide() - 54 - ( 40 * icons ), job:GetTall() / 2 - 16 )
			icon:SetMaterial( bleur.materials.voteOnly )
			icon:SetImageColor( Color( 255, 255, 255, 25 ) )
			icons = icons + 1
		end
	end
end }

bleur.tabs[ 1 ] = { name = "Cartridges", hoverColor = Color( 209, 81, 89 ), loadPanels = function( parent, filter )
	local scrollPanel = vgui.Create( "bleur_menu_scrollpanel", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )

	filter.keywords = {}

	for i, data in pairs ( GAMEMODE.AmmoTypes ) do
		local ammo = vgui.Create( "DPanel", scrollPanel )
		ammo:SetSize( scrollPanel:GetWide(), 100 )
		ammo:SetPos( 0, 0 + ( 101 * ( i - 1 ) ) )

		filter.keywords[ ammo ] = { data.name, data.ammoType }

		function ammo:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			draw.RoundedBox( 0, 5, 5, 90, 90, Color( 255, 255, 255, 5 ) )

			surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
			surface.SetMaterial( bleur.materials.name )
			surface.DrawTexturedRect( 100, 9, 16, 16 )

			surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
			surface.SetMaterial( bleur.materials.salary )
			surface.DrawTexturedRect( 100, 35, 16, 16 )

			draw.SimpleText( data.name .. " (" .. data.amountGiven .. ")", "bleur_menu16", 120, 9, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "$" .. data.price, "bleur_menu16", 120, 35, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		function ammo:OnCursorEntered()
			self:SetCursor( "hand" )
		end

		function ammo:OnCursorExited()
			self:SetCursor( "arrow" )
		end

		function ammo:OnMousePressed()
			RunConsoleCommand( "say", "/buyammo " .. data.ammoType )
		end

		local model = vgui.Create( "DModelPanel", ammo )
		model:SetSize( 90, 90 )
		model:SetPos( 5, 5 )
		model:SetModel( data.model )

		local mn, mx = model.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
		size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
		size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
		model:SetFOV( 50 )
		model:SetCamPos( Vector( size, size, size ) )
		model:SetLookAt( ( mn + mx ) * 0.5 )


		function model:LayoutEntity() 
			return false 
		end
	end
end }

bleur.tabs[ 2 ] = { name = "Entity", hoverColor = Color( 236, 153, 23 ), loadPanels = function( parent, filter )
	local scrollPanel = vgui.Create( "bleur_menu_scrollpanel", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )

	filter.keywords = {}

	local allowed = {}
	for i, data in pairs ( DarkRPEntities ) do
		if not data.allowed or ( type( data.allowed) == "table" and table.HasValue( data.allowed, LocalPlayer():Team() ) ) then
			table.insert( allowed, data )
		end
	end

	for i, data in pairs ( allowed ) do
		local ent = vgui.Create( "DPanel", scrollPanel )
		ent:SetSize( scrollPanel:GetWide(), 100 )
		ent:SetPos( 0, 0 + ( 101 * ( i - 1 ) ) )

		filter.keywords[ ent ] = { data.name, data.category, data.cmd, data.ent }

		ent.price = data.price 
		if data.getPrice then
			ent.price = data.getPrice( LocalPlayer(), data.price )
		end

		function ent:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			draw.RoundedBox( 0, 5, 5, 90, 90, Color( 255, 255, 255, 5 ) )

			surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
			surface.SetMaterial( bleur.materials.name )
			surface.DrawTexturedRect( 100, 9, 16, 16 )
			surface.SetMaterial( bleur.materials.salary )
			surface.DrawTexturedRect( 100, 35, 16, 16 )
			surface.SetMaterial( bleur.materials.category )
			surface.DrawTexturedRect( 100, 61, 16, 16 )

			draw.SimpleText( data.name, "bleur_menu16", 120, 9, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "$" .. self.price, "bleur_menu16", 120, 35, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( data.category, "bleur_menu16", 120, 61, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		function ent:OnCursorEntered()
			self:SetCursor( "hand" )
		end

		function ent:OnCursorExited()
			self:SetCursor( "arrow" )
		end

		function ent:OnMousePressed()
			RunConsoleCommand( "say", "/" .. data.cmd )
		end

		local model = vgui.Create( "DModelPanel", ent )
		model:SetSize( 90, 90 )
		model:SetPos( 5, 5 )
		model:SetModel( data.model )

		local mn, mx = model.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
		size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
		size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
		model:SetFOV( 50 )
		model:SetCamPos( Vector( size, size, size ) )
		model:SetLookAt( ( mn + mx ) * 0.5 )

		function model:LayoutEntity() 
			return false 
		end
	end
end }

bleur.tabs[ 3 ] = { name = "Weapon", hoverColor = Color( 98, 83, 69 ), loadPanels = function( parent, filter )
	local scrollPanel = vgui.Create( "bleur_menu_scrollpanel", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )

	filter.keywords = {}

	local shipments = {}
	local singles = {}
	for i, data in pairs ( CustomShipments ) do
		if not data.allowed or ( type( data.allowed) == "table" and table.HasValue( data.allowed, LocalPlayer():Team() ) ) then
			if data.seperate then
				table.insert( singles, data )
			end
			if !data.noship then
				table.insert( shipments, data )
			end
		end
	end
	for i, data in pairs ( singles ) do
		local wep = vgui.Create( "DPanel", scrollPanel )
		wep:SetSize( scrollPanel:GetWide(), 100 )
		wep:SetPos( 0, 0 + ( 101 * ( i - 1 ) ) )

		filter.keywords[ wep ] = { data.name, data.category, data.entity }

		function wep:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			draw.RoundedBox( 0, 5, 5, 90, 90, Color( 255, 255, 255, 5 ) )

			surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
			surface.SetMaterial( bleur.materials.name )
			surface.DrawTexturedRect( 100, 9, 16, 16 )
			surface.SetMaterial( bleur.materials.salary )
			surface.DrawTexturedRect( 100, 35, 16, 16 )
			surface.SetMaterial( bleur.materials.category )
			surface.DrawTexturedRect( 100, 61, 16, 16 )

			draw.SimpleText( data.name .. " (Single)", "bleur_menu16", 120, 9, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "$" .. data.pricesep, "bleur_menu16", 120, 35, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( data.category, "bleur_menu16", 120, 61, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		function wep:OnCursorEntered()
			self:SetCursor( "hand" )
		end

		function wep:OnCursorExited()
			self:SetCursor( "arrow" )
		end

		function wep:OnMousePressed()
			RunConsoleCommand( "say", "/buy " .. data.name )
		end

		local model = vgui.Create( "DModelPanel", wep )
		model:SetSize( 90, 90 )
		model:SetPos( 5, 5 )
		model:SetModel( data.model )

		local mn, mx = model.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
		size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
		size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
		model:SetFOV( 50 )
		model:SetCamPos( Vector( size, size, size ) )
		model:SetLookAt( ( mn + mx ) * 0.5 )

		function model:LayoutEntity() 
			return false 
		end
	end
	for i, data in pairs ( shipments ) do
		local wep = vgui.Create( "DPanel", scrollPanel )
		wep:SetSize( scrollPanel:GetWide(), 100 )
		wep:SetPos( 0, 0 + ( 101 * ( i + #singles - 1 ) ) )

		filter.keywords[ wep ] = { data.name, data.category, data.entity }

		function wep:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			draw.RoundedBox( 0, 5, 5, 90, 90, Color( 255, 255, 255, 5 ) )

			surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
			surface.SetMaterial( bleur.materials.name )
			surface.DrawTexturedRect( 100, 9, 16, 16 )
			surface.SetMaterial( bleur.materials.salary )
			surface.DrawTexturedRect( 100, 35, 16, 16 )
			surface.SetMaterial( bleur.materials.category )
			surface.DrawTexturedRect( 100, 61, 16, 16 )

			draw.SimpleText( data.name .. " (Ящик)", "bleur_menu16", 120, 9, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "$" .. data.price, "bleur_menu16", 120, 35, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( data.category, "bleur_menu16", 120, 61, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end

		function wep:OnCursorEntered()
			self:SetCursor( "hand" )
		end

		function wep:OnCursorExited()
			self:SetCursor( "arrow" )
		end

		function wep:OnMousePressed()
			RunConsoleCommand( "say", "/buyshipment " .. data.name )
		end

		local model = vgui.Create( "DModelPanel", wep )
		model:SetSize( 90, 90 )
		model:SetPos( 5, 5 )
		model:SetModel( data.model )

		local mn, mx = model.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
		size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
		size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
		model:SetFOV( 50 )
		model:SetCamPos( Vector( size, size, size ) )
		model:SetLookAt( ( mn + mx ) * 0.5 )

		function model:LayoutEntity() 
			return false 
		end
	end
end }

bleur.tabs[ 4 ] = { name = "Website", hoverColor = Color( 145, 195, 83 ), loadPanels = function( parent )
	local html = vgui.Create( "HTML", parent )
	html:Dock( FILL )
	html:OpenURL( bleur.config.webpage )
end }

bleur.tabs[ 5 ] = { name = "Statistics",	hoverColor = Color( 47, 168, 235 ), loadPanels = function( parent )
	local richest = vgui.Create( "DPanel", parent )
	richest:SetSize( parent:GetWide() * 0.5, parent:GetTall() * 0.5 - 1 )
	richest:SetPos( 0, 0 )
	function richest:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
		draw.SimpleText( "Economy", "bleur_menu18", w / 2, 18, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local richestList = vgui.Create( "bleur_menu_scrollpanel", richest )
	richestList:SetSize( richest:GetWide() - 2, richest:GetTall() * 0.9 )
	richestList:SetPos( 1, 30 )

	local wealthiest = {}
	for _, p in pairs( player.GetAll() ) do
		if p.DarkRPVars then
			wealthiest[ #wealthiest + 1 ] = { ply = p, money = p.DarkRPVars.money }
		end
	end
	table.sort( wealthiest, function( a, b ) return a.money > b.money end )

	for i = 1, 10 do
		if wealthiest[ i ] then
			local richman = vgui.Create( "DPanel", richestList )
			richman:SetSize( richestList:GetWide(), 30 )
			richman:SetPos( 0, 0 + ( 31 * ( i - 1 ) ) )
			richman.data = {}
			richman.data.ply = wealthiest[ i ].ply
			richman.data.money = 0
			function richman:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
				draw.SimpleText( self.data.ply:Nick(), "bleur_menu14", 10, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( "$" .. self.data.money, "bleur_menu14", w - 20, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			function richman:Think()
				richman.data.money = math.floor( Lerp( 0.1, richman.data.money, wealthiest[ i ].money ) )
			end
		end
	end

	local jobChart = vgui.Create( "DPanel", parent )
	jobChart:SetSize( parent:GetWide() * 0.5 - 1, parent:GetTall() * 0.5 - 1 )
	jobChart:SetPos( parent:GetWide() * 0.5 + 1, 0 )
	function jobChart:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
		draw.SimpleText( "Work", "bleur_menu18", w / 2, 18, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local jobList = vgui.Create( "bleur_menu_scrollpanel", jobChart )
	jobList:SetSize( jobChart:GetWide() - 2, jobChart:GetTall() * 0.9 )
	jobList:SetPos( 1, 30 )

	local jobs = {}
	for i, data in pairs( RPExtraTeams ) do
		jobs[ #jobs + 1 ] = { name = data.name, players = team.NumPlayers( i ), color = data.color }
	end
	table.sort( jobs, function( a, b ) return a.players > b.players end )

	for i, data in pairs( jobs ) do
		local job = vgui.Create( "DPanel", jobList )
		job:SetSize( jobList:GetWide(), 30 )
		job:SetPos( 0, 0 + ( 31 * ( i - 1 ) ) )
		job.fill = 0
		function job:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			draw.RoundedBox( 0, 2, 2, job.fill, h - 4, Color( data.color.r, data.color.g, data.color.b, 200 ) )
			draw.SimpleText( data.name, "bleur_menu14", 10, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( data.players, "bleur_menu14", w - 20, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end
		function job:Think()
			job.fill = Lerp( 0.1, job.fill, ( job:GetWide() - 4 ) * ( data.players / #player.GetAll() ) )
		end
	end

	local gameStats = vgui.Create( "DPanel", parent )
	gameStats:SetSize( parent:GetWide() * 0.5, parent:GetTall() * 0.5 - 1 )
	gameStats:SetPos( 0, parent:GetTall() * 0.5 )
	function gameStats:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
		draw.SimpleText( "Information", "bleur_menu18", w / 2, 18, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local gameStatsList = vgui.Create( "bleur_menu_scrollpanel", gameStats )
	gameStatsList:SetSize( gameStats:GetWide() - 2, gameStats:GetTall() * 0.9 )
	gameStatsList:SetPos( 1, 30 )
	
	local i = 1
	for stat, data in pairs( bleur.config.stats ) do
		local gameStat = vgui.Create( "DPanel", gameStatsList )
		gameStat:SetSize( gameStatsList:GetWide(), 30 )
		gameStat:SetPos( 0, 0 + ( 31 * ( i - 1 ) ) )
		function gameStat:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			draw.SimpleText( stat, "bleur_menu14", 10, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( data(), "bleur_menu14", w - 20, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end
		i = i + 1
	end

	local staffOnline = vgui.Create( "DPanel", parent )
	staffOnline:SetSize( parent:GetWide() * 0.5 - 1, parent:GetTall() * 0.5 - 1 )
	staffOnline:SetPos( parent:GetWide() * 0.5 + 1, parent:GetTall() * 0.5 )
	function staffOnline:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
		draw.SimpleText( "Admins", "bleur_menu18", w / 2, 18, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local staffList = vgui.Create( "bleur_menu_scrollpanel", staffOnline )
	staffList:SetSize( staffOnline:GetWide() - 2, staffOnline:GetTall() * 0.9 )
	staffList:SetPos( 1, 30 )
	
	local staffOnlineList = {}
	for _, p in pairs( player.GetAll() ) do
		if bleur.config.adminRanks[ p:GetNWString( "usergroup" ) ] then
			table.insert( staffOnlineList, p )
		end
	end

	for i, p in pairs( staffOnlineList ) do
		local staff = vgui.Create( "DPanel", staffList )
		staff:SetSize( staffList:GetWide(), 30 )
		staff:SetPos( 0, 0 + ( 31 * ( i - 1 ) ) )
		function staff:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
			draw.SimpleText( p:Name(), "bleur_menu14", 10, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( bleur.config.adminRanks[ p:GetNWString( "usergroup" ) ], "bleur_menu14", w - 20, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end
	end
end }

bleur.tabs[ 6 ] = { name = "Settings", hoverColor = Color( 177, 54, 95 ), loadPanels = function( parent )
	local i = 0
	for var, val in pairs( bleur.settings ) do
		local setting = vgui.Create( "DLabel", parent )
		setting:SetPos( 10, 10 + ( i * 20 ) )
		setting:SetText( bleur.lang[ var ] )
		setting:SetFont( "bleur_menu18" )
		setting:SizeToContents()

		local changer = vgui.Create( "DTextEntry", parent )
		changer:SetSize( 50, 20 ) 
		changer:SetPos( parent:GetWide() - 60, 10 + ( i * 20 ) )
		changer:SetValue( val )
		changer:SetNumeric( true )
		changer.OnEnter = function()
			bleur.settings[ var ] = changer:GetValue()
			file.Write( "bleur_settings.txt", util.TableToJSON( bleur.settings ) )
		end
		i = i + 1
	end
end }

bleur.tabs[ 7 ] = { name = "Commands", hoverColor = Color( 108, 17, 207 ), loadPanels = function( parent )
	local r = 0
	for i, data in pairs( bleur.commands ) do
		if not data.restrict or data.restrict( LocalPlayer() ) then
			local cmd = vgui.Create( "EditablePanel", parent )
			cmd:SetSize( parent:GetWide(), 40 )
			cmd:SetPos( 0, r * 41 )
			cmd.hoverMul = 0
			function cmd:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w - 1, h, Color( 255, 255, 255, 5 ) )
				draw.SimpleText( data.text, "bleur_menu16", 10, 20, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( data.cmd, "bleur_menu16", w - 10, 20, Color( 255, 255, 255, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				if self:IsHovered() then
					self.hoverMul = Lerp( 0.1, self.hoverMul, 1 )
				else
					self.hoverMul = Lerp( 0.1, self.hoverMul, 0 )
				end
				draw.RoundedBox( 0, 0, 0, 10 * self.hoverMul, h, Color( 108, 17, 207 ) )
			end

			function cmd:OnCursorEntered()
				self:SetCursor( "hand" )
			end

			function cmd:OnCursorExited()
				self:SetCursor( "arrow" )
			end

			function cmd:OnMousePressed()
				bleur.menu:Remove()
				if not data.prompt then
					RunConsoleCommand( "say", "/" .. data.cmd )
				else
					local prompt = vgui.Create( "EditablePanel" )
					prompt:SetSize( ScrW() * 0.6, 20 + 60 * #data.prompt + 30 )
					prompt:Center()
					prompt:MakePopup()

					function prompt:Paint( w, h )
						bleur:drawPanelBlur( self, bleur.settings.blurLayers, bleur.settings.blurDensity, 255 )
						draw.RoundedBoxEx( 6, 0, 0, w, h, Color( 0, 0, 0, bleur.settings.darkSheetAlpha ), true, true, true, true )
						draw.RoundedBoxEx( 6, 1, 1, w - 2, h - 2, Color( 255, 255, 255, 5 ), true, true, true, true  )
						for i, text in pairs( data.prompt ) do
							draw.SimpleText( text, "bleur_menu16", w / 2, 20 + 60 * ( i - 1 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						end
					end

					local args = {}
					for i, text in pairs( data.prompt ) do
						local entry = vgui.Create( "DTextEntry", prompt )
						entry:SetSize( prompt:GetWide() * 0.9, 20 ) 
						entry:SetPos( prompt:GetWide() * 0.05, 40 + 60 * ( i - 1 ) )

						function entry:OnChange()
							args[ i ] = self:GetValue()
						end
					end

					local submit = vgui.Create( "DPanel", prompt )
					submit:SetSize( prompt:GetWide() * 0.9, 30 )
					submit:SetPos( prompt:GetWide() * 0.05, prompt:GetTall() - 40 )

					function submit:Paint( w, h )
						draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ), true, true, true, true  )
						draw.SimpleText( "SUBMIT", "bleur_menu16", w / 2, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end

					function submit:OnCursorEntered()
						self:SetCursor( "hand" )
					end

					function submit:OnCursorExited()
						self:SetCursor( "arrow" )
					end

					function submit:OnMousePressed()
						prompt:Remove()

						args = string.Implode( " ", args )
						RunConsoleCommand( "say", "/" .. data.cmd .. " " .. args )
					end
				end
			end
			r = r + 1
		end
	end
end }