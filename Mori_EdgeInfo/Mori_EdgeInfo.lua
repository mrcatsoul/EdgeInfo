-- инфа левый нижний угол
do  
  local ADDON_NAME, ns = ...
  _G[ADDON_NAME] = ns
  
  local ADDON_FOLDER = "interface\\addons\\" .. ADDON_NAME
  local DEFAULT_FONT_NAME = "fonts\\FRIZQT__.TTF"
  local DEFAULT_FONT_SIZE = 12
  local DEFAULT_ALPHA = 0.9
  local PARTICLE_DENSITY_BAR_MIN_WIDTH = 50
  local PARTICLE_DENSITY_BAR_MIN_HEIGHT = 7
  local PARTICLE_DENSITY_BAR_MIN_HEIGHT = 7
  local DEFAULT_FRAME_STRATA = "high"
  local DEFAULT_FRAME_LEVEL = 10
  local INDENT_BIG = "    "
  local INDENT_SMALL = " "
  local PERCENT_SIGN = "%"
  
  ns.fontsList = {
    "PTSansNarrow.ttf",
    "PTSansNarrow-Regular.ttf",
    "FRIZQT__.TTF", 
    "Hack.ttf",
    "trebuc.ttf",
    "trebucbd.ttf",
    "VeraMono.ttf",
    "Roboto.ttf",
    "Hack-Bold.ttf",
    "Roboto_Condensed-Regular.ttf",
    "Roboto_Condensed-Medium.ttf", 
    "UbuntuCondensed.ttf",
    "consola.ttf",
    "consolab.ttf",
    "Pixel LCD7_20231125.ttf",
    "centurygothic.TTF",
    "Homespun.ttf",
    "HOOGE.ttf",
    "Impact.ttf",
    "FORCEDSQUARE.ttf",
    "hooge test1.ttf",
  }
  
  ns.fontsFlags = {
    "NONE", "OUTLINE", "THICKOUTLINE", "MONOCHROME", "MONOCHROMEOUTLINE"
  }
  
  ns.frameStrata = {
    "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG", "TOOLTIP"
  }
  
  ns.statsEvent = {
    "PLAYER_TALENT_UPDATE",
    "UNIT_ATTACK_POWER",
    "UNIT_RANGED_ATTACK_POWER",
    "UNIT_STATS",
    "UNIT_RANGEDDAMAGE",
    "UNIT_DAMAGE",
    "UNIT_RESISTANCES",
    "PLAYER_DAMAGE_DONE_MODS",
    "UNIT_ATTACK",
    "UNIT_ATTACK_SPEED",
    --"SKILL_LINES_CHANGED"
  }
  
  ns.spellEvents = {
    "COMBAT_LOG_EVENT_UNFILTERED",
    "UNIT_SPELLCAST_SENT",
    "UNIT_SPELLCAST_SUCCEEDED",
    "UNIT_SPELLCAST_START",
    "UNIT_SPELLCAST_FAILED"
  }

  local cfg = mrcatsoul_Mori_EdgeInfo_Data or {}

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
  local GetSpellInfo = GetSpellInfo
  local GetUnitSpeed = GetUnitSpeed
  local GetParryChance = GetParryChance
  local GetDodgeChance = GetDodgeChance
  local GetStatistic = GetStatistic
  local UnitCastingInfo = UnitCastingInfo
  local UnitChannelInfo = UnitChannelInfo
  local GetNumWhoResults = GetNumWhoResults
  local SendWho = SendWho
  local GetPlayerMapPosition = GetPlayerMapPosition
  local GetBattlefieldInstanceRunTime = GetBattlefieldInstanceRunTime
  local IsShiftKeyDown = IsShiftKeyDown
  local WhoFrameEditBox = WhoFrameEditBox
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
  local strmatch = strmatch
  local tinsert = tinsert
  local tconcat = table.concat
  local tContains = tContains
  local strep = string.rep
  local wipe = wipe
  local GetFramerate = GetFramerate
  local GetNetStats = GetNetStats
  local GetZonePVPInfo = GetZonePVPInfo
  local date = _G.date
  local time = _G.time
  local GetTime = _G.GetTime
  local GetLocale = GetLocale
  local CR_HASTE_SPELL = CR_HASTE_SPELL
  local CR_HIT_RANGED = CR_HIT_RANGED
  local CR_HIT_MELEE = CR_HIT_MELEE
  local CR_HIT_RANGED = CR_HIT_RANGED
  local CR_CRIT_RANGED = CR_CRIT_RANGED
  local _

  local RezTimer_Data, bg_statistics = _G.RezTimer_Data, _G.bg_statistics
  local SYSMSG_SPAM_ERROR = GetLocale()=="ruRU" and "Команда не может быть обработана в текущий момент" or "This command cann't be processed now"
  
  local playerGUID = UnitGUID("player")
  local InDungeon, InRaidDungeon, InBg, InArena, InRaidGroup, spectatorMode, instanceDifficulty, zonePvpType, showAttackPower, showSpellPower, curZone, zoneColor, InCrossZone, isHunter, needShowServerInfo, needShowServerInfo
  
  ns.UNIT_SPELLCAST_SENT, ns.UNIT_SPELLCAST_SUCCEEDED, ns.spellIcons = {}, {}, {}
  ns.statsInfoString, ns.bgInfoString, ns.zoneInfoString = "", "", ""
  ns.INV_Misc_QuestionMark = [=[Interface\icons\INV_Misc_QuestionMark]=]
  
  ns.L = GetLocale()
  ns.L = ns.L=="ruRU" and FORCE_EN_LOCALE and "enUS" or FORCE_RUS_LOCALE and "ruRU" or GetLocale()

  local ADDON_NAME_LOCALE = GetAddOnMetadata(ADDON_NAME, "Title") or ADDON_NAME
  local ADDON_NOTES = GetAddOnMetadata(ADDON_NAME, "Notes") or UNKNOWN
  local ADDON_VERSION = GetAddOnMetadata(ADDON_NAME, "Version") or UNKNOWN

  local PARTICLES, SERV_DELAY, GAMES, WINS, WINRATE, ATTACK_POWER
  local SPELL_POWER, RES, CRIT, HASTE, HIT, MOVE_SPEED, TO_RES
  local BY_CORPSE, TO_RES_BY_CORPSE, ENEMIES, READY, BG_PTS, MAP
  local TIME, PLWHO, PLSRV, PVPINST, UPTIME, PVPFLAG, REALM
  local ARMOR, PARRY, DODGE, SPELL, INCORRECT_VALUE
  
  function ns.ForceUpdateLocale()
    --local L = GetLocale()=="ruRU" and cfg.force_en_locale and "enUS" or cfg.force_rus_locale and "ruRU" or GetLocale() 
    local L = cfg.locale or GetLocale()
    ns.L = L
  
    PARTICLES = L=="ruRU" and "Частицы" or "PARTICLES"
    SERV_DELAY = L=="ruRU" and "Серв" or "SERV"
    GAMES = L=="ruRU" and "Игр" or "GAMES"
    WINS = L=="ruRU" and "Побед" or "WINS"
    WINRATE = L=="ruRU" and "Винрейт" or "WR"
    ATTACK_POWER = L=="ruRU" and "АП" or "AP"
    SPELL_POWER = L=="ruRU" and "СПД" or "SP"
    RES = L=="ruRU" and "Уст" or "RSL"
    CRIT = L=="ruRU" and "Крит" or "CRT"
    HASTE = L=="ruRU" and "Скор" or "HST"
    HIT = L=="ruRU" and "Метк" or "HIT"
    MOVE_SPEED = L=="ruRU" and "Движ" or "MOV"
    TO_RES = L=="ruRU" and "До реса" or "RES"
    BY_CORPSE = L=="ruRU" and "по телу" or "CORPSE"
    TO_RES_BY_CORPSE = L=="ruRU" and "Рес по телу" or "RES CORPSE"
    ENEMIES = L=="ruRU" and "Врагов реснется" or "DEAD ENMS"
    READY = L=="ruRU" and "готов" or "ready"
    BG_PTS = L=="ruRU" and "БГ очки" or "BG PTS"
    MAP = L=="ruRU" and "Карта" or "MAP"
    TIME = L=="ruRU" and "Время" or "TIME"
    PLWHO = L=="ruRU" and "Онлайн(кто)" or "Players(WHO)"
    PLSRV = L=="ruRU" and "Онлайн(серв)" or "Players(SERV)"
    PVPINST = L=="ruRU" and "БГ длится" or "PVPINST"
    UPTIME = L=="ruRU" and "Аптайм" or "UPT"
    PVPFLAG = --[[L=="ruRU" and "ПвП" or]] "PvP"
    REALM = L=="ruRU" and "Серв" or "REALM"
    ARMOR = L=="ruRU" and "Брон" or "ARM"
    PARRY = L=="ruRU" and "Пар" or "PAR"
    DODGE = L=="ruRU" and "Укл" or "DOD"
    SPELL = L=="ruRU" and "Закл" or "SPELL"
    INCORRECT_VALUE = L=="ruRU" and "Некоректное значение" or "Incorrect value"
  end
  
  ns.ForceUpdateLocale()

  ns.RegEvents = function(frame, eventsTable)
    for _, event in ipairs(eventsTable) do
      frame:RegisterEvent(event)
    end
  end
  
  ns.UnRegEvents = function(frame, eventsTable)
    for _, event in ipairs(eventsTable) do
      frame:UnregisterEvent(event)
    end
  end

  -- -------------------------
  -- localization helper
  -- -------------------------
  -- function ns.GetLocaleKey()
    -- if cfg.locale:find("ru") then 
      -- return "ru" 
    -- else
      -- return "en" 
    -- end
    -- -- if (ns.L~="ruRU" and FORCE_RUS_LOCALE) or cfg.force_rus_locale then return "ru" end
    -- -- if (ns.L=="ruRU" and FORCE_EN_LOCALE) or cfg.force_en_locale then return "en" end
    -- -- local loc = (GetLocale and GetLocale()) or "enUS"
    -- -- if loc:sub(1,2) == "ru" then return "ru" end
    -- -- return "en"
  -- end

  local function Localise(tbl)
    if not tbl then return nil end
    local k
    if cfg.locale:find("ru") then 
      k = "ru" 
    else
      k = "en" 
    end
    return tbl[k] or tbl.en or tbl.ru or ""
  end

  local DelayedCall, CancelDelayedCall
  do
    local unpack, type, pcall, tinsert = unpack, type, pcall, tinsert
    local f = CreateFrame("Frame")
    local calls = {}

    local function OnUpdate(self, elapsed)
      for i = #calls, 1, -1 do
        local c = calls[i]
        if c.cancelled then
          tremove(calls, i)
        else
          c.time = c.time + elapsed
          if c.time >= c.delay then
            tremove(calls, i)
            local ok, err = pcall(c.func, unpack(c.args or {}))
            if not ok then
              DEFAULT_CHAT_FRAME:AddMessage("DelayedCall error: "..tostring(err))
            end
          end
        end
      end
      
      if #calls == 0 then
        self:SetScript("OnUpdate", nil) 
      end
    end

    function DelayedCall(delay, func, ...)
      if type(delay) ~= "number" or delay < 0 then delay = 0 end
      if type(func) ~= "function" then error("DelayedCall: func must be function") end
      local entry = { delay = delay, time = 0, func = func, args = {...}, cancelled = false }
      tinsert(calls, entry)
      if not f:GetScript("OnUpdate") then
        f:SetScript("OnUpdate", OnUpdate)
      end
      return entry -- handle для отмены
    end

    function CancelDelayedCall(handle)
      if type(handle) == "table" then handle.cancelled = true end
    end
  end
  
  -- -------------------------
  -- settings UI: scroll frame + panel
  -- -------------------------
  do
    local FRAME_WIDTH, FRAME_HEIGHT = 800, 400
    local ROW_HEIGHT = 20
  
    local cfgPanel = CreateFrame("frame", ADDON_NAME.."SettingsPanel", InterfaceOptionsFramePanelContainer)
    ns.cfgPanel = cfgPanel
    cfgPanel:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    cfgPanel:SetAllPoints(InterfaceOptionsFramePanelContainer)
    cfgPanel:Hide()
    
    local cfgScroll = CreateFrame("ScrollFrame", ADDON_NAME.."SettingsScrollFrame", InterfaceOptionsFramePanelContainer, "UIPanelScrollFrameTemplate")
    cfgScroll:SetScrollChild(cfgPanel)
    --cfgScroll.name = "|cff00ffff" .. Localise({ en = ADDON_NAME, ru = ADDON_NAME })
    cfgScroll.name = ADDON_NAME_LOCALE
    cfgScroll:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    cfgScroll:SetVerticalScroll(0)
    -- cfgScroll:SetVerticalScroll(10)
    -- cfgScroll:SetHorizontalScroll(10)
    cfgScroll:Hide()
    InterfaceOptions_AddCategory(cfgScroll)
    
    cfgScroll:SetScript("OnShow", function()
      cfgPanel:Show()
    end)

    cfgScroll:SetScript("OnHide", function()
      cfgPanel:Hide()
    end)
    
    _G[ADDON_NAME.."SettingsScrollFrameScrollBar"]:SetPoint("topleft",ADDON_NAME.."SettingsScrollFrame","topright",-25,-25)
    _G[ADDON_NAME.."SettingsScrollFrameScrollBar"]:SetFrameLevel(1000)
    _G[ADDON_NAME.."SettingsScrollFrameScrollBarScrollDownButton"]:SetPoint("top",ADDON_NAME.."SettingsScrollFrameScrollBar","bottom",0,7)
    
    -- -------------------------
    -- tooltip
    -- -------------------------
    local cfgTitle = cfgPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    cfgTitle:SetPoint("TOPLEFT", 15, -10)
    cfgTitle:SetFont(GameFontNormal:GetFont(), 18, "OUTLINE")
    cfgTitle:SetText(ADDON_NAME_LOCALE.." v"..ADDON_VERSION)

    local titleTip = CreateFrame("button", ADDON_NAME.."_tooltipFrame", cfgPanel)
    titleTip:SetPoint("center", cfgTitle, "center")
    --titleTip:SetSize(cfgTitle:GetStringWidth()+11, cfgTitle:GetStringHeight()+1) 
    
    titleTip:SetScript("OnEnter", function(self) 
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
      GameTooltip:SetText(ADDON_NAME_LOCALE.." v"..ADDON_VERSION.."\n\n"..ADDON_NOTES.."\n\n"..GetAddOnMetadata(ADDON_NAME, "X-Repository"), nil, nil, nil, nil, true)
      GameTooltip:Show() 
    end)

    titleTip:SetScript("OnLeave", function(self) 
      GameTooltip:Hide() 
    end)
    
    titleTip:SetScript("OnShow", function(self) 
      self:SetSize(cfgTitle:GetStringWidth(), cfgTitle:GetStringHeight())
    end)
    
    local function GetNextChar(str, startPos)
      local byte = string.byte(str, startPos)
      if not byte then return nil end

      -- Если байт > 127, значит это начало мультибайтового символа (RU)
      if byte > 127 then
        return string.sub(str, startPos, startPos + 1), 2
      else
        return string.sub(str, startPos, startPos), 1
      end
    end

    cfgPanel.aboutString = "Скрипт на тех-инфу слева в нижнем углу.\r\rНастройки: Главное меню > Интерфейс > Модификации.\r\r" .. ADDON_NOTES .. "\r\rРепозиторий: |ccc00aaff" .. GetAddOnMetadata(ADDON_NAME, "X-Repository") .. "|r\r\rЕсли это окно появилось автоматически - значит стандартная конфигурация была создана и данное окно более не появится для этого аккаунта.\r\rPS: Впервые тестирую скрипт-приветствие в подобном формате(окно с копипастом), вкурсе что навязчиво, ноооооо мб так кто-нибудь узнает об авторе если дочитает это до конца, и может даже скинет ему на пивасик/мораль/мотивацию :)"

    function cfgPanel.ShowAbout()
      StaticPopup_Show(ADDON_NAME .. "_TEST1")
    end
    
    local displayCursor = " |"

    StaticPopupDialogs[ADDON_NAME .. "_TEST1"] = {
      text = ADDON_NAME_LOCALE .. " " .. ADDON_VERSION,
      button1 = OKAY,
      hasEditBox = 1,
      maxLetters = 1000,
      hasWideEditBox = 1,
      timeout = 0,
      exclusive = 1,
      whileDead = 1,
      hideOnEscape = 1,
      closeButton = 1,

      OnAccept = function(self)
        if self.wideEditBox:GetScript("OnUpdate") then
          DelayedCall(0.01, function()
            cfgPanel.ShowAbout()
            self.wideEditBox:SetScript("OnUpdate", nil)
            self.wideEditBox:SetText(cfgPanel.aboutString)
            if not GetCurrentKeyBoardFocus() then
              self.wideEditBox:SetFocus()
            end
          end)
          --_G[self:GetName().."Button1"]:SetText("Показать фул")
        else
          self:Hide()
        end
      end,
      
      OnShow = function(self)
        self.wideEditBox:SetScript("OnUpdate", nil)
        self.wideEditBox:SetScript("OnEditFocusGained", nil)
        self.wideEditBox:SetScript("OnTextChanged", nil)

        self.wideEditBox:SetAutoFocus(false)
        --self.wideEditBox:EnableKeyboard(false)
        self.wideEditBox:ClearFocus()
        
        if self.wideEditBox:GetText() == cfgPanel.aboutString then 
          return 
        end
        
        select(8, self.wideEditBox:GetRegions()):Hide()
        if(_G[self.wideEditBox:GetName().."Left"]) then _G[self.wideEditBox:GetName().."Left"]:Hide() end
        if(_G[self.wideEditBox:GetName().."Middle"]) then _G[self.wideEditBox:GetName().."Middle"]:Hide() end
        if(_G[self.wideEditBox:GetName().."Mid"]) then _G[self.wideEditBox:GetName().."Mid"]:Hide() end
        if(_G[self.wideEditBox:GetName().."Right"]) then _G[self.wideEditBox:GetName().."Right"]:Hide() end

        self.wideEditBox:SetFont(ADDON_FOLDER.."\\Hack.ttf", 11)
        _G[self:GetName().."Text"]:SetFont(ADDON_FOLDER.."\\Hack-Bold.ttf", 11)
        
        self.wideEditBox:SetMultiLine()
      
        local currentByte = 1
        local elapsedAccumulator = 0
        local speed = .001 -- задержка между буквами
        
        self.wideEditBox:SetText("") -- очищаем перед началом

        --self.wideEditBox:SetScript("OnCursorChanged", function(s, ...) 
          --print("OnCursorChanged")
          -- if s:GetScript("OnUpdate") then
            -- --s:SetCursorPosition(#(s:GetText() or ""))
          -- end
        --end)
        
        -- self.wideEditBox:SetScript("OnChar", function(s, ...) 
          -- print("OnChar",...)
        -- end)
        
        local expectedText = "" -- Переменная, где мы храним то, что реально напечатал аддон

        self.wideEditBox:SetScript("OnUpdate", function(s, elapsed)
          elapsedAccumulator = elapsedAccumulator + elapsed
          
          --local butt = _G[self:GetName().."Button1"]
          local text = s:GetText()
          
          if text == cfgPanel.aboutString then
            --butt:SetText("Пон")
            s:SetScript("OnUpdate", nil)
            if not GetCurrentKeyBoardFocus() then
              self.wideEditBox:SetFocus()
            end
          else 
            --butt:SetText("Показать фул")
            --s:ClearFocus()
          
            if elapsedAccumulator >= speed then
              elapsedAccumulator = 0
              
              -- Получаем символ и его длину в байтах
              local nextChar, byteLen = GetNextChar(cfgPanel.aboutString, currentByte)

              if s:HasFocus() then
                --s:SetCursorPosition(#(text or "")) -- обязательно если текст пытаются выделить в процессе автоввода кодом (Insert)
                --s:HighlightText(0, 0)
                --s:ClearFocus()
              end
              
              local currentPos = s:GetCursorPosition()
              local totalByteLen = #(text or "")
              --print(currentPos,totalByteLength)
              
              if nextChar --[[and currentPos == totalByteLen]] then
                --s:SetText(cfgPanel.aboutString:sub(1, currentByte + byteLen - 1))
                
                expectedText = expectedText .. nextChar -- Запоминаем, что мы добавили (Insert)
                --s:Insert(nextChar) -- вставляем символ в текущую позицию курсора
                
                s:SetText(expectedText)
                currentByte = currentByte + byteLen
              else
                s:SetText(cfgPanel.aboutString)
                -- Если символов больше нет, выключаем OnUpdate
                s:SetScript("OnUpdate", nil)
                if not GetCurrentKeyBoardFocus() then
                  self.wideEditBox:SetFocus()
                end
              end
            end
          end
        end)
        
        self.wideEditBox:SetScript("OnTextChanged", function(s, isUserInput)
          --print("wideEditBox OnTextChanged", isUserInput)
          self:SetHeight(s:GetHeight() + 100)
          
          local butt = _G[s:GetParent():GetName().."Button1"]
          local curText = s:GetText()
          
          if curText == cfgPanel.aboutString then
            butt:SetText("Пон")
          else
            if s:GetScript("OnUpdate") then
              if isUserInput or curText ~= expectedText then -- текст введен руками
                s:SetText(expectedText) -- test
                --s:SetScript("OnUpdate", nil) -- Стоп анимация
                --s:SetText(cfgPanel.aboutString) -- Показываем весь текст
                --print("SetScript OnUpdate nil OnTextChanged")
              else -- текст введен кодом
                butt:SetText("Показать фул")
                --print("Показать фул")
              end
            else
              --self:Hide()
              s:SetText(cfgPanel.aboutString) -- test
              s:ClearFocus()
              --print("клоуз OnTextChanged")
            end
          end
        end)
        
        self.wideEditBox:SetScript("OnEditFocusGained", function(self)
          --print("OnEditFocusGained")
          if self:GetScript("OnUpdate") then
            --self:SetCursorPosition(#(self:GetText() or "")) -- обязательно если текст пытаются выделить в процессе автоввода кодом (Insert)
            self:HighlightText(0, 0)
            self:ClearFocus()
          end
        end)
        
        -- self.wideEditBox:SetScript("OnMouseDown", function(self, button)
          -- print("OnMouseDown", button)
          -- -- Если кликнули левой кнопкой, даем фокус (для копирования)
          -- -- Если не хочешь, чтобы фокус вообще брался - просто ничего не пиши или ClearFocus()
          -- if button == "LeftButton" then
            -- -- self:SetFocus() -- закомментируй, если фокус не нужен вообще
          -- end
        -- end)
      end,

      OnHide = function(self)
        ChatEdit_FocusActiveWindow()
      end,
      
      EditBoxOnEscapePressed = function(self)
        if self:HasFocus() then
          if self:GetScript("OnUpdate") then
            self:SetText(cfgPanel.aboutString)
            --self:HighlightText(0, 0)
          else
            self:HighlightText(0, 0)
            self:ClearFocus()
          end
        else
          if self:GetScript("OnUpdate") then
            self:SetText(cfgPanel.aboutString)
          else
            --self:GetParent():Hide()
          end
        end
      end,
    }
    
    titleTip:SetScript("OnClick", function(self) 
      InterfaceOptionsFrame:Hide()
      GameMenuFrame:Hide()
      StaticPopup_Show(ADDON_NAME .. "_TEST1")
    end)

    -- -------------------------
    -- chat hyperlink to open options (simple)
    -- -------------------------
    -- create clickable string: |cff71d5ff|Haddon:MyAddon_link:Settings:|h[Settings]|h|r
    do
      DEFAULT_CHAT_FRAME:HookScript("OnHyperlinkClick", function(self, link, text, button, ...)
        if not link then return end
        local linkType, arg1, option = strsplit(":", link)
        if linkType == "addon" and arg1 and arg1 == (ADDON_NAME.."_link") then
          if option:lower() == "settings" then
            InterfaceOptionsFrame_OpenToCategory(cfgScroll)
            if not cfgPanel:IsShown() then
              InterfaceOptionsFrameAddOnsListScrollBarScrollDownButton:Click()
              InterfaceOptionsFrame_OpenToCategory(cfgScroll)
            end
          elseif option:lower() == "about" then
            cfgPanel.ShowAbout()
          end
        end
      end)
      
      function cfgPanel.MakeChatLink(text, option)
        option = option or "Settings"
        local color = "71d5ff"
        return "|cff"..color.."|Haddon:"..ADDON_NAME.."_link:"..option..":|h["..text.."]|h|r"
      end

      cfgPanel.old = ItemRefTooltip.SetHyperlink 
      function ItemRefTooltip:SetHyperlink(link, ...)
        if link:find(ADDON_NAME.."_link") then return end
        return cfgPanel.old(self, link, ...)
      end
    end

    -- Новая структура options:
    -- key        = string (имя в конфиге)
    -- label      = { en = "English label", ru = "Русская метка" }
    -- tooltip    = { en = "English tooltip", ru = "Русская подсказка" }  (nil -> нет подсказки)
    -- default    = value (boolean/number/string)
    -- min, max   = только для чисел (optional)
    cfgPanel.options = {
      {
        key = "locale",
        label = { en = "Locale", ru = "Язык текста" },
        tooltip = { en = "Locale", ru = "Язык текста" },
        type = "select",
        values = { "enUS", "ruRU" },
        default = "enUS",
      },
    
      {
        key = "fontSize",
        label = { en = "Font size", ru = "Размер шрифта" },
        tooltip = { en = "Font size in pixels.\nPress ENTER to apply.", ru = "Размер шрифта в пикселях.\nЧтобы применить - нажать ENTER." },
        default = 12, min = 5, max = 40
      },
      
      {
        key = "fontName",
        label = { en = "Font", ru = "Шрифт" },
        tooltip = { en = "Font name", ru = "Шрифт" },
        default = ns.fontsList
      },
      
      {
        key = "fontFlags",
        label = { en = "Font flags", ru = "Флаги шрифта" },
        tooltip = { en = "Font flags", ru = "Флаги шрифта" },
        default = ns.fontsFlags
      },
      
      {
        key = "frameStrata",
        label = { en = "Frame strata", ru = "Слой фрейма (frame strata)" },
        tooltip = { en = "Frame strata.\nChange if the text is hidden behind other frames or overlaps them.\nTOOLTIP is the highest layer, BACKGROUND is the lowest.", ru = "Слой фрейма (frame strata).\nМенять если текст скрывается за другими фреймами (например панелью заклинаний) или наоборот поверх их.\nЗадать MEDIUM или HIGH если текст прячется за панелью заклинаний. TOOLTIP - самый верхний слой, BACKGROUND - самый нижний.\nЕсли представить интерфейс как стопку листов бумаги, то Strata — это целые пачки (например, «слой фона» и «слой иконок»), а Frame Level — это порядок листов внутри одной пачки. Чтобы SetFrameLevel сработал, нужно понимать, что он вторичен. Сначала игра проверяет слои (FrameStrata). Фрейм на слое MEDIUM с уровнем 100 всегда будет ниже, чем фрейм на слое HIGH с уровнем 1." },
        default = ns.frameStrata
      },
      
      {
        key = "frameLevel",
        label = { en = "Frame level", ru = "Уровень фрейма в слое (frame level)" },
        tooltip = { en = "Frame level.\nChange if the text is hidden behind other frames or overlaps them.", ru = "Уровень фрейма в слое (frame level).\nМенять если текст скрывается за другими фреймами (например панелью заклинаний) или наоборот поверх их.\nЕсли представить интерфейс как стопку листов бумаги, то Strata — это целые пачки (например, «слой фона» и «слой иконок»), а Frame Level — это порядок листов внутри одной пачки. Чтобы SetFrameLevel сработал, нужно понимать, что он вторичен. Сначала игра проверяет слои (FrameStrata). Фрейм на слое MEDIUM с уровнем 100 всегда будет ниже, чем фрейм на слое HIGH с уровнем 1." },
        default = 10, min = 0, max = 128
      },
      
      {
        key = "fontShadow",
        label = { en = "Font shadow", ru = "Тень под шрифтом" },
        tooltip = { en = "Font shadow", ru = "Небольшая тень под шрифтом со смещением в 1 пиксель вниз + вправо" },
        default = true
      },
      
      {
        key = "alpha",
        label = { en = "Text opacity", ru = "Прозрачность текста" },
        tooltip = { en = "Text opacity from 0 to 1.\n1 = 100%. Set to 0.5 for 50% opacity, for example.\nPress ENTER to apply.", ru = "Прозрачность текста от 0 до 1.\n1 = 100%. Задать к примеру 0.5 для прозрачности в 50%.\nЧтобы применить - нажать ENTER." },
        default = 0.9, min = 0, max = 1
      },
      
      {
        key = "attachFrameToUIParent",
        label = { en = "Hide addon info when UI is hidden (ALT+Z)", ru = "Скрывать текст аддона при скрытии интерфейса (ALT+Z)" },
        tooltip = { en = "Hide addon info when UI is hidden (ALT+Z)", ru = "Скрывать текст аддона при скрытии интерфейса (ALT+Z)" },
        default = false
      },
      
      {
        key = "updateIntervalGlobal",
        label = { en = "Global update interval (seconds)", ru = "Частота обновления текста в секундах" },
        tooltip = { en = "Global text update interval in seconds.\nAffects addon memory usage. Lower value = faster updates = higher memory consumption.\nPress ENTER to apply.", ru = "Скорость обновления текста в секундах.\nВлияет на потребление памяти аддоном. Меньше значение = быстрее обновление = больше потребление памяти.\nЧтобы применить - нажать ENTER." },
        default = 0.025, min = 0.01, max = 5
      },
      
      {
        key = "indentSpaceCount",
        label = { en = "Number of spaces between segments", ru = "Кол-во пробелов в отступах между сегментами" },
        tooltip = { en = "Number of spaces in indents between segments.\nPress ENTER to apply.", ru = "Кол-во пробелов в отступах между сегментами.\nЧтобы применить - нажать ENTER." },
        default = 4, min = 1, max = 20
      },
      
      {
        key = "smallIndentSpaceCount",
        label = { en = "Number of spaces between parameters and values", ru = "Кол-во пробелов в отступах между параметрами и их значениями" },
        tooltip = { en = "Number of spaces in indents between parameters and their values.\nPress ENTER to apply.", ru = "Кол-во пробелов в отступах между параметрами и их значениями.\nЧтобы применить - нажать ENTER." },
        default = 1, min = 0, max = 20
      },
      
      -- {
        -- key = "force_en_locale",
        -- label = { en = "Force English locale", ru = "Принудительно английский текст" },
        -- tooltip = { en = "Force interface texts to English", ru = "Принудительно отображать тексты на английском" },
        -- default = false
      -- },
      
      -- {
        -- key = "force_rus_locale",
        -- label = { en = "Force Russian locale", ru = "Принудительно русский текст" },
        -- tooltip = { en = "Force interface texts to Russian", ru = "Принудительно отображать тексты на русском" },
        -- default = false
      -- },
      
      {
        key = "RezTimer",
        label = { en = "Show corpse recovery delay and RezTimer info (https://github.com/mrcatsoul/RezTimer)", ru = "Показывать время до реса \"по телу\" и время до реса у духа на БГ + потенциальное кол-во ресающихся врагов из RezTimer" },
        tooltip = { en = "Show corpse recovery delay and BG spirit healer timer + potential number of resurrecting enemies from RezTimer.\nhttps://github.com/mrcatsoul/RezTimer", ru = "Показывать время до реса \"по телу\" и время до реса у духа на БГ + потенциальное кол-во ресающихся врагов из RezTimer.\nhttps://github.com/mrcatsoul/RezTimer" },
        default = true
      },
      
      {
        key = "showZoneInfo",
        label = { en = "Show zone info: name, coordinates, PvP flag, instance difficulty", ru = "Показывать инфу о зоне: название, координаты, пвп флаг, сложность инста" },
        tooltip = { en = "Show zone info: name, coordinates, PvP flag, instance difficulty", ru = "Показывать инфу о зоне: название, координаты, пвп флаг, сложность инста" },
        default = true
      },
      
      {
        key = "showBgInstanceRunTime",
        label = { en = "Show time since current PvP instance (BG/Arena) started", ru = "Показывать время с момента открытия текущего пвп инста (БГ/арены)" },
        tooltip = { en = "Show time elapsed since the current PvP instance (BG/Arena) opened", ru = "Показывать время с момента открытия текущего пвп инста (БГ/арены)" },
        default = true
      },
      
      {
        key = "showTime",
        label = { en = "Show time", ru = "Показывать время" },
        tooltip = { en = "Show time.\nIf disabled, the day of the week and date will not be displayed.", ru = "Показывать время.\nЕсли выключено: день недели/дата отображаться не будут." },
        default = true
      },
      
      {
        key = "showDayOfWeek",
        label = { en = "Show day of the week", ru = "Показывать день недели" },
        tooltip = { en = "Show day of the week", ru = "Показывать день недели" },
        default = true
      },
      
      {
        key = "showDate",
        label = { en = "Show date", ru = "Показывать дату" },
        tooltip = { en = "Show date", ru = "Показывать дату" },
        default = true
      },
      
      {
        key = "showMilliseconds",
        label = { en = "Show milliseconds", ru = "Показывать милисекунды" },
        tooltip = { en = "Show milliseconds.\nCan consume a lot of memory at high text update rates.", ru = "Показывать милисекунды.\nПри высокой скорости обновления текста может хорошо жрать память.\nДля того чтобы было видно милисекунды вплоть до сотых доль - поставить частоту обновления текста меньшей или равной 0.05" },
        default = true
      },
      
      {
        key = "showServerTime",
        label = { en = "Show server time", ru = "Показывать серверное время" },
        tooltip = { en = "Show server time", ru = "Показывать серверное время" },
        default = true
      },
      
      {
        key = "showFPS",
        label = { en = "Show FPS", ru = "Показывать фпс" },
        tooltip = { en = "Show FPS", ru = "Показывать фпс" },
        default = true
      },
      
      {
        key = "showParticles",
        label = { en = "Show particle density", ru = "Показывать плотность частиц" },
        tooltip = { en = "Show particle density", ru = "Показывать плотность частиц" },
        default = true
      },
      
      {
        key = "showServerOnline",
        label = { en = "Show server online from .server info", ru = "Показывать онлайн сервера из .server info" },
        tooltip = { en = "Show server online count from .server info.\nWhen enabled, it automatically sends hidden '.server info' commands. A system error may pop up in chat when calling .menu/.server info manually ('Command cannot be processed at this time').", ru = "Показывать онлайн сервера из .server info.\nПри включенной функции автоматически скрыто посылает команду .server info + может выскакивать системная ошибка в чат когда вызываем .menu/.server info (\"Команда не может быть обработана в текущий момент\")" },
        default = true
      },
      
      {
        key = "showWhoOnline",
        label = { en = "Show server online from 'Who' window", ru = "Показывать онлайн сервера из окна \"кто\"" },
        tooltip = { en = "Show server online count based on the 'Who' window", ru = "Показывать онлайн сервера из окна \"кто\"" },
        default = true
      },
      
      {
        key = "showParticleDensityBar",
        label = { en = "Show particle density bar (resize: SHIFT + mouse scroll on frame)", ru = "Показывать полосу плотности частиц из настроек графики" },
        tooltip = { en = "Display particle density bar from graphics settings.\nResize using SHIFT + mouse wheel scroll on the frame; move using SHIFT + drag.", ru = "Отображать полосу плотности частиц из настроек графики.\nРазмер меняется через SHIFT+прокрутка мышью по фрейму, перетаскивание так же при помощи шифта." },
        default = false
      },
      
      {
        key = "showLatencyHome",
        label = { en = "Show latency from game menu button tooltip", ru = "Показывать задержку из тултипа(подсказки) кнопки игрового меню" },
        tooltip = { en = "Show latency from game menu button tooltip", ru = "Показывать задержку из тултипа(подсказки) кнопки игрового меню" },
        default = true
      },
      
      {
        key = "showRTT",
        label = { en = "Show RTT", ru = "Показывать RTT" },
        tooltip = { en = "Show RTT.\nRTT (Round-trip time) — a more accurate ping using addon messages (https://wowwiki-archive.fandom.com/wiki/API_SendAddonMessage).\nUnlike normal latency, this quickly shows real connection issues, updating rapidly.", ru = "Показывать RTT.\nRTT (https://ru.wikipedia.org/wiki/Круговая_задержка) - более реальное значение задержки/пинга через отправку самому себе сообщений аддона (https://wowwiki-archive.fandom.com/wiki/API_SendAddonMessage).\nВ отличии от обычной задержки (из тултипа кнопки игрового меню) через эту цифру сразу будет видно если есть проблемы с соединением, значение сразу вырастает, обновляется максимально быстро." },
        default = true
      },
      
      {
        key = "showSpellDelay",
        label = { en = "Show potential flight time of the last cast spell (flytime, ms between UNIT_SPELLCAST_SENT and UNIT_SPELLCAST_SUCCEEDED)", ru = "Показывать потенциальное время полёта последнего применённого заклинания (флайтайм, количество милисекунд между UNIT_SPELLCAST_SENT и UNIT_SPELLCAST_SUCCEEDED)" },
        tooltip = { en = "Show potential flight time of the last cast spell (flytime, ms between UNIT_SPELLCAST_SENT and UNIT_SPELLCAST_SUCCEEDED)", ru = "Показывать потенциальное время полёта последнего применённого заклинания (флайтайм, количество милисекунд между UNIT_SPELLCAST_SENT и UNIT_SPELLCAST_SUCCEEDED)" },
        default = true
      },
      
      {
        key = "showSpellName",
        label = { en = "Show name of the last cast spell", ru = "Показывать название последнего применённого заклинания" },
        tooltip = { en = "Show name of the last cast spell", ru = "Показывать название последнего применённого заклинания" },
        default = true
      },
      
      {
        key = "showServerLatency",
        label = { en = "Show server latency from .server info", ru = "Показывать задержку из .server info" },
        tooltip = { en = "Show server latency from .server info.\nWhen enabled, it automatically sends hidden '.server info' commands. A system error may pop up in chat when calling .menu/.server info manually.", ru = "Показывать задержку из .server info.\nПри включенной функции автоматически скрыто посылает команду .server info + может выскакивать системная ошибка в чат когда вызываем .menu/.server info (\"Команда не может быть обработана в текущий момент\")" },
        default = true
      },
      
      {
        key = "showServerUptime",
        label = { en = "Show server uptime from .server info", ru = "Показывать аптайм сервера из .server info" },
        tooltip = { en = "Show server uptime.\nWhen enabled, it automatically sends hidden '.server info' commands. A system error may pop up in chat when calling .menu/.server info manually.", ru = "Показывать аптайм сервера.\nПри включенной функции автоматически скрыто посылает команду .server info + может выскакивать системная ошибка в чат когда вызываем .menu/.server info (\"Команда не может быть обработана в текущий момент\")" },
        default = true
      },
      
      {
        key = "showMovementSpeed",
        label = { en = "Show movement speed percentage", ru = "Показывать скорость передвижения (%)" },
        tooltip = { en = "Show movement speed percentage", ru = "Показывать скорость передвижения (%)" },
        default = true
      },
      
      {
        key = "showAttackPowerOrSpd",
        label = { en = "Show Attack/Spell Power (AP/SP)", ru = "Показывать силу атаки/заклинаний (АП/СПД)" },
        tooltip = { en = "Show Attack/Spell Power (AP/SP)", ru = "Показывать силу атаки/заклинаний (АП/СПД)" },
        default = true
      },
      
      {
        key = "showResilience",
        label = { en = "Show resilience", ru = "Показывать устойчивость" },
        tooltip = { en = "Show resilience", ru = "Показывать устойчивость" },
        default = true
      },
      
      {
        key = "showParry",
        label = { en = "Show parry percentage", ru = "Показывать парирование (%)" },
        tooltip = { en = "Show parry percentage", ru = "Показывать парирование (%)" },
        default = true
      },
      
      {
        key = "showDodge",
        label = { en = "Show dodge percentage", ru = "Показывать уклонение (%)" },
        tooltip = { en = "Show dodge percentage", ru = "Показывать уклонение (%)" },
        default = false
      },
      
      {
        key = "showArmor",
        label = { en = "Show armor", ru = "Показывать броню" },
        tooltip = { en = "Show armor", ru = "Показывать броню" },
        default = true
      },
      
      {
        key = "showCrit",
        label = { en = "Show critical strike chance percentage", ru = "Показывать крит (%)" },
        tooltip = { en = "Show critical strike chance percentage", ru = "Показывать крит (%)" },
        default = false
      },
      
      {
        key = "showHaste",
        label = { en = "Show haste rating", ru = "Показывать рейтинг скорости" },
        tooltip = { en = "Show haste rating", ru = "Показывать рейтинг скорости" },
        default = false
      },
      
      {
        key = "showHit",
        label = { en = "Show hit rating", ru = "Показывать рейтинг меткости" },
        tooltip = { en = "Show hit rating", ru = "Показывать рейтинг меткости" },
        default = false
      },
      
      {
        key = "showPercentSign",
        label = { en = "Show percent sign", ru = "Показывать знак процента" },
        tooltip = { en = "Show percent sign", ru = "Показывать знак процента" },
        default = true
      },
      
      {
        key = "showBattlegroundStats",
        label = { en = "Show battleground stats (BGs played, wins, winrate)", ru = "Показывать статистику поля боя (кол-во игр, победы, винрейт)" },
        tooltip = { en = "Show basic battleground statistics: BGs played, wins, winrate (from achievement stats data)", ru = "Кол-во игр на бг, победы, винрейт (из данных статистики ачив)" },
        default = true
      },
      
      {
        key = "update_interval_server_info",
        label = { en = "Seconds between .server info requests", ru = "Частота отправок .server info в секундах" },
        tooltip = { en = "Interval between .server info requests in seconds.\nLower value = more frequent requests.\nPress ENTER to apply.", ru = "Интервал между отправками .server info в секундах.\nМеньше значение - чаще отправки.\nЧтобы применить - нажать ENTER." },
        default = 5, min = 1, max = 60
      },
      
      {
        key = "num_addons_to_display",
        label = { en = "Number of addons to display in game menu tooltip", ru = "Кол-во аддонов для отображения в тултипе игрового меню" },
        tooltip = { en = "How many addons to show in the list inside the game menu tooltip.\nPress ENTER to apply.", ru = "Сколько аддонов показывать в списке в тултипе от игрового меню.\nЧтобы применить - нажать ENTER." },
        default = 50, min = 1, max = 80
      },
      
      {
        key = "seconds_game_menu_update_interval",
        label = { en = "Game menu tooltip update interval (seconds)", ru = "Частота обновления тултипа игрового меню в секундах" },
        tooltip = { en = "Update interval for game menu tooltip values (where addon memory usage is shown) in seconds.\nLower value = more frequent updates.\nPress ENTER to apply.", ru = "Скорость обновления текста в тултипе от игрового меню в секундах(где видно потребление памяти аддонами).\nМеньше значение - чаще обновление.\nЧтобы применить - нажать ENTER." },
        default = 0.2, min = 0.01, max = 10
      },
      
      {
        key = "seconds_rtt_update_interval",
        label = { en = "RTT visual update interval (only text, seconds)", ru = "Частота обновления RTT в секундах (только визуально)" },
        tooltip = { en = "Interval to refresh RTT value text in seconds. Affects only the visual text update, not the actual RTT check rate.\nLower value = more frequent updates.\nPress ENTER to apply.", ru = "Скорость обновления текста RTT в секундах. Влияет только на частоту обновления текста, не влияет на частоту определения самого значения RTT.\nМеньше значение - чаще обновление.\nЧтобы применить - нажать ENTER." },
        default = 0.05, min = 0.01, max = 10
      },
      
      {
        key = "seconds_send_addon_message_interval",
        label = { en = "Send addon message interval (seconds, RTT check)", ru = "Частота отправок сообщений аддона в секундах для определения RTT" },
        tooltip = { en = "Minimum interval between addon messages for RTT checks in seconds.\nLower value = more frequent RTT checks.\nPress ENTER to apply.", ru = "Интервал между отправками сообщений аддона для определения RTT.\nМеньше значение - чаще определяется RTT.\nЧтобы применить - нажать ENTER." },
        default = 1, min = 0.1, max = 10
      },
      
      {
        key = "dynamicParticleDensityByFPS",
        label = { en = "Automatic particle density adjustment based on FPS", ru = "Авто регулировка плотности частиц в зависимости от фпс" },
        tooltip = { en = "Automatic particle density adjustment based on current FPS", ru = "Авто регулировка плотности частиц в зависимости от фпс" },
        default = true
      },
      
      {
        key = "particle_value_max",
        label = { en = "Maximum particle density value for auto adjustment", ru = "Максимальное значение плотности частиц при авто регулировке" },
        tooltip = { en = "Maximum allowed particle density value when using auto adjustment.\n1 = 100% (max), 0.1 = 10% (min).\nPress ENTER to apply.", ru = "Максимальное значение плотности частиц при авто регулировке.\n1 = 100% - максимум, 0.1 = 10% - минимум. Задать к примеру 0.5 для значения плотности частиц в 50%.\nЧтобы применить - нажать ENTER." },
        default = 1, min = 0.101, max = 1
      },
      
      {
        key = "target_min_fps",
        label = { en = "FPS threshold to decrease particle density (auto adjustment)", ru = "Отметка фпс, при падении до которой уменьшаем плотность частиц (при включённой авто регулировке)" },
        tooltip = { en = "FPS threshold to decrease particle density (when auto adjustment is enabled).\nPress ENTER to apply.", ru = "Отметка фпс, при падении до которой уменьшаем плотность частиц (при включённой авто регулировке).\nЧтобы применить - нажать ENTER." },
        default = 50, min = 15, max = 150
      },
      
      {
        key = "target_max_fps",
        label = { en = "FPS threshold to increase particle density (auto adjustment)", ru = "Отметка фпс, по достижении которой увеличиваем плотность частиц (при включённой авто регулировке)" },
        tooltip = { en = "FPS threshold to increase particle density (when auto adjustment is enabled).\nPress ENTER to apply.", ru = "Отметка фпс, по достижении которой увеличиваем плотность частиц (при включённой авто регулировке).\nЧтобы применить - нажать ENTER." },
        default = 59, min = 24, max = 200
      },
      
      {
        key = "hide_SYSMSG_SPAM_ERROR",
        label = { en = "Hide system error in chat caused by .server info spam", ru = "Скрывать системную ошибку в чате от спама .server info аддоном" },
        tooltip = { en = "Hide system error message in chat that appears due to automatic .server info requests", ru = "Скрывать системную ошибку в чате от спама .server info аддоном" },
        default = false
      }
    }

    -- { key = "server_info",
      -- label = { en = "Hidden .server info spam for show information as online and uptime", ru = "Невидимый спам .server info для получения инфы о задержке, онлайне и аптайме сервера" },
      -- tooltip = { en = "Hidden .server info spam for show information as online and uptime", ru = "Невидимый спам .server info для получения инфы о задержке, онлайне и аптайме сервера" },
      -- default = true },

    function cfgPanel.GetValueByKey(key, param)
      for _, opt in ipairs(cfgPanel.options) do
        if opt.key == key then
          return opt[param]
        end
      end
    end
    
    function cfgPanel.dynamicParticleDensityByFPS_MinMaxFpsUpdate()
      cfg.target_max_fps = max(cfgPanel.GetValueByKey("target_max_fps", "min"), cfg.target_max_fps)
      
      if GetCVar("gxVSync") == "1" and tonumber(GetCVar("maxfps")) >= 60 then
        cfg.target_max_fps = 59
        --print("cfg.target_max_fps", cfg.target_max_fps, "(gxVSync)")
      end
      
      if (cfg.target_max_fps - cfg.target_min_fps) < 5 then
        cfg.target_min_fps = max(cfgPanel.GetValueByKey("target_min_fps", "min"), cfg.target_max_fps - 6)
      end
    end
    
    -- -----------
    -- ApplySettings
    -- -----------
    function cfgPanel.ApplySettings()
      local textFrame = ns.textFrame --_G[ADDON_NAME.."_TextFrame"]
      local text = textFrame.text
      local particleDensityFrame = ns.particleDensityFrame --_G[ADDON_NAME.."_ParticleDensityBar_Frame"]
      
      if cfg.attachFrameToUIParent then
        textFrame:SetParent(UIParent)
        --text:SetFont(DEFAULT_FONT_NAME, (cfg.fontSize or DEFAULT_FONT_SIZE) +4) -- при привязке к UIParent размер шрифта по какой-то причине уменьшается (надо выяснить)
      else
        textFrame:SetParent(nil)
      end
      
      text:SetFont(type(cfg.fontName) == "string" and ADDON_FOLDER.."\\"..cfg.fontName or DEFAULT_FONT_NAME, 
        cfg.fontSize or DEFAULT_FONT_SIZE, 
        type(cfg.fontFlags) == "string" and cfg.fontFlags or "NONE") 
        
      textFrame:SetFrameStrata(cfg.frameStrata or DEFAULT_FRAME_STRATA)
      textFrame:SetFrameLevel(cfg.frameLevel or DEFAULT_FRAME_LEVEL)
      
      particleDensityFrame:SetFrameStrata(cfg.frameStrata or DEFAULT_FRAME_STRATA)
      particleDensityFrame:SetFrameLevel(cfg.frameLevel or DEFAULT_FRAME_LEVEL)
        
      if cfg.fontShadow then 
        text:SetShadowOffset(1, -1) 
      else
        text:SetShadowOffset(0, 0) 
      end
      
      textFrame:SetAlpha(cfg.alpha or DEFAULT_ALPHA)
      particleDensityFrame:SetAlpha(cfg.alpha or DEFAULT_ALPHA)
      
      if cfg.showParticleDensityBar then
        particleDensityFrame:Show()
      else
        particleDensityFrame:Hide()
      end
      
      if cfg.showSpellDelay then
        ns.RegEvents(particleDensityFrame, ns.spellEvents)
      else
        ns.UnRegEvents(particleDensityFrame, ns.spellEvents)
      end
      
      if cfg.showAttackPowerOrSpd or cfg.showResilience or cfg.showParry or cfg.showDodge or cfg.showArmor or cfg.showCrit or cfg.showHaste or cfg.showHit then
        ns.RegEvents(particleDensityFrame, ns.statsEvent)
      else
        ns.UnRegEvents(particleDensityFrame, ns.statsEvent)
      end
      
      if cfg.showWhoOnline then
        FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE") 
        SetWhoToUI(1)
      else
        FriendsFrame:RegisterEvent("WHO_LIST_UPDATE") 
        SetWhoToUI(0)
      end
      
      cfgPanel.dynamicParticleDensityByFPS_MinMaxFpsUpdate()
      
      if cfg.dynamicParticleDensityByFPS then
        --ns.dynamicParticleDensity:Show()
        ns.dynamicParticleDensity:SetScript("onupdate", ns.func_dynamicParticleDensity)
        --print("ns.dynamicParticleDensity:SetScript(\"onupdate\", ns.func_dynamicParticleDensity) (ApplySettings)")
      else
        --ns.dynamicParticleDensity:Hide()
        ns.dynamicParticleDensity:SetScript("onupdate", nil)
        --print("ns.dynamicParticleDensity:SetScript(\"onupdate\", nil)")
      end

      PERCENT_SIGN = cfg.showPercentSign and "%" or ""
      
      INDENT_BIG = cfg.indentSpaceCount and strep(" ", cfg.indentSpaceCount) or INDENT_BIG
      INDENT_SMALL = cfg.smallIndentSpaceCount and strep(" ", cfg.smallIndentSpaceCount) or INDENT_SMALL
      
      ns.ForceUpdateLocale()
      ns.updateZoneAndRaidInfo()
      ns.UpdateStats()
      ns.bgInfoString = ns.GetBgInfoText()
      
      cfgPanel:Hide()
      cfgPanel:Show()
      
      textFrame.update(true, textFrame)
    end
    
    -- ------------
    -- CreateMenu
    -- ------------
    function cfgPanel.CreateMenu(opt, y)
      local key = opt.key
      local labelText = Localise(opt.label) or key
      local tooltip = Localise(opt.tooltip)
      local def = opt.default
      local tbl = type(def) == "table" and def or opt.values

      local menu = CreateFrame("frame", ADDON_NAME.."_"..key.."_Frame", cfgPanel, "UIDropDownMenuTemplate")
      menu.disabled = opt.disabled
      menu:SetPoint("TOPLEFT", cfgTitle, "BOTTOMLEFT", -25, y and -y or -(ROW_HEIGHT * cfgPanel.optionsCreated))

      UIDropDownMenu_SetText(menu, cfg[key] or labelText)
      --print("test", _G[menu:GetName().."Text"]:GetStringWidth())
      UIDropDownMenu_SetWidth(menu, _G[menu:GetName().."Text"]:GetStringWidth() + 50) -- test
      --UIDropDownMenu_SetWidth(_G[menu:GetName().."Text"]:GetText():GetNumLetters() * 7 + 22)
      
      UIDropDownMenu_Initialize(menu, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        
        for k, v in ipairs(tbl) do
          info.text = v
          info.notCheckable = true
          info.menuList = k --??
          info.func = function() 
            UIDropDownMenu_SetText(menu, v) 
            cfg[key] = v
            --print("test", _G[menu:GetName().."Text"]:GetStringWidth())
            UIDropDownMenu_SetWidth(menu, _G[menu:GetName().."Text"]:GetStringWidth() + 50) -- test
            cfgPanel.ApplySettings()
          end
          
          UIDropDownMenu_AddButton(info)
        end
      end)
      
      menu:SetScript("OnShow", function(self)
        UIDropDownMenu_SetText(menu, cfg[key]) 
        UIDropDownMenu_SetWidth(self, _G[self:GetName().."Text"]:GetStringWidth() + 50) -- test
        cfgPanel.SetDisabledOption(key, self.disabled)
      end)
      
      -- фрейм текста описания
      local labelFrame = CreateFrame("Button", ADDON_NAME.."_"..key.."_TextFrame", menu) 
      labelFrame:SetPoint("LEFT", menu, "RIGHT", -10, 3)
      
      -- текст описания
      local label = labelFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
      label:SetFont(GameFontNormal:GetFont(), 12)
      label:SetPoint("LEFT", menu, "RIGHT", 0, 0)
      label:SetText(labelText)
      label:SetJustifyH("LEFT")
      label:SetJustifyV("BOTTOM")
      label:SetAllPoints(labelFrame) 
      
      menu.text = label
      
      labelFrame:SetScript("OnShow", function(self)
        self:SetSize(label:GetStringWidth(), label:GetStringHeight())
      end)
      
      if tooltip then
        labelFrame:SetScript("OnEnter", function(self)
          if menu.disabled then return end
          GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(type(def)=="string" and def or type(def)=="table" and def[1] or tbl[1]), 0,1,1)
          GameTooltip:Show()
          --cfgPanel.DesaturateOtherOptionsText(key)
          --GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1)
        end)
        labelFrame:SetScript("OnLeave", function() 
          GameTooltip:Hide() 
          --cfgPanel.SetNormalColorOptionsText() 
        end)
      end
    end
    
    -- GameTooltip:HookScript("OnUpdate", function(self)
      -- local owner = self:GetOwner()
      -- local name = owner and owner:GetName()
      -- if name and name:find(ADDON_NAME) then
        -- --print("GameTooltip:SetBackdropColor")
        -- self:SetBackdrop({
          -- bgFile = "Interface\\Buttons\\WHITE8X8", -- Сплошная заливка
          -- edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- Стандартная рамка
          -- tile = true,
          -- tileSize = 16,
          -- edgeSize = 16,
          -- insets = { left = 5, right = 5, top = 5, bottom = 5 }
        -- })
        -- self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
        -- self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
        -- if owner.UpdateTooltip then
          -- owner:UpdateTooltip()
        -- end
      -- end
    -- end)

    -- --------------
    -- CreateCheckbox
    -- --------------
    function cfgPanel.CreateCheckbox(opt, y)
      local key = opt.key
      local labelText = Localise(opt.label) or key
      local tooltip = Localise(opt.tooltip)
      local def = opt.default
 
      local cb = CreateFrame("CheckButton", ADDON_NAME.."_"..key.."_Frame", cfgPanel, "UICheckButtonTemplate")
      cb.disabled = opt.disabled
      cb:SetPoint("TOPLEFT", cfgTitle, "BOTTOMLEFT", -8, y and -y or -(ROW_HEIGHT * cfgPanel.optionsCreated))
      cb:SetSize(28,28)

      -- фрейм текста описания
      local labelFrame = CreateFrame("Button", ADDON_NAME.."_"..key.."_TextFrame", cb) 
      labelFrame:SetPoint("LEFT", cb, "RIGHT", 0, 0)
      
      -- текст описания
      local label = labelFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
      label:SetFont(GameFontNormal:GetFont(), 12)
      label:SetPoint("LEFT", cb, "RIGHT", 0, 0)
      label:SetText(labelText)
      label:SetJustifyH("LEFT")
      label:SetJustifyV("BOTTOM")
      label:SetAllPoints(labelFrame) 
      
      cb.text = label
      
      labelFrame:SetScript("OnClick", function(self) 
        if cb.disabled then return end
        if cb:GetChecked() then
          cb:SetChecked(false)
        else
          cb:SetChecked(true)
        end
        cfg[key] = cb:GetChecked() and true or false
        cfgPanel.ApplySettings()
      end)
      
      labelFrame:SetScript("OnShow", function(self)
        self:SetSize(label:GetStringWidth(), label:GetStringHeight())
      end)
      
      cb:SetScript("OnClick", function(self)
        cfg[key] = self:GetChecked() and true or false
        cfgPanel.ApplySettings()
      end)

      cb:SetScript("OnShow", function(self)
        self:SetChecked(cfg[key])
        cfgPanel.SetDisabledOption(key, self.disabled)
      end)
      
      if tooltip then
        cb:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def), 0,1,1)
          GameTooltip:Show()
          --cfgPanel.DesaturateOtherOptionsText(key)
          --GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1)
        end)
        cb:SetScript("OnLeave", function() 
          GameTooltip:Hide() 
          --cfgPanel.SetNormalColorOptionsText() 
        end)
        
        labelFrame:SetScript("OnEnter", function(self)
          if cb.disabled then return end
          GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def), 0,1,1)
          GameTooltip:Show()
          --cfgPanel.DesaturateOtherOptionsText(key)
          --GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1)
        end)
        labelFrame:SetScript("OnLeave", function() 
          GameTooltip:Hide() 
          --cfgPanel.SetNormalColorOptionsText() 
        end)
      end
    end

    -- ----------------
    -- CreateEditBox
    -- ----------------
    function cfgPanel.CreateEditBox(opt, y)
      local key = opt.key
      local labelText = Localise(opt.label) or key
      local tooltip = Localise(opt.tooltip)
      local def = opt.default
      local minV = opt.min
      local maxV = opt.max
      local type = type(def)
      local isNumber = (type == "number" and minV and maxV)
    
      local eb = CreateFrame("EditBox", ADDON_NAME.."_"..key.."_Frame", cfgPanel, "InputBoxTemplate")
      eb.disabled = opt.disabled
      eb:SetAutoFocus(false)
      eb:SetPoint("TOPLEFT", cfgTitle, "BOTTOMLEFT", 0, y and -y or -(ROW_HEIGHT * cfgPanel.optionsCreated))
      eb:SetFont(GameFontNormal:GetFont(), 12)
      eb:SetSize(20, 20)
      
      -- фрейм текста
      local labelFrame = CreateFrame("Button", ADDON_NAME.."_"..key.."_TextFrame", eb) 
      labelFrame:SetPoint("LEFT", eb, "RIGHT", 4, 0) --??
      
      -- текст
      local label = labelFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
      label:SetFont(GameFontNormal:GetFont(), 12)
      label:SetPoint("LEFT", eb, "RIGHT", 0, 0)
      label:SetText(labelText)
      label:SetJustifyH("LEFT")
      label:SetJustifyV("BOTTOM")
      label:SetAllPoints(labelFrame) 
      
      eb.text = label
      
      eb:SetScript("OnEditFocusLost", function(self) 
        self:SetText(tostring(cfg[key]))
      end)
      
      eb:SetScript("OnEditFocusGained", function(self) 
        if self.disabled then
          self:ClearFocus() 
        else
          self:HighlightText()
        end
      end)
      
      eb:SetScript("OnShow", function(self)
        self:SetText(tostring(cfg[key]))
        self:SetCursorPosition(0) -- делает видимым весь текст, если не задать - то при показе фрейма будет скрыта та часть текста, что вначале
        cfgPanel.SetDisabledOption(key, self.disabled)
      end)

      eb:SetScript("OnEnterPressed", function(self) 
        local val = self:GetText()
        if isNumber then
          local num = tonumber(val)
          if not num then
            self:SetText(tostring(cfg[key]))
          else
            if minV and num < minV then num = minV end
            if maxV and num > maxV then num = maxV end
            cfg[key] = num
            self:SetText(tostring(cfg[key]))
          end
        else
          if val == "" then val = nil end
          cfg[key] = val or ""
          self:SetText(tostring(cfg[key]))
        end
        self:ClearFocus()
        cfgPanel.ApplySettings()
      end)
      
      eb:SetScript("OnEscapePressed", function(self) 
        self:SetText(tostring(cfg[key]))
        self:ClearFocus() 
      end)
      
      eb:SetScript("OnUpdate", function(self) 
        if not self.disabled then 
          if self:HasFocus() then
            if isNumber then
              local val = tonumber(self:GetText())
              if not val or (maxV and val > maxV) or (minV and val < minV) then
                self:SetTextColor(1,0,0)
                label:SetText("|cffff0000"..INCORRECT_VALUE.."!|r "..labelText.." (number, default: "..def..", min: "..minV..", max: "..maxV..")")
              else
                self:SetTextColor(0,1,0)
                label:SetText(labelText)
              end
            end
          else
            self:SetTextColor(1,1,1)
            label:SetText(labelText)
          end
        end
        
        self:SetWidth(self:GetNumLetters() * 7 + 22)
        label:SetPoint("LEFT", self, "RIGHT", 3, 0)
        labelFrame:SetSize(label:GetStringWidth(), label:GetStringHeight())
      end)

      if tooltip then
        eb:SetScript("OnEnter", function(self)
          if self.disabled then return end
          GameTooltip:SetOwner(self, "ANCHOR_TOP")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def), 0,1,1)
          if isNumber and minV and maxV then
            GameTooltip:AddLine("Min: "..tostring(minV)..", Max: "..tostring(maxV), 0,1,1)
          end
          GameTooltip:Show()
          --cfgPanel.DesaturateOtherOptionsText(key)
          --GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1)
        end)
        eb:SetScript("OnLeave", function() 
          GameTooltip:Hide() 
          --cfgPanel.SetNormalColorOptionsText() 
        end)
        
        labelFrame:SetScript("OnEnter", function(self)
          if eb.disabled then return end
          GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def), 0,1,1)
          if isNumber and minV and maxV then
            GameTooltip:AddLine("Min: "..tostring(minV)..", Max: "..tostring(maxV), 0,1,1)
          end
          GameTooltip:Show()
          --cfgPanel.DesaturateOtherOptionsText(key)
          --GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1)
        end)
        labelFrame:SetScript("OnLeave", function() 
          GameTooltip:Hide() 
          --cfgPanel.SetNormalColorOptionsText() 
        end)
      end
    end

    -- -------------------------
    -- initialize defaults
    -- -------------------------
    function cfgPanel.LoadConfig()
      cfg = mrcatsoul_Mori_EdgeInfo_Data or cfg
      mrcatsoul_Mori_EdgeInfo_Data = cfg
      --_G[ADDON_NAME] = cfg
      
      for _, opt in ipairs(cfgPanel.options) do
        if cfg[opt.key] == nil and opt.default ~= nil then
          cfg[opt.key] = type(opt.default) == "table" and opt.default[1] or opt.default
          print(tostring(opt.key), tostring(opt.default))
        end
      end
      
      if not cfg.lockedAndLoaded then
        cfg.lockedAndLoaded = true
        DelayedCall(4, function()
          StaticPopup_Show(ADDON_NAME .. "_TEST1") -- test
        end)
      end

      --cfgPanel.CreateOptionsUI()
      cfgPanel.ApplySettings()
      
      DelayedCall(0.1, function()
        print(ADDON_NAME_LOCALE, Localise({ en = "loaded", ru = "загружен" })..".", cfgPanel.MakeChatLink(Localise({ en = "Settings", ru = "Настройки" }), "Settings"), " | ", cfgPanel.MakeChatLink(Localise({ en = "About", ru = "Об аддоне" }), "About"))
      end)
      
      return cfg
    end
    
    InterfaceOptionsFrame:HookScript("onshow", function()
      cfgPanel.CreateOptionsUI()
    end)
    
    -- function cfgPanel.DesaturateOtherOptionsText(currentKey)
      -- if not currentKey then return end
      -- local currentFrame = _G[ADDON_NAME.."_"..currentKey.."_Frame"]
      -- if not currentFrame then return end

      -- local frame
      -- for _, opt in pairs(cfgPanel.options) do
        -- frame = _G[ADDON_NAME.."_"..opt.key.."_Frame"]
        -- if frame and frame ~= currentFrame and frame.text then
          -- print(NORMAL_FONT_COLOR.r/5, NORMAL_FONT_COLOR.g/5, NORMAL_FONT_COLOR.b/5)
          -- frame.text:SetVertexColor(NORMAL_FONT_COLOR.r/2, NORMAL_FONT_COLOR.g/2, NORMAL_FONT_COLOR.b/2)
        -- end
      -- end
    -- end
    
    -- function cfgPanel.SetNormalColorOptionsText()
      -- local frame
      -- for _, opt in pairs(cfgPanel.options) do
        -- frame = _G[ADDON_NAME.."_"..opt.key.."_Frame"]
        -- if frame and frame.text then
          -- frame.text:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
        -- end
      -- end
    -- end
    
    function cfgPanel.SetDisabledOption(key, val)
      if not key then return end
      local frame = _G[ADDON_NAME.."_"..key.."_Frame"]
      if not frame then return end
      --print("SetDisabledOption", key, val)
      
      frame.disabled = val
      
      local r, g, b = GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
      
      if not val then
        r, g, b = NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
      end
    
      -- menu
      if val and _G[frame:GetName().."Button"] and _G[frame:GetName().."Button"].Disable then
        _G[frame:GetName().."Button"]:Disable()
      elseif not val and _G[frame:GetName().."Button"] and _G[frame:GetName().."Button"].Enable then
        _G[frame:GetName().."Button"]:Enable()
      end
      
      if _G[frame:GetName().."Button"] then
        _G[frame:GetName().."Text"]:SetVertexColor(r, g, b)
      end
      
      -- checkbox
      if val and frame.Disable then
        frame:Disable()
      elseif not val and frame.Enable then
        frame:Enable()
      end

      if frame.text then
        frame.text:SetVertexColor(r, g, b)
      end
      
      if frame.SetTextColor then
        frame:SetTextColor(r, g, b)
      end
    end
    
    function cfgPanel.SetDisabledAllOptions(val)
      for _, opt in pairs(cfgPanel.options) do
        cfgPanel.SetDisabledOption(opt.key, val)
      end
    end
    --_G.SetDisabledAllOptions = cfgPanel.SetDisabledAllOptions
    
    function cfgPanel.CreateOptionsUI()
      if cfgPanel.optionsCreated then return end
      cfgPanel.optionsCreated = 1
      --print("CreateOptionsUI")
      
      local y, lastOptionType = -8
      
      for _, opt in ipairs(cfgPanel.options) do
        local type = opt.type or opt.values and type(opt.values) or type(opt.default)
        --print(type)
        if type == "select" or type == "table" then -- меню
          if lastOptionType == "table" or lastOptionType == "select" then
            y = y + ROW_HEIGHT + 2
          else
            y = y + ROW_HEIGHT - 2
          end
          cfgPanel.CreateMenu(opt, y)
        elseif type == "boolean" or type == "toggle" then -- чекбокс
          if lastOptionType == "table" or lastOptionType == "select" then
            y = y + ROW_HEIGHT + 2
          elseif lastOptionType == "number" or lastOptionType == "string" or lastOptionType == "input" or lastOptionType == "range" then
            y = y + ROW_HEIGHT - 2
          else
            y = y + ROW_HEIGHT
          end
          cfgPanel.CreateCheckbox(opt, y)
        elseif type == "number" or type == "string" or type == "input" or type == "range" then -- эдитбокс
          if lastOptionType == "table" or lastOptionType == "select" then
            y = y + ROW_HEIGHT + 6
          elseif lastOptionType == "boolean" or lastOptionType == "toggle" then
            y = y + ROW_HEIGHT + 4
          else
            y = y + ROW_HEIGHT + 2
          end
          cfgPanel.CreateEditBox(opt, y)
        end
        
        lastOptionType = type
      end
      
      cfgPanel.optionsCreated = cfgPanel.optionsCreated +1

      -- Reset to defaults button
      local resetCount = 0
      local reset = CreateFrame("Button", ADDON_NAME.."_ResetBtn", cfgPanel, "UIPanelButtonTemplate")
      reset:SetSize(140, 22)
      reset:SetPoint("RIGHT", titleTip, "RIGHT", 0, -35)
      reset:SetText(Localise({ en = "Reset to defaults", ru = "Сбросить к умолчаниям" }))
      reset:SetScript("OnClick", function(self)
        if resetCount == 0 then
          DelayedCall(5, function()
            resetCount = 0
            if GameTooltip:GetOwner() == self and GameTooltip:IsShown() then
              GameTooltip:SetText(Localise({ en = "To reset, press 5 times.", ru = "Чтобы выполнить сброс нажать быстро 5 раз." }))
            end
          end)
        end
        resetCount = resetCount +1
        if resetCount >= 5 then
          resetCount = 0
          for _, opt in ipairs(cfgPanel.options) do
            cfg[opt.key] = type(opt.default) == "table" and opt.default[1] or opt.default
          end
          cfgPanel.ApplySettings()
          UIFrameFlashStop(cfgPanel)
          UIFrameFlash(cfgPanel, 1.5, 0.5, 2, true, 2, 0)
          GameTooltip:SetText(Localise({ en = "The config reset was successful.", ru = "Сброс конфига успешно выполнен." }))
        else
          local needCount = 5 - resetCount
          GameTooltip:SetText(Localise({ en = "To reset, press 5 times.|r\n"..(5-resetCount).." times remaining.", ru = "Чтобы выполнить сброс нажать быстро 5 раз.|r\nОсталось "..(5-resetCount).." раз(а)." }))
        end
      end)
      
      reset:SetScript("OnEnter", function(self) 
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        if resetCount == 0 then
          GameTooltip:SetText(Localise({ en = "To reset, press 5 times.", ru = "Чтобы выполнить сброс нажать быстро 5 раз." }))
        else
          GameTooltip:SetText(Localise({ en = "To reset, press 5 times.|r\n"..(5-resetCount).." times remaining.", ru = "Чтобы выполнить сброс нажать быстро 5 раз.|r\nОсталось "..(5-resetCount).." раз(а)." }))
        end
        GameTooltip:Show() 
      end)

      reset:SetScript("OnLeave", function(self) 
        --resetCount = 0
        GameTooltip:Hide() 
      end)
      
      cfgPanel:Hide()
      cfgPanel:Show()
    end
  end
  -- end settings
  
  -- Серверное время (Realm)
  local GameTime
  do
    local format = string.format
    local floor = math.floor
    local date = date
    local GetTime = GetTime
    local GetGameTime = GetGameTime
  
    GameTime = {
      Get = function(self)
        if self.LastMinuteTimer == nil then
          local h, m = GetGameTime()
          return h, m, 0
        end
        
        local s = GetTime() - self.LastMinuteTimer
        if s > 59.999 then
          s = 59.999
        end
        local ms = floor((s % 1) * 1000 + 0.5)
        
        return self.LastGameHour, self.LastGameMinute, floor(s), ms
      end,

      -- Форматирование серверного времени с учетом опций
      GetFormatted = function(self, showMs)
        local h, m, s, ms = self:Get()
        if showMs and s and ms then
          local interval = cfg.updateIntervalGlobal or 0.025
          if interval > 0.05 then
            -- Оставляем только одну цифру (десятые доли)
            return format("%02d:%02d:%02d.%d", h, m, s, floor(ms / 100))
          else
            -- Показываем полные миллисекунды
            return format("%02d:%02d:%02d.%03d", h, m, s, ms)
          end
        else
          return format("%02d:%02d", h, m)
        end
      end,

      OnUpdate = function(self, elapsed)
        self.tick = (self.tick or 0) + elapsed
        if self.tick < 0.5 then return end
        self.tick = 0

        local h, m = GetGameTime()
        if self.LastGameMinute == nil then
          self.LastGameHour, self.LastGameMinute = h, m
          return
        end
        
        if self.LastGameMinute ~= m then
          self.LastGameHour, self.LastGameMinute = h, m
          self.LastMinuteTimer = GetTime()
        end
      end,

      Initialize = function(self)
        self.Frame = CreateFrame("Frame")
        self.Frame:SetScript("OnUpdate", function(_, elapsed) self:OnUpdate(elapsed) end)
      end
    }
    GameTime:Initialize()
  end

  -- Локальное время (Local)
  local TimeFormatter = {}
  do
    local format = string.format
    local floor = math.floor
    local date = date
    local GetTime = GetTime
    local tostring = tostring

    local daysRU = {
      ["0"] = "Воскресенье", ["1"] = "Понедельник", ["2"] = "Вторник",
      ["3"] = "Среда", ["4"] = "Четверг", ["5"] = "Пятница", ["6"] = "Суббота"
    }

    TimeFormatter.cachedSeconds = -1
    TimeFormatter.cachedDateString = ""
    TimeFormatter.lastSettingsMask = "" -- Для сброса кэша при смене настроек

    function TimeFormatter:GetFormattedTime(showDate, showDayOfWeek, showMs)
      if not self.timeOffset then
        self.timeOffset = time() - floor(GetTime())
      end

      self.now = GetTime()
      self.seconds = floor(self.now)
      
      -- Генерируем маску настроек, чтобы понять, менялись ли они
      self.settingsMask = format("%s%s", tostring(showDate), tostring(showDayOfWeek))

      -- Обновляем кэш строки (раз в секунду или при смене настроек)
      if self.seconds ~= self.cachedSeconds or self.settingsMask ~= self.lastSettingsMask then
        self.cachedSeconds = self.seconds
        self.lastSettingsMask = self.settingsMask
        
        self.fullTime = self.timeOffset + self.seconds
        self.timePart = date("%H:%M:%S", self.fullTime)
        self.datePart = showDate and date("%d.%m.%Y  ", self.fullTime) or ""
        
        self.dayPart = ""
        if showDayOfWeek then
          if ns.L == "ruRU" then
            self.dayPart = daysRU[date("%w", self.fullTime)] .. "  "
          else
            self.dayPart = date("%A  ", self.fullTime)
          end
        end
        
        self.cachedDateString = self.dayPart .. self.datePart .. self.timePart
      end

      -- Миллисекунды добавляем всегда «на лету», так как они меняются каждый кадр
      if showMs then
        local fraction = self.now - self.seconds
        local interval = cfg.updateIntervalGlobal or 0.025
        
        if interval > 0.05 then
          -- Умножаем остаток на 10 и отбрасываем дробную часть для получения десятых
          local tenths = floor(fraction * 10)
          return format("%s.%d", self.cachedDateString, tenths)
        else
          -- Оригинальный вариант с тысячными
          local ms = floor(fraction * 1000)
          return format("%s.%03d", self.cachedDateString, ms)
        end
      else
        return self.cachedDateString
      end
    end
  end
  
  -- FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE") 
  -- WhoFrameWhoButton:HookScript("onclick", function(self, button)
    -- WhoList_Update()
  -- end)
  -- SetWhoToUI(1)
  
  WhoFrame:HookScript("OnShow", function(self)
    if cfg.showWhoOnline then
      FriendsFrame:RegisterEvent("WHO_LIST_UPDATE")
      print("RegisterEvent(\"WHO_LIST_UPDATE\")")
    end
  end)
  
  WhoFrame:HookScript("OnHide", function(self)
    if cfg.showWhoOnline then
      FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
      print("UnregisterEvent(\"WHO_LIST_UPDATE\")")
    end
  end)
  
  function ns.formatTime(seconds)
    if seconds >= 60 then
      return format("%.1dm %.2ds", floor(seconds / 60), seconds % 60)
    else
      return format("%.1ds", seconds)
    end
  end
   
  -- Создаем статус-бар
  do
    local f = CreateFrame("StatusBar", ADDON_NAME.."_ParticleDensityBar_Frame", UIParent)
    ns.particleDensityFrame = f
    f:SetClampedToScreen(true)
    f:SetSize(PARTICLE_DENSITY_BAR_MIN_WIDTH, PARTICLE_DENSITY_BAR_MIN_HEIGHT)
    f:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 172, 36)
    f:SetFrameStrata(cfg.frameStrata or DEFAULT_FRAME_STRATA)
    f:SetFrameLevel(cfg.frameLevel or DEFAULT_FRAME_LEVEL)
    f:SetMinMaxValues(0, 100)
    f:SetValue(0)
    f:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    f:SetStatusBarColor(1, 0, 0)  -- начальное значение - красный
    
    -- Делаем фрейм "пользовательским", чтобы WoW сохранял его параметры в layout-local.txt
    f:SetMovable(true)
    f:SetResizable(true)
    f:SetUserPlaced(true)  -- ✅ Ключевая строка для сохранения в layout-local.txt
    
    f:SetAlpha(cfg.alpha or DEFAULT_ALPHA)

    -- Обводка (черная рамка, тоньше)
    f.border = CreateFrame("Frame", nil, f)
    f.border:SetPoint("TOPLEFT", -0.5, 0.5)   -- Уменьшаем отступы
    f.border:SetPoint("BOTTOMRIGHT", 0.5, -0.5)
    f.border:SetBackdrop({
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      edgeSize = 4,   -- ✅ Уменьшаем толщину рамки
    })
    f.border:SetBackdropBorderColor(0, 0, 0, 1)
    
    function f.UpdateBarColor(bar, value, maxValue)
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
    function f.UpdateStatusBarColor(self)
      local value = self:GetValue()
      local min, max = self:GetMinMaxValues()
      local percent = (value - min) / (max - min)
      local red = 1 - percent      -- при 0% красный = 1
      local green = percent        -- при 100% зеленый = 1
      f.UpdateBarColor(self, value, max)
    end

    f:SetScript("OnValueChanged", f.UpdateStatusBarColor)

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
        f.border:SetPoint("TOPLEFT", -1, 1)
        f.border:SetPoint("BOTTOMRIGHT", 1, -1)
      end
    end)
    
    local textFrame = CreateFrame("frame", ADDON_NAME.."_TextFrame")
    ns.textFrame = textFrame
    textFrame:SetFrameStrata(cfg.frameStrata or "high")
    textFrame:SetFrameLevel(cfg.frameLevel or DEFAULT_FRAME_LEVEL)

    local text = textFrame:CreateFontString(nil, "background")
    text:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 1)
    --text:SetPoint("LEFT", "ActionButton1", "LEFT", -255, -7)
    --text:SetFont([[Interface\addons\CustomFrames\hooge test1.ttf]], 11, "OUTLINE, MONOCHROME")
    text:SetFont(type(cfg.fontName) == "string" and ADDON_FOLDER.."\\"..cfg.fontName or DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE)
    if cfg.fontShadow then text:SetShadowOffset(1, -1) end
    text:SetTextColor(1, 1, 1, 1)
    text:SetJustifyH("LEFT")
    --text:SetJustifyV("BOTTOM")
    textFrame.text = text

    function f.truncate(num, digits)
      local mult = 10 ^ (digits or 1)
      return floor(num * mult) / mult
    end
    
    -- local function formatTrimmed(num)
      -- num = tonumber(num)
      -- if num then
        -- local rounded = floor(num * 10 + 0.5) / 10  -- округление до 1 знака
        -- if rounded % 1 == 0 then
          -- return format("%d", rounded)  -- целое число без дробной части
        -- else
          -- return format("%.1f", rounded)
        -- end
      -- end
      -- return -1
    -- end
    
    function f.tLength(T)
      local count = 0
      for _ in pairs(T) do count = count + 1 end
      return count
    end
    
    -- local function rgbToHex(r, g, b)
      -- return format("%02x%02x%02x", floor(255 * r), floor(255 * g), floor(255 * b))
    -- end
    
    function f.rgbToHex(r, g, b)
      return format("%02x%02x%02x", r*255, g*255, b*255)
    end
    
    f.gradientColor = { 0, 1, 0, 1, 1, 0, 1, 0, 0 }

    function f.ColorGradient(perc, ...)
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
    
    function f.RGBGradient(num)
      local r, g, b = f.ColorGradient(num, unpack(f.gradientColor))
      -- Преобразуем значения компонент цвета в формат FFFFFF
      local hexColor = format("%02x%02x%02x", r * 255, g * 255, b * 255)
      return hexColor
    end
    
    -- ОПТИМИЗАЦИЯ ЦВЕТА: Кэширование результата RGBGradient
    -- Вычисляет цвет только если значение изменилось
    f.colorCache = {}
    function f.GetCachedColor(key, value, divisor)
      -- value - текущее значение (число)
      -- divisor - на что делить для градиента (150 для пинга, 60 для фпс и т.д.)
      local cache = f.colorCache[key]
      if not cache then
         cache = { val = -1, color = "ffffff" }
         f.colorCache[key] = cache
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
      cache.color = f.RGBGradient(ratio)
      return cache.color
    end

    function f.IsMeleeClass()
      return select(2, UnitClass("player")) == "ROGUE"
      or select(2, UnitClass("player")) == "WARRIOR"
      or select(2, UnitClass("player")) == "DEATHKNIGHT"
      or (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(1)) < 51)
      or (select(2, UnitClass("player")) == "SHAMAN" and select(3, GetTalentTabInfo(2)) >= 51)
      or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(2)) >= 51)
    end

    function f.IsSpellPowerClass()
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

    function f.IsHealerClass()
      return (select(2, UnitClass("player")) == "PALADIN" and select(3, GetTalentTabInfo(1)) >= 51)
      or (select(2, UnitClass("player")) == "SHAMAN" and select(3, GetTalentTabInfo(3)) >= 51)
      or (select(2, UnitClass("player")) == "DRUID" and select(3, GetTalentTabInfo(3)) >= 51)
      or (select(2, UnitClass("player")) == "PRIEST" and select(3, GetTalentTabInfo(3)) < 51)
    end
    --_G.IsHealerClass = IsHealerClass
    
    function ns.updateZoneAndRaidInfo()
      local isInstance, InstanceType = IsInInstance()
      InDungeon, InRaidDungeon, InBg, InArena, InRaidGroup, spectatorMode, instanceDifficulty, zonePvpType, showAttackPower, showSpellPower, InCrossZone, isHunter = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil

      local _, type, _, _, maxPlayers, playerDifficulty = GetInstanceInfo()
      zonePvpType = GetZonePVPInfo()
      curZone = GetRealZoneText()
      if curZone == nil or curZone == "" then
        curZone = UNKNOWN
      end

      if zonePvpType=="sanctuary" then zoneColor = f.rgbToHex(0.41, 0.8, 0.94)
        elseif zonePvpType=="contested" then zoneColor = f.rgbToHex(1.0, 0.7, 0)
        elseif zonePvpType=="friendly" then zoneColor = f.rgbToHex(0.1, 1.0, 0.1)
        elseif zonePvpType=="hostile" then zoneColor = f.rgbToHex(1.0, 0.1, 0.1)
        elseif zonePvpType=="combat" then zoneColor = f.rgbToHex(1.0, 0.1, 0.1)
        elseif zonePvpType=="arena" then zoneColor = f.rgbToHex(1.0, 0.1, 0.1)
        else zoneColor = f.rgbToHex(1.0, 0.9294, 0.7607)
      end

      if type == "party" or type == "raid" then
        if maxPlayers == 10 and playerDifficulty==0 then
          instanceDifficulty = "10"
        elseif maxPlayers == 10 and playerDifficulty==1 then
          instanceDifficulty = "10" .. COMBATLOG_ICON_RAIDTARGET8
        elseif maxPlayers == 25 and playerDifficulty==0 then
          instanceDifficulty = "25"
        elseif maxPlayers == 25 and playerDifficulty==1 then
          instanceDifficulty = "25" .. COMBATLOG_ICON_RAIDTARGET8
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
      showSpellPower = f.IsSpellPowerClass() or f.IsHealerClass()
      showAttackPower = f.IsMeleeClass()
      isHunter = select(2, UnitClass("player")) == "HUNTER"
      
      wipe(ns.UNIT_SPELLCAST_SENT)
      wipe(ns.UNIT_SPELLCAST_SUCCEEDED)
    end

    ns.RezTimerInfoTblParts = {}
    function ns.GetRezTimerInfo()
      wipe(ns.RezTimerInfoTblParts)
      
      local isDead = UnitIsDeadOrGhost("player")
      local recoveryDelay = isDead and GetCorpseRecoveryDelay() or 0
      local BattlefieldInstanceRunTime = GetBattlefieldInstanceRunTime()
      
      -- 1. Таймер БГ (если есть данные)
      local bgCD = InBg and BattlefieldInstanceRunTime > 120000 and RezTimer_Data and RezTimer_Data.cd
      if bgCD then
        tinsert(ns.RezTimerInfoTblParts, format("%s:%s|cffff8822%s|r", TO_RES, INDENT_SMALL, bgCD))
      end
      
      -- 2. Таймер до тела (универсальный блок)
      if isDead then
        local label = bgCD and BY_CORPSE or TO_RES_BY_CORPSE
        local timeStr = (recoveryDelay > 0) 
          and format("|cffff8822%s|r", ns.formatTime(recoveryDelay)) 
          or format("|cff33ff33%s|r", READY)
        
        tinsert(ns.RezTimerInfoTblParts, format("%s:%s%s", label, INDENT_SMALL, timeStr))
      end
      
      -- 3. Счетчик врагов
      if InBg and BattlefieldInstanceRunTime > 120000 and RezTimer_Data and RezTimer_Data.counter and GetBattlefieldInstanceRunTime() > 120000 then
        tinsert(ns.RezTimerInfoTblParts, format("%s:%s|cffff6622%d|r", ENEMIES, INDENT_SMALL, RezTimer_Data.counter))
      end
      
      return tconcat(ns.RezTimerInfoTblParts, INDENT_BIG)
    end
    
    ns.BgInfoTextParts, ns.BgData = {}, {}
    function ns.GetBgInfoText()
      local bgstats = bg_statistics and bg_statistics[playerGUID]
      wipe(ns.BgInfoTextParts)
      wipe(ns.BgData)

      if bgstats then
        -- Берем данные из текущей сессии БГ
        ns.BgData.rating = bgstats.rating
        ns.BgData.wins = bgstats.wins or 0
        ns.BgData.games = bgstats.games or 0
      else
        -- Берем общие данные персонажа
        ns.BgData.wins = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_WON)) or 0
        ns.BgData.games = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_PLAYED)) or 0
      end

      -- Считаем винрейт (один раз для обоих случаев)
      local wr = (ns.BgData.games > 0) and (ns.BgData.wins / ns.BgData.games * 100) or 0
      local wrColor = (ns.BgData.games > 0) and f.RGBGradient(1 - wr / 100) or "999999"

      -- Собираем итоговую строку
      local parts = {
        format("%s:%s|cccf1f1a1%d|r", GAMES, INDENT_SMALL, ns.BgData.games),
        format("%s:%s|cccf1f1a1%d|r", WINS, INDENT_SMALL, ns.BgData.wins),
        format("%s:%s|ccc%s%d%%|r", WINRATE, INDENT_SMALL, wrColor, f.truncate(wr))
      }

      if ns.BgData.rating then
        tinsert(parts, format("%s:%s%d", BG_PTS, INDENT_SMALL, ns.BgData.rating))
      end

      return tconcat(parts, INDENT_BIG)
    end

    --[[
    ns.StatsTextParts = {}
    function ns.GetStatsText()
      -- 1. Определяем базовые значения
      local spdOrAp, crit, haste, hit = 0, 0, 0, 0
      local attackPowerLabel = ATTACK_POWER -- По умолчанию AP

      if showSpellPower then
        attackPowerLabel = SPELL_POWER
        
        -- Start at 2 to skip physical damage
        spdOrAp = GetSpellBonusDamage(2)
        crit = GetSpellCritChance(2)
        
        for i = 3, MAX_SPELL_SCHOOLS do
          spdOrAp = min(spdOrAp, GetSpellBonusDamage(i))
          crit = min(crit, GetSpellCritChance(i))
        end
        
        haste = GetCombatRating(CR_HASTE_SPELL)
        hit = GetCombatRating(CR_HIT_SPELL)
        
      elseif showAttackPower or isHunter then
        attackPowerLabel = ATTACK_POWER
        
        local base, pos, neg
        if isHunter then
          base, pos, neg = UnitRangedAttackPower("player")
          crit = GetRangedCritChance()
          haste = GetCombatRating(CR_HASTE_RANGED)
          hit = GetCombatRating(CR_HIT_RANGED)
        else
          base, pos, neg = UnitAttackPower("player")
          crit = GetCritChance()
          haste = GetCombatRating(CR_HASTE_MELEE)
          hit = GetCombatRating(CR_HIT_MELEE)
        end
        spdOrAp = base + pos - neg
      end

      -- 2. Определяем цвета
      local hexAP, hexCrit, hexHaste, hexHit
      
      if showAttackPower or isHunter then
        hexAP = f.RGBGradient(1 - spdOrAp / 12000)
        hexHaste = (haste == 0) and "999999" or "ffffff"
      else -- showSpellPower
        hexAP = f.RGBGradient(1 - spdOrAp / 3500)
        hexHaste = f.RGBGradient(1 - haste / 50)
      end
      
      hexHit = f.RGBGradient(1 - hit / 10)
      hexCrit = f.RGBGradient(1 - crit / 50)

      -- 3. Собираем список всех возможных статов
      -- Структура элемента: { check = true/false, label = "Название", val = "Значение", color = "HEX" }
      
      local res = GetCombatRating(16)
      local resColor = f.RGBGradient(1 - tonumber(res) / 1414)
      
      local _, _, armor, posBuff, negBuff = UnitArmor("player")
      local armorColor = (posBuff ~= 0 and "00f100") or (negBuff ~= 0 and "f10000") or "f1f1a1"

      -- Форматируем значения заранее
      --local critStr = format("%.0f%s", crit, PERCENT_SIGN) --(showSpellPower or showAttackPower) and truncate(crit) 
      --local parryVal = format("%.0f%s", GetParryChance(), PERCENT_SIGN) --truncate(GetParryChance(), 1)
      --local dodgeVal = format("%.0f%s", GetDodgeChance(), PERCENT_SIGN) --truncate(GetDodgeChance(), 0) 
      --armor = format("%s%s", format("%.1f", armor / 1000):gsub("%.0", ""), "k")

      local statsList = {
        { 
          check = cfg.showAttackPowerOrSpd, 
          label = attackPowerLabel, 
          val = spdOrAp, 
          color = hexAP 
        },
        { 
          check = cfg.showResilience, 
          label = RES, 
          val = res, 
          color = resColor 
        },
        { 
          check = cfg.showCrit, 
          label = CRIT, 
          val = format("%.0f%s", crit, PERCENT_SIGN), --(showSpellPower or showAttackPower) and truncate(crit) 
          color = hexCrit 
        },
        { 
          check = cfg.showHaste, 
          label = HASTE, 
          val = haste, 
          color = hexHaste 
        },
        { 
          check = cfg.showHit, 
          label = HIT, 
          val = hit, 
          color = hexHit 
        },
        { 
          check = cfg.showParry, 
          label = PARRY, 
          val = format("%.0f%s", GetParryChance(), PERCENT_SIGN), --truncate(GetParryChance(), 1)
          color = "f1f1a1" 
        },
        { 
          check = cfg.showDodge, 
          label = DODGE, 
          val = format("%.0f%s", GetDodgeChance(), PERCENT_SIGN), --truncate(GetDodgeChance(), 0) 
          color = "f1f1a1" 
        },
        { 
          check = cfg.showArmor, 
          label = ARMOR, 
          val = format("%s%s", format("%.1f", armor / 1000):gsub("%.0", ""), "k"), 
          color = armorColor 
        },
      }

      -- 4. Формируем итоговую строку
      wipe(ns.StatsTextParts)
      for _, stat in ipairs(statsList) do
        if stat.check then
          -- Если label совпадает с AP/SP, выводим "Label: Val", иначе просто "Label: Val" с отступом
          -- В твоем старом коде для первого стата (AP/SP) отступа не было.
          local textPart = format("%s:%s|cff%s%s|r", stat.label, INDENT_SMALL, stat.color, stat.val)
          tinsert(ns.StatsTextParts, textPart)
        end
      end
      
      -- Соединяем все части через отступ (INDENT)
      return tconcat(ns.StatsTextParts, INDENT_BIG or "   ")
    end
    ]]
    
    -- Вспомогательная функция для вставки (чтобы не дублировать логику format)
    local function AddStat(label, val, color)
      tinsert(ns.StatsTextParts, format("%s:%s|cff%s%s|r", label, INDENT_SMALL, color, val))
    end

    ns.StatsTextParts = {}

    function ns.GetStatsText()
      wipe(ns.StatsTextParts)

      local spdOrAp, crit, haste, hit = 0, 0, 0, 0
      local attackPowerLabel = ATTACK_POWER

      -- 1. Сбор данных (только нужных)
      if showSpellPower then
        attackPowerLabel = SPELL_POWER
        -- В 3.3.5 индекс 2 - это Holy. Итерируем остальные школы.
        spdOrAp = GetSpellBonusDamage(2)
        crit = GetSpellCritChance(2)
        for i = 3, 7 do -- MAX_SPELL_SCHOOLS обычно 7
          local s = GetSpellBonusDamage(i)
          local c = GetSpellCritChance(i)
          if s < spdOrAp then spdOrAp = s end
          if c < crit then crit = c end
        end
        haste = GetCombatRating(CR_HASTE_SPELL)
        hit = GetCombatRating(CR_HIT_SPELL)
      elseif showAttackPower or isHunter then
        attackPowerLabel = ATTACK_POWER
        local base, pos, neg
        if isHunter then
          base, pos, neg = UnitRangedAttackPower("player")
          crit = GetRangedCritChance()
          haste = GetCombatRating(CR_HASTE_RANGED)
          hit = GetCombatRating(CR_HIT_RANGED)
        else
          base, pos, neg = UnitAttackPower("player")
          crit = GetCritChance()
          haste = GetCombatRating(CR_HASTE_MELEE)
          hit = GetCombatRating(CR_HIT_MELEE)
        end
        spdOrAp = base + pos - neg
      end

      -- 3. Прямая вставка статов (без создания промежуточной таблицы statsList)
      if cfg.showAttackPowerOrSpd then
        local color = (showAttackPower or isHunter) 
          and f.RGBGradient(1 - spdOrAp / 12000) 
          or f.RGBGradient(1 - spdOrAp / 3500)
        AddStat(attackPowerLabel, spdOrAp, color)
      end

      if cfg.showResilience then
        local res = GetCombatRating(16)
        AddStat(RES, res, f.RGBGradient(1 - res / 1414))
      end

      if cfg.showCrit then
        AddStat(CRIT, format("%.2f%%", crit), f.RGBGradient(1 - crit / 50))
      end

      if cfg.showHaste then
        local color = (showSpellPower) and f.RGBGradient(1 - haste / 50) or ((haste == 0) and "999999" or "ffffff")
        AddStat(HASTE, haste, color)
      end

      if cfg.showHit then
        AddStat(HIT, hit, f.RGBGradient(1 - hit / 10))
      end

      if cfg.showParry then
        AddStat(PARRY, format("%.1f%%", GetParryChance()), "f1f1a1")
      end

      if cfg.showDodge then
        AddStat(DODGE, format("%.1f%%", GetDodgeChance()), "f1f1a1")
      end

      if cfg.showArmor then
        local _, _, armor, posBuff, negBuff = UnitArmor("player")
        local color = (posBuff ~= 0 and "00f100") or (negBuff ~= 0 and "f10000") or "f1f1a1"
        local armorVal = format("%.1fk", armor / 1000):gsub("%.0k", "k")
        AddStat(ARMOR, armorVal, color)
      end

      return tconcat(ns.StatsTextParts, INDENT_BIG or "   ")
    end
    
    ns.UpdateStatsTime = 0
    function ns.UpdateStats()
      local t = GetTime()
      if ns.UpdateStatsTime > t then return end
      ns.UpdateStatsTime = t + 0.1
      --print("|cff00ff00UpdateStats|r")
      ns.statsInfoString = ns.GetStatsText()
      textFrame.update(true, textFrame)
    end

    function ns.GetZoneInfo()
      local PVPTimer = GetPVPTimer() / 1000
      local pvpOn = UnitIsPVP("player")
      --local pvpInfo = pvpOn and ("|cffff0000" .. PVPFLAG .. "|r") or ""
      
      local x, y = GetPlayerMapPosition("player")
      x, y = floor(x * 1000 + 0.5) / 10, floor(y * 1000 + 0.5) / 10
      
      -- if pvpOn and PVPTimer > 0 then
        -- if PVPTimer < 300 then
          -- pvpInfo = pvpOn and ("|cffff0000" .. PVPFLAG .. "|r") or "" .. " " .. (PVPTimer < 300) and ns.formatTime(PVPTimer) or ""
        -- end
      -- end
      
      ns.zoneInfoString = format("%s:%s|ccc%s%s%s|r%s  %s, %s  |cccff0000%s|r  %s", 
        MAP, 
        INDENT_SMALL, 
        zoneColor, 
        curZone, 
        instanceDifficulty and " (" .. instanceDifficulty .. ")" or "",
        spectatorMode and "  [spectator]" or "", 
        x, 
        y,
        pvpOn and PVPFLAG or "",
        PVPTimer < 300 and ns.formatTime(PVPTimer) or ""
      )
      --zoneInfoString = MAP .. ": |ccc" .. zoneColor .. curZone .. "|r" .. _instanceDifficulty .. _spectatorMode.."  " .. x .. ", " .. y .. "  " .. pvpInfo

      return ns.zoneInfoString
    end

    function ns.GetSpellUseDelay()
      local spellSent = ns.UNIT_SPELLCAST_SENT[1]
      local timeSent = ns.UNIT_SPELLCAST_SENT[2]
      local spellSucc = ns.UNIT_SPELLCAST_SUCCEEDED[1]
      local timeSucc = (spellSent and spellSucc and spellSent == spellSucc) and ns.UNIT_SPELLCAST_SUCCEEDED[2] or GetTime()
      
      if spellSent then
        if spellSent and spellSucc and spellSent == spellSucc then
          wipe(ns.UNIT_SPELLCAST_SENT)
          wipe(ns.UNIT_SPELLCAST_SUCCEEDED)
        end
        
        if spellSent == ns.lastUsedSpellName then
          --ns.SpellUseDelaySpell = spellSent
          ns.SpellUseDelay = modf((timeSucc - timeSent)*1000)
        end
      end
      
      return ns.SpellUseDelay
    end

    f:RegisterEvent("MODIFIER_STATE_CHANGED")
    f:RegisterEvent("PLAYER_LOGIN")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    f:RegisterEvent("ZONE_CHANGED")
    f:RegisterEvent("CHAT_MSG_SYSTEM")
    f:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
    f:RegisterEvent("ADDON_LOADED")
    f:RegisterEvent("WHO_LIST_UPDATE")

    f:SetScript("OnEvent", function(self, event, ...)
      if event == "UNIT_SPELLCAST_SENT" and not (UnitCastingInfo("player") or UnitChannelInfo("player")) then
        local unit, spell = ...
        
        if unit == "player" then
          --print(event,spell)
          local icon = select(3, GetSpellInfo(spell))
          
          if icon and not ns.spellIcons[spell] then
            ns.spellIcons[spell] = icon
          end
          
          if #ns.UNIT_SPELLCAST_SENT == 0 then
            ns.UNIT_SPELLCAST_SENT[1] = spell
            ns.UNIT_SPELLCAST_SENT[2] = GetTime()
            --textFrame.update(true, textFrame)
          end
        end
      elseif event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_FAILED" then
        local unit, spell = ...
        
        if unit == "player" then
          --print(event,spell)
          if event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_START" then
            ns.lastUsedSpellName = spell
          end
          
          local castSpell, castIcon
          local icon = select(3, GetSpellInfo(spell))
          
          if not icon then
            if event == "UNIT_SPELLCAST_START" then
              castSpell, _, _, castIcon = UnitCastingInfo("player")
            else--if event == "UNIT_SPELLCAST_SUCCEEDED" then
              castSpell, _, _, castIcon = UnitChannelInfo("player")
            end
            --print(castSpell,castIcon)
          end
          
          icon = icon or (castSpell and spell == castSpell and castIcon)

          if icon and not ns.spellIcons[spell] then
            --print(icon)
            ns.spellIcons[spell] = icon
          end
          
          if ns.UNIT_SPELLCAST_SENT[1] and ns.UNIT_SPELLCAST_SENT[1] == spell and #ns.UNIT_SPELLCAST_SUCCEEDED == 0 then
            ns.UNIT_SPELLCAST_SUCCEEDED[1] = spell
            ns.UNIT_SPELLCAST_SUCCEEDED[2] = GetTime()
            textFrame.update(true, textFrame)
          end
        end
      elseif 
        ( event == "UNIT_ATTACK_POWER"
        or event == "UNIT_RANGED_ATTACK_POWER"
        or event == "UNIT_STATS"
        or event == "UNIT_RANGEDDAMAGE"
        or event == "UNIT_DAMAGE"
        or event == "UNIT_ATTACK"
        or event == "UNIT_ATTACK_SPEED"
        or event == "UNIT_RESISTANCES"
        )
        --tContains(ns.statsEvent, event)
        and ... == "player"
        then
          --print(event)
          ns.UpdateStats()
      elseif event == "PLAYER_DAMAGE_DONE_MODS" then
        ns.UpdateStats()
      elseif event == "ADDON_LOADED" then
        if ... == "RezTimer" then
          RezTimer_Data = _G.RezTimer_Data
        elseif ... == "CustomFrames" then
          bg_statistics = _G.bg_statistics
        elseif ... == ADDON_NAME then
          -- cfg = mrcatsoul_Mori_EdgeInfo_Data or cfg
          -- mrcatsoul_Mori_EdgeInfo_Data = cfg
          -- cfg.fontSize = cfg.fontSize or DEFAULT_FONT_SIZE
          -- cfg.updateIntervalGlobal = cfg.updateIntervalGlobal or UPDATE_INTERVAL_GLOBAL_DEFAULT
          cfg = ns.cfgPanel.LoadConfig()
        end
      elseif event == "UPDATE_BATTLEFIELD_STATUS" then
        ns.bgInfoString = ns.GetBgInfoText()
        textFrame.update(true, textFrame)
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
        --print(event)
        playerGUID = UnitGUID("player")
        --SetWhoToUI(1)
        --ns.cfgPanel.ApplySettings()
        DelayedCall(0.1, function() textFrame:SetScript("OnUpdate", function(...) textFrame.update(nil, ...) end) end)
      elseif event == "PLAYER_ENTERING_WORLD" then
        --print(event, IsSpellPowerClass(), IsHealerClass())
        textFrame.needWaitServerInfo = nil
        was_SYSMSG_SPAM_ERROR_error = nil
        textFrame.TextUpdating = nil
        ns.activeConnections = nil
        ns.serverDelay = nil
        ns.serverUptime = nil
        ns.NumWhoResults = nil
        ns.responceTime = nil
        ns.SpellUseDelay = nil
        ns.lastUsedSpellName = nil
        ns.updateZoneAndRaidInfo()
        ns.bgInfoString = ns.GetBgInfoText()
        ns.UpdateStats()
        --textFrame.update(true, textFrame)
      elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
        --print(event, IsSpellPowerClass(), IsHealerClass())
        ns.updateZoneAndRaidInfo()
        ns.UpdateStats()
      elseif event == "CHAT_MSG_SYSTEM" then
        local msg = ...
        if msg:find(SYSMSG_SPAM_ERROR, 1, true) then
          textFrame.needWaitServerInfo = nil
          --print(SYSMSG_SPAM_ERROR)
          if needShowServerInfo and needShowServerInfo == 0 then
            was_SYSMSG_SPAM_ERROR_error = true
            print("["..ADDON_NAME_LOCALE.."]: |cffff7733Сообщение об ошибке от сервера из-за спама при ручной отправке server info. Ждём ~1 сек и траим отправить server info ещё раз с уже включенным показом в чате.|r")
            DelayedCall(1, function()
              --print("["..ADDON_NAME_LOCALE.."]: |cff00ffaaОтправляем...|r")
              SendChatMessage(".server info", "guild")
            end)
          end
        elseif msg:find("Server delay: ", 1, true) then
          ns.serverDelay = tonumber(strmatch(msg, "Server delay: (%d+) ms")) or -1
          --print('serverDelay:',serverDelay)
        elseif msg:find("Server uptime: ", 1, true) then
          textFrame.needWaitServerInfo = nil
          local s = msg:lower()

          local h = s:match("(%d+)%s*hours?") or s:match("(%d+)%s*hour")
          local m = s:match("(%d+)%s*minutes?") or s:match("(%d+)%s*minute")
          local sec = s:match("(%d+)%s*seconds?") or s:match("(%d+)%s*second")

          h = tonumber(h) or 0
          m = tonumber(m) or 0
          sec = tonumber(sec) or 0

          if h > 0 then
            ns.serverUptime = format("%dh %02dm %02ds", h, m, sec)
          elseif m > 0 then
            ns.serverUptime = format("%dm %02ds", m, sec)
          else
            ns.serverUptime = format("0:%02ds", sec)
          end
        elseif msg:find("Active connections: ", 1, true) then
          ns.activeConnections = msg:match("Active connections:%s+(%d+)")
          --print(activeConnections) 
        end
      elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local subevent, srcGuid = select(2, ...)
        --print(subevent, srcGuid)
        if subevent:find("SPELL_") and srcGuid == playerGUID then
          local spellid, spellname = select(9, ...)
          if spellname and not ns.spellIcons[spellname] then
            ns.spellIcons[spellname] = select(3, GetSpellInfo(spellid))
            textFrame.update(true, textFrame)
            --print(spellname,select(3, GetSpellInfo(spellid)))
          end
        end
      elseif event == "WHO_LIST_UPDATE" then
        ns.NumWhoResults = select(2, GetNumWhoResults())
      end
    end)

    f.smooth_data = {}

    function f.GetSmoothedValue(key, targetVal)
      local target = tonumber(targetVal)
      if not target then
        f.smooth_data[key] = nil
        return targetVal
      end
      
      if not f.smooth_data[key] then
        f.smooth_data[key] = target
        return target
      end
      
      local current = f.smooth_data[key]
      local diff = target - current
      
      if abs(diff) < 0.1 then
        f.smooth_data[key] = target
        return target
      end

      -- ЛОГИКА:
      -- Мы хотим, чтобы всё изменение происходило, допустим, за 0.5 секунды.
      -- Число шагов за это время = (секунды / интервал_обновления).
      -- В твоем случае: 0.5 / 0.025 = 20 шагов.
      
      local duration = min(1, cfg.seconds_send_addon_message_interval) / 10 -- время полной анимации в секундах
      local numSteps = duration / min(cfg.updateIntervalGlobal or UPDATE_INTERVAL_GLOBAL_DEFAULT, duration)
      
      -- Чтобы скорость была пропорциональна разнице (плавное затухание):
      local step = diff / numSteps
      
      -- Гарантируем минимальный сдвиг, чтобы анимация не "залипала" на целых числах
      if abs(step) < 0.05 then
        step = (diff > 0) and 0.1 or -0.1
      end
      
      current = current + step
      f.smooth_data[key] = current
      
      return floor(current + 0.5)
    end
    
    local function utf8sub(str, i, dots)
      if not str then return end
      local bytes = str:len()
      if (bytes <= i) then
        return str
      else
        local len, pos = 0, 1
        while (pos <= bytes) do
          len = len + 1
          local c = str:byte(pos)
          if (c > 0 and c <= 127) then
            pos = pos + 1
          elseif (c >= 192 and c <= 223) then
            pos = pos + 2
          elseif (c >= 224 and c <= 239) then
            pos = pos + 3
          elseif (c >= 240 and c <= 247) then
            pos = pos + 4
          end
          if (len == i) then break end
        end

        if (len == i and pos <= bytes) then
          return str:sub(1, pos - 1) .. (dots and '..' or '')
        else
          return str
        end
      end
    end
    
    textFrame.servInfoTime, textFrame.t, textFrame.SendWhoTime = 0, 0, 0
    local finalLines, row = {}, {}
    
    function textFrame.update(force, self, elapsed)
      if self.TextUpdating then return end
      
      -- Сразу обновляем таймеры
      local e = elapsed or 0
      self.t = self.t + e
      self.servInfoTime = self.servInfoTime + e
      self.SendWhoTime = self.SendWhoTime + e

      local updateIntervalGlobal = cfg.updateIntervalGlobal or UPDATE_INTERVAL_GLOBAL_DEFAULT

      -- 1. РАННИЙ ВЫХОД: Если время обновления не пришло и это не принудительный апдейт - уходим
      if not force and self.t < updateIntervalGlobal then 
        return 
      end

      self.TextUpdating = true
      self.t = min(self.t - (e ~= 0 and updateIntervalGlobal or 0), updateIntervalGlobal)

      -- 2. ОБНОВЛЕНИЕ ДАННЫХ В ФОНЕ (Запросы к серверу)
      if --[[cfg.server_info and]] not self.needWaitServerInfo and self.servInfoTime > (cfg.update_interval_server_info or UPDATE_INTERVAL_SERVER_INFO) and (cfg.showServerLatency or cfg.showServerUptime) then
        self.needWaitServerInfo = true
        self.servInfoTime = 0
        SendChatMessage(".server info", "guild")
      end

      if cfg.showWhoOnline and self.SendWhoTime > 5 and not (WhoFrameEditBox:IsVisible() and WhoFrameEditBox:GetText() ~= "") and not IsShiftKeyDown() then
        self.SendWhoTime = 0
        SendWho("")
      end

      -- === ПОДГОТОВКА ДАННЫХ (Только то, что реально нужно сейчас) ===

      local fps = GetFramerate()
      local fpsColor = cfg.showFPS and f.GetCachedColor("fps", fps, 60) or nil

      local latency
      local latColor
      if cfg.showLatencyHome then
        latency = f.GetSmoothedValue("latency", select(3, GetNetStats()))
        latColor = f.GetCachedColor("latency", latency, 150)
      end

      local responce = cfg.showRTT and f.GetSmoothedValue("responce", ns.responceTime) or nil
      local respColor = (responce and tonumber(responce)) and f.GetCachedColor("responce", responce, 150) or "f1f1a1"

      local srvDelayVal = cfg.showServerLatency and f.GetSmoothedValue("srvDelay", ns.serverDelay) or nil
      local srvDelayColor = (srvDelayVal and tonumber(srvDelayVal)) and f.GetCachedColor("srvDelay", srvDelayVal, 150) or "f1f1a1"

      -- Частицы
      local particleDensity = 0
      local particleColor = "ffffff"
      if cfg.showParticles or cfg.showParticleDensityBar then
        particleDensity = tonumber(GetCVar("particleDensity")) * 100
        local p_perc = particleDensity / 100
        local p_r = (p_perc < 0.5) and 1 or (2 - p_perc * 2)
        local p_g = (p_perc < 0.5) and (p_perc * 2) or 1
        particleColor = f.rgbToHex(p_r, p_g, 0)
      end

      -- Скорость
      local speed = 0
      local speedColor = "888888"
      if cfg.showMovementSpeed then
        speed = GetUnitSpeed("player") / 7 * 100
        speedColor = (speed > 0) and f.GetCachedColor("speed", speed, 250) or "888888"
      end

      -- Спеллы
      local spellDelayStr = ""
      if cfg.showSpellDelay and ns.lastUsedSpellName then
        local spellDelay = f.GetSmoothedValue("spellDelay", ns.GetSpellUseDelay())
        local spellDelayColor = tonumber(spellDelay) and f.GetCachedColor("spell", spellDelay, 150) or "f1f1a1"
        
        local icon = ns.spellIcons[ns.lastUsedSpellName] or ns.INV_Misc_QuestionMark
        local spellIconStr = format(" |T%s:%d|t", icon, (cfg.fontSize or DEFAULT_FONT_SIZE) + 1)
        
        local lastSpellShort = ns.lastUsedSpellName
        if #ns.lastUsedSpellName:gsub("[\128-\191]", "") > 10 then
          lastSpellShort = utf8sub(ns.lastUsedSpellName, 10, true)
        end
        spellDelayStr = format("%s:%s|ccc%s%-4s%s|r", SPELL, INDENT_SMALL, spellDelayColor, spellDelay .. spellIconStr, cfg.showSpellName and lastSpellShort or "")
      end

      -- === СБОРКА СТРОК ===
      wipe(finalLines)
      wipe(row)
      local rIdx = 1

      -- Блок 1: Инфо (Зона, БГ, Время)
      if cfg.showZoneInfo then
        row[rIdx] = ns.GetZoneInfo(); rIdx = rIdx + 1
      end

      if cfg.showBgInstanceRunTime and (InBg or InArena) then
        local bgRunTime = GetBattlefieldInstanceRunTime()
        if bgRunTime and bgRunTime > 0 then
          row[rIdx] = format("%s:%s|cccf1f1a1%s|r", PVPINST, INDENT_SMALL, ns.formatTime(bgRunTime / 1000))
          rIdx = rIdx + 1
        end
      end

      if rIdx > 1 then
        finalLines[#finalLines + 1] = tconcat(row, INDENT_BIG)
        wipe(row); rIdx = 1
      end

      if cfg.RezTimer then
        local rezInfo = ns.GetRezTimerInfo()
        if rezInfo and rezInfo ~= "" then
          finalLines[#finalLines + 1] = rezInfo
        end
      end

      if cfg.showTime then
        row[rIdx] = format("%s:%s|cccf1f1a1%s|r", TIME, INDENT_SMALL, TimeFormatter:GetFormattedTime(cfg.showDate, cfg.showDayOfWeek, cfg.showMilliseconds))
        rIdx = rIdx + 1
      end

      if cfg.showServerTime then
        row[rIdx] = format("%s:%s|cccf1f1a1%s|r", REALM, INDENT_SMALL, GameTime:GetFormatted(cfg.showMilliseconds))
        rIdx = rIdx + 1
      end

      if rIdx > 1 then
        finalLines[#finalLines + 1] = tconcat(row, INDENT_BIG)
        wipe(row); rIdx = 1
      end

      -- Блок 2: Технические (FPS, Частицы, Онлайн)
      if cfg.showFPS then 
        row[rIdx] = format("FPS:%s|ccc%s%-3d|r", INDENT_SMALL, fpsColor, fps); rIdx = rIdx + 1 
      end
      if cfg.showParticles then 
        row[rIdx] = format("%s:%s|ccc%s%-3d%s|r", PARTICLES, INDENT_SMALL, particleColor, particleDensity, PERCENT_SIGN); rIdx = rIdx + 1 
      end
      if cfg.showServerOnline and ns.activeConnections then 
        row[rIdx] = format("%s:%s|cccf1f1a1%s|r", PLSRV, INDENT_SMALL, f.GetSmoothedValue("connections", ns.activeConnections)); rIdx = rIdx + 1 
      end
      if cfg.showWhoOnline and ns.NumWhoResults then 
        row[rIdx] = format("%s:%s|cccf1f1a1%s|r", PLWHO, INDENT_SMALL, f.GetSmoothedValue("who", ns.NumWhoResults)); rIdx = rIdx + 1 
      end

      if rIdx > 1 then
        finalLines[#finalLines + 1] = tconcat(row, INDENT_BIG)
        wipe(row); rIdx = 1
      end

      -- Блок 3: Сеть (Пинг, RTT, Спеллы, Сервер)
      if cfg.showLatencyHome and latency then 
        row[rIdx] = format("LAT:%s|ccc%s%-3d|r", INDENT_SMALL, latColor, latency); rIdx = rIdx + 1 
      end
      if cfg.showRTT and responce then 
        row[rIdx] = format("RTT:%s|ccc%s%-3s|r", INDENT_SMALL, respColor, responce); rIdx = rIdx + 1 
      end
      if spellDelayStr ~= "" then 
        row[rIdx] = spellDelayStr; rIdx = rIdx + 1 
      end
      if cfg.showServerLatency and srvDelayVal then 
        row[rIdx] = format("%s:%s|ccc%s%-3s|r", SERV_DELAY, INDENT_SMALL, srvDelayColor, srvDelayVal); rIdx = rIdx + 1 
      end
      if cfg.showServerUptime and ns.serverUptime then 
        row[rIdx] = format("%s:%s|cccf1f1a1%s|r", UPTIME, INDENT_SMALL, ns.serverUptime); rIdx = rIdx + 1 
      end

      if rIdx > 1 then
        finalLines[#finalLines + 1] = tconcat(row, INDENT_BIG)
        wipe(row); rIdx = 1
      end

      -- Блок 4: Статы игрока
      if ns.statsInfoString and ns.statsInfoString ~= "" then
        row[rIdx] = ns.statsInfoString; rIdx = rIdx + 1
      end

      if cfg.showMovementSpeed then
        row[rIdx] = format("%s:%s|ccc%s%d%s|r", MOVE_SPEED, INDENT_SMALL, speedColor, speed, PERCENT_SIGN); rIdx = rIdx + 1
      end

      if rIdx > 1 then
        finalLines[#finalLines + 1] = tconcat(row, INDENT_BIG)
        wipe(row)
      end

      -- Статистика БГ
      if (cfg.showBattlegroundStats or ENABLE_BG_INFO_BLOCK) and ns.bgInfoString and ns.bgInfoString ~= "" then
        finalLines[#finalLines + 1] = ns.bgInfoString
      end

      -- Финальная склейка ВСЕГО текста
      local finalText = tconcat(finalLines, "\n")
      if self.text:GetText() ~= finalText then
        self.text:SetText(finalText)
      end

      -- Обновление слайдера
      if cfg.showParticleDensityBar and f:GetValue() ~= particleDensity then
        f:SetValue(particleDensity) 
      end

      self.TextUpdating = nil
    end
  end
  -- end status bar
  
  -- скрываем спам ".сервер инфо" от аддона и отображаем вывод только по ручному запросу в чат
  do
    local ServerInfoMsgs = {
      "WoW Circle Wotlk Development 3.3.5a",
      "WoW Circle Core: Last Update",
      "WoW Circle DB: Last Update",
      "Active connections:",
      "Server uptime:",
      "Next arena point distribution time:",
      "Server delay:",
      "Игроков онлайн:",
      "Продолжительность работы сервера:",
      "WoW Circle Cross Server:",
    }
    
    local function msgContainsStringFromList(msg, list)
      for _, v in ipairs(list) do
        if msg:find(v, 1, true) then
          return true
        end
      end
    end
    
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, msg, name, ...)
      if not (msg and name) then return end

      local isServerInfoMsg = msgContainsStringFromList(msg, ServerInfoMsgs)

      if isServerInfoMsg then
        if not needShowServerInfo then
          --print("filter+",msg)
          return true
        end

        if needShowServerInfo then
          if was_SYSMSG_SPAM_ERROR_error then
            was_SYSMSG_SPAM_ERROR_error = nil
            --print("["..ADDON_NAME_LOCALE.."]: |cff44ff44Отправлено.|r")
          end
        
          needShowServerInfo = needShowServerInfo +1
          --print(f.needShowServerInfo,msg)
          
          if (InCrossZone and needShowServerInfo >= 3) or needShowServerInfo >= 7 then
            needShowServerInfo = nil
          end
        end
      elseif msg:find(SYSMSG_SPAM_ERROR, 1, true) and cfg.hide_SYSMSG_SPAM_ERROR then
        --print("SYSMSG_SPAM_ERROR")
        return true
      end
    end)

    ChatFrame1EditBox:HookScript("onupdate", function(self)
      local cur = self:GetText()
      if cur and cur ~= "" then
        self[ADDON_NAME.."_ChatFrame1EditBoxLastText"] = cur
      end
    end)

    ChatFrame1EditBox:HookScript("OnEnterPressed", function(self)
      --print(self[ADDON_NAME.."_ChatFrame1EditBoxLastText"])
      local last = self[ADDON_NAME.."_ChatFrame1EditBoxLastText"] 
      if last
        and last:find(".serv", 1, true) 
        and last:find(" in", 1, true) 
        then
          cfg.hide_SYSMSG_SPAM_ERROR = false
          DelayedCall(0.5, function()
            if not cfg.hide_SYSMSG_SPAM_ERROR then
              cfg.hide_SYSMSG_SPAM_ERROR = true
            end
          end)
          needShowServerInfo = 0
      end
    end)
  end
  -- end server info
  
  -- тестовая проверка пинга (Response Time / RTT) через SendAddonMessage 
  do
    local ADDON_NAME, ns = ...
    local ADDON_NAME_META = GetAddOnMetadata(ADDON_NAME, "Title")

    local SECONDS_SEND_ADDON_MESSAGE_INTERVAL = 1
    local SECONDS_RTT_UPDATE_INTERVAL = 0.05
    local SECONDS_GAME_MENU_UPDATE_INTERVAL = 0.2
    local NUM_ADDONS_TO_DISPLAY = 50

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
    
    local L = ns.L or GetLocale()
    local LOW_LVL_MUTE = L=="ruRU" and "Мут" or "Muted"
    local DND_ON = L=="ruRU" and "Включено ДНД" or "DND on"
    local NAME_UNKNOWN = L=="ruRU" and "Имя неизвестно" or "Name unknown"
    
    ns.responceTime = "-"

    local f = CreateFrame("frame")
    f:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
    f:RegisterEvent("CHAT_MSG_ADDON")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UI_ERROR_MESSAGE")
    f:RegisterEvent("PLAYER_LEVEL_UP")
    --f:RegisterEvent("ADDON_LOADED")
    
    function f:UI_ERROR_MESSAGE(arg1)
      if not ns.cannotSend and (arg1:find("Вы не можете использовать личные сообщения", 1, true) or arg1:find("You cannot whisper", 1, true)) then
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
    
    function f:ADDON_LOADED(...)
      -- if ... ~= ADDON_NAME then return end
      -- NUM_ADDONS_TO_DISPLAY = cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY
      -- --print(NUM_ADDONS_TO_DISPLAY, cfg.num_addons_to_display)
      -- for i = 1, NUM_ADDONS_TO_DISPLAY do
        -- f.topAddOns[i] = { value = 0, name = "" }
      -- end
    end

    function f:PLAYER_ENTERING_WORLD()
      ns.responceTime, responceReceivedTime, lastRequestSendTime = "-", 0, nil
    end

    function f:CHAT_MSG_ADDON(...)
      local prefix, text, channel, sender = ...
      
      if prefix == ADDON_NAME..":rtt_test" and lastRequestSendTime and tostring(lastRequestSendTime) == tostring(text) --[[and channel == "WHISPER"]] and playerName and playerName == sender then
        responceReceivedTime = GetTime()
        ns.responceTime = modf((responceReceivedTime - lastRequestSendTime) *1000) 
        lastRequestSendTime = nil
        --print("|cff00ffffresponceTime(received):", ns.responceTime)
      end
    end

    f.updateValueTime, f.newRequestTime = 0, 0
    
    f:SetScript("onupdate", function(s, e)
      s.updateValueTime = s.updateValueTime + e
      
      if s.updateValueTime < (cfg.seconds_rtt_update_interval or SECONDS_RTT_UPDATE_INTERVAL) then return end
      
      if playerName == nil or playerName == UNKNOWN or playerName == "" then
        playerName = UnitName("player")
      end
      
      local _time = GetTime()
      
      if lastRequestSendTime and responceReceivedTime == nil and s.newRequestTime ~= 0 then
        local diff = _time - lastRequestSendTime
        if diff > 0 then
          ns.responceTime = modf((_time - lastRequestSendTime) *1000)
          --print("|cffff5500responceTime(connection dead):", ns.responceTime)
        end
      end
      
      s.newRequestTime = s.newRequestTime + s.updateValueTime
      --print(s.newRequestTime)
      
      if ns.cannotSend then
        ns.responceTime = "|cffff0000"..LOW_LVL_MUTE.."|r"
      elseif playerName == nil or playerName == UNKNOWN or playerName == "" then
        ns.responceTime = "|cffff0000"..NAME_UNKNOWN.."|r"
      elseif s.newRequestTime > (cfg.seconds_send_addon_message_interval or SECONDS_SEND_ADDON_MESSAGE_INTERVAL) and responceReceivedTime then
        local chan = UnitIsDND("player") == nil and "WHISPER" or IsInGuild() and "GUILD" or GetNumRaidMembers()>0 and "RAID" or GetNumPartyMembers()>0 and "PARTY"
        if chan then
          s.newRequestTime = 0
          responceReceivedTime = nil
          lastRequestSendTime = _time
          --print("|cffffff00sending...|r")
          SendAddonMessage(ADDON_NAME..":rtt_test", tostring(_time), chan, playerName)
        else
          ns.responceTime = "|cffff0000"..DND_ON.."|r"
        end
      end

      s.updateValueTime = 0
    end)
    
    f.gradientColor = { 0, 1, 0, 1, 1, 0, 1, 0, 0 }

    function f.ColorGradient(perc, ...)
      if perc > 1 then
        local r, g, b = select(select("#", ...) - 2, ...)
        return r, g, b
      elseif perc < 0 then
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
    
    function f.RGBGradient(num)
      local r, g, b = f.ColorGradient(num, unpack(f.gradientColor))
      local hexColor = format("%02x%02x%02x", r * 255, g * 255, b * 255)
      return hexColor
    end

    f.topAddOns = {}
    for i = 1, (cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY) do
      f.topAddOns[i] = { value = 0, name = "" }
    end
    
    function f.GameMenu_OnEnter()
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
        
        if SHOW_NEWBIE_TIPS == "1" then
          GameTooltip:AddLine(NEWBIE_TOOLTIP_LATENCY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
        end
        
        GameTooltip:AddLine("\n")
       
        -- framerate
        string = format(MAINMENUBAR_FPS_LABEL, GetFramerate())
        GameTooltip:AddLine(string, 1.0, 1.0, 1.0)
        if SHOW_NEWBIE_TIPS == "1" then
          GameTooltip:AddLine(NEWBIE_TOOLTIP_FRAMERATE, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
        end
       
        -- AddOn mem usage
        for i = 1, (cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY), 1 do
          f.topAddOns[i].value = 0
        end
       
        UpdateAddOnMemoryUsage()
        
        local totalMem = 0
       
        for i = 1, GetNumAddOns(), 1 do
          local mem = GetAddOnMemoryUsage(i)
          totalMem = totalMem + mem
          
          for j = 1, (cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY), 1 do
            if mem > f.topAddOns[j].value then
              for k = (cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY), 1, -1 do
                if k == j then
                  local addonName = GetAddOnInfo(i):gsub("_Atom","HugeDick")
                  if addonName == ADDON_NAME then addonName = "|cff44ffff"..addonName.."|r" end
                  f.topAddOns[k].value = mem
                  f.topAddOns[k].name = addonName
                  break
                elseif k ~= 1 then
                  f.topAddOns[k].value = f.topAddOns[k-1].value
                  f.topAddOns[k].name = f.topAddOns[k-1].name
                end
              end
              break
            end
          end
        end
       
        if totalMem > 0 then
          local color = f.RGBGradient(totalMem/40000)
          
          if totalMem > 1000 then
            totalMem = totalMem / 1000
            string = format(TOTAL_MEM_MB_ABBR, totalMem)
          else
            string = format(TOTAL_MEM_KB_ABBR, totalMem) 
          end
          
          string = "|cff".. color .. string .. "|r"
       
          GameTooltip:AddLine("\n")
          
          GameTooltip:AddLine(string, 1.0, 1.0, 1.0)
          
          if SHOW_NEWBIE_TIPS == "1" then
            GameTooltip:AddLine(NEWBIE_TOOLTIP_MEMORY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
          end
          
          local size
          
          for i = 1, (cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY), 1 do
            if f.topAddOns[i].value == 0 then
              break
            end
            
            size = f.topAddOns[i].value
            
            color = f.RGBGradient(size/5000)
            
            if ( size > 1000 ) then
              size = size / 1000
              string = format(ADDON_MEM_MB_ABBR, size, f.topAddOns[i].name)
            else
              string = format(ADDON_MEM_KB_ABBR, size, f.topAddOns[i].name)
            end
            
            GameTooltip:AddLine("|cff989898"..i..".|r |cff"..color..""..string.."|r", 1.0, 1.0, 1.0)
          end
        end
       
        GameTooltip:Show()
      end
    end

    function f.GameMenu_AddRTT()
      local mouseFocus = GetMouseFocus()
      if mouseFocus and mouseFocus.GetName and mouseFocus:GetName() == "MainMenuMicroButton" then
        for i = 1, GameTooltip:NumLines() do
          local text = _G[GameTooltip:GetName().."TextLeft"..i]:GetText()
          if text and text:find(MAINMENUBAR_LATENCY_LABEL:match("^(.-):")) then
            local _, _, latency = GetNetStats()
            local _string = format(MAINMENUBAR_LATENCY_LABEL, latency)
            local textRegion = _G[GameTooltip:GetName().."TextLeft"..i]
            local color = tonumber(ns.responceTime) and f.RGBGradient(ns.responceTime/150) or "ffffff"
            textRegion:SetText(_string..", RTT: |cff"..color..ns.responceTime.."|r")
            GameTooltip:Show()
            break
          end
        end
      end
    end

    -- GameTooltip:HookScript("onshow", function()
      -- GameMenu_AddRTT()
    -- end)

    f.t = 0
    GameTooltip:HookScript("onupdate", function(_, e)
      f.t = f.t + e
      local SECONDS_GAME_MENU_UPDATE_INTERVAL = cfg.seconds_game_menu_update_interval or SECONDS_GAME_MENU_UPDATE_INTERVAL
      if f.t < SECONDS_GAME_MENU_UPDATE_INTERVAL then return end
      f.t = 0
      f.GameMenu_OnEnter()
      f.GameMenu_AddRTT()
    end)
    
    hooksecurefunc("MainMenuBarPerformanceBarFrame_OnEnter", function() 
      f.GameMenu_OnEnter()
      f.GameMenu_AddRTT()
    end)
  end
  
  -- авто регулировка плотности частиц в зависимости от фпс
  do
    local _, ns = ...
    
    local UPDATE_INTERVAL = 0.1 -- Обновляем раз в N секунды
    local TARGET_MIN_FPS = 50  -- Нижний порог FPS
    local TARGET_MAX_FPS = 59  -- Верхний порог FPS
    local ADJUSTMENT_STEP = 0.05 -- Шаг изменения particleDensity
    local PARTICLE_VALUE_MIN = 0.101 -- НЕ МЕНЯТЬ! МИНИМАЛЬНО ДОПУСТИМОЕ ЗНАЧЕНИЕ! / DO NOT CHANGE!
    local PARTICLE_VALUE_MAX = 1
    
    local IsWindowFocused = IsWindowFocused
    local GetTime = GetTime 
    local GetFramerate = GetFramerate
    local math_max, math_min, tonumber = math.max, math.min, tonumber
    local GetCVar, SetCVar = GetCVar, SetCVar
    
    function ns.func_dynamicParticleDensity(s, e)
      s.t = s.t and s.t + e or 0; if s.t < UPDATE_INTERVAL then return end; s.t = 0
      
      local particleDensity = tonumber(GetCVar("particleDensity"))
      
      if IsWindowFocused and not IsWindowFocused() then
        if particleDensity ~= PARTICLE_VALUE_MIN then
          --print("Понижаем particleDensity до PARTICLE_VALUE_MIN ("..PARTICLE_VALUE_MIN.."), particleDensity:", particleDensity)
          SetCVar("particleDensity", PARTICLE_VALUE_MIN)
        end
        return 
      end

      local fps = GetFramerate()
      --print("target_max_fps",(cfg.target_max_fps or TARGET_MAX_FPS),fps)
      if fps < (cfg.target_min_fps or TARGET_MIN_FPS) and particleDensity > PARTICLE_VALUE_MIN then
        -- Понижаем particleDensity на малый шаг, но не ниже 0.101
        particleDensity = math_max(particleDensity - ADJUSTMENT_STEP, PARTICLE_VALUE_MIN)
        SetCVar("particleDensity", particleDensity)
        --print("Понижаем particleDensity",GetCVar("particleDensity"))
      elseif fps > (cfg.target_max_fps or TARGET_MAX_FPS) and particleDensity < (cfg.particle_value_max or PARTICLE_VALUE_MAX) then
        -- Повышаем particleDensity на малый шаг, но не выше 1
        particleDensity = math_min(particleDensity + ADJUSTMENT_STEP, PARTICLE_VALUE_MAX)
        SetCVar("particleDensity", particleDensity)
        --print("Повышаем particleDensity",GetCVar("particleDensity"))
      end
    end
    
    ns.dynamicParticleDensity = CreateFrame("frame")
    ns.dynamicParticleDensity:SetScript("onupdate", ns.func_dynamicParticleDensity)
  end
end
