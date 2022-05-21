Config = {
    NotificationDistance = 10.0,
    PropsToRemove = {
        vector3(1992.803, 3047.312, 46.22865),
        vector3(-36.301, 6391.44, 31.6047),
        vector3(550.147, -174.76, 50.6930),
        vector3(-574.17, 288.834, 79.1766),
        vector3(-71.93, -1809.61, 33.54),
        vector3(-541.4, -128.35, 43.16),
    },

    --[[
        -- To use custom notifications, implement client event handler, example:

        AddEventHandler('rcore_pool:notification', function(serverId, message)
            print(serverId, message)
        end)
    ]]
    CustomNotifications = true,

    --[[
        -- To use custom menu, implement following client handlers
        AddEventHandler('rcore_pool:openMenu', function()
            -- open menu with your system
        end)

        AddEventHandler('rcore_pool:closeMenu', function()
            -- close menu, player has walked far from table
        end)


        -- After selecting game type, trigger one of the following setupTable events
        TriggerEvent('rcore_pool:setupTable', 'BALL_SETUP_8_BALL')
        TriggerEvent('rcore_pool:setupTable', 'BALL_SETUP_STRAIGHT_POOL')
    ]]
    CustomMenu = false,

    --[[
        When you want your players to pay to play pool, set this to true
        AND implement the following server handler in your framework of choice.
        The handler MUST deduct money from the player and then CALL the callback
        if the payment is successful, or inform the player of payment failure.

        This script itself DOES NOT implement ESX/vRP logic, you have to do that yourself.

        AddEventHandler('rcore_pool:payForPool', function(playerServerId, cb)
            print("This should be replaced by deducting money from " .. playerServerId)
            cb() -- successfuly set balls on table
        end)
    ]]
    PayForSettingBalls = false,
    BallSetupCost = nil, -- for example: "$1" or "$200" - any text

    --[[
        You can integrate pool cue into your system with

        SERVERSIDE HANDLERS
            - rcore_pool:onReturnCue - called when player takes cue
            - rcore_pool:onTakeCue   - called when player returns cue

        CLIENTSIDE EVENTS
            - rcore_pool:takeCue   - forces player to take cue in hand
            - rcore_pool:removeCue - removes cue from player's hand

        This prevents players from taking cue from cue rack if `false`
    ]]
    AllowTakePoolCueFromStand = true,

    --[[
        This option is for servers whose anticheats prevents
        this script from setting players invisible.

        When player's ped is blocking camera when aiming,
        set this to true
    ]]
    DoNotRotateAroundTableWhenAiming = false,

    MenuColor = {245, 127, 23},
    Keys = {
        BACK = {code = 200, label = 'INPUT_FRONTEND_PAUSE_ALTERNATE'},
        ENTER = {code = 38, label = 'INPUT_PICKUP'},
        SETUP_MODIFIER = {code = 21, label = 'INPUT_SPRINT'},
        CUE_HIT = {code = 179, label = 'INPUT_CELLPHONE_EXTRA_OPTION'},
        CUE_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        CUE_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        AIM_SLOWER = {code = 21, label = 'INPUT_SPRINT'},
        BALL_IN_HAND = {code = 29, label = 'INPUT_SPECIAL_ABILITY_SECONDARY'},

        BALL_IN_HAND_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        BALL_IN_HAND_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        BALL_IN_HAND_UP = {code = 172, label = 'INPUT_CELLPHONE_UP'},
        BALL_IN_HAND_DOWN = {code = 173, label = 'INPUT_CELLPHONE_DOWN'},
    },
    Text = {
        BACK = "Wyjdź",
        HIT = "Uderz",
        BALL_IN_HAND = "Widok (góra)",
        BALL_IN_HAND_BACK = "Widok (tył)",
        AIM_LEFT = "Lewo",
        AIM_RIGHT = "Prawo",
        AIM_SLOWER = "Wolniej",

        POOL = 'Bilard',
        POOL_GAME = 'Gra w bilarda',
        POOL_SUBMENU = 'Tryb gry',
        TYPE_8_BALL = '8-Ball',
        TYPE_STRAIGHT = 'Prosty',

        HINT_SETUP = 'Zagraj',
        HINT_TAKE_CUE = 'Weź kij.',
        HINT_RETURN_CUE = 'Odłóż kij.',
        HINT_HINT_TAKE_CUE = 'Aby zagrać w bilard, musisz trzymać kij.',
        HINT_PLAY = 'Graj',

        BALL_IN_HAND_LEFT = 'Lewo',
        BALL_IN_HAND_RIGHT = 'Prawo',
        BALL_IN_HAND_UP = 'Wyżej',
        BALL_IN_HAND_DOWN = 'Niżej',
        BALL_POCKETED = '%s Trafia w dół',
        BALL_IN_HAND_NOTIFY = 'Masz kulę bilardową',
        BALL_LABELS = {
            [-1] = 'Biała',
            [1] = '~y~Pełna 1~s~',
            [2] = '~b~Pełna 2~s~',
            [3] = '~r~Pełna 3~s~',
            [4] = '~p~Pełna 4~s~',
            [5] = '~o~Pełna 5~s~',
            [6] = '~g~Pełna 6~s~',
            [7] = '~r~Pełna 7~s~',
            [8] = 'Czarna Pełna 8',
            [9] = '~y~Połówka 9~s~',
            [10] = '~b~Połówka 10~s~',
            [11] = '~r~Połówka 11~s~',
            [12] = '~p~Połówka 12~s~',
            [13] = '~o~Połówka 13~s~',
            [14] = '~g~Połówka 14~s~',
            [15] = '~r~Połówka 15~s~',
         }
    },
}