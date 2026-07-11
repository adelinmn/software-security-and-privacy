---
title: System Auditing
---

We talk about how easy it is to use automatic scanning tools (both as a
sysadmin and as an attacker), but also how those might miss critical
security aspects. Automatic scanning tools are not the solution to
everything. They do help with assessing the security of a target, but
they do not always end up finding everything.

## Feedback

In order to improve the SIS course, your opinions and suggestions are
important to us.
The feedback is anonymous and the results will only
become visible after the final exam. You will find the link to the
feedback form on the main page of the curs.pub.ro instance for your
master's program SIS class.

## Tasks

Download the [Kioptrix 1
VM](https://www.vulnhub.com/entry/kioptrix-level-1-1,22/) from
`vulnhub`.
This will be our target throughout the lab.

To audit our target, we will use `GVM` (former `OpenVAS`). We will use a
[dockerized version](https://hub.docker.com/r/securecompliance/gvm), to
speed up the setup process (this means that `docker` should be already
installed on your systems).

1. Set up the docker container:

    ```text
    mkdir ~/gvm-docker
    docker run --detach --publish 8080:9392 --publish 5432:5432 --publish 2222:22 --env DB_PASSWORD="password" --env PASSWORD="password" --volume <absolute-path-to-gvm-docker>/storage/postgres-db:/opt/database --volume <absolute-path-to-gvm-docker>/storage/openvas-plugins:/var/lib/openvas/plugins --volume <absolute-path-to-gvm-docker>/storage/gvm:/var/lib/gvm --volume <absolute-path-to-gvm-docker>/storage/ssh:/etc/ssh --name gvm --net=host securecompliance/gvm:21.4.3-v1
    ```

    The container will be up and running in a few minutes, but the
    update process will take more (20-30 minutes).
    Leave it running.

1. Download, import and start the [Kioptrix 1
    VM](https://www.vulnhub.com/entry/kioptrix-level-1-1,22/).

1. Find the target IP and perform a port scan:

    ```text
    - first list all adapters with `ifconfig`
    - perform `nmap` ping scans on all the networks to find all
        potential target IPs of hosts connected to any of the networks
        (`nmap -sn <subnetwork>`)
    - perform a fast port scan of the targets
        (`nmap -sT -sV -T5 -p- <target>`)
    ```

1. Now Scan the target with `GVM`.

    - access the web interface located at `https://localhost:9392` and
        log in using `admin:password` as credentials.
    - define the target (navigate to `Configuration > Targets` and
        click the `New Target` icon on the top left)
        - give the target a name and manually define it
        - select `All TCP and Nmap top 100 UDP` as `Port List`
        - select `Consider Alive` as `Alive Test`
    - define a new scan config (navigate to
        `Configuration > Scan Configs` and click the `New Scan Config`
        icon on the top left)
        - use the `Full and fast` as base scan
        - right after creating it, click on the `Edit Scan Config`
            button associated with the newly created scan config and
            make sure that the following three scan categories are
            checked:
            - General
            - Port Scanners
            - Service detection
    - create a new task that uses the target and scan config that you
        defined previously

1. While waiting for the task to finish, try to perform some manual
    recon with nmap and some Googling. Compare this with the final
    result of `GVM`.

    - Notice that `GVM` did not find the major flaw that enables an
        attacker to exploit the current target