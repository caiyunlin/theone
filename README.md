# 关于 TheOne

在软件开发过程中，经常会使用到一些公共的辅助代码，比如MD5加密，日期格式化，正则替换等等，这些代码远没有到整理成类库的级别，所以整理成公共函数文件，以便更好的复用。

TheOne便是这样一个函数库，其中每种语言会发布成一个文件，如 TheOne.cs 是C#的函数, TheOne.java 是Java的函数库。

## 目标

从取名可知，TheOne的目标是，每一种语言就发布一个且只会发布一个文件，且只有一个版本，新的版本发布时尽量兼容原来的版本，这样的好处就是引入非常简单，个人项目可以直接引用文件，如果用户公司的项目，则可以直接打开文件，复制需要的片段。

## 使用方式

每一种语言的使用方式都不太一样，提供的功能也不尽相同，比如 TheOne.ps1 是PowerShell的脚本，引入方式非常简单，引入后可以执行包装好的公共函数，也可以执行下载软件的操作
```powershell

# 安装 7zip 软件包
one install 7zip

# 执行 MD5 函数
$code = $one.MD5('aaa')

```

而开发语言如 C#, 则可以下载TheOne.cs然后直接添加文件到项目中，然后实例化出对象再进行操作
```csharp

TheOne one = new TheOne();
string code = one.MD5("aaa");

```

## 详细帮助(TODO)

- theone.ps1 Powershell 常用函数/命令
- theone.cs .Net C# 函数库
- theone.js Javascript 常用函数
- theone.php PHP 常用函数
- theone.py Python 常用函数
- theone.sh Linux 下常用命令
- theone.sql SQL 常用脚本
- theone.xslt XSLT 常用函数


## 写在最后
TheOne 是一个个人项目，旨在将自己开发过程中遇到的代码进行整理，防止重复劳动，所涉及到的方法也仅限于我个人在开发中遇到的场景，所以肯定不会很全面。 这个项目仅作为一个思路，希望启发同为开发者的你可以用此方法整理自己的类库。