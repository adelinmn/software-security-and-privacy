# Application Confinement

We discuss solutions for confining (isolating) applications for damage
control: in case an application is compromised the damage done must be
limited.

Slides for this session:

- [handout](http://elf.cs.pub.ro/sis/res/07-application-confinement-handout.pdf)
  - [handout_4on1_notes](http://elf.cs.pub.ro/sis/res/07-application-confinement-handout-4on1-notes.pdf)
  - [handout_8on1](http://elf.cs.pub.ro/sis/res/07-application-confinement-handout-8on1.pdf)

## Tasks

Download the [session task
archive](http://elf.cs.pub.ro/sis/res/07-app-confine.tar).

1. Access the `shellcode/` subfolder. We assume a shellcode is injected
    maliciously inside an executable and we want to use different
    mechanisms to protect it. To simplify things we add the shellcode in
    the source code and compile it to execute the shellcode.

    There are two subfolders: `generate-shellcode/` for generating a
    shellcode and `run-shellcode/` for running a shellcode inside an
    executable. Use `make print` in `generate-shellcode/` to generate
    the shellcode. It is part of the `shellcode` array in `exec.c` in
    `run-shellcode/`.

    Test what it does by running `strace ./exec` in
    `generate-shellcode`.

    Inspect the shellcode implementation in `shellcode.asm`. Update the
    shellcode to **also** open the two files from `../../jail/a.txt` and
    `../../b.txt` using the `open` system call: the first argument (in
    `ebx`) is a pointer to the string denoting the filename, the second
    argument (in `ecx`) is `O_RDONLY` (see its numeric value in
    `/usr/include/bits/fcntl-linux.h`).

    Generate the new shellcode (using `make print`), replace it in
    `exec.c`, recompile the `exec` executable, and then test it again by
    running `strace ./vuln`.

1. Let's use AppArmor to allow the `exec` executable from the previous
    task to open the `a.txt` file, but not the `b.txt` file (i.e. the
    first `open` system call in the shellcode will succeed, but the
    second `open` system call will fail).

    AppArmor needs to be installed on your system. 
    If you have trouble installing it, use [this Debian virtual machine](http://repository.grid pub.ro/cs/uso/USO%20Demo.ova). 
    Use the `cs.curs.pub.ro` account to download it.

    Follow the [Debian AppArmor HowToUse instructions](https://wiki.debian.org/AppArmor/HowToUse). Use the file
    `/etc/default/grub` for configuring GRUB.
    **Do not use** `/etc/default/grub.d/apparmor.cfg` as shown in the page.

    Create a profile for `exec` in `/etc/apparmor.d/` to allow the `exec` executable to access `a.txt` but prevent it from accessing `b.txt`. 
    Start from the `bin.ping` profile. 
    You need to use full paths.

    At any point you can use `ps -efZ` to see what processes are
    confined.

1. Now we want to use `chroot` to allow the program to access
    `../jail/a.txt` but prevent it from accessing `../b.txt`.

    Access the `chroot/` subfolder. Go into the `exec` executable and
    update the `A_PATH` and `B_PATH` macros for full paths to `a.txt`
    and `b.txt`. Compile the `exec` executable and run it under `chroot`
    in the `../jail/` folder.

    In order to run an executable inside a folder as a chroot jail run:

    ```text
    sudo chroot ../jail/ ./exec
    ```

    The executable `exec` has to be part of the jail.
    All required files (including library files) need to be inside the jail. `a.txt` is
    already part of the jail. Use `ldd exec` to determine the library
    files required by the executable. You need to copy them full paths
    inside the jail.

    After a successful run in the chroot jail, the `exec` program will
    open the `a.txt` file but not the `b.txt` file.

1. Now we want to use sandboxing (`seccomp`) to allow the program to
    open the `../jail/a.txt` file, but not the `../b.txt` file.

    Access the `seccomp/` subfolder. Inspect the `exec.c` file and see
    what it does and what calls should succeed or not. Compile it using
    `make`. Run `strace ./exec` and see what calls are allowed and what
    calls are not allowed.

    Update the `exec.c` file to enforce and check that read and write is
    allowed to the `a.txt` file, but only read is allowed to the `b.txt`
    file.

    You need the `libseccomp-dev:i386` installed on the system. To
    install it run:

    ```text
    sudo apt install gcc-multilib libseccomp-dev:i386
    ```

    **Bonus**: Update the `exec.c` program to invoke the `read` and
    `write` system calls from inside a shellcode, similar to way its
    done in the `shellcode/run-shellcode/exec.c`.