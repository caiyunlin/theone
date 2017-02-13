## 关闭控制台默认输出
```
@echo off
echo ABC
```
>只有echo的语句才会输出

## BAT参数和变量使用
```
echo %1
echo %2 
set p=123
echo %p% 
if %p% EQU 123 echo p value is 123
```
> %1为第一个参数，%2为第二个参数。  
赋值的时候，=两边不要有空格 
使用变量需要用%%括起来   
判断比较变量值不需要加引号

## BAT时间戳
```
@echo off
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
set hour=%time:~,2%
if "%time:~,1%"==" " set hour=0%time:~1,1%
set DateTimeNow=%mydate%-%hour%%time:~3,2%
```

## 使用choice实现选择和分支
```
choice /C 1234 /M "Press a key for your choice to see a sample."

if %ERRORLEVEL% EQU 1 goto sample1
if %ERRORLEVEL% EQU 2 goto sample2
if %ERRORLEVEL% EQU 2 goto sample3
if %ERRORLEVEL% EQU 2 goto sample4

:sample1
    echo Display a timestamp
    For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
    set hour=%time:~,2%
    if "%time:~,1%"==" " set hour=0%time:~1,1%
    set DateTimeNow=%mydate%-%hour%%time:~3,2%
    echo %DateTimeNow%
goto end

:sample2
    echo display current location
    echo "%~dp0"
goto end

:sample3
    echo this is sample 3
goto end

:sample4
    echo this is sample 4
goto end

:end
```

## BAT设置执行路径为bat所在目录
```
cd %~dp0
```
或者
```
for %%i in (%0) do set aa=%%~dpi
cd /d %aa%
```

## 创建网络共享路径
```
net use \\servername /delete
net use \\servername password /user:username
```

## 强制删除某个文件夹，对NodeJS长路径无法删除的问题有效
```
mkdir empty_dir
robocopy empty_dir the_dir_to_delete /s /mir
rmdir empty_dir
rmdir the_dir_to_delete
```

## BAT设置无线网路共享
```
netsh wl set hos m=a s=vWiFi k=1234567890
netsh wl sta hos
netsh wl sto hos
```

## 清除源代码残留文件脚本
清理一个目录的版本控制软件生成文件，可以将下面问呢保存成bat，在目标文件夹内执行
```
@ECHO OFF
@echo ===================================================================
@echo    清除svn,vss,cvs标记文件   
@echo    filename : clearSvnCvsVss.bat
@echo ===================================================================
@ECHO 按Ctrl + C取消。
@pause
@echo 执行批处理：%0 %1 %2 %3
@echo 转到：%1 
cd /d %1

@echo (1)开始清除.SVN文件夹
@rem for /r %%d in (.) do if exist "%%d\.svn" echo /s /q "%%d\.svn"
@for /r %%d in (.) do if exist "%%d\.svn" rd /s /q "%%d\.svn"

@echo (2)开始清除CVS标记
@for /r %%d in (.) do if exist "%%d\CVS\Root" rd /s/q "%%d\CVS"

@echo (3)开始清除vssver.scc和vssver2.scc文件
attrib -s -h -r -a vssver?.scc /s
for /r . %%i in (vssver?.scc) do if exist %%i del %%i

@echo (4)开始清除VisualStudio中的VSS标记文件
attrib -s -h -r -a *.vssscc /s
attrib -s -h -r -a *.csproj.vspscc /s

for /r . %%i in (*.vssscc) do if exist %%i del %%i
for /r . %%i in (*.csproj.vspscc) do if exist %%i del %%i

@echo 删除完后请检查是否清楚干净。考虑不同的编码工具带有自己的特殊标志，可根据具体情况修改批处理文件中的命令行。
pause
exit
```

