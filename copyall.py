#!/usr/bin/python3

# TODO:
#   arm/rootfs-arm-m3
#   arm/rootfs-armv4
#   arm/rootfs-sa110
#   xtensa/rootfs-dc232b
#   xtensa/rootfs-dc233c
#   xtensa/rootfs-nommu

import argparse
import filecmp
import os
import subprocess

# imagedir = 'images-2023.02.4'

x=subprocess.run(["git", "describe"], capture_output=True, text=True)
imagedir="images-"+x.stdout.split('-')[0]

# rootfsdir = '/tmp/testdir'
rootfsdir = '/opt/buildbot/rootfs'

config = {
    'aarch64': { 'destdir': 'arm64',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.erofs': 'rootfs.erofs',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.f2fs.gz',
            'rootfs.squashfs': 'rootfs.squashfs'
        }
    },
    'aarch64be': { 'destdir': 'arm64be',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.erofs': 'rootfs.erofs',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.f2fs.gz',
            'rootfs.iso.gz': 'rootfs.iso.gz',
            'rootfs.squashfs': 'rootfs.squashfs'
        }
    },
    'alpha': { 'destdir': 'alpha',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
        }
    },
    'armv4': { 'destdir': 'arm',
        'files': {
            'rootfs.cpio.gz': 'rootfs-armv4.cpio.gz',
            'rootfs.ext2.gz': 'rootfs-armv4.ext2.gz',
            'rootfs.squashfs': 'rootfs-armv4.sqf'
        }
    },
    'armv5': { 'destdir': 'arm',
        'files': {
            'rootfs.btrfs.gz': 'rootfs-armv5.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs-armv5.cpio.gz',
            'rootfs.cramfs': 'rootfs-armv5.cramfs',
            'rootfs.ext2.gz': 'rootfs-armv5.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs-armv5.f2fs.gz',
            'rootfs.squashfs': 'rootfs-armv5.sqf'
        }
    },
    'armv7a': { 'destdir': 'arm',
        'files': {
            'rootfs.btrfs.gz': 'rootfs-armv7a.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs-armv7a.cpio.gz',
            'rootfs.cramfs': 'rootfs-armv7a.cramfs',
            'rootfs.erofs': 'rootfs-armv7a.erofs',
            'rootfs.ext2.gz': 'rootfs-armv7a.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs-armv7a.f2fs.gz',
        }
    },
    'i386': { 'destdir': 'x86',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.iso.gz': 'rootfs.iso.gz',
            'rootfs.squashfs': 'rootfs.squashfs'
        }
    },
    'loongarch64': { 'destdir': 'loongarch',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.btrfs.gz': 'rootfs.btrfs.gz',
            'rootfs.iso.gz': 'rootfs.iso.gz',
            'rootfs.squashfs': 'rootfs.squashfs',
        }
    },
    'm68k_q800': { 'destdir': 'm68k',
        'files': {
            'rootfs.cpio.gz': 'rootfs-68040.cpio.gz',
            'rootfs.cramfs': 'rootfs-68040.cramfs',
            'rootfs.ext2.gz': 'rootfs-68040.ext2.gz',
        }
    },
    'm68k_5208': { 'destdir': 'm68k',
        'files': {
            'rootfs.cpio.gz': 'rootfs-5208.cpio.gz',
            'rootfs.ext2.gz': 'rootfs-5208.ext2.gz',
        }
    },
    'microblaze': { 'destdir': 'microblaze',
        'files': {
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
        }
    },
    'microblazeel': { 'destdir': 'microblazeel',
        'files': {
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
        }
    },
    'mips': { 'destdir': 'mips',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.squashfs': 'rootfs.squashfs'
        }
    },
    'mipsel_r1': { 'destdir': 'mipsel',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs-mipselr1.ext2.gz',
            'rootfs.squashfs': 'rootfs.squashfs',
        }
    },
    'mipsel_r6': { 'destdir': 'mipsel',
        'files': {
            'rootfs.ext2.gz': 'rootfs-mipselr6.ext2.gz',
        }
    },
    'mips64_n32': { 'destdir': 'mips64',
        'files': {
            'rootfs.cpio.gz': 'rootfs-n32.cpio.gz',
            'rootfs.btrfs.gz': 'rootfs-n32.btrfs.gz',
            'rootfs.ext2.gz': 'rootfs-n32.ext2.gz',
        }
    },
    'mips64_n64': { 'destdir': 'mips64',
        'files': {
            'rootfs.cpio.gz': 'rootfs-n64.cpio.gz',
            'rootfs.btrfs.gz': 'rootfs-n64.btrfs.gz',
            'rootfs.ext2.gz': 'rootfs-n64.ext2.gz',
            'rootfs.squashfs': 'rootfs-n64.squashfs',
        }
    },
    'mipsel64r1_n32': { 'destdir': 'mipsel64',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.mipsel64r1_n32.btrfs.gz',
            'rootfs.ext2.gz': 'rootfs.mipsel64r1_n32.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.mipsel64r1_n32.f2fs.gz',
        }
    },
    'mipsel64r1_n64': { 'destdir': 'mipsel64',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.mipsel64r1_n64.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs.mipsel64r1_n64.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.mipsel64r1_n64.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.mipsel64r1_n64.f2fs.gz',
            'rootfs.iso.gz': 'rootfs.mipsel64r1_n64.iso.gz',
            'rootfs.squashfs': 'rootfs.mipsel64r1_n64.squashfs',
        }
    },
    'mipsel64r6_n32': { 'destdir': 'mipsel64',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.mipsel64r6_n32.btrfs.gz',
            'rootfs.erofs': 'rootfs.mipsel64r6_n32.erofs',
            'rootfs.ext2.gz': 'rootfs.mipsel64r6_n32.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.mipsel64r6_n32.f2fs.gz',
        }
    },
    'mipsel64r6_n64': { 'destdir': 'mipsel64',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.mipsel64r6_n64.btrfs.gz',
            'rootfs.erofs': 'rootfs.mipsel64r6_n64.erofs',
            'rootfs.ext2.gz': 'rootfs.mipsel64r6_n64.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.mipsel64r6_n64.f2fs.gz',
            'rootfs.iso.gz': 'rootfs.mipsel64r6_n64.iso.gz',
        }
    },
    'nios2': { 'destdir': 'nios2',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
        }
    },
    'openrisc': { 'destdir': 'openrisc',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
        }
    },
    'parisc': { 'destdir': 'parisc',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
        }
    },
    'ppc': { 'destdir': 'ppc',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.cramfs': 'rootfs.cramfs',
            'rootfs.erofs': 'rootfs.erofs',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.f2fs.gz',
        }
    },
    'ppc64': { 'destdir': 'ppc64',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.squashfs': 'rootfs.squashfs'
        }
    },
    'ppc64le': { 'destdir': 'ppc64',
        'files': {
            'rootfs.cpio.gz': 'rootfs-el.cpio.gz',
            'rootfs.ext2.gz': 'rootfs-el.ext2.gz',
            'rootfs.squashfs': 'rootfs-el.squashfs'
        }
    },
    'riscv32': { 'destdir': 'riscv32',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.iso.gz': 'rootfs.iso.gz',
        }
    },
    'riscv64': { 'destdir': 'riscv64',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
        }
    },
    's390x': { 'destdir': 's390',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.erofs': 'rootfs.erofs',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.f2fs.gz',
        }
    },
    'sh': { 'destdir': 'sh',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
        }
    },
    'sheb': { 'destdir': 'sheb',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
        }
    },
    'sparc': { 'destdir': 'sparc',
        'files': {
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.iso.gz': 'rootfs.iso.gz',
            'rootfs.squashfs': 'rootfs.sqf',
        }
    },
    'sparc64': { 'destdir': 'sparc64',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.iso.gz': 'rootfs.iso.gz',
            'rootfs.squashfs': 'rootfs.squashfs'
        }
    },
    'x86_64': { 'destdir': 'x86_64',
        'files': {
            'rootfs.btrfs.gz': 'rootfs.btrfs.gz',
            'rootfs.cpio.gz': 'rootfs.cpio.gz',
            'rootfs.erofs': 'rootfs.erofs',
            'rootfs.ext2.gz': 'rootfs.ext2.gz',
            'rootfs.f2fs.gz': 'rootfs.f2fs.gz',
            'rootfs.iso.gz': 'rootfs.iso.gz',
            'rootfs.squashfs': 'rootfs.squashfs'
        }
    },
    'xtensa_dc232b': { 'destdir': 'xtensa',
        'files': {
            'rootfs.cpio.gz': 'rootfs-dc232b.cpio.gz',
            'rootfs.ext2.gz': 'rootfs-dc232b.ext2.gz',
            'rootfs.squashfs': 'rootfs-dc232b.squashfs'
        }
    },
    'xtensa_dc233c': { 'destdir': 'xtensa',
        'files': {
            'rootfs.cpio.gz': 'rootfs-dc233c.cpio.gz',
            'rootfs.ext2.gz': 'rootfs-dc233c.ext2.gz',
        }
    },
    'xtensa_de212': { 'destdir': 'xtensa',
        'files': {
            'rootfs.cpio.gz': 'rootfs-nommu.cpio.gz',
        }
    }
}

def copyone(frompath, fromarch):
    c = config[fromarch]
    filelist = c['files']
    sourcedir = os.path.join(frompath, fromarch)
    destdir = os.path.join(rootfsdir, c['destdir'])

    if not os.path.isdir(destdir):
        print('Destination directory %s does not exist, can not copy files' % destdir)
        return

    if not os.path.isdir(sourcedir):
        print('Source directory %s does not exist, can not copy files' % sourcedir)
        return

    for fromfile in filelist:
        sourcepath = os.path.join(sourcedir, fromfile)
        destpath = os.path.join(destdir, filelist[fromfile])

        if not os.path.isfile(sourcepath):
            print('%s does not exist, can not copy file' % sourcepath)
            continue

        if not os.path.isfile(destpath):
            print('Warning: %s does not exist in %s' %
                  (filelist[fromfile], os.path.join(rootfsdir, c['destdir'])))
        elif filecmp.cmp(sourcepath, destpath):
            print('Skipping %s (no change)' % sourcepath)
            continue

        print('Copying %s' % sourcepath)

        cmd = ['cp', sourcepath, destpath]
        # print('copy command: ', cmd)
        result = subprocess.run(cmd, stderr=subprocess.DEVNULL)
        if result.returncode:
            print('Warning: Failed to copy %s to %s' % (frompath, destpath))
            continue
        workdir = os.getcwd()
        os.chdir(destdir)
        cmd = ['md5sum', filelist[fromfile]]
        # print('md5 command: ', cmd)
        md5sum = subprocess.check_output(cmd, stderr=subprocess.DEVNULL)
        # print('md5sum: ', md5sum)
        md5file = open(destpath + '.md5', 'w')
        md5file.write(md5sum.decode('utf-8'))
        md5file.close()
        os.chdir(workdir)


def copyall(basedir, architectures=list(config)):

    for arch in architectures:
        copyone(basedir, arch)


def architecture(arch):
    if arch not in config:
        raise ValueError('Unsupported architecture')
    return arch


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="copy buildroot file systems to target directory"
    )
    parser.add_argument(
        "architecture",
        type=architecture,
        nargs="*",
        help="Architecture(s) to copy.",
    )
    args = parser.parse_args()

    copyall(imagedir, args.architecture)
