module Menus.Inicio where

import System.Exit (exitSuccess)
import Menus.Util (escolherOpcoes)
import Menus.Cadastro (menuCadastro)
import Menus.Login (menuLogin)
import Menus.Calendario (menuCalendario)
import qualified Menus.Cores as Cores

menu :: [String]
menu = [
        "╔═══════════════════════════════════════════════════════════════════════════════╗",
        "║                                                                               ║",
        "║                 ______  __                 __               _______           ║",
        "║               .' ___  |[  |               [  |  _          |_   __ |          ║",
        "║             / .'   |_| | |  .--.    .--.  | | / ] __   _    | |__) |          ║",
        "║             | |        | |/ .'`| |/ .'`| || '' < [  | | |   |  ___/           ║",
        "║             | `.___.'| | || |__. || |__. || |`| | | |_/ |, _| |_              ║",
        "║              `.____ .'[___]'.__.'  '.__.'[__|  |_]'.__.'_/|_____|             ║",
        "║                                                                               ║",
        "║       Menu:                                                                   ║",
        "║          " ++ Cores.reseta ++ Cores.negrito ++ "1. Login      " ++ Cores.amarelo ++ "                                                       ║",
        "║          " ++ Cores.reseta ++ Cores.negrito ++ "2. Cadastro   " ++ Cores.amarelo ++ "                                                       ║",
        "║          " ++ Cores.reseta ++ Cores.negrito ++ "3. Calendário " ++ Cores.amarelo ++ "                                                       ║",
        "║          " ++ Cores.reseta ++ Cores.negrito ++ "4. Sair       " ++ Cores.amarelo ++ "                                                       ║",
        "║                                                                               ║",
        "║                                                          Digite a opção:      ║",
        "╚═══════════════════════════════════════════════════════════════════════════════╝"
    ]

menuInicio :: IO()
menuInicio = do
    putStrLn $ Cores.amarelo ++ unlines menu ++ Cores.reseta
    escolherOpcoes [
        menuLogin,
        menuCadastro,
        menuCalendario,
        sair
     ]
    -- loop infinito, já que o unico jeito de sair é utilizando a opção de sair
    menuInicio

sair :: IO()
sair = do
    putStrLn "Até Mais!"
    exitSuccess