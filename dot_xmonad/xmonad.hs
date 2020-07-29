import Data.Ratio ((%))
import qualified Data.Map as M

import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.IM
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
import XMonad.Layout.Maximize
import XMonad.Layout.Tabbed
import XMonad.Layout.Spiral

import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS (nextWS, prevWS)

import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

main = do
          xmonad . ewmh $ docks defaults 

defaults       = def { terminal = myTerminal
                     , borderWidth = 0
                     , modMask = mod4Mask 
                     
                     , normalBorderColor = "#102040"
                     , focusedBorderColor = "#009bb0"
                     
                     , workspaces = myWorkspaces
                     , manageHook = myManageFloat <+> myManageShift
                     , startupHook = myStartup
                     , layoutHook = myLayout
                     , logHook = myLogHook 
                     , mouseBindings = myMouseBindings
                     , keys = myKeys
                     }

myTerminal = "alacritty"
myBrowser  = "firefox"

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
                       [ ((modMask, xK_p), spawn "rofi -show run")
                       , ((modMask, xK_Right), nextWS) 
                       , ((modMask, xK_Left), prevWS) 

                       -- Defaults

                       , ((modMask, xK_Return), spawn myTerminal)
                       , ((modMask, xK_i), spawn myBrowser) 
                       , ((modMask, xK_Print), spawn "sh ~/.xmonad/hooks/screenshot")
                       , ((modMask .|. shiftMask, xK_BackSpace), kill)
                       , ((modMask .|. shiftMask, xK_C), kill)
                       , ((modMask, xK_q), spawn "xmonad --recompile; xmonad --restart")
                       , ((modMask, xK_space ), sendMessage NextLayout)
                       , ((modMask, xK_j), windows W.focusDown)
                       , ((modMask, xK_k), windows W.focusUp)
                       , ((modMask .|. shiftMask, xK_j), windows W.swapDown)
                       , ((modMask .|. shiftMask, xK_k), windows W.swapUp)
                       ]

                       ++

                       [((m .|. modMask, k), windows $ f i)
                           | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
                           , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

                       ++

                       [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
                               | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
                               , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
                     [ ((mod4Mask, button4), const prevWS)
                     , ((mod4Mask, button5), const nextWS)
                     ]

myLayout       = avoidStruts
               $ smartBorders
               $ spacingRaw True (Border 5 5 5 5) True (Border 5 5 5 5) True
               $ all
                  where
                      all = spiral (6/7) ||| Grid ||| Full ||| Simplest ||| ResizableTall 1 (3/100) (1/2) []

myWorkspaces = ["edit", "terminal", "browse", "social", "file"]

myManageFloat = composeAll
              [ className =? "Pavucontrol" --> doFloat
              , className =? "jetbrains-studio" --> doFloat
              , className =? "Polybar" --> doFullFloat
              , title =? "screenshot" --> doFloat
              ]

myManageShift = composeAll
              [ className =? "Nemo" --> doShift "5"
              ]

myStartup     = do
               spawn "sh ~/.xmonad/hooks/startup"
               spawn "feh --bg-fill ~/dotfiles/WALLPAPER.png"

myLogHook     = do
                     fadeInactiveLogHook 0.6

