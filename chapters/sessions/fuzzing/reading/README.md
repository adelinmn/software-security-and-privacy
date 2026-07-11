# Fuzzing

We talk about securing software by program analysis. We discuss about
fuzzing techniques, their advantages and disadvantages and about hybrid
approaches.

Slides for this session:

- [slides](http://elf.cs.pub.ro/sis/res/10-fuzzing-handout.pdf)

## Tasks

We highly recommend you use teams of 2 or 3 to work on the tutorials.

### Setup

For the AFL and KLEE tutorial, you require access to a pre-configured
environment. These environments use Docker, both for
[AFL](https://github.com/mykter/afl-training/tree/main/) and
[KLEE](https://klee.github.io/docker/).

You can either:

- Download a Virtual Machine that is already configured to use Docker
    to run the `AFL` and `KLEE` containers
- Install Docker on your local machine and configure the
    `AFL` and `KLEE` containers

Depending on which method you want to use, skip to the matching section
below:

#### Virtual Machine

The easiest way is to use the `SIS - Fuzzing` virtual machine. This
virtual machine has Docker installed and it also has the
`AFL` and `KLEE` containers configured.

Download the virtual machine (in OVA format) using Bittorrent. Use [this
Bittorrent
file](http://elf.cs.pub.ro/sis/res/SIS%20-%20Fuzzing.ova.torrent).

The virtual machine is rather large (5.4GB the OVA file, 13GB the
unpacked virtual machine); be sure you have disk space. Import the OVA
file in VMware or VirtualBox.

Once you start the virtual machine, use the username `student` and
password `student`. Then start and access the AFL and KLEE Docker
instances as the following snippet explains:

```text
student@sis-fuzzing:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
student@sis-fuzzing:~$ docker ps -a
CONTAINER ID   IMAGE           COMMAND           CREATED          STATUS                        PORTS     NAMES
f2d5777932b3   klee/klee:2.1   "/bin/bash"       8 minutes ago    Exited (0) 5 minutes ago                klee
5275c2d2c1ed   afltraining     "entrypoint.sh"   19 minutes ago   Exited (137) 14 minutes ago             afl
student@sis-fuzzing:~$ docker start afl
afl
student@sis-fuzzing:~$ docker start klee
klee
student@sis-fuzzing:~$ docker ps
CONTAINER ID   IMAGE           COMMAND           CREATED          STATUS         PORTS                   NAMES
f2d5777932b3   klee/klee:2.1   "/bin/bash"       8 minutes ago    Up 4 seconds   0.0.0.0:23000->22/tcp   klee
5275c2d2c1ed   afltraining     "entrypoint.sh"   20 minutes ago   Up 7 seconds   0.0.0.0:22000->22/tcp   afl

student@sis-fuzzing:~$ docker exec -it klee /bin/bash
klee@f2d5777932b3:~$ ls
klee_build  klee_src
klee@f2d5777932b3:~$ exit

student@sis-fuzzing:~$ ssh fuzzer@localhost -p 22000
fuzzer@localhost's password:
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 4.15.0-130-generic x86_64)
 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: Tue Jan 12 09:52:37 2021 from 172.17.0.1
-bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
fuzzer@5275c2d2c1ed:~$ ls
AFLplusplus  workshop
fuzzer@5275c2d2c1ed:~$ logout
```

::: important
::: title
Important
:::

The password for the AFL Docker container is `afl`.
No password is
required for the KLEE Docker container.
:::

#### Local Docker Installlation

Otherwise you can do your own setup using Docker. If that is the case,
do the following steps.

1. (Skip this if Docker is already installed) Install Docker.

    ``` bash
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
    sudo service docker start
    sudo usermod -aG docker $USER
    sudo newgrp docker
    ```

    You may need to reauthenticate the current user.

1. Install the AFL Docker container, by following the [AFL
    instructions](https://github.com/mykter/afl-training/tree/main/environment).

    ``` bash
    docker pull ghcr.io/mykter/fuzz-training:latest
    docker run -d --name afl --privileged -p 2222:2222 -e PASSMETHOD=env -e PASS=afl ghcr.io/mykter/fuzz-training
    ssh fuzzer@localhost -p 2222 # use password afl
    sudo ~/AFLplusplus/afl-system-config
    ```

1. Install the KLEE Docker container, by following the [KLEE
    instructions](https://klee.github.io/docker/).

    The important bit is:

    ``` bash
    docker pull klee/klee:2.3
    docker run -d --name klee --rm -ti --ulimit='stack=-1:-1' klee/klee:2.3
    docker exec -it klee /bin/bash
    ```

### Fuzzing with AFL

We will go through the [AFL
tutorial](https://github.com/mykter/afl-training). Just as the README
suggests, we will go over the `quickstart` and
`harness` exercises.

First, log into the AFL Docker container.
Then go inside the `workshop/`
folder. Then go the `quickstart/` folder and follow the
[instructions](https://github.com/mykter/afl-training/tree/main/quickstart#the-vulnerable-program).

After launching `afl-fuzz` make sure to take a look at
[understanding the status
screen](https://aflplus.plus/docs/status_screen/).

Once you have some crashes being detected, you can move on to the next
step.

You can test the crashes in the `out/crashes/`:

``` bash
./vulnerabable < out/crashes/<id_of_crash-file>
```

Create a new folder with inputs and use that.

Now create your own test file, with an obvious issue / vulnerability
(such as a buffer overflow). And build that with AFL support and test /
fuzz it using AFL.

Now go through the `harness/` folder. Follow the instructions.

Go through as many challenges in the `challenges/` folder as you can.

### Symbolic Execution with KLEE

We will go through the [KLEE
tutorials](https://klee.github.io/tutorials/). Go through the tutorials
in order: `First tutorial`, `Second tutorial`,
`Using symbolic environment`.

Clone the [official repository](https://github.com/klee/klee) to have access
to the `examples/` directory. Use the directory to work on
the exercises.

The latest version of the container has `clang` installed in
`/usr/lib/llvm-11/bin/clang`. This path is not included in
the `PATH` variable. You can either include it manually or
call `clang` with the full path.

### Extra: Fuzzing with driller

**BONUS**: Traditional fuzzers are not able to generate inputs that pass
complex string comparisons, magic numbers, etc. Even if a grey-box
fuzzer like `libFuzzer` knows the coverage state and drives the test
generation to uncovered paths, this approach won't determine proper
value for complex compares. In this situation, a mix system is used.

This approach knows the set of paths where execution can reach only one
branch of the comparison during multiple tests. We say that the fuzzer
is `blocked` in certain instruction pointers. To unblock the code
discovery, symbolic execution is used.

In this lab we experiment this situation with `driller`
(<https://github.com/shellphish/driller>).
Take a look on how it works
in `this example`
(<https://github.com/shellphish/driller/blob/master/README.md>).

From [session task
archive](http://elf.cs.pub.ro/sis/res/10-fuzzing.tar), access
`hard-to-fuzz` subfolder and inspect `fuzzy` using a static analyzer.

1. Run `fuzzy-fuzzer` to see whether issues are found in reasonable
    time.
1. Write a Driller script to detect the deep-hidden vulnerability.
    `Driller` is installed in this virtual machine
    (<https://repository.grid.pub.ro/cs/hexcellents/sss/SSS%20-%20Ubuntu%2014.04.1%2064-bit.ova>).
    To start driller virtual environment, run `workon driller`.
    Be
    patient! Pay attention to how `crash-me` reads input!