local frame = CreateFrame("FRAME", "KevToolQueueFrame");


function KevToolQueue_OnLoad()
  --math.randomseed();
	
  SLASH_KEVTOOLQUEUE1 = "/kevtoolqueue";
  SLASH_KEVTOOLQUEUE2 = "/ktq";
  SlashCmdList["KEVTOOLQUEUE"] = function(msg)
		KTQSlashCommandHandler(msg:upper(),msg);
	end	
	
	if not KTQuseBonusQueue then
		KTQuseBonusQueue = false
	end
	
	
	if not KTQBonusQueue then
		KTQBonusQueue = 2
	end
	
	if not KTQskipSingles then
		KTQskipSingles = false
	end
	if not KTQuseThreshold then
		KTQuseThreshold = false
	end
	
	if not KTQThreshold then
		KTQThreshold = 50000
	end
	
	if not KTQuseFallback then
		KTQuseFallback = false
	end
	
	if not KTQuseQuickAuction then
		KTQuseQuickAuction = false
		KTQuseAucAdvanced = true
	end
	print("KevTool Queue loaded: type /ktq for options");
end

function KTQSlashCommandHandler(msg)

	if msg ~= nil then
		local arg0,arg1,arg2  = strsplit(" ",msg)
		if arg0 == "DISABLE" then
			if arg1 == "BONUSQUEUE" then				
					KTQuseBonusQueue = false
					print("KevTool Queue: BonusQueue Disabled");	
			elseif arg1 == "SKIPSINGLES" then				
					KTQskipSingles = false
					print("KevTool Queue: SkipSingles Disabled");				
			elseif arg1 == "THRESHOLD" then				
					KTQuseThreshold = false
					print("KevTool Queue: Threshold Disabled");					
			elseif arg1 == "FALLBACK" then				
					KTQuseFallback = false
					print("KevTool Queue: Fallback Disabled");			
			else
				KTQShowHelp()
			end
		elseif arg0 == "ENABLE" then
			if arg1 == "BONUSQUEUE" then
				KTQuseBonusQueue = true		
				print("KevTool Queue: BonusQueue Enabled");				
			elseif arg1 == "SKIPSINGLES" then
				KTQskipSingles = true		
				print("KevTool Queue: SkipSingles Enabled");
			elseif arg1 == "THRESHOLD" then		
				KTQuseThreshold = true		
				print("KevTool Queue: Threshold Enabled");			
			elseif arg1 == "FALLBACK" then				
				KTQuseFallback = true		
				print("KevTool Queue: Fallback Enabled");			
			else
				KTQShowHelp()
			end	
		elseif arg0 == "SHOW" then
			if KTQuseBonusQueue then
				print("KevTool Queue: BonusQueue "..KTQBonusQueue);
			else		
				print("KevTool Queue: BonusQueue is Disabled");
			end	
			if KTQskipSingles then
				print("KevTool Queue: Skipping Singles is Enabled");
			else		
				print("KevTool Queue: Skipping Singles is Disabled");
			end	
			if KTQuseThreshold then
				print("KevTool Queue: Threshold "..KTQFormatCopperToText(KTQThreshold, false));
			else		
				print("KevTool Queue: Threshold is Disabled");
			end	
			if KTQuseFallback then
				print("KevTool Queue: Fallback is Enabled");
			else		
				print("KevTool Queue: Fallback is Disabled");
			end	
		elseif arg0 == "SET" then
			if arg2 ~= nil then
				local value = tonumber(arg2)
				if arg1 ~= nil then
					if arg1 == "BONUSQUEUE" then
						KTQBonusQueue = value
						print("KevTool Queue: BonusQueue "..KTQBonusQueue);
					elseif arg1 == "THRESHOLD" then
						value = KTQConvertTextToCopper(arg2)
						if value ~= nil then
							KTQThreshold = value
							print("KevTool Queue: Threshold "..KTQFormatCopperToText(KTQThreshold,false));
						end
						
					end		
				end
			
			else
				KTQShowHelp()
			end
		elseif arg0 == "QUEUE" then
			KTQQueue(msg)			
		else
		KTQShowHelp()
		end
	else
		KTQShowHelp()
	end
end

function KTQQueue(msg)
	local queueString0,queueString1,queueString2,queueString3,queueString4  = strsplit(" ",msg)
	if queueString0 == "QUEUE" then
		if queueString1 ~= nil then
			stackSize = tonumber(queueString1)
			if queueString2 ~= nil then
				if queueString2 == "GLYPHS" then
					KTQQueueItem(stackSize, "Glyphs")
				elseif queueString2 == "EPICGEMS" then
					KTQQueueItem(stackSize, "EpicGems")
				elseif queueString2 == "RAREGEMS" then
					KTQQueueItem(stackSize, "RareGems")
				else
					if queueString4 ~= nil then
						KTQQueueItem(stackSize, strtrim(queueString2.." "..queueString3.." "..queueString4))
					elseif queueString3 ~= nil then
						KTQQueueItem(stackSize, strtrim(queueString2.." "..queueString3))
					else
						KTQQueueItem(stackSize, strtrim(queueString2))
					end
					
				end					
			end
			
		end
	end
end 
 
function KTQShowHelp()
	print("Kev's Toolkit Queue Help [/ktq|/kevtoolqueue]")
	print("Features")
	print("  Bonus Queue lets you add extras when you sell out")
	print("  Skip Singles lets you not queue it if there is only one needed")
	print("  Threshold checks Auctioneer for listed value and lets you skip low selling items")
	print("  Fallback determins how to handle it when the AH is empty in regards to threshold")
	print("Command List")
	print("  QUEUE [number] [Keyword|Glyphs|EpicGems|RareGems]")
	print("          number is the amount you want to queue up")
	print("          keyword is search word that will queue matches")
	print("  ENABLE [BonusQueue|SkipSingles|Threshold|Fallback]")
	print("  DISABLE [BonusQueue|SkipSingles|Threshold|Fallback]")
	print("  SHOW [BonusQueue|SkipSingles|Threshold|Fallback]")
	print("  SET [BonusQueue|Threshold] [number]")
	print("          number is the value you want to set")
	print("Example")
	print("  /ktq set threshold 5g83s12c")
	print("  /ktq queue 5 Glyphs")
end
	
	
function KTQQueueItem(stackSize, group)
local totalQueue = 0
local totalAdded = 0
local totalSkipped = 0
for i = 1, GetNumTradeSkills() do
  local itemLink = GetTradeSkillItemLink(i)
  local skillName, skillType, numAvailable, isExpanded, altVerb = GetTradeSkillInfo(i)
  
  if KTQIsMatch(skillName, group) == true then
    local count = Altoholic:GetItemCount(Skillet:GetItemIDFromLink(itemLink))
    if count < stackSize then
		local enchantLink = GetTradeSkillRecipeLink(i)
		local found, _, skillString = string.find(enchantLink, "^|%x+|H(.+)|h%[.+%]")
		local _, skillId = strsplit(":", skillString )
		local toQueue = stackSize - count
		if KTQuseBonusQueue == true and toQueue == stackSize then
			toQueue = toQueue + KTQBonusQueue
		end
		
		if KTQuseThreshold == true then
			local minBuyout = KTQGetLowestPrice(itemLink)			
			
			if minBuyout < KTQThreshold then
				
				DEFAULT_CHAT_FRAME:AddMessage("-"..toQueue.." "..itemLink.." under threshold "..KTQFormatCopperToText(minBuyout,true))
				toQueue = 0
			end
		end
		
		if (KTQskipSingles == false or toQueue > 1) and toQueue ~= 0 then
			Skillet:AddToQueue(Skillet:QueueCommandIterate(tonumber(skillId), toQueue))
			DEFAULT_CHAT_FRAME:AddMessage("+"..toQueue.." "..itemLink)
			totalQueue = totalQueue + toQueue
			totalAdded = totalAdded  + 1
		else
			totalSkipped = totalSkipped  + 1
		end
    else
        totalSkipped = totalSkipped  + 1
    end
  end
end

DEFAULT_CHAT_FRAME:AddMessage("Keyword: "..group)
DEFAULT_CHAT_FRAME:AddMessage("Stack Size: "..stackSize)
DEFAULT_CHAT_FRAME:AddMessage("Total Added: "..totalQueue)
DEFAULT_CHAT_FRAME:AddMessage("Items Added: "..totalAdded )
DEFAULT_CHAT_FRAME:AddMessage("Items Skipped: "..totalSkipped)
end

function KTQIsMatch(skillName, group)

	if skillName == nil then return false end

	-- Glyphs
	if string.find(skillName,"Glyph of") ~= nil and group == "Glyphs" then
		return true
	end

	-- Epic Gems
	if string.find(skillName,"Cardinal Ruby") ~= nil and group == "EpicGems" then
		return true
	end
	if string.find(skillName,"Ametrine") ~= nil and group == "EpicGems" then
		return true
	end
	if string.find(skillName,"King's Amber") ~= nil and group == "EpicGems" then
		return true
	end
	if string.find(skillName,"Eye of Zul") ~= nil and group == "EpicGems" then
		return true
	end
	if string.find(skillName,"Majestic Zircon") ~= nil and group == "EpicGems" then
		return true
	end
	if string.find(skillName,"Dreadstone") ~= nil and group == "EpicGems" then
		return true
	end

	-- Rare Gems
	if string.find(skillName,"Scarlet Ruby") ~= nil and group == "RareGems" then
		return true
	end
	if string.find(skillName,"Monarch Topaz") ~= nil and group == "RareGems" then
		return true
	end
	if string.find(skillName,"Autumn's Glow") ~= nil and group == "RareGems" then
		return true
	end
	if string.find(skillName,"Forest Emerald") ~= nil and group == "RareGems" then
		return true
	end
	if string.find(skillName,"Sky Sapphire") ~= nil and group == "RareGems" then
		return true
	end
	if string.find(skillName,"Twilight Opal") ~= nil and group == "RareGems" then
		return true
	end

	-- Everything else
	if string.find(skillName:upper(),group:upper()) ~= nil then
		return true
	end

end

function KTQGetLowestPrice(itemLink)
	if itemLink then
		if KTQuseAucAdvanced == true and AucAdvanced and AucAdvanced.Version then
			local imgSeen, image, matchBid, matchBuy, lowBid, lowBuy, aveBuy, aSeen = AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(itemLink)
			local KTQFallback = 0
			if KTQuseFallback == true then
					KTQFallback = 9999999	
			end
			if imgSeen > 0 then
				if lowBuy ~= nil then
					return lowBuy
				else
					return KTQFallback
				end
			else
				return KTQFallback
			end
		end
	end	
end

-- All Currency processing and formatting Stolen form QuickAuction
-- Stolen from Tekkub!
local GOLD_TEXT = "|cffffd700g|r"
local SILVER_TEXT = "|cffc7c7cfs|r"
local COPPER_TEXT = "|cffeda55fc|r"
local COPPER_PER_SILVER = 100
local COPPER_PER_GOLD = 10000

-- Truncate tries to save space, after 10g stop showing copper, after 100g stop showing silver
function KTQFormatCopperToText(money, truncate)
	if money == nil then
		money = 0
	end
	
	local gold = math.floor(money / COPPER_PER_GOLD)
	local silver = math.floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = math.floor(math.fmod(money, COPPER_PER_SILVER))
	local text = ""
	
	-- Add gold
	if( gold > 0 ) then
		text = string.format("%d%s ", gold, GOLD_TEXT)
	end
	
	-- Add silver
	if( silver > 0 and ( not truncate or gold < 100 ) ) then
		text = string.format("%s%d%s ", text, silver, SILVER_TEXT)
	end
	
	-- Add copper if we have no silver/gold found, or if we actually have copper
	if( text == "" or ( copper > 0 and ( not truncate or gold <= 10 ) ) ) then
		text = string.format("%s%d%s ", text, copper, COPPER_TEXT)
	end
	
	return string.trim(text)
end

function KTQConvertTextToCopper(text)

	text = string.lower(text)
	local gold = tonumber(string.match(text, "([0-9]+)g"))
	local silver = tonumber(string.match(text, "([0-9]+)s"))
	local copper = tonumber(string.match(text, "([0-9]+)c"))
	
	if( not gold and not silver and not copper ) then
		print("Invalid money format: #g#s#c")
		return nil
	end
	
	-- Convert it all into copper
	copper = (copper or 0) + ((gold or 0) * COPPER_PER_GOLD) + ((silver or 0) * COPPER_PER_SILVER) or 0
	
	return copper
end