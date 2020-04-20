{ pkgs, username, ... }:
  pkgs.writers.writeHaskellBin "xmonad" {
    libraries = [
      pkgs.haskellPackages.xmonad
      pkgs.haskellPackages.xmonad-extras
      pkgs.haskellPackages.xmonad-contrib
      (pkgs.haskellPackages.callPackage ../Libraries/xmonad-stockholm.nix {})
    ];
  } /* haskell */ ''
{-# LANGUAGE LambdaCase #-}

module Main (main) where
import XMonad

import System.Exit
import System.IO (hPutStrLn, stderr)
import System.Environment (getArgs)

import qualified XMonad.StackSet as W
import XMonad.Config.Desktop

import XMonad.Actions.Navigation2D

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers

import qualified XMonad.Layout.BinarySpacePartition as BSP
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)

import XMonad.Util.EZConfig
import XMonad.Util.NamedWindows (getName, unName)
import XMonad.Util.Run (safeSpawn)

import XMonad.Stockholm.Shutdown (newShutdownEventHandler, shutdown)

myLocalMod = mod4Mask -- This is caps lock
-- myGlobalMod -- will be windows key
myTerminal = "${pkgs.kitty}/bin/kitty"
myLaunchTerminal = "${pkgs.alacritty}/bin/alacritty"
myNormalBorderColor = "#cccccc"
myFocusedBorderColor = "#cd8b00"

main :: IO ()
main = getArgs >>= \case
    [] -> main'
    ["--shutdown"] -> shutdown
    args -> hPutStrLn stderr ("bad arguments: " <> show args) >> exitFailure

main' :: IO ()
main' = do
  handleShutdownEvent <- newShutdownEventHandler
  launch $ nav $ desktopConfig
    { borderWidth        = 2
    , modMask            = myLocalMod
    , terminal           = myTerminal
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , manageHook         = myManageHook <+> manageHook desktopConfig
    , layoutHook         = desktopLayoutModifiers $ myLayouts
    , logHook            = dynamicLogString def >>= xmonadPropLog
    , handleEventHook    = handleShutdownEvent
    } `additionalKeysP`    (keyState Insert)


nav :: XConfig l -> XConfig l
nav = navigation2D def (xK_k, xK_h, xK_j, xK_l) [(myLocalMod, windowGo), (myLocalMod .|. shiftMask, windowSwap)] False

data ActiveBindings = Insert | Travel | Shuffle | Overview

keyState :: ActiveBindings -> [(String, X ())]
keyState Insert = [ ("M-g", sendMessage (Toggle "Full"))
                  , ("M-S-l", safeSpawn "${pkgs.slock}/bin/slock" [])
                  , ("M-,", sendMessage Shrink)
                  , ("M-.", sendMessage Expand)
                  , ("M-a", sendMessage $ BSP.Rotate)
                  , ("M-s", sendMessage $ BSP.Swap)
                  , ("M-d", sendMessage $ BSP.FocusParent)
                  , ("M-f", sendMessage $ BSP.SelectNode)
                  , ("M-z", spawn $ myTerminal)
                  , ("M-x", spawn $ myLaunchTerminal)
                  , ("M-c", kill)
                  ]
keyState _ = error "Not yet implemented, look up how to do dynamic keybinds in xmonad"

myLayouts = toggleLayouts (noBorders Full) others
  where
    others = {- ResizableTall 1 (1.5/100) (3/5) [] ||| -} BSP.emptyBSP

myManageHook = composeAll . concat $
    [ [ className =? c --> doFloat           | c <- myFloats]
    , [ title     =? t --> doFloat           | t <- myOtherFloats]
    , [ className =? c --> doF (W.shift "2") | c <- webApps]
    , [ isDialog       --> doCenterFloat ]
    ]
  where myFloats      = ["MPlayer", "Gimp"]
        myOtherFloats = ["alsamixer"]
        webApps       = ["Firefox-bin"]
''
