@echo off
cls
setlocal enabledelayedexpansion

rem goto question2
:question1
echo What part of the puzzle do you want to solve?
set /P P=type in either 1 or 2:
cls
if %P% == 1 ( set part=1 & goto question2 )
if %P% == 2 ( set part=2 & goto question2 )
echo That isn't a 1 or 2...
echo " "
goto question1
:question2



echo|set /p="">numbers.txt

set result=0

set i=0
for /f "tokens=*" %%a in (input.txt) do (
	set a=%%a
	set a=!a: =!
	set lines[!i!]=!a!
	set /a i=i+1
	
)
set /a l=!i!-1



goto postfunctions


:math
rem echo !lvl!:%ln%%op%%rn%
set a=%eol%%ln%
set b=%eol%%rn%
set la=0
set lb=0
set ai=0
set bi=0
:whilea
	set n=!a:~-1!
	rem echo %n%
	set lna[!ai!]=%n%
	set a=!a:~0,-1!
	set /a ai=ai+1
if not %a% == %eol% goto whilea
set /a al=ai-1
:whileb
	set n=!b:~-1!
	rem echo %n%
	set b=!b:~0,-1!
	if %op% == %+ (
		if !bi! lss !ai! (
			set /a out[!bi!]=lna[!bi!]+n
		) else (
			set out[!bi!]=!n!
		)
		rem echo !bi!:!out[%bi%]!
	) else (
		for /l %%n in (0,1,!al!) do (
			set /a oi=%%n+bi
			if defined out[!oi!] (
				set /a ocs=lna[%%n]*%n%
				set /a out[!oi!]=out[!oi!]+ocs
			) else (
				set /a out[!oi!]=lna[%%n]*%n%
			)
			rem echo !oi!:!out[%%n]!
		)
	)
	set /a bi=bi+1
if not %b% == %eol% goto whileb
if %op% == %+ (
	if %bi% lss %ai% (
		for /l %%n in (!bi!,1,!al!) do (
			set /a out[%%n]=lna[%%n]
		)
		set tl=!ai!
	) else (
		set tl=!bi!
	)
) else (
	set /a tl=ai+bi-1
)

set ti=0
set "return="
:whilet
	set /a n=!out[%ti%]!
	rem echo out!ti!:!n!
	if !n! gtr 9 (
		set /a tn=ti+1
		set /a na=!n:~0,-1!
		set /a out[!tn!]=out[!tn!]+na
		set n=!n:~-1!
		set "out[!ti!]="
		set return=!n!!return!
		set /a ti=ti+1
		goto whilet
	)
	set return=!n!!return!
	set "out[!ti!]="
	set /a ti=ti+1
	rem if defined out[!ti!] goto whilet
	if !ti! lss %tl% goto whilet
rem echo result: !return!

EXIT /B 0

:postfunctions




set i=0
set eol=_
set highestlvl=0
set sum=0
set part=2
:lineloop
	rem setlocal enabledelayedexpansion
	rem echo Line !i!:
	rem echo !lines[%i%]!
	set line=!lines[%i%]!%eol%
	set lvl=0
	set mlvl=0
	set "sumarray[0]="
	set "lastoparray[0]="
	set "multarray[0]="
	:charloop
		set c=!line:~0,1!
		rem echo processing !c!:
		if !c! == %) ( 
			if %part% == 2 (
				if defined multarray[!lvl!] (
					rem echo first do closing on multiplier lvl !lvl!
					call set totalsumlvl=%%sumarray[!lvl!]%%
					call set rn=%%sumarray[!lvl!]%%
					set "sumarray[!lvl!]="
					set "lastoparray[!lvl!]="
					set "multarray[!lvl!]="
					set /a lvl=lvl-1 
					if defined sumarray[!lvl!] (
						call set ln=%%sumarray[!lvl!]%%
						rem echo !ln!
						call set op=%%lastoparray[!lvl!]%%
						rem set /a rn=x
						call :math
						set sumarray[!lvl!]=!return!
					) else (
						set sumarray[!lvl!]=!totalsumlvl!
					)
				) 
			)
			rem echo closing bracket lvl !lvl!
			set "lastoparray[!lvl!]=" 
			call set totalsumlvl=%%sumarray[!lvl!]%%
			call set rn=%%sumarray[!lvl!]%%
			set "sumarray[!lvl!]="
			set "lastoparray[!lvl!]="
			set /a lvl=lvl-1 
			if defined sumarray[!lvl!] (
				call set ln=%%sumarray[!lvl!]%%
				rem echo !ln!
				call set op=%%lastoparray[!lvl!]%%
				rem set /a rn=x
				call :math
				set sumarray[!lvl!]=!return!
			) else (
				set sumarray[!lvl!]=!totalsumlvl!
				rem echo set !lvl! !totalsumlvl!
			)
		) else (
			if !c! == %( ( 
				set /a lvl=lvl+1 
				if lvl gtr highestlvl (set highestlvl=!lvl!) 
			) else (
				if !c! == * ( 
					if %part% == 2 (
						if defined multarray[!lvl!] (
							rem echo do closing on multiplier lvl !lvl!
							call set totalsumlvl=%%sumarray[!lvl!]%%
							call set rn=%%sumarray[!lvl!]%%
							set "sumarray[!lvl!]="
							set "lastoparray[!lvl!]="
							set "multarray[!lvl!]="
							set /a lvl=lvl-1 
							if defined sumarray[!lvl!] (
								call set ln=%%sumarray[!lvl!]%%
								rem echo !ln!
								call set op=%%lastoparray[!lvl!]%%
								rem set /a rn=x
								call :math
								set sumarray[!lvl!]=!return!
							) else (
								set sumarray[!lvl!]=!totalsumlvl!
							)
						) 
						set lastoparray[!lvl!]=!c!
						set /a lvl=lvl+1 
						set multarray[!lvl!]=1
					) else (
						set lastoparray[!lvl!]=!c!
					)
				) else (
					if !c! == + ( 
						set lastoparray[!lvl!]=!c!
					) else (
						if defined sumarray[!lvl!] (
							rem echo !lvl! !sumarray[%lvl%]!
							call set ln=%%sumarray[!lvl!]%%
							set op=!lastoparray[%lvl%]!
							set /a rn=c
							call :math
							set sumarray[!lvl!]=!return!
						) else (
							set /a sumarray[!lvl!]=c
							rem echo set !lvl! %c%
						)
					)
				)
			)
		)
		set line=!line:~1!
		if not %line% == %eol% goto charloop
		if %part% == 2 (
			:part2multLoop
			if defined multarray[!lvl!] (
				rem echo END do closing on multiplier lvl !lvl!
				call set totalsumlvl=%%sumarray[!lvl!]%%
				call set rn=%%sumarray[!lvl!]%%
				set "sumarray[!lvl!]="
				set "lastoparray[!lvl!]="
				set "multarray[!lvl!]="
				set /a lvl=lvl-1 
				if defined sumarray[!lvl!] (
					call set ln=%%sumarray[!lvl!]%%
					rem echo !ln!
					call set op=%%lastoparray[!lvl!]%%
					rem set /a rn=x
					call :math
					set sumarray[!lvl!]=!return!
				) else (
					set sumarray[!lvl!]=!totalsumlvl!
				)
			)
			if defined multarray[!lvl!] goto part2multLoop
		)
	set out=!sumarray[0]!
	
	echo Sum !i!: !out!
	echo !out!>>numbers.txt
	set ln=!result!
	set op=+
	set rn=!out!
	call :math
	set result=!return!
	rem endlocal
	set /a i=i+1
	rem echo ----------------------------------------------------------
if defined lines[%i%] goto lineloop

echo ----------------------------------------------------------
echo The answer for part !part!: !result!
echo The answer for part !part!: !result! > out.txt

endlocal

exit /b