project('White2Upgrade', 'cpp', version: '0.0.1')

fs = import('fs')
incdir = include_directories('include')

cpp_args = [
    '-mthumb',
    '-march=armv5t',
    '-mno-thumb-interwork',
    '-mno-long-calls',
    '-r',
    '-nostdinc++',
    '-Os',
    '-fno-exceptions',
    '-fno-rtti',
    '-fno-unwind-tables',
    '-fno-asynchronous-unwind-tables',
    '-DW2U_ENABLE_GEN6_BATTLE_ITEMS=1'
]

asm_args = [
    '-mthumb',
    '-march=armv5t',
    '-r'
]

# Tools
subdir('tools')

# Custom code patches.  
subdir('src')

# Assets
subdir('data')

black2_package_builder = meson.project_source_root() / 'tools' / 'build_black2upgrade_package.py'
black2_clean_rom = meson.project_source_root() / get_option('black2_base_rom')
black2_clean_w2_rom = meson.project_source_root() / '..' / 'Port-Pokeweb' / 'cleanwhite2.nds'

black2upgrade_data_package = custom_target(
  'black2upgrade-data-package',
  input: [black2_clean_rom, black2_clean_w2_rom],
  output: ['black2upgrade-data.tar.gz', 'black2upgrade-package-manifest.json'],
  depends: vfs_files,
  depend_files: [
    black2_package_builder,
    meson.project_source_root() / 'tools' / 'text' / 'gen5_text.py',
    meson.project_source_root() / 'tools' / 'item_icons' / 'build_item_icon_patch.py',
    meson.project_source_root() / 'assets' / 'move_backgrounds' / 'terrains' / 'battle-background-floor-targets.csv',
  ],
  command: [
    'python3', black2_package_builder,
    '--clean-b2', '@INPUT0@',
    '--clean-w2', '@INPUT1@',
    '--vfs', meson.project_source_root() / 'vfs' / 'data',
    '--root', meson.project_source_root(),
    '--output', '@OUTPUT0@',
    '--manifest-output', '@OUTPUT1@',
    '--expanded-files', meson.project_build_root() / 'black2upgrade-expanded-files',
  ],
)

black2upgrade_release_artifacts = custom_target(
  'stage_black2upgrade_release_artifacts',
  input: [black2upgrade_data_package],
  output: 'black2upgrade-release-artifacts.stamp',
  command: ['sh', '-eu', '-c', '''
    package="$1"
    manifest="$2"
    out_dir="$3"
    stamp="$4"
    mkdir -p "$out_dir"
    cp "$package" "$out_dir/black2upgrade-data.tar.gz"
    cp "$manifest" "$out_dir/black2upgrade-package-manifest.json"
    shasum -a 256 "$package" > "$out_dir/black2upgrade-data.tar.gz.sha256"
    touch "$stamp"
  ''',
    'stage_black2upgrade_release_artifacts',
    '@INPUT@',
    meson.project_build_root() / 'black2upgrade-artifacts',
    '@OUTPUT@',
  ],
)

item_icon_patch_py = find_program(meson.project_source_root() / 'tools' / 'item_icons' / 'build_item_icon_patch.py', native: true)
patch_pmc_sysheap_py = find_program(meson.project_source_root() / 'tools' / 'patch_pmc_sysheap.py', native: true)

item_icon_asset_list = run_command(
  'sh',
  '-c',
  'cd "$1" && find assets/item_icons -type f \( -name "*.png" -o -name "*.pal" \) | sort',
  'find_item_icon_assets',
  meson.project_source_root(),
  check: true,
).stdout().strip()

item_icon_assets = []
foreach item_icon_asset : item_icon_asset_list.split('\n')
  if item_icon_asset != ''
    item_icon_assets += meson.project_source_root() / item_icon_asset
  endif
endforeach

pmc_arm9 = custom_target(
  'pmc_arm9',
  input: meson.project_source_root() / 'pmc' / 'ARM9PMC.bin',
  depend_files: item_icon_assets,
  output: 'pmc_arm9.stamp',
  command: [
    item_icon_patch_py,
    '--arm9-input', '@INPUT@',
    '--arm9-output', meson.project_source_root() / 'vfs' / 'arm9.bin',
    '--vfs-output-dir', meson.project_source_root() / 'vfs' / 'data' / 'a' / '0' / '2' / '5',
    '--icons', meson.project_source_root() / 'assets' / 'item_icons' / 'icons',
    '--palettes', meson.project_source_root() / 'assets' / 'item_icons' / 'icon_palettes',
    '--base-icon-archive', meson.project_source_root() / '..' / 'IRDO_Extracted' / 'data' / 'a' / '0' / '2' / '5',
    '--report', meson.project_build_root() / 'item_icon_patch_report.json',
    '--stamp', '@OUTPUT@',
  ],
)

pmc_overlay = custom_target(
  'pmc_overlay',
  input: meson.project_source_root() / 'pmc' / 'OVL344.bin',
  output: 'pmc_overlay.stamp',
  # The real output is staged in the source-tree VFS. Re-run this cheap copy so
  # a changed or corrupted staged overlay cannot bypass the stamp dependency.
  build_always_stale: true,
  command: [
    patch_pmc_sysheap_py,
    '--input', '@INPUT@',
    '--output', meson.project_source_root() / 'vfs' / 'overlay' / 'overlay_0344.bin',
    '--stamp', '@OUTPUT@',
  ],
)

pmc_symbols = custom_target(
  'pmc_symbols',
  input: meson.project_source_root() / 'pmc' / 'RPMSYM-PMC.rpm',
  output: 'pmc_symbols.stamp',
  command: ['sh', '-eu', '-c', '''
    input="$1"
    output="$2"
    stamp="$3"

    mkdir -p "$(dirname "$output")"
    cp "$input" "$output"
    touch "$stamp"
  ''',
    'stage_pmc_symbols',
    '@INPUT@',
    meson.project_source_root() / 'vfs' / 'data' / 'data' / 'codeinjection' / 'RPMSYM-PMC.rpm',
    '@OUTPUT@',
  ],
)
  
# The ROM itself, assembled by insistence-tools' ds-rom backend from a
# ds-rom extraction of the clean ROM plus this tree's vfs overlay.
insistence_manifest = meson.project_source_root() / '..' / 'insistence-tools' / 'Cargo.toml'
white2_clean_rom = meson.project_source_root() / get_option('white2_base_rom')
dsrom_base = custom_target(
  'dsrom_base',
  input: white2_clean_rom,
  output: 'dsrom_base.stamp',
  command: ['sh', '-eu', '-c',
    'cargo run --release -q --manifest-path "$1" -- rom extract --rom "$2" --out "$3" && touch "$4"',
    'dsrom_base',
    insistence_manifest,
    '@INPUT@',
    meson.project_build_root() / 'dsrom-base',
    '@OUTPUT@',
  ],
)

# insistence-tools' own archives (zones, maps, scripts, text, trainers, ...)
# are staged on top of this tree's vfs after every W2U data target has run,
# so nothing here repacks them away again.
insistence_stage = custom_target(
  'insistence_stage',
  input: [vfs_files, w2u_main_patch, w2u_battle_module_stage, pwan_runtime_patch, pmc_arm9, pmc_overlay, pmc_symbols],
  output: 'insistence_stage.stamp',
  build_always_stale: true,
  command: ['sh', '-eu', '-c',
    'cargo run --release -q --manifest-path "$1" -- --rom-dir "$2" build "$3" --vfs "$4" && touch "$5"',
    'insistence_stage',
    insistence_manifest,
    meson.project_source_root() / '..' / 'IRDO_Extracted',
    meson.project_source_root() / '..' / 'data' / 'project.toml',
    meson.project_source_root() / 'vfs',
    '@OUTPUT@',
  ],
)

rom = custom_target('White2Upgrade.nds',
  output: 'White2Upgrade.nds',
  input: [
    insistence_stage,
    dsrom_base,
  ],
  command: ['sh', '-eu', '-c',
    'cargo run --release -q --manifest-path "$1" -- rom build --base "$2" --vfs "$3" --work "$4" --out "$5"',
    'rombuild',
    insistence_manifest,
    meson.project_build_root() / 'dsrom-base',
    meson.project_source_root() / 'vfs',
    meson.project_build_root() / 'dsrom-work',
    '@OUTPUT@',
  ],
)
