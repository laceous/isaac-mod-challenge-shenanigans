local mod = RegisterMod('Challenge Shenanigans', 1)

if REPENTOGON then
  -- the achievements in challenges.xml trigger these, but are different than these
  mod.unlocks = {
    [Challenge.CHALLENGE_DARKNESS_FALLS]      = Achievement.CHALLENGE_4_DARKNESS_FALLS,
    [Challenge.CHALLENGE_THE_TANK]            = Achievement.CHALLENGE_5_THE_TANK,
    [Challenge.CHALLENGE_SOLAR_SYSTEM]        = Achievement.CHALLENGE_6_SOLAR_SYSTEM,
    [Challenge.CHALLENGE_SUICIDE_KING]        = Achievement.CHALLENGE_7_SUICIDE_KING,
    [Challenge.CHALLENGE_CAT_GOT_YOUR_TONGUE] = Achievement.CHALLENGE_8_CAT_GOT_YOUR_TONGUE,
    [Challenge.CHALLENGE_DEMO_MAN]            = Achievement.CHALLENGE_9_DEMO_MAN,
    [Challenge.CHALLENGE_CURSED]              = Achievement.CHALLENGE_10_CURSED,
    [Challenge.CHALLENGE_GLASS_CANNON]        = Achievement.CHALLENGE_11_GLASS_CANNON,
    [Challenge.CHALLENGE_THE_FAMILY_MAN]      = Achievement.CHALLENGE_19_THE_FAMILY_MAN,
    [Challenge.CHALLENGE_PURIST]              = Achievement.CHALLENGE_20_PURIST,
    [Challenge.CHALLENGE_XXXXXXXXL]           = Achievement.CHALLENGE_21_XXXXXXXXL,
    [Challenge.CHALLENGE_SPEED]               = Achievement.CHALLENGE_22_SPEED,
    [Challenge.CHALLENGE_BLUE_BOMBER]         = Achievement.CHALLENGE_23_BLUE_BOMBER,
    [Challenge.CHALLENGE_PAY_TO_PLAY]         = Achievement.CHALLENGE_24_PAY_TO_PLAY,
    [Challenge.CHALLENGE_HAVE_A_HEART]        = Achievement.CHALLENGE_25_HAVE_A_HEART,
    [Challenge.CHALLENGE_I_RULE]              = Achievement.CHALLENGE_26_I_RULE,
    [Challenge.CHALLENGE_BRAINS]              = Achievement.CHALLENGE_27_BRAINS,
    [Challenge.CHALLENGE_PRIDE_DAY]           = Achievement.CHALLENGE_28_PRIDE_DAY,
    [Challenge.CHALLENGE_ONANS_STREAK]        = Achievement.CHALLENGE_29_ONANS_STREAK,
    [Challenge.CHALLENGE_GUARDIAN]            = Achievement.CHALLENGE_30_THE_GUARDIAN,
    [Challenge.CHALLENGE_BACKASSWARDS]        = Achievement.CHALLENGE_31_BACKASSWARDS,
    [Challenge.CHALLENGE_APRILS_FOOL]         = Achievement.CHALLENGE_32_APRILS_FOOL,
    [Challenge.CHALLENGE_POKEY_MANS]          = Achievement.CHALLENGE_33_POKEY_MANS,
    [Challenge.CHALLENGE_ULTRA_HARD]          = Achievement.CHALLENGE_34_ULTRA_HARD,
    [Challenge.CHALLENGE_PONG]                = Achievement.CHALLENGE_35_PONG,
    [Challenge.CHALLENGE_BLOODY_MARY]         = Achievement.CHALLENGE_37_BLOODY_MARY,
    [Challenge.CHALLENGE_BAPTISM_BY_FIRE]     = Achievement.CHALLENGE_38_BAPTISM_BY_FIRE,
    [Challenge.CHALLENGE_ISAACS_AWAKENING]    = Achievement.CHALLENGE_39_ISAACS_AWAKENING,
    [Challenge.CHALLENGE_SEEING_DOUBLE]       = Achievement.CHALLENGE_40_SEEING_DOUBLE,
    [Challenge.CHALLENGE_PICA_RUN]            = Achievement.CHALLENGE_41_PICA_RUN,
    [Challenge.CHALLENGE_HOT_POTATO]          = Achievement.CHALLENGE_42_HOT_POTATO,
    [Challenge.CHALLENGE_CANTRIPPED]          = Achievement.CHALLENGE_43_CANTRIPPED,
    [Challenge.CHALLENGE_RED_REDEMPTION]      = Achievement.CHALLENGE_44_RED_REDEMPTION,
    [Challenge.CHALLENGE_DELETE_THIS]         = Achievement.CHALLENGE_45_DELETE_THIS,
  }
  
  function mod:onRender()
    mod:RemoveCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.onRender)
    mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
    mod:setupImGui()
  end
  
  function mod:getKeys(tbl, val)
    local keys = {}
    
    for k, v in pairs(tbl) do
      if v == val then
        table.insert(keys, k)
      end
    end
    
    table.sort(keys)
    return keys
  end
  
  function mod:getXmlChallengeName(id)
    id = tonumber(id)
    
    if math.type(id) == 'integer' then
      local entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
      if entry and type(entry) == 'table' then
        if entry.name and entry.name ~= '' then
          return entry.name
        end
      end
    end
    
    return nil
  end
  
  function mod:getXmlModName(sourceid)
    local id = 1
    local entry = XMLData.GetEntryById(XMLNode.MOD, id)
    while entry and type(entry) == 'table' do
      if entry.id and entry.id ~= '' and entry.name and entry.name ~= '' then
        if entry.id == sourceid then
          return entry.name
        end
      end
      
      id = id + 1
      entry = XMLData.GetEntryById(XMLNode.MOD, id)
    end
    
    return nil
  end
  
  function mod:getModdedChallenges()
    local challenges = {}
    
    local id = Challenge.NUM_CHALLENGES
    local entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
    while entry and type(entry) == 'table' do
      entry.id = tostring(id) -- id can be overriden in the xml even though the game ignores it
      table.insert(challenges, entry)
      
      id = id + 1
      entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
    end
    
    return challenges
  end
  
  function mod:getMaxModdedChallengeClearCount()
    local maxModdedChallengeClearCount = 0
    
    for _, v in ipairs(mod:getModdedChallenges()) do
      if v.id and v.id ~= '' then
        local moddedChallengeClearCount = Isaac.GetModChallengeClearCount(v.id)
        if moddedChallengeClearCount > maxModdedChallengeClearCount then
          maxModdedChallengeClearCount = moddedChallengeClearCount
        end
      end
    end
    
    return maxModdedChallengeClearCount
  end
  
  function mod:toggleChallenge(challenge)
    local gameData = Isaac.GetPersistentGameData()
    local achievement = mod.unlocks[challenge]
    
    if achievement then
      if not gameData:Unlocked(achievement) then
        gameData:TryUnlock(achievement)
        return true
      else
        Isaac.ExecuteCommand('lockachievement ' .. achievement)
        return false
      end
    end
    
    return nil
  end
  
  -- should we also unlock the achievements listed in challenges.xml?
  function mod:unlockChallenge(challenge)
    local gameData = Isaac.GetPersistentGameData()
    local achievement = mod.unlocks[challenge]
    
    if achievement then
      gameData:TryUnlock(achievement)
    end
  end
  
  function mod:clearChallenge(challenge, clear)
    if clear then
      Isaac.ClearChallenge(challenge)
    else
      Isaac.MarkChallengeAsNotDone(challenge)
    end
  end
  
  function mod:setupImGui()
    if not ImGui.ElementExists('shenanigansMenu') then
      ImGui.CreateMenu('shenanigansMenu', '\u{f6d1} Shenanigans')
    end
    ImGui.AddElement('shenanigansMenu', 'shenanigansMenuItemChallenges', ImGuiElement.MenuItem, '\u{f091} Challenge Shenanigans')
    ImGui.CreateWindow('shenanigansWindowChallenges', 'Challenge Shenanigans')
    ImGui.LinkWindowToElement('shenanigansWindowChallenges', 'shenanigansMenuItemChallenges')
    
    ImGui.AddTabBar('shenanigansWindowChallenges', 'shenanigansTabBarChallenges')
    ImGui.AddTab('shenanigansTabBarChallenges', 'shenanigansTabChallenges', 'Challenges')
    ImGui.AddTab('shenanigansTabBarChallenges', 'shenanigansTabChallengesModded', 'Challenges (Modded)')
    
    for challenge = 1, Challenge.NUM_CHALLENGES - 1 do
      local keys = mod:getKeys(Challenge, challenge)
      if #keys > 0 then
        local challengeName = mod:getXmlChallengeName(challenge)
        if challengeName then
          table.insert(keys, 1, challengeName)
        end
        local btnChallengeId = 'shenanigansBtnChallenge' .. challenge
        ImGui.AddButton('shenanigansTabChallenges', btnChallengeId, '\u{f13e}', nil, false)
        ImGui.AddCallback(btnChallengeId, ImGuiCallback.Render, function()
          local achievement = mod.unlocks[challenge]
          if achievement then
            local gameData = Isaac.GetPersistentGameData()
            local label = gameData:Unlocked(achievement) and '\u{f09c}' or '\u{f023}'
            ImGui.UpdateData(btnChallengeId, ImGuiData.Label, label)
          end
        end)
        ImGui.AddCallback(btnChallengeId, ImGuiCallback.Clicked, function()
          local toggled = mod:toggleChallenge(challenge)
          if toggled == false then
            mod:clearChallenge(challenge, false)
          end
        end)
        ImGui.AddElement('shenanigansTabChallenges', '', ImGuiElement.SameLine, '')
        local chkChallengeId = 'shenanigansChkChallenge' .. challenge
        ImGui.AddCheckbox('shenanigansTabChallenges', chkChallengeId, challenge .. '.' .. table.remove(keys, 1), nil, false)
        if #keys > 0 then
          ImGui.SetHelpmarker(chkChallengeId, table.concat(keys, ', '))
        end
        ImGui.AddCallback(chkChallengeId, ImGuiCallback.Render, function()
          ImGui.UpdateData(chkChallengeId, ImGuiData.Value, Isaac.IsChallengeDone(challenge))
        end)
        ImGui.AddCallback(chkChallengeId, ImGuiCallback.Edited, function(b)
          if b then
            mod:unlockChallenge(challenge)
          end
          mod:clearChallenge(challenge, b)
        end)
      end
    end
    
    for i, v in ipairs(mod:getModdedChallenges()) do
      local keys = {}
      table.insert(keys, v.name or '')
      if v.sourceid and v.sourceid ~= '' then
        local modName = mod:getXmlModName(v.sourceid)
        table.insert(keys, modName or v.sourceid)
      end
      if v.id and v.id ~= '' and #keys > 0 then
        local progChallengeId = 'shenanigansProgChallengeModded' .. v.id
        ImGui.AddProgressBar('shenanigansTabChallengesModded', progChallengeId, '', 0, '0 clears')
        ImGui.AddCallback(progChallengeId, ImGuiCallback.Render, function()
          local moddedChallengeClearCount = Isaac.GetModChallengeClearCount(v.id)
          local maxModdedChallengeClearCount = mod:getMaxModdedChallengeClearCount()
          local value = maxModdedChallengeClearCount > 0 and moddedChallengeClearCount / maxModdedChallengeClearCount or 0
          local hintText = moddedChallengeClearCount .. ' clear'
          if moddedChallengeClearCount ~= 1 then
            hintText = hintText .. 's'
          end
          ImGui.UpdateData(progChallengeId, ImGuiData.Value, value)
          ImGui.UpdateData(progChallengeId, ImGuiData.HintText, hintText)
        end)
        ImGui.AddElement('shenanigansTabChallengesModded', '', ImGuiElement.SameLine, '')
        ImGui.AddButton('shenanigansTabChallengesModded', 'shenanigansBtnChallengeModded' .. v.id, '+', function()
          mod:clearChallenge(v.id, true)
        end, false)
        ImGui.AddElement('shenanigansTabChallengesModded', '', ImGuiElement.SameLine, '')
        local chkChallengeId = 'shenanigansChkChallengeModded' .. v.id
        local chkChallengeText = i .. '.' .. table.remove(keys, 1)
        ImGui.AddCheckbox('shenanigansTabChallengesModded', chkChallengeId, chkChallengeText, nil, false)
        if #keys > 0 then
          ImGui.SetHelpmarker(chkChallengeId, table.concat(keys, ', '))
        end
        ImGui.AddCallback(chkChallengeId, ImGuiCallback.Render, function()
          ImGui.UpdateData(chkChallengeId, ImGuiData.Value, Isaac.IsChallengeDone(v.id))
        end)
        ImGui.AddCallback(chkChallengeId, ImGuiCallback.Edited, function(b)
          mod:clearChallenge(v.id, b)
        end)
      end
    end
  end
  
  -- launch options allow you to skip the menu
  mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.onRender)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
end