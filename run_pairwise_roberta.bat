@echo off
setlocal EnableDelayedExpansion

call conda activate hiergat
cd /d "%~dp0"

set TASKS=Beer Itunes-Amazon Fodors-Zagats DBLP-ACM DBLP-Scholar Amazon-Google Walmart-Amazon Abt-Buy Dirty/Itunes-Amazon Dirty/DBLP-ACM Dirty/DBLP-Scholar Dirty/Walmart-Amazon

set /a TOTAL=0
for %%T in (%TASKS%) do (
  set /a TOTAL+=1
)

set /a CURRENT=0
for %%T in (%TASKS%) do (
  set /a CURRENT+=1
  echo ===============================
  echo Running RoBERTa task !CURRENT!/!TOTAL!: %%T
  echo ===============================

  python train.py --task %%T --batch_size 32 --max_len 256 --lr 1e-5 --n_epochs 10 --finetuning --split --lm roberta
  if errorlevel 1 (
    echo.
    echo Task failed: %%T
    exit /b 1
  )
)

echo.
echo All pairwise RoBERTa tasks completed.
