mkdir -p build >$null 2>&1
cp .\bin\* .\build
odin run .\src -out:.\build\OdinLang.exe