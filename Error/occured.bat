if "%1" == "" call Error/occured panic
cd %~dp0/message
color 0c
echo �G���[���������܂����I
if exist %1.txt (
	echo ���: ��ʃG���[
	echo ����: %1
	echo.
	type %1.txt
) else (
	echo ���: ����G���[
	echo ����: %1
)
pause>nul
exit


