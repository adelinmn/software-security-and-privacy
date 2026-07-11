# Software Supply Chain Security

We talk about how easy it is to use automatic scanning tools (both as a
sysadmin and as an attacker), but also how those might miss critical
security aspects. Automatic scanning tools are not the solution to
everything. They do help with assessing the security of a target, but
they do not always end up finding everything.

Slides for this session:

- [handout](http://elf.cs.pub.ro/sis/res/12-supply-chain-security-handout.pdf)
  - [handout_4on1_notes](http://elf.cs.pub.ro/sis/res/12-supply-chain-security-handout-4on1-notes.pdf)
  - [handout_8on1](http://elf.cs.pub.ro/sis/res/12-supply-chain-security-handout-8on1.pdf)

## Tasks

Download the [session task
archive](http://elf.cs.pub.ro/sis/res/12-supply-chain.tar).

### Cosign

#### Container Check

Install `cosign` using the instructions
[here](https://github.com/sigstore/cosign?tab=readme-ov-file#installation).

Check the signature of the image we already uploaded on
[Docker Hub](https://hub.docker.com/):

```text
./cosign-linux-amd64 verify razvandeax/my-hello --certificate-identity='razvan.deaconescu@upb.ro' --certificate-oidc-issuer='https://github.com/login/oauth'
```

Run the image locally:

```text
docker run razvandeax/my-hello
```

We use `cosign` to validate the contents of a container we have
previously uploaded. The identity and issuer are GitHub as we used
GitHub to authenticate and sign.

We will use similar steps to sign new containers.

#### Tutorial

Open the [session task
archive](http://elf.cs.pub.ro/sis/res/12-supply-chain.tar) and access
the `cosign/` directory. The aim is to sign and provide signed
containers.

Follow the steps below:

1. If you don't have one, create an account on
    [Docker Hub](https://hub.docker.com/).

1. [Install Docker](https://docs.docker.com/engine/install/ubuntu/)
    locally on your system

1. Log in on `docker.io`:

    ```text
    docker login docker.io -u <username> -p <password>
    ```

Now, let's push an image on [Docker Hub](https://hub.docker.com/).

1. Create a Docker image entry on [Docker Hub](https://hub.docker.com/).
    Give it a name of your choosing.

1. Create a container image from the `Dockerfile` provided:

    ```text
    make -f Makefile.docker build
    ```

1. Tag the image with the name you choose prefixed by your username.
    First find the image name / ID:

    ```text
    docker image ls
    ```

    And then tag it:

    ```text
    docker tag <ID_from_above> <username>/<name_of_your_choosing>:latest
    ```

1. Test the image:

    ```text
    docker run <username>/<name_of_your_choosing>:latest
    ```

1. Push the image to [Docker Hub](https://hub.docker.com/):

    ```text
    docker push <username>/<name_of_your_choosing>:latest
    ```

1. Check the image in the [Docker Hub](https://hub.docker.com/)
    interface. Make sure the image is public.

Now, let's sign the image.

1. Sign the image using the command:

    ```text
    ./cosign-linux-amd64 sign <username>/<name_of_your_choosing>:latest
    ```

    You will be prompted with an authentication screen. Choose the
    engine you want to use to authenticate.

1. Verify the image. If you don't know your identity and issuer, you
    can use a regex:

    ```text
    ./cosign-linux-amd64 verify <username>/<name_of_your_choosing>:latest --certificate-identity-regexp='.*' --certificate-oidc-issuer-regexp='.*'
    ```

1. Ask other colleagues to verify your image. Ask them to use `cosign`
    to verify it.
    And ask them to use `docker run` to test it:

    ```text
    docker run <username>/<name_of_your_choosing>:latest
    ```

#### Another Container

Use the example `Dockerfile` to create another minimalistic application.
Aim to build a Go, C++, Rust, D language application.

Copy **only** the required libraries in a `scratch` container.

Follow the steps above to:

- Create a new container.
- Run it locally.
- Push the container on [Docker Hub](https://hub.docker.com/).
- Sign the container with `cosign`.
- Verify the container. Ask colleagues to verify it.

#### GitHub Container Registry (GHCR)

Use [GitHub Container Registry
(GHCR)](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
instead of [Docker Hub](https://hub.docker.com/).

You need a GitHub account and a personal access token with it.

You need to login to `ghcr.io`:

```text
echo $PAT | docker login ghcr.io -u yokawasa --password-stdin
```

where `$PAT` is the personal access token.

Follow instructions in [this
article](https://medium.com/@vniranjan251203/github-packages-and-container-registry-79ee7336e24d)
or [this other
article](https://nikiforovall.github.io/docker/2020/09/19/publish-package-to-ghcr.html)
to push the container created above to GHCR.

Sign the container on GHCR.

Make the container public. You need to attach it to a repository.

Verify the container. Ask colleagues to verify it.

### Syft & Grype

Install `syft` using the [install
instructions](https://github.com/anchore/syft#installation).

Use it to extract the SBOM for the following containers:

- `alpine`
- `gcc:13.2`
- `debian:bookworm`
- `node:21-bookworm`
- `node:21-alpiner3.18`
- `rust:1.75-bookworm`

Use it to extract the SBOM for the container you created above.
Why
are not there any items output?

Use `syft` to extract the SBOM in JSON format.

Install `grype` using the [corresponding install
instructions](https://github.com/anchore/grype/?tab=readme-ov-file#installation).
Use it to scan for vulnerabilities of the above images.

Create your own container for two of the three options below:

- a NodeJS framework / application of choice that uses `npm`
- a Rust framework / application of choice that uses Cargo
- a Python framework / application of choice that uses Poetry or
    `requirements.txt`

Extract the SBOM using `syft`. Look for vulnerabilities using `grype`.