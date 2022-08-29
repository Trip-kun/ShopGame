
set YYYY=%DATE:~10,4%
set MM=%DATE:~4,2%
set DD=%DATE:~7,2%

set HH=%TIME: =0%
set HH=%HH:~0,2%
set MI=%TIME:~3,2%
set SS=%TIME:~6,2%
set FF=%TIME:~9,2%

set dirName=%YYYY%%MM%%DD%
set fileName=%YYYY%%MM%%DD%_%HH%%MI%%SS%

cd /d C:\Users\Triplapeeck\ClueSidescroller\
echo %fileName%
clue --continue luajit -j bit ./src/
cd /d C:\Users\Triplapeeck\ClueSidescroller\
cp ./src/main.lua ./lua_out/
cp ./src/conf.lua ./lua_out/
rm ./src/main.lua
cd /d C:\Users\Triplapeeck\ClueSidescroller\lua_out\
7z a -tzip -r C:\Users\Triplapeeck\ClueSidescroller\out\%fileName%.love ./*
cd /d C:\Users\Triplapeeck\ClueSidescroller\
lovec ./lua_out