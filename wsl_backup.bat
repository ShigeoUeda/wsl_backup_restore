@echo off
setlocal enabledelayedexpansion

REM WSL�f�B�X�g���r���[�V�����̃o�b�N�A�b�v�X�N���v�g
REM �g�p���@: 
REM   wsl_backup.bat [�f�B�X�g���r���[�V������] [�o�b�N�A�b�v�p�X(�ȗ���)]
REM ��:
REM   wsl_backup.bat Ubuntu-22.04
REM   wsl_backup.bat Ubuntu-22.04 D:\backups

REM �����`�F�b�N
if "%1"=="" (
    echo �G���[: �o�b�N�A�b�v�Ώۂ̃f�B�X�g���r���[�V���������w�肵�Ă��������B
    echo �g�p���@: wsl_backup.bat [�f�B�X�g���r���[�V������] [�o�b�N�A�b�v�p�X(�ȗ���:Default�l C:\wsl_images)]
    echo ��:
    echo wsl_backup.bat Ubuntu-22.04
    echo wsl_backup.bat Ubuntu-22.04 D:\backups
    echo.
    echo ���p�\�ȃf�B�X�g���r���[�V����:
    wsl --list -v
    exit /b 1
)

REM �V�X�e���Ǘ��Ҍ����`�F�b�N
net session >nul 2>&1
if errorlevel 1 (
    echo �G���[: ���̃X�N���v�g�ɂ͊Ǘ��Ҍ������K�v�ł��B
    echo �Ǘ��҂Ƃ��Ď��s���Ă��������B
    exit /b 1
)

REM WSL�̏�Ԋm�F
wsl --status >nul 2>&1
if errorlevel 1 (
    echo �G���[: WSL������ɓ��삵�Ă��܂���B
    echo WSL�̃X�e�[�^�X���m�F���Ă��������B
    exit /b 1
)

REM �o�b�N�A�b�v�p�X�̐ݒ�
set "BACKUP_DIR=%2"
if "%BACKUP_DIR%"=="" (
    set "BACKUP_DIR=C:\wsl_images"
)

REM �^�C���X�^���v�̐���
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
    set "DATE=%%c%%a%%b"
)
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (
    set "TIME=%%a%%b"
)

REM �o�b�N�A�b�v�t�@�C�����̐ݒ�
set "BACKUP_FILE=!BACKUP_DIR!\%~1_!DATE!_!TIME!.tar"

REM �o�b�N�A�b�v�f�B���N�g���̊m�F�ƍ쐬
if not exist "!BACKUP_DIR!" (
    echo �o�b�N�A�b�v�f�B���N�g�����쐬���܂�: !BACKUP_DIR!
    mkdir "!BACKUP_DIR!"
    if errorlevel 1 (
        echo �G���[: �o�b�N�A�b�v�f�B���N�g���̍쐬�Ɏ��s���܂����B
        echo �p�X�̌�����󂫗e�ʂ��m�F���Ă��������B
        exit /b 1
    )
)

REM �f�B�X�N�e�ʃ`�F�b�N
for /f "tokens=3" %%a in ('dir /-c "!BACKUP_DIR!" ^| findstr "�o�C�g�̋�"') do set "FREE_SPACE=%%a"
if !FREE_SPACE! LSS 10485760 (
    echo �G���[: �o�b�N�A�b�v�f�B���N�g���̋󂫗e�ʂ��s�����Ă��܂��B
    echo �Œ�10GB�ȏ�̋󂫗e�ʂ��K�v�ł��B
    exit /b 1
)

echo.
echo �o�b�N�A�b�v���J�n���܂�...
echo �Ώ�: %~1
echo �o�͐�: !BACKUP_FILE!
echo.

REM �o�b�N�A�b�v�̎��s
wsl --export "%~1" "!BACKUP_FILE!"
if errorlevel 1 (
    echo �G���[: �o�b�N�A�b�v�̍쐬�Ɏ��s���܂����B
    echo.
    echo ���p�\�ȃf�B�X�g���r���[�V����:
    wsl --list -v
    echo.
    echo �ڍׂȃG���[�ɂ��Ă�WSL�̃��O���m�F���Ă��������B
    exit /b 1
)

REM �o�b�N�A�b�v�t�@�C���̊m�F
if not exist "!BACKUP_FILE!" (
    echo �G���[: �o�b�N�A�b�v�t�@�C�����쐬����܂���ł����B
    exit /b 1
)

echo.
echo �o�b�N�A�b�v������Ɋ������܂����B
echo �o�̓t�@�C��: !BACKUP_FILE!
echo �t�@�C���T�C�Y: 
dir "!BACKUP_FILE!" | findstr "!DATE!"

endlocal
exit /b 0