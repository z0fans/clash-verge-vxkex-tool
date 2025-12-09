# -*- mode: python ; coding: utf-8 -*-
"""
PyInstaller 打包配置文件
使用方法: pyinstaller build.spec
"""

from PyInstaller.utils.hooks import collect_dynamic_libs, collect_data_files
import sys
import os
import glob

block_cipher = None

# 使用 PyInstaller 的内置功能收集所有 ctypes 相关的二进制文件
binaries = []
datas = []

# 手动收集 Python DLLs 目录中的关键 DLL 文件
python_dir = os.path.dirname(sys.executable)
dlls_dir = os.path.join(python_dir, 'DLLs')

print(f"Python directory: {python_dir}")
print(f"DLLs directory: {dlls_dir}")

# 收集所有可能需要的 DLL
dll_patterns = [
    'libffi*.dll',
    'ffi*.dll',
    '_ctypes*.pyd',
    '_tkinter*.pyd',
    'tcl*.dll',
    'tk*.dll',
]

if os.path.exists(dlls_dir):
    for pattern in dll_patterns:
        for dll_file in glob.glob(os.path.join(dlls_dir, pattern)):
            binaries.append((dll_file, '.'))
            print(f"Found and including: {dll_file}")

# 也搜索 Python 根目录
for pattern in dll_patterns:
    for dll_file in glob.glob(os.path.join(python_dir, pattern)):
        binaries.append((dll_file, '.'))
        print(f"Found and including: {dll_file}")

# 收集 _ctypes 相关的所有动态库 (作为补充)
try:
    ctypes_binaries = collect_dynamic_libs('_ctypes')
    if ctypes_binaries:
        binaries.extend(ctypes_binaries)
        print(f"Collected {len(ctypes_binaries)} _ctypes binaries via collect_dynamic_libs")
except Exception as e:
    print(f"Warning: Could not collect _ctypes binaries: {e}")

# 收集 tkinter 相关的二进制文件
try:
    tkinter_binaries = collect_dynamic_libs('tkinter')
    if tkinter_binaries:
        binaries.extend(tkinter_binaries)
        print(f"Collected {len(tkinter_binaries)} tkinter binaries via collect_dynamic_libs")
except Exception as e:
    print(f"Warning: Could not collect tkinter binaries: {e}")

print(f"Total binaries to include: {len(binaries)}")

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=binaries,
    datas=[
        ('resources/KexSetup_Release_1_1_2_1428.exe', 'resources'),
        # 如果有图标文件，取消下面的注释
        # ('resources/icon.ico', 'resources'),
    ],
    hiddenimports=[
        'tkinter',
        'tkinter.ttk',
        'tkinter.messagebox',
        'tkinter.filedialog',
        '_tkinter',
        'ctypes',
        'ctypes.wintypes',
        '_ctypes',
        'ctypes.util',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='ClashVerge-VxKex-Configurator',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,  # 不显示控制台窗口
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    # 设置图标（如果有）
    # icon='resources/icon.ico',
    # 设置 Windows 清单，请求管理员权限
    uac_admin=True,
    uac_uiaccess=False,
    # Windows 7 兼容性设置
    manifest='''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
  <assemblyIdentity
    version="1.0.0.0"
    processorArchitecture="*"
    name="ClashVerge-VxKex-Configurator"
    type="win32"
  />
  <description>Clash Verge VxKex Configuration Tool</description>
  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
    <security>
      <requestedPrivileges>
        <requestedExecutionLevel level="requireAdministrator" uiAccess="false"/>
      </requestedPrivileges>
    </security>
  </trustInfo>
  <compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1">
    <application>
      <!-- Windows 7 -->
      <supportedOS Id="{35138b9a-5d96-4fbd-8e2d-a2440225f93a}"/>
      <!-- Windows 8 -->
      <supportedOS Id="{4a2f28e3-53b9-4441-ba9c-d69d4a4a6e38}"/>
      <!-- Windows 8.1 -->
      <supportedOS Id="{1f676c76-80e1-4239-95bb-83d0f6d0da78}"/>
      <!-- Windows 10 -->
      <supportedOS Id="{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}"/>
    </application>
  </compatibility>
  <dependency>
    <dependentAssembly>
      <assemblyIdentity
        type="win32"
        name="Microsoft.Windows.Common-Controls"
        version="6.0.0.0"
        processorArchitecture="*"
        publicKeyToken="6595b64144ccf1df"
        language="*"
      />
    </dependentAssembly>
  </dependency>
</assembly>''',
)
