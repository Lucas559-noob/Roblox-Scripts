script_author('RoflHaHaWF')
script_name('Hp And Armour HUD')

local inicfg = require 'inicfg'
local imgui = require 'mimgui'
local ffi = require 'ffi'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof



local ini = inicfg.load({
    main = {
        hpbar = true,
        armbar = true,
        hpcolor = '990000',
        armcolor = '999999',
        hsize = 9,
        asize = 9,
        hpx = 1200,
        hpy = 590,
        apx = 960,
        apy = 540,
        hpfont = "Courrier New",
        armfont = "Courrier New"
    }
},'hparm.ini')


inicfg.save(ini, "hparm.ini")

function save()
    inicfg.save(ini, 'hparm.ini')
end

--залупа--
local hcpos, acpos = false, false
local hpbar, armbar = ini.main.hpbar, ini.main.armbar
local hpx, hpy, apx, apy = ini.main.hpx, ini.main.hpy, ini.main.apx, ini.main.apy
local hpfont, armfont = ini.main.hpfont, ini.main.armfont
local hpsize, armsize = ini.main.hsize, ini.main.asize
local hpcolor, armcolor = ini.main.hpcolor, ini.main.armcolor
local hps, arms = new.char[256](''), new.char[256]('')
local hpf, armf = new.char[256](''), new.char[256]('')
local hpc, armc = new.char[256](''), new.char[256]('')
--залупа--

local main_window_state = new.bool(false)
local sx, sy = getScreenResolution()
local bsize = 75, 20
local smenasize = 120, 20

imgui.OnInitialize(function() imgui.IniFilename = nil WhiteTheme() end)

--менюшка--
local mainframe = imgui.OnFrame(
    function() return main_window_state[0] end, function(main)
        if isKeyJustPressed(0x02) then
            main.HideCursor = not main.HideCursor
        end
        if main_window_state[0] then
            imgui.SetNextWindowPos(imgui.ImVec2(sx / 2, sy / 2), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowSize(imgui.ImVec2(311, 232), imgui.Cond.FirstUseEver)
            imgui.Begin('Hp/Armour HUD by RoflHaHaWF', main_window_state)
            imgui.CenterText(u8'Настройки хп-худа')
            imgui.Separator()
            if imgui.Button(u8'Статус##hpbar', imgui.ImVec2(bsize)) then
                hpbar = not hpbar
                ini.main.hpbar = hpbar
                save()
                msg(hpbar and 'Теперь хп-худ по умолчанию включен' or 'Теперь хп-худ по умолчанию выключен')
            end
            imgui.SameLine()
            if imgui.Button(u8'Смена позиции##hppos', imgui.ImVec2(smenasize)) then
                hcpos = true
                msg(hcpos and 'Смена позиции хп-худа включена, нажмите ЛКМ - чтобы сохранить позицию, ПКМ - чтобы отменить смену позиции' or 'Смена позиции хп-худа выключена')
            end
            imgui.Text(u8'Введите цвет хп-худа')
            imgui.InputText('##hpinputcolor', hpc, sizeof(hpc))
            imgui.SameLine()
            if imgui.Button(u8'Сохранить##hpcolor', imgui.ImVec2(bsize)) then
                local a = u8:decode(str(hpc))
                if a ~= '' then
                    ini.main.hpcolor = a
                    save()
                    msg('Новый цвет хп-худа - '..'['..a..']')
                else
                    msg('Введите цвет')
                end
            end
            imgui.Text(u8'Введите шрифт хп-худа')
            imgui.InputText('##hpinputfont', hpf, sizeof(hpf))
            imgui.SameLine()
            if imgui.Button(u8'Сохранить##hpfont', imgui.ImVec2(bsize)) then
                local a = u8:decode(str(hpf))
                if a ~= '' then
                    ini.main.hpfont = a
                    save()
                    msg('Новый шрифт хп-худа - '..a)
                    thisScript():reload()
                else
                    msg('Введите шрифт')
                end
            end
            imgui.Text(u8'Введите размер шрифта хп-худа')
            imgui.InputText('##hpinputsize', hps, sizeof(hps))
            imgui.SameLine()
            if imgui.Button(u8'Сохранить##hp', imgui.ImVec2(bsize)) then
                local a = u8:decode(str(hps))
                if tonumber(a) then
                    ini.main.hsize = math.ceil(tonumber(a))
                    save()
                    msg('Новый размер шрифта хп-худа - '..math.ceil(a))
                    thisScript():reload()
                else
                    msg('Введите число')
                end
            end
            imgui.Separator()
            imgui.CenterText(u8'Настройки армор-худа')
            imgui.Separator()
            if imgui.Button(u8'Статус##armbar', imgui.ImVec2(bsize)) then
                armbar = not armbar
                ini.main.armbar = armbar
                save()
                msg(armbar and 'Теперь армор-худ по умолчанию включен' or 'Теперь армор-худ по умолчанию выключен')
            end
            imgui.SameLine()
            if imgui.Button(u8'Смена позиции##armpos', imgui.ImVec2(smenasize)) then
                acpos = not acpos
                msg(acpos and 'Смена позиции армор-худа включена, нажмите ЛКМ - чтобы сохранить позицию, ПКМ - чтобы отменить смену позиции' or 'Смена позиции армор-худа выключена')
            end
            imgui.Text(u8'Введите цвет армор-худа')
            imgui.InputText('##arminputcolor', armc, sizeof(armc))
            imgui.SameLine()
            if imgui.Button(u8'Сохранить##armcolor', imgui.ImVec2(bsize)) then
                local a = u8:decode(str(armc))
                if a ~= '' then
                    ini.main.armcolor = a
                    save()
                    msg('Новый цвет армор-худа - '..'['..a..']')
                else
                    msg('Введите цвет')
                end
            end
            imgui.Text(u8'Введите шрифт армор-худа')
            imgui.InputText('##arminputfont', armf, sizeof(armf))
            imgui.SameLine()
            if imgui.Button(u8'Сохранить##armfont', imgui.ImVec2(bsize)) then
                local a = u8:decode(str(armf))
                if a ~= '' then
                    ini.main.armfont = a
                    save()
                    msg('Новый шрифт армор-худа - '..a)
                    thisScript():reload()
                else
                    msg('Введите шрифт')
                end
            end
            imgui.Text(u8'Введите размер шрифта армор-худа')
            imgui.InputText('##arminput', arms, sizeof(arms))
            imgui.SameLine()
            if imgui.Button(u8'Сохранить##arm', imgui.ImVec2(bsize)) then
                if tonumber(u8:decode(str(arms))) then
                    ini.main.asize = tonumber(u8:decode(str(arms)))
                    save()
                    msg('Новый размер шрифта армор-худа - '..u8:decode(str(arms)))
                    thisScript():reload()
                else
                    msg('Введите число')
                end
            end
            imgui.End()
        end
    end
)
--менюшка--

--шрифты
local rhpfont = renderCreateFont(ini.main.hpfont, ini.main.hsize, 4)
local rarmfont = renderCreateFont(ini.main.armfont, ini.main.asize, 4)
--шрифты--

function main()
    while not isSampAvailable() do wait(0) end
    sampRegisterChatCommand('rhud', function()
        main_window_state[0] = not main_window_state[0]
    end)
    while true do
        wait(0)
        if not hcpos then
            if hpbar then
                local hp = sampGetPlayerHealth(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                renderFontDrawText(rhpfont, '{'..ini.main.hpcolor..'}'..math.floor(hp), ini.main.hpx, ini.main.hpy, 0xFFFFFFFF, 0x90000000)
            end
        else
            main_window_state[0] = false
            local mx, my = getCursorPos()
            local hp = sampGetPlayerHealth(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
            renderFontDrawText(rhpfont, '{'..ini.main.hpcolor..'}'..math.floor(hp), mx, my, 0xFFFFFFFF, 0x90000000)
            if isKeyJustPressed(0x01) then
                hcpos = false
                ini.main.hpx = mx
                ini.main.hpy = my
                save()
                msg('Новая позиция хп-худа: x - '..tostring(mx)..', y - '..tostring(my))
            elseif isKeyJustPressed(0x02) then
                hcpos = false
                if hpbar then hpbar = true end
                msg('Вы отменили смену позиции хп-худа.')
            end
        end
        if not acpos then
            if armbar then
                local arm = sampGetPlayerArmor(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                renderFontDrawText(rarmfont, '{'..ini.main.armcolor..'}'..math.floor(arm), ini.main.apx, ini.main.apy, 0xFFFFFFFF, 0x90000000)
            end
        else
            main_window_state[0] = false
            local mx, my = getCursorPos()
            local arm = sampGetPlayerArmor(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
            renderFontDrawText(rarmfont, '{'..ini.main.armcolor..'}'..math.floor(arm), mx, my, 0xFFFFFFFF, 0x90000000)
            if isKeyJustPressed(0x01) then
                acpos = false
                ini.main.apx = mx
                ini.main.apy = my
                save()
                msg('Новая позиция армор-худа: x - '..tostring(mx)..', y - '..tostring(my))
            elseif isKeyJustPressed(0x02) then
                acpos = false
                msg('Вы отменили смену позиции армор-худа.')
            end
        end
    end
end

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end

function msg(msg)
    sampAddChatMessage('{FFFFFF}[{5BC2D5}HPARM{FFFFFF}]: '..msg, -1)
end

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end

--тема--
function WhiteTheme() --https://www.blast.hk/threads/25442/post-973165 + сам отредачил под белый цвет
    imgui.SwitchContext()

    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1

    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)

    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(1.00, 1.00, 1.00, 0.80)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.85, 0.85, 0.85, 0.94)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.77, 0.77, 0.97, 0.50)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.00, 0.00, 0.00, 0.14)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.78, 0.78, 0.78, 0.40)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.68, 0.68, 0.68, 0.67)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.84, 0.84, 0.84, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.66, 0.66, 0.66, 0.67)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.96, 0.96, 0.96, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.55, 0.55, 0.55, 0.53)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.46, 0.46, 0.46, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.10, 0.10, 0.10, 0.79)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.46, 0.46, 0.46, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.09, 0.42, 0.83, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.44, 0.44, 0.44, 0.88)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.31, 0.34, 0.37, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.00, 0.00, 0.00, 0.07)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(1.00, 1.00, 1.00, 0.94)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.54, 0.54, 0.54, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.04, 0.06, 0.09, 0.31)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.45, 0.49, 0.53, 0.80)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.50, 0.50, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.40, 0.40, 0.44, 0.50)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.00, 0.00, 0.00, 0.21)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.37, 0.37, 0.38, 0.80)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.82, 0.82, 0.82, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.19, 0.21, 0.23, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.29, 0.30, 0.31, 1.00)
end
--тема--