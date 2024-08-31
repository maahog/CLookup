
module Menus.Logado where

import Menus.Util (printMenuEscolhas, readLnPrompt, lerDataHora, aguardeEnter)
import System.Exit (exitSuccess)
import qualified Controllers.SalaController as SalaController
import Control.Monad (forM_)
import Models.Sala (Sala(nomeSala, numSala, tipoSala), Reserva (Reserva))
import qualified Menus.Cores as Cores
import System.Console.ANSI (clearScreen)
import Controllers.EstudanteController (atualizaMonitor)
import Models.Usuario (Usuario (Prof, Est), matriculaUsuario, nomeUsuario)

bemVindo :: [String]
bemVindo = [
   "╔══════════════════════════════════════════════════════════╗",
   "║    ____                  __     ___           _          ║",
   "║   | __ )  ___ _ __ ___   | |   / (_)_ __   __| | ___     ║",
   "║   |  _ | / _ | '_ ` _ |   | | / /| | '_ | / _` |/ _ |    ║",
   "║   | |_) |  __/ | | | | |   | V / | | | | | (_| | (_) |   ║",
   "║   |____/ |___|_| |_| |_|    |_/  |_|_| |_||__,_||___/    ║",
   "╚══════════════════════════════════════════════════════════╝"
 ]

textoSala :: [String]
textoSala = [
   "╔══════════════════════════════════════════════════════════╗",
   "║                ____        _                             ║",
   "║               / ___|  __ _| | __ _                       ║",
   "║               |___ | / _` | |/ _` |                      ║",
   "║                ___) | (_| | | (_| |                      ║",
   "║               |____/ |__,_|_||__,_|                      ║",
   "╚══════════════════════════════════════════════════════════╝"
 ]

menuLogado :: Usuario -> IO ()
menuLogado user = do
    clearScreen
    putStrLn $ Cores.laranja ++ unlines bemVindo ++ Cores.reseta
    putStrLn $ "Bem vindo ao sistema, " ++ nomeUsuario user ++ "!\n"
    case user of
        Est _ -> printMenuEscolhas [
            ("Ver Sala", menuVerSala),
            ("Reservar Sala", reservarSala user),
            ("Cancelar Reserva", cancelarReserva user),
            ("Sair", exitSuccess)
            ]
        Prof _ ->  printMenuEscolhas [
            ("Ver Sala", menuVerSala),
            ("Reservar Sala", reservarSala user),
            ("Cancelar Reserva", cancelarReserva user),
            ("Tornar estudante monitor", menuMonitor),
            ("Sair", exitSuccess)
            ]
    menuLogado user

menuVerSala :: IO ()
menuVerSala = do
    clearScreen
    putStrLn $ Cores.laranja ++ unlines textoSala ++ Cores.reseta
    salas <- SalaController.listarSalas
    forM_ salas $ \sala -> do
        putStrLn $ show (numSala sala) ++ ". " ++ nomeSala sala
    aguardeEnter

listarSalas :: IO ()
listarSalas = do
    clearScreen
    salas <- SalaController.listarSalas
    putStrLn "Salas disponíveis:"
    putStrLn $ Cores.ciano ++ "Num. Nome - Tipo" ++ Cores.reseta
    forM_ salas $ \sala -> do
        putStrLn $ show (numSala sala) ++ ".   " ++ nomeSala sala ++ " - " ++ show (tipoSala sala)
    putStrLn ""

reservarSala :: Usuario -> IO ()
reservarSala user = do
    listarSalas
    numeroSala <- readLnPrompt "Digite o número da sala: "
    horarioInicio <- lerDataHora "Digite o horário de início (DD/MM/AAAA HH:MM): "
    horarioFim <- lerDataHora "Digite o horário de fim (DD/MM/AAAA HH:MM): "

    resposta <- SalaController.reservarSala numeroSala user horarioInicio horarioFim
    case resposta of
        Left erro -> putStrLn erro
        Right _ -> do
            putStrLn "Reserva feita com sucesso!\n"
    aguardeEnter

cancelarReserva :: Usuario -> IO()
cancelarReserva user = do
    listarSalas
    numeroSala <- readLnPrompt "Digite o número da sala: "
    horarioInicio <- lerDataHora "Digite o horário de início (DD/MM/AAAA HH:MM): "
    horarioFim <- lerDataHora "Digite o horário de fim (DD/MM/AAAA HH:MM): "
    let reserva = Reserva (matriculaUsuario user) horarioInicio horarioFim
    resposta <- SalaController.cancelarReserva numeroSala reserva

    case resposta of
        Left erro -> putStrLn erro
        Right _ -> do
            putStrLn "Reserva cancelada com sucesso!\n"
    aguardeEnter

menuMonitor :: IO()
menuMonitor = do
    matricula <- readLnPrompt "Informe a matricula do aluno: "
    valor <- atualizaMonitor matricula True
    case valor of
        Left erro -> putStrLn erro
        Right _ -> do
            putStrLn "Monitor adicionado!\n"
    aguardeEnter
