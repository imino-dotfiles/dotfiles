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
import XMonad.Layout.PerWorkspace
import XMonad.Layout.MultiColumns

import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS (nextWS, prevWS)
import XMonad.Actions.SpawnOn

import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

-- workspaces definition

ws_edit   = "\xe7b5"
ws_manage = "\xe795"
ws_social = "\xf6ed"
ws_media  = "\xf9c2"
ws_life   = "\xf303"

main = do
          xmonad . ewmh $ docks defaults 

defaults       = def { terminal = myTerminal
                     , borderWidth = 0
                     , modMask = mod4Mask 
                     
                     , normalBorderColor = "#102040"
                     , focusedBorderColor = "#009bb0"
                     
                     , workspaces = [ ws_edit, ws_manage, ws_social, ws_media, ws_life]
                     , manageHook = myManageHook 
                     , startupHook = myStartup
                     , layoutHook = myLayout
                     , logHook = myLogHook 
                     , mouseBindings = myMouseBindings
                     , keys = myKeys
                     }

myTerminal = "alacritty"
myBrowser  = "vivaldi-stable"

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
                       [ ((modMask, xK_p), spawn "rofi -show run")
                       , ((modMask, xK_Tab), spawn "rofi -show window")
                       , ((modMask, xK_Right), nextWS) 
                       , ((modMask .|. controlMask, xK_k), nextWS) 
                       , ((modMask, xK_Left), prevWS) 
                       , ((modMask .|. controlMask, xK_j), prevWS) 

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
                       , ((modMask, xK_comma ), sendMessage (IncMasterN 1))
                       , ((modMask, xK_period), sendMessage (IncMasterN (-1)))
                       , ((modMask, xK_g), goToSelected defaultGSConfig)
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

myLayout      = avoidStruts
                   $ smartBorders
                   $ spacingRaw True (Border 5 5 5 5) True (Border 5 5 5 5) True
                   $ onWorkspaces [ws_edit] layout_edit
                   $ onWorkspaces [ws_manage] layout_manage
                   $ onWorkspaces [ws_social] layout_social
                   $ onWorkspaces [ws_media] layout_media
                   $ onWorkspaces [ws_life] layout_life 
                   $ Simplest
                       where
                           layout_edit = Simplest 
                           layout_manage = Simplest ||| Grid ||| multiCol [1] 4 0.01 0.5
                           layout_social = Simplest ||| Grid
                           layout_media = Simplest
                           layout_life = Simplest ||| Grid

-- window rules
myManageHook             = composeAll . concat $
    [ [isDialog        --> doCenterFloat'                ]
    , [className        =? c --> doFloat       | c <- myJFloats]    -- Just float
    , [className        =? c --> doCenterFloat' | c <- myCFloats]   -- Center float
    , [title            =? t --> doFloat       | t <- myTFloats]
    , [resource         =? r --> doFloat       | r <- myRFloats]
    , [resource         =? i --> doIgnore      | i <- myIgnores]
    , [(className       =? x <||> title =? x <||> resource =? x) --> doShiftAndGo ws_edit | x <- myShifts_edit]  -- send the given program to this tag
    , [(className       =? x <||> title =? x <||> resource =? x) --> doShiftAndGo ws_manage | x <- myShifts_manage]  -- send the given program to this tag
    , [(className       =? x <||> title =? x <||> resource =? x) --> doShiftAndGo ws_edit | x <- myShifts_social]  -- send the given program to this tag
    , [(className       =? x <||> title =? x <||> resource =? x) --> doShiftAndGo ws_media | x <- myShifts_media]  -- send the given program to this tag
    , [(className       =? x <||> title =? x <||> resource =? x) --> doShiftAndGo ws_life | x <- myShifts_life]  -- send the given program to this tag
    ]
    where
        doMaster         = doF W.shiftMaster -- new floating windows goes on top
        doCenterFloat'   = doCenterFloat <+> doMaster
        doShiftAndGo ws  = doF (W.greedyView ws) <+> doShift ws
        myJFloats        = []
        myCFloats        = [ "Pavucontrol"
                           ]
        myTFloats        = []
        myRFloats        = []
        myIgnores        = [ "xmobar"
                           , "dzen"
                           , "dzen2"
                           , "desktop_window"
                           , "kdesktop"
                           , "Polybar"
                           ]
        myShifts_edit    = [ "jetbrains-idea"
                           ]
        myShifts_manage  = [ "alacritty"
                           , "Nemo"
                           ]
        myShifts_social  = [ "discord"
                           , "mailspring"
                           , "vivaldi-stable"
                           ]
        myShifts_media   = [ "spotify"
                           ] 
        myShifts_life    = [ "todoist"
                           ]

myStartup    = do
                   spawn "sh ~/.xmonad/hooks/startup"
                   spawn "feh --bg-fill ~/dotfiles/WALLPAPER.png"
                   spawnOn ws_edit "intellij-idea-ultimate-edition"
                   spawnOn ws_manage "alacritty"
                   spawnOn ws_social "vivaldi-stable"
                   spawnOn ws_social "discord"
                   spawnOn ws_social "mailspring"
                   spawnOn ws_media "spotify"
                   spawnOn ws_life "todoist"

myLogHook     = do
                     fadeInactiveLogHook 0.5

