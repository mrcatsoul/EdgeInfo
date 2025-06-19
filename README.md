WoW 3.3.5 addon.

No settings UI yet, but some values can be adjusted via constants in the .lua file.

Displays the following:

1) Time left until resurrection by-corpse
2) If RezTimer is enabled: spirit healer resurrection timer at BG + estimated number of enemies about to resurrection
3) Day of the week, date, and exact time with milliseconds
4) Your current zone
5) Dungeon difficulty
6) PvP flag + PvP flag time remaining (shown if under 5 minutes)
7) FPS
8) Particle density from graphics settings (shown as a status bar)
9) Latency (same as shown in the game menu tooltip, updates ~every 30 sec)
10) RTT (Round-trip time) — a more accurate ping using addon messages (https://wowwiki-archive.fandom.com/wiki/API_SendAddonMessage), updates rapidly; good for spotting real connection issues)
11) Server info latency (spam-pings (.server info) every 2 sec; may show system error in chat when using .menu)
12) BG stats: total games, wins, winrate (based on achievement stats)
13) Main stats: Attack power/Spell damage, Resilience, Crit, Haste, Hit
14) Movement speed

![image](https://github.com/user-attachments/assets/228da761-fca2-4978-8aaf-8b98f383608b)

![image](https://github.com/user-attachments/assets/566b9901-b0ba-45fa-ab93-59d31c470bd2)

--------------------------------

WoW 3.3.5 аддон. Пока что без опций-настроек, но некоторые значения можно покрутить через константы в lua-файле.

Показывает:

1) время до реса по телу
2) если включен RezTimer: время до реса у духа на бг + потенциальное кол-во ресающихся врагов
3) день недели, дату, точное время с милисекундами
4) зону местонахождения
5) сложность подземелья
6) пвп флаг + оставшееся время пвп флага (когда меньше 5 минут)
7) фпс
8) плотность частиц из настроек графики (статус бар - это они)
9) задержка (та что видна через подсказку по кнопке игрового меню и обновляется раз в ~30 сек)
10) RTT (https://ru.wikipedia.org/wiki/Круговая_задержка) - более реальное значение задержки/пинга через отправку самому себе сообщений аддона (https://wowwiki-archive.fandom.com/wiki/API_SendAddonMessage), в отличии от обычной задержки "из кнопки меню" - через эту цифру сразу будет видно если лагает интернет/есть проблемы с соединением, обновляется максимально быстро ⚠️ 
11) задержка через сервер инфо (невидимо спамится каждые 2 сек, из-за спама может выскакивать системная ошибка в чат когда вызываем .menu, а-ля "Команда не может быть обработана в текущий момент")
12) кол-во игр на бг, победы, винрейт (из данных статистики ачив)
13) характеристики: ап/спд, рес, крит, хаст, хит
14) скорость передвижения
