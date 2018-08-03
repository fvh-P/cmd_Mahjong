@echo off
setlocal enabledelayedexpansion
cd /d %~dp0
echo %random%>nul

rem main�֐��Q�B�ċA�̓s���㕪���B
:Main
rem �������A�g�b�v��ʂ܂�
	mode con cols=90 lines=25
	call :FolderSearch %1
	call :YamaSet
	call :Initialize
	call :Cursor 0 4
	call :Top

:Main2
rem �ǂ̐i�s�A���v�A���񂾂��S�����̗��v
	call :NextRound
	call :Sipai
	call :AllRipai

:Main3
rem ��Ԃ̈ړ��A�c��
	call :NextTurn
	call :Tumo
	call :Tehai%aiturn%
	if %nokori% == 0 (
		call :Ryukyoku
		goto Main2
	)
	call :PonJudge %turn%
	goto Main3

:Top
	cls
	if %testmode% == 0 (
		set tempstr1=
	) else set tempstr1=test mode
	echo ���� ver.%version%  %tempstr1%
	echo  %cursor[1]%�΋ǊJ�n %cursor[2]%���O�擾 %cursor[3]%�o�[�W������� %cursor[4]%�I��
	choice /c adws >nul
	set selected=%errorlevel%
	if %selected% leq 2 (
		call :Cursor %selected%
		goto Top
	)
	if %selected% == 4 (
		set /a testmode+=1,testmode%%=2
		goto Top
	)
	if %cursor% == 4 exit
	if %cursor% == 3 (
		call version.bat
		goto Main
	)
	if %cursor% == 2 call :logging Main2
	exit /b

:Initialize
rem �������Ƃɐݒ肷��ϐ�
	set player=4
	set gamecount=41
	set kyoku=0
	set tumibou=0
	set tumiboureset=1
	set cursor=1
	set testmode=0
	set EPstr=�Z���O�l�ܘZ�����㖳�@�A�B�C�D�E�F�G�H���P�Q�R�S�T�U�V�W�X�����쐼�k��ᢒ��������@
	for /l %%i in (1,1,14) do set cursor[%%i]=�@
	call :Roll
	exit /b

:FolderSearch
	for /f "tokens=2" %%i in ('findstr /n "��" "%cd%\version.bat"') do set version=%%i
	set tempint1=0
	set tempstr1=%cd%
	for /l %%a in (1,1,100) do (
		for /f "delims=\" %%b in ("!tempstr1!") do (
			if "%%b" neq "" (
				set foldername[%%a]=%%b
				set tempstr1=!tempstr1:%%b=!
				set /a tempint1+=1
			) else goto FolderSearch2
		)
	)
:FolderSearch2
	if not "MJ%version%" == "!foldername[%tempint1%]!" call testmode.bat "%cd%" %version%
	pushd ..
	if "%1" == "ren" del /q "%cd%\renaming.bat">nul
	popd
	exit /b

:NextRound
rem �ǂ��Ƃɐݒ�A�ω�����ϐ��B
rem sutehai[�ԍ�]...�̂Ĕv�̖���
rem sutehaiEP[�ԍ�][����]...�e�̂Ĕv��EP
rem sutehaistr[�ԍ�]...�̂Ĕv�̗�\��
	set agari=0
	for /l %%i in (1,1,%player%) do (
		set fCount[%%i]=0
		set sutehaistr[%%i]=
		set sutehai[%%i]=0
		set reach[%%i]=F
		set poncheck[%%i]=0
		for /l %%j in (1,1,24) do set sutehaiEP[%%i][%%j]=
		for /l %%j in (1,1,47) do set PU[%%i][%%j]=0
	)
	set poncheck[1]=1
	
rem �ꕗ�̐ݒ�
	call :TPtoEP %gamecount% bEP

rem ���ꎞ/�A�����̐e�ԁA�ǁA�ςݖ_�̐ݒ�
	if %tumiboureset% == 1 (
		set /a kyoku+=1,tumibou=0
		if !kyoku! gtr %player% set /a gamecount+=1,kyoku=1
		if !gamecount! == 43 goto finish
		for /l %%i in (1,1,%player%) do (
			set /a jTP[%%i]-=1
			if !jTP[%%i]! lss 41 set jTP[%%i]=4%player%
			call :TPtoEP !jTP[%%i]! jEP[%%i]
		)
	) else set /a tumibou+=1
	set kyokuEP=!EPstr:~%kyoku%,1!
	set tumibouEP=!EPstr:~%tumibou%,1!
	exit /b

:NextTurn
rem �����Ƃɕω�����ϐ��B
	exit /b

:Ryukyoku
rem ���ǎ��̕ϐ��B
set >>hensu.txt
	echo ����
	echo ���v����A����
	pause
	exit /b

rem =�����܂ŕϐ��̊Ǘ�=============

:Tumo
rem �c����
	set /a NP[%turn%][14]=yama[%nokori%],aiturn=(turn+1)/3
	call :NPtoTP !NP[%turn%][14]! TP[%turn%][14] EP[%turn%][14]
rem PU[turn]�ɉ��Z�B
	set /a PU[%turn%][!tp[%turn%][14]!]+=1
	exit /b

:Tehai0
rem �v���C���[�p��v���x��(tehai0��tehai)
	set /a tehaicount[1]=14-fCount[1]*3
	set command[1]=Z�F�c��
	set selectkey[1]=z
	if %reach[1]% == F (
		set command[2]=X�F���[�`
		set selectkey[2]=x
	) else (
		set command[2]=�@�@�@�@�@
		set selectkey[2]=
	)
rem �ȉ\���ǂ���
	call :KanJudge 1
	if %kanable[1]% geq 1 (
	set command[3]=C:�J��
	set selectkey[3]=c
	) else (
		set command[3]=�@�@�@�@
		set selectkey[3]=
	)
	call :Cursor 0 %tehaicount[1]%

:Tehai
	call :Display 1
	cls
	echo %jEP[4]%�Ǝ�v�F%str[4]%
	echo �@�@�̔v�F%sutehaistr[4]%
	echo ����������������������������������������
	echo %jEP[3]%�Ǝ�v�F%str[3]%
	echo �@�@�̔v�F%sutehaistr[3]%
	echo ����������������������������������������
	echo %jEP[2]%�Ǝ�v�F%str[2]%
	echo �@�@�̔v�F%sutehaistr[2]%
	echo ����������������������������������������
	echo %bEP%%kyokuEP%�� %tumibouEP%�{�� 
	echo �h���\���v�F%dEP[0]%�@�c�F%nokori%
	echo ����������������������������������������
	echo �@�@�̔v�F%sutehaistr[1]%
	echo.
	echo %jEP[1]%�Ǝ�v�F%str[1]%
	echo �@�@�@�@�@%str2%
	echo (�ȉ\��)%str3%
	echo %command[1]%�@%command[2]%�@%command[3]%
	choice /c adw%selectkey[1]%%selectkey[2]%%selectkey[3]% >nul
	set selected=%errorlevel%
	if %selected% leq 2 (
		call :Cursor %selected%
		goto Tehai
	)
	if %selected% == 3 (
		if %cursor% == %tehaicount[1]% set cursor=14
		call :Dahai !cursor!
		exit /b
	)
	if %selected% geq 4 call :Unimplemented
	exit
	
:Dahai
rem �����P�ɑŔv����v�ԍ��B���Ă���ꍇ�̃c���؂��14
	set /a sutehai[%turn%]+=1
	set sutehai[%turn%][!sutehai[%turn%]!]=!EP[%turn%][%1]!
	set sutehaistr[%turn%]=!sutehaistr[%turn%]!!EP[%turn%][%1]!
	set NP[%turn%][%1]=!NP[%turn%][14]!
	set ldNP=!NP[%turn%][%1]!
	set ldTP=!TP[%turn%][%1]!
	set ldEP=!EP[%turn%][%1]!
	set /a PU[%turn%][!TP[%turn%][%1]!]-=1
	set /a PU[1][!TP[%turn%][%1]!]+=1,PU[2][!TP[%turn%][%1]!]+=1,PU[3][!TP[%turn%][%1]!]+=1,PU[4][!TP[%turn%][%1]!]+=1
	if %1 neq 14 call :Ripai %turn%
	exit /b

:Tehai1
rem �R���s���[�^�p��v���x��
	call :display %turn%
	cls
	echo %jEP[4]%�Ǝ�v�F%str[4]%
	echo �@�@�̔v�F%sutehaistr[4]%
	echo ����������������������������������������
	echo %jEP[3]%�Ǝ�v�F%str[3]%
	echo �@�@�̔v�F%sutehaistr[3]%
	echo ����������������������������������������
	echo %jEP[2]%�Ǝ�v�F%str[2]%
	echo �@�@�̔v�F%sutehaistr[2]%
	echo ����������������������������������������
	echo %bEP%%kyokuEP%�� %tumibouEP%�{�� 
	echo �h���\���v�F%dEP[0]%�@�c�F%nokori%
	echo ����������������������������������������
	echo �@�@�̔v�F%sutehaistr[1]%
	echo.
	echo %jEP[1]%�Ǝ�v�F%str[1]%
	set aidahai=14
	if !tp[%turn%][13]! geq 41 set aidahai=13
	call :Dahai %aidahai%
	exit /b

rem =��������ėp���x��=============

:KanJudge
rem loop...�J���ł��邩�̍l��������P����
rem loop2...�J���ł��邩�̍l��������Q����
rem loop3...�J���ł��邩�̍l��������R����
rem loop4...�J���ł��邩�̍l��������S����
rem kanable[P�ԍ�]...����P������J���ł��邩
rem kanable[P�ԍ�][�J���ł����ڂ̑g�ݍ��킹���ikanable[P�ԍ�]�j]...0�Ȃ�ÞȁA1�Ȃ疾��
rem kanabletehai[1~14]...�P�Ȃ�J���\�A�O�Ȃ�s�\
	set /a loop=0,kanable[%1]=0,tempint1=12-fCount[1]*3
	for /l %%i in (1,1,14) do set kanabletehai[%%i]=0

:KanJudge2
rem �ÞȂ̔���
	set /a loop+=1,loop1=loop,loop2=loop+1,loop3=loop+2,loop4=loop+3
	if %loop% geq %tempint1% goto KanJudge3
	if !TP[%1][%loop%]! neq !TP[%1][%loop3%]! goto KanJudge2
	if !TP[%1][%loop%]! == !TP[%1][14]! (
		set /a kanable[%1]+=1,loop+=2
		set kanable[%1][!kanable[%1]!]=0
		set kanabletehai[%loop1%]=1
		set kanabletehai[%loop2%]=1
		set kanabletehai[%loop3%]=1
		set kanabletehai[14]=1
		goto KanJudge2
	)
	if !TP[%1][%loop%]! == !TP[%1][%loop4%]! (
		set /a kanable[%1]+=1,loop+=3
		set kanable[%1][!kanable[%1]!]=0
		set kanabletehai[%loop1%]=1
		set kanabletehai[%loop2%]=1
		set kanabletehai[%loop3%]=1
		set kanabletehai[%loop4%]=1
		goto KanJudge2
	)
	set /a loop+=2
	goto KanJudge2

:Kanjudge3
rem ���Ȃ̔���
	for /l %%i in (1,1,!fCount[%1]!) do (
		for /l %%j in (1,1,10) do (
			if !fDisp[%1][%%i]! == !TP[%1][%%j]! (
				set kanable[%1][!kanable[%1]!]=1
				set kanabletehai[%%j]=1	
			)
		)
		if !fDisp[%1][%%i]! == !TP[%1][14]! set kanabletehai[14]=1
	)
	set /a tehaicount=13-fCount[%1]*3
	set str3=
	for /l %%i in (1,1,%tehaicount%) do (
		if !kanabletehai[%%i]! == 1 (
			set str3=!str3!��
		) else set str3=!str3!�Q
	)
	for /l %%i in (1,1,!fcount[%1]!) do set str3=!str3!         
	if !kanabletehai[14]! == 1 (
		set str3=!str3! ��
	) else set str3=!str3! �Q
	exit /b

:PonJudge
rem �e�v���C���[�̑Ŕv��A���̃v���C���[�����̔v���|���ł��邩�ǂ����̊m�F
	set /a turn=turn%%4+1,loop=0
	if %turn% == %1 (
		set /a turn=turn%%4+1
		goto ChiJudge
	)
	if !poncheck[%turn%]! == 0 goto PonJudge
:PonJudge2
	set /a loop+=1,loop2=loop+1,tempint1=13-fCount[%turn%]*3,tempint5=tempint1-2,nakivector=(%1+4-%turn%)%%4
	if !TP[%turn%][%loop%]! == %ldTP% if !TP[%turn%][%loop2%]! == %ldTP% (
		call :Cursor 0 2
		set cursor=2
		goto PonCheck
	)
	
	if %loop2% lss %tempint1% goto PonJudge2
	goto Ponjudge
:PonCheck
	cls
	call :PlainDisplay %turn%
	echo !jEP[%1]!�Ǝ̔v�F!sutehaistr[%1]!
	echo.
	echo �@�@��v�F%str[1]%
	echo.
	echo �y!jEP[%turn%]!�ƁF�v���C���[%turn%�z�́A�y!jEP[%1]!�ƁF�v���C���[%1�z�̎̔v�y!ldEP!�z���|���ł��܂��B
	echo �|�����܂����H
	echo !cursor[1]!�͂� !cursor[2]!������
	choice /c adw >nul
	if %errorlevel% leq 2 (
		call :Cursor %errorlevel%
		goto PonCheck
	)
	if %cursor% == 2 exit /b
	set /a fCount[%turn%]+=1,sutehai[%1]-=1
	set tempstr=!sutehaistr[%1]!
	set sutehaistr[%1]=!tempstr:~0,-1!
rem 	�������̋��ʏ���
	set tempint6=!fCount[%turn%]!
	set /a NP[%turn%][%loop%]=999,NP[%turn%][%loop2%]=999,NP[%turn%][14]=999,fMents[%turn%][%tempint6%]=ldTP
	if %nakivector% == 1 set fDispMents[%turn%][%tempint6%]=%ldEP%%ldEP%[%ldEP%]
	if %nakivector% == 2 set fDispMents[%turn%][%tempint6%]=%ldEP%[%ldEP%]%ldEP%
	if %nakivector% == 3 set fDispMents[%turn%][%tempint6%]=[%ldEP%]%ldEP%%ldEP%
	set fDisp[%turn%][%tempint6%]=%ldEP%
rem ���񐔂��Ƃ̏���
	set /a tempint7=tempint6*3-2,tempint8=tempint6*3-1,tempint9=tempint6*3
	set /a furohai[%turn%][%tempint7%]=ldNP,furohai[%turn%][%tempint8%]=ldNP,furohai[%turn%][%tempint9%]=ldNP

	call :Ripai %turn%
	set /a NP[%turn%][14]=NP[%turn%][%tempint5%],NP[%turn%][%tempint5%]=999
	call :Ripai %turn%
	call :NPtoTP !NP[%turn%][14]! TP[%turn%][14] EP[%turn%][14]
	set /a PU[%turn%][%ldTP%]-=2
	set /a PU[1][%ldTP%]+=2,PU[2][%ldTP%]+=2,PU[3][%ldTP%]+=2,PU[4][%ldTP%]!]+=2
	if %turn% == 1 goto Tehai0
	goto Tehai1

:ChiJudge
rem turn�ɁA�Ŕv����P�̉E��P�̔ԍ��������Ă���
rem ldTP����ɁA�`�[�ł���g�ݍ��킹������΁A������L�^
rem 	for /l %%i in (1,1,13) do set /p <nul="!TP[%turn%][%%i]!,"
rem 	pause
rem �����܂ŗ����Ȃ�΁A�v���C���[���Ƃ̑Ŕv�������I���������ƂɂȂ�B
rem ����āA����P�̎��̂Ɉڂ�̂ŁA����ɕK�v�ȏ����������ōs���B
rem 
	set /a nokori-=1
	exit /b
	
:Display
rem �����P�̃v���C���[�̎�v�\��
rem str2�̓J�[�\����Btehai[1][14]�̃J�[�\����[14]�ł͂Ȃ�[14-����*3]
	set /a tehaicount=13-fCount[%1]*3
	set str[%1]=
	if %1 == 1 set str2=
	for /l %%i in (1,1,%tehaicount%) do (
		set str[%1]=!str[%1]!!EP[%1][%%i]!
		if %1 == 1 set str2=!str2!!cursor[%%i]!
	)
	set str[%1]=!str[%1]! !EP[%1][14]!
	if %1 == 1 set str2=!str2! !cursor[%tehaicount[1]%]!
	for /l %%i in (!fCount[%1]!,-1,1) do set str[%1]=!str[%1]! !fDispMents[%1][%%i]!
	exit /b

:PlainDisplay
	set /a tehaicount=13-fCount[%1]*3
	set str[%1]=
	for /l %%i in (1,1,%tehaicount%) do set str[%1]=!str[%1]!!EP[%1][%%i]!
	exit /b
	
:Roll
rem �e����
	set /a tempint1=%random%*player/32768
	for /l %%i in (1,1,%player%) do (
		set /a tempint1+=1
		if !tempint1! gtr %player% set /a turn=%%i,tempint1=1
		set /a jTP[%%i]=tempint1%%4+41
	)
	set /a turn=(turn+2)%%4+1
	exit /b

:NPtoTP
rem ����1��tehai��TP�ɕϊ����āA����2�Ɏw�肳�ꂽ���O�̕ϐ��ɕۑ��B
rem ����3�����݂���ꍇ�A����3������2�Ƃ���TPtoEP�Ɉ����p���B
	set /a %2=(%1-1)/4+(%1-1)/36+11
	if not "%3" == "" call :TPtoEP !%2! %3
	exit /b

:TPtoEP
rem ����1��TP��EP�ɕϊ����āA����2�Ɏw�肳�ꂽ���O�̕ϐ��ɕۑ�
	set /a tempint0=%1-10
	set %2=!EPstr:~%tempint0%,1!
	exit /b

:Sipai
rem yama2.txt�̓��e�𒊏o
	set /a nokori=0,loop=0
	if not exist yama2.txt (
		cls
		echo wait...
		call :Wait
		goto Sipai
	)
	call :YamaSet
	cls
	echo OK
	for /f %%i in (%cd%\yama2.txt) do (
		set /a nokori+=1
		set yama[!nokori!]=%%i
	)
	
	if %testmode% == 1 (
		set nokori=0
		start /b /wait testmode.bat
		for /f %%i in (%cd%\yama2.txt) do (
			set /a nokori+=1
			set yama[!nokori!]=%%i
		)
	)

	:Sipai2
		if %nokori% geq 127 (
			set /a tempint1=136-nokori
			set dNP[!tempint1!]=!yama[%nokori%]!
			call :NPtoTP !yama[%nokori%]! dTP[!tempint1!] dEP[!tempint1!]
			set /a nokori-=1
			goto Sipai2
		)
		if %nokori% geq 123 (
			set /a tempint1=127-nokori
			set rNP[!tempint1!]=!yama[%nokori%]!
			call :NPtoTP !yama[%nokori%]! rTP[!tempint1!] rEP[!tempint1!]
			set /a nokori-=1
			goto Sipai2
		)
		set /a PU[1][%dTP[0]%]+=1,PU[2][%dTP[0]%]+=1,PU[3][%dTP[0]%]+=1,PU[4][%dTP[0]%]+=1
	:Sipai3
		if %loop% == %player% (
			set /a nokori+=1
			exit /b
		)
		set /a loop+=1,loop2=0
	:Sipai4
		set /a loop2+=1
		set NP[%loop%][%loop2%]=!yama[%nokori%]!
		set /a nokori-=1
		if %loop2% == 13 goto Sipai3
		goto Sipai4

:AllRipai
rem �S�v���C���[�ꊇripai
	set loop2=0
	:AllRipai2
		set /a loop2+=1
		call :Ripai %loop2%
		for /l %%i in (1,1,13) do set /a PU[%loop2%][!TP[%loop2%][%%i]!]+=1
		if %loop2% == %player% exit /b
		goto AllRipai2

:Ripai
rem ����1�̃v���C���[�ԍ��̎�v��playernum�ɑ������ripai
rem ���ꂽ�v��tehai999/TP51�Ƃ��ĕ��ʂɗ��v�B
	set /a tempint2=agari+13,loop=0
	echo.>tehai.txt
	for /l %%i in (1,1,%tempint2%) do (
		set /a tempint1=!NP[%1][%%i]!+1000
		echo !tempint1!>>tehai.txt
	)
	sort "%cd%\tehai.txt" /o "%cd%\tehai.txt"
	for /f %%i in (%cd%\tehai.txt) do (
		set /a loop+=1
		set /a NP[%1][!loop!]=%%i-1000
	)
	for /l %%i in (1,1,%tempint2%) do call :NPtoTP !NP[%1][%%i]! TP[%1][%%i] EP[%1][%%i]
	exit /b

:YamaSet
rem �V�[�p�C���邽�߂�txt���쐬����o�b�`���N������B
rem ����ŋN�����邽�ߕʂ�bat�ɁB
	start /belownormal /min %cd%\yamaset.bat
	exit /b

:Unimplemented
rem �������̎��ɕ\���B�\�����������ł���exit /b����̂Ńo�O��B�m�F�p
	echo ������
	pause
	exit /b

:Cursor
rem �J�[�\���ړ��֘A
rem ����...012(/array)
	if not "%2" == "" set /a array=%2
	set cursor[%cursor%]=�@
	call :Cursor_%1
	set cursor[%cursor%]=��
	exit /b

	:Cursor_0
		exit /b
	:Cursor_1
		set /a cursor=(cursor+array-2)%%array+1
		exit /b
	:Cursor_2
		set /a cursor=cursor%%array+1
		exit /b

:GetTime
rem �����P�Ȃ�A���̔ԍ����g���Ď��Ԃ�o�^
rem �����Q�Ȃ�A�P�ڂ̔ԍ����g���Ď��Ԃ�o�^�B��������Q�ڂ̔ԍ����J�n���ԁA�P�ڂ̔ԍ����I�����ԂƂ��Čo�ߎ��Ԃ��Z�o�E�\��
	set T[%1]=%TIME%
	for /f "tokens=1-4 delims=:." %%a in ("!T[%1]!") do set /a MT[%1]=%%a0*36000+1%%b*6000+1%%c*100+1%%d-610100
	if "%2" == "" exit /b
	set /a D=MT[%2]-MT[%1]
	set /a D1=%D:~0,-2%0/10,D2=10%D:~-2,2%%%100+100
	set D2=%D2:~1,2%
	echo.
	echo �J�n���ԁF!T[%2]!
	echo �I�����ԁF!T[%1]!
	echo �o�ߎ��ԁF%D1%.%D2%sec �i%D%ms�j
	pause >nul
	exit /b

:Wait
rem �P�b�ҋ@�B
	timeout /t 1 /nobreak >nul
	exit /b

:Logging
rem ���O�擾�p���x���B�����Ɠ����ɍ폜
	set fName=%cd%\%date:~0,4%%date:~5,2%%date:~8,2%
	prompt $s
	@echo on
	for /l %%i in (1,1,100) do if not exist "%fName%_%%i.log" call :%1 > "%fName%_%%i.log" 2>&1