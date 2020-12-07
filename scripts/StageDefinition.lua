
local hx = require "scripts.hashes"

local M = {}

local _stageSectionCount = 3

local _bonusRankingMountainCatHC  = {     10, 5, 2 }

local _bonusRankingMountainFinish = { 25, 10, 5, 2 }

local _bonusRankingSprint         = {     10, 5, 2 }

local _bonusRankingSprintFinish   = { 25, 10, 5, 2 }

local _bonusRankingTimeLoss       = { 60, 45, 30 }

local _bonusRankingTimeWin        = { 60, 45, 30 }

local _cardDefinitionGroups = 
{
	Empty =
	{
		{ cardType = hx.CardType_None, statType = hx.StatType_None,          valueMin = 0, valueMax = 0, class = hx.CardClass_None         }
	}, 
--------------------------------------------------------------- ENERGY -----------------------------------------------------------------------------------------------------------------------------
	Energy = 
	{
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Energy,        valueMin = 2, valueMax = 2, class = hx.CardClass_Bidon       , rarity = 2 }, 
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Energy,        valueMin = 4, valueMax = 4, class = hx.CardClass_Food        , rarity = 1 }, 
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Team,          valueMin = 4, valueMax = 4, class = hx.CardClass_TeamMate    , rarity = 2 } 
	},
--------------------------------------------------------------- PROFILE ----------------------------------------------------------------------------------------------------------------------------
	ProfileFlat = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_Acceleration, rarity = 5 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Hill        , rarity = 2 } 
	},
	ProfileHill = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_Acceleration, rarity = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Hill        , rarity = 5 } 
	},
	ProfileMountain = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Hill        , rarity = 3 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 4, valueMax = 5, class = hx.CardClass_Climb       , rarity = 4 }
	},
---------------------------------------------------------------- TYPE --------------------------------------------------------------------------------------------------------------------------------
	TypeNormal = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_FlatTire    , rarity = 4 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_AnyExceptTeam, valueMin = 2, valueMax = 3, class = hx.CardClass_Hunger      , rarity = 2 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Crash       , rarity = 2 }
	},
	TypeCobbles = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_FlatTire    , rarity = 5 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Crash       , rarity = 2 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 4, valueMax = 5, class = hx.CardClass_Cobbles     , rarity = 4 }
	},
--------------------------------------------------------------- WEATHER ------------------------------------------------------------------------------------------------------------------------------
	WeatherSun = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_Wind        , rarity = 5 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Thirst      , rarity = 2 }
	},
	WeatherRain = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_Wind        , rarity = 3 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Rain        , rarity = 4 } 
	},
	WeatherWind = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_Wind        , rarity = 4 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 3, valueMax = 4, class = hx.CardClass_Crosswind   , rarity = 3 }
	},
	WeatherHeat = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Thirst      , rarity = 4 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 4, valueMax = 5, class = hx.CardClass_Heat        , rarity = 3 }
	},
	WeatherCold = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 3, valueMax = 4, class = hx.CardClass_Cold        , rarity = 5 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 4, valueMax = 5, class = hx.CardClass_Snow        , rarity = 2 }
	},
--------------------------------------------------------------- SPECIAL ------------------------------------------------------------------------------------------------------------------------------
	Feedzone = 
	{
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Energy,        valueMin = 2, valueMax = 2, class = hx.CardClass_Bidon       , rarity = 1 }, 
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Energy,        valueMin = 4, valueMax = 4, class = hx.CardClass_Food        , rarity = 1 }, 
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Gel         , rarity = 1 }
	},
	SprintFlat = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_Acceleration, rarity = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 1, valueMax = 1, class = hx.CardClass_Sprint      , rarity = 3, bonusType = hx.CardBonus_Sprint, rank = 3 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 2, valueMax = 2, class = hx.CardClass_Sprint      , rarity = 2, bonusType = hx.CardBonus_Sprint, rank = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Sprint      , rarity = 1, bonusType = hx.CardBonus_Sprint, rank = 1 } 
	},
	SprintHill = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Hill        , rarity = 2 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 1, valueMax = 1, class = hx.CardClass_Sprint      , rarity = 3, bonusType = hx.CardBonus_Mountain, rank = 3 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 2, valueMax = 2, class = hx.CardClass_Sprint      , rarity = 2, bonusType = hx.CardBonus_Mountain, rank = 2 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Sprint      , rarity = 1, bonusType = hx.CardBonus_Mountain, rank = 1 }
	},
	SprintMountain = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 4, valueMax = 5, class = hx.CardClass_Climb       , rarity = 2 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 1, valueMax = 1, class = hx.CardClass_Sprint      , rarity = 3, bonusType = hx.CardBonus_Mountain, rank = 3 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 2, valueMax = 2, class = hx.CardClass_Sprint      , rarity = 2, bonusType = hx.CardBonus_Mountain, rank = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Sprint      , rarity = 1, bonusType = hx.CardBonus_Mountain, rank = 1 }
	},
	FinalFlat = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_Acceleration, rarity = 4 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Crash       , rarity = 2 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 1, valueMax = 1, class = hx.CardClass_Sprint      , rarity = 4, bonusType = hx.CardBonus_SprintFinish, rank = 4 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Team,          valueMin = 2, valueMax = 2, class = hx.CardClass_SprintTrain , rarity = 3, bonusType = hx.CardBonus_SprintFinish, rank = 3 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Sprint      , rarity = 2, bonusType = hx.CardBonus_SprintFinish, rank = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Team,          valueMin = 4, valueMax = 4, class = hx.CardClass_SprintTrain , rarity = 1, bonusType = hx.CardBonus_SprintFinish, rank = 1 } 
	},
	FinalHill = 
	{
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 1, valueMax = 2, class = hx.CardClass_Acceleration, rarity = 3 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 2, valueMax = 3, class = hx.CardClass_Hill        , rarity = 3 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 1, valueMax = 1, class = hx.CardClass_Attack      , rarity = 2, bonusType = hx.CardBonus_TimeWin,        rank = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 2, valueMax = 2, class = hx.CardClass_Attack      , rarity = 2, bonusType = hx.CardBonus_TimeWin,        rank = 1 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 1, valueMax = 1, class = hx.CardClass_Sprint      , rarity = 3, bonusType = hx.CardBonus_MountainFinish, rank = 3 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Sprint      , rarity = 2, bonusType = hx.CardBonus_SprintFinish,   rank = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Sprint      , rarity = 1, bonusType = hx.CardBonus_MountainFinish, rank = 1 }, 
	},
	FinalMountain = 
	{
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Gel         , rarity = 2 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Any,           valueMin = 4, valueMax = 5, class = hx.CardClass_Climb       , rarity = 4 },
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 1, valueMax = 1, class = hx.CardClass_Attack      , rarity = 2, bonusType = hx.CardBonus_TimeWin,        rank = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 2, valueMax = 2, class = hx.CardClass_Attack      , rarity = 2, bonusType = hx.CardBonus_TimeWin,        rank = 1 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 1, valueMax = 1, class = hx.CardClass_Sprint      , rarity = 3, bonusType = hx.CardBonus_MountainFinish, rank = 3 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 2, valueMax = 2, class = hx.CardClass_Sprint      , rarity = 2, bonusType = hx.CardBonus_MountainFinish, rank = 2 }, 
		{ cardType = hx.CardType_Loss, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Sprint      , rarity = 1, bonusType = hx.CardBonus_MountainFinish, rank = 1 }
	},
	Handcards = 
	{
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Gel         , rarity = 1 }, 
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Team,          valueMin = 4, valueMax = 4, class = hx.CardClass_TeamMate    , rarity = 1, bonusType = hx.CardBonus_TimeLoss, rank = 1 },
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Energy,        valueMin = 2, valueMax = 2, class = hx.CardClass_Bidon       , rarity = 1, bonusType = hx.CardBonus_TimeLoss, rank = 3 },
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Team,          valueMin = 4, valueMax = 4, class = hx.CardClass_TeamMate    , rarity = 1, bonusType = hx.CardBonus_TimeLoss, rank = 1 },
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Energy,        valueMin = 2, valueMax = 2, class = hx.CardClass_Bidon       , rarity = 1, bonusType = hx.CardBonus_TimeLoss, rank = 3 },
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Gel         , rarity = 1 }, 
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Team,          valueMin = 4, valueMax = 4, class = hx.CardClass_TeamMate    , rarity = 1, bonusType = hx.CardBonus_TimeLoss, rank = 1 },
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Gel         , rarity = 1 }, 
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Energy,        valueMin = 4, valueMax = 4, class = hx.CardClass_Food        , rarity = 1, bonusType = hx.CardBonus_TimeLoss, rank = 2 },
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Attack,        valueMin = 3, valueMax = 3, class = hx.CardClass_Gel         , rarity = 1 }, 
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Team,          valueMin = 4, valueMax = 4, class = hx.CardClass_TeamMate    , rarity = 1, bonusType = hx.CardBonus_TimeLoss, rank = 1 },
		{ cardType = hx.CardType_Gain, statType = hx.StatType_Energy,        valueMin = 4, valueMax = 4, class = hx.CardClass_Food        , rarity = 1, bonusType = hx.CardBonus_TimeLoss, rank = 2 },
		{ cardType = hx.CardType_DNF,  statType = hx.StatType_Energy,        valueMin = 0, valueMax = 0, class = hx.CardClass_DNF         , rarity = 1 }
	}
}

local tempDeck_section = {}
local tempDeck_feedzone = {}
local tempDeck_endzone = {}

local function section_copyCardDefinition(cardDefinition, deckIndex)
	return { cardType = cardDefinition.cardType, statType = cardDefinition.statType, valueMin = cardDefinition.valueMin, valueMax = cardDefinition.valueMax, class = cardDefinition.class, rarity = cardDefinition.rarity, bonusType = cardDefinition.bonusType, rank = cardDefinition.rank, count = 0, deckIndex = deckIndex }
end

local function section_buildNormalDeck(section)
	local deck = {}
	local deckIndex = 0
	local rarityCounter = 0
	for defKey, defValue in pairs(section) do
		for key, cardDefinition in pairs(_cardDefinitionGroups[defValue]) do
			deckIndex = deckIndex + 1
			deck[deckIndex] = section_copyCardDefinition(cardDefinition, deckIndex)
			rarityCounter = rarityCounter + cardDefinition.rarity
		end
	end
	deck.rarityCounter = rarityCounter
	deck.cardsDrawn = 0
	return deck
end

local function section_buildFeedzoneDeck()
	local deck = {}
	local deckIndex = 0
	local rarityCounter = 0
	for key, cardDefinition in pairs(_cardDefinitionGroups["Feedzone"]) do
		deckIndex = deckIndex + 1
		deck[deckIndex] = section_copyCardDefinition(cardDefinition, deckIndex)
		rarityCounter = rarityCounter + cardDefinition.rarity
	end
	deck.rarityCounter = rarityCounter
	deck.cardsDrawn = 0
	return deck 
end

local function section_buildEndzoneDeck(endzoneType, isLastSection)
	local deck = {}
	local deckIndex = 0
	local rarityCounter = 0
	local groupName = ""
	if isLastSection == false then
		groupName = "Sprint" .. endzoneType
	else
		groupName = "Final" .. endzoneType
	end
	for key, cardDefinition in pairs(_cardDefinitionGroups[groupName]) do
		deckIndex = deckIndex + 1
		deck[deckIndex] = section_copyCardDefinition(cardDefinition, deckIndex)
		rarityCounter = rarityCounter + cardDefinition.rarity
	end
	deck.rarityCounter = rarityCounter
	deck.cardsDrawn = 0
	return deck 
end

local function card_GetDefaultProperties(gridColumn) 
	return { object = hx.Undefined, objectUrl = msg.url(), cardpool = hx.Undefined, status = hx.Undefined, gridColumn = gridColumn, cardType = hx.Undefined, statType = hx.Undefined, class = hx.Undefined, value = 0, bonusType = hx.Undefined, bonusPoints = 0/0, newPosition = vmath.vector3() }
end

local function card_getRandomDefinition(tempDeck)
	local totalCardCount = 0
	local availableCards = {}
	local availableCardCount = 0
	for key, cardDefinition in ipairs(tempDeck) do
		totalCardCount = totalCardCount + cardDefinition.count
		if cardDefinition.count < cardDefinition.rarity then
			availableCardCount = availableCardCount + 1
			availableCards[availableCardCount] = cardDefinition
		end
	end
	randomNumber = math.random(1, availableCardCount)
	local cardDefinition = availableCards[randomNumber]
	cardDefinition.count = cardDefinition.count + 1
	if totalCardCount + 1 >= tempDeck.rarityCounter then
		for key, cardDefinition in ipairs(tempDeck) do
			cardDefinition.count = 0
		end
	else
		tempDeck[cardDefinition.deckIndex] = cardDefinition
	end
	return cardDefinition
end

local function card_setProperties(cardInfo, cardDefinition)
	-- get a card defintion from the given card defintion type
--	print_table(cardDefinition)
	-- set the card properties based on the card defintion
	cardInfo.class = cardDefinition.class
	cardInfo.cardType = cardDefinition.cardType
	cardInfo.statType = cardDefinition.statType
	if cardInfo.cardType ~= hx.CardType_DNF then
		cardInfo.value = math.random(cardDefinition.valueMin, cardDefinition.valueMax)
	end
	if cardDefinition.bonusType ~= nil then
		-- a bous type has been defined
		cardInfo.bonusType = cardDefinition.bonusType
		if cardDefinition.rank ~= nil then
			-- a rank has been defined 
			if cardInfo.bonusType == hx.CardBonus_Mountain then
				cardInfo.bonusPoints = _bonusRankingMountainCatHC[cardDefinition.rank]
				-- andere Kategorien fehlen noch, müsste in Stage or cardDefinition hinterlegt sein
			elseif cardInfo.bonusType == hx.CardBonus_MountainFinish then
				cardInfo.bonusPoints = _bonusRankingMountainFinish[cardDefinition.rank]
			elseif cardInfo.bonusType == hx.CardBonus_Sprint then
				cardInfo.bonusPoints = _bonusRankingSprint[cardDefinition.rank]
			elseif cardInfo.bonusType == hx.CardBonus_SprintFinish then
				cardInfo.bonusPoints = _bonusRankingSprintFinish[cardDefinition.rank]
			elseif cardInfo.bonusType == hx.CardBonus_TimeLoss then
				cardInfo.bonusPoints = _bonusRankingTimeLoss[cardDefinition.rank]
			elseif cardInfo.bonusType == hx.CardBonus_TimeWin then
				cardInfo.bonusPoints = _bonusRankingTimeWin[cardDefinition.rank]
			end
		end
	else
		-- no bonus type has been defined
		cardInfo.bonusType = hx.CardBonus_None
		cardInfo.bonusPoints = 0/0
	end 
--	print_table(cardInfo)
end

function M.stage_getRoute(stageProperties, stageRowCount, gridSize)
	math.randomseed(stageProperties.stageIndex)
	local stage = {}
	local rowsPerSection = stageRowCount / _stageSectionCount
	for sectionIndex = 1, _stageSectionCount do
		local section = stageProperties.stageDefinition["section" .. sectionIndex]
		tempDeck_section = section_buildNormalDeck(section)
		tempDeck_feedzone = section_buildFeedzoneDeck()
		tempDeck_endzone = section_buildEndzoneDeck(string.sub(section.profile, 8), (sectionIndex == _stageSectionCount))
		local sectionRowStart = ((sectionIndex - 1) * rowsPerSection)
		for rowIndex = 1, rowsPerSection do
			local cardRow = {}
			local tempDeck = {}
			if sectionIndex == _stageSectionCount and rowIndex >= (rowsPerSection - 3) then
				tempDeck = tempDeck_endzone
			elseif sectionIndex < _stageSectionCount and rowIndex >= (rowsPerSection - 1) then
				tempDeck = tempDeck_endzone 
			elseif sectionIndex < _stageSectionCount and rowIndex >= ((rowsPerSection / 2) - 1) and rowIndex <= (rowsPerSection / 2) then
				tempDeck = tempDeck_feedzone
			else
				tempDeck = tempDeck_section
			end
--print(rowIndex .. ", " .. cardDefinitionType)
			for gridCol = 1, gridSize.x do
				local cardInfo = card_GetDefaultProperties(gridCol)
				local cardDefinition = card_getRandomDefinition(tempDeck)
				card_setProperties(cardInfo, cardDefinition)
				cardInfo.cardpool = hx.CardPool_Grid
				cardInfo.status = hx.CardStatus_OK
				cardRow[gridCol] = cardInfo
			end
			stage[sectionRowStart + rowIndex] = cardRow
		end 
	end
	local cardDefinitionEmpty = _cardDefinitionGroups["Empty"][1]
	for stageRow = stageRowCount + 1, stageRowCount + gridSize.y do
		local cardRow = {}
		for gridCol = 1, gridSize.x do
			local cardInfo = card_GetDefaultProperties(gridCol)
			card_setProperties(cardInfo, cardDefinitionEmpty)
			cardInfo.cardpool = hx.CardPool_Grid
			cardInfo.status = hx.CardStatus_OK
			cardRow[gridCol] = cardInfo
		end
		stage[stageRow] = cardRow
	end
	return stage
end

function M.hand_getCards(handIndex, handCardCount)
	local handCards = {}
	local tmp = _cardDefinitionGroups["Handcards"]
--	for cardIndex = 1, handCardCount do
	for cardIndex = 1, #tmp do
		local cardInfo = card_GetDefaultProperties(cardIndex)
		local cardDefinition = tmp[cardIndex]
		card_setProperties(cardInfo, cardDefinition)
		cardInfo.cardpool = hx.CardPool_Handcard
		cardInfo.status = hx.CardStatus_OK
		handCards[cardIndex] = cardInfo
	end
	return handCards
end

return M