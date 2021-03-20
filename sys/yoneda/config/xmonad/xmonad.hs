-- inspiration https://github.com/bbugyi200/dotfiles

import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.NamedWindows (getName, unName)
import XMonad.Util.Loggers
import Data.List
import XMonad.Actions.Submap
import XMonad.Actions.WindowGo
import XMonad.Actions.TagWindows
import XMonad.Actions.WindowBringer
import XMonad.Actions.GroupNavigation
import XMonad.Actions.CycleRecentWS
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows
import XMonad.Actions.UpdatePointer
import XMonad.Util.NamedScratchpad
import XMonad.Operations
import XMonad.Layout.Tabbed
import Control.Monad (liftM, sequence)
import XMonad.Hooks.ManageHelpers
import Text.Read
import XMonad.Layout.WorkspaceDir
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName -- for jetbrains stuff to work

main = do
  d <- spawnPipe myDzenArgs
  xmonad $ withUrgencyHook NoUrgencyHook $ desktopConfig
    { manageHook  = myManageHook
    , modMask     = myModMask -- set modifier key
    , layoutHook  = myLayoutHook
    , terminal    = myTerminal
    , logHook     = myLogHook d
    , borderWidth = myBorderWidth
    , startupHook = myStartupHook
    } `additionalKeysP` myKeys -- defines custom keymaps

-- `myStartupHook` specifies actions to run at the start of the X session
myStartupHook :: X ()
myStartupHook = do
  spawnHere "~/.xmonad/autostart.sh"
  setWMName "LG3D" -- spoof window manager name in order to make jetbrains stuff work

myLayoutHook =
  id
--  $ workspaceDir "~"
  $ avoidStruts
  $ smartBorders
  $ layoutHook desktopConfig

myModMask = mod4Mask -- use window key as modifier

myManageHook = composeAll
  [ manageDocks
  , manageHook def
  , namedScratchpadManageHook myScratchPads
  , manageSpawn
  -- , className =? "qutebrowser-editor"  --> doFloat
  -- , appName=? "qute-editor" --> doRectFloat (W.RationalRect l t w h)
  ]
      -- where
      --   h = 2/6
      --   w = 2/6
      --   t = 3/6
      --   l = (1-w)/2

myLogHook h  = do
    historyHook                     -- for window history navigation
    updatePointer (0.5, 0.5) (0, 0) -- center pointer when focusing new window
    dynamicLogWithPP $ def

    -------------------
    -- dzen settings --
    -------------------
        { ppCurrent         = dzenColor "black" "light gray" . pad           -- current ws color
        , ppHidden          = dzenColor "light gray" "" . pad . noScratchPad -- nonempty ws color
        , ppHiddenNoWindows = dzenColor "dim gray" "" . pad . noScratchPad   -- empty ws color
        , ppLayout          = dzenColor "dim gray" "" . pad                  -- layout indicator color
        -- , ppUrgent       = dzenColor "yellow" "" . pad . dzenStrip        -- urgent ws color
        , ppUrgent          = dzenColor "black" "red" . pad . dzenStrip      -- urgent ws color
        , ppTitle           = shorten 50                                     -- shorten window titles
        , ppWsSep           = ""                                             -- workspace separator
        , ppSep             = "  "                                           -- object separator
        , ppOutput          = hPutStrLn h                                    -- output to argument
        , ppExtras          = [logTitles (dzenColor "#ee3366" "")]
        , ppOrder           = \(ws:l:t:e) -> [ws, l] ++ e
        }
        where
          noScratchPad ws = if ws =="NSP" then "" else ws

-- `myKeys` is a list of keymaps.
-- See the `EZConfig` module regarding the format used to specify keymaps.
myKeys :: [(String, X ())]
myKeys =
  [
  --------------------------
  -- workspace navigation --
  --------------------------
    ("M-n"   , moveTo Next EmptyWS) -- focus next empty workspace
  , ("M-S-l" , nextWS)              -- focus next workspace
  , ("M-S-h" , prevWS)              -- focus prev workspace

  -------------------------
  -- window manipulation --
  -------------------------
  , ("M-d" , kill)                                   -- delete window
  , ("M-y" , windowYank)                             -- yank window
  , ("M-p" , windowPut)                              -- put all tagged windows
  , ("M-u"   , nextMatch History (return True))      -- go to prev win
  , ("M-/"   , gotoMenuConfig myWindowBringerConfig) -- go to win by title
  , ("M-S-n" , shiftTo Next EmptyWS)                 -- send window to next nonempty ws

  -- the block below implements window tagging in the style of vim marks
  -- currently the only characters that can be used as marks are a, b, m, and n
  , ("M-m", submap . M.fromList $
      [ ((0, xK_m),     windowMark "m")
      , ((0, xK_n),     windowMark "n")
      , ((0, xK_a),     windowMark "a")
      , ((0, xK_b),     windowMark "b")
      ])
  , ("M-'", submap . M.fromList $
      [ ((0, xK_m),     windowJump "m")
      , ((0, xK_n),     windowJump "n")
      , ((0, xK_a),     windowJump "a")
      , ((0, xK_b),     windowJump "b")
      ])

  --------------------
  -- screen control --
  --------------------
  -- NOTE if `light` fails for permission reasons, see note at the end of this file
  , ("M-<XF86MonBrightnessUp>"   , spawnHere "light -A 10")                               -- brighten
  , ("M-<XF86MonBrightnessDown>" , spawnHere "light -U 10")                               -- dim
  , ("M-<F1>"                    , spawnHere "redshift -x; redshift -O 3000 ")            -- set screen temperature to red
  , ("M-<F2>"                    , spawnHere "redshift -x; sleep 0.1; redshift -O 5000 ") -- set screen temperature to orange
  , ("M-<F3>"                    , spawnHere "redshift -x")                               -- set screen temperature to default

  -- the block below allows one to set screen brightness to a specific value using the number row
  , ("M-`", submap . M.fromList $
      [ ((0, 0x60) , spawnHere "light -S 1")
      , ((0, 0x31) , spawnHere "light -S 10")
      , ((0, 0x32) , spawnHere "light -S 20")
      , ((0, 0x33) , spawnHere "light -S 30")
      , ((0, 0x34) , spawnHere "light -S 40")
      , ((0, 0x35) , spawnHere "light -S 50")
      , ((0, 0x36) , spawnHere "light -S 60")
      , ((0, 0x37) , spawnHere "light -S 70")
      , ((0, 0x38) , spawnHere "light -S 80")
      , ((0, 0x39) , spawnHere "light -S 90")
      , ((0, 0x30) , spawnHere "light -S 100")
      ])
  , ("M-<XF86Favorites>" , spawnHere "light -S 100 -s	sysfs/leds/tpacpi::power") -- turn keyboard backlight on

  ---------------------
  -- color switching --
  ---------------------
  -- NOTE needs testing
  , ("M-<F5>" , sequence_ [ spawnHere  (".dynamic-colors/bin/dynamic-colors switch default-dark > /dev/pts/" ++ (show i)) | i <- [0..9]])    -- dark terminal
  , ("M-<F6>" , sequence_ [ spawnHere  (".dynamic-colors/bin/dynamic-colors switch solarized-light > /dev/pts/" ++ (show i)) | i <- [0..9]]) -- light terminal
  , ("M-<F7>" , spawnHere "xcalib -invert -alter" ) -- invert screen color

  --------------------
  -- audio settings --
  --------------------
  , ("<XF86AudioLowerVolume>" , spawnHere "amixer set Master 2-")              -- volume down
  , ("<XF86AudioRaiseVolume>" , spawnHere "amixer set Master 2+")              -- volume up
  , ("<XF86AudioMute        " , spawnHere "amixer -D pulse set Master toggle") -- toggle mute

  --------------------
  -- misc utilities --
  --------------------
  , ("M-S-<Print>" , spawnHere "sleep 0.5; scrot -s -e 'mv $f ~/images/screenshots/'") -- screenshot region of screen
  , ("M-<Print>  " , spawnHere "sleep 0.5; scrot -e 'mv $f ~/images/screenshots/'")    -- capture entire screen
  , ("M-<F9>     " , spawnHere "setxkbmap us -variant colemak")                        -- set keyboard layout to colemak
  , ("M-<F10>    " , spawnHere "setxkbmap us")                                         -- set keyboard layoyut to qwerty
  , ("M-i"         , spawnHere myLauncher)                                             -- run app by name via rofi
  , ("M-s"         , scratchTerm)                                                      -- scratchpad
  , ("M-q" , spawn "xmonad --recompile; kill -9 $(pgrep dzen); xmonad --restart")      -- restart xmonad

  ----------------------
  -- temporary things --
  ----------------------
  -- , ("M-f", withFocused $ windows . W.sink) -- toggle float -- NOTE needs testing to determine exact behavior
  ]
  ++ myAppKeys
  where
    windowPut       = sequence_ [withTaggedGlobalP "yanked" shiftHere, withTaggedGlobal "yanked" (delTag "yanked")]
    windowYank      = withFocused (addTag "yanked")
    windowMark mark = sequence_ [withTaggedGlobal mark (delTag mark), withFocused (addTag mark)]
    windowJump mark = focusUpTaggedGlobal mark
    scratchTerm     = namedScratchpadAction myScratchPads "terminal"

myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm]
  where
    spawnTerm  = myTerminal ++ " -name scratchpad"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
      where
        h = 2/6
        w = 2/6
        t = 3/6
        l = (1-w)/2

myTerminal = "urxvt"

myWindowBringerConfig :: WindowBringerConfig
myWindowBringerConfig = def
  { menuCommand = "rofi"
  , menuArgs = ["-dmenu", "-i"]
  }

myLauncher              = ("rofi -show run " ++ myLauncherArgs )
myLauncherArgs = "" -- rofi config delegated to home.nix

myDzenArgs = "dzen2 -dock -p -xs 1 -ta l -e 'onstart=lower' -fn terminus:bold:pixelsize=12"

myBorderWidth = 2

-- logTitles is used to show window titles in dzen2 -- NOTE rarely if ever used
logTitles :: (String -> String) -> Logger
logTitles ppFocus =
        let
            windowTitles windowset = sequence (map (fmap showName . getName) (W.index windowset))
                where
                    fw = W.peek windowset
                    showName nw =
                        let
                            window = unName nw
                            name = shorten 50 (show nw)
                        in
                            if maybe False (== window) fw
                                then
                                    ppFocus name
                                else
                                    name
        in
            withWindowSet $ liftM (Just . (intercalate "  |  ")) . windowTitles


----------------------------------
-- Application launch and focus --
----------------------------------

-- The `App` type wraps the data needed to control an application
data App = App
     { keyApp :: String      -- a hotkey used to run or raise the app
     , findApp :: Query Bool -- how to raise the app
     , runApp :: X ()        -- how to run the app
     }

-- The `makeKeys` function turns an `App` value into a concrete xmonad keymap
makeKeys :: App -> [(String, X ())]
makeKeys (App k f r) =
  [ ("M-" ++ k, nextMatchOrDo Backward f r)
  , ("M-S-" ++ k, r)
  ]

-- The list `myApps` contains applications which can be ran or raised
myApps :: [App]
myApps =
  -- appname    -- hotkey
  [ firefox     -- f
  , zathura     -- a
  , urxvt       -- t
  , ranger      -- r
  , qutebrowser -- o
  , emacs       -- e
  , chromium    -- c
  ]

-- `myAppKeys` is a list of concrete keymaps constructed from `myApps`
myAppKeys = concat $ map makeKeys myApps

-- The block below defines applications of interest
firefox = App
  { keyApp =               "f"
  , findApp = className =? "Firefox"
  , runApp =  spawnHere    "firefox" -- optionally add `-private-window`
  }
zathura = App
  { keyApp  =              "a"
  , findApp = className =? "Zathura"
  , runApp  =  spawnHere   "zathura"
  }
vscode      = App
  { keyApp  =              "v"
  , findApp = className =? "Code"
  , runApp  =  spawnHere   "code"
  }
emacs       = App
  { keyApp  =              "e"
  , findApp = className =? "Emacs"
  , runApp  =  spawnHere   "emacsclient -c"
  }
urxvt       = App
  { keyApp  =              "t"
  , findApp = className =? "URxvt"
  , runApp  =  spawnHere   "urxvt"
  }
ranger      = App
  { keyApp  =              "r"
  , findApp = title =?     "ranger"
  , runApp  =  runInTerm   "-title ranger" "ranger"
  }
qutebrowser = App
  { keyApp  =              "o"
  , findApp = className =? "qutebrowser"
  , runApp  =  spawnHere   "qutebrowser"
  }
chromium    = App
  { keyApp  =              "c"
  , findApp = className =? "Chromium-browser"
  , runApp  =  spawnHere   "chromium-browser"
  }

-----------
-- notes --
-----------

-- NOTE from documentation at https://wiki.haskell.org/Xmonad/Frequently_asked_questions#I_need_to_find_the_class_title_or_some_other_X_property_of_my_program section 3.16
-- resource (also known as appName) is the first element in WM_CLASS(STRING)
-- className is the second element in WM_CLASS(STRING)
-- title is WM_NAME(STRING)

-- NOTE if `light` fails for permission reasons, run `chgrp video /sys/class/backlight/.../brightness; chmod g+w ...`
-- do `cat .nix-profile/lib/udev/rules.d/90-backlight.rules` first
-- and make sure user is part of "video" group
