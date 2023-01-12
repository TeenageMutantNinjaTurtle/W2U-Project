from pathlib import Path
from sys import argv
import subprocess
import shutil

Wk = Path('data/a')
BuildDir = Path(argv[1])
VFS = []
NARCs = []
for Subdir in Wk.rglob('*/*/*'):
    if Subdir.is_dir():
        NARCPath = BuildDir / 'romfs' / Path(*Subdir.parts[1:])
        if NARCPath not in NARCs:
            VFS.append(Subdir)
            NARCs.append(NARCPath)

for NARC in NARCs:        
    ARCPath = Path(*NARC.parts[3:])
    P = BuildDir / 'narcs' / ARCPath
    P.mkdir(parents=True, exist_ok=True)
    subprocess.run(['tools/knarc/knarc', '-d', P, '-u', NARCPath])
    DataPath = 'data' / ARCPath
    for x in DataPath.glob('*'):
        shutil.copy(x, P / f'{DataPath.stem}_{str(x.stem).zfill(8)}.bin')
    subprocess.run(['tools/knarc/knarc', '-d', P, '-p', NARCPath])