@echo off

:loop
	godot -f scenes\game.tscn
	echo "restart"
goto loop
