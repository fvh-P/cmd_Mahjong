if "%2" == "" call Error/occured invalid_arguments

setlocal
set _disp=���������������������ވ��O�l�ܘZ������N�@�A�B�C�D�E�F�G�H�X�P�Q�R�S�T�U�V�W�X�����쐼�k��ᢒ��������@

set /a _n=%2-1
set _str=
for /l %%_ in (0,1,%_n%) do (
	call :getChar !%1[%%_]!
	set _str=!_str!!_char!
	set /a _m=%%_%%17
	if !_m! equ 16 (
		echo !_str!
		set _str=
	)
)
exit /b

:getChar
	set _char=!_disp:~%1,1!
	exit /b
