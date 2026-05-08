@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo =============================================
echo    NTR Mobile - Portable Translator Installer
echo =============================================
echo.
echo This will install BepInEx + XUnity AutoTranslator
echo for machine translation of NTR Mobile.
echo No internet connection required.
echo.

:: ---- Detect script directory ----
set "SCRIPT_DIR=%~dp0"
set "FILES_DIR=%SCRIPT_DIR%files"

if not exist "%FILES_DIR%\winhttp.dll" (
    echo ERROR: 'files' folder not found!
    echo Make sure the 'files' folder is next to this script.
    echo Expected: %FILES_DIR%
    pause
    exit /b 1
)

:: ---- Game Path ----
set /p "GAME_PATH=Enter the full path to your NTR Mobile game folder: "

:: Remove trailing backslash if present
if "%GAME_PATH:~-1%"=="\" set "GAME_PATH=%GAME_PATH:~0,-1%"

if not exist "%GAME_PATH%\NTRMobile.exe" (
    echo.
    echo ERROR: NTRMobile.exe not found in the specified path!
    echo Please verify the path and try again.
    pause
    exit /b 1
)

echo.
echo Game found at: %GAME_PATH%
echo.

:: ---- Source Language ----
echo What language is the game currently in?
echo   [1] English     (en)
echo   [2] Japanese     (ja)
echo   [3] Chinese      (zh-Hans)
echo   [4] Korean       (ko)
echo.
set /p "FROM_CHOICE=Enter your choice [1-4]: "

if "%FROM_CHOICE%"=="1" set "FROM_LANG=en"
if "%FROM_CHOICE%"=="2" set "FROM_LANG=ja"
if "%FROM_CHOICE%"=="3" set "FROM_LANG=zh-Hans"
if "%FROM_CHOICE%"=="4" set "FROM_LANG=ko"

if not defined FROM_LANG (
    echo Invalid choice. Defaulting to English.
    set "FROM_LANG=en"
)

echo Source language set to: %FROM_LANG%
echo.

:: ---- Target Language ----
echo What language do you want to translate to?
echo   [1]  Russian             (ru)
echo   [2]  Ukrainian            (uk)
echo   [3]  Spanish              (es)
echo   [4]  French               (fr)
echo   [5]  German               (de)
echo   [6]  Portuguese           (pt)
echo   [7]  Polish               (pl)
echo   [8]  Turkish              (tr)
echo   [9]  Chinese Simplified   (zh-Hans)
echo   [10] Japanese             (ja)
echo   [11] Korean               (ko)
echo   [12] Italian              (it)
echo   [13] Dutch                (nl)
echo   [14] Czech                (cs)
echo   [15] Thai                 (th)
echo   [16] Vietnamese           (vi)
echo   [17] Indonesian           (id)
echo   [18] Arabic               (ar)
echo.
set /p "TO_CHOICE=Enter your choice [1-18]: "

if "%TO_CHOICE%"=="1"  set "TO_LANG=ru"
if "%TO_CHOICE%"=="2"  set "TO_LANG=uk"
if "%TO_CHOICE%"=="3"  set "TO_LANG=es"
if "%TO_CHOICE%"=="4"  set "TO_LANG=fr"
if "%TO_CHOICE%"=="5"  set "TO_LANG=de"
if "%TO_CHOICE%"=="6"  set "TO_LANG=pt"
if "%TO_CHOICE%"=="7"  set "TO_LANG=pl"
if "%TO_CHOICE%"=="8"  set "TO_LANG=tr"
if "%TO_CHOICE%"=="9"  set "TO_LANG=zh-Hans"
if "%TO_CHOICE%"=="10" set "TO_LANG=ja"
if "%TO_CHOICE%"=="11" set "TO_LANG=ko"
if "%TO_CHOICE%"=="12" set "TO_LANG=it"
if "%TO_CHOICE%"=="13" set "TO_LANG=nl"
if "%TO_CHOICE%"=="14" set "TO_LANG=cs"
if "%TO_CHOICE%"=="15" set "TO_LANG=th"
if "%TO_CHOICE%"=="16" set "TO_LANG=vi"
if "%TO_CHOICE%"=="17" set "TO_LANG=id"
if "%TO_CHOICE%"=="18" set "TO_LANG=ar"

if not defined TO_LANG (
    echo Invalid choice. Defaulting to Russian.
    set "TO_LANG=ru"
)

echo Target language set to: %TO_LANG%
echo.

:: ---- Translation Service ----
echo Which translation service do you want to use?
echo   [1] GoogleTranslateV2  (default, works well)
echo   [2] DeepLTranslate     (better quality, may need API key)
echo   [3] GoogleTranslate     (older Google API)
echo   [4] BingTranslate      (Microsoft Translator)
echo.
set /p "SERVICE_CHOICE=Enter your choice [1-4]: "

if "%SERVICE_CHOICE%"=="1" set "TRANSLATION_SERVICE=GoogleTranslateV2"
if "%SERVICE_CHOICE%"=="2" set "TRANSLATION_SERVICE=DeepLTranslate"
if "%SERVICE_CHOICE%"=="3" set "TRANSLATION_SERVICE=GoogleTranslate"
if "%SERVICE_CHOICE%"=="4" set "TRANSLATION_SERVICE=BingTranslate"

if not defined TRANSLATION_SERVICE (
    set "TRANSLATION_SERVICE=GoogleTranslateV2"
)

echo Translation service set to: %TRANSLATION_SERVICE%
echo.
echo =============================================
echo   Ready to install!
echo   Game:      %GAME_PATH%
echo   From:      %FROM_LANG%
echo   To:        %TO_LANG%
echo   Service:   %TRANSLATION_SERVICE%
echo =============================================
echo.
pause

:: ---- Copy root files ----
echo.
echo [1/5] Copying loader files...
copy /Y "%FILES_DIR%\winhttp.dll" "%GAME_PATH%\" >nul
copy /Y "%FILES_DIR%\.doorstop_version" "%GAME_PATH%\" >nul
copy /Y "%FILES_DIR%\baselib.dll" "%GAME_PATH%\" >nul
copy /Y "%FILES_DIR%\doorstop_config.ini" "%GAME_PATH%\" >nul
echo Done.

:: ---- Copy dotnet runtime (required for IL2CPP) ----
echo.
echo [2/5] Copying .NET runtime (65 MB, please wait)...
if not exist "%GAME_PATH%\dotnet" mkdir "%GAME_PATH%\dotnet"
xcopy /E /Y /Q /I "%FILES_DIR%\dotnet" "%GAME_PATH%\dotnet" >nul
echo Done.

:: ---- Copy BepInEx core ----
echo.
echo [3/5] Copying BepInEx core...
if not exist "%GAME_PATH%\BepInEx\core" mkdir "%GAME_PATH%\BepInEx\core"
copy /Y "%FILES_DIR%\BepInEx\core\*" "%GAME_PATH%\BepInEx\core\" >nul
echo Done.

:: ---- Copy plugins ----
echo.
echo [4/5] Copying XUnity AutoTranslator...
if not exist "%GAME_PATH%\BepInEx\plugins\XUnity.AutoTranslator\Translators\FullNET" mkdir "%GAME_PATH%\BepInEx\plugins\XUnity.AutoTranslator\Translators\FullNET"
copy /Y "%FILES_DIR%\BepInEx\plugins\XUnity.AutoTranslator\ExIni.dll" "%GAME_PATH%\BepInEx\plugins\XUnity.AutoTranslator\" >nul
copy /Y "%FILES_DIR%\BepInEx\plugins\XUnity.AutoTranslator\XUnity.AutoTranslator.Plugin.BepInEx-IL2CPP.dll" "%GAME_PATH%\BepInEx\plugins\XUnity.AutoTranslator\" >nul
copy /Y "%FILES_DIR%\BepInEx\plugins\XUnity.AutoTranslator\XUnity.AutoTranslator.Plugin.Core.dll" "%GAME_PATH%\BepInEx\plugins\XUnity.AutoTranslator\" >nul
copy /Y "%FILES_DIR%\BepInEx\plugins\XUnity.AutoTranslator\XUnity.AutoTranslator.Plugin.ExtProtocol.dll" "%GAME_PATH%\BepInEx\plugins\XUnity.AutoTranslator\" >nul
copy /Y "%FILES_DIR%\BepInEx\plugins\XUnity.AutoTranslator\Translators\*.dll" "%GAME_PATH%\BepInEx\plugins\XUnity.AutoTranslator\Translators\" >nul
copy /Y "%FILES_DIR%\BepInEx\plugins\XUnity.AutoTranslator\Translators\FullNET\*" "%GAME_PATH%\BepInEx\plugins\XUnity.AutoTranslator\Translators\FullNET\" >nul
echo Done.

echo.
echo [4/5] Copying XUnity Resource Redirector...
if not exist "%GAME_PATH%\BepInEx\plugins\XUnity.ResourceRedirector" mkdir "%GAME_PATH%\BepInEx\plugins\XUnity.ResourceRedirector"
copy /Y "%FILES_DIR%\BepInEx\plugins\XUnity.ResourceRedirector\*" "%GAME_PATH%\BepInEx\plugins\XUnity.ResourceRedirector\" >nul
echo Done.

:: ---- Create config and translation dirs ----
echo.
echo [5/5] Creating configuration and translation folders...
if not exist "%GAME_PATH%\BepInEx\config" mkdir "%GAME_PATH%\BepInEx\config"
if not exist "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\Text" mkdir "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\Text"
if not exist "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\Texture" mkdir "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\Texture"
if not exist "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\RedirectedResources" mkdir "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\RedirectedResources"

echo. > "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\Text\_Substitutions.txt"
echo. > "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\Text\_Preprocessors.txt"
echo. > "%GAME_PATH%\BepInEx\Translation\%TO_LANG%\Text\_Postprocessors.txt"

set "CONFIG_PATH=%GAME_PATH%\BepInEx\config\AutoTranslatorConfig.ini"

(
echo [Service]
echo Endpoint=%TRANSLATION_SERVICE%
echo FallbackEndpoint=
echo.
echo [General]
echo Language=%TO_LANG%
echo FromLanguage=%FROM_LANG%
echo.
echo [Files]
echo Directory=Translation\{Lang}\Text
echo OutputFile=Translation\{Lang}\Text\_AutoGeneratedTranslations.txt
echo SubstitutionFile=Translation\{Lang}\Text\_Substitutions.txt
echo PreprocessorsFile=Translation\{Lang}\Text\_Preprocessors.txt
echo PostprocessorsFile=Translation\{Lang}\Text\_Postprocessors.txt
echo.
echo [TextFrameworks]
echo EnableIMGUI=False
echo EnableUGUI=True
echo EnableUIElements=True
echo EnableNGUI=True
echo EnableTextMeshPro=True
echo EnableTextMesh=False
echo EnableFairyGUI=True
echo.
echo [Behaviour]
echo MaxCharactersPerTranslation=200
echo IgnoreWhitespaceInDialogue=True
echo MinDialogueChars=20
echo ForceSplitTextAfterCharacters=0
echo CopyToClipboard=False
echo MaxClipboardCopyCharacters=2500
echo ClipboardDebounceTime=1.25
echo EnableUIResizing=True
echo EnableBatching=False
echo UseStaticTranslations=True
echo OverrideFont=
echo OverrideFontSize=
echo OverrideFontTextMeshPro=
echo FallbackFontTextMeshPro=
echo ResizeUILineSpacingScale=
echo ForceUIResizing=False
echo IgnoreTextStartingWith=
echo TextGetterCompatibilityMode=False
echo GameLogTextPaths=
echo RomajiPostProcessing=ReplaceMacronWithCircumflex;RemoveApostrophes;ReplaceHtmlEntities
echo TranslationPostProcessing=ReplaceMacronWithCircumflex;ReplaceHtmlEntities
echo RegexPostProcessing=
echo CacheRegexPatternResults=False
echo PersistRichTextMode=Final
echo CacheRegexLookups=False
echo CacheWhitespaceDifferences=False
echo GenerateStaticSubstitutionTranslations=False
echo GeneratePartialTranslations=False
echo EnableTranslationScoping=True
echo EnableSilentMode=True
echo BlacklistedIMGUIPlugins=
echo EnableTextPathLogging=False
echo OutputUntranslatableText=False
echo IgnoreVirtualTextSetterCallingRules=False
echo MaxTextParserRecursion=1
echo HtmlEntityPreprocessing=True
echo HandleRichText=True
echo EnableTranslationHelper=False
echo ForceMonoModHooks=False
echo InitializeHarmonyDetourBridge=False
echo RedirectedResourceDetectionStrategy=AppendMongolianVowelSeparatorAndRemoveAll
echo OutputTooLongText=False
echo TemplateAllNumberAway=False
echo ReloadTranslationsOnFileChange=False
echo DisableTextMeshProScrollInEffects=False
echo CacheParsedTranslations=False
echo.
echo [Texture]
echo TextureDirectory=Translation\{Lang}\Texture
echo EnableTextureTranslation=False
echo EnableTextureDumping=False
echo EnableTextureToggling=False
echo EnableTextureScanOnSceneLoad=False
echo EnableSpriteRendererHooking=False
echo LoadUnmodifiedTextures=False
echo DetectDuplicateTextureNames=False
echo DuplicateTextureNames=
echo EnableLegacyTextureLoading=False
echo TextureHashGenerationStrategy=FromImageName
echo CacheTexturesInMemory=True
echo EnableSpriteHooking=False
echo.
echo [ResourceRedirector]
echo PreferredStoragePath=Translation\{Lang}\RedirectedResources
echo EnableTextAssetRedirector=False
echo LogAllLoadedResources=False
echo EnableDumping=False
echo CacheMetadataForAllFiles=True
echo.
echo [Http]
echo UserAgent=
echo DisableCertificateValidation=True
echo.
echo [TranslationAggregator]
echo Width=400
echo Height=100
echo EnabledTranslators=
echo.
echo [Debug]
echo EnableConsole=False
echo.
echo [Migrations]
echo Enable=True
echo Tag=5.6.1
echo.
echo [Baidu]
echo BaiduAppId=
echo BaiduAppSecret=
echo DelaySeconds=1
echo.
echo [BingLegitimate]
echo OcpApimSubscriptionKey=
echo.
echo [Custom]
echo Url=
echo EnableShortDelay=False
echo DisableSpamChecks=False
echo.
echo [DeepL]
echo ExecutableLocation=
echo MinDelaySeconds=2
echo MaxDelaySeconds=6
echo.
echo [DeepLLegitimate]
echo ExecutableLocation=
echo ApiKey=
echo Free=False
echo.
echo [ezTrans]
echo InstallationPath=
echo.
echo [Google]
echo ServiceUrl=
echo.
echo [GoogleV2]
echo ServiceUrl=
echo RPCID=MkEWBc
echo VERSION=boq_translate-webserver_20210323.10_p0
echo UseSimplest=False
echo.
echo [GoogleLegitimate]
echo GoogleAPIKey=
echo.
echo [LecPowerTranslator15]
echo InstallationPath=
echo.
echo [LingoCloud]
echo LingoCloudToken=
echo.
echo [Watson]
echo Url=
echo Key=
echo.
echo [Yandex]
echo YandexAPIKey=
) > "%CONFIG_PATH%"

echo Done.

:: ---- Done ----
echo.
echo =============================================
echo   Installation complete!
echo =============================================
echo.
echo What happens next:
echo   1. Launch the game - BepInEx will initialize
echo      (first launch will be slower, this is normal)
echo   2. Translation will start automatically
echo   3. Translated text is cached in:
echo      BepInEx\Translation\%TO_LANG%\Text\_AutoGeneratedTranslations.txt
echo.
echo Tips:
echo   - Batching is DISABLED to avoid translation errors
echo   - Press Ctrl+Alt+T in-game to toggle translation
echo   - Edit _Substitutions.txt for manual translation overrides
echo   - Check BepInEx\LogOutput.log for any issues
echo.
pause