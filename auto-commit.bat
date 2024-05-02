:: git init

:: git remote add origin https://github.com/iyeaaa/SelfStudy.git

:: git add --all

:: git commit -m "before reupload"

:: git pull --rebase origin main

:: git push --set-upstream origin main

:loop

	cd C:\Users\user\Desktop\Self-study

	git add --all

	git commit -m "auto commit"

	git pull

	git push
	
	TIMEOUT 300

goto loop