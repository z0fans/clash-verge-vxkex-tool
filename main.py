#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Clash Verge VxKex 一键配置工具
自动安装 VxKex 并配置 Clash Verge Rev 在 Windows 7 上运行
"""

import os
import sys
import subprocess
import winreg
import ctypes
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
from pathlib import Path
import threading
import time


# 常量定义
VXKEX_SETUP = "KexSetup_Release_1_1_2_1428.exe"
TARGET_EXECUTABLES = [
    "Clash Verge.exe",
    "resources\\clash-verge-service.exe",
    "resources\\install-service.exe",
    "resources\\uninstall-service.exe",
]

IFEO_BASE = r"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
VXKEX_DLL = "VxKexLdr.dll"


def is_admin():
    """检查是否以管理员权限运行"""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False


def run_as_admin():
    """请求管理员权限重新启动"""
    try:
        if sys.argv[0].endswith('.py'):
            # 如果是脚本，使用 python.exe
            params = ' '.join([sys.argv[0]] + sys.argv[1:])
            ctypes.windll.shell32.ShellExecuteW(
                None, "runas", sys.executable, params, None, 1
            )
        else:
            # 如果是打包的 exe
            params = ' '.join(sys.argv[1:])
            ctypes.windll.shell32.ShellExecuteW(
                None, "runas", sys.executable, params, None, 1
            )
        sys.exit(0)
    except Exception as e:
        messagebox.showerror("错误", f"无法获取管理员权限: {e}")
        sys.exit(1)


def get_resource_path(relative_path):
    """获取资源文件路径（支持 PyInstaller 打包）"""
    try:
        # PyInstaller 创建临时文件夹，路径存储在 _MEIPASS 中
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(os.path.dirname(__file__))

    return os.path.join(base_path, relative_path)


def check_vxkex_installed():
    """检查 VxKex 是否已安装"""
    # 方法 1: 检查系统目录中的 DLL
    system32 = os.path.join(os.environ.get('SystemRoot', 'C:\\Windows'), 'System32')
    vxkex_dll_path = os.path.join(system32, VXKEX_DLL)

    if os.path.exists(vxkex_dll_path):
        return True

    # 方法 2: 检查注册表
    try:
        key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\VxKex")
        winreg.CloseKey(key)
        return True
    except:
        pass

    return False


def install_vxkex(progress_callback=None):
    """安装 VxKex"""
    setup_path = get_resource_path(f"resources\\{VXKEX_SETUP}")

    if not os.path.exists(setup_path):
        raise FileNotFoundError(f"找不到 VxKex 安装包: {setup_path}")

    if progress_callback:
        progress_callback("正在启动 VxKex 安装程序...")

    # 静默安装参数
    # /VERYSILENT - 完全静默
    # /SUPPRESSMSGBOXES - 抑制消息框
    # /NORESTART - 不重启
    cmd = [setup_path, "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART"]

    if progress_callback:
        progress_callback("请稍候，安装中...（约需 1-2 分钟）")

    # 执行安装
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    process.wait()

    # 等待安装完成
    time.sleep(3)

    # 验证安装
    if not check_vxkex_installed():
        raise Exception("VxKex 安装失败，请手动安装")

    if progress_callback:
        progress_callback("VxKex 安装完成！")


def find_clash_verge_path():
    """自动检测 Clash Verge 安装路径"""
    possible_paths = []

    # 从注册表读取
    try:
        key = winreg.OpenKey(
            winreg.HKEY_LOCAL_MACHINE,
            r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Clash Verge"
        )
        install_location, _ = winreg.QueryValueEx(key, "InstallLocation")
        winreg.CloseKey(key)
        if install_location:
            possible_paths.append(install_location)
    except:
        pass

    # 常见安装位置
    possible_paths.extend([
        r"C:\Program Files\Clash Verge",
        r"C:\Program Files (x86)\Clash Verge",
        os.path.join(os.environ.get('LOCALAPPDATA', ''), 'Clash Verge'),
        os.path.join(os.environ.get('USERPROFILE', ''), 'AppData', 'Local', 'Clash Verge'),
    ])

    # 检查哪个路径存在
    for path in possible_paths:
        if os.path.exists(path) and os.path.exists(os.path.join(path, "Clash Verge.exe")):
            return path

    return None


def configure_vxkex(install_path, progress_callback=None):
    """配置 VxKex 到 Clash Verge"""
    if not os.path.exists(install_path):
        raise FileNotFoundError(f"安装路径不存在: {install_path}")

    success_count = 0
    failed_files = []

    for exe_name in TARGET_EXECUTABLES:
        full_path = os.path.join(install_path, exe_name)

        if not os.path.exists(full_path):
            if progress_callback:
                progress_callback(f"跳过不存在的文件: {exe_name}")
            continue

        exe_basename = os.path.basename(exe_name)

        if progress_callback:
            progress_callback(f"正在配置: {exe_basename}")

        try:
            # 创建 IFEO 注册表项
            key_path = f"{IFEO_BASE}\\{exe_basename}"
            key = winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, key_path)

            # 设置 VerifierDlls
            winreg.SetValueEx(key, "VerifierDlls", 0, winreg.REG_SZ, VXKEX_DLL)

            # 设置 GlobalFlag
            winreg.SetValueEx(key, "GlobalFlag", 0, winreg.REG_DWORD, 0x100)

            # 禁用子进程 VxKex
            try:
                winreg.SetValueEx(key, "DisableChildVxKex", 0, winreg.REG_DWORD, 1)
            except:
                pass  # 某些版本可能不支持

            winreg.CloseKey(key)
            success_count += 1

            if progress_callback:
                progress_callback(f"✓ 配置成功: {exe_basename}")

        except Exception as e:
            failed_files.append(f"{exe_basename}: {e}")
            if progress_callback:
                progress_callback(f"✗ 配置失败: {exe_basename}")

    if failed_files:
        raise Exception(f"部分文件配置失败:\n" + "\n".join(failed_files))

    return success_count


class VxKexConfiguratorGUI:
    """GUI 主类"""

    def __init__(self, root):
        self.root = root
        self.root.title("Clash Verge VxKex 一键配置工具")
        self.root.geometry("550x400")
        self.root.resizable(False, False)

        # 设置图标（如果存在）
        try:
            icon_path = get_resource_path("resources\\icon.ico")
            if os.path.exists(icon_path):
                self.root.iconbitmap(icon_path)
        except:
            pass

        self.install_path = None
        self.create_widgets()

        # 自动检测
        self.root.after(500, self.auto_detect)

    def create_widgets(self):
        """创建界面组件"""
        # 标题
        title_frame = tk.Frame(self.root, bg="#2196F3", height=60)
        title_frame.pack(fill=tk.X)
        title_frame.pack_propagate(False)

        title_label = tk.Label(
            title_frame,
            text="Clash Verge VxKex 一键配置工具",
            font=("微软雅黑", 16, "bold"),
            bg="#2196F3",
            fg="white"
        )
        title_label.pack(expand=True)

        # 主内容区
        main_frame = tk.Frame(self.root, padx=20, pady=20)
        main_frame.pack(fill=tk.BOTH, expand=True)

        # VxKex 状态
        status_frame = tk.LabelFrame(main_frame, text="环境检查", font=("微软雅黑", 10), padx=10, pady=10)
        status_frame.pack(fill=tk.X, pady=(0, 10))

        self.vxkex_status_label = tk.Label(
            status_frame,
            text="VxKex 状态: 检查中...",
            font=("微软雅黑", 9),
            anchor="w"
        )
        self.vxkex_status_label.pack(fill=tk.X)

        # 安装路径
        path_frame = tk.LabelFrame(main_frame, text="Clash Verge 安装路径", font=("微软雅黑", 10), padx=10, pady=10)
        path_frame.pack(fill=tk.X, pady=(0, 10))

        path_input_frame = tk.Frame(path_frame)
        path_input_frame.pack(fill=tk.X)

        self.path_var = tk.StringVar()
        self.path_entry = tk.Entry(
            path_input_frame,
            textvariable=self.path_var,
            font=("微软雅黑", 9),
            state="readonly"
        )
        self.path_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 5))

        browse_btn = tk.Button(
            path_input_frame,
            text="浏览...",
            command=self.browse_path,
            font=("微软雅黑", 9)
        )
        browse_btn.pack(side=tk.LEFT)

        # 进度显示
        progress_frame = tk.LabelFrame(main_frame, text="操作进度", font=("微软雅黑", 10), padx=10, pady=10)
        progress_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))

        self.progress_text = tk.Text(
            progress_frame,
            height=8,
            font=("Consolas", 9),
            wrap=tk.WORD,
            state="disabled"
        )
        self.progress_text.pack(fill=tk.BOTH, expand=True)

        # 按钮区
        button_frame = tk.Frame(main_frame)
        button_frame.pack(fill=tk.X)

        self.start_btn = tk.Button(
            button_frame,
            text="一键启用 VxKex",
            command=self.start_configuration,
            font=("微软雅黑", 11, "bold"),
            bg="#4CAF50",
            fg="white",
            activebackground="#45a049",
            height=2,
            cursor="hand2"
        )
        self.start_btn.pack(fill=tk.X)

    def log(self, message):
        """添加日志"""
        self.progress_text.config(state="normal")
        self.progress_text.insert(tk.END, f"{message}\n")
        self.progress_text.see(tk.END)
        self.progress_text.config(state="disabled")
        self.root.update()

    def auto_detect(self):
        """自动检测环境"""
        self.log("正在检测环境...")

        # 检查 VxKex
        if check_vxkex_installed():
            self.vxkex_status_label.config(text="VxKex 状态: ✓ 已安装", fg="green")
            self.log("✓ VxKex 已安装")
        else:
            self.vxkex_status_label.config(text="VxKex 状态: ✗ 未安装（将自动安装）", fg="orange")
            self.log("⚠ VxKex 未安装，将在配置时自动安装")

        # 检测安装路径
        path = find_clash_verge_path()
        if path:
            self.path_var.set(path)
            self.install_path = path
            self.log(f"✓ 找到 Clash Verge 安装路径: {path}")
        else:
            self.log("⚠ 未找到 Clash Verge 安装路径，请手动选择")

    def browse_path(self):
        """浏览选择路径"""
        path = filedialog.askdirectory(title="选择 Clash Verge 安装目录")
        if path:
            if os.path.exists(os.path.join(path, "Clash Verge.exe")):
                self.path_var.set(path)
                self.install_path = path
                self.log(f"✓ 已选择路径: {path}")
            else:
                messagebox.showerror("错误", "所选目录不是有效的 Clash Verge 安装目录")

    def start_configuration(self):
        """开始配置"""
        if not self.install_path:
            messagebox.showerror("错误", "请先选择 Clash Verge 安装路径")
            return

        # 禁用按钮
        self.start_btn.config(state="disabled", text="配置中...")

        # 在新线程中执行
        thread = threading.Thread(target=self.run_configuration)
        thread.daemon = True
        thread.start()

    def run_configuration(self):
        """执行配置流程"""
        try:
            # 1. 检查并安装 VxKex
            if not check_vxkex_installed():
                self.log("\n=== 安装 VxKex ===")
                install_vxkex(self.log)
                self.log("✓ VxKex 安装完成")
                self.vxkex_status_label.config(text="VxKex 状态: ✓ 已安装", fg="green")

            # 2. 配置 Clash Verge
            self.log("\n=== 配置 Clash Verge ===")
            count = configure_vxkex(self.install_path, self.log)

            # 3. 完成
            self.log(f"\n{'='*50}")
            self.log(f"✓ 配置完成！成功配置了 {count} 个可执行文件")
            self.log(f"{'='*50}")
            self.log("\n现在可以正常启动 Clash Verge 了！")

            messagebox.showinfo(
                "配置完成",
                f"✓ 已成功为 {count} 个文件配置 VxKex\n\n现在可以正常启动 Clash Verge 了！"
            )

        except Exception as e:
            self.log(f"\n✗ 错误: {e}")
            messagebox.showerror("配置失败", f"配置过程中出现错误:\n\n{e}")

        finally:
            # 恢复按钮
            self.start_btn.config(state="normal", text="一键启用 VxKex")


def main():
    """主函数"""
    # 检查管理员权限
    if not is_admin():
        messagebox.showwarning(
            "需要管理员权限",
            "此工具需要管理员权限才能修改注册表。\n\n点击确定后将请求管理员权限。"
        )
        run_as_admin()
        return

    # 创建 GUI
    root = tk.Tk()
    app = VxKexConfiguratorGUI(root)
    root.mainloop()


if __name__ == "__main__":
    main()
