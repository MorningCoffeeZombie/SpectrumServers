SKIN = {}

function SKIN:PaintTab( panel )
	surface.SetDrawColor( Color(163, 163, 163, 60) );
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
end
derma.DefineSkin("managertab", "managetab", SKIN)