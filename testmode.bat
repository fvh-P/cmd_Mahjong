@echo off
setlocal enabledelayedexpansion
cd %~dp0

if "%1" neq "" goto Renaming

set /a loop=0,error=0
for /l %%i in (11,1,47) do set /a haisyu[%%i]=0,koyuu[%%i]=%%i*4-43
for /l %%i in (21,1,29) do set /a koyuu[%%i]-=4
for /l %%i in (31,1,39) do set /a koyuu[%%i]-=8
for /l %%i in (41,1,47) do set /a koyuu[%%i]-=12

rem haisyu[]...���̔v�킪�����g�p���ꂽ���H
rem koyuu[]...�v��n�Ԃ̔v�̌��݂̌ŗL�ԍ��͉����H
rem tehai[]...��vn�Ԗڂ̔v��ԍ��͉����H
rem result[]...��vn�Ԗڂ̌ŗL�ԍ��͉����H

:Select
	cls
	echo Tips:C�c�`���[�����AK�c���m�@�������Őݒ肵�܂�
	echo      20,30,40�̂����ꂩ����͂ŁA���̔v�̓����_���ɂȂ�܂�
	if %error% == 1 echo ERROR:�����͏�ԂŃG���^�[�L�[��������܂���
	if %error% == 2 echo ERROR:���͂��ꂽ�����́A�ݒ�ł���l�ł͂���܂���
	if %error% == 3 echo ERROR:���̔v�͂S���o�^�ς݂ł�
	set /a loop+=1,error=0
	set tehai=
	set /p tehai="��v%loop%���ڂ̔v��ԍ��H"
	set /a judge_test=0+tehai,tehai[%loop%]=tehai
rem ���͂���Ă��Ȃ��c�cerror=1
	if "%tehai%" == "" set /a loop-=1,error=1& goto Select	
rem ���͂�����ԍ��������ꍇ�c�cerror=201,202...
	if %tehai% == C set /a loop-=1,error=201& goto Select_Ex
	if %tehai% == K set /a loop-=1,error=202& goto Select_Ex
rem ���͂�<=10,>=48,%10=0�ł���i���͈͊O�j�c�cerror=2
	if %judge_test% lss 11 set /a loop-=1,error=2& goto Select
	if %judge_test% gtr 47 set /a loop-=1,error=2& goto Select
rem ���̔v�킪���łɂS���g�p����Ă���c�cerror=3
	if !haisyu[%tehai%]! == 4 set /a loop-=1,error=3& goto Select
rem �v�ԍ��o�^����
	set /a haisyu[%tehai%]+=1
	set /a result[%loop%]=koyuu[%tehai%],koyuu[%tehai%]+=1
	if %loop% lss 13 goto Select
	goto Change

:Select_Ex
rem �v�ԍ��ꊇ�o�^����
	if %error% == 201 (
		set /a tehai[1]=11,tehai[2]=11,tehai[3]=11,tehai[4]=12,tehai[5]=13,tehai[6]=14,tehai[7]=15,tehai[8]=16
		set /a tehai[9]=17,tehai[10]=18,tehai[11]=19,tehai[12]=19,tehai[13]=19
	)
	if %error% == 202 (
		set /a tehai[1]=11,tehai[2]=19,tehai[3]=21,tehai[4]=29,tehai[5]=31,tehai[6]=39,tehai[7]=41,tehai[8]=42
		set /a tehai[9]=43,tehai[10]=44,tehai[11]=45,tehai[12]=46,tehai[13]=47
	)
	for /l %%i in (1,1,13) do (
		set /a haisyu[!tehai[%%i]!]+=1
		set /a result[%%i]=koyuu[!tehai[%%i]!],koyuu[!tehai[%%i]!]+=1
	)
	goto Change

:Change
	cls
	for /l %%i in (1,1,13) do set /p <nul="!result[%%i]! "
	echo.
	echo �ݒ肵�܂��B
	timeout /t 1 /nobreak  >nul
	for /l %%i in (1,1,13) do (
		set /a tempint0=109+%%i
		for /l %%j in (1,1,136) do (
			if !yama[%%j]! == !result[%%i]! (
				set /a tempint11=yama[!tempint0!]
				set yama[!tempint0!]=!result[%%i]!
				set yama[%%j]=!tempint11!
			)
		)
	)
	del /q "%cd%\yama2.txt"
	for /l %%i in (1,1,136) do echo !yama[%%i]!>>"%cd%\yama2.txt"
	exit

:Renaming
	cd ..
	echo timeout /t 2 /nobreak^>nul>"%cd%\renaming.bat"
	echo ren %1 MJ%2>>"%cd%\renaming.bat"
	echo start %cd%\MJ%2\MJ.bat ren>>"%cd%\renaming.bat"
	echo exit>>"%cd%\renaming.bat"
	start "%cd%\renaming.bat"
	exit