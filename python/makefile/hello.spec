# -*- mode: python -*-

block_cipher = None


a = Analysis(['..\\hello.py'],
             pathex=['c:/python27', 'D:\\github\\scripts\\python\\makefile'],
             binaries=[],
             datas=[],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='hello',
          debug=True,
          strip=False,
          upx=True,
          runtime_tmpdir=None,
          console=True , icon='a.ico')
