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

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)

import XMonad.Util.EZConfig
import XMonad.Util.NamedWindows (getName, unName)
import XMonad.Util.Run (safeSpawn)

import XMonad.Stockholm.Shutdown (newShutdownEventHandler, shutdown)

main :: IO ()
main = getArgs >>= \case
    [] -> main'
    ["--shutdown"] -> shutdown
    args -> hPutStrLn stderr ("bad arguments: " <> show args) >> exitFailure

main' :: IO ()
main' = do
  handleShutdownEvent <- newShutdownEventHandler
  launch $ desktopConfig
    { borderWidth        = 2
    , modMask            = mod4Mask -- windows key
    , terminal           = "${pkgs.kitty}/bin/kitty"
    , normalBorderColor  = "#cccccc"
    , focusedBorderColor = "#cd8b00"
    , manageHook         = myManageHook <+> manageHook desktopConfig
    , layoutHook         = desktopLayoutModifiers $ myLayouts
    , logHook            = dynamicLogString def >>= xmonadPropLog
    , handleEventHook    = handleShutdownEvent
    }
    `additionalKeysP`
      [ ("M-t", sendMessage (Toggle "Full"))
      , ("M-L", safeSpawn "${pkgs.slock}/bin/slock" [])
      ]

myLayouts = toggleLayouts (noBorders Full) others
  where
    others = ResizableTall 1 (1.5/100) (3/5) [] ||| emptyBSP

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
