@ECHO OFF

bpc /b genres2 -$E+ -$G+ -$N+ 
if errorlevel 1 goto fail
c:\temp\exe\genres2
if errorlevel 1 goto fail
bpc /b genres2 -$E+ -$G+ -$N+ /DRUS
if errorlevel 1 goto fail
c:\temp\exe\genres2
if errorlevel 1 goto fail
bpc /b/dSINGLE resrs2  -$G+ -$E+ -$N+
if errorlevel 1 goto fail
COPY /B C:\temp\exe\resrs2.EXE+C:\temp\exe\resrs2.ovr+c:\temp\exe\resrs2.TVR exe\resrs2.EXE
bpc /cp/b/dSINGLE resrs2 -$G+ -$E+ -$N+ -L
if errorlevel 1 goto fail
COPY /B C:\temp\exe\resrs2.EXE+c:\temp\exe\resrs2.TVR exe\resrs2p.EXE
if errorlevel 1 goto fail
COPY C:\TEMP\EXE\Res2ru.LNG exe\Res2ru.LNG
if errorlevel 1 goto fail
goto success
:fail
echo Error encountered building RESRS2.EXE
:success
