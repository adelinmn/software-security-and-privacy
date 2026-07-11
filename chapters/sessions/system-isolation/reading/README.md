# System Isolation

We discuss solutions for isolating an entire system/OS for damage
control: virtualization, containerization. If critical apps or the
OS/kernel itself are compromised, the system is compromised but won't
affect other systems.

Slides for this session:

- [handout](http://elf.cs.pub.ro/sis/res/08-system-isolation-handout.pdf)
  - [handout_4on1_notes](http://elf.cs.pub.ro/sis/res/08-system-isolation-handout-4on1-notes.pdf)
  - [handout_8on1](http://elf.cs.pub.ro/sis/res/08-system-isolation-handout-8on1.pdf)

## Tasks

Download the [session task
archive](http://elf.cs.pub.ro/sis/res/08-system-isolation.tar).

1. **DO NOT DO THIS ON A REAL MACHINE** Do not manually remove `jail`
    folder!
    Use only the scripts provided.
    You are playing "Bad
    Software Monopoly" and you just drew the "Go to jail!" card.
    Fortunately, you chose to play with the **root** token.

    Find your "Get out of jail free" card and get your well deserved
    reward.

    Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/08-system-isolation.tar) and
    access the `monopoly/` subfolder.

    Run: `sudo ./go_to_jail` and try to escape the `chroot` jail. When
    you escape, read the `/flag` file.

    Run `sudo ./destroy_jail` to remove the jail

1. a.  Install `Docker` (information here
        <https://docs.docker.com/get-started/>).
        Run
        `docker run hello-world` to make sure that everything is set up
        OK.
        Run `docker run -it ubuntu bash` to enter the container.
        Experiment a little
    1. Create a custom Docker image based on the instructions here
        <https://docs.docker.com/get-started/part2/>
    1. Modify the default app and introduce a way to execute commands
        from the web page (eg: add a `GET` *cmd* parameter that will be
        executed.
        Try to read `/etc/passwd` or break the app.

1. a.  Create an Ubuntu virtual machine in your favourite
        virtualization product.
    1. Inside the VM, create a Linux container following the
        instructions here:
        <https://linuxcontainers.org/lxc/getting-started/>. Experiment
        with `lxc-*` commands
    1. Create a snapshot of your VM.
    1. **DO NOT DO THIS ON A REAL MACHINE** Break the VM with the
        following command: `sudo dd if=/dev/urandom of=/dev/sda` or
        `sudo rm --no-preserve-root -rf /`. Try to restore it