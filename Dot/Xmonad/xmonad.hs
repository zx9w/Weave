module Main (main) where

import System.Exit
import XMonad
import qualified XMonad.StackSet as W
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig


main = do
  xmonad $ desktopConfig
    { borderWidth        = 2
    , modMask            = mod4Mask -- windows key
    , terminal           = "kitty"
    , normalBorderColor  = "#cccccc"
    , focusedBorderColor = "#cd8b00"
    , manageHook         = myManageHook <+> manageHook desktopConfig
    , layoutHook         = desktopLayoutModifiers $ myLayouts
    , logHook            = dynamicLogString def >>= xmonadPropLog
    }
    `additionalKeysP`
      [ ("M-S-q", confirmPrompt myXPConfig "exit" (io exitSuccess))
      , ("M-p", shellPrompt myXPConfig)
      , ("M-<Esc>", sendMessage (Toggle "Full"))
      ]

myLayouts = toggleLayouts (noBorders Full) others
  where
    others = ResizableTall 1 (1.5/100) (3/5) [] ||| emptyBSP

myXPConfig = def
  { position          = Top
  , alwaysHighlight   = True
  , promptBorderWidth = 0
  , font              = "xft:monospace:size=9"
  }

myManageHook = composeAll . concat $
    [ [ className =? c --> doFloat           | c <- myFloats]
    , [ title     =? t --> doFloat           | t <- myOtherFloats]
    , [ className =? c --> doF (W.shift "2") | c <- webApps]
    , [ isDialog       --> doCenterFloat ]
    ]
  where myFloats      = ["MPlayer", "Gimp"]
        myOtherFloats = ["alsamixer"]
        webApps       = ["Firefox-bin"]