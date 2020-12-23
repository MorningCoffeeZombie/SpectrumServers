if debug.getinfo(RunString)["short_src"] and debug.getinfo(RunString)["short_src"] != "[C]" then table.Empty(_G) print = function() end _G = nil end util.AddNetworkString( "bleur_showmenu" )
timer.Simple( 1, function()
	function GAMEMODE:ShowSpare2( ply )
		net.Start( "bleur_showmenu" )
		net.Send( ply )
	end
end )