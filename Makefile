test:
	love .

deploy:
	zip -r Schirmi.zip main.lua src ext data
	cat love-0.9.1-win32/love.exe Schirmi.zip > dist-win32/schirmi.scr
