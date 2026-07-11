# Introduction to Systems Security

We make the first steps into systems security and talk about the high
level topics. We present logistics and organizational aspects for the
"Security of Information Systems" class.

Slides for this session:

- [handout](http://elf.cs.pub.ro/sis/res/01-intro-systems-security-handout.pdf)
- [handout_4on1_notes](http://elf.cs.pub.ro/sis/res/01-intro-systems-security-handout-4on1-notes.pdf)
- [handout_8on1](http://elf.cs.pub.ro/sis/res/01-intro-systems-security-handout-8on1.pdf)

## Tasks

1. Use `checksec.sh` to audit the security of the executables on your
    system. You can download `checksec.sh` from the [following link](https://raw.githubusercontent.com/slimm609/checksec.sh/master/checksec).

    Or you can use [pwntools](http://docs.pwntools.com/en/stable/commandline.html#pwn-checksec) as a wrapper of `checksec`.

    Use GCC and its options to create executables with all sorts of
    combinations (NX, PIE, stack canary, RELRO). Build (compile and
    link) an executable with all hardening options on:

    ```text
    $ checksec a.out
      [...]
      Arch:     amd64-64-little
      RELRO:    Full RELRO
      Stack:    Canary found
      NX:       NX enabled
      PIE:      PIE enabled
    ```

    And build (compile and link) an executable with all hardening
    options off:

    ```text
    $ checksec a.out
      [...]
      Arch:     amd64-64-little
      RELRO:    Partial RELRO
      Stack:    No canary found
      NX:       NX disabled
      PIE:      No PIE (0x400000)
      RWX:      Has RWX segments
    ```

1. You can't read the `/flag` file.
    Still, it might be **duplicated**
    somewhere else. Where could you find it?

    Connect using SSH to **ctf@141.85.224.104:10000**. The account
    password is **look-for-me-0**.

    Submit the flag on the [CTF
    platform](https://app.cyber-edu.co/challenges/9a49c0ea-ecab-4070-9967-3497b8f51013?tenant=upb).
    You need to create an account on the platform if you don't already
    have one.

1. When you can't read the `/home/ctf/flag`, ask someone else.

    Connect using SSH to **ctf@141.85.224.104:10001**. The account
    password is **reverse-kitten-0**.

    Submit the flag on the [CTF
    platform](https://app.cyber-edu.co/challenges/9a49c32f-11b5-400e-b758-ade4cb4f271ac?tenant=upb).
    You need to create an account on the platform if you don't already
    have one.

1. The `/home/ctf/flag` is already there.
    You just have to read it.

    Connect using SSH to **ctf@141.85.224.104:10002**. The account
    password is **hit-me-hard-0**.

    Submit the flag on the [CTF
    platform](https://app.cyber-edu.co/challenges/9a49c412-5ece-4f47-8a7b-06912feac628?tenant=upb).
    You need to create an account on the platform if you don't already
    have one.

1. You know how the flag looks.
    Find it somewhere where **data** could
    be stored.

    Connect using SSH to **ctf@141.85.224.104:10003**. The account
    password is **cant-find-me-0**.

    Submit the flag on the [CTF
    platform](https://app.cyber-edu.co/challenges/9a49c4c4-2436-4c0a-94e8-213a07befbf6?tenant=upb).
    You need to create an account on the platform if you don't already
    have one.