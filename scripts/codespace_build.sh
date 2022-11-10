
set YYYY=%DATE:~10,4%
set MM=%DATE:~4,2%
set DD=%DATE:~7,2%

set HH=%TIME: =0%
set HH=%HH:~0,2%
set MI=%TIME:~3,2%
set SS=%TIME:~6,2%
set FF=%TIME:~9,2%

set dirName=%YYYY%%MM%%DD%
NOW=$(date +%Y-%m-%d-%H%M%S)

cd /workspaces/codespaces-blank/ShopGame/
/workspaces/codespaces-blank/clue --continue luajit -j bit ./src/
cd /workspaces/codespaces-blank/out/
cd /workspaces/codespaces-blank/ShopGame/
cp ./src/main.lua ./lua_out/
cp ./src/conf.lua ./lua_out/
rm ./src/main.lua
cd /workspaces/codespaces-blank/ShopGame/lua_out
/workspaces/codespaces-blank/7zz a -tzip -r "/workspaces/codespaces-blank/out/${NOW}.love" ./*