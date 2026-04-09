# Vimspector 调试配置指南

## 快速开始

### 1. 安装 vimspector 插件

在 Vim 中运行：
```vim
:PlugInstall
```

### 2. 安装调试适配器

在 Vim 中运行：
```vim
:VimspectorInstall vscode-cpptools
```

或者手动下载：
- 访问 https://github.com/microsoft/vscode-cpptools/releases
- 下载最新版本的 cpptools-win64.vsix
- 解压到 `~/.vim/plugged/vimspector/gadgets/windows/` 目录

### 3. 在项目根目录创建 .vimspector.json

将 `.vimspector.json.template` 复制到你的项目根目录，并重命名为 `.vimspector.json`：

```bash
cp ~/.vim/.vimspector.json.template /path/to/your/project/.vimspector.json
```

根据你的项目修改以下内容：
- `buildTarget`: 你的可执行文件名（默认：main）
- `buildType`: Debug 或 Release
- `program`: 可执行文件的完整路径

## 调试快捷键

| 按键 | 功能 |
|------|------|
| F8 | 运行到光标 |
| F9 | 开始/继续调试 |
| F10 | 单步跳过 |
| F11 | 单步进入 |
| F12 | 切换断点 |
| S-F3 | 停止调试 |
| S-F4 | 重启调试 |
| S-F8 | 添加函数断点 |
| S-F9 | 条件断点 |
| S-F10 | 单步跳出 |
| S-F11 | 单步信息 |
| g= | 悬浮求值 |

## 配置示例

### 基本 C++ 项目配置

```json
{
  "configurations": {
    "C++: Launch": {
      "adapter": "vscode-cpptools",
      "configuration": {
        "request": "launch",
        "program": "${workspaceRoot}/build/Debug/main.exe",
        "args": [],
        "stopAtEntry": false,
        "cwd": "${workspaceRoot}",
        "MIMode": "gdb"
      }
    }
  }
}
```

### 带命令行参数的配置

```json
{
  "configurations": {
    "C++: Launch with args": {
      "adapter": "vscode-cpptools",
      "configuration": {
        "request": "launch",
        "program": "${workspaceRoot}/build/Debug/main.exe",
        "args": ["arg1", "arg2", "--option"],
        "stopAtEntry": false,
        "cwd": "${workspaceRoot}",
        "MIMode": "gdb"
      }
    }
  }
}
```

### xmake 项目配置

```json
{
  "configurations": {
    "C++: xmake Launch": {
      "adapter": "vscode-cpptools",
      "variables": {
        "buildBeforeLaunch": {
          "shell": "xmake build"
        }
      },
      "configuration": {
        "request": "launch",
        "program": "${workspaceRoot}/build/windows/x64/debug/main.exe",
        "args": [],
        "stopAtEntry": false,
        "cwd": "${workspaceRoot}",
        "MIMode": "gdb"
      }
    }
  }
}
```

## 变量说明

vimspector 支持以下变量：

| 变量 | 说明 |
|------|------|
| `${workspaceRoot}` | 项目根目录 |
| `${file}` | 当前打开的文件完整路径 |
| `${fileDirname}` | 当前文件所在目录 |
| `${fileBasename}` | 当前文件名（含扩展名） |
| `${fileBasenameNoExtension}` | 当前文件名（不含扩展名） |
| `${command:pickProcess}` | 选择进程（用于 attach） |

## 常用 Vimspector 命令

| 命令 | 说明 |
|------|------|
| `:VimspectorInstall <adapter>` | 安装调试适配器 |
| `:VimspectorUninstall <adapter>` | 卸载调试适配器 |
| `:VimspectorReset` | 重置 vimspector |
| `:call vimspector#Launch()` | 启动调试 |
| `:call vimspector#Continue()` | 继续执行 |
| `:call vimspector#ToggleBreakpoint()` | 切换断点 |

## 注意事项

1. **编译时需要添加调试信息**：
   - 使用 MSVC: 添加 `/Zi` 或 `/Z7` 编译选项
   - 使用 GCC/Clang: 添加 `-g` 编译选项

2. **xmake 调试编译**：
   ```bash
   xmake config -m debug
   xmake build
   ```

3. **Windows 上的 GDB**：
   - 可以通过 MinGW 或 MSYS2 安装 GDB
   - 或者使用 Visual Studio 的调试器（需要配置 MIMode）

## 故障排除

### 问题：找不到 gdb.exe

**解决方案**：
- 确保 GDB 已安装并在 PATH 中
- 或者在配置中指定完整路径：
  ```json
  "miDebuggerPath": "C:/msys64/mingw64/bin/gdb.exe"
  ```

### 问题：无法启动调试

**解决方案**：
- 检查可执行文件路径是否正确
- 确保程序是用调试信息编译的
- 查看 `:messages` 中的错误信息

### 问题：断点不生效

**解决方案**：
- 确保使用调试信息编译（`-g` 或 `/Zi`）
- 检查源代码路径是否匹配
