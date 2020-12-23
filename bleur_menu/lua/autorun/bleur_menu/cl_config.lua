bleur.config = {}
bleur.settings = {}
bleur.lang = {}
bleur.commands = {}
/*---------------------------------------------------------------------------
	User settings - Only defaults!
	Do not change these, these are what makes it look good and subtle!
---------------------------------------------------------------------------*/
bleur.settings.blurLayers = 6
bleur.settings.blurDensity = 12
bleur.settings.darkSheetAlpha = 150
/*---------------------------------------------------------------------------
	Config
---------------------------------------------------------------------------*/
bleur.config.webpage = "https://www.youtube.com/channel/UCeb3Q-CDO1usrGwvenqN2qg"
--Define admin ranks to show in 'Staff Online'
bleur.config.adminRanks = {}
bleur.config.adminRanks[ "superadmin" ] = "Главный админ"
bleur.config.adminRanks[ "admin" ] = "Админ"
bleur.config.adminRanks[ "moderator" ] = "Модератор"
--Define what stats are shown in the 'Game Info'
bleur.config.stats = {}
bleur.config.stats[ "Название:" ] = function() return GetHostName() end
bleur.config.stats[ "Игроки:" ] = function() return #player.GetAll() .. " / " .. game.MaxPlayers() end
bleur.config.stats[ "Карта:" ] = function() return game.GetMap() end
bleur.config.stats[ "Играет: " ] = function() return os.date( "%H:%M:%S", RealTime() ) end
bleur.config.stats[ "Пропы: " ] = function() return #ents.FindByClass( "prop_physics" ) end
--Categories
bleur.config.useCategorisedJobs = true
/*---------------------------------------------------------------------------
	Lang, don't modify it - it's useless, only for setting translation
---------------------------------------------------------------------------*/
bleur.lang.blurLayers = "Цвет (Стандарт: 6)"
bleur.lang.blurDensity = "Цвет (Стандарт: 12)"
bleur.lang.darkSheetAlpha = "Цвет (Стандарт: 150)"
/*---------------------------------------------------------------------------
	Materials
---------------------------------------------------------------------------*/
bleur.materials = {}
bleur.materials[ "job" ] = Material( "bleur_menu/job.png" )
bleur.materials[ "salary" ] = Material( "bleur_menu/salary.png" )
bleur.materials[ "weapons" ] = Material( "bleur_menu/weapons.png" )
bleur.materials[ "voteOnly" ] = Material( "bleur_menu/voteonly.png" )
bleur.materials[ "gunLicense" ] = Material( "bleur_menu/license.png" )
bleur.materials[ "jobsOccupied" ] = Material( "bleur_menu/jobsoccupied.png" )
bleur.materials[ "man" ] = Material( "bleur_menu/man.png" )
bleur.materials[ "name" ] = Material( "bleur_menu/name.png" )
bleur.materials[ "category" ] = Material( "bleur_menu/category.png" )
/*---------------------------------------------------------------------------
	Commands
	cmd			- cmd to run
	text		- text over button
	prompt		- what messages should show up if arguments are needed
	restrict 	- who should be able to see it
---------------------------------------------------------------------------*/
bleur.commands[ 1 ] = 
{
	cmd = "advert",
	text = "Реклама",
	prompt = { "Пишите рекламу" },
}

bleur.commands[ 2 ] = 
{
	cmd	= "wanted",
	text = "Розыск(для ареста)",
	prompt = { "Выбери игрока", "Причина" },
	restrict = function( ply ) return ply:Team() == TEAM_CP or ply:Team() == TEAM_CHIEF end,
}

bleur.commands[ 3 ] = 
{
	cmd	= "removeletters",
	text = "Удалить все свои письма",
}

bleur.commands[ 4 ] = 
{
	cmd	= "unownalldoors",
	text = "Продать все двери",
}

bleur.commands[ 5 ] = 
{
	cmd	= "lockdown",
	text = "Начать ком.час",
	restrict = function( ply ) return ply:Team() == TEAM_MAYOR end,
}

bleur.commands[ 6 ] = 
{
	cmd	= "resetlaws",
	text = "Сбросить законы",
	restrict = function( ply ) return ply:Team() == TEAM_MAYOR end,
}

bleur.commands[ 7 ] = 
{
	cmd = "addowner",
	text = "Добавить жильца в дверь(смотри на дверь)",
	prompt = { "Добавить жильца" }
}
--sort it by commands
table.sort( bleur.commands, function( a, b ) return a.cmd < b.cmd end )