local mod = RegisterMod('Challenge Shenanigans', 1)
local json = require('json')

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
  
  function mod:hasKey(tbl, key)
    for _, v in ipairs(tbl) do
      if v.key == key then
        return true
      end
    end
    
    return false
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
  
  function mod:getXmlChallengeAchievements(id)
    id = tonumber(id)
    
    if math.type(id) == 'integer' then
      local entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
      if entry and type(entry) == 'table' then
        if entry.achievements and entry.achievements ~= '' then
          return entry.achievements
        end
      end
    end
    
    return nil
  end
  
  function mod:getXmlChallengeId(nameAndSourceId)
    local id = Challenge.NUM_CHALLENGES
    local entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
    while entry and type(entry) == 'table' do
      if entry.id and entry.id ~= '' and entry.name and entry.name ~= '' and entry.sourceid and entry.sourceid ~= '' then
        if entry.name .. entry.sourceid == nameAndSourceId then
          --return entry.id
          return id
        end
      end
      
      id = id + 1
      entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
    end
    
    return nil
  end
  
  function mod:getXmlMaxChallengeId()
    local id = Challenge.NUM_CHALLENGES
    local entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
    while entry and type(entry) == 'table' do
      id = id + 1
      entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
    end
    
    return id - 1
  end
  
  function mod:getXmlModName(sourceid)
    local entry = XMLData.GetModById(sourceid)
    if entry and type(entry) == 'table' and entry.name and entry.name ~= '' then
      return entry.name
    end
    
    return nil
  end
  
  function mod:getModdedChallenges()
    local challenges = {}
    
    local id = Challenge.NUM_CHALLENGES
    local entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
    while entry and type(entry) == 'table' do
      if entry.hidden == nil or entry.hidden == 'false' then
        table.insert(challenges, entry)
      end
      
      id = id + 1
      entry = XMLData.GetEntryById(XMLNode.CHALLENGE, id)
    end
    
    return challenges
  end
  
  function mod:xmlAchievementsToTbl(s)
    local achievements = {}
    
    if s then
      for a in string.gmatch(s, '([^,]+)') do
        local achievement = tonumber(a)
        if achievement and math.type(achievement) == 'integer' then
          table.insert(achievements, achievement)
        end
      end
    end
    
    return achievements
  end
  
  function mod:allAchievementsUnlocked(achievements)
    local gameData = Isaac.GetPersistentGameData()
    
    for _, achievement in ipairs(achievements) do
      if not gameData:Unlocked(achievement) then
        return false
      end
    end
    
    return true
  end
  
  function mod:toggleChallenge(achievements)
    local gameData = Isaac.GetPersistentGameData()
    
    if #achievements > 0 then
      if not mod:allAchievementsUnlocked(achievements) then
        for _, achievement in ipairs(achievements) do
          gameData:TryUnlock(achievement, false)
        end
        return true
      else
        for _, achievement in ipairs(achievements) do
          Isaac.ExecuteCommand('lockachievement ' .. achievement)
        end
        return false
      end
    end
    
    return nil
  end
  
  function mod:unlockChallenge(achievements, unlock)
    local gameData = Isaac.GetPersistentGameData()
    
    if #achievements > 0 then
      if unlock then
        for _, achievement in ipairs(achievements) do
          gameData:TryUnlock(achievement, false)
        end
      else -- lock
        if mod:allAchievementsUnlocked(achievements) then
          for _, achievement in ipairs(achievements) do
            Isaac.ExecuteCommand('lockachievement ' .. achievement)
          end
        end
      end
    end
  end
  
  function mod:clearChallenge(challenge, clear)
    if clear then
      Isaac.ClearChallenge(challenge) -- +1 to modded challenges
    else
      Isaac.MarkChallengeAsNotDone(challenge)
    end
  end
  
  function mod:processImportedJson(s)
    local function sortKeys(a, b)
      return a.key < b.key
    end
    
    local jsonDecoded, data = pcall(json.decode, s)
    local maxChallengeId = mod:getXmlMaxChallengeId()
    local challenges = {}
    
    if jsonDecoded and type(data) == 'table' then
      if type(data.challenges) == 'table' then
        for k, v in pairs(data.challenges) do
          local challenge = nil
          if type(k) == 'string' then
            if string.sub(k, 1, 2) == 'M-' then
              challenge = tonumber(mod:getXmlChallengeId(string.sub(k, 3)))
            else
              challenge = tonumber(string.match(k, '^(%d+)'))
            end
          end
          if math.type(challenge) == 'integer' and math.type(v) == 'integer' and challenge >= 1 and challenge <= maxChallengeId then
            if not mod:hasKey(challenges, challenge) then
              table.insert(challenges, { key = challenge, value = v })
            end
          end
        end
      end
      
      table.sort(challenges, sortKeys)
      
      for _, v in ipairs(challenges) do
        local achievements
        if v.key < Challenge.NUM_CHALLENGES then
          local achievement = mod.unlocks[v.key]
          achievements = achievement and { achievement } or {}
        else
          achievements = mod:xmlAchievementsToTbl(mod:getXmlChallengeAchievements(v.key))
        end
        
        if v.value < 0 then
          mod:unlockChallenge(achievements, false)
          mod:clearChallenge(v.key, false)
        elseif v.value == 0 then
          mod:unlockChallenge(achievements, true)
          mod:clearChallenge(v.key, false)
        else -- v.value > 0
          mod:unlockChallenge(achievements, true)
          if not Isaac.IsChallengeDone(v.key) then -- gameData:IsChallengeCompleted
            mod:clearChallenge(v.key, true)
          end
        end
      end
    end
    
    return jsonDecoded, jsonDecoded and 'Imported ' .. #challenges .. ' challenges' or data
  end
  
  function mod:getJsonExport(inclBuiltInChallenges, inclModdedChallenges)
    local gameData = Isaac.GetPersistentGameData()
    local s = '{'
    
    s = s .. '\n  "challenges": {'
    local sb = {}
    if inclBuiltInChallenges then
      for challenge = 1, Challenge.NUM_CHALLENGES - 1 do
        local keys = mod:getKeys(Challenge, challenge)
        if #keys > 0 then
          local name = challenge .. '-' .. keys[1]
          local achievement = mod.unlocks[challenge]
          local achievements = achievement and { achievement } or {}
          table.insert(sb, mod:getJsonChallengeExport(challenge, name, achievements))
        end
      end
    end
    if inclModdedChallenges then
      for _, v in ipairs(mod:getModdedChallenges()) do
        if v.id and v.id ~= '' and v.name and v.name ~= '' and v.sourceid and v.sourceid ~= '' then
          local challenge = tonumber(v.id)
          if math.type(challenge) == 'integer' then
            local name = 'M-' .. v.name .. v.sourceid
            local achievements = mod:xmlAchievementsToTbl(v.achievements)
            table.insert(sb, mod:getJsonChallengeExport(challenge, name, achievements))
          end
        end
      end
    end
    s = s .. table.concat(sb, ',')
    s = s .. '\n  }'
    
    s = s .. '\n}'
    return s
  end
  
  function mod:getJsonChallengeExport(challenge, name, achievements)
    local val
    if Isaac.IsChallengeDone(challenge) then
      val = 1
    else
      if #achievements > 0 and not mod:allAchievementsUnlocked(achievements) then
        val = -1
      else
        val = 0
      end
    end
    
    local s = '\n    ' .. json.encode(name) .. ': ' .. val
    return s
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
    ImGui.AddTab('shenanigansTabBarChallenges', 'shenanigansTabChallengesImportExport', 'Import/Export')
    
    for challenge = 1, Challenge.NUM_CHALLENGES - 1 do
      local keys = mod:getKeys(Challenge, challenge)
      if #keys > 0 then
        local challengeName = mod:getXmlChallengeName(challenge)
        if challengeName then
          table.insert(keys, 1, challengeName)
        end
        local achievement = mod.unlocks[challenge]
        local achievements = achievement and { achievement } or {}
        mod:processChallenge(challenge, challenge, 'shenanigansTabChallenges', keys, achievements)
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
        local achievements = mod:xmlAchievementsToTbl(v.achievements) -- any names should already be converted to IDs
        mod:processChallenge(v.id, i, 'shenanigansTabChallengesModded', keys, achievements)
      end
    end
    
    local importText = ''
    ImGui.AddElement('shenanigansTabChallengesImportExport', '', ImGuiElement.SeparatorText, 'Import')
    ImGui.AddText('shenanigansTabChallengesImportExport', 'Paste JSON here:', false, '')
    ImGui.AddInputTextMultiline('shenanigansTabChallengesImportExport', 'shenanigansTxtChallengesImport', '', function(txt)
      importText = txt
    end, importText, 12)
    for i, v in ipairs({
                        { text = 'Cut'        , func = function()
                                                         if importText ~= '' then
                                                           Isaac.SetClipboard(importText)
                                                           ImGui.UpdateData('shenanigansTxtChallengesImport', ImGuiData.Value, '')
                                                           importText = ''
                                                         end
                                                       end },
                        { text = 'Copy'       , func = function()
                                                         if importText ~= '' then
                                                           Isaac.SetClipboard(importText)
                                                         end
                                                       end },
                        { text = 'Paste'      , func = function()
                                                         local clipboard = Isaac.GetClipboard()
                                                         if clipboard then
                                                           ImGui.UpdateData('shenanigansTxtChallengesImport', ImGuiData.Value, clipboard)
                                                           importText = clipboard
                                                         end
                                                       end },
                        { text = 'Import JSON', func = function()
                                                         local jsonImported, msg = mod:processImportedJson(importText)
                                                         ImGui.PushNotification(msg, jsonImported and ImGuiNotificationType.SUCCESS or ImGuiNotificationType.ERROR, 5000)
                                                       end },
                      })
    do
      ImGui.AddButton('shenanigansTabChallengesImportExport', 'shenanigansBtnChallengesImport' .. i, v.text, v.func, false)
      if i < 4 then
        ImGui.AddElement('shenanigansTabChallengesImportExport', '', ImGuiElement.SameLine, '')
      end
    end
    
    local exportBooleans = {
      builtInChallenges = true,
      moddedChallenges = true,
    }
    ImGui.AddElement('shenanigansTabChallengesImportExport', '', ImGuiElement.SeparatorText, 'Export')
    for i, v in ipairs({
                        { text = 'Export built-in challenges?', exportBoolean = 'builtInChallenges' },
                        { text = 'Export modded challenges?'  , exportBoolean = 'moddedChallenges' },
                      })
    do
      local chkChallengesExportId = 'shenanigansChkChallengesExport' .. i
      ImGui.AddCheckbox('shenanigansTabChallengesImportExport', chkChallengesExportId, v.text, function(b)
        exportBooleans[v.exportBoolean] = b
      end, exportBooleans[v.exportBoolean])
    end
    ImGui.AddButton('shenanigansTabChallengesImportExport', 'shenanigansBtnChallengesExport', 'Copy JSON to clipboard', function()
      Isaac.SetClipboard(mod:getJsonExport(exportBooleans.builtInChallenges, exportBooleans.moddedChallenges))
      ImGui.PushNotification('Copied JSON to clipboard', ImGuiNotificationType.INFO, 5000)
    end, false)
  end
  
  function mod:processChallenge(challenge, idx, tab, keys, achievements)
    local btnChallengeLockedId = 'shenanigansBtnChallengeLocked' .. challenge
    ImGui.AddButton(tab, btnChallengeLockedId, '\u{f13e}', nil, false)
    ImGui.AddCallback(btnChallengeLockedId, ImGuiCallback.Render, function()
      if #achievements > 0 then
        local label = mod:allAchievementsUnlocked(achievements) and '\u{f09c}' or '\u{f023}'
        ImGui.UpdateData(btnChallengeLockedId, ImGuiData.Label, label)
      end
    end)
    ImGui.AddCallback(btnChallengeLockedId, ImGuiCallback.Clicked, function()
      local toggled = mod:toggleChallenge(achievements)
      if toggled == false then
        mod:clearChallenge(challenge, false)
      end
    end)
    if tab == 'shenanigansTabChallengesModded' then
      ImGui.AddElement(tab, '', ImGuiElement.SameLine, '')
      local btnChallengePlusOneId = 'shenanigansBtnChallengePlusOne' .. challenge
      ImGui.AddButton(tab, btnChallengePlusOneId, '', nil, false)
      ImGui.AddCallback(btnChallengePlusOneId, ImGuiCallback.Render, function()
        local clearCount = Isaac.GetModChallengeClearCount(challenge)
        ImGui.UpdateData(btnChallengePlusOneId, ImGuiData.Label, string.format('%05d (+)', clearCount))
      end)
      ImGui.AddCallback(btnChallengePlusOneId, ImGuiCallback.Clicked, function()
        mod:unlockChallenge(achievements, true)
        mod:clearChallenge(challenge, true)
      end)
    end
    ImGui.AddElement(tab, '', ImGuiElement.SameLine, '')
    local chkChallengeId = 'shenanigansChkChallenge' .. challenge
    ImGui.AddCheckbox(tab, chkChallengeId, idx .. '.' .. table.remove(keys, 1), nil, false)
    if #keys > 0 then
      ImGui.SetHelpmarker(chkChallengeId, table.concat(keys, ', '))
    end
    ImGui.AddCallback(chkChallengeId, ImGuiCallback.Render, function()
      ImGui.UpdateData(chkChallengeId, ImGuiData.Value, Isaac.IsChallengeDone(challenge))
    end)
    ImGui.AddCallback(chkChallengeId, ImGuiCallback.Edited, function(b)
      if b then
        mod:unlockChallenge(achievements, true)
      end
      mod:clearChallenge(challenge, b)
    end)
  end
  
  -- launch options allow you to skip the menu
  mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.onRender)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
end