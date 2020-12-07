
local M = {}

M.Undefined = hash("undefined")

M.Action_Touch = hash("touch")

M.MainMenu_Page_None = hash("nopage")
M.MainMenu_Page_Cyclist = hash("cyclistpage")
M.MainMenu_Page_Race = hash("racepage")


M.StageDefinition_ProfileFlat = hash("flat")
M.StageDefinition_ProfileHill = hash("hill")
M.StageDefinition_ProfileMountain = hash("mountain")

M.StageDefinition_WeatherSun = hash("sun")
M.StageDefinition_WeatherRain = hash("rain")
M.StageDefinition_WeatherWind = hash("wind")
M.StageDefinition_WeatherHeat = hash("heat")
M.StageDefinition_WeatherCold = hash("cold")

M.StageDefinition_TypeNormal = hash("normal")
M.StageDefinition_TypeCobble = hash("cobble")


M.StageStatus_Running = hash("running")
M.StageStatus_Stopped = hash("stopped")
M.StageStatus_PreInitialization = hash("preinit")


M.StageRoute_Empty = hash("empty")
M.StageRoute_Normal = hash("normal")
M.StageRoute_Feedzone = hash("feedzone")
M.StageRoute_Mountain1 = hash("mountain1")
M.StageRoute_Mountain2 = hash("mountain2")
M.StageRoute_Sprint1 = hash("sprint1")
M.StageRoute_Sprint2 = hash("sprint2")
M.StageRoute_FinalSprint1 = hash("finalsprint1")
M.StageRoute_FinalSprint2 = hash("finalsprint2")
M.StageRoute_FinalSprint3 = hash("finalsprint3")
M.StageRoute_FinalSprint4 = hash("finalsprint4")
M.StageRoute_FinalMountain1 = hash("finalmountain1")
M.StageRoute_FinalMountain2 = hash("finalmountain2")
M.StageRoute_FinalMountain3 = hash("finalmountain3")
M.StageRoute_FinalMountain4 = hash("finalmountain4")

M.CardPool_Grid = hash("grid")
M.CardPool_Handcard = hash("handcard")

M.CardType_None = hash("none")
M.CardType_Gain = hash("gain")
M.CardType_Loss = hash("loss")
M.CardType_DNF = hash("dnf")

M.StatType_None = hash("none")
M.StatType_Team = hash("teamsupport")
M.StatType_Energy = hash("energy")
M.StatType_Attack = hash("attack")
M.StatType_Any = hash("any")
M.StatType_AnyExceptTeam = hash("anyexecptteam")

M.CardClass_None = hash("none")
M.CardClass_Gel = hash("gel")
M.CardClass_Food = hash("food")
M.CardClass_Bidon = hash("bidon")
M.CardClass_TeamMate = hash("teammate")
M.CardClass_Crosswind = hash("crosswind")
M.CardClass_Wind = hash("wind")
M.CardClass_Rain = hash("rain")
M.CardClass_Cold = hash("cold")
M.CardClass_Snow = hash("snow")
M.CardClass_Heat = hash("heat")
M.CardClass_FlatTire = hash("flattire")
M.CardClass_Acceleration = hash("acceleration")
M.CardClass_Hill = hash("hill")
M.CardClass_Climb = hash("climb")
M.CardClass_Cobbles = hash("cobbles")
M.CardClass_Hunger = hash("hunger")
M.CardClass_Thirst = hash("thirst")
M.CardClass_Attack = hash("attack")
M.CardClass_Sprint = hash("sprint")
M.CardClass_SprintTrain = hash("sprinttrain")
M.CardClass_TeamCar = hash("teamcar")
M.CardClass_Crash = hash("crash")
M.CardClass_Relax = hash("relax")
M.CardClass_DNF = hash("dnf")

M.CardBonus_None = hash("none")
M.CardBonus_Sprint = hash("sprint")
M.CardBonus_Mountain = hash("mountain")
M.CardBonus_SprintFinish = hash("sprintfinish")
M.CardBonus_MountainFinish = hash("mountainfinish")
M.CardBonus_TimeLoss = hash("timeloss")
M.CardBonus_TimeWin = hash("timewin")

M.CardStatus_OK = hash("OK")
M.CardStatus_Hidden = hash("hidden")
M.CardStatus_Moving = hash("moving")
M.CardStatus_MovingTwice = hash("movingtwice")

return M