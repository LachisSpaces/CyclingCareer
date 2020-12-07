
local hx = require "scripts.hashes"

local M = {}


local function simulation_newStats(team, energy, attack, sprint, mountain, handTeam, handEnergy, handAttack)
	return { 
		team = team, energy = energy, attack = attack, 
		sprint = sprint, mountain = mountain, 
		handTeam = handTeam, handEnergy = handEnergy, handAttack = handAttack }
end

local function simulation_getStats(array)
	return { 
		team = array.team, energy = array.energy, attack = array.attack, 
		sprint = array.sprint, mountain = array.mountain, 
		handTeam = array.handTeam, handEnergy = array.handEnergy, handAttack = array.handAttack }
end

local function simulation_getFirst(index, row, column, teammAmount, energyAmount, attackAmount, teamMaximum, energyMaximum, attackMaximum, handTeam, handEnergy, handAttack)
	local amount = { team = teammAmount, energy = energyAmount, attack = attackAmount, sprint = 0, mountain = 0, handTeam = handTeam, handEnergy = handEnergy, handAttack = handAttack }
	local max = { team = teamMaximum, energy = energyMaximum, attack = attackMaximum }
	return { index = index, row = row, col = column, status = hash("collected"), previousIndex = -1, next = {0,0,0,0}, amount = amount, max = max }
end

local function simulation_getNext(index, previous, column)
	local next = {}
	if column == 1 then
		next = { 0, 0,-1,-1}
	elseif column == 2 then
		next = { 0, 0, 0,-1}
	elseif column == 3 then
		next = {-1, 0, 0, 0}
	elseif column == 4 then
		next = {-1,-1, 0, 0}
	end
	return { index = index, row = previous.row + 1, col = column, status = hash("new"), previousIndex = previous.index, next = next, amount = simulation_getStats(previous.amount), max = simulation_getStats(previous.max) }
end

local function simulation_print_card(cardInfo)
	print(cardInfo.cardType .. " " .. cardInfo.statType .. " " .. cardInfo.value)
end
local function simulation_print_step(step)
	print("r = " .. step.row .. ", c = " .. step.col .. ", T" .. step.amount.team .. " E" .. step.amount.energy .. " A" .. step.amount.attack .. ", index = " .. step.index .. ", prev = " .. step.previousIndex .. ", status = " .. step.status .. ", next = {" .. concat_table(step.next) .. "}") 
end

local function simulation_tryDeduction(testAmount, testDeduction, deductionStart)
	if deductionStart <= 1 and testDeduction <= testAmount.team then
		testAmount.team = testAmount.team - testDeduction
	else
		if deductionStart <= 1 then
			testDeduction = testDeduction - testAmount.team
			testAmount.team = 0
		end
		if deductionStart <= 2 and testDeduction <= testAmount.energy  then
			testAmount.energy  = testAmount.energy  - testDeduction
		else
			if deductionStart <= 2 then
				testDeduction = testDeduction - testAmount.energy 
				testAmount.energy  = 0
			end
			if testDeduction <= testAmount.attack then
				testAmount.attack = testAmount.attack - testDeduction
			else
				testAmount.attack = 0
			end
		end
	end
	if testAmount.energy  <= 0 and testAmount.attack <= 0 then
		return false
	else
		return true
	end
end

function M.simulate(stageRoute, stageRowCount, gridSize_x)
	local bestResults = {}
	for row = 1, stageRowCount do
		for col = 1, gridSize_x do
			local resultGroup = {}
			bestResults[(row-1) * gridSize_x + col] = resultGroup
		end
	end
	local simulation = {}
	local simulationIndex = 0
	local evaluationStep = 0
	local actualStep = 0
	local start = simulation_getFirst(simulationIndex, 0,0, 3,3,3, 3,3,3, 16,12,8)
	simulation[simulationIndex] = start
	repeat 
--		print ("----------------------------------------------")
		local actual = simulation[actualStep]
		if actual == nil then
			break
		end
--		simulation_print_step(actual)
		local tryNext = false 
		local colEvaluation = {0, 0, 0, 0}
		local bestEvalutation = -999
		local bestColumn = -1
		for col = 1, gridSize_x do
			if actual.next[col] == 0 then
				local cardInfo = stageRoute[actual.row + 1][col]
				if cardInfo ~= nil then
					if cardInfo.status == hx.CardStatus_OK then
						if cardInfo.cardType == hx.CardType_Gain then
							if cardInfo.statType == hx.StatType_Attack then
								if actual.amount.attack < actual.max.attack then
									colEvaluation[col] = 2
								end
							elseif cardInfo.statType == hx.StatType_Team then 
								if actual.amount.team < actual.max.team then
									local newValue = math.min(actual.amount.team + cardInfo.value, actual.max.team)
									colEvaluation[col] = (newValue / actual.max.team) + 0.01
								end
							elseif cardInfo.statType == hx.StatType_Energy then
								if actual.amount.energy < actual.max.energy then
									local newValue = math.min(actual.amount.energy + cardInfo.value, actual.max.energy)
									colEvaluation[col] = (newValue / actual.max.energy)
								end
							end
						elseif cardInfo.cardType == hx.CardType_Loss then
							if cardInfo.bonusPoints > 0 then
								colEvaluation[col] = cardInfo.bonusPoints + 0.1 -- To be higher than max value of 1.01 from gain above
							else
								colEvaluation[col] = cardInfo.value * -1
							end
						end
						if bestEvalutation < colEvaluation[col] then
							bestEvalutation = colEvaluation[col]
							bestColumn = col 
						end
					end
				end
			end
		end
		if bestColumn > -1 then
			if actual.next[bestColumn] == 0 then
				simulationIndex = simulationIndex + 1
				actualStep = simulationIndex
				actual.next[bestColumn] = actualStep
				simulation[actual.index] = actual
--				simulation_print_step(actual)
				local nextStep = simulation_getNext(actualStep, actual, bestColumn)
				actual = nextStep 
				simulation[actualStep] = actual
				tryNext = true
			else
				print("ERROR: " .. actual.next[bestColumn])
			end
		end
		if tryNext == true then
--			simulation_print_step(actual)
			local row = actual.row
			local col = actual.col 
			local cardInfo = stageRoute[row][col]
--			simulation_print_card(cardInfo)
			if cardInfo ~= nil then
				if cardInfo.object ~= nil and cardInfo.status == hx.CardStatus_OK then
					if cardInfo.cardType == hx.CardType_Gain then
						if cardInfo.statType == hx.StatType_Team then
							actual.amount.team = math.min(actual.amount.team + cardInfo.value, actual.max.team)
						elseif cardInfo.statType == hx.StatType_Energy then
							actual.amount.energy = math.min(actual.amount.energy + cardInfo.value, actual.max.energy)
						elseif cardInfo.statType == hx.StatType_Attack then
							actual.amount.attack = math.min(actual.amount.attack + cardInfo.value, actual.max.attack)
						end
						actual.status = hash("collected")
					elseif cardInfo.cardType == hx.CardType_Loss then
						local deduction = cardInfo.value
						if cardInfo.statType == hx.StatType_Any or cardInfo.statType == hx.StatType_AnyExceptTeam then
							local deductionStart = 1
							if cardInfo.statType == hx.StatType_AnyExceptTeam then
								deductionStart = 2
							end
							local testAmount = simulation_getStats(actual.amount)
							if simulation_tryDeduction(testAmount, deduction + 0, deductionStart) == false then
								if actual.amount.handEnergy > 8 and actual.amount.energy < actual.max.energy then
									testAmount.handEnergy = testAmount.handEnergy - 2
									testAmount.energy = math.min(testAmount.energy + 2, actual.max.energy)
								end
								if simulation_tryDeduction(testAmount, deduction + 0, deductionStart) == false then
									if actual.amount.handTeam > 0 and actual.amount.team < actual.max.team then
										testAmount.handTeam = testAmount.handTeam - 4
										testAmount.team = math.min(testAmount.team + 4, actual.max.team)
									end
									if simulation_tryDeduction(testAmount, deduction + 0, deductionStart) == false then
										if actual.amount.handEnergy >= 4 then
											testAmount.handEnergy = testAmount.handEnergy - 4
											testAmount.energy = math.min(testAmount.energy + 4, actual.max.energy)
										end
										if simulation_tryDeduction(testAmount, deduction + 0, deductionStart) == false then
											if actual.amount.handAttack > 0 then
												testAmount.handAttack = testAmount.handAttack - 2
												testAmount.attack = math.min(testAmount.attack + 2, actual.max.attack)
											end
											if simulation_tryDeduction(testAmount, deduction + 0, deductionStart) == false then
												-- not OK >> will be a GAME OVER 
											else -- OK with 2 attack
												actual.amount.handAttack = actual.amount.handAttack - 2
												actual.amount.attack = math.min(actual.amount.attack + 2, actual.max.attack)
											end
										else -- OK with 4 energy
											actual.amount.handEnergy = actual.amount.handEnergy - 4
											actual.amount.energy = math.min(actual.amount.energy + 4, actual.max.energy)
										end
									else -- OK with 4 team
										actual.amount.handTeam = actual.amount.handTeam - 4
										actual.amount.team = math.min(actual.amount.team + 4, actual.max.team)
									end
								else -- OK with 2 energy
									actual.amount.handEnergy = actual.amount.handEnergy - 2
									actual.amount.energy = math.min(actual.amount.energy + 2, actual.max.energy)
								end
							end
							if deductionStart <= 1 and deduction <= actual.amount.team then
								actual.amount.team = actual.amount.team - deduction
							else
								if deductionStart <= 1 then
									deduction = deduction - actual.amount.team
									actual.amount.team = 0
								end
								if deductionStart <= 2 and deduction <= actual.amount.energy  then
									actual.amount.energy  = actual.amount.energy  - deduction
								else
									if deductionStart <= 2 then
										deduction = deduction - actual.amount.energy 
										actual.amount.energy  = 0
									end
									if deduction <= actual.amount.attack then
										actual.amount.attack = actual.amount.attack - deduction
									else
										actual.amount.attack = 0
									end
								end
							end
							actual.status = hash("collected")
						elseif cardInfo.statType == hx.StatType_Team then
							if cardInfo.value > actual.amount.team then
								if cardInfo.value > actual.max.team then
									actual.status = hash("insufficient")
								else
									if cardInfo.value > math.min(actual.amount.team + actual.amount.handTeam, actual.max.team) then
										actual.status = hash("insufficient")
									else
										actual.amount.handTeam = actual.amount.handTeam - 4
										actual.amount.team = math.min(actual.amount.team + 4, actual.max.team)
										if cardInfo.value > actual.amount.team then
											actual.amount.handTeam = actual.amount.handTeam - 4
											actual.amount.team = math.min(actual.amount.team + 4, actual.max.team)
										end
										actual.amount.team = actual.amount.team - deduction
										actual.status = hash("collected")
									end
								end
							else
								actual.amount.team = actual.amount.team - deduction
								actual.status = hash("collected")
							end
						elseif cardInfo.statType == hx.StatType_Energy then
							if cardInfo.value > actual.amount.energy  then
								if cardInfo.value > actual.max.energy then
									actual.status = hash("insufficient")
								else
									if cardInfo.value > math.min(actual.amount.energy + actual.amount.handEnergy, actual.max.energy) then
										actual.status = hash("insufficient")
									else
										if actual.amount.handEnergy > 8 then
											actual.amount.handEnergy = actual.amount.handEnergy - 2
											actual.amount.energy = math.min(actual.amount.energy + 2, actual.max.energy)
										end
										if cardInfo.value > actual.amount.energy then
											if actual.amount.handEnergy > 8 then
												actual.amount.handEnergy = actual.amount.handEnergy - 2
												actual.amount.energy = math.min(actual.amount.energy + 2, actual.max.energy)
											end
											if cardInfo.value > actual.amount.energy then
												actual.amount.handEnergy = actual.amount.handEnergy - 4
												actual.amount.energy = math.min(actual.amount.energy + 4, actual.max.energy)
											end
											if cardInfo.value > actual.amount.energy then
												actual.amount.handEnergy = actual.amount.handEnergy - 4
												actual.amount.energy = math.min(actual.amount.energy + 4, actual.max.energy)
											end
										end
										actual.amount.energy = actual.amount.energy - deduction
										actual.status = hash("collected")
									end
								end
							else
								actual.amount.energy  = actual.amount.energy  - cardInfo.value
								actual.status = hash("collected")
							end
						elseif cardInfo.statType == hx.StatType_Attack then
							if cardInfo.value > actual.amount.attack then
								if cardInfo.value > actual.max.attack then
									actual.status = hash("insufficient")
								else
									if cardInfo.value > math.min(actual.amount.attack + actual.amount.handAttack, actual.max.attack) then
										actual.status = hash("insufficient")
									else
										actual.amount.handAttack = actual.amount.handAttack - 2
										actual.amount.attack = math.min(actual.amount.attack + 2, actual.max.attack)
										if cardInfo.value > actual.amount.attack then
											actual.amount.handAttack = actual.amount.handAttack - 2
											actual.amount.attack = math.min(actual.amount.attack + 2, actual.max.attack)
										end
										actual.amount.attack = actual.amount.attack - deduction
										actual.status = hash("collected")
									end
								end
							else
								actual.amount.attack = actual.amount.attack - cardInfo.value
								actual.status = hash("collected")
							end
						end
						if actual.amount.energy  <= 0 and actual.amount.attack <= 0 then
							actual.status = hash("gameover")
						end
					end
					if actual.status == hash("collected") then
						if cardInfo.bonusPoints > 0 then
							if cardInfo.bonusType == hx.CardBonus_Sprint or cardInfo.bonusType == hx.CardBonus_SprintFinish then
								actual.amount.sprint = actual.amount.sprint + cardInfo.bonusPoints 
							end
							if cardInfo.bonusType == hx.CardBonus_Mountain or cardInfo.bonusType == hx.CardBonus_MountainFinish then
								actual.amount.mountain = actual.amount.mountain + cardInfo.bonusPoints 
							end
						end
						if row == stageRowCount then
							actual.status = hash("winner")
							simulation[actualStep] = actual
--							simulation_print_step(actual)
							actualStep = actual.previousIndex
						else
							local resultIndex = 0
							local betterResult = false 
							local resultGroup = bestResults[(row-1) * gridSize_x + col]
							if next(resultGroup) then
								local betterResultCount = 0
								for key, value in pairs(resultGroup) do
--									print_table (value)
									if actual.amount.team > value.team or actual.amount.energy > value.energy or actual.amount.attack > value.attack or actual.amount.sprint > value.sprint or actual.amount.mountain > value.mountain or actual.amount.handTeam > value.handTeam or actual.amount.handEnergy > value.handEnergy or actual.amount.handAttack > value.handAttack then
										betterResultCount = betterResultCount + 1
									end
									resultIndex = resultIndex + 1
								end
								if betterResultCount == resultIndex then
									betterResult = true
								end
							else
								betterResult = true
							end
							if betterResult == true then
								simulation[actualStep] = actual
								local result = simulation_getStats(actual.amount)
								resultGroup[resultIndex] = result
								bestResults[(row-1) * gridSize_x + col] = resultGroup
							else
								actual.status = hash("cancelled")
								simulation[actualStep] = actual
								actualStep = actual.previousIndex
							end
						end
					else
--						simulation_print_step(actual)
						simulation[actualStep] = actual
						actualStep = actual.previousIndex
					end
				else
					actualStep = actual.previousIndex
				end
			else
				actualStep = actual.previousIndex
			end
		else
			actualStep = actual.previousIndex
		end
		evaluationStep = evaluationStep + 1
	until evaluationStep > 999999
	print("evalutation steps: " .. evaluationStep)
	for index = simulationIndex, 0, -1 do
		local test = simulation[index]
		if test.status == hash("winner") then
			local bonus = "M." .. string.format("%02d", test.amount.mountain) .. ".S." .. string.format("%02d", test.amount.sprint)
			local sequence = ""
			repeat 
				sequence = test.col .. "." .. sequence
				test = simulation[test.previousIndex]
			until test.row == 0
			print (bonus .. "." .. sequence)
		end
	end
	--	pprint(simulation)
end

return M