-- инфа левый нижний угол

do  
  local ADDON_NAME, ns = ...
  
  --local FONT_NAME = "Interface\\addons\\"..ADDON_NAME.."\\PTSansNarrow.ttf"
  local FONT_NAME = "Interface\\addons\\"..ADDON_NAME.."\\trebucbd.ttf"
  local FONT_SIZE = 12
  local ALPHA = 0.9

  local PARTICLE_DENSITY_BAR_MIN_WIDTH = 50
  local PARTICLE_DENSITY_BAR_MIN_HEIGHT = 7
  local UPDATE_INTERVAL_GLOBAL = 0.1
  local UPDATE_INTERVAL_SERVER_INFO = 5
  local FORCE_EN_LOCALE = true
  
  local L = FORCE_EN_LOCALE and "enUS" or GetLocale()
  local PARTICLES = L=="ruRU" and "Частицы" or "PARTICLES"
  local SERV_DELAY = L=="ruRU" and "Серв. зад" or "SERV"
  local GAMES = L=="ruRU" and "Игр" or "GAMES"
  local WINS = L=="ruRU" and "Побед" or "WINS"
  local WINRATE = L=="ruRU" and "Винрейт" or "WR"
  local ATTACK_POWER = L=="ruRU" and "АП" or "AP"
  local SPELL_POWER = L=="ruRU" and "СПД" or "SPD"
  local RES = L=="ruRU" and "Рес" or "RES"
  local CRIT = L=="ruRU" and "Крит" or "CRT"
  local HASTE = L=="ruRU" and "Хаст" or "HST"
  local HIT = L=="ruRU" and "Хит" or "HIT"
  local MOVE_SPEED = L=="ruRU" and "Скор. движ" or "MOV"
  local TO_RES = L=="ruRU" and "До реса" or "To res"
  local BY_CORPSE = L=="ruRU" and "по телу" or "by corpse"
  local TO_RES_BY_CORPSE = L=="ruRU" and "Рес по телу" or "Res by corpse"
  local ENEMIES = L=="ruRU" and "врагов реснется" or "dead enemies"
  local READY = L=="ruRU" and "готов" or "ready"
  local RATING = L=="ruRU" and "Рейтинг" or "RTG"
  local SYSMSG_SPAM_ERROR = L=="ruRU" and "Команда не может быть обработана в текущий момент" or "This command cann't be processed now"
  
  local ACHIV_CATEGORY_ID_BATTLEGROUNDS_PLAYED = 839 --GetStatisticId("Battlegrounds", "Battlegrounds played")
  local ACHIV_CATEGORY_ID_BATTLEGROUNDS_WON = 840 --GetStatisticId("Battlegrounds", "Battlegrounds won")
  
  local GetCorpseRecoveryDelay = GetCorpseRecoveryDelay
  local UnitIsDeadOrGhost = UnitIsDeadOrGhost
  local GetRealZoneText = GetRealZoneText
  local GetCVar = GetCVar
  local UnitIsPVP = UnitIsPVP
  local GetPVPTimer = GetPVPTimer
  local IsInInstance = IsInInstance
  local GetInstanceInfo = GetInstanceInfo
  local GetRealNumRaidMembers = GetRealNumRaidMembers
  local UnitInRaid = UnitInRaid
  local GetSpellBonusDamage = GetSpellBonusDamage
  local GetCombatRating = GetCombatRating
  local GetSpellCritChance = GetSpellCritChance
  local UnitAttackPower = UnitAttackPower
  local UnitRangedAttackPower = UnitRangedAttackPower
  local GetRangedCritChance = GetRangedCritChance
  local GetCritChance = GetCritChance
  local UnitGUID = UnitGUID
  local UnitClass = UnitClass
  local UnitHealthMax = UnitHealthMax
  local UnitIsPVPSanctuary = UnitIsPVPSanctuary
  local GetTalentTabInfo = GetTalentTabInfo
  local GetNumTalents = GetNumTalents
  local GetSpellInfo = GetSpellInfo
  local GetTalentInfo = GetTalentInfo
  local GetNumTalentTabs = GetNumTalentTabs
  local GetUnitSpeed = GetUnitSpeed
  local GetStatistic = GetStatistic
  local _G = _G
  local format = _G.format
  local select = _G.select
  local tonumber = _G.tonumber
  local unpack = _G.unpack
  local floor = _G.floor
  local max = _G.max
  local min = _G.min
  local modf = math.modf
  local GetFramerate = GetFramerate
  local GetNetStats = GetNetStats
  local GetZonePVPInfo = GetZonePVPInfo
  local date = _G.date
  local time = _G.time
  local GetTime = _G.GetTime
  local CR_HASTE_SPELL = CR_HASTE_SPELL
  local CR_HIT_RANGED = CR_HIT_RANGED
  local CR_HIT_MELEE = CR_HIT_MELEE
  local CR_HIT_RANGED = CR_HIT_RANGED
  local CR_CRIT_RANGED = CR_CRIT_RANGED

  local playerGUID = UnitGUID("player")
  
  local InDungeon, InRaidDungeon, InBg, InArena, InRaidGroup, spectatorMode, instanceDifficulty, zonePvpType, showAttackPower, showSpellPower, curZone, zoneColor, InCrossZone, isHunter
  local serverDelay = 0

  local statsInfoString, bgInfoString, zoneInfoString = "", "", ""
  local RezTimer_Data, bg_statistics = _G.RezTimer_Data, _G.bg_statistics
  local zone_interval = 0
  --print("bg_statistics",bg_statistics)
  
  local function rgbToHex(r, g, b)
    return format("%02x%02x%02x", floor(255 * r), floor(255 * g), floor(255 * b))
  end
  
  local gradientColor = { 0, 1, 0, 1, 1, 0, 1, 0, 0 }

  local function ColorGradient(perc, ...)
    if (perc > 1) then
      local r, g, b = select(select("#", ...) - 2, ...)
      return r, g, b
    elseif (perc < 0) then
      local r, g, b = ...
      return r, g, b
    end

    local num = select("#", ...) / 3

    local segment, relperc = modf(perc * (num - 1))
    local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

    if r2 == nil then r2 = 1 end
    if g2 == nil then g2 = 1 end
    if b2 == nil then b2 = 1 end

    return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
  end
  
  local function RGBGradient(num)
    local r, g, b = ColorGradient(num, unpack(gradientColor))
    -- Преобразуем значения компонент цвета в формат FFFFFF
    local hexColor = format("%02x%02x%02x", r * 255, g * 255, b * 255)
    return hexColor
  end

  local function getTalentpointsSpent(spellID)
    local spellName = GetSpellInfo(spellID)
    for tabIndex = 1, GetNumTalentTabs() do
      for talentID = 1, GetNumTalents(tabIndex) do
        local name, _, _, _, spent = GetTalentInfo(tabIndex, talentID)
        if name == spellName then
          return spent
        end
      end
    end
    return 0
  end

  local function IsMeleeClass()
    return select(2, UnitClass("player")) == "ROGUE"
    or select(2, UnitClass("player")) == "WARRIOR"
    or select(2, UnitClass("player")) == "DEATHKNIGHT"
    or (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(1)) < 51)
    or (select(2, UnitClass("player")) == "SHAMAN" and select(3, GetTalentTabInfo(2)) >= 51)
    or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(2)) >= 51)
  end

  local function IsSpellPowerClass()
    return select(2, UnitClass("player")) == "MAGE"
    or select(2, UnitClass("player")) == "WARLOCK"
    or select(2, UnitClass("player")) == "PRIEST"
    or (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(1)) >= 51)
    or (select(2, UnitClass("player")) == "SHAMAN" and select(3, GetTalentTabInfo(2)) < 51)
    or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(2)) < 51)
  end

  -- local function IsPhysicalClass()
    -- return IsMeleeClass() or select(2, UnitClass("player")) == "HUNTER"
  -- end

  local function IsHealerClass()
    return (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(1)) >= 51)
    or (select(2, UnitClass("player")) == "SHAMAN" and select(3, GetTalentTabInfo(3)) >= 51)
    or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(3)) >= 51)
    or (select(2, UnitClass("player")) == "PRIEST" and select(3, GetTalentTabInfo(3)) < 51)
  end
  
  -- пвп таймер формат в мин:сек
  local function formatTime(seconds)
    local minutes = floor(seconds / 60)
    local remainingSeconds = floor(seconds % 60)

    if minutes == 0 then
      return format("%ds", remainingSeconds)
    elseif remainingSeconds == 0 then
      return format("%dm", minutes)
    else
      return format("%dm %ds", minutes, remainingSeconds)
    end
  end
  
  -- милисекунды
  local TimeFormatter = {}

  function TimeFormatter:Init()
    self.timeOffset = time() - floor(GetTime())
  end

  function TimeFormatter:GetFormattedTime()
    if not self.timeOffset then
      self:Init()
    end

    self.now = GetTime()
    self.seconds = floor(self.now)
    self.milliseconds = floor((self.now - self.seconds) * 1000)
    self.fullTime = self.timeOffset + self.seconds
    
    return date("%A  %d.%m.%Y  %H:%M:%S", self.fullTime) .. format(".%03d", self.milliseconds)
  end
  _G.GetFormattedTime = TimeFormatter.GetFormattedTime 
   
  -- Создаем статус-бар
  local f = CreateFrame("StatusBar", ADDON_NAME.."_ParticleDensityBar_Frame", UIParent)
  f:SetSize(PARTICLE_DENSITY_BAR_MIN_WIDTH, PARTICLE_DENSITY_BAR_MIN_HEIGHT)
  f:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 172, 36)
  f:SetFrameStrata("high")
  f:SetFrameLevel(10)
  f:SetMinMaxValues(0, 100)
  f:SetValue(0)
  f:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  f:SetStatusBarColor(1, 0, 0)  -- начальное значение - красный
  
  -- Делаем фрейм "пользовательским", чтобы WoW сохранял его параметры в layout-local.txt
  f:SetMovable(true)
  f:SetResizable(true)
  f:SetUserPlaced(true)  -- ✅ Ключевая строка для сохранения в layout-local.txt
  
  f:SetAlpha(ALPHA)

  -- Обводка (черная рамка, тоньше)
  local border = CreateFrame("Frame", nil, f)
  border:SetPoint("TOPLEFT", -0.5, 0.5)   -- Уменьшаем отступы
  border:SetPoint("BOTTOMRIGHT", 0.5, -0.5)
  border:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 4,   -- ✅ Уменьшаем толщину рамки
  })
  border:SetBackdropBorderColor(0, 0, 0, 1)
  
  local function UpdateBarColor(bar, value, maxValue)
    local percent = value / maxValue
    
    local r, g, b
    if percent < 0.5 then
      -- Переход от красного (1,0,0) к желтому (1,1,0)
      r = 1
      g = percent * 2  -- От 0 до 1
      b = 0
    else
      -- Переход от желтого (1,1,0) к зеленому (0,1,0)
      r = 2 - (percent * 2) -- От 1 до 0
      g = 1
      b = 0
    end
    
    bar:SetStatusBarColor(r, g, b)
  end

  -- Функция обновления цвета статус-бара
  local function UpdateStatusBarColor(self)
    local value = self:GetValue()
    local min, max = self:GetMinMaxValues()
    local percent = (value - min) / (max - min)
    local red = 1 - percent      -- при 0% красный = 1
    local green = percent        -- при 100% зеленый = 1
    UpdateBarColor(self, value, max)
  end

  f:SetScript("OnValueChanged", UpdateStatusBarColor)

  f:RegisterForDrag("LeftButton")
  
  f:SetScript("OnMouseDown", function(self, button)
    if IsModifierKeyDown() then
      self:StartMoving()
    end
  end)
  
  f:SetScript("OnMouseUp", function(self, button)
    self:StopMovingOrSizing()
  end)

  -- Обработчик прокрутки колесика для пропорционального изменения размера
  f:SetScript("OnMouseWheel", function(self, delta)
    if IsModifierKeyDown() then
      local width, height = self:GetSize()
      local newSize = max(PARTICLE_DENSITY_BAR_MIN_WIDTH, min(400, width + delta * 10)) -- Ограничиваем размер от 50 до 400
      local aspectRatio = 10  -- Коэффициент пропорциональности (чем выше, тем меньше меняется высота)
      local newHeight = max(PARTICLE_DENSITY_BAR_MIN_HEIGHT, min(100, height + delta * (10 / aspectRatio)))

      self:SetSize(newSize, newHeight)

      -- Обновляем обводку, чтобы не ломалась при изменении размера
      border:SetPoint("TOPLEFT", -1, 1)
      border:SetPoint("BOTTOMRIGHT", 1, -1)
    end
  end)

  local function updateZoneAndRaidInfo()
    local isInstance, InstanceType = IsInInstance()
    InDungeon, InRaidDungeon, InBg, InArena, InRaidGroup, spectatorMode, instanceDifficulty, zonePvpType, showAttackPower, showSpellPower, InCrossZone, isHunter = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil

    local _, type, _, _, maxPlayers, playerDifficulty = GetInstanceInfo()
    zonePvpType = GetZonePVPInfo()
    curZone = GetRealZoneText()

    if zonePvpType=="sanctuary" then zoneColor = rgbToHex(0.41, 0.8, 0.94)
      elseif zonePvpType=="contested" then zoneColor = rgbToHex(1.0, 0.7, 0)
      elseif zonePvpType=="friendly" then zoneColor = rgbToHex(0.1, 1.0, 0.1)
      elseif zonePvpType=="hostile" then zoneColor = rgbToHex(1.0, 0.1, 0.1)
      elseif zonePvpType=="combat" then zoneColor = rgbToHex(1.0, 0.1, 0.1)
      elseif zonePvpType=="arena" then zoneColor = rgbToHex(1.0, 0.1, 0.1)
      else zoneColor = rgbToHex(1.0, 0.9294, 0.7607)
    end

    if type == "party" or type == "raid" then
      if maxPlayers == 10 and playerDifficulty==0 then
        instanceDifficulty = "10"
      elseif maxPlayers == 10 and playerDifficulty==1 then
        instanceDifficulty = "10"..""..COMBATLOG_ICON_RAIDTARGET8
      elseif maxPlayers == 25 and playerDifficulty==0 then
        instanceDifficulty = "25"
      elseif maxPlayers == 25 and playerDifficulty==1 then
        instanceDifficulty = "25"..""..COMBATLOG_ICON_RAIDTARGET8
      elseif playerDifficulty==1 then
        instanceDifficulty = COMBATLOG_ICON_RAIDTARGET8
      end
    end
    
    if isInstance == 1 then
      if InstanceType == "raid" then
        InDungeon, InRaidDungeon = true, true
      elseif InstanceType == "party" then
        InDungeon = true
      elseif InstanceType == "pvp" then
        InBg = true
      elseif InstanceType == "arena" then
        InArena = true
      end
    end

    InRaidGroup = GetRealNumRaidMembers() > 0 or UnitInRaid("player")
    InCrossZone = InBg or InArena or (UnitIsPVPSanctuary("player") and (curZone=="Кратер Азшары" or curZone=="Ульдуар" or curZone=="Azshara Crater" or curZone=="Ulduar"))
    
    if (InRaidDungeon and not InRaidGroup) or (InArena and UnitHealthMax("player") < 3000) then
      spectatorMode = true
    end
    
    playerGUID = UnitGUID("player")
    showSpellPower = IsSpellPowerClass() or IsHealerClass()
    showAttackPower = IsMeleeClass()
    isHunter = select(2, UnitClass("player")) == "HUNTER"
  end

  local function GetRezTimerInfo()
    local text, CorpseRecoveryDelay = ""
   
    if InBg then
      local secondsToRes = RezTimer_Data and RezTimer_Data.cd
      
      if secondsToRes then
        text = text .. TO_RES..":  |cffff8822"..secondsToRes.."|r"
        if UnitIsDeadOrGhost("player") then
          CorpseRecoveryDelay = GetCorpseRecoveryDelay()
          if CorpseRecoveryDelay > 0 then
            text = text .. "   "..BY_CORPSE..":  |cffff8822"..formatTime(CorpseRecoveryDelay).."|r"
          else
            text = text .. "   "..BY_CORPSE..":  |cff33ff33"..READY.."|r"
          end
        end
      else
        if UnitIsDeadOrGhost("player") then
          CorpseRecoveryDelay = GetCorpseRecoveryDelay()
          if CorpseRecoveryDelay > 0 then
            text = text .. TO_RES_BY_CORPSE..":  |cffff8822"..formatTime(CorpseRecoveryDelay).."|r"
          else
            text = text .. TO_RES_BY_CORPSE..":  |cff33ff33"..READY.."|r"
          end
        end
      end
      
      if RezTimer_Data and RezTimer_Data.counter then
        text = text .. "   "..ENEMIES..":  |cffff6622"..RezTimer_Data.counter.."|r"
      end
    elseif UnitIsDeadOrGhost("player") then
      CorpseRecoveryDelay = GetCorpseRecoveryDelay()
      if CorpseRecoveryDelay > 0 then
        text = text .. TO_RES_BY_CORPSE..":  |cffff8822"..formatTime(CorpseRecoveryDelay).."|r"
      else
        text = text .. TO_RES_BY_CORPSE..":  |cff33ff33"..READY.."|r"
      end
    end
    
    return text
  end
  
  local function formatTrimmed(num)
    num = tonumber(num)
    if num then
      local rounded = floor(num * 10 + 0.5) / 10  -- округление до 1 знака
      if rounded % 1 == 0 then
        return format("%d", rounded)  -- целое число без дробной части
      else
        return format("%.1f", rounded)
      end
    end
    return -1
  end
  
  local function GetBgInfoText()
    --local text = ""
    
    local bgstats = bg_statistics and bg_statistics[playerGUID]
    
    local winsStr, gamesStr, winRateStr 
    
    if bgstats then
      --local rating = bgstats.rating
      local wins = bgstats.wins
      local games = bgstats.games
      local winrate = games > 0 and formatTrimmed(wins / games *100) or 0
      local wrColor = games > 0 and RGBGradient(1 - (wins / games *100) / 100) or "999999"
      
      winsStr, gamesStr, winRateStr = wins, games, "|ccc"..wrColor..""..winrate.."|r"
      
      --text = RATING..":  |cccffff88"..rating.."|r    "..GAMES..":  |cccffff88"..games.."|r    "..WINS..":  |cccffff88"..wins.."|r    "..WINRATE..":  |ccc"..wrColor..""..winrate.."|r"
    end
    
    games = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_PLAYED)) or 0
    wins = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_WON)) or 0
    winrate = games > 0 and formatTrimmed(wins / games *100) or 0
    wrColor = games > 0 and RGBGradient(1 - (wins / games *100) / 100) or "999999"
    
    winsStr = winsStr and ""..WINS..":  |cccffff88"..winsStr.. " ("..wins..")|r" or ""..WINS..":  |cccffff88"..wins.."|r"
    gamesStr = gamesStr and ""..GAMES..":  |cccffff88"..gamesStr.. " ("..games..")|r" or ""..GAMES..":  |cccffff88"..games.."|r"
    winRateStr = winRateStr and ""..WINRATE..":  "..winRateStr .. " |ccc"..wrColor.."("..winrate..")|r" or ""..WINRATE..":  "..winrate..""
    
    --text = gamesStr.."    "..winsStr.."    "..winRateStr
    
    return gamesStr.."    "..winsStr.."    "..winRateStr
  end
  
  local function GetStatsText()
    local text = ""

    local spdOrAp, crit, haste, hexcolor, hexcolorCrit, hexcolorHaste, hit, hexHitColor, bonusDamage, _crit

    if showSpellPower then
      --spdOrAp = GetSpellBonusDamage(6) -- 6=shadow
    
      -- Start at 2 to skip physical damage
      spdOrAp = GetSpellBonusDamage(2)
      crit = GetSpellCritChance(2)
      
      for i = 3, MAX_SPELL_SCHOOLS do
        bonusDamage = GetSpellBonusDamage(i)
        spdOrAp = min(spdOrAp, bonusDamage)
      end
      
      for i = 3, MAX_SPELL_SCHOOLS do
        _crit = GetSpellCritChance(i)
        crit = min(crit, _crit)
      end
      
      haste = GetCombatRating(CR_HASTE_SPELL) --* 0.03049802371
      --crit = GetSpellCritChance(6)
      hit = GetCombatRating(CR_HIT_SPELL) --/ 32.7868852459
    elseif showAttackPower then
      local base, posBuff, negBuff = UnitAttackPower("player")
      spdOrAp = base + posBuff - negBuff -- value=current attack power
      crit = GetCritChance()
      haste = GetCombatRating(CR_HASTE_MELEE) --* 0.03049802371
      hit = GetCombatRating(CR_HIT_MELEE) --/ 32.7868852459
    elseif isHunter then
      local base, posBuff, negBuff = UnitRangedAttackPower("player")
      spdOrAp = base + posBuff - negBuff -- value=current attack power
      crit = GetRangedCritChance()
      haste = GetCombatRating(CR_HASTE_RANGED) --* 0.03049802371
      hit = GetCombatRating(CR_HIT_RANGED) --/ 32.7868852459
    end

    if showAttackPower or isHunter then
      --hexcolor = RGBGradient(spdOrAp / 9000)
      hexcolor = RGBGradient(1 - spdOrAp / 6000)
      --hexcolorHaste = RGBGradient(157 / 1000)
      hexcolorHaste = haste == 0 and "999999" or "ffffff"
      hexHitColor = RGBGradient(1 - hit / 10)
    elseif showSpellPower then
      hexcolor = RGBGradient(1 - spdOrAp / 3500)
      --hexcolorHaste = RGBGradient(haste / 2000)
      hexcolorHaste = RGBGradient(1 - haste / 50)
      hexHitColor = RGBGradient(1 - hit / 10)
    end
    
    hexcolorCrit = RGBGradient(1 - crit / 50)
    
    local res = GetCombatRating(16)
    local resColor = RGBGradient(1 - tonumber(res) / 1414)

    if showAttackPower or isHunter then 
      text = text .. ATTACK_POWER
    elseif showSpellPower then 
      text = text .. SPELL_POWER  
    end

    text = text .. ":  |cff" ..hexcolor .."" ..spdOrAp .."|r    "..RES..":  |cff"..resColor..""..res.."|r    "..CRIT..":  |cff" ..hexcolorCrit .."" .. format("%.0f", crit) .. "|r    "..HASTE..":  |cff" .. hexcolorHaste .. "" ..formatTrimmed(haste) .. "|r    "..HIT..":  |cff" .. hexHitColor .. ""..formatTrimmed(hit).."|r"
    
    return text
  end

  local function GetZoneInfo()
    zone_interval = zone_interval + 0.01
    if zone_interval < 0.1 then return zoneInfoString end
    zone_interval, zoneInfoString = 0, ""

    local _instanceDifficulty = instanceDifficulty and (" |ccc" .. zoneColor .. "("..instanceDifficulty..")|r") or ""
    local _spectatorMode = spectatorMode and ("  [spectator]") or ""
    
    local PVPTimer = GetPVPTimer() / 1000
    local pvpOn = UnitIsPVP("player")
    local pvpInfo = pvpOn and ("|cffff0000PvP|r") or ""
    
    if pvpOn and PVPTimer > 0 then
      if PVPTimer < 300 then
        pvpInfo = pvpInfo .. " "..formatTime(PVPTimer)..""
      end
    end
    
    zoneInfoString = "|ccc" .. zoneColor .. curZone .. "|r".._instanceDifficulty.."".._spectatorMode.."   "..pvpInfo..""
    
    return zoneInfoString
  end

  f:RegisterEvent("MODIFIER_STATE_CHANGED")
  f:RegisterEvent("PLAYER_LOGIN")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  f:RegisterEvent("ZONE_CHANGED")
  f:RegisterEvent("PLAYER_TALENT_UPDATE")
  f:RegisterEvent("CHAT_MSG_SYSTEM")
  f:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
  f:RegisterEvent("ADDON_LOADED")
  
  f:RegisterEvent("UNIT_ATTACK_POWER")
  f:RegisterEvent("UNIT_RANGED_ATTACK_POWER")
  f:RegisterEvent("UNIT_STATS")
  f:RegisterEvent("UNIT_RANGEDDAMAGE")
  f:RegisterEvent("UNIT_DAMAGE")
  
  f:RegisterEvent("PLAYER_DAMAGE_DONE_MODS")
  --f:RegisterEvent("SKILL_LINES_CHANGED")
  
  f:SetScript("OnEvent", function(self, event, ...)
    if ( event == "UNIT_ATTACK_POWER"
      or event == "UNIT_RANGED_ATTACK_POWER"
      or event == "UNIT_STATS"
      or event == "UNIT_RANGEDDAMAGE"
      or event == "UNIT_DAMAGE"
      ) and ... == "player"
      then
        statsInfoString = GetStatsText()
    elseif event == "PLAYER_DAMAGE_DONE_MODS" then
      statsInfoString = GetStatsText()
    elseif event == "ADDON_LOADED" then
      if ... == "RezTimer" then
        RezTimer_Data = _G.RezTimer_Data
      elseif ... == "CustomFrames" then
        bg_statistics = _G.bg_statistics
      end
    elseif event == "UPDATE_BATTLEFIELD_STATUS" then
      bgInfoString = GetBgInfoText()
    elseif event == "MODIFIER_STATE_CHANGED" then
      local state = select(2, ...)
      if state == 1 then
        self:EnableMouse(true)
        self:EnableMouseWheel(true)
      else
        self:StopMovingOrSizing()
        self:EnableMouse(false)
        self:EnableMouseWheel(false)
      end
    elseif event == "PLAYER_LOGIN" then
      playerGUID = UnitGUID("player")
      f:SetFrameLevel(10)
    elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
      updateZoneAndRaidInfo()
      bgInfoString = GetBgInfoText()
      statsInfoString = GetStatsText()
    elseif event == "CHAT_MSG_SYSTEM" then
      local msg = ...
      if msg:find("Server delay: ") or msg:find(SYSMSG_SPAM_ERROR) then
        self.needWaitServerInfo = nil
        serverDelay = tonumber(string.match(msg, "Server delay: (%d+) ms")) or -1
        --print('serverDelay:',serverDelay)
      end
    end
  end)
  
  local text = f:CreateFontString(nil, "background")
  text:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 1)
  --text:SetPoint("LEFT", "ActionButton1", "LEFT", -255, -7)
  --text:SetFont([[Interface\addons\CustomFrames\hooge test1.ttf]], 11, "OUTLINE, MONOCHROME")
  text:SetFont(FONT_NAME, FONT_SIZE)
  text:SetShadowOffset(1, -1)
  text:SetTextColor(1, 1, 1, 1)
  text:SetJustifyH("LEFT")
  text:SetJustifyV("BOTTOM")
  
  f.text = text

  f:SetScript("onupdate", function(self, elapsed)
    self.t = self.t and self.t + elapsed or 0
    if self.t < UPDATE_INTERVAL_GLOBAL then return end
    self.t = 0
    
    self.servInfoTime = self.servInfoTime and self.servInfoTime + UPDATE_INTERVAL_GLOBAL or 0
    if not self.needWaitServerInfo and self.servInfoTime > UPDATE_INTERVAL_SERVER_INFO then
      self.needWaitServerInfo = true
      self.servInfoTime = 0
      --print("server info")
      SendChatMessage(".server info","guild")
    end
    
    local topText = ""

    topText = topText .. "\n" .. GetZoneInfo()

    local RezTimerInfo = GetRezTimerInfo()
    if RezTimerInfo ~= "" then
      topText = topText .. "\n" .. RezTimerInfo
    end
    
    topText = topText .. "\n" ..TimeFormatter:GetFormattedTime()
    
    local particleDensity = tonumber(GetCVar("particleDensity"))*100
    local particle_percent = particleDensity / 100
    
    local particle_r, particle_g, particle_b
    if particle_percent < 0.5 then
      -- Переход от красного (1,0,0) к желтому (1,1,0)
      particle_r = 1
      particle_g = particle_percent * 2  -- От 0 до 1
    else
      -- Переход от желтого (1,1,0) к зеленому (0,1,0)
      particle_r = 2 - (particle_percent * 2) -- От 1 до 0
      particle_g = 1
    end
    
    local particleColor = rgbToHex(particle_r, particle_g, 0)
    
    local latency = select(3, GetNetStats())
    local latencyColor = RGBGradient(latency / 150)
    
    local responce = ns.responceTime or -1
    local responceColor = RGBGradient(responce / 150)
    
    local serverDelayColor = RGBGradient(serverDelay / 150)
    
    local fps = format("%d", GetFramerate())
    local fpsColor = RGBGradient(1 - tonumber(fps) / 60)
    
    topText = topText .. "\nFPS:  |ccc" .. fpsColor .. "" .. fps .. "|r    "..PARTICLES..":  |ccc" .. particleColor .. ""..format("%.0f", particleDensity).."|r"
    
    topText = topText .. "\nLAT:  |ccc" .. latencyColor .. "" .. latency .. "|r    RTT:  |ccc"..responceColor..""..responce.."|r    "..SERV_DELAY..":  |ccc"..serverDelayColor..""..serverDelay.."|r"

    topText = topText .. "\n" .. bgInfoString
    
    topText = topText .. "\n" .. statsInfoString

    local speed = GetUnitSpeed("player") / 7 *100
    local speedColor = RGBGradient(1 - tonumber(speed) / 250)
    if speed == 0 then speedColor = "888888" end
    local speedString = ""..MOVE_SPEED..":  |ccc" .. speedColor .. ""..format("%d", speed).."%|r"
      
    topText = topText.."    "..speedString

    if self:GetValue() ~= particleDensity then
      self:SetValue(particleDensity) 
    end

    if self.text:GetText() ~= topText then
      self.text:SetText(topText)
    end
  end)
  
  -- скрываем спам ".сервер инфо" от аддона и [по возможности] отображаем вывод только по нашему (ручному) запросу в чат
  ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, msg, name, ...)
    if not (msg and name) then return end

    local isServerInfoMsg = 
    msg:find("WoW Circle Wotlk Development 3.3.5a") 
    or msg:find("WoW Circle Core: Last Update") 
    or msg:find("WoW Circle DB: Last Update") 
    or msg:find("Active connections:") 
    or msg:find("Server uptime:") 
    or msg:find("Next arena point distribution time:") 
    or msg:find("Server delay:") 
    or msg:find("WoW Circle Cross Server:")
    --ru
    or msg:find("Игроков онлайн:")
    or msg:find("Продолжительность работы сервера:")
    or msg:find("WoW Circle Cross Server:")
    
    if f.needShowServerInfo then
      if isServerInfoMsg then
        f.needShowServerInfo = f.needShowServerInfo +1
      end
      
      if (InCrossZone and f.needShowServerInfo >=3) or f.needShowServerInfo >= 7 then
        f.needShowServerInfo = nil
      end
    end

    if isServerInfoMsg and not f.needShowServerInfo then
      return true
    end
  end)

  ChatFrame1EditBox:HookScript("onupdate", function(self)
    if self:GetText() and self:GetText() ~= "" then
      self.lastText = self:GetText()
    end
  end)

  ChatFrame1EditBox:HookScript("OnEnterPressed", function(self)
    --print(self.lastText)
    if self.lastText and self.lastText:find(".serv") and self.lastText:find(" in") then
      f.needShowServerInfo = 0
    end
  end)
end












-- тестовая проверка пинга (Response Time / RTT) через SendAddonMessage 
do
  local ADDON_NAME, ns = ...
  
  local ADDON_NAME_META = GetAddOnMetadata(ADDON_NAME, "Title")

  local SECONDS_SEND_ADDON_MESSAGE_INTERVAL = 1
  local SECONDS_RTT_UPDATE_INTERVAL = 0.05
  local SECONDS_GAME_MENU_UPDATE_INTERVAL = 0.2
  local NUM_ADDONS_TO_DISPLAY = 20

  local GameTooltip = GameTooltip
  local MainMenuMicroButton = MainMenuMicroButton
  local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
  local GetAddOnMemoryUsage = GetAddOnMemoryUsage
  local GetAddOnInfo = GetAddOnInfo
  local GetFramerate = GetFramerate
  local SendAddonMessage = SendAddonMessage
  local UnitName = UnitName
  local GetMouseFocus = GetMouseFocus
  local MAINMENUBAR_LATENCY_LABEL = MAINMENUBAR_LATENCY_LABEL
  local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
  local TOTAL_MEM_KB_ABBR = TOTAL_MEM_KB_ABBR
  local NEWBIE_TOOLTIP_MEMORY = NEWBIE_TOOLTIP_MEMORY
  local ADDON_MEM_KB_ABBR = ADDON_MEM_KB_ABBR
  local GetNetStats = GetNetStats
  local UNKNOWN = UNKNOWN
  local playerName = UnitName("player")
  local GetTime = _G.GetTime
  local responceReceivedTime, lastRequestSendTime = 0
  local modf = math.modf
  local format = string.format
  local tostring = _G.tostring
  local select = _G.select
  local unpack = _G.unpack
  
  ns.responceTime = 0

  local f=CreateFrame("frame")
  f:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
  f:RegisterEvent("CHAT_MSG_ADDON")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  
  function f:PLAYER_ENTERING_WORLD()
    ns.responceTime, responceReceivedTime, lastRequestSendTime = 0, 0
  end

  function f:CHAT_MSG_ADDON(...)
    local prefix, text, channel, sender = ...
    
    if prefix == ADDON_NAME..":rtt_test" and lastRequestSendTime and tostring(lastRequestSendTime) == tostring(text) and channel == "WHISPER" and playerName and playerName == sender then
      responceReceivedTime = GetTime()
      ns.responceTime = modf((responceReceivedTime - lastRequestSendTime) *1000)
      lastRequestSendTime = nil
      --print("received, responceTime:", ns.responceTime)
    end
  end

  f.updateValueTime, f.newRequestTime = 0, 0
  
  f:SetScript("onupdate", function(s, e)
    s.updateValueTime = s.updateValueTime + e
    
    if s.updateValueTime < SECONDS_RTT_UPDATE_INTERVAL then return end
    
    if not playerName or playerName == UNKNOWN then
      playerName = UnitName("player")
    end
    
    local _time = GetTime()
    
    s.newRequestTime = s.newRequestTime + s.updateValueTime
    
    if s.newRequestTime > SECONDS_SEND_ADDON_MESSAGE_INTERVAL and responceReceivedTime and playerName and playerName ~= UNKNOWN and playerName ~= "" then
      s.newRequestTime = 0
      responceReceivedTime = nil
      lastRequestSendTime = _time
      --print("sending...")
      SendAddonMessage(ADDON_NAME..":rtt_test", tostring(_time), "WHISPER", playerName)
    end
    
    if lastRequestSendTime then
      local diff = _time - lastRequestSendTime
      if diff > 0 then
        ns.responceTime = modf((_time - lastRequestSendTime) *1000)
        --print("responceTime:", ns.responceTime)
      end
    end
    
    s.updateValueTime = 0
  end)
  
  local gradientColor = { 0, 1, 0, 1, 1, 0, 1, 0, 0 }

  local function ColorGradient(perc, ...)
    if (perc > 1) then
      local r, g, b = select(select("#", ...) - 2, ...)
      return r, g, b
    elseif (perc < 0) then
      local r, g, b = ...
      return r, g, b
    end

    local num = select("#", ...) / 3

    local segment, relperc = modf(perc * (num - 1))
    local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

    if r2 == nil then r2 = 1 end
    if g2 == nil then g2 = 1 end
    if b2 == nil then b2 = 1 end

    return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
  end
  
  local function RGBGradient(num)
    local r, g, b = ColorGradient(num, unpack(gradientColor))
    local hexColor = format("%02x%02x%02x", r * 255, g * 255, b * 255)
    return hexColor
  end

    local topAddOns = {}
    for i=1, NUM_ADDONS_TO_DISPLAY do
      topAddOns[i] = { value = 0, name = "" };
    end
  
    local function GameMenu_OnEnter()
      local mouseFocus = GetMouseFocus()
      if mouseFocus and mouseFocus.GetName and mouseFocus == MainMenuMicroButton and GameTooltip:IsShown() then
        GameTooltip:ClearLines()
        --print("GameMenu_OnEnter")
        
        local string = "";
        local i, j, k = 0, 0, 0;
       
        GameTooltip_SetDefaultAnchor(GameTooltip, MainMenuMicroButton);
        
        GameTooltip_AddNewbieTip(MainMenuMicroButton, MainMenuMicroButton.tooltipText .." [".. ADDON_NAME_META .. "]", 1.0, 1.0, 1.0, MainMenuMicroButton.newbieText);
       
        -- latency
        local bandwidthIn, bandwidthOut, latency = GetNetStats();
        string = format(MAINMENUBAR_LATENCY_LABEL, latency);
        GameTooltip:AddLine("\n");
        GameTooltip:AddLine(string, 1.0, 1.0, 1.0);
        
        if ( SHOW_NEWBIE_TIPS == "1" ) then
          GameTooltip:AddLine(NEWBIE_TOOLTIP_LATENCY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
        end
        
        GameTooltip:AddLine("\n");
       
        -- framerate
        string = format(MAINMENUBAR_FPS_LABEL, GetFramerate());
        GameTooltip:AddLine(string, 1.0, 1.0, 1.0);
        if ( SHOW_NEWBIE_TIPS == "1" ) then
          GameTooltip:AddLine(NEWBIE_TOOLTIP_FRAMERATE, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
        end
       
        -- AddOn mem usage
        for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
          topAddOns[i].value = 0;
        end
       
        UpdateAddOnMemoryUsage();
        
        local totalMem = 0;
       
        for i=1, GetNumAddOns(), 1 do
          local mem = GetAddOnMemoryUsage(i);
          totalMem = totalMem + mem;
          
          for j=1, NUM_ADDONS_TO_DISPLAY, 1 do
            if (mem > topAddOns[j].value) then
              for k=NUM_ADDONS_TO_DISPLAY, 1, -1 do
                if(k == j) then
                  topAddOns[k].value = mem;
                  topAddOns[k].name = GetAddOnInfo(i):gsub("_Atom","HugeDick");
                  break;
                elseif(k ~= 1) then
                  topAddOns[k].value = topAddOns[k-1].value;
                  topAddOns[k].name = topAddOns[k-1].name;
                end
              end
              break;
            end
          end
        end
       
        if ( totalMem > 0 ) then
          local color = RGBGradient(totalMem/40000)
          
          if ( totalMem > 1000 ) then
            totalMem = totalMem / 1000;
            string = format(TOTAL_MEM_MB_ABBR, totalMem);
          else
            string = format(TOTAL_MEM_KB_ABBR, totalMem); 
          end
          
          string = "|cff".. color .. string .. "|r"
       
          GameTooltip:AddLine("\n");
          
          GameTooltip:AddLine(string, 1.0, 1.0, 1.0);
          
          if ( SHOW_NEWBIE_TIPS == "1" ) then
            GameTooltip:AddLine(NEWBIE_TOOLTIP_MEMORY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
          end
          
          local size;
          
          for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
            if ( topAddOns[i].value == 0 ) then
              break;
            end
            
            size = topAddOns[i].value;
            
            color = RGBGradient(size/5000)
            
            if ( size > 1000 ) then
              size = size / 1000;
              string = format(ADDON_MEM_MB_ABBR, size, topAddOns[i].name);
            else
              string = format(ADDON_MEM_KB_ABBR, size, topAddOns[i].name);
            end
            
            GameTooltip:AddLine("|cff989898"..i..".|r |cff"..color..""..string.."|r", 1.0, 1.0, 1.0);
          end
        end
       
        GameTooltip:Show();
      end
    end
  
    local function GameMenu_AddRTT()
      local mouseFocus = GetMouseFocus()
      if mouseFocus and mouseFocus.GetName and mouseFocus:GetName() == "MainMenuMicroButton" then
        for i = 1, GameTooltip:NumLines() do
          local text = _G[GameTooltip:GetName().."TextLeft"..i]:GetText()
          if text and text:find(MAINMENUBAR_LATENCY_LABEL:match("^(.-):")) then
            local _, _, latency = GetNetStats()
            local _string = format(MAINMENUBAR_LATENCY_LABEL, latency)
            local textRegion = _G[GameTooltip:GetName().."TextLeft"..i]
            local color = RGBGradient(ns.responceTime/150)
            textRegion:SetText(_string..", RTT: |cff"..color..""..ns.responceTime.."|r")
            GameTooltip:Show()
            break
          end
        end
      end
    end
  
    -- GameTooltip:HookScript("onshow", function()
      -- GameMenu_AddRTT()
    -- end)
  
    local t = 0
    GameTooltip:HookScript("onupdate", function(_, e)
      t = t + e
      if t < SECONDS_GAME_MENU_UPDATE_INTERVAL then return end
      t = 0
      GameMenu_OnEnter()
      GameMenu_AddRTT()
    end)
    
    hooksecurefunc("MainMenuBarPerformanceBarFrame_OnEnter", function() 
      GameMenu_OnEnter()
      GameMenu_AddRTT()
    end)
end


--[[

-- опции
-- Описание опций (либо ruRU, либо enUS)
local locale = GetLocale()
local optionDescriptions = {}
if locale == "ruRU" then
  optionDescriptions = {
    updateIntervalEdge           = "интервал обновления в секундах",
    corpseResTimer               = "время до реса по телу",
    bgRezTimer                   = "время до реса у духа на БГ",
    bgRezTimerDeadEnemiesCount   = "потенциальное кол-во ресающихся врагов",
    dateTime                     = "день недели, дату, точное время с милисекундами",
    dayOfWeek                    = "день недели",
    date                         = "дата",
    time                         = "время",
    milliseconds                 = "миллисекунды",
    dungDifficulty               = "сложность подземелья",
    pvpFlag                      = "пвп флаг",
    pvpFlagTime                  = "оставшееся время пвп флага (если <5 мин)",
    fps                          = "фпс",
    particleDensity              = "плотность частиц из настроек графики",
    particleDensityBar           = "плотность частиц (статус-бар)",
    latency                      = "задержка (из подсказки меню, обновляется ~30 сек)",
    rtt                          = "RTT — более реальное значение пинга через сообщения аддона",
    delayServerInfo              = "задержка через Server Info (спам каждые 2 сек)",
    bgStats                      = "статистика БГ: игр, побед, винрейт",
    attrStats                    = "характеристики: ап/спд, рес, крит, хаст, хит",
    attackPowerOrSpellPower      = "атака/спелл-урон",
    resilience                   = "резилиенс",
    crit                         = "крит",
    haste                        = "хаст",
    hit                          = "хит",
    armorPenetration             = "пробивание брони",
    armor                        = "броня",
    moveSpeed                    = "скорость передвижения",
  }
else
  optionDescriptions = {
    updateIntervalEdge           = "update interval in seconds",
    corpseResTimer               = "Time left until resurrection by-corpse",
    bgRezTimer                   = "Spirit healer resurrection timer at BG",
    bgRezTimerDeadEnemiesCount   = "Estimated number of enemies about to resurrect",
    dateTime                     = "Day of week, date, and exact time with milliseconds",
    dayOfWeek                    = "Day of the week",
    date                         = "Date",
    time                         = "Time",
    milliseconds                 = "Milliseconds",
    dungDifficulty               = "Dungeon difficulty",
    pvpFlag                      = "PvP flag",
    pvpFlagTime                  = "PvP flag time remaining (if <5 min)",
    fps                          = "FPS",
    particleDensity              = "Particle density from graphics settings",
    particleDensityBar           = "Particle density (status bar)",
    latency                      = "Latency (game menu tooltip, updates ~30 sec)",
    rtt                          = "RTT — more accurate ping using addon messages",
    delayServerInfo              = "Server info latency (spam every 2 sec)",
    bgStats                      = "BG stats: total games, wins, winrate",
    attrStats                    = "Main stats: AP/SP, Resilience, Crit, Haste, Hit",
    attackPowerOrSpellPower      = "Attack Power/Spell Damage",
    resilience                   = "Resilience",
    crit                         = "Crit",
    haste                        = "Haste",
    hit                          = "Hit",
    armorPenetration             = "Armor Penetration",
    armor                        = "Armor",
    moveSpeed                    = "Movement speed",
  }
end




local options =
{
  -- [1] - settingName, [2] - checkboxText, [3] - tooltipText, [4] - значение по умолчанию, [5] - minValue, [6] - maxValue 
  {"corpseResTimer","",nil,true},
  {"bgRezTimer","",nil,true},
  {"bgRezTimerDeadEnemiesCount","",nil,true},
  {"dateTime","",nil,true},
  {"dayOfWeek","",nil,true},
  {"date","",nil,true},
  {"time","",nil,true},
  {"milliseconds","",nil,true},
  {"dungDifficulty","",nil,true},
  {"pvpFlag","",nil,true},
  {"pvpFlagTime","",nil,true},
  {"fps","",nil,true},
  {"particleDensity","",nil,true},
  {"particleDensityBar","",nil,true},
  {"latency","",nil,true},
  {"rtt","",nil,true},
  {"delayServerInfo","",nil,true},
  {"bgStats","",nil,true},
  {"attrStats","",nil,true},
  {"attackPowerOrSpellPower","",nil,true},
  {"resilience","",nil,true},
  {"crit","",nil,true},
  {"haster","",nil,true},
  {"hit","",nil,true},
  {"armorPenetration","",nil,true},
  {"armor","",nil,true},
  {"moveSpeed","",nil,true},
  
  {"updateIntervalEdge","",nil,0.01,0.01,10},
  
  {"secondsSendAddonMessageInterval", "", nil, 1, 0.1, 60},
  {"secondsRTTUpdateInterval", "", nil, 0.05, 0.01, 1},
  {"secondsGameMenuUpdateInterval", "", nil, 0.2, 0.1, 5},
  {"numAddonsToDisplay", "", nil, 20, 1, 100},
  
  -- Дополнительные опции
  {"fontName", "", nil, "Interface\\addons\\"..ADDON_NAME.."\\trebucbd.ttf"},
  {"fontSize", "", nil, 12, 6, 32},
  {"alpha", "", nil, 0.9, 0.1, 1},
  {"updateIntervalServerInfo", "", nil, 2, 1, 30},
  {"forceEnLocale", "", nil, true},
  -- {"","",nil,true},
  -- {"","",nil,true},
}

-- Заполнение описаний в таблицу options
for i, opt in ipairs(options) do
  local key = opt[1]
  -- присваиваем текст описания в поле checkboxText
  opt[2] = optionDescriptions[key] or ""
  -- можно присвоить tooltipText, если нужно:
  -- opt[3] = optionDescriptions[key] or nil
end




function core:UpdateVisual()
  --print("UpdateVisual")
  core.countFrame:Show()
  core.countText:Show()
  core.namesFrame:Show()
  core.namesText:Show()
  
  if not cfg.settings.targetters_names then
    core.namesFrame:Hide()
    core.namesText:Hide()
  end
  
  if not cfg.settings.count_number and not cfg.settings.wanted_level_stars then
    core.countFrame:Hide()
    core.countText:Hide()
  end
end

function core:initConfig()
  if core.init then return true end
  core.init = true
  
  cfg = mrcatsoul_WantedLevel or {}
  
  if cfg.settings == nil then cfg.settings = {} end

  -- [1] - settingName, [2] - checkboxText, [3] - tooltipText, [4] - значение по умолчанию, [5] - minValue, [6] - maxValue  
  for _,v in ipairs(options) do
    if cfg.settings[ v[1] ]==nil then
      cfg.settings[ v[1] ]=v[4]
      print(""..v[1]..": "..tostring(cfg.settings[ v[1] ]).." (задан параметр по умолчанию)")
    end
  end

  if mrcatsoul_WantedLevel == nil then 
    mrcatsoul_WantedLevel = cfg
    cfg = mrcatsoul_WantedLevel
    local t = GetTime()+4
    CreateFrame("frame"):SetScript("OnUpdate", function(self)
      if t<GetTime() then
        PlaySound("RaidWarning")
        RaidNotice_AddMessage(RaidWarningFrame, "|cff33ccff["..ADDON_NAME.."]:|r |cffffffff"..GetAddOnMetadata(ADDON_NAME, "Notes"), ChatTypeInfo["RAID_WARNING"])
        print("|cff33ccff["..ADDON_NAME.."]:|r "..GetAddOnMetadata(ADDON_NAME, "Notes"))
        self:SetScript("OnUpdate", nil)
        self=nil
      end
    end)
  end

  core:UpdateVisual()
  core:CreateOptions()
end

function core:CreateOptions()
  if core.options then return end
  core.options=true
  core.optNum=0
  
  -- вроде отныне не говнокод для интерфейса настроек (27.1.25)
  -- [1] - settingName, [2] - checkboxText, [3] - tooltipText, [4] - значение по умолчанию, [5] - minValue, [6] - maxValue 
  for i,v in ipairs(options) do
    if v[4]~=nil then
      --print(v[1],type(v[4]),v[4])
      if type(v[4])=="boolean" then
        --print(v[1],v[4])
        core:createCheckbox(v[1], v[2], v[3], core.optNum)
        if options[i+1] and type(options[i+1][4])=="number" then
          core.optNum=core.optNum+3
        else
          core.optNum=core.optNum+2
        end
      elseif type(v[4])=="number" then
        --print(v[1])
        core:createEditBox(v[1], v[2], v[3], v[5], v[6], core.optNum)
        if options[i+1] and type(options[i+1][4])=="boolean" then
          core.optNum=core.optNum+1.5
        else
          core.optNum=core.optNum+2
        end
      end
    end
  end
end

--------------------------------------------------------------------------------
-- фрейм прокрутки для фрейма настроек. нужен чтобы прокручивать настройки вверх-вниз
--------------------------------------------------------------------------------
local width, height = 800, 500
local settingsScrollFrame = CreateFrame("ScrollFrame", ADDON_NAME.."SettingsScrollFrame", InterfaceOptionsFramePanelContainer, "UIPanelScrollFrameTemplate")
settingsScrollFrame.name = GetAddOnMetadata(ADDON_NAME, "Title") -- Название во вкладке интерфейса
settingsScrollFrame:SetSize(width, height)
settingsScrollFrame:Hide()
settingsScrollFrame:SetVerticalScroll(10)
settingsScrollFrame:SetHorizontalScroll(10)
_G[ADDON_NAME.."SettingsScrollFrameScrollBar"]:SetPoint("topleft",settingsScrollFrame,"topright",-25,-25)
_G[ADDON_NAME.."SettingsScrollFrameScrollBar"]:SetFrameLevel(1000)
_G[ADDON_NAME.."SettingsScrollFrameScrollBarScrollDownButton"]:SetPoint("top",_G[ADDON_NAME.."SettingsScrollFrameScrollBar"],"bottom",0,7)

--------------------------------------------------------------------------------
-- фрейм настроек который должен быть помещен в фрейм прокрутки
--------------------------------------------------------------------------------
local settingsFrame = CreateFrame("button", nil, InterfaceOptionsFramePanelContainer)
settingsFrame:Hide()
settingsFrame:SetSize(width, height) 
settingsFrame:SetAllPoints(InterfaceOptionsFramePanelContainer)

settingsFrame:RegisterEvent("ADDON_LOADED")
settingsFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
function settingsFrame:ADDON_LOADED(addon)
  if addon==ADDON_NAME then
    core:initConfig()
  end
end

--------------------------------------------------------------------------------
-- связываем скролл-фрейм с фреймом настроек в котором все опции
--------------------------------------------------------------------------------
settingsScrollFrame:SetScrollChild(settingsFrame)

--------------------------------------------------
-- регистрируем фрейм настроек в близ настройках интерфейса (интерфейс->модификации) этой самой функцией 
--------------------------------------------------
InterfaceOptions_AddCategory(settingsScrollFrame)

--------------------------------------------------------------------------------
-- при показе/скрытии скролл-фрейма - показывается/скрывается фрейм настроек
--------------------------------------------------------------------------------
settingsScrollFrame:SetScript("OnShow", function()
  settingsFrame:Show()
end)

settingsScrollFrame:SetScript("OnHide", function()
  settingsFrame:Hide()
end)

--------------------------------------------------------------------------------
-- заголовок фрейма опций
--------------------------------------------------------------------------------
do
  local text = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  text:SetPoint("TOPLEFT", 16, -16)
  text:SetFont(GameFontNormal:GetFont(), 18, 'OUTLINE')
  text:SetText(GetAddOnMetadata(ADDON_NAME, "Title").." v"..GetAddOnMetadata(ADDON_NAME, "Version").."")
  text:SetJustifyH("LEFT")
  text:SetJustifyV("BOTTOM")
  settingsFrame.TitleText = text
end

--------------------------------------------------------------------------------
-- тултип (подсказка) для заголовка фрейма опций
--------------------------------------------------------------------------------
do
  local tip = CreateFrame("button", nil, settingsFrame)
  tip:SetPoint("center",settingsFrame.TitleText,"center")
  tip:SetSize(settingsFrame.TitleText:GetStringWidth()+1,settingsFrame.TitleText:GetStringHeight()+1) -- Измените размеры фрейма настроек ++ 4.3.24
  
  --------------------------------------------------------------------------------
  -- действия при наведении мышкой на тултип
  --------------------------------------------------------------------------------
  tip:SetScript("OnEnter", function(self) -- при наведении мышкой на фрейм чекбокса (маусовер) ...
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:SetText(""..GetAddOnMetadata(ADDON_NAME, "Title").." v"..GetAddOnMetadata(ADDON_NAME, "Version").."\n\n"..GetAddOnMetadata(ADDON_NAME, "Notes").."", nil, nil, nil, nil, true)
    GameTooltip:Show() -- ... появится подсказка
  end)

  tip:SetScript("OnLeave", function(self) -- при снятии фокуса мышки с фрейма чекбокса ... 
    GameTooltip:Hide() -- ... подсказка скроется
  end)
end

---------------------------------------------------------------
-- функция создания чекбоксов. так как их будет много - нужно будет спамить её по кд
---------------------------------------------------------------
function core:createCheckbox(settingName,checkboxText,tooltipText,optNum) -- offsetY отступ от settingsFrame.TitleText
  local checkBox = CreateFrame("CheckButton",ADDON_NAME.."_"..settingName,settingsFrame,"UICheckButtonTemplate") -- фрейм чекбокса
  checkBox:SetPoint("TOPLEFT", settingsFrame.TitleText, "BOTTOMLEFT", 0, -10-(optNum*10))
  checkBox:SetSize(28,28)
  
  local textFrame = CreateFrame("Button",nil,checkBox) 
  textFrame:SetPoint("LEFT", checkBox, "RIGHT", 0, 0)

  local textRegion = textFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  textRegion:SetText(checkboxText)
  
  textRegion:SetJustifyH("LEFT")
  textRegion:SetJustifyV("BOTTOM")
  
  textRegion:SetAllPoints(textFrame)
  
  textFrame:SetSize(textRegion:GetStringWidth(),textRegion:GetStringHeight()) 
  textFrame:SetPoint("LEFT", checkBox, "RIGHT", 0, 0)
  
  checkBox:SetScript("OnClick", function(self) -- по клику по фрейму проставляется настройка, чекбокс
    cfg.settings[settingName] = checkBox:GetChecked() and true or false
    core:UpdateVisual()
  end)
  
  textFrame:SetScript("OnClick", function(self) -- по клику по фрейму проставляется настройка, текст
    if checkBox:GetChecked() then
      checkBox:SetChecked(false)
    else
      checkBox:SetChecked(true)
    end
    cfg.settings[settingName] = checkBox:GetChecked() and true or false
    core:UpdateVisual()
  end)
  
  textFrame:SetScript("OnShow", function(self)
    self:SetSize(textRegion:GetStringWidth()+1,textRegion:GetStringHeight())
  end)
  
  checkBox:SetScript("OnShow", function(self) 
    self:SetChecked(cfg.settings[settingName])
  end)
  
  checkBox:SetScript("OnEnter", function(self) -- при наведении мышкой на фрейм чекбокса (маусовер) ...
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(tooltipText or checkboxText, 1, 1, 1, nil, true)
    GameTooltip:Show() -- ... появится подсказка
  end)
  
  checkBox:SetScript("OnLeave", function(self) -- при снятии фокуса мышки с фрейма чекбокса ...
    GameTooltip:Hide() -- ... подсказка скроется
  end)
  
  textFrame:SetScript("OnEnter", function(self) -- при наведении мышкой на фрейм текста (маусовер) ...
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:SetText(tooltipText or checkboxText, 1, 1, 1, nil, true)
    GameTooltip:Show() -- ... появится подсказка
  end)
  
  textFrame:SetScript("OnLeave", function(self) -- при снятии фокуса мышки с фрейма текста ...
    GameTooltip:Hide() -- ... подсказка скроется
  end)
end




]]
