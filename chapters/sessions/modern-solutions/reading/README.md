# Modern Offensive and Defensive Solutions

We discuss modern offensive and defensive solutions, focusing on recent
research on application and system security.

Slides for this session:

- [handout](http://elf.cs.pub.ro/sis/res/06-modern-solutions-handout.pdf)
  - [handout_4on1_notes](http://elf.cs.pub.ro/sis/res/06-modern-solutions-handout-4on1-notes.pdf)
  - [handout_8on1](http://elf.cs.pub.ro/sis/res/06-modern-solutions-handout-8on1.pdf)

## Tasks

Download the [session task
archive](http://elf.cs.pub.ro/sis/res/06-modern-solutions.tar).

1. Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/06-modern-solutions.tar) and
    access the `rop-shell/` subfolder. Your goal is to open a shell by
    calling `system("/bin/sh")`. You can jump directly to where
    `system()` is called. You need to store the address of `"sh"` in RDI
    using a gadget. You can find the address of `"sh"` in the executable
    by using `find` in GDB PEDA.

    Construct the ROP-based payload in `exploit.py` similar to the
    `exploit.py` file in the `rop-demo/` subfolder.

    You can look for ROP gadgets by issuing the command

    ```text
    ROPgadget --binary vuln
    ```

1. Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/06-modern-solutions.tar) and
    access the `rop-chain/` subfolder. You goal is to call
    `mega_checker()` after the `checker()` call.
    Both the `"ihahaha!"`
    and the `"Uberihahaha!"` messages need to be printed. For the
    `mega_checker()` to be properly called you need to initialized both
    the RDI register (1st parameter) and the RSI register (2nd
    parameter).

    Construct the ROP-based payload in `exploit.py`.

1. First make sure you have a recent version of Clang/LLVM (3.8+)
    installed.
    If you use the lab machines, use `apt-get` to install the
    `clang-4.0` package.

    Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/06-modern-solutions.tar) and
    access the `dop/` subfolder. Open `dop.c`.
    What is the
    vulnerability? Notice there is a buffer overflow in `f` and that `f`
    contains a while loop that acts as an interpreter.

    Open `payload.c` and study the example payload.
    What does it do?
    Fill in the missing addresses in `payload.c`. Generate the payload
    and feed it to `dop`. It should print "End of program: FAILAA!".

    Devise a similar payload that makes `dop` print "End of program:
    SISPWN!".

    Recompile `dop` with the `-fsanitize=safe-stack` flag and run the
    exploit again.
    What happened? Why?