# Defense and Mitigation

We discuss defense and mitigation techniques and ways of bypassing them.

Slides for this session:

- [handout](http://elf.cs.pub.ro/sis/res/05-defense-handout.pdf)
  - [handout_4on1_notes](http://elf.cs.pub.ro/sis/res/05-defense-handout-4on1-notes.pdf)
  - [handout_8on1](http://elf.cs.pub.ro/sis/res/05-defense-handout-8on1.pdf)

## Tasks

Download the [session task
archive](http://elf.cs.pub.ro/sis/res/05-defense.tar).

1. Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/05-defense.tar) and access the
    `use-shellcode/` subfolder. This task is already solved.
    Disassemble
    the `vuln` executable, see where the buffer overflow
    happens and what is the offset from the buffer start to the return
    address. The executable is compiled with the `-zexecstack
    option` such that the stack is executable and we can
    inject binary code.

    The `exploit.py` script exploits the current executable
    and gets you a shell; the script crafts a shellcode and then injects
    it in the buffer and then overwrites the return address with the
    start of the buffer. The script has to be run into a non-ASLR
    environment. In order to create that, run the command below to
    create a non-ASLR shell:

    ```text
    setarch $(uname -m) -R /bin/bash
    ```

    As you can't really know the precise address of the buffer, we use
    `NOP` instructions as padding in the buffer and we have
    to do a bit of randomizing to guess the start address of the buffer.
    This is because, although ASLR is disabled, the buffer address is
    affected by the environment.
    So we have to do a bit of matching. For
    that you have to change the first 5 nibbles (hexadecimal digits) in
    line `32` in `exploit.py` from
    `0xffffd` to the likely address. For that to happen,
    find the buffer address in GDB:

    ```text
    razvan@einherjar:~/.../tasks/src/use-shellcode$ gdb -q ./vuln
    Reading symbols from ./vuln...done.
    gdb-peda$ start
    [...]
    gdb-peda$ b reader
    Breakpoint 2 at 0x804849c: file vuln.c, line 8.
    gdb-peda$ c
    Continuing.
    Greetings, your liege!
    [...]
    Breakpoint 2, reader () at vuln.c:8
    8     printf("gimme message: ");
    gdb-peda$ p $esp
    $1 = (void *) 0xffffcf70
    ```

    The last value (`0xffffcf70`) is the approximate value
    of the buffer (that's where the stack pointer is after the prologue
    of the `reader` function). As the stack is likely larger
    in GDB (`0xffffcf70`) we use a slightly lower address in
    the `exploit.py` script (`0xffffd000`).

    **Update** line `32` in the `exploit.py`
    script with the proper value from the GDB inspection.

    Now run the script and wait a bit for it to jump to the proper
    address on the stack (through randomization), same as below. It
    should take no more than 2-3 minutes.

    ```text
    razvan@einherjar:~/.../tasks/src/use-shellcode$ python exploit.py
    [+] Starting local process './vuln': Done
    Using address 0xffffd8b0
    [*] Process './vuln' stopped with exit code -11
    [...]
    [+] Starting local process './vuln': Done
    Using address 0xffffdbe0
    [*] Process './vuln' stopped with exit code -11
    [+] Starting local process './vuln': Done
    Using address 0xffffd5f0
    [*] Process './vuln' stopped with exit code -11
    [+] Starting local process './vuln': Done
    Using address 0xffffd040
    [*] Switching to interactive mode
    $ ls
    Makefile  core    exploit.py  vuln  vuln.c  vuln.o
    ```

1. Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/05-defense.tar) and access the
    `bypass-dep/` subfolder. Disassemble the `vuln`
    executable, see where the buffer overflow happens and what is the
    offset from the buffer start to the return address. The system is
    using DEP (*Data Execution Prevention*) and you cannot inject a
    shellcode. However we assume the executable runs on a non-ASLR
    environment. In order to create that, run the command below to
    create a non-ASLR shell:

    ```text
    setarch $(uname -m) -R /bin/bash
    ```

    Now you can create a shell by following the below steps:

1. Use the skeleton in the `exploit.py` script.
1. Use GDB to determine the address of the `system()`
    function.
1. Use GDB to determine the address of the
    `"/bin/sh"` (or just the `"sh"`)
    string.
1. Use the above information to craft a payload in
    `exploit.py` that manages to overwrite the return
    address of the `reader()` function and call
    `system("/bin/sh")` or
    `system("sh")`.

    This is a *return-to-libc* attack.

1. Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/05-defense.tar) and access the
    `bypass-aslr/` subfolder. Disassemble the `vuln`
    executable, see where the buffer overflow happens and what is the
    offset from the buffer start to the return address. The system is
    using DEP (*Data Execution Prevention*) and you cannot inject a
    shellcode. We assume the executable runs on an ASLR-enabled
    environment so you cannot easily determine the address of the
    `system()` function call and the
    `"/bin/sh"` string. You can however use the address of
    `system()` in PLT and use the `"sh"`
    string that is, fortunately, part of the executable.

    Now you can create a shell by following the below steps:

1. Use the skeleton in the `exploit.py` script.
1. Use GDB to determine the address of the `system()`
    function PLT entry.
1. Use GDB to determine the address of the `"sh"`
    string in the executable.
1. Use the above information to craft a payload in
    `exploit.py` that manages to overwrite the return
    address of the `reader()` function and call
    `system@plt("sh")`.

    This is a *return-to-plt* attack, a particular form of the
    *return-to-libc* attack.

1. Check out `http://141.85.224.104:50001/index.php`. There are
    multiple vulnerabilities for you to discover:

    > a.  Find one (self) XSS - alert(1)
    > b.  Find one (reflected) XSS - alert(1)
    > c.  Can you find/read the `/flag`?
    > d.  Nothing trumps remote execution!

## Solutions

Download the [solutions
archive](http://elf.cs.pub.ro/sis/res/05-defense-sol.tar).