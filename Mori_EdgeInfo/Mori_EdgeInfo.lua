local ADDON_NAME, ns = ...
local cfg, gcfg = {}, {}

-- инфа левый нижний угол
do  
  local ADDON_NAME, ns = ...
  
  local FONT_NAME = "Interface\\addons\\"..ADDON_NAME.."\\PTSansNarrow.ttf"
  --local FONT_NAME = "Interface\\addons\\"..ADDON_NAME.."\\trebucbd.ttf"
  local FONT_SIZE = 11
  local ALPHA = 0.9

  local PARTICLE_DENSITY_BAR_MIN_WIDTH = 50
  local PARTICLE_DENSITY_BAR_MIN_HEIGHT = 7
  local UPDATE_INTERVAL_GLOBAL = 0.025
  local UPDATE_INTERVAL_SERVER_INFO = 5
  local FORCE_EN_LOCALE = true
  
  local L = FORCE_EN_LOCALE and "enUS" or GetLocale()
  local PARTICLES = L=="ruRU" and "Частицы" or "PARTICLES"
  local SERV_DELAY = L=="ruRU" and "Серв. зад" or "SERV"
  local GAMES = L=="ruRU" and "Игр" or "GAMES"
  local WINS = L=="ruRU" and "Побед" or "WINS"
  local WINRATE = L=="ruRU" and "Винрейт" or "WR"
  local ATTACK_POWER = L=="ruRU" and "Ап" or "AP"
  local SPELL_POWER = L=="ruRU" and "Спд" or "SPD"
  local RES = L=="ruRU" and "Уст" or "RSL"
  local CRIT = L=="ruRU" and "Крит" or "CRT"
  local HASTE = L=="ruRU" and "Скор" or "HST"
  local HIT = L=="ruRU" and "Метк" or "HIT"
  local MOVE_SPEED = L=="ruRU" and "Ск. движ" or "MOV"
  local TO_RES = L=="ruRU" and "До реса" or "RES"
  local BY_CORPSE = L=="ruRU" and "по телу" or "CORPSE"
  local TO_RES_BY_CORPSE = L=="ruRU" and "Рес по телу" or "RES CORPSE"
  local ENEMIES = L=="ruRU" and "врагов реснется" or "DEAD ENMS"
  local READY = L=="ruRU" and "готов" or "ready"
  local RATING = L=="ruRU" and "Бг очки" or "PTS"
  local SYSMSG_SPAM_ERROR = L=="ruRU" and "Команда не может быть обработана в текущий момент" or "This command cann't be processed now"
  local MAP = L=="ruRU" and "Карта" or "MAP"
  local TIME = L=="ruRU" and "Время" or "TIME"
  
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
  local UnitArmor = UnitArmor
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
  local UnitCastingInfo = UnitCastingInfo
  local UnitChannelInfo = UnitChannelInfo
  local GetNumWhoResults = GetNumWhoResults
  local SendWho = SendWho
  local GetPlayerMapPosition = GetPlayerMapPosition
  local _G = _G
  local format = _G.format
  local select = _G.select
  local tonumber = _G.tonumber
  local tostring = _G.tostring
  local unpack = _G.unpack
  local pairs, ipairs = _G.pairs, _G.ipairs
  local floor = _G.floor
  local max = _G.max
  local min = _G.min
  local modf = _G.math.modf
  local abs = _G.math.abs
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
  
  local LOCALE = GetLocale()
  local ADDON_NAME_LOCALE = LOCALE=="ruRU" and GetAddOnMetadata(ADDON_NAME,"Title-ruRU") or GetAddOnMetadata(ADDON_NAME,"Title") or ADDON_NAME
  local ADDON_NAME_LOCALE_SHORT = LOCALE=="ruRU" and GetAddOnMetadata(ADDON_NAME,"TitleS-ruRU") or GetAddOnMetadata(ADDON_NAME,"TitleShort") or ADDON_NAME_LOCALE
  local ADDON_NOTES = LOCALE=="ruRU" and GetAddOnMetadata(ADDON_NAME,"Notes-ruRU") or GetAddOnMetadata(ADDON_NAME,"Notes") or UNKNOWN
  local ADDON_VERSION = GetAddOnMetadata(ADDON_NAME,"Version") or UNKNOWN

  local playerGUID = UnitGUID("player")
  
  local InDungeon, InRaidDungeon, InBg, InArena, InRaidGroup, spectatorMode, instanceDifficulty, zonePvpType, showAttackPower, showSpellPower, curZone, zoneColor, InCrossZone, isHunter
  local UNIT_SPELLCAST_SENT, UNIT_SPELLCAST_SUCCEEDED = {}, {}
  local serverDelay, serverUptime, activeConnections, NumWhoResults = 0, "-", 0, 0
  local statsInfoString, bgInfoString, zoneInfoString = "", "", ""
  local RezTimer_Data, bg_statistics = _G.RezTimer_Data, _G.bg_statistics
  local x_GameTime = _G.x_GameTime
  
  local cfg = mrcatsoul_Mori_EdgeInfo_Data or {}
  
  local DelayedCall
  do
    local f = CreateFrame("frame")
    local calls = {} 
    local function OnUpdate(self, elapsed)
      for i, call in ipairs(calls) do
        call.time = call.time + elapsed
        if call.time >= call.delay then
          call.func()
          tremove(calls, i) 
        end
      end
    end
    f:SetScript("OnUpdate", OnUpdate)
    DelayedCall = function(delay, func)
      tinsert(calls, { delay = delay, time = 0, func = func })
    end
  end
  
  do
    local GetGameTime, GetTime = GetGameTime, GetTime

    x_GameTime = {
      -----------------------------------------------------------
      -- function <PREFIX>_GameTime:Get()
      --
      -- Return game time as (h,m,s) where s has 3 decimals of
      -- precision (though it's only likely to be precise down
      -- to ~20th of seconds since we're dependent on frame
      -- refreshrate).
      --
      -- During the first minute of play, the seconds will
      -- consistenly be "00", since we haven't observed any
      -- minute changes yet.
      --
      --

      Get = function(self)
        if(self.LastMinuteTimer == nil) then
          local h,m = GetGameTime()
          return h,m,0
        end
        local s = GetTime() - self.LastMinuteTimer
        local ms = tonumber(tostring(s):match("%.(%d?%d?%d?)"))
        s = tonumber(format("%d", s))
        print(s,ms)
        if(s>59.999) then
          s=59.999
        end
        return self.LastGameHour, self.LastGameMinute, s, ms
      end,

      -----------------------------------------------------------
      -- function <PREFIX>_GameTime:OnUpdate()
      --
      -- Called by: Private frame <OnUpdate> handler
      --
      -- Construct high precision server time by polling for
      -- server minute changes and remembering GetTime() when it
      -- last did
      --

      OnUpdate = function(self)
        local h,m = GetGameTime()
        if(self.LastGameMinute == nil) then
          self.LastGameHour = h
          self.LastGameMinute = m
          return
        end
        if(self.LastGameMinute == m) then
          return
        end
        self.LastGameHour = h
        self.LastGameMinute = m
        self.LastMinuteTimer = GetTime()
      end,

      -----------------------------------------------------------
      -- function <PREFIX>_GameTime:Initialize()
      --
      -- Create frame to pulse OnUpdate() for us
      --

      Initialize = function(self)
        self.Frame = CreateFrame("Frame")
        self.Frame:SetScript("OnUpdate", function() self:OnUpdate() end)
      end
    }

    x_GameTime:Initialize()
  end
  
  FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE") 
  -- WhoFrameWhoButton:HookScript("onclick", function(self, button)
    -- WhoList_Update()
  -- end)
  
  SetWhoToUI(1)
  
  WhoFrame:HookScript("OnShow", function(self)
    FriendsFrame:RegisterEvent("WHO_LIST_UPDATE")
    print("RegisterEvent(\"WHO_LIST_UPDATE\")")
  end)
  
  WhoFrame:HookScript("OnHide", function(self)
    FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
    print("UnregisterEvent(\"WHO_LIST_UPDATE\")")
  end)
  
  local function tLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end
  
  -- local function rgbToHex(r, g, b)
    -- return format("%02x%02x%02x", floor(255 * r), floor(255 * g), floor(255 * b))
  -- end
  
  local function rgbToHex(r, g, b)
    return format("%02x%02x%02x", r*255, g*255, b*255)
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
  
  -- ОПТИМИЗАЦИЯ ЦВЕТА: Кэширование результата RGBGradient
  -- Вычисляет цвет только если значение изменилось
  local colorCache = {}
  local function GetCachedColor(key, value, divisor)
    -- value - текущее значение (число)
    -- divisor - на что делить для градиента (150 для пинга, 60 для фпс и т.д.)
    local cache = colorCache[key]
    if not cache then
       cache = { val = -1, color = "ffffff" }
       colorCache[key] = cache
    end
    
    -- Если значение то же самое, возвращаем старый цвет (экономим проц и память)
    if cache.val == value then
        return cache.color
    end
    
    local ratio = value / divisor
    -- Ограничиваем от 0 до 1
    if ratio > 1 then ratio = 1 elseif ratio < 0 then ratio = 0 end
    
    -- Для некоторых значений логика инвертирована (FPS, Скорость)
    if key == "fps" or key == "speed" then 
        ratio = 1 - ratio 
    end
    
    cache.val = value
    cache.color = RGBGradient(ratio)
    return cache.color
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
  -- local function formatTime(seconds)
    -- local minutes = floor(seconds / 60)
    -- local remainingSeconds = floor(seconds % 60)

    -- if minutes == 0 then
      -- return format("%ds", remainingSeconds)
    -- elseif remainingSeconds == 0 then
      -- return format("%dm", minutes)
    -- else
      -- return format("%dm %ds", minutes, remainingSeconds)
    -- end
  -- end
  --_G.FormatTime_MinSec = formatTime
  
  local function formatTime(time)
    if time >= 60 then
      return format("%.1dm %.2ds", floor(time / 60), time % 60)
    else
      return format("%.1ds", time)
    end
  end
  
  -- милисекунды
  local TimeFormatter = {}

  function TimeFormatter:GetFormattedTime()
    if not self.timeOffset then
      self.timeOffset = time() - floor(GetTime())
    end

    local now = GetTime()
    local seconds = floor(now)
    local milliseconds = floor((now - seconds) * 1000)
    local fullTime = self.timeOffset + seconds
    
    return date("%A  %d.%m.%Y  %H:%M:%S", fullTime) .. format(".%03d", milliseconds)
  end
  _G.GetFormattedTime = TimeFormatter.GetFormattedTime 
   
  -- Создаем статус-бар
  local f = CreateFrame("StatusBar", ADDON_NAME.."_ParticleDensityBar_Frame", UIParent)
  f:SetClampedToScreen(true)
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

  --f:RegisterForDrag("LeftButton")
  
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
    --_G.InCrossZone = InCrossZone
    --print("InCrossZone",_G.InCrossZone)
    
    if (InRaidDungeon and not InRaidGroup) or (InArena and UnitHealthMax("player") < 3000) then
      spectatorMode = true
    end
    
    playerGUID = UnitGUID("player")
    showSpellPower = IsSpellPowerClass() or IsHealerClass()
    showAttackPower = IsMeleeClass()
    isHunter = select(2, UnitClass("player")) == "HUNTER"
    
    wipe(UNIT_SPELLCAST_SENT)
    wipe(UNIT_SPELLCAST_SUCCEEDED)
  end

  local function GetRezTimerInfo()
    local text, CorpseRecoveryDelay = ""
   
    if InBg then
      local secondsToRes = RezTimer_Data and RezTimer_Data.cd
      
      if secondsToRes then
        text = text .. TO_RES .. ": |cffff8822" .. secondsToRes .. "|r"
        if UnitIsDeadOrGhost("player") then
          CorpseRecoveryDelay = GetCorpseRecoveryDelay()
          if CorpseRecoveryDelay > 0 then
            text = text .. "   " .. BY_CORPSE .. ": |cffff8822" .. formatTime(CorpseRecoveryDelay) .. "|r"
          else
            text = text .. "   " .. BY_CORPSE .. ": |cff33ff33" .. READY .. "|r"
          end
        end
      else
        if UnitIsDeadOrGhost("player") then
          CorpseRecoveryDelay = GetCorpseRecoveryDelay()
          if CorpseRecoveryDelay > 0 then
            text = text .. TO_RES_BY_CORPSE .. ": |cffff8822" .. formatTime(CorpseRecoveryDelay) .. "|r"
          else
            text = text .. TO_RES_BY_CORPSE .. ": |cff33ff33" .. READY .. "|r"
          end
        end
      end
      
      if RezTimer_Data and RezTimer_Data.counter then
        text = text .. "   "..ENEMIES..": |cffff6622" .. RezTimer_Data.counter .. "|r"
      end
    elseif UnitIsDeadOrGhost("player") then
      CorpseRecoveryDelay = GetCorpseRecoveryDelay()
      if CorpseRecoveryDelay > 0 then
        text = text .. TO_RES_BY_CORPSE .. ": |cffff8822" .. formatTime(CorpseRecoveryDelay) .. "|r"
      else
        text = text .. TO_RES_BY_CORPSE .. ": |cff33ff33" .. READY .. "|r"
      end
    end
    
    return text
  end
  
  local function truncate(num, digits)
    local mult = 10 ^ (digits or 1)
    return floor(num * mult) / mult
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
    local bgstats = bg_statistics and bg_statistics[playerGUID]
    
    local winsTest, bgPts, gamesTest, winrateTest, wrColorTest, gamesTtl, winsTtl, winRateTtl, wrColorTtl
    
    if bgstats then
      bgPts = bgstats.rating or 0
      winsTest = bgstats.wins or 0
      gamesTest = bgstats.games or 0
      
      if gamesTest > 0 then
        winrateTest = gamesTest > 0 and truncate(winsTest / gamesTest *100) or 0
        wrColorTest = gamesTest > 0 and RGBGradient(1 - (winsTest / gamesTest *100) / 100) or "999999"
        winrateTest = "|ccc" .. wrColorTest .. winrateTest .. "|r"
      end
    else
      gamesTtl = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_PLAYED)) or 0
      winsTtl = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_WON)) or 0
      winRateTtl = gamesTtl > 0 and truncate(winsTtl / gamesTtl *100) or 0
      wrColorTtl = gamesTtl > 0 and RGBGradient(1 - (winsTtl / gamesTtl *100) / 100) or "999999"
    end

    local winsStr = bgstats and 
      "" .. WINS .. ": |cccf1f1a1" .. winsTest .. "|r" or 
      winsTtl and "" .. WINS .. ": |cccf1f1a1" .. winsTtl .. "|r"
    
    local gamesStr = bgstats and 
      "" .. GAMES .. ": |cccf1f1a1" .. gamesTest .. "|r" or
      gamesTtl and "" .. GAMES .. ": |cccf1f1a1" .. gamesTtl .. "|r"
    
    local winRateStr = winrateTest and 
      "" .. WINRATE .. ": |ccc" .. wrColorTest .. winrateTest .. "|r" or
      winRateTtl and "" .. WINRATE .. ": |ccc" .. wrColorTtl .. winRateTtl .."|r"
    
    local text = gamesStr .. "   " .. winsStr
    text = winRateStr and text .. "    " .. winRateStr or text
    
    if bgPts then
      text = text .. "   "..RATING..": " .. bgPts
    end
    
    return text
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
      hexcolor = RGBGradient(1 - spdOrAp / 12000)
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
    
    local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player")
    local armorColor
    if posBuff ~= 0 then 
      armorColor = "00f100"
    elseif negBuff ~= 0 then
      armorColor = "f10000"
    else
      armorColor = "f1f1a1"
    end

    if InDungeon then 
      if showAttackPower then
        text = text .. ": |cff" ..hexcolor .."" ..spdOrAp .."|r    "..CRIT..": |cff" ..hexcolorCrit .."" .. truncate(crit) .. "|r    "..HASTE..": |cff" .. hexcolorHaste .. "" ..truncate(haste) .. "|r    "..HIT..": |cff" .. hexHitColor .. ""..truncate(hit).."|r    ARM: |cff" .. armorColor .. ""..armor.."|r"
      elseif showSpellPower then
        text = text .. ": |cff" ..hexcolor .."" ..spdOrAp .."|r    "..CRIT..": |cff" ..hexcolorCrit .."" .. truncate(crit) .. "|r    "..HASTE..": |cff" .. hexcolorHaste .. "" ..truncate(haste) .. "|r    "..HIT..": |cff" .. hexHitColor .. ""..truncate(hit).."|r"
      else
        text = text .. ": |cff" ..hexcolor .."" ..spdOrAp .."|r    "..CRIT..": |cff" ..hexcolorCrit .."" .. format("%.0f", crit) .. "|r    "..HASTE..": |cff" .. hexcolorHaste .. "" ..truncate(haste) .. "|r    "..HIT..": |cff" .. hexHitColor .. ""..truncate(hit).."|r    ARM: |cff" .. armorColor .. ""..armor.."|r"
      end
    else
      if showAttackPower then 
        text = text .. ": |cff" ..hexcolor .."" ..spdOrAp .."|r    "..RES..": |cff"..resColor..""..res.."|r    PAR: |cfff1f1a1" .. truncate(GetParryChance(),1) .. "|r    ARM: |cff" .. armorColor .. ""..armor.."|r"
      elseif showSpellPower then
        text = text .. ": |cff" ..hexcolor .."" ..spdOrAp .."|r    "..RES..": |cff"..resColor..""..res.."|r    "..CRIT..": |cff" ..hexcolorCrit .."" .. truncate(crit) .. "|r    "..HASTE..": |cff" .. hexcolorHaste .. "" ..truncate(haste) .. "|r    "..HIT..": |cff" .. hexHitColor .. ""..truncate(hit).."|r"
      else
        text = text .. ": |cff" ..hexcolor .."" ..spdOrAp .."|r    "..RES..": |cff"..resColor..""..res.."|r    "..CRIT..": |cff" ..hexcolorCrit .."" .. format("%.0f", crit) .. "|r    "..HASTE..": |cff" .. hexcolorHaste .. "" ..truncate(haste) .. "|r    "..HIT..": |cff" .. hexHitColor .. ""..truncate(hit).."|r    ARM: |cff" .. armorColor .. ""..armor.."|r"
      end
    end
    
    return text
  end
  
  local function GetZoneInfo()
    local _instanceDifficulty = instanceDifficulty and (" |ccc" .. zoneColor .. "("..instanceDifficulty..")|r") or ""
    local _spectatorMode = spectatorMode and ("  [spectator]") or ""
    
    local PVPTimer = GetPVPTimer() / 1000
    local pvpOn = UnitIsPVP("player")
    local pvpInfo = pvpOn and ("|cffff0000PvP|r") or ""
    
    local x, y = GetPlayerMapPosition("player")
    x, y = floor(x * 1000 + 0.5) / 10, floor(y * 1000 + 0.5) / 10
    
    if pvpOn and PVPTimer > 0 then
      if PVPTimer < 300 then
        pvpInfo = pvpInfo .. " "..formatTime(PVPTimer)..""
      end
    end
    
    zoneInfoString = ""..MAP..": |ccc" .. zoneColor .. curZone .. "|r".._instanceDifficulty.."".._spectatorMode.."  "..x..", "..y.."  "..pvpInfo..""

    return zoneInfoString
  end

  local SpellUseDelay, SpellUseDelaySpell = "-"
  
  local function GetSpellUseDelay()
    if tLength(UNIT_SPELLCAST_SENT) > 0 then
      for spell, time in pairs(UNIT_SPELLCAST_SENT) do
        if UNIT_SPELLCAST_SUCCEEDED[spell] then
          SpellUseDelay = UNIT_SPELLCAST_SUCCEEDED[spell] - time
          UNIT_SPELLCAST_SENT[spell] = nil
          UNIT_SPELLCAST_SUCCEEDED[spell] = nil
          SpellUseDelaySpell = spell
          --print("UNIT_SPELLCAST_SUCCEEDED",spell," = nil")
        else
          SpellUseDelay = GetTime() - time
        end
        SpellUseDelay = modf(SpellUseDelay*1000)
        break
      end
    end
    return SpellUseDelay, SpellUseDelaySpell
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
  f:RegisterEvent("WHO_LIST_UPDATE")
  
  f:RegisterEvent("UNIT_ATTACK_POWER")
  f:RegisterEvent("UNIT_RANGED_ATTACK_POWER")
  f:RegisterEvent("UNIT_STATS")
  f:RegisterEvent("UNIT_RANGEDDAMAGE")
  f:RegisterEvent("UNIT_DAMAGE")
  f:RegisterEvent("UNIT_RESISTANCES")
  
  f:RegisterEvent("UNIT_SPELLCAST_SENT")
  f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  f:RegisterEvent("UNIT_SPELLCAST_START")
  f:RegisterEvent("UNIT_SPELLCAST_FAILED")
  
  f:RegisterEvent("PLAYER_DAMAGE_DONE_MODS")
  --f:RegisterEvent("SKILL_LINES_CHANGED")
  
  f:RegisterEvent("UNIT_ATTACK") -- 10.10.25
  f:RegisterEvent("UNIT_ATTACK_SPEED") -- 10.10.25
  --"UNIT_DAMAGE" or event == "PLAYER_DAMAGE_DONE_MODS" or event == "UNIT_ATTACK_SPEED" or event == "UNIT_RANGEDDAMAGE" or event == "UNIT_ATTACK" or event == "UNIT_STATS" or event == "UNIT_RANGED_ATTACK_POWER"
  
  f:SetScript("OnEvent", function(self, event, ...)
    if ( event == "UNIT_ATTACK_POWER"
      or event == "UNIT_RANGED_ATTACK_POWER"
      or event == "UNIT_STATS"
      or event == "UNIT_RANGEDDAMAGE"
      or event == "UNIT_DAMAGE"
      or event == "UNIT_ATTACK"
      or event == "UNIT_ATTACK_SPEED"
      or event == "UNIT_RESISTANCES"
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
        --x_GameTime = _G.x_GameTime
      elseif ... == ADDON_NAME then
        cfg = mrcatsoul_Mori_EdgeInfo_Data or cfg
        mrcatsoul_Mori_EdgeInfo_Data = cfg
        cfg.fontSize = cfg.fontSize or FONT_SIZE
        f.text:SetFont(FONT_NAME, cfg.fontSize) 
      end
    elseif event == "UPDATE_BATTLEFIELD_STATUS" then
      bgInfoString = GetBgInfoText()
    elseif event == "MODIFIER_STATE_CHANGED" then
      local key, state = ...
      if state == 1 then
        self:EnableMouse(true)
        self:EnableMouseWheel(true)
        if key:find("SHIFT") then
          SetWhoToUI(0)
          --FriendsFrame:RegisterEvent("WHO_LIST_UPDATE")
        end
      else
        if key:find("SHIFT") then
          SetWhoToUI(1)
          --FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
        end
        self:StopMovingOrSizing()
        self:EnableMouse(false)
        self:EnableMouseWheel(false)
      end
    elseif event == "PLAYER_LOGIN" then
      playerGUID = UnitGUID("player")
      f:SetFrameLevel(10)
    elseif event == "PLAYER_ENTERING_WORLD" then
      updateZoneAndRaidInfo()
      SetWhoToUI(1)
      f.SYSMSG_SPAM_ERROR = nil
      bgInfoString = GetBgInfoText()
      statsInfoString = GetStatsText()
      activeConnections = "-"
      serverDelay = "-"
      serverUptime = "-"
      NumWhoResults = "-"
      ns.responceTime = "-"
      SpellUseDelay = "-"
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
      updateZoneAndRaidInfo()
    elseif event == "CHAT_MSG_SYSTEM" then
      local msg = ...
      if msg:find(SYSMSG_SPAM_ERROR) then
        self.needWaitServerInfo = nil
        if f.needShowServerInfo and f.needShowServerInfo == 0 then
          f.SYSMSG_SPAM_ERROR = true
          print("["..GetAddOnMetadata(ADDON_NAME, "Title").."]: |cffff7733Сообщение об ошибке от сервера при ручной отправке server info. Ждём 1 сек и траим отправить server info ещё раз из аддона.|r")
          DelayedCall(1, function()
            print("["..GetAddOnMetadata(ADDON_NAME, "Title").."]: |cff00ffaaОтправляем...|r")
            SendChatMessage(".server info", "guild")
          end)
        end
      elseif msg:find("Server delay: ") then
        serverDelay = tonumber(string.match(msg, "Server delay: (%d+) ms")) or -1
        --print('serverDelay:',serverDelay)
      elseif msg:find("Server uptime: ") then
        self.needWaitServerInfo = nil
        local s = msg:lower()

        local h = s:match("(%d+)%s*hours?") or s:match("(%d+)%s*hour")
        local m = s:match("(%d+)%s*minutes?") or s:match("(%d+)%s*minute")
        local sec = s:match("(%d+)%s*seconds?") or s:match("(%d+)%s*second")

        h = tonumber(h) or 0
        m = tonumber(m) or 0
        sec = tonumber(sec) or 0

        if h > 0 then
          serverUptime = string.format("%dh %02dm %02ds", h, m, sec)
        elseif m > 0 then
          serverUptime = string.format("%dm %02ds", m, sec)
        else
          serverUptime = string.format("0:%02ds", sec)
        end
      elseif msg:find("Active connections: ") then
        activeConnections = msg:match("Active connections:%s+(%d+)")
        --print(activeConnections) 
      end
    elseif event == "UNIT_SPELLCAST_SENT" and not (UnitCastingInfo("player") or UnitChannelInfo("player")) then
      local unit, spell = ...
      if unit == "player" and not UNIT_SPELLCAST_SENT[spell] then
        --print(event, unit, spell)
        UNIT_SPELLCAST_SENT[spell] = GetTime()
      end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_FAILED" then
      local unit, spell = ...
      if unit == "player" and UNIT_SPELLCAST_SENT[spell] and not UNIT_SPELLCAST_SUCCEEDED[spell] then
        --print(event, unit, spell)
        UNIT_SPELLCAST_SUCCEEDED[spell] = GetTime()
      end
    elseif event == "WHO_LIST_UPDATE" then
      NumWhoResults = select(2, GetNumWhoResults())
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
  --text:SetJustifyV("BOTTOM")
  
  f.text = text

  local smooth_data = {}

  local function GetSmoothedValue(key, targetVal)
    local target = tonumber(targetVal)
    if not target then
      smooth_data[key] = nil
      return targetVal
    end
    
    if not smooth_data[key] then
      smooth_data[key] = target
      return target
    end
    
    local current = smooth_data[key]
    local diff = target - current
    
    if abs(diff) < 0.1 then
      smooth_data[key] = target
      return target
    end

    -- ЛОГИКА:
    -- Мы хотим, чтобы всё изменение происходило, допустим, за 0.5 секунды.
    -- Число шагов за это время = (секунды / интервал_обновления).
    -- В твоем случае: 0.5 / 0.025 = 20 шагов.
    
    local duration = 0.1 -- время полной анимации в секундах
    local numSteps = duration / min(cfg.UPDATE_INTERVAL_GLOBAL or UPDATE_INTERVAL_GLOBAL, duration)
    
    -- Чтобы скорость была пропорциональна разнице (плавное затухание):
    local step = diff / numSteps
    
    -- Гарантируем минимальный сдвиг, чтобы анимация не "залипала" на целых числах
    if abs(step) < 0.05 then
      step = (diff > 0) and 0.1 or -0.1
    end
    
    current = current + step
    smooth_data[key] = current
    
    return floor(current + 0.5)
  end
  
  f:SetScript("onupdate", function(self, elapsed)
    local update_interval_global = cfg.UPDATE_INTERVAL_GLOBAL or UPDATE_INTERVAL_GLOBAL
    self.t = self.t and self.t + elapsed or update_interval_global
    if self.t < update_interval_global then return end
    self.t = 0
    
    self.servInfoTime = self.servInfoTime and self.servInfoTime + update_interval_global or UPDATE_INTERVAL_SERVER_INFO
    
    if not self.needWaitServerInfo and self.servInfoTime > UPDATE_INTERVAL_SERVER_INFO then
      self.needWaitServerInfo = true
      self.servInfoTime = 0
      --print("server info")
      SendChatMessage(".server info","guild")
      if not (WhoFrameEditBox:IsVisible() and WhoFrameEditBox:GetText() ~= "") and not IsShiftKeyDown() then
        SendWho("")
      end
    end
    
    -- === СБОР ДАННЫХ ===
    
    -- 1. Зона (кэшированная)
    local zoneStr = GetZoneInfo()
    
    -- 2. Таймер реса
    local rezStr = GetRezTimerInfo()

    -- 3. Время (быстрое обновление)
    local timeStr = "|cccf1f1a1" .. TimeFormatter:GetFormattedTime() .. "|r"
    local realmTimeStr = ""
    if x_GameTime then
      local h, m, s, ms = x_GameTime:Get()
      if ms then 
        realmTimeStr = format("    REALM: |cccf1f1a1%02d:%02d:%02d.%03d|r", h, m, s, ms)
      else
        realmTimeStr = format("    REALM: |cccf1f1a1%02d:%02d|r", h, m)
      end
    end
    
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
    
    -- 4. Частицы
    --local rawDensity = tonumber(GetCVar("particleDensity"))*100
    --print(rawDensity)
    --local particleColor = GetCachedColor("particle", rawDensity, 50) -- 50 середина, логика чуть упрощена для скорости
    --if rawDensity < 50 then particleColor = rgbToHex(rawDensity/50, 1, 0) end -- Кастомная логика для частиц
    local particleColor = rgbToHex(particle_r, particle_g, 0)
    
    -- 5. Сглаженные статы
    local latency = GetSmoothedValue("latency", select(3, GetNetStats()))
    local latColor = GetCachedColor("latency", latency, 150)
    
    local responce = GetSmoothedValue("responce", ns.responceTime)
    local respColor = tonumber(responce) and GetCachedColor("responce", responce, 150) or "f1f1a1"
    
    local connections = GetSmoothedValue("connections", activeConnections)
    local whoResults = GetSmoothedValue("who", NumWhoResults)
    
    local srvDelayVal = GetSmoothedValue("srvDelay", serverDelay)
    local srvDelayColor = tonumber(srvDelayVal) and GetCachedColor("srvDelay", srvDelayVal, 150) or "f1f1a1"
    
    local fps = GetFramerate()
    local fpsColor = GetCachedColor("fps", fps, 60)
    
    -- Spell Delay
    local spellDelay, spell = GetSpellUseDelay()
    spellDelay = GetSmoothedValue("spellDelay", spellDelay)
    local spellDelayColor = tonumber(spellDelay) and GetCachedColor("spell", spellDelay, 150) or "f1f1a1"
    if spell then
        local spellIcon = select(3, GetSpellInfo(spell))
        if spellIcon then 
            spellDelay = spellDelay .. " |T" .. spellIcon .. ":"..(FONT_SIZE+1).."|t"
        end
    end

    -- 6. Скорость
    local speed = GetUnitSpeed("player") / 7 * 100
    local speedColor = GetCachedColor("speed", speed, 250)
    if speed == 0 then speedColor = "888888" end

    -- === СБОРКА СТРОКИ (Единый format для экономии памяти) ===
    
    -- Собираем строку "блоками", чтобы избежать множества '..'
    -- Блок 1: Верх (Зона, Рес, Время)
    local topBlock = zoneStr
    if rezStr ~= "" then topBlock = topBlock .. "\n" .. rezStr end
    topBlock = topBlock .. "\n"..TIME..": " .. timeStr .. realmTimeStr
    
    -- Блок 2: Технические статы (FPS, Particles, PL)
    local techBlock = format("\nFPS: |ccc%s%d|r    %s: |ccc%s%d|r    PL(SRV): |cccf1f1a1%s|r    PL(WHO): |cccf1f1a1%s|r",
        fpsColor, fps, PARTICLES, particleColor, particleDensity, connections, whoResults)
        
    -- Блок 3: Сетевые статы (Lat, Msg, Spell, Serv, Upt)
    local netBlock = format("\nLAT: |ccc%s%s|r    MSG(RTT): |ccc%s%s|r    SPELL: |ccc%s%s|r    %s: |ccc%s%s|r    UPT: |cccf1f1a1%s|r",
        latColor, latency, respColor, responce, spellDelayColor, spellDelay, SERV_DELAY, srvDelayColor, srvDelayVal, serverUptime)
        
    -- Блок 4: Инфо (BG, Stats, Speed)
    local infoBlock = format("\n%s    PVPINST: |cccf1f1a1%s|r\n%s    %s: |ccc%s%d|r",
        bgInfoString, formatTime(GetBattlefieldInstanceRunTime() / 1000), statsInfoString, MOVE_SPEED, speedColor, speed)

    -- Финальная склейка (всего 3 конкатенации вместо 20+)
    local finalText = topBlock .. techBlock .. netBlock .. infoBlock

    if self.text:GetText() ~= finalText then
      self.text:SetText(finalText)
    end
    
    -- Обновление слайдера настроек частиц (если открыт)
    if self:GetValue() ~= particleDensity then
       self:SetValue(particleDensity) 
    end
  end)
  
  -- скрываем спам ".сервер инфо" от аддона и [по возможности] отображаем вывод только по (ручному) запросу в чат
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
    --ru
    or msg:find("Игроков онлайн:")
    or msg:find("Продолжительность работы сервера:")
    or msg:find("WoW Circle Cross Server:")
    
    if isServerInfoMsg then
      if not f.needShowServerInfo then
        --print("filter+",msg)
        return true
      end

      if f.needShowServerInfo then
        if f.SYSMSG_SPAM_ERROR then
          f.SYSMSG_SPAM_ERROR = nil
          print("["..GetAddOnMetadata(ADDON_NAME, "Title").."]: |cff44ff44Отправлено.|r")
        end
      
        if isServerInfoMsg then
          f.needShowServerInfo = f.needShowServerInfo +1
          --print(f.needShowServerInfo,msg)
        end
        
        if (InCrossZone and f.needShowServerInfo >= 3) or f.needShowServerInfo >= 7 then
          f.needShowServerInfo = nil
        end
      end
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
  
  -- slash commands
  -- font size
  SlashCmdList["edgeinfofontsize"] = function(...) 
    local size = ...
    if size and tonumber(size) then
      cfg.fontSize = tonumber(size)
      f.text:SetFont(FONT_NAME, tonumber(size)) 
      print("cfg.fontSize",tonumber(size))
    end
  end
  SLASH_edgeinfofontsize1 = "/edgeinfofontsize"
  SLASH_edgeinfofontsize2 = "/meifs"
  
  -- settings
  do
    local width, height = 800, 500
    local settingsScrollFrame = CreateFrame("ScrollFrame",ADDON_NAME.."SettingsScrollFrame",InterfaceOptionsFramePanelContainer,"UIPanelScrollFrameTemplate")
    settingsScrollFrame.name = ADDON_NAME_LOCALE_SHORT -- Название во вкладке интерфейса
    settingsScrollFrame:SetSize(width, height)
    settingsScrollFrame:SetVerticalScroll(10)
    settingsScrollFrame:SetHorizontalScroll(10)
    settingsScrollFrame:Hide()
    _G[ADDON_NAME.."SettingsScrollFrameScrollBar"]:SetPoint("topleft",ADDON_NAME.."SettingsScrollFrame","topright",-25,-25)
    _G[ADDON_NAME.."SettingsScrollFrameScrollBar"]:SetFrameLevel(1000)
    _G[ADDON_NAME.."SettingsScrollFrameScrollBarScrollDownButton"]:SetPoint("top",ADDON_NAME.."SettingsScrollFrameScrollBar","bottom",0,7)

    local settingsFrame = CreateFrame("button", nil, InterfaceOptionsFramePanelContainer)
    settingsFrame:SetSize(width, height) 
    settingsFrame:SetAllPoints(InterfaceOptionsFramePanelContainer)
    settingsFrame:Hide()

    settingsScrollFrame:SetScrollChild(settingsFrame)

    InterfaceOptions_AddCategory(settingsScrollFrame)

    settingsScrollFrame:SetScript("OnShow", function()
      settingsFrame:Show()
    end)

    settingsScrollFrame:SetScript("OnHide", function()
      settingsFrame:Hide()
    end)

    settingsFrame.TitleText = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    settingsFrame.TitleText:SetPoint("TOPLEFT", 24, -24)
    settingsFrame.TitleText:SetText(GetAddOnMetadata(ADDON_NAME, "Title").." v"..GetAddOnMetadata(ADDON_NAME, "Version"))

    do
      local f = CreateFrame("button", ADDON_NAME.."_tooltipFrame", settingsFrame)
      f:SetPoint("center",settingsFrame.TitleText,"center")
      f:SetSize(settingsFrame.TitleText:GetStringWidth()+11,settingsFrame.TitleText:GetStringHeight()+1) 
      
      f:SetScript("OnEnter", function(self) 
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText(""..GetAddOnMetadata(ADDON_NAME, "Title").." v"..GetAddOnMetadata(ADDON_NAME, "Version").."\n\n"..GetAddOnMetadata(ADDON_NAME, "Notes").."", nil, nil, nil, nil, true)
        GameTooltip:Show() 
      end)

      f:SetScript("OnLeave", function(self) 
        GameTooltip:Hide() 
      end)
    end
    
    -- font size
    do
      local editbox = CreateFrame("EditBox",nil,settingsFrame,"InputBoxTemplate") 
      editbox:SetPoint("TOPLEFT", settingsFrame.TitleText, "BOTTOMLEFT", 8, -16)
      editbox:SetAutoFocus(false)
      editbox:SetSize(40,12)
      editbox:SetFont(GameFontNormal:GetFont(), 12)
      
      local labelDefaultText = "font size (number, min: 1, default: "..FONT_SIZE..")"

      editbox.label = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal") 
      editbox.label:SetText(labelDefaultText)
      editbox.label:SetPoint("LEFT", editbox, "RIGHT", 3, 0)
      
      editbox:SetScript("OnEditFocusLost", function(self) 
        local num=tonumber(self:GetText())
        if num and num>=1 then
          cfg.fontSize = num
          self:SetText(num)
          f.text:SetFont(FONT_NAME, num) 
          print("cfg.fontSize",num)
        else
          self:SetText(cfg.fontSize or FONT_SIZE)
        end
      end)

      editbox:SetScript("OnEscapePressed", function(self) 
        self:SetText(cfg.fontSize or FONT_SIZE)
        self:ClearFocus() 
      end)
      
      editbox:SetScript("OnUpdate", function(self) 
        if self:HasFocus() then
          local num=tonumber(self:GetText())
          if num and num>=1 then
            self:SetTextColor(0,1,0)
            self.label:SetText(labelDefaultText)
          else
            self:SetTextColor(1,0,0)
            self.label:SetText("|cffff0000incorrect value!|r "..labelDefaultText)
          end
        else
          self:SetTextColor(1,1,1)
          self.label:SetText(labelDefaultText)
        end
      end)
      
      editbox:SetScript("OnEnterPressed", function(self) 
        local num=tonumber(self:GetText())
        if num and num>=1 then
          cfg.fontSize = num
          self:SetText(num)
          f.text:SetFont(FONT_NAME, num) 
          print("cfg.fontSize",num)
        else
          self:SetText(cfg.fontSize or FONT_SIZE)
        end
        self:ClearFocus() 
      end)
      
      editbox:SetScript("OnShow", function(self) 
        self:SetText(cfg.fontSize or FONT_SIZE) 
      end)
    end
    
    -- update interval
    do
      local editbox = CreateFrame("EditBox",nil,settingsFrame,"InputBoxTemplate") 
      editbox:SetPoint("TOPLEFT", settingsFrame.TitleText, "BOTTOMLEFT", 8, -36)
      editbox:SetAutoFocus(false)
      editbox:SetSize(40,12)
      editbox:SetFont(GameFontNormal:GetFont(), 12)
      
      local labelDefaultText = "UPDATE_INTERVAL_GLOBAL (number, min: 0.01, default: "..UPDATE_INTERVAL_GLOBAL..")"

      editbox.label = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal") 
      editbox.label:SetText(labelDefaultText)
      editbox.label:SetPoint("LEFT", editbox, "RIGHT", 3, 0)
      
      editbox:SetScript("OnEditFocusLost", function(self) 
        local num=tonumber(self:GetText())
        if num and num>=0.01 then
          cfg.UPDATE_INTERVAL_GLOBAL = num
          self:SetText(num)
          print("cfg.UPDATE_INTERVAL_GLOBAL",num)
        else
          self:SetText(cfg.UPDATE_INTERVAL_GLOBAL or UPDATE_INTERVAL_GLOBAL)
        end
      end)

      editbox:SetScript("OnEscapePressed", function(self) 
        self:SetText(cfg.UPDATE_INTERVAL_GLOBAL or UPDATE_INTERVAL_GLOBAL)
        self:ClearFocus() 
      end)
      
      editbox:SetScript("OnUpdate", function(self) 
        if self:HasFocus() then
          local num=tonumber(self:GetText())
          if num and num>=0.01 then
            self:SetTextColor(0,1,0)
            self.label:SetText(labelDefaultText)
          else
            self:SetTextColor(1,0,0)
            self.label:SetText("|cffff0000incorrect value!|r "..labelDefaultText)
          end
        else
          self:SetTextColor(1,1,1)
          self.label:SetText(labelDefaultText)
        end
      end)
      
      editbox:SetScript("OnEnterPressed", function(self) 
        local num=tonumber(self:GetText())
        if num and num>=0.01 then
          cfg.UPDATE_INTERVAL_GLOBAL = num
          self:SetText(num)
          print("cfg.UPDATE_INTERVAL_GLOBAL",num)
        else
          self:SetText(cfg.UPDATE_INTERVAL_GLOBAL or UPDATE_INTERVAL_GLOBAL)
        end
        self:ClearFocus() 
      end)
      
      editbox:SetScript("OnShow", function(self) 
        self:SetText(cfg.UPDATE_INTERVAL_GLOBAL or UPDATE_INTERVAL_GLOBAL) 
      end)
    end
  end
end












-- тестовая проверка пинга (Response Time / RTT) через SendAddonMessage 
do
  local ADDON_NAME, ns = ...
  
  local ADDON_NAME_META = GetAddOnMetadata(ADDON_NAME, "Title")

  local SECONDS_SEND_ADDON_MESSAGE_INTERVAL = 1
  local SECONDS_RTT_UPDATE_INTERVAL = 0.05
  local SECONDS_GAME_MENU_UPDATE_INTERVAL = 0.2
  local NUM_ADDONS_TO_DISPLAY = 30

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
  local UnitIsDND = UnitIsDND
  local IsInGuild = IsInGuild
  local GetNumRaidMembers = GetNumRaidMembers
  local GetNumPartyMembers = GetNumPartyMembers
  
  ns.responceTime = "-"

  local f=CreateFrame("frame")
  f:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
  f:RegisterEvent("CHAT_MSG_ADDON")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  f:RegisterEvent("UI_ERROR_MESSAGE")
  f:RegisterEvent("PLAYER_LEVEL_UP")
  
  local DelayedCall
  do
    local f = CreateFrame("frame")
    local calls = {} 
    local function OnUpdate(self, elapsed)
      for i, call in ipairs(calls) do
        call.time = call.time + elapsed
        if call.time >= call.delay then
          call.func()
          tremove(calls, i) 
        end
      end
    end
    f:SetScript("OnUpdate", OnUpdate)
    DelayedCall = function(delay, func)
      tinsert(calls, { delay = delay, time = 0, func = func })
    end
  end

  function f:UI_ERROR_MESSAGE(arg1)
    if not ns.cannotSend and (arg1:find("Вы не можете использовать личные сообщения") or arg1:find("You cannot whisper")) then
      ns.cannotSend = true
      ns.responceTime, responceReceivedTime, lastRequestSendTime = "-", 0, nil
      DelayedCall(60, function()
        ns.cannotSend = nil
      end)
    end
  end

  function f:PLAYER_LEVEL_UP(...)
    --print(event, ...)
    ns.cannotSend = nil
  end

  function f:PLAYER_ENTERING_WORLD()
    ns.responceTime, responceReceivedTime, lastRequestSendTime = "-", 0, nil
  end

  function f:CHAT_MSG_ADDON(...)
    local prefix, text, channel, sender = ...
    
    if prefix == ADDON_NAME..":rtt_test" and lastRequestSendTime and tostring(lastRequestSendTime) == tostring(text) --[[and channel == "WHISPER"]] and playerName and playerName == sender then
      responceReceivedTime = GetTime()
      --ns.responceTime = modf((responceReceivedTime - lastRequestSendTime) *1000) -- test remove
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
    
    if not ns.cannotSend and s.newRequestTime > SECONDS_SEND_ADDON_MESSAGE_INTERVAL and responceReceivedTime and playerName and playerName ~= UNKNOWN and playerName ~= "" then
      local chan = UnitIsDND("player")==nil and "WHISPER" or IsInGuild() and "GUILD" or GetNumRaidMembers()>0 and "RAID" or GetNumPartyMembers()>0 and "PARTY"
      if chan then
        s.newRequestTime = 0
        responceReceivedTime = nil
        lastRequestSendTime = _time
        --print("sending...")
        SendAddonMessage(ADDON_NAME..":rtt_test", tostring(_time), chan, playerName)
      end
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
    topAddOns[i] = { value = 0, name = "" }
  end
  
  local function GameMenu_OnEnter()
    local mouseFocus = GetMouseFocus()
    if mouseFocus and mouseFocus.GetName and mouseFocus == MainMenuMicroButton and GameTooltip:IsShown() then
      GameTooltip:ClearLines()
      --print("GameMenu_OnEnter")
      
      local string = ""
      local i, j, k = 0, 0, 0
     
      GameTooltip_SetDefaultAnchor(GameTooltip, MainMenuMicroButton)
      
      GameTooltip_AddNewbieTip(MainMenuMicroButton, MainMenuMicroButton.tooltipText .." [".. ADDON_NAME_META .. "]", 1.0, 1.0, 1.0, MainMenuMicroButton.newbieText)
     
      -- latency
      local bandwidthIn, bandwidthOut, latency = GetNetStats()
      string = format(MAINMENUBAR_LATENCY_LABEL, latency)
      GameTooltip:AddLine("\n")
      GameTooltip:AddLine(string, 1.0, 1.0, 1.0)
      
      if ( SHOW_NEWBIE_TIPS == "1" ) then
        GameTooltip:AddLine(NEWBIE_TOOLTIP_LATENCY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
      end
      
      GameTooltip:AddLine("\n")
     
      -- framerate
      string = format(MAINMENUBAR_FPS_LABEL, GetFramerate())
      GameTooltip:AddLine(string, 1.0, 1.0, 1.0)
      if ( SHOW_NEWBIE_TIPS == "1" ) then
        GameTooltip:AddLine(NEWBIE_TOOLTIP_FRAMERATE, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
      end
     
      -- AddOn mem usage
      for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
        topAddOns[i].value = 0
      end
     
      UpdateAddOnMemoryUsage()
      
      local totalMem = 0
     
      for i=1, GetNumAddOns(), 1 do
        local mem = GetAddOnMemoryUsage(i)
        totalMem = totalMem + mem
        
        for j=1, NUM_ADDONS_TO_DISPLAY, 1 do
          if (mem > topAddOns[j].value) then
            for k=NUM_ADDONS_TO_DISPLAY, 1, -1 do
              if(k == j) then
                topAddOns[k].value = mem
                topAddOns[k].name = GetAddOnInfo(i):gsub("_Atom","HugeDick")
                break
              elseif(k ~= 1) then
                topAddOns[k].value = topAddOns[k-1].value
                topAddOns[k].name = topAddOns[k-1].name
              end
            end
            break
          end
        end
      end
     
      if ( totalMem > 0 ) then
        local color = RGBGradient(totalMem/40000)
        
        if ( totalMem > 1000 ) then
          totalMem = totalMem / 1000
          string = format(TOTAL_MEM_MB_ABBR, totalMem)
        else
          string = format(TOTAL_MEM_KB_ABBR, totalMem) 
        end
        
        string = "|cff".. color .. string .. "|r"
     
        GameTooltip:AddLine("\n")
        
        GameTooltip:AddLine(string, 1.0, 1.0, 1.0)
        
        if ( SHOW_NEWBIE_TIPS == "1" ) then
          GameTooltip:AddLine(NEWBIE_TOOLTIP_MEMORY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
        end
        
        local size
        
        for i=1, NUM_ADDONS_TO_DISPLAY, 1 do
          if ( topAddOns[i].value == 0 ) then
            break
          end
          
          size = topAddOns[i].value
          
          color = RGBGradient(size/5000)
          
          if ( size > 1000 ) then
            size = size / 1000
            string = format(ADDON_MEM_MB_ABBR, size, topAddOns[i].name)
          else
            string = format(ADDON_MEM_KB_ABBR, size, topAddOns[i].name)
          end
          
          GameTooltip:AddLine("|cff989898"..i..".|r |cff"..color..""..string.."|r", 1.0, 1.0, 1.0)
        end
      end
     
      GameTooltip:Show()
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
          local color = tonumber(ns.responceTime) and RGBGradient(ns.responceTime/150) or "ffffff"
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
