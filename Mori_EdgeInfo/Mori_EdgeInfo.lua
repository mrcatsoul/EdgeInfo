-- инфа левый нижний угол
do  
  local ADDON_NAME, ns = ...
  local ADDON_FOLDER = "interface\\addons\\"..ADDON_NAME
  local DEFAULT_FONT_NAME = ADDON_FOLDER.."\\PTSansNarrow.ttf"
  --local DEFAULT_FONT_NAME = ADDON_FOLDER.."\\trebuc.ttf"
  local DEFAULT_FONT_SIZE = 12
  local DEFAULT_ALPHA = 0.9
  local PARTICLE_DENSITY_BAR_MIN_WIDTH = 50
  local PARTICLE_DENSITY_BAR_MIN_HEIGHT = 7
  local UPDATE_INTERVAL_GLOBAL_DEFAULT = 0.025
  local UPDATE_INTERVAL_SERVER_INFO = 5
  local FORCE_EN_LOCALE = false
  local FORCE_RUS_LOCALE = false
  local ENABLE_BG_INFO_BLOCK = false
  local INDENT = "    "
  local PERCENT = "%"
  
  ns.fontsList = {
    "PTSansNarrow.ttf",
    "trebuc.ttf",
    "trebucbd.ttf",
    "Pixel LCD7_20231125.ttf",
    "centurygothic.TTF",
    "Homespun.ttf",
    "HOOGE.ttf",
    "Impact.ttf",
    "FORCEDSQUARE.ttf",
    "Hack.ttf",
    "UbuntuCondensed.ttf",
  }
  
  ns.fontsFlags = {
    "NONE", "MONOCHROME", "OUTLINE", "OUTLINE, MONOCHROME", "MONOCHROMEOUTLINE", "THICKOUTLINE", "",
  }

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
  local GetParryChance = GetParryChance
  local GetDodgeChance = GetDodgeChance
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
  local tinsert = tinsert
  local tconcat = table.concat
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
  local UNIT_SPELLCAST_SENT, UNIT_SPELLCAST_SUCCEEDED = {}, {}
  local serverDelay, serverUptime, activeConnections, NumWhoResults = 0, "-", 0, 0
  local statsInfoString, bgInfoString, zoneInfoString, needShowServerInfo, was_SYSMSG_SPAM_ERROR_error = "", "", ""
  local RezTimer_Data, bg_statistics = _G.RezTimer_Data, _G.bg_statistics

  local L = GetLocale()
  L = L=="ruRU" and FORCE_EN_LOCALE and "enUS" or FORCE_RUS_LOCALE and "ruRU" or L -- test shit
  
  local ADDON_NAME_LOCALE = L=="ruRU" and GetAddOnMetadata(ADDON_NAME,"Title-ruRU") or GetAddOnMetadata(ADDON_NAME,"Title") or ADDON_NAME
  local ADDON_NAME_LOCALE_SHORT = L=="ruRU" and GetAddOnMetadata(ADDON_NAME,"TitleS-ruRU") or GetAddOnMetadata(ADDON_NAME,"TitleShort") or ADDON_NAME_LOCALE
  local ADDON_NOTES = L=="ruRU" and GetAddOnMetadata(ADDON_NAME,"Notes-ruRU") or GetAddOnMetadata(ADDON_NAME,"Notes") or UNKNOWN
  local ADDON_VERSION = GetAddOnMetadata(ADDON_NAME,"Version") or UNKNOWN
  
  local SYSMSG_SPAM_ERROR = GetLocale()=="ruRU" and "Команда не может быть обработана в текущий момент" or "This command cann't be processed now"
  
  local PARTICLES = L=="ruRU" and "Частицы" or "PARTICLES"
  local SERV_DELAY = L=="ruRU" and "Серв" or "SERV"
  local GAMES = L=="ruRU" and "Игр" or "GAMES"
  local WINS = L=="ruRU" and "Побед" or "WINS"
  local WINRATE = L=="ruRU" and "Винрейт" or "WR"
  local ATTACK_POWER = L=="ruRU" and "Ап" or "AP"
  local SPELL_POWER = L=="ruRU" and "Спд" or "SPD"
  local RES = L=="ruRU" and "Уст" or "RSL"
  local CRIT = L=="ruRU" and "Крт" or "CRT"
  local HASTE = L=="ruRU" and "Скр" or "HST"
  local HIT = L=="ruRU" and "Мтк" or "HIT"
  local MOVE_SPEED = L=="ruRU" and "Движ" or "MOV"
  local TO_RES = L=="ruRU" and "До реса" or "RES"
  local BY_CORPSE = L=="ruRU" and "по телу" or "CORPSE"
  local TO_RES_BY_CORPSE = L=="ruRU" and "Рес по телу" or "RES CORPSE"
  local ENEMIES = L=="ruRU" and "врагов реснется" or "DEAD ENMS"
  local READY = L=="ruRU" and "готов" or "ready"
  local RATING = L=="ruRU" and "БГ очки" or "PTS"
  local MAP = L=="ruRU" and "Карта" or "MAP"
  local TIME = L=="ruRU" and "Время" or "TIME"
  local PLWHO = L=="ruRU" and "Онлайн(кто)" or "PL(WHO)"
  local PLSRV = L=="ruRU" and "Онлайн(серв)" or "PL(SRV)"
  local PVPINST = L=="ruRU" and "БГ длится" or "PVPINST"
  local UPTIME = L=="ruRU" and "Аптайм" or "UPT"
  local PVPFLAG = --[[L=="ruRU" and "ПвП" or]] "PvP"
  local REALM = L=="ruRU" and "Сервер" or "REALM"
  local ARMOR = L=="ruRU" and "Бро" or "ARM"
  local PARRY = L=="ruRU" and "Пар" or "PAR"
  local DODGE = L=="ruRU" and "Укл" or "DOD"
  local SPELL = L=="ruRU" and "Закл" or "SPELL"
  local INCORRECT_VALUE = L=="ruRU" and "Некоректное значение" or "Incorrect value"
  
  -- settings
  local FRAME_WIDTH, FRAME_HEIGHT = 800, 400
  local ROW_HEIGHT = 20
  
  local cfg = mrcatsoul_Mori_EdgeInfo_Data or {}

  -- -------------------------
  -- settings UI: scroll frame + panel
  -- -------------------------
  do
    local cfgPanel = CreateFrame("frame", ADDON_NAME.."SettingsPanel", InterfaceOptionsFramePanelContainer)
    ns.cfgPanel = cfgPanel
    cfgPanel:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    cfgPanel:SetAllPoints(InterfaceOptionsFramePanelContainer)
    cfgPanel:Hide()

    -- -------------------------
    -- localization helper
    -- -------------------------
    function cfgPanel.GetLocaleKey()
      if (L~="ruRU" and FORCE_RUS_LOCALE) or cfg.force_rus_locale then return "ru" end
      if (L=="ruRU" and FORCE_EN_LOCALE) or cfg.force_en_locale then return "en" end
      local loc = (GetLocale and GetLocale()) or "enUS"
      if loc:sub(1,2) == "ru" then return "ru" end
      return "en"
    end

    function cfgPanel.L(tbl)
      if not tbl then return nil end
      local k = cfgPanel.GetLocaleKey()
      return tbl[k] or tbl.en or tbl.ru or ""
    end
    
    local cfgScroll = CreateFrame("ScrollFrame", ADDON_NAME.."SettingsScrollFrame", InterfaceOptionsFramePanelContainer, "UIPanelScrollFrameTemplate")
    cfgScroll:SetScrollChild(cfgPanel)
    --cfgScroll.name = "|cff00ffff" .. cfgPanel.L({ en = ADDON_NAME, ru = ADDON_NAME })
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
    cfgTitle:SetText(GetAddOnMetadata(ADDON_NAME, "Title").." v"..GetAddOnMetadata(ADDON_NAME, "Version"))

    local titleTip = CreateFrame("button", ADDON_NAME.."_tooltipFrame", cfgPanel)
    titleTip:SetPoint("center", cfgTitle, "center")
    --titleTip:SetSize(cfgTitle:GetStringWidth()+11, cfgTitle:GetStringHeight()+1) 
    
    titleTip:SetScript("OnEnter", function(self) 
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
      GameTooltip:SetText(""..GetAddOnMetadata(ADDON_NAME, "Title").." v"..GetAddOnMetadata(ADDON_NAME, "Version").."\n\n"..GetAddOnMetadata(ADDON_NAME, "Notes").."", nil, nil, nil, nil, true)
      GameTooltip:Show() 
    end)

    titleTip:SetScript("OnLeave", function(self) 
      GameTooltip:Hide() 
    end)
    
    titleTip:SetScript("OnShow", function(self) 
      self:SetSize(cfgTitle:GetStringWidth(), cfgTitle:GetStringHeight())
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
          if option == "Settings" then
            InterfaceOptionsFrame_OpenToCategory(cfgScroll)
            if not cfgPanel:IsShown() then
              InterfaceOptionsFrameAddOnsListScrollBarScrollDownButton:Click()
              InterfaceOptionsFrame_OpenToCategory(cfgScroll)
            end
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
      { key = "fontSize",
        label = { en = "Font size", ru = "Размер шрифта" },
        tooltip = { en = "Font size in pixels", ru = "Размер шрифта в пикселях" },
        default = 12, min = 5, max = 40 },
        
      { key = "fontName",
        label = { en = "Font", ru = "Шрифт" },
        tooltip = { en = "Font name", ru = "Шрифт" },
        default = ns.fontsList },
        
      { key = "fontFlags",
        label = { en = "Font flags", ru = "Флаги шрифта" },
        tooltip = { en = "Font flags", ru = "Флаги шрифта" },
        default = ns.fontsFlags },
        
      { key = "fontShadow",
        label = { en = "Font shadow", ru = "Тень под шрифтом" },
        tooltip = { en = "Font shadow", ru = "Тень под шрифтом" },
        default = true },
        
      { key = "updateIntervalGlobal",
        label = { en = "Global update interval (seconds)", ru = "Глобальный интервал обновления всего текста в секундах" },
        tooltip = { en = "Global update interval (seconds)", ru = "Глобальный интервал обновлени всего текста в секундах" },
        default = 0.025, min = 0.01, max = 60 },
        
      { key = "showParticleDensityBar",
        label = { en = "Show particle density bar (resize: shift+mouseover scroll on frame)", ru = "Показывать полосу плотности частиц (размер меняется через шифт+колесо мыши по фрейму)" },
        tooltip = { en = "Display particle density bar (resize: shift+mouseover scroll on frame)", ru = "Отображать полосу плотности частиц (размер меняется через шифт+колесо мыши по фрейму)" },
        default = false },
        
      { key = "showBattlegroundStats",
        label = { en = "Show battleground stats", ru = "Показывать статистику поля боя" },
        tooltip = { en = "Show basic battleground statistics", ru = "Показывать базовую статистику поля боя" },
        default = true },
        
      { key = "RezTimer",
        label = { en = "Show corpse recovery delay and RezTimer info (https://github.com/mrcatsoul/RezTimer)", ru = "Показывать время до реса \"по телу\" и инфу из RezTimer-а (https://github.com/mrcatsoul/RezTimer)" },
        tooltip = { en = "Show corpse recovery delay and RezTimer info (https://github.com/mrcatsoul/RezTimer)", ru = "Показывать время до реса \"по телу\" и инфу из RezTimer-а (https://github.com/mrcatsoul/RezTimer)", ru = "Показывать инфу из RezTimer-а и время до реса \"по телу\" (https://github.com/mrcatsoul/RezTimer)" },
        default = true },

      { key = "attachFrameToUIParent",
        label = { en = "Hide addon info when UI is hidden (ALT+Z)", ru = "Скрывать инфо аддона при скрытии интерфейса (ALT+Z)" },
        tooltip = { en = "Hide addon info visible when UI is hidden (ALT+Z)", ru = "Скрывать инфо аддона при скрытии интерфейса (ALT+Z)" },
        default = false },
        
      { key = "alpha",
        label = { en = "Opacity", ru = "Прозрачность" },
        tooltip = { en = "Frame opacity from 0 to 1", ru = "Прозрачность фрейма от 0 до 1 (задать к примеру 0.5 для прозрачности в 50%)" },
        default = 0.9, min = 0, max = 1 },
        
      { key = "force_en_locale",
        label = { en = "Force English locale", ru = "Принудительно английский" },
        tooltip = { en = "Force interface texts to English", ru = "Принудительно отображать тексты на английском" },
        default = false },
        
      { key = "force_rus_locale",
        label = { en = "Force Russian locale", ru = "Принудительно русский" },
        tooltip = { en = "Force interface texts to Russian", ru = "Принудительно отображать тексты на русском" },
        default = false },
        
      { key = "server_info",
        label = { en = "Hidden .server info spam for show information as online and uptime", ru = "Скрытый спам .server info для показа инфы об онлайне и аптайме" },
        tooltip = { en = "Hidden .server info spam for show information as online and uptime", ru = "Скрытый спам .server info для показа инфы об онлайне и аптайме" },
        default = true },
        
      { key = "update_interval_server_info",
        label = { en = "Seconds between .server info spam", ru = "Интервал между отправками .server info в секундах" },
        tooltip = { en = "Seconds between .server info spam", ru = "Интервал между отправками .server info в секундах" },
        default = 5, min = 1, max = 60 },
        
      { key = "num_addons_to_display",
        label = { en = "Number of addons to display in game menu tooltip", ru = "Кол-во аддонов для отображения в тултипе игрового меню" },
        tooltip = { en = "How many addons to show in the list in game menu tooltip", ru = "Сколько аддонов показывать в списке в тултипе игрового меню" },
        default = 50, min = 1, max = 80 },
        
      { key = "seconds_game_menu_update_interval",
        label = { en = "Game menu tooltip update interval (seconds)", ru = "Интервал между обновлениями тултипа игрового меню в секундах" },
        tooltip = { en = "Update interval for game menu tooltip values (seconds)", ru = "Интервал обновления значений в тултипе игрового меню в секундах" },
        default = 0.2, min = 0.01, max = 10 },
        
      { key = "seconds_rtt_update_interval",
        label = { en = "RTT update (seconds)", ru = "Интервал обновления RTT в секундах" },
        tooltip = { en = "Interval to refresh RTT value (seconds)", ru = "Интервал обновления RTT" },
        default = 0.05, min = 0.01, max = 10 },
        
      { key = "seconds_send_addon_message_interval",
        label = { en = "Send addon msg interval (seconds, RTT check)", ru = "Интервал между отправками сообщений аддона в секундах (для определения RTT)" },
        tooltip = { en = "Minimum seconds between addon messages (seconds, RTT check)", ru = "Минимум секунд между сообщениями аддона в секундах (для определения RTT)" },
        default = 1, min = 0.1, max = 10 },
        
      { key = "dynamicParticleDensityByFPS",
        label = { en = "Automatic particle density adjustment based on FPS", ru = "Авто регулировка плотности частиц в зависимости от фпс" },
        tooltip = { en = "Automatic particle density adjustment based on FPS", ru = "Авто регулировка плотности частиц в зависимости от фпс" },
        default = true },
        
      { key = "hide_SYSMSG_SPAM_ERROR",
        label = { en = "Hide SYSMSG_SPAM_ERROR", ru = "Скрывать ошибку в чате от спама сервер инфо" },
        tooltip = { en = "Hide SYSMSG_SPAM_ERROR", ru = "Скрывать ошибку в чате от спама сервер инфо" },
        default = false },
        
      { key = "indentSpaceCount",
        label = { en = "indentSpaceCount", ru = "Отступ кол-во пробелов" },
        tooltip = { en = "indentSpaceCount", ru = "Отступ кол-во пробелов" },
        default = 4, min = 1, max = 20 },
        
      { key = "showMovementSpeed",
        label = { en = "showMovementSpeed", ru = "showMovementSpeed" },
        tooltip = { en = "showMovementSpeed", ru = "showMovementSpeed" },
        default = true },
        
      { key = "showAttackPowerOrSpd",
        label = { en = "showAttackPowerOrSpd", ru = "showAttackPowerOrSpd" },
        tooltip = { en = "showAttackPowerOrSpd", ru = "showAttackPowerOrSpd" },
        default = true },
        
      { key = "showResilience",
        label = { en = "showResilience", ru = "showResilience" },
        tooltip = { en = "showResilience", ru = "showResilience" },
        default = true },
        
      { key = "showParry",
        label = { en = "showParry", ru = "showParry" },
        tooltip = { en = "showParry", ru = "showParry" },
        default = true },
        
      { key = "showDodge",
        label = { en = "showDodge", ru = "showDodge" },
        tooltip = { en = "showDodge", ru = "showDodge" },
        default = false },
        
      { key = "showArmor",
        label = { en = "showArmor", ru = "showArmor" },
        tooltip = { en = "showArmor", ru = "showArmor" },
        default = true },
        
      { key = "showCrit",
        label = { en = "showCrit", ru = "showCrit" },
        tooltip = { en = "showCrit", ru = "showCrit" },
        default = false },
        
      { key = "showHaste",
        label = { en = "showHaste", ru = "showHaste" },
        tooltip = { en = "showHaste", ru = "showHaste" },
        default = false },
        
      { key = "showHit",
        label = { en = "showHit", ru = "showHit" },
        tooltip = { en = "showHit", ru = "showHit" },
        default = false },
        
      { key = "showPercentSign",
        label = { en = "showPercentSign", ru = "showPercentSign" },
        tooltip = { en = "showPercentSign", ru = "showPercentSign" },
        default = true },
    }
    
    function cfgPanel.VisualUpdate()
      local textFrame = _G[ADDON_NAME.."_TextFrame"]
      local text = textFrame.text
      local particleDensityFrame = _G[ADDON_NAME.."_ParticleDensityBar_Frame"]
      
      text:SetFont(type(cfg.fontName) == "string" and ADDON_FOLDER.."\\"..cfg.fontName or DEFAULT_FONT_NAME, 
        cfg.fontSize or DEFAULT_FONT_SIZE, 
        type(cfg.fontFlags) == "string" and cfg.fontFlags or "NONE") 
        
      if cfg.fontShadow then 
        text:SetShadowOffset(1, -1) 
      else
        text:SetShadowOffset(0, 0) 
      end
      
      textFrame:SetAlpha(cfg.alpha or DEFAULT_ALPHA)
      particleDensityFrame:SetAlpha(cfg.alpha or DEFAULT_ALPHA)
      
      if cfg.attachFrameToUIParent then
        textFrame:SetParent(UIParent)
        --text:SetFont(DEFAULT_FONT_NAME, (cfg.fontSize or DEFAULT_FONT_SIZE) +4) -- при привязке к UIParent размер шрифта по какой-то причине уменьшается (надо выяснить)
      else
        textFrame:SetParent(nil)
      end
      
      if cfg.showParticleDensityBar then
        particleDensityFrame:Show()
      else
        particleDensityFrame:Hide()
      end
      
      if cfg.dynamicParticleDensityByFPS then
        ns.dynamicParticleDensity:Show()
      else
        ns.dynamicParticleDensity:Hide()
      end

      PERCENT = cfg.showPercentSign and "%" or ""
      
      INDENT = cfg.indentSpaceCount and string.rep(" ", cfg.indentSpaceCount) or INDENT
      
      L = GetLocale()=="ruRU" and cfg.force_en_locale and "enUS" or cfg.force_rus_locale and "ruRU" or GetLocale() -- test shit
    
      ADDON_NAME_LOCALE = L=="ruRU" and GetAddOnMetadata(ADDON_NAME,"Title-ruRU") or GetAddOnMetadata(ADDON_NAME,"Title") or ADDON_NAME
      ADDON_NAME_LOCALE_SHORT = L=="ruRU" and GetAddOnMetadata(ADDON_NAME,"TitleS-ruRU") or GetAddOnMetadata(ADDON_NAME,"TitleShort") or ADDON_NAME_LOCALE
      ADDON_NOTES = L=="ruRU" and GetAddOnMetadata(ADDON_NAME,"Notes-ruRU") or GetAddOnMetadata(ADDON_NAME,"Notes") or UNKNOWN
      ADDON_VERSION = GetAddOnMetadata(ADDON_NAME,"Version") or UNKNOWN
      
      PARTICLES = L=="ruRU" and "Частицы" or "PARTICLES"
      SERV_DELAY = L=="ruRU" and "Серв" or "SERV"
      GAMES = L=="ruRU" and "Игр" or "GAMES"
      WINS = L=="ruRU" and "Побед" or "WINS"
      WINRATE = L=="ruRU" and "Винрейт" or "WR"
      ATTACK_POWER = L=="ruRU" and "Ап" or "AP"
      SPELL_POWER = L=="ruRU" and "Спд" or "SPD"
      RES = L=="ruRU" and "Уст" or "RSL"
      CRIT = L=="ruRU" and "Кри" or "CRT"
      HASTE = L=="ruRU" and "Ско" or "HST"
      HIT = L=="ruRU" and "Мет" or "HIT"
      MOVE_SPEED = L=="ruRU" and "Движ" or "MOV"
      TO_RES = L=="ruRU" and "До реса" or "RES"
      BY_CORPSE = L=="ruRU" and "по телу" or "CORPSE"
      TO_RES_BY_CORPSE = L=="ruRU" and "Рес по телу" or "RES CORPSE"
      ENEMIES = L=="ruRU" and "врагов реснется" or "DEAD ENMS"
      READY = L=="ruRU" and "готов" or "ready"
      RATING = L=="ruRU" and "БГ очки" or "PTS"
      MAP = L=="ruRU" and "Карта" or "MAP"
      TIME = L=="ruRU" and "Время" or "TIME"
      PLWHO = L=="ruRU" and "Онлайн(кто)" or "Players(WHO)"
      PLSRV = L=="ruRU" and "Онлайн(серв)" or "Players(SERV)"
      PVPINST = L=="ruRU" and "БГ длится" or "PVPINST"
      UPTIME = L=="ruRU" and "Аптайм" or "UPT"
      PVPFLAG = --[[L=="ruRU" and "ПвП" or]] "PvP"
      REALM = L=="ruRU" and "Серв" or "REALM"
      ARMOR = L=="ruRU" and "Бро" or "ARM"
      PARRY = L=="ruRU" and "Пар" or "PAR"
      DODGE = L=="ruRU" and "Укл" or "DOD"
      SPELL = L=="ruRU" and "Закл" or "SPELL"
      INCORRECT_VALUE = L=="ruRU" and "Некоректное значение" or "Incorrect value"
      
      ns.updateZoneAndRaidInfo()
      statsInfoString = ns.GetStatsText()
      bgInfoString = ns.GetBgInfoText()
      
      cfgPanel:Hide()
      cfgPanel:Show()
    end
    
    function cfgPanel.CreateMenu(parent, key, labelText, tooltip, y, def)
      local menu = CreateFrame("frame", ADDON_NAME.."_menu_"..key, parent, "UIDropDownMenuTemplate")
      menu:SetPoint("TOPLEFT", cfgTitle, "BOTTOMLEFT", -25, -y)

      UIDropDownMenu_SetText(menu, cfg[key] or labelText)
      --print("test", _G[menu:GetName().."Text"]:GetStringWidth())
      UIDropDownMenu_SetWidth(menu, _G[menu:GetName().."Text"]:GetStringWidth() + 50) -- test
      --UIDropDownMenu_SetWidth(_G[menu:GetName().."Text"]:GetText():GetNumLetters() * 7 + 22)
      
      UIDropDownMenu_Initialize(menu, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        
        for k, v in ipairs(def) do
          info.text = v
          info.notCheckable = true
          info.menuList = k --??
          info.func = function() 
            UIDropDownMenu_SetText(menu, v) 
            cfg[key] = v
            --print("test", _G[menu:GetName().."Text"]:GetStringWidth())
            UIDropDownMenu_SetWidth(menu, _G[menu:GetName().."Text"]:GetStringWidth() + 50) -- test
            cfgPanel.VisualUpdate()
          end
          
          UIDropDownMenu_AddButton(info)
        end
      end)
      
      menu:SetScript("OnShow", function(self)
        UIDropDownMenu_SetText(menu, cfg[key]) 
        UIDropDownMenu_SetWidth(self, _G[self:GetName().."Text"]:GetStringWidth() + 50) -- test
      end)
      
      -- фрейм текста описания
      local labelFrame = CreateFrame("Button", nil, menu) 
      labelFrame:SetPoint("LEFT", menu, "RIGHT", -10, 3)
      
      -- текст описания
      local label = labelFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
      label:SetFont(GameFontNormal:GetFont(), 12)
      label:SetPoint("LEFT", menu, "RIGHT", 0, 0)
      label:SetText(labelText)
      label:SetJustifyH("LEFT")
      label:SetJustifyV("BOTTOM")
      label:SetAllPoints(labelFrame) 
      
      labelFrame:SetScript("OnShow", function(self)
        self:SetSize(label:GetStringWidth(), label:GetStringHeight())
      end)
      
      if tooltip then
        menu:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def[1]), 0,1,1)
          GameTooltip:Show()
        end)
        menu:SetScript("OnLeave", function() GameTooltip:Hide() end)
        
        labelFrame:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def[1]), 0,1,1)
          GameTooltip:Show()
        end)
        labelFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)
      end
    end

    function cfgPanel.CreateCheckbox(parent, key, labelText, tooltip, y, def)
      local cb = CreateFrame("CheckButton", ADDON_NAME.."_CB_"..key, parent, "UICheckButtonTemplate")
      cb:SetPoint("TOPLEFT", cfgTitle, "BOTTOMLEFT", -8, -y)
      cb:SetSize(28,28)

      -- фрейм текста описания
      local labelFrame = CreateFrame("Button", nil, cb) 
      labelFrame:SetPoint("LEFT", cb, "RIGHT", 0, 0)
      
      -- текст описания
      local label = labelFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
      label:SetFont(GameFontNormal:GetFont(), 12)
      label:SetPoint("LEFT", cb, "RIGHT", 0, 0)
      label:SetText(labelText)
      label:SetJustifyH("LEFT")
      label:SetJustifyV("BOTTOM")
      label:SetAllPoints(labelFrame) 
      
      --labelFrame:SetSize(label:GetStringWidth(), label:GetStringHeight()) 
      
      labelFrame:SetScript("OnClick", function(self) 
        if cb:GetChecked() then
          cb:SetChecked(false)
        else
          cb:SetChecked(true)
        end
        cfg[key] = cb:GetChecked() and true or false
        cfgPanel.VisualUpdate()
      end)
      
      labelFrame:SetScript("OnShow", function(self)
        self:SetSize(label:GetStringWidth(), label:GetStringHeight())
      end)
      
      cb:SetScript("OnClick", function(self)
        cfg[key] = self:GetChecked() and true or false
        cfgPanel.VisualUpdate()
      end)

      cb:SetScript("OnShow", function(self)
        self:SetChecked(cfg[key])
      end)
      
      -- ++
      if tooltip then
        cb:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def), 0,1,1)
          GameTooltip:Show()
        end)
        cb:SetScript("OnLeave", function() GameTooltip:Hide() end)
        
        labelFrame:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def), 0,1,1)
          GameTooltip:Show()
        end)
        labelFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)
      end
    end

    -- new ++
    function cfgPanel.CreateEditBox(parent, key, labelText, tooltip, y, isNumber, minV, maxV, def)
      local eb = CreateFrame("EditBox", ADDON_NAME.."_EB_"..key, parent, "InputBoxTemplate")
      eb:SetAutoFocus(false)
      eb:SetPoint("TOPLEFT", cfgTitle, "BOTTOMLEFT", 0, -y)
      eb:SetFont(GameFontNormal:GetFont(), 12)
      eb:SetSize(20, 20)

      -- фрейм текста
      local labelFrame = CreateFrame("Button", nil, eb) 
      labelFrame:SetPoint("LEFT", eb, "RIGHT", 4, 0) --??
      
      -- текст
      local label = labelFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
      label:SetFont(GameFontNormal:GetFont(), 12)
      label:SetPoint("LEFT", eb, "RIGHT", 0, 0)
      label:SetText(labelText)
      label:SetJustifyH("LEFT")
      label:SetJustifyV("BOTTOM")
      label:SetAllPoints(labelFrame) 
      
      local labelDefaultText = labelText

      if isNumber then
        --if eb.SetNumeric then eb:SetNumeric(true) end
        --labelDefaultText = labelDefaultText .. " (number, default: "..def..", min: "..minV..", max: "..maxV..")"
      else
        --labelDefaultText = labelDefaultText.. " (string, default: "..def..")"
      end
      
      --++ (test)
      eb:SetScript("OnEditFocusLost", function(self) 
        self:SetText(tostring(cfg[key]))
      end)
      
      --++
      eb:SetScript("OnShow", function(self)
        self:SetText(tostring(cfg[key]))
        self:SetCursorPosition(0)
        --labelFrame:SetSize(label:GetStringWidth(), label:GetStringHeight())
        
        --if not self:HasFocus() then 
          --self:SetWidth(self:GetNumLetters() * 7 + 22)
        --end 
      end)

      --++
      eb:SetScript("OnEnterPressed", function(self) 
        --old
        --[[
        local val = tonumber(self:GetText())
        if val and val >= 1 then
          cfg.fontSize = val
          self:SetText(val)
          f.text:SetFont(DEFAULT_FONT_NAME, val) 
          print("cfg.fontSize", val)
        else
          self:SetText(cfg.fontSize or DEFAULT_FONT_SIZE)
        end
        self:ClearFocus() 
        ]]
        
        --new
        local val = self:GetText()
        if isNumber then
          local n = tonumber(val)
          if not n then
            self:SetText(tostring(cfg[key]))
          else
            if minV and n < minV then n = minV end
            if maxV and n > maxV then n = maxV end
            cfg[key] = n
            self:SetText(tostring(cfg[key]))
          end
        else
          if val == "" then val = nil end
          cfg[key] = val or ""
          self:SetText(tostring(cfg[key]))
        end
        self:ClearFocus()
        cfgPanel.VisualUpdate()
      end)
      
      --++
      eb:SetScript("OnEscapePressed", function(self) 
        --self:SetText(cfg[key])
        self:SetText(tostring(cfg[key]))
        self:ClearFocus() 
      end)
      
      --++
      eb:SetScript("OnUpdate", function(self) 
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
        
        self:SetWidth(self:GetNumLetters() * 7 + 22)
        label:SetPoint("LEFT", self, "RIGHT", 3, 0)
        labelFrame:SetSize(label:GetStringWidth(), label:GetStringHeight())
      end)

      if tooltip then
        eb:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(self, "ANCHOR_TOP")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def), 0,1,1)
          if isNumber and minV and maxV then
            GameTooltip:AddLine("Min: "..tostring(minV)..", Max: "..tostring(maxV), 0,1,1)
          end
          GameTooltip:Show()
        end)
        eb:SetScript("OnLeave", function() GameTooltip:Hide() end)
        
        labelFrame:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(self, "ANCHOR_TOP")
          GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
          GameTooltip:AddLine("Default: "..tostring(def), 0,1,1)
          if isNumber and minV and maxV then
            GameTooltip:AddLine("Min: "..tostring(minV)..", Max: "..tostring(maxV), 0,1,1)
          end
          GameTooltip:Show()
        end)
        labelFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)
      end
    end

    -- -------------------------
    -- initialize defaults
    -- -------------------------
    function cfgPanel.LoadConfig()
      cfg = mrcatsoul_Mori_EdgeInfo_Data or cfg
      mrcatsoul_Mori_EdgeInfo_Data = cfg
      
      for _, opt in ipairs(cfgPanel.options) do
        if cfg[opt.key] == nil and opt.default ~= nil then
          cfg[opt.key] = type(opt.default) == "table" and opt.default[1] or opt.default
          print(tostring(opt.key), tostring(opt.default))
        end
      end

      cfgPanel.CreateOptionsUI()
      cfgPanel.VisualUpdate()
      
      DelayedCall(0.1, function()
        print(ADDON_NAME_LOCALE, "loaded.", cfgPanel.MakeChatLink("Settings", "Settings"))
      end)
      
      return cfg
    end
    
    function cfgPanel.CreateOptionsUI()
      local y, wasCheckbox, wasEditbox = -8
      
      for _, opt in ipairs(cfgPanel.options) do
        local key = opt.key
        local label = cfgPanel.L(opt.label) or key
        local tip = cfgPanel.L(opt.tooltip)
        local def = opt.default

        if type(def) == "table" then
          y = y + ROW_HEIGHT 
          cfgPanel.CreateMenu(cfgPanel, key, label, tip, y, def)
        elseif type(def) == "boolean" then
          if wasEditbox then
            y = y + ROW_HEIGHT - 2
          else
            y = y + ROW_HEIGHT
          end
          cfgPanel.CreateCheckbox(cfgPanel, key, label, tip, y, def)
          wasCheckbox, wasEditbox = true, nil
        elseif type(def) == "number" or type(def) == "string" then
          if wasCheckbox then
            y = y + ROW_HEIGHT + 4
          else
            y = y + ROW_HEIGHT + 2
          end
          local isNum = (type(def) == "number" and opt.min and opt.max)
          cfgPanel.CreateEditBox(cfgPanel, key, label, tip, y, isNum, opt.min, opt.max, def)
          wasCheckbox, wasEditbox = nil, true
        end
      end

      -- Reset to defaults button
      local resetCount = 0
      local reset = CreateFrame("Button", ADDON_NAME.."_ResetBtn", cfgPanel, "UIPanelButtonTemplate")
      reset:SetSize(140, 22)
      reset:SetPoint("RIGHT", titleTip, "RIGHT", 155, 0)
      reset:SetText(cfgPanel.L({ en = "Reset to defaults", ru = "Сбросить к умолчаниям" }))
      reset:SetScript("OnClick", function()
        resetCount = resetCount +1
        if resetCount >= 5 then
          resetCount = 0
          for _, opt in ipairs(cfgPanel.options) do
            cfg[opt.key] = type(opt.default) == "table" and opt.default[1] or opt.default
          end
          cfgPanel.VisualUpdate()
          UIFrameFlashStop(cfgPanel)
          UIFrameFlash(cfgPanel, 1.5, 0.5, 2, true, 2, 0)
          GameTooltip:SetText(cfgPanel.L({ en = "The config reset was successful.", ru = "Сброс конфига успешно выполнен." }))
        else
          local needCount = 5 - resetCount
          GameTooltip:SetText(cfgPanel.L({ en = "To reset, press 5 times.|r\n"..(5-resetCount).." times remaining.", ru = "Чтобы выполнить сброс нажать 5 раз.|r\nОсталось "..(5-resetCount).." раз(а)." }))
        end
      end)
      
      reset:SetScript("OnEnter", function(self) 
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        if resetCount == 0 then
          GameTooltip:SetText(cfgPanel.L({ en = "To reset, press 5 times.", ru = "Чтобы выполнить сброс нажать 5 раз." }))
        else
          GameTooltip:SetText(cfgPanel.L({ en = "To reset, press 5 times.|r\n"..(5-resetCount).." times remaining.", ru = "Чтобы выполнить сброс нажать 5 раз.|r\nОсталось "..(5-resetCount).." раз(а)." }))
        end
        GameTooltip:Show() 
      end)

      reset:SetScript("OnLeave", function(self) 
        GameTooltip:Hide() 
      end)
    end
  end
  -- end settings

  local DelayedCall
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
            local ok, err = pcall(c.func, unpack(c.args or {}))
            if not ok then
              DEFAULT_CHAT_FRAME:AddMessage("DelayedCall error: "..tostring(err))
            end
            tremove(calls, i)
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
      tinsert(calls, { delay = delay, time = 0, func = func, args = {...}, cancelled = false })
      if not f:GetScript("OnUpdate") then
        f:SetScript("OnUpdate", OnUpdate)
      end
    end
  end
  
  -- серверное время
  local GameTime
  do
    local GetGameTime, GetTime = GetGameTime, GetTime

    GameTime = {
      Get = function(self)
        if self.LastMinuteTimer == nil then
          local h, m = GetGameTime()
          return h, m, 0
        end
        
        local s = GetTime() - self.LastMinuteTimer
        local ms = floor((s % 1) * 1000 + 0.5)

        if s > 59.999 then
          s = 59.999
        end
        
        return self.LastGameHour, self.LastGameMinute, s, ms
      end,

      OnUpdate = function(self)
        local h, m = GetGameTime()
        if self.LastGameMinute == nil then
          self.LastGameHour = h
          self.LastGameMinute = m
          return
        end
        if self.LastGameMinute == m then
          return
        end
        self.LastGameHour = h
        self.LastGameMinute = m
        self.LastMinuteTimer = GetTime()
      end,

      Initialize = function(self)
        self.Frame = CreateFrame("Frame")
        self.Frame:SetScript("OnUpdate", function() self:OnUpdate() end)
      end
    }

    GameTime:Initialize()
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
  
  local function formatTime(seconds)
    if seconds >= 60 then
      return format("%.1dm %.2ds", floor(seconds / 60), seconds % 60)
    else
      return format("%.1ds", seconds)
    end
  end
  
  -- милисекунды
  local TimeFormatter = {}
  
  local daysRU = {
    ["0"] = "Воскресенье",
    ["1"] = "Понедельник",
    ["2"] = "Вторник",
    ["3"] = "Среда",
    ["4"] = "Четверг",
    ["5"] = "Пятница",
    ["6"] = "Суббота"
  }

  -- local daysRU = {
    -- ["0"] = "ВС",
    -- ["1"] = "ПН",
    -- ["2"] = "ВТ",
    -- ["3"] = "СР",
    -- ["4"] = "ЧТ",
    -- ["5"] = "ПТ",
    -- ["6"] = "СБ"
  -- } 
  
  function TimeFormatter:GetFormattedTime()
    if not self.timeOffset then
      self.timeOffset = time() - floor(GetTime())
    end

    local now = GetTime()
    local seconds = floor(now)
    local milliseconds = floor((now - seconds) * 1000)
    local fullTime = self.timeOffset + seconds
    
    if L == "ruRU" then
      local day = date("%w", fullTime) -- Получаем номер дня недели (0-6, где 0 - воскресенье)
      return format("%s  %s.%03d", daysRU[day], date("%d.%m.%Y  %H:%M:%S", fullTime), milliseconds)
    end
    
    return format("%s.%03d", date("%A  %d.%m.%Y  %H:%M:%S", fullTime), milliseconds)
    --return date("%A  %d.%m.%Y  %H:%M:%S", fullTime) .. format(".%03d", milliseconds)
  end
  _G.GetFormattedTime = TimeFormatter.GetFormattedTime 
   
  -- Создаем статус-бар
  do
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
    textFrame:SetFrameStrata("high")
    textFrame:SetFrameLevel(10)
    
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

    local function truncate(num, digits)
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

    -- local function getTalentpointsSpent(spellID)
      -- local spellName = GetSpellInfo(spellID)
      -- for tabIndex = 1, GetNumTalentTabs() do
        -- for talentID = 1, GetNumTalents(tabIndex) do
          -- local name, _, _, _, spent = GetTalentInfo(tabIndex, talentID)
          -- if name == spellName then
            -- return spent
          -- end
        -- end
      -- end
      -- return 0
    -- end

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
    
    local function updateZoneAndRaidInfo()
      local isInstance, InstanceType = IsInInstance()
      InDungeon, InRaidDungeon, InBg, InArena, InRaidGroup, spectatorMode, instanceDifficulty, zonePvpType, showAttackPower, showSpellPower, InCrossZone, isHunter = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil

      local _, type, _, _, maxPlayers, playerDifficulty = GetInstanceInfo()
      zonePvpType = GetZonePVPInfo()
      curZone = GetRealZoneText()

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
    ns.updateZoneAndRaidInfo = updateZoneAndRaidInfo

    --[[
    local function GetRezTimerInfo()
      local text, CorpseRecoveryDelay = ""
     
      if InBg then
        local secondsToRes = RezTimer_Data and RezTimer_Data.cd
        
        if secondsToRes then
          text = text .. TO_RES .. ": |cffff8822" .. secondsToRes .. "|r"
          if UnitIsDeadOrGhost("player") then
            CorpseRecoveryDelay = GetCorpseRecoveryDelay()
            if CorpseRecoveryDelay > 0 then
              text = text .. INDENT .. BY_CORPSE .. ": |cffff8822" .. formatTime(CorpseRecoveryDelay) .. "|r"
            else
              text = text .. INDENT .. BY_CORPSE .. ": |cff33ff33" .. READY .. "|r"
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
          text = text .. INDENT ..ENEMIES .. ": |cffff6622" .. RezTimer_Data.counter .. "|r"
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
    ]]
    
    local function GetRezTimerInfo()
      local parts = {}
      local isDead = UnitIsDeadOrGhost("player")
      local recoveryDelay = isDead and GetCorpseRecoveryDelay() or 0
      
      -- 1. Таймер БГ (если есть данные)
      local bgCD = InBg and RezTimer_Data and RezTimer_Data.cd
      if bgCD then
        tinsert(parts, format("%s: |cffff8822%s|r", TO_RES, bgCD))
      end
      
      -- 2. Таймер до тела (универсальный блок)
      if isDead then
        local label = bgCD and BY_CORPSE or TO_RES_BY_CORPSE
        local timeStr = (recoveryDelay > 0) 
          and format("|cffff8822%s|r", formatTime(recoveryDelay)) 
          or format("|cff33ff33%s|r", READY)
        
        tinsert(parts, format("%s: %s", label, timeStr))
      end
      
      -- 3. Счетчик врагов
      if InBg and RezTimer_Data and RezTimer_Data.counter then
        tinsert(parts, format("%s: |cffff6622%d|r", ENEMIES, RezTimer_Data.counter))
      end
      
      return tconcat(parts, INDENT)
    end
    
    local function GetBgInfoText()
      local bgstats = bg_statistics and bg_statistics[playerGUID]
      local data = {}

      if bgstats then
        -- Берем данные из текущей сессии БГ
        data.rating = bgstats.rating
        data.wins = bgstats.wins or 0
        data.games = bgstats.games or 0
      else
        -- Берем общие данные персонажа
        data.wins = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_WON)) or 0
        data.games = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_PLAYED)) or 0
      end

      -- Считаем винрейт (один раз для обоих случаев)
      local wr = (data.games > 0) and (data.wins / data.games * 100) or 0
      local wrColor = (data.games > 0) and f.RGBGradient(1 - wr / 100) or "999999"

      -- Собираем итоговую строку
      local parts = {
        format("%s: |cccf1f1a1%d|r", GAMES, data.games),
        format("%s: |cccf1f1a1%d|r", WINS, data.wins),
        format("%s: |ccc%s%d%%|r", WINRATE, wrColor, truncate(wr))
      }

      if data.rating then
        table.insert(parts, format("%s: %d", RATING, data.rating))
      end

      return table.concat(parts, INDENT)
    end
    ns.GetBgInfoText = GetBgInfoText
    
    --[[
    local function GetBgInfoText()
      local bgstats = bg_statistics and bg_statistics[playerGUID]
      
      local winsTest, bgPts, gamesTest, winrateTest, wrColorTest, gamesTtl, winsTtl, winRateTtl, wrColorTtl
      
      if bgstats then
        bgPts = bgstats.rating or 0
        winsTest = bgstats.wins or 0
        gamesTest = bgstats.games or 0
        
        if gamesTest > 0 then
          winrateTest = gamesTest > 0 and truncate(winsTest / gamesTest *100) or 0
          wrColorTest = gamesTest > 0 and f.RGBGradient(1 - (winsTest / gamesTest *100) / 100) or "999999"
          winrateTest = "|ccc" .. wrColorTest .. winrateTest .. "|r"
        end
      else
        gamesTtl = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_PLAYED)) or 0
        winsTtl = tonumber(GetStatistic(ACHIV_CATEGORY_ID_BATTLEGROUNDS_WON)) or 0
        winRateTtl = gamesTtl > 0 and truncate(winsTtl / gamesTtl *100) or 0
        wrColorTtl = gamesTtl > 0 and f.RGBGradient(1 - (winsTtl / gamesTtl *100) / 100) or "999999"
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
      
      local text = gamesStr .. INDENT .. winsStr
      text = winRateStr and text .. INDENT .. winRateStr or text
      
      if bgPts then
        text = text .. INDENT .. RATING .. ": " .. bgPts
      end
      
      return text
    end
    ]]

    --[[
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
        --hexcolor = f.RGBGradient(spdOrAp / 9000)
        hexcolor = f.RGBGradient(1 - spdOrAp / 12000)
        --hexcolorHaste = f.RGBGradient(157 / 1000)
        hexcolorHaste = haste == 0 and "999999" or "ffffff"
        hexHitColor = f.RGBGradient(1 - hit / 10)
      elseif showSpellPower then
        hexcolor = f.RGBGradient(1 - spdOrAp / 3500)
        --hexcolorHaste = f.RGBGradient(haste / 2000)
        hexcolorHaste = f.RGBGradient(1 - haste / 50)
        hexHitColor = f.RGBGradient(1 - hit / 10)
      end
      
      hexcolorCrit = f.RGBGradient(1 - crit / 50)
      
      local res = GetCombatRating(16)
      local resColor = f.RGBGradient(1 - tonumber(res) / 1414)

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
          text = text .. ": |cff" .. hexcolor .. spdOrAp .. "|r" .. INDENT .. CRIT .. ": |cff" .. hexcolorCrit .. truncate(crit) .. "|r" .. INDENT .. HASTE .. ": |cff" .. hexcolorHaste .. truncate(haste) .. "|r" .. INDENT .. HIT .. ": |cff" .. hexHitColor .. truncate(hit) .. "|r" .. INDENT .. ARMOR .. ": |cff" .. armorColor .. armor .. "|r"
        elseif showSpellPower then
          text = text .. ": |cff" .. hexcolor .. spdOrAp .. "|r" .. INDENT .. CRIT .. ": |cff" .. hexcolorCrit .. truncate(crit) .. "|r" .. INDENT .. HASTE .. ": |cff" .. hexcolorHaste .. truncate(haste) .. "|r" .. INDENT .. HIT .. ": |cff" .. hexHitColor .. truncate(hit) .. "|r"
        else
          text = text .. ": |cff" ..hexcolor .. spdOrAp .."|r" .. INDENT .. CRIT .. ": |cff" ..hexcolorCrit .. format("%.0f", crit) .. "|r" .. INDENT .. HASTE .. ": |cff" .. hexcolorHaste .. "" ..truncate(haste) .. "|r" .. INDENT .. HIT.. ": |cff" .. hexHitColor .. truncate(hit) .. "|r" .. INDENT .. ARMOR..": |cff" .. armorColor .. armor.."|r"
        end
      else
        if showAttackPower then 
          text = text .. ": |cff" .. hexcolor .. spdOrAp .. "|r" .. INDENT .. RES .. ": |cff" .. resColor .. res .. "|r" .. INDENT .. PARRY .. ": |cfff1f1a1" .. truncate(GetParryChance(),1) .. "|r" .. INDENT .. ARMOR .. ": |cff" .. armorColor ..  armor .. "|r"
        elseif showSpellPower then
          text = text .. ": |cff" ..hexcolor .."" ..spdOrAp .. "|r" .. INDENT .. RES .. ": |cff" .. resColor .. res .. "|r" .. INDENT .. CRIT..": |cff" ..hexcolorCrit .. truncate(crit) .. "|r" .. INDENT .. HASTE .. ": |cff" .. hexcolorHaste .. truncate(haste) .. "|r" .. INDENT .. HIT .. ": |cff" .. hexHitColor .. ""..truncate(hit).."|r"
        else
          text = text .. ": |cff" .. hexcolor .. spdOrAp .. "|r" ..INDENT .. RES .. ": |cff" .. resColor .. res .. "|r" ..INDENT .. CRIT .. ": |cff" .. hexcolorCrit .. format("%.0f", crit) .. "|r" .. INDENT .. HASTE .. ": |cff" .. hexcolorHaste .. truncate(haste) .. "|r" .. INDENT .. HIT..": |cff" .. hexHitColor .. truncate(hit).. "|r" ..INDENT .. ARMOR .. ": |cff" .. armorColor .. armor .. "|r"
        end
      end
      
      return text
    end
    ]]

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
      local critStr = format("%.0f%s", crit, PERCENT) --(showSpellPower or showAttackPower) and truncate(crit) 
      local parryVal = format("%.0f%s", GetParryChance(), PERCENT) --truncate(GetParryChance(), 1)
      local dodgeVal = format("%.0f%s", GetDodgeChance(), PERCENT) --truncate(GetDodgeChance(), 0) 
      armor = (format("%.1f", armor / 1000):gsub("%.0", "") .. "k")

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
          val = critStr, 
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
          val = parryVal, 
          color = "f1f1a1" 
        },
        { 
          check = cfg.showDodge, 
          label = DODGE, 
          val = dodgeVal, 
          color = "f1f1a1" 
        },
        { 
          check = cfg.showArmor, 
          label = ARMOR, 
          val = armor, 
          color = armorColor 
        },
      }

      -- 4. Формируем итоговую строку
      local parts = {}
      for _, stat in ipairs(statsList) do
        if stat.check then
          -- Если label совпадает с AP/SP, выводим "Label: Val", иначе просто "Label: Val" с отступом
          -- В твоем старом коде для первого стата (AP/SP) отступа не было.
          local textPart = format("%s: |cff%s%s|r", stat.label, stat.color, stat.val)
          tinsert(parts, textPart)
        end
      end
      
      -- Соединяем все части через отступ (INDENT)
      return tconcat(parts, INDENT or "   ")
    end

    local function GetZoneInfo()
      local _instanceDifficulty = instanceDifficulty and (" |ccc" .. zoneColor .. "(" .. instanceDifficulty .. ")|r") or ""
      local _spectatorMode = spectatorMode and ("  [spectator]") or ""
      
      local PVPTimer = GetPVPTimer() / 1000
      local pvpOn = UnitIsPVP("player")
      local pvpInfo = pvpOn and ("|cffff0000" .. PVPFLAG .. "|r") or ""
      
      local x, y = GetPlayerMapPosition("player")
      x, y = floor(x * 1000 + 0.5) / 10, floor(y * 1000 + 0.5) / 10
      
      if pvpOn and PVPTimer > 0 then
        if PVPTimer < 300 then
          pvpInfo = pvpInfo .. " " .. formatTime(PVPTimer)
        end
      end
      
      zoneInfoString = MAP .. ": |ccc" .. zoneColor .. curZone .. "|r" .. _instanceDifficulty .. _spectatorMode.."  " .. x .. ", " .. y .. "  " .. pvpInfo

      return zoneInfoString
    end

    local SpellUseDelay, SpellUseDelaySpell = "-"
    
    local function GetSpellUseDelay()
      if f.tLength(UNIT_SPELLCAST_SENT) > 0 then
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
          statsInfoString = ns.GetStatsText()
      elseif event == "PLAYER_DAMAGE_DONE_MODS" then
        statsInfoString = ns.GetStatsText()
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
        textFrame:SetFrameLevel(10)
      elseif event == "PLAYER_ENTERING_WORLD" then
        updateZoneAndRaidInfo()
        SetWhoToUI(1)
        was_SYSMSG_SPAM_ERROR_error = nil
        bgInfoString = GetBgInfoText()
        statsInfoString = ns.GetStatsText()
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
        if msg:find(SYSMSG_SPAM_ERROR, 1, true) then
          textFrame.needWaitServerInfo = nil
          --print(SYSMSG_SPAM_ERROR)
          if needShowServerInfo and needShowServerInfo == 0 then
            was_SYSMSG_SPAM_ERROR_error = true
            print("["..GetAddOnMetadata(ADDON_NAME, "Title").."]: |cffff7733Сообщение об ошибке от сервера при ручной отправке server info. Ждём 1 сек и траим отправить server info ещё раз из аддона.|r")
            DelayedCall(1, function()
              print("["..GetAddOnMetadata(ADDON_NAME, "Title").."]: |cff00ffaaОтправляем...|r")
              SendChatMessage(".server info", "guild")
            end)
          end
        elseif msg:find("Server delay: ", 1, true) then
          serverDelay = tonumber(string.match(msg, "Server delay: (%d+) ms")) or -1
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
            serverUptime = string.format("%dh %02dm %02ds", h, m, sec)
          elseif m > 0 then
            serverUptime = string.format("%dm %02ds", m, sec)
          else
            serverUptime = string.format("0:%02ds", sec)
          end
        elseif msg:find("Active connections: ", 1, true) then
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
      local numSteps = duration / min(cfg.updateIntervalGlobal, duration)
      
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
    
    textFrame.servInfoTime, textFrame.t = 0, 0
    
    textFrame:SetScript("OnUpdate", function(self, elapsed)
      self.t = self.t + elapsed
      self.servInfoTime = self.servInfoTime + elapsed
      --self.servInfoTime = self.servInfoTime and self.servInfoTime + cfg.updateIntervalGlobal
      --print(self.t)
      if self.t < cfg.updateIntervalGlobal then return end
      self.t = self.t - cfg.updateIntervalGlobal

      local UPDATE_INTERVAL_SERVER_INFO = cfg.update_interval_server_info or UPDATE_INTERVAL_SERVER_INFO
      
      if cfg.server_info and not self.needWaitServerInfo and self.servInfoTime > UPDATE_INTERVAL_SERVER_INFO then
        --print("server info",self.servInfoTime)
        self.needWaitServerInfo = true
        self.servInfoTime = 0
        SendChatMessage(".server info", "guild")
        if not (WhoFrameEditBox:IsVisible() and WhoFrameEditBox:GetText() ~= "") and not IsShiftKeyDown() then
          SendWho("")
        end
      end

      --print(self.t)

      -- === ПОДГОТОВКА ДАННЫХ ===
      
      -- Цвета и значения (используем кэш и сглаживание)
      local fps = GetFramerate()
      local fpsColor = f.GetCachedColor("fps", fps, 60)
      
      local latency = f.GetSmoothedValue("latency", select(3, GetNetStats()))
      local latColor = f.GetCachedColor("latency", latency, 150)
      
      local responce = f.GetSmoothedValue("responce", ns.responceTime)
      local respColor = tonumber(responce) and f.GetCachedColor("responce", responce, 150) or "f1f1a1"
      
      local connections = f.GetSmoothedValue("connections", activeConnections)
      local whoResults = f.GetSmoothedValue("who", NumWhoResults)
      
      local srvDelayVal = f.GetSmoothedValue("srvDelay", serverDelay)
      local srvDelayColor = tonumber(srvDelayVal) and f.GetCachedColor("srvDelay", srvDelayVal, 150) or "f1f1a1"

      -- Частицы
      local particleDensity = tonumber(GetCVar("particleDensity")) * 100
      local p_perc = particleDensity / 100
      -- Упрощенная логика цвета частиц (без создания лишних переменных r,g,b)
      local p_r = (p_perc < 0.5) and 1 or (2 - p_perc * 2)
      local p_g = (p_perc < 0.5) and (p_perc * 2) or 1
      local particleColor = f.rgbToHex(p_r, p_g, 0)
      
      -- Скорость
      local speed = GetUnitSpeed("player") / 7 * 100
      local speedColor = (speed > 0) and f.GetCachedColor("speed", speed, 250) or "888888"

      -- Spell Delay
      local spellDelay, spell = GetSpellUseDelay()
      spellDelay = f.GetSmoothedValue("spellDelay", spellDelay)
      local spellDelayColor = tonumber(spellDelay) and f.GetCachedColor("spell", spellDelay, 150) or "f1f1a1"
      
      local spellIconStr = ""
      if spell then
        local icon = select(3, GetSpellInfo(spell))
        if icon then 
          spellIconStr = format(" |T%s:%d|t", icon, DEFAULT_FONT_SIZE + 1)
        end
      end

      -- Время (Realm)
      local h, m, s, ms = GameTime:Get()
      local realmTimeFmt = ms 
        and format("%02d:%02d:%02d.%03d", h, m, s, ms)
        or  format("%02d:%02d", h, m)
        
      -- Таймер БГ
      local bgTimeStr = ""
      if (InBg or InArena) then
        local bgRunTime = GetBattlefieldInstanceRunTime()
        if bgRunTime and bgRunTime > 0 then
          bgTimeStr = format("  %s: |cccf1f1a1%s|r", PVPINST, formatTime(bgRunTime / 1000))
        end
      end

      -- === СБОРКА СТРОК (БЛОКИ) ===
      
      -- Блок 1: Инфо (Зона, Рес, Время)
      local rezInfo = (cfg.RezTimer and GetRezTimerInfo()) or ""
      local topBlock = format("%s%s%s\n%s: |cccf1f1a1%s|r%s%s: |cccf1f1a1%s|r",
        GetZoneInfo(), -- Зона
        bgTimeStr,     -- Таймер БГ (если есть)
        (rezInfo ~= "") and ("\n"..rezInfo) or "", -- Таймер реса (с новой строкой если есть)
        TIME, TimeFormatter:GetFormattedTime(),    -- Локальное время
        INDENT, REALM, realmTimeFmt                -- Серверное время
      )

      -- Блок 2: Технические (FPS, Частицы, Онлайн)
      local techBlock = format("\nFPS: |ccc%s%-5d|r  %s: |ccc%s%-3d|r%s%s: |cccf1f1a1%s|r%s%s: |cccf1f1a1%s|r",
        fpsColor, fps, 
        PARTICLES, particleColor, particleDensity,
        INDENT, PLSRV, connections,
        INDENT, PLWHO, whoResults
      )
           
      -- Блок 3: Сеть (Пинг, RTT, Спеллы, Сервер)
      local netBlock = format("\nLAT: |ccc%s%s|r%sRTT: |ccc%s%s|r%s%s: |ccc%s%s%s|r%s%s: |ccc%s%s|r%s%s: |cccf1f1a1%s|r",
        latColor, latency,
        INDENT, respColor, responce,
        INDENT, SPELL, spellDelayColor, spellDelay, spellIconStr,
        INDENT, SERV_DELAY, srvDelayColor, srvDelayVal,
        INDENT, UPTIME, serverUptime
      )
           
      -- Блок 4: Статы игрока
      local statsBlock = statsInfoString
      
      if cfg.showMovementSpeed then
        statsBlock = format("%s%s%s: |ccc%s%d%s|r", statsBlock, statsBlock ~= "" and INDENT or "", MOVE_SPEED, speedColor, speed, PERCENT)
      end
           
      if statsBlock ~= "" then
        --print(statsBlock)
        statsBlock = "\n" .. statsBlock
      end
      
      if ENABLE_BG_INFO_BLOCK or cfg.showBattlegroundStats then
        statsBlock = statsBlock .. "\n" .. bgInfoString
      end
      
      -- Финальная склейка
      local finalText = topBlock .. techBlock .. netBlock .. statsBlock

      if self.text:GetText() ~= finalText then
        self.text:SetText(finalText)
      end
      
      -- Обновление слайдера (синхронизация с частицами)
      if cfg.showParticleDensityBar and f:GetValue() ~= particleDensity then
        f:SetValue(particleDensity) 
      end
    end)
    
    --[[
    textFrame:SetScript("onupdate", function(self, elapsed)
      self.t = self.t + elapsed
      --self.servInfoTime = self.servInfoTime and self.servInfoTime + cfg.updateIntervalGlobal
      --print(self.t)
      if self.t < cfg.updateIntervalGlobal then return end

      self.servInfoTime = self.servInfoTime + self.t
      
      local UPDATE_INTERVAL_SERVER_INFO = cfg.update_interval_server_info or UPDATE_INTERVAL_SERVER_INFO
      
      if cfg.server_info and not self.needWaitServerInfo and self.servInfoTime > UPDATE_INTERVAL_SERVER_INFO then
        self.needWaitServerInfo = true
        self.servInfoTime = 0
        --print("server info")
        SendChatMessage(".server info", "guild")
        if not (WhoFrameEditBox:IsVisible() and WhoFrameEditBox:GetText() ~= "") and not IsShiftKeyDown() then
          SendWho("")
        end
      end
      
      -- === СБОР ДАННЫХ ===
      
      -- 1. Зона (кэшированная)
      local zoneStr = ns.GetZoneInfo()
      
      -- 2. Таймер реса
      local rezStr = cfg.RezTimer and GetRezTimerInfo()

      -- 3. Время (быстрое обновление)
      local timeStr = "|cccf1f1a1" .. TimeFormatter:GetFormattedTime() .. "|r"
      local realmTimeStr = ""

      local h, m, s, ms = GameTime:Get()
      if ms then 
        realmTimeStr = format("%s%s: |cccf1f1a1%02d:%02d:%02d.%03d|r", INDENT, REALM, h, m, s, ms)
      else
        realmTimeStr = format("%s%s: |cccf1f1a1%02d:%02d|r", INDENT, REALM, h, m)
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
      --local particleColor = f.GetCachedColor("particle", rawDensity, 50) -- 50 середина, логика чуть упрощена для скорости
      --if rawDensity < 50 then particleColor = f.rgbToHex(rawDensity/50, 1, 0) end -- Кастомная логика для частиц
      local particleColor = f.rgbToHex(particle_r, particle_g, 0)
      
      -- 5. Сглаженные статы
      local latency = f.GetSmoothedValue("latency", select(3, GetNetStats()))
      local latColor = f.GetCachedColor("latency", latency, 150)
      
      local responce = f.GetSmoothedValue("responce", ns.responceTime)
      local respColor = tonumber(responce) and f.GetCachedColor("responce", responce, 150) or "f1f1a1"
      
      local connections = f.GetSmoothedValue("connections", activeConnections)
      local whoResults = f.GetSmoothedValue("who", NumWhoResults)
      
      local srvDelayVal = f.GetSmoothedValue("srvDelay", serverDelay)
      local srvDelayColor = tonumber(srvDelayVal) and f.GetCachedColor("srvDelay", srvDelayVal, 150) or "f1f1a1"
      
      local fps = GetFramerate()
      local fpsColor = f.GetCachedColor("fps", fps, 60)
      
      -- Spell Delay
      local spellDelay, spell = GetSpellUseDelay()
      spellDelay = f.GetSmoothedValue("spellDelay", spellDelay)
      local spellDelayColor = tonumber(spellDelay) and f.GetCachedColor("spell", spellDelay, 150) or "f1f1a1"
      if spell then
        local spellIcon = select(3, GetSpellInfo(spell))
        if spellIcon then 
          spellDelay = spellDelay .. " |T" .. spellIcon .. ":"..(DEFAULT_FONT_SIZE+1).."|t"
        end
      end

      -- 6. Скорость
      local speed = GetUnitSpeed("player") / 7 * 100
      local speedColor = f.GetCachedColor("speed", speed, 250)
      if speed == 0 then speedColor = "888888" end

      -- === СБОРКА СТРОКИ (Единый format для экономии памяти) ===
      
      -- Собираем строку "блоками", чтобы избежать множества '..'
      -- Блок 1: Верх (Зона, Рес, Время)
      -- local topBlock = zoneStr 
      local topBlock = zoneStr
     
      local BattlefieldInstanceRunTime, BattlefieldInstanceRunTimeInfo = (InBg or InArena) and GetBattlefieldInstanceRunTime()
      --local BattlefieldInstanceRunTime = GetBattlefieldInstanceRunTime()
      --print(BattlefieldInstanceRunTime)
      if BattlefieldInstanceRunTime then
        topBlock = topBlock .. "  "..PVPINST..": |cccf1f1a1"..formatTime(BattlefieldInstanceRunTime / 1000).."|r"
      end

      if rezStr ~= "" then topBlock = topBlock .. "\n" .. rezStr end
      topBlock = topBlock .. "\n"..TIME..": " .. timeStr .. realmTimeStr

      -- Блок 2: Технические статы (FPS, Particles, PL)
      -- %-4d : 
      -- "-" означает выравнивание по левому краю (пробелы полетят вправо)
      -- "4" это общая ширина строки
      -- "d" означает, что мы работаем с целым числом
      local techBlock = format("\nFPS: |ccc%s%-5d|r  %s: |ccc%s%-3d|r%s%s: |cccf1f1a1%s|r%s%s: |cccf1f1a1%s|r",
          fpsColor, fps, PARTICLES, particleColor, particleDensity, INDENT, PLSRV, connections, INDENT, PLWHO, whoResults)
          
      -- Блок 3: Сетевые статы (Lat, Msg, Spell, Serv, Upt)
      local netBlock = format("\nLAT: |ccc%s%s|r%sRTT: |ccc%s%s|r%s%s: |ccc%s%s|r%s%s: |ccc%s%s|r%s%s: |cccf1f1a1%s|r",
          latColor, latency, INDENT, respColor, responce, INDENT, SPELL, spellDelayColor, spellDelay, INDENT, SERV_DELAY, srvDelayColor, srvDelayVal, INDENT, UPTIME, serverUptime)
          
      -- Блок 4: Инфо (BG, Stats, Speed)
      --local infoBlock = format("\n%s    PVPINST: |cccf1f1a1%s|r\n%s    %s: |ccc%s%d|r",
          --bgInfoString, formatTime(GetBattlefieldInstanceRunTime() / 1000), statsInfoString, MOVE_SPEED, speedColor, speed)
      local infoBlock = format("\n%s%s", statsInfoString, INDENT)
          
      if cfg.showMovementSpeed then
        infoBlock = infoBlock .. format("%s: |ccc%s%d|r", MOVE_SPEED, speedColor, speed)
      end
          
      if ENABLE_BG_INFO_BLOCK or cfg.showBattlegroundStats then
        infoBlock = infoBlock .. "\n" .. bgInfoString
      end

      -- Финальная склейка (всего 3 конкатенации вместо 20+)
      local finalText = topBlock .. techBlock .. netBlock .. infoBlock

      if self.text:GetText() ~= finalText then
        self.text:SetText(finalText)
      end
      
      -- Обновление слайдера настроек частиц (если открыт)
      if cfg.showParticleDensityBar and f:GetValue() ~= particleDensity then
        f:SetValue(particleDensity) 
      end
      
      self.t = 0
    end)
    ]]
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
      
      -- msg:find("WoW Circle Wotlk Development 3.3.5a", 1, true) 
      -- or msg:find("WoW Circle Core: Last Update", 1, true) 
      -- or msg:find("WoW Circle DB: Last Update", 1, true) 
      -- or msg:find("Active connections:", 1, true) 
      -- or msg:find("Server uptime:", 1, true) 
      -- or msg:find("Next arena point distribution time:", 1, true) 
      -- or msg:find("Server delay:", 1, true) 
      -- --ru
      -- or msg:find("Игроков онлайн:", 1, true)
      -- or msg:find("Продолжительность работы сервера:", 1, true)
      -- or msg:find("WoW Circle Cross Server:", 1, true)
      -- or (msg:find(SYSMSG_SPAM_ERROR, 1, true) and cfg.hide_SYSMSG_SPAM_ERROR)
      
      if isServerInfoMsg then
        if not needShowServerInfo then
          --print("filter+",msg)
          return true
        end

        if needShowServerInfo then
          if was_SYSMSG_SPAM_ERROR_error then
            was_SYSMSG_SPAM_ERROR_error = nil
            print("["..GetAddOnMetadata(ADDON_NAME, "Title").."]: |cff44ff44Отправлено.|r")
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
    
    local LOW_LVL_MUTE = L=="ruRU" and "Лоу лвл мут" or "Low lvl mute"
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
      
      local SECONDS_RTT_UPDATE_INTERVAL = cfg.seconds_rtt_update_interval or SECONDS_RTT_UPDATE_INTERVAL
      if s.updateValueTime < SECONDS_RTT_UPDATE_INTERVAL then return end
      
      if not playerName or playerName == UNKNOWN then
        playerName = UnitName("player")
      end
      
      local _time = GetTime()
      
      if lastRequestSendTime and responceReceivedTime==nil and s.newRequestTime ~= 0 then
        local diff = _time - lastRequestSendTime
        if diff > 0 then
          ns.responceTime = modf((_time - lastRequestSendTime) *1000)
          --print("|cffff5500responceTime(connection dead):", ns.responceTime)
        end
      end
      
      s.newRequestTime = s.newRequestTime + s.updateValueTime
      --print(s.newRequestTime)
      local SECONDS_SEND_ADDON_MESSAGE_INTERVAL = cfg.seconds_send_addon_message_interval or SECONDS_SEND_ADDON_MESSAGE_INTERVAL
      
      if ns.cannotSend then
        ns.responceTime = "|cffff0000"..LOW_LVL_MUTE.."|r"
      elseif playerName == nil or playerName == UNKNOWN or playerName == "" then
        ns.responceTime = "|cffff0000"..NAME_UNKNOWN.."|r"
      elseif s.newRequestTime > SECONDS_SEND_ADDON_MESSAGE_INTERVAL and responceReceivedTime then
        local chan = UnitIsDND("player")==nil and "WHISPER" or IsInGuild() and "GUILD" or GetNumRaidMembers()>0 and "RAID" or GetNumPartyMembers()>0 and "PARTY"
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
    for i = 1, cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY do
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
        for i = 1, cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY, 1 do
          f.topAddOns[i].value = 0
        end
       
        UpdateAddOnMemoryUsage()
        
        local totalMem = 0
       
        for i = 1, GetNumAddOns(), 1 do
          local mem = GetAddOnMemoryUsage(i)
          totalMem = totalMem + mem
          
          for j = 1, cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY, 1 do
            if mem > f.topAddOns[j].value then
              for k = cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY, 1, -1 do
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
          
          for i = 1, cfg.num_addons_to_display or NUM_ADDONS_TO_DISPLAY, 1 do
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
    local interval = 0.1 -- Обновляем раз в N секунды
    local TargetMinFPS = 50  -- Нижний порог FPS
    local TargetMaxFPS = 59  -- Верхний порог FPS
    local AdjustmentStep = 0.05 -- Шаг изменения particleDensity
    local focusTime
    local IsWindowFocused = IsWindowFocused
    local PARTICLE_VALUE_MIN, PARTICLE_VALUE_MAX = 0.101, 1
    local GetTime = GetTime 
    local GetFramerate = GetFramerate
    local math_max, math_min, tonumber = math.max, math.min, tonumber
    local GetCVar, SetCVar = GetCVar, SetCVar
    SetCVar("particleDensity", PARTICLE_VALUE_MAX)

    local function func_dynamicParticleDensity(s, e)
      s.t = s.t and s.t + e or 0; if s.t < interval then return end; s.t = 0
      
      local t=GetTime()
      
      if IsWindowFocused then
        if not IsWindowFocused() then 
          focusTime=nil
          SetCVar("particleDensity", PARTICLE_VALUE_MIN)
          return 
        end
      end
      
      if focusTime and (focusTime+1) > t then
        return
      end
      
      local fps = GetFramerate()
      local particleDensity = tonumber(GetCVar("particleDensity"))

      if fps < TargetMinFPS and particleDensity > PARTICLE_VALUE_MIN then
        -- Понижаем particleDensity на малый шаг, но не ниже 0.101
        particleDensity = math.max(particleDensity - AdjustmentStep, PARTICLE_VALUE_MIN)
        SetCVar("particleDensity", particleDensity)
      elseif fps > TargetMaxFPS and particleDensity < PARTICLE_VALUE_MAX then
        -- Повышаем particleDensity на малый шаг, но не выше 1
        particleDensity = math.min(particleDensity + AdjustmentStep, PARTICLE_VALUE_MAX)
        SetCVar("particleDensity", particleDensity)
      end
    end
    
    local f=CreateFrame("frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    f:SetScript("onupdate", func_dynamicParticleDensity)
    ns.dynamicParticleDensity = f
  end
end
