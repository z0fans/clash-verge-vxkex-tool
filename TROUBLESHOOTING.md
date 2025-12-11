# VxKex 配置工具故障排除指南

## 📋 常见问题

### 问题 1: "软件可以成功安装,但 KexSetup 貌似没有被正确安装上"

#### 原因分析
VxKex 配置工具使用**静默安装**模式 (`/VERYSILENT /NORESTART`),这意味着:
- ✅ KexSetup 会在后台安装,不显示任何界面
- ✅ 安装过程没有可见的进度条或窗口
- ⚠️ 用户可能无法确认 VxKex 是否真正安装成功

#### 验证方法

##### 方法 1: 使用诊断工具 (推荐)

1. **双击运行** `VxKex-Diagnostic.bat` (需要管理员权限)

2. **查看诊断结果**,工具会检查:
   - VxKex 安装目录是否存在
   - VxKex 注册表项是否存在
   - Clash Verge 是否已配置 VxKex
   - VxKexLoader.dll 是否存在
   - 兼容性标志是否设置

3. **根据结果判断**:
   - ✅ 如果显示 "VxKex 已正确安装",说明安装成功
   - ❌ 如果显示 "VxKex 可能未正确安装",请参考下面的修复步骤

##### 方法 2: 手动检查

**检查 1: VxKex 安装目录**
```
路径: C:\Program Files\VxKex
      或 C:\Program Files (x86)\VxKex
```
打开文件资源管理器,查看上述目录是否存在。

**检查 2: VxKexLoader.dll**
```
路径: C:\Windows\System32\VxKexLoader.dll
```
确认此文件存在。

**检查 3: 注册表**
1. 按 `Win + R`,输入 `regedit`,打开注册表编辑器
2. 导航到: `HKEY_CURRENT_USER\Software\VXsoft\VxKex\Configured`
3. 查看是否有 `Clash Verge.exe` 相关的项

**检查 4: 兼容性标志**
1. 在注册表编辑器中,导航到:
   ```
   HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers
   ```
2. 查找 Clash Verge 的路径,值应包含 `VXKEX`

---

## 🔧 修复步骤

### 修复步骤 1: 使用手动安装工具

如果静默安装失败,可以尝试手动安装:

1. **双击运行** `VxKex-Manual-Install.bat` (需要管理员权限)

2. **选择安装模式**:
   - **选项 1 (推荐)**: 图形界面安装 - 可以看到完整的安装过程
   - **选项 2**: 静默安装 - 与自动配置工具相同

3. **完成安装后**:
   - 再次运行 `VxKex-Diagnostic.bat` 验证
   - 如果验证通过,运行 `ClashVerge-VxKex-Configurator.bat` 配置 Clash Verge

### 修复步骤 2: 直接运行 KexSetup 安装程序

1. 找到 `KexSetup_Release_1_1_2_1428.exe` 文件:
   ```
   位置: tools\vxkex-configurator\resources\KexSetup_Release_1_1_2_1428.exe
   ```

2. **右键点击** → **以管理员身份运行**

3. 按照安装向导完成安装

4. 安装完成后,运行 `ClashVerge-VxKex-Configurator.bat` 配置 Clash Verge

### 修复步骤 3: 检查系统环境

如果上述方法都失败,请检查:

#### 3.1 Windows 版本
确保您使用的是 **Windows 7 Service Pack 1** 或更高版本:
```
1. 右键点击"计算机" → 属性
2. 查看 Windows 版本和 Service Pack 信息
```

#### 3.2 .NET Framework
VxKex 可能需要 .NET Framework 3.5 或更高版本:
```
控制面板 → 程序和功能 → 启用或关闭 Windows 功能
→ 确保 ".NET Framework 3.5" 已勾选
```

#### 3.3 杀毒软件
某些杀毒软件可能会阻止 VxKex 安装:
```
1. 临时禁用杀毒软件
2. 重新运行安装工具
3. 完成后重新启用杀毒软件
```

#### 3.4 磁盘空间
确保系统盘有足够的空间 (至少 50 MB)

---

## 🧪 测试 VxKex 是否生效

### 测试方法 1: 启动 Clash Verge

1. 找到 Clash Verge 安装目录,通常在:
   ```
   C:\Program Files\Clash Verge\Clash Verge.exe
   或
   C:\Users\<用户名>\AppData\Local\Programs\Clash Verge\Clash Verge.exe
   ```

2. **双击启动** Clash Verge

3. **预期结果**:
   - ✅ **成功**: Clash Verge 正常启动,没有 `0xc0000005` 错误
   - ❌ **失败**: 仍然显示错误,参考下面的进阶故障排除

### 测试方法 2: 检查事件查看器

1. 按 `Win + R`,输入 `eventvwr.msc`,打开事件查看器

2. 导航到: **Windows 日志** → **应用程序**

3. 查找与 Clash Verge 或 VxKex 相关的错误日志

---

## 🔍 进阶故障排除

### 问题: Clash Verge 仍然无法启动

#### 可能原因 1: VxKex 配置未生效

**解决方案**:
1. 注销当前 Windows 用户
2. 重新登录
3. 再次尝试启动 Clash Verge

#### 可能原因 2: Clash Verge 路径配置错误

**解决方案**:
1. 打开注册表编辑器 (`regedit`)
2. 导航到: `HKCU\Software\VXsoft\VxKex\Configured`
3. 检查 `Clash Verge.exe` 的值是否为 `1`
4. 导航到: `HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers`
5. 检查 Clash Verge 完整路径是否存在,值应为 `~ WIN7RTM VXKEX`

**如果不存在或值不正确**,请手动添加/修改:
```
路径: HKCU\Software\VXsoft\VxKex\Configured
名称: Clash Verge.exe
类型: DWORD (32-bit)
值: 1

路径: HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers
名称: <Clash Verge 完整路径,如 C:\Program Files\Clash Verge\Clash Verge.exe>
类型: 字符串 (REG_SZ)
值: ~ WIN7RTM VXKEX
```

#### 可能原因 3: VxKex 与其他兼容性设置冲突

**解决方案**:
1. 右键点击 `Clash Verge.exe` → 属性
2. 切换到 "兼容性" 选项卡
3. **取消勾选**所有兼容性选项
4. 点击"确定"
5. 重新启动 Clash Verge

---

## 🆘 仍然无法解决?

如果尝试了所有方法仍然无法解决,请:

1. **运行诊断工具** `VxKex-Diagnostic.bat`,保存完整的输出结果

2. **收集以下信息**:
   - Windows 版本 (Win + Pause 查看)
   - Clash Verge 版本
   - 完整的错误信息或截图
   - VxKex 诊断工具的输出

3. **提交 Issue**:
   - 访问: https://github.com/clash-verge-rev/clash-verge-rev/issues
   - 创建新的 Issue,提供上述信息

---

## 📚 相关资源

- [VxKex 官方项目](https://github.com/i486/VxKex)
- [Clash Verge Rev 官方仓库](https://github.com/clash-verge-rev/clash-verge-rev)
- [原始问题讨论 Issue #1041](https://github.com/clash-verge-rev/clash-verge-rev/issues/1041)

---

## 📝 工具说明

### 提供的辅助工具

| 工具 | 说明 | 使用场景 |
|------|------|----------|
| `VxKex-Diagnostic.bat` | 诊断 VxKex 安装状态 | 验证 VxKex 是否正确安装 |
| `VxKex-Manual-Install.bat` | 手动安装 VxKex | 静默安装失败时使用 |
| `ClashVerge-VxKex-Configurator.bat` | 配置 Clash Verge | 安装 VxKex 并配置兼容性 |

### 运行顺序建议

1. **首次安装**: `ClashVerge-VxKex-Configurator.bat`
2. **验证安装**: `VxKex-Diagnostic.bat`
3. **手动修复**: `VxKex-Manual-Install.bat` (如需要)
4. **重新配置**: `ClashVerge-VxKex-Configurator.bat` (如需要)

---

**最后更新**: 2025-12-10
**适用版本**: VxKex Configurator v4.0.2+
