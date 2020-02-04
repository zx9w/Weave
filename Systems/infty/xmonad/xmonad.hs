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
    { manageHook = myManageHook
    , modMask = myModMask -- set modifier key
    , layoutHook = myLayoutHook
    , terminal = myTerminal
    , logHook = myLogHook d
    , borderWidth = myBorderWidth
    , startupHook = myStartupHook
    } `additionalKeysP` myKeys

myStartupHook :: X ()
myStartupHook = do
  spawnHere "~/.xmonad/autostart.sh"
  setWMName "LG3D" -- spoof WM name to make jetbrains stuff work


myLayoutHook =
  id
  $ workspaceDir "~"
  $ avoidStruts
  $ smartBorders
  $ layoutHook desktopConfig

myModMask = mod4Mask -- set window key as modifier

myManageHook = composeAll
  [ manageDocks
  , manageHook def
  , namedScratchpadManageHook myScratchPads
  , manageSpawn
  -- , className =? "qutebrowser-editor"  --> doFloat
  , appName=? "qute-editor" --> doRectFloat (W.RationalRect l t w h)
  ]
      where
        h = 2/6
        w = 2/6
        t = 3/6
        l = (1-w)/2

myLogHook h  = do
    historyHook -- used for window history navigation
    updatePointer (0.5, 0.5) (0, 0) -- center pointer when focusing new window
    dynamicLogWithPP $ def
    -- dzen settings
        { ppCurrent         = dzenColor "black" "light gray" . pad -- current ws color
        , ppHidden          = dzenColor "light gray" "" . pad . noScratchPad -- nonempty ws color
        , ppHiddenNoWindows = dzenColor "dim gray" "" . pad . noScratchPad -- empty ws color
        , ppLayout          = dzenColor "dim gray" "" . pad -- layout indicator color
        -- , ppUrgent          = dzenColor "yellow" "" . pad . dzenStrip -- urgent ws color
        , ppUrgent          = dzenColor "black" "red" . pad . dzenStrip -- urgent ws color
        , ppTitle           = shorten 50 -- shorten window titles
        , ppWsSep           = "" -- workspace separator
        , ppSep             = "  " -- object separator
        , ppOutput          = hPutStrLn h -- output to argument
        , ppExtras = [logTitles (dzenColor "#ee3366" "")]
        , ppOrder = \(ws:l:t:e) -> [ws, l] ++ e
        }
        where
          noScratchPad ws = if ws =="NSP" then "" else ws

myKeys :: [(String, X ())]
myKeys =
  [
    -- ("M-q", spawn "xmonad --recompile; killall conky dzen2 compton mpd thunar synapse hhp; xmonad --restart") -- restarts xmonad
    ("M-q", spawn "xmonad --recompile; kill -9 $(pgrep dzen); xmonad --restart") -- restarts xmonad

  --------------------------
  -- workspace navigation --
  --------------------------
  , ("M-<Tab>", moveTo Next NonEmptyWS) -- go to next nonempty ws
  , ("M-S-<Tab>" , moveTo Prev NonEmptyWS) -- go to prev nonempty ws
  , ("M-n", moveTo Next EmptyWS)  -- goto next empty ws
  , ("M-S-l", nextWS)  -- goto next ws
  , ("M-S-h", prevWS)  -- goto prev ws

  -------------------------
  -- window manipulation --
  -------------------------
  , ("M-d", kill) -- kill win
  , ("M-y", windowYank) -- tag win for yanking
  , ("M-p", windowPut) -- put win tagged for yanking
  -- , ("M-u", cycleRecentWindows [xK_Super_L] xK_Tab xK_Tab) -- go to prev win
  , ("M-u", nextMatch History (return True)) -- go to prev win
  , ("M-/", gotoMenuConfig myWindowBringerConfig) -- go to win by title
  , ("M-S-n", shiftTo Next EmptyWS) -- send window to next nonempty ws
  -- window tagging
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
  -- TODO remember to delete the tags!
  -- specifically, you need to enforce that no tag be assigned to multiple windows

  ------------------
  -- applications --
  ------------------
  , ("M-i", spawnHere myLauncher) -- run app by name via rofi
  , ("M-s", scratchTerm) --scratchpad

  ---------------------
  -- screen settings --
  ---------------------
  , ("M-<XF86MonBrightnessUp>", spawnHere "light -A 10") -- brighten
  , ("M-<XF86MonBrightnessDown>", spawnHere "light -U 10") -- dim
    -- if `light` fails for permission reasons, `chgrp video /sys/class/backlight/.../brightness; chmod g+w ...`
    -- do `cat .nix-profile/lib/udev/rules.d/90-backlight.rules` first
    -- and make user user is part of "video" group
  , ("M-<F1>", spawnHere "redshift -x; redshift -O 3000 ") -- set screen temperature to red
  , ("M-<F2>", spawnHere "redshift -x; sleep 0.1; redshift -O 5000 ") -- set screen temperature to orange
  , ("M-<F3>", spawnHere "redshift -x") -- set screen temperature to default
  , ("M-`", submap . M.fromList $
      [ ((0, 0x60), spawnHere "light -S 1")
      , ((0, 0x31), spawnHere "light -S 10")
      , ((0, 0x32), spawnHere "light -S 20")
      , ((0, 0x33), spawnHere "light -S 30")
      , ((0, 0x34), spawnHere "light -S 40")
      , ((0, 0x35), spawnHere "light -S 50")
      , ((0, 0x36), spawnHere "light -S 60")
      , ((0, 0x37), spawnHere "light -S 70")
      , ((0, 0x38), spawnHere "light -S 80")
      , ((0, 0x39), spawnHere "light -S 90")
      , ((0, 0x30), spawnHere "light -S 100")
      ])

  ---------------------
  -- color switching --
  ---------------------
  , ("M-<F5>", sequence_ [ spawnHere  (".dynamic-colors/bin/dynamic-colors switch default-dark > /dev/pts/" ++ (show i)) | i <- [0..9]]) -- dark terminal
  , ("M-<F6>", sequence_ [ spawnHere  (".dynamic-colors/bin/dynamic-colors switch solarized-light > /dev/pts/" ++ (show i)) | i <- [0..9]]) -- light terminal
  , ("M-<F7>", spawnHere "xcalib -invert -alter" ) -- invert screen color


  --------------------
  -- audio settings --
  --------------------
  , ("<XF86AudioLowerVolume>", spawnHere "amixer set Master 2-") -- volume down
  , ("<XF86AudioRaiseVolume>", spawnHere "amixer set Master 2+") -- volume up
  , ("<XF86AudioMute", spawnHere "amixer -D pulse set Master toggle") -- toggle mute

  --------------------
  -- misc utilities --
  --------------------
  , ("M-S-<Print>", spawnHere "sleep 0.5; scrot -s -e 'mv $f ~/img/screenshots/'") -- capture region of screen
  , ("M-<Print>", spawnHere "sleep 0.5; scrot -e 'mv $f ~/img/screenshots/'") -- capture entire screen
  , ("M-<F9>", spawnHere "setxkbmap us -variant colemak")
  , ("M-<F10>", spawnHere "setxkbmap us")

  ----------------------
  -- temporary things --
  ----------------------
  -- , ("M-x", increaseTemp)
  -- , ("M-z", decreaseTemp)
  -- , ("M-x", changeDir def)
  -- , ("M-x", increaseNMasterGroups)
  -- , ("M-S-x", decreaseNMasterGroups)
  -- , ("M-z", expandMasterGroups)
  -- , ("M-S-z", shrinkMasterGroups)
  -- , ("M-x", splitGroup)
  -- , ("M-<Up>", moveToNewGroupUp)
  -- , ("M-<Down>", moveToNewGroupDown)
  -- , ("M-<Left>", decreaseNMasterGroups)
  -- , ("M-<Right>", increaseNMasterGroups)
  -- , ("M-v", showClipboard) -- show clipboard
  -- , ("M-z",  spawnHere "rofi-pass" ) -- run rofi-pass
  -- , ("M-f", withFocused $ windows . W.sink) -- toggle float
  ]
  ++ myAppKeys
  where
    windowPut = sequence_ [withTaggedGlobalP "yanked" shiftHere, withTaggedGlobal "yanked" (delTag "yanked")]
    windowYank = withFocused (addTag "yanked")
    windowMark mark = sequence_ [withTaggedGlobal mark (delTag mark), withFocused (addTag mark)]
    windowJump mark = focusUpTaggedGlobal mark
    scratchTerm = namedScratchpadAction myScratchPads "terminal"
    summon = nextMatchOrDo Backward

myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm]
  where
    spawnTerm = myTerminal ++ " -name scratchpad"
    findTerm = resource =? "scratchpad"
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
myLauncherArgs = ""
-- myLauncherArgs          = intercalate " " ["-kb-accept-entry \"\"", "-kb-row-down \"Control+j\"", "-kb-remove-to-eol \"\"", "-kb-row-up \"Control+k\""] -- rofi
-- for rofi config check out https://github.com/DaveDavenport/rofi/issues/640 and https://blog.wizardsoftheweb.pro/rofi-basic-configuration/

myMailClient = "emacsclient"
  ++ " -s emacs-mail "
  ++ " -e \"(progn (load-theme \'spacemacs-light) (notmuch))\""
  ++ " --create-frame --frame-parameters='(quote (name . \""
  ++ myMailClientName
  ++ "\"))'"
  ++ " --display $DISPLAY"
myMailClientName = "mail-client"

-- myDzenArgs = "dzen2 -dock -p -xs 1 -ta l -e 'onstart=lower' -fn dejavusansmono:pixelsize=12"
myDzenArgs = "dzen2 -dock -p -xs 1 -ta l -e 'onstart=lower' -fn terminus:bold:pixelsize=12"

myBorderWidth = 2

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

data App = App
     { keyApp :: String -- a hotkey used to run or raise the app
     , findApp :: Query Bool -- how to raise the app
     , runApp :: X () -- how to run the app
     }

myApps =
  [ firefox -- f
  , zathura -- a
  , vscode
  , urxvt -- t
  , ranger -- r
  , qutebrowser -- o
  , emacs -- e
  , chromium -- c
  , pycharm -- w
  , zeal -- z
  ]

myAppKeys = concat $ map makeKeys myApps

zeal = App
  { keyApp = "z"
  , findApp = className =? "Zeal"
  , runApp =  spawnHere "zeal"
  }

pycharm = App
  { keyApp = "w"
  , findApp = className =? "jetbrains-pycharm-ce"
  , runApp =  spawnHere "pycharm-community"
  }

firefox = App
  { keyApp = "f"
  , findApp = className =? "Firefox"
-- , runApp =  spawnHere "firefox -private-window"
  , runApp =  spawnHere "firefox"
  }

zathura = App
  { keyApp = "a"
  , findApp = className =? "Zathura"
  , runApp =  spawnHere "zathura"
  }

vscode = App
  { keyApp = "v"
  , findApp = className =? "Code"
  , runApp =  spawnHere "code"
  }

emacs = App
  { keyApp = "e"
  , findApp = className =? "Emacs"
  , runApp =  spawnHere "emacsclient -c"
  }

urxvt = App
  { keyApp = "t"
  , findApp = className =? "URxvt"
  , runApp =  spawnHere "urxvt"
  }

ranger = App
  { keyApp = "r"
  , findApp = title =? "ranger"
  , runApp =  runInTerm  "-title ranger" "ranger"
  }

qutebrowser = App
  { keyApp = "o"
  , findApp = className =? "qutebrowser"
  , runApp =  spawnHere "qutebrowser"
  }

chromium = App
  { keyApp = "c"
  , findApp = className =? "Chromium-browser"
  , runApp =  spawnHere "chromium-browser"
  }

makeKeys :: App -> [(String, X ())]
makeKeys (App k f r) =
  [ ("M-" ++ k, nextMatchOrDo Backward f r)
  , ("M-S-" ++ k, r)
  ]


-----------
-- notes --
-----------

-- note from documentation at https://wiki.haskell.org/Xmonad/Frequently_asked_questions#I_need_to_find_the_class_title_or_some_other_X_property_of_my_program section 3.16
-- resource (also known as appName) is the first element in WM_CLASS(STRING)
-- className is the second element in WM_CLASS(STRING)
-- title is WM_NAME(STRING)
