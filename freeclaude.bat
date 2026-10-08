@echo off
chcp 65001 >nul
title Claude Code via OmniRoute

echo Запуск OmniRoute...
start "OmniRoute" cmd /k omniroute

echo Ожидание запуска OmniRoute...

:wait
curl http://localhost:20128/v1/models >nul 2>&1
if errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto wait
)

echo OmniRoute запущен!

set ANTHROPIC_BASE_URL=http://localhost:20128
set ANTHROPIC_AUTH_TOKEN=sk-c45ac5c4a7cfcd8e-3b0dd9-4332c341
set ANTHROPIC_MODEL=WomboCombo
set CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1

claude