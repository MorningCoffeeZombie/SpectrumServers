bleur = {}
if SERVER then
	for _, f in pairs( file.Find( "materials/bleur_menu/*.png", "GAME" ) ) do
		resource.AddFile( "materials/bleur_menu/" .. f )
	end

	AddCSLuaFile( "bleur_menu/cl_config.lua" )
	AddCSLuaFile( "bleur_menu/cl_core.lua" )
	AddCSLuaFile( "bleur_menu/cl_vgui.lua" )
	AddCSLuaFile( "bleur_menu/cl_tabs.lua" )
	AddCSLuaFile( "bleur_menu/cl_categorisedjobs.lua" )

	include( "bleur_menu/sv_core.lua" )
end

if CLIENT then
	include( "bleur_menu/cl_config.lua" )
	include( "bleur_menu/cl_core.lua" )
	include( "bleur_menu/cl_vgui.lua" )
	include( "bleur_menu/cl_tabs.lua" )
	include( "bleur_menu/cl_categorisedjobs.lua" )
end