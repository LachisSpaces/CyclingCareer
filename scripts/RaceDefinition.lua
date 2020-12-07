
local hx = require "scripts.hashes"

local M = {}

local _raceDefinition = 
{
	TourDeSuisse = 
	{
		{ 
			stage = 1, type = hx.StageDefinition_TypeNormal, profile = hx.StageDefinition_ProfileHill, weather = hx.StageDefinition_WeatherSun, 
			section1 = { energy = "Energy", type = "TypeNormal", profile = "ProfileHill",     weather = "WeatherSun"  }, 
			section2 = { energy = "Energy", type = "TypeNormal", profile = "ProfileHill",     weather = "WeatherSun"  }, 
			section3 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherSun"  } 
		},
		{ 
			stage = 2, type = hx.StageDefinition_TypeNormal, profile = hx.StageDefinition_ProfileFlat, weather = hx.StageDefinition_WeatherHeat, 
			section1 = { energy = "Energy", type = "TypeNormal", profile = "ProfileHill",     weather = "WeatherSun"  }, 
			section2 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherHeat" }, 
			section3 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherHeat" } 
		},
		{ 
			stage = 3, type = hx.StageDefinition_TypeNormal, profile = hx.StageDefinition_ProfileHill, weather = hx.StageDefinition_WeatherRain, 
			section1 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherWind" }, 
			section2 = { energy = "Energy", type = "TypeNormal", profile = "ProfileHill",     weather = "WeatherRain" }, 
			section3 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherRain" } 
		},
		{ 
			stage = 4, type = hx.StageDefinition_TypeNormal, profile = hx.StageDefinition_ProfileHill, weather = hx.StageDefinition_WeatherCold, 
			section1 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherCold" }, 
			section2 = { energy = "Energy", type = "TypeNormal", profile = "ProfileHill",     weather = "WeatherWind" }, 
			section3 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherCold" } 
		},
		{ 
			stage = 5, type = hx.StageDefinition_TypeNormal, profile = hx.StageDefinition_ProfileHill, weather = hx.StageDefinition_WeatherWind, 
			section1 = { energy = "Energy", type = "TypeNormal", profile = "ProfileHill",     weather = "WeatherRain" }, 
			section2 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherRain" }, 
			section3 = { energy = "Energy", type = "TypeNormal", profile = "ProfileHill",     weather = "WeatherRain" } 
		},
		{ 
			stage = 6, type = hx.StageDefinition_TypeNormal, profile = hx.StageDefinition_ProfileMountain, weather = hx.StageDefinition_WeatherSun, 
			section1 = { energy = "Energy", type = "TypeNormal", profile = "ProfileHill",     weather = "WeatherSun"  }, 
			section2 = { energy = "Energy", type = "TypeNormal", profile = "ProfileMountain", weather = "WeatherWind" }, 
			section3 = { energy = "Energy", type = "TypeNormal", profile = "ProfileMountain", weather = "WeatherSun"  } 
		},
		{ 
			stage = 7, type = hx.StageDefinition_TypeNormal, profile = hx.StageDefinition_ProfileMountain, weather = hx.StageDefinition_WeatherRain, 
			section1 = { energy = "Energy", type = "TypeNormal", profile = "ProfileMountain", weather = "WeatherRain" }, 
			section2 = { energy = "Energy", type = "TypeNormal", profile = "ProfileMountain", weather = "WeatherRain" }, 
			section3 = { energy = "Energy", type = "TypeNormal", profile = "ProfileFlat",     weather = "WeatherWind" } 
		}
	}
}

function M.race_getStages(raceName)
	local stages = _raceDefinition[raceName]
--	for key, stage in pairs(stages) do
--		print_table(stage)
--	end
	return stages
end

return M