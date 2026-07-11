# Authentication

We discuss methods to access a system, their strengths and weaknesses.
We show how an attacker would compromise or bypass authentication
methods and present defensive mechanisms.

Slides for this session:

- [handout](http://elf.cs.pub.ro/sis/res/02-authentication-handout.pdf)
  - [handout_4on1_notes](http://elf.cs.pub.ro/sis/res/02-authentication-handout-4on1-notes.pdf)
  - [handout_8on1](http://elf.cs.pub.ro/sis/res/02-authentication-handout-8on1.pdf)

## Tasks

Download the [session task
archive](http://elf.cs.pub.ro/sis/res/02-authentication.tar).

1. Connect using SSH to **ctf@141.85.224.104:20000**.
    The account password is **aw3som3_passw0rd**. The flag is in `/home/ctf/flag`.

    > Submit the flag on the [CTF
    > platform](https://app.cyber-edu.co/challenges/9a57f21d-91fa-456a-88d2-17542034cc54?tenant=upb).
    > You need to create an account on the platform if you don't
    > already have one.

1. Connect using SSH to **ctf@141.85.224.104:20001**.
    The account password is **no-matter-what-1**. The flag is split in different
    places and each piece was created recently.

    > Submit the flag on the [CTF
    > platform](https://app.cyber-edu.co/challenges/9a57f13e-cbaa-44ea-996d-4c56e8c21a93?tenant=upb).
    > You need to create an account on the platform if you don't
    > already have one.

1. The password is, essentially, a string which needs to be checked
    against the user input. As you would expect, this usually goes as
    follows:

    ```text
    for i = 1,length(password)
        if password[i] != input[i]
            return FAIL
    return SUCCESS
    ```

    Therefore, the more iterations the for-loop does, the closer the
    input is to the truth.
    Exploits based on information about the
    physical implementation of the authentication system (such as
    execution time / power consumption / resources allocated, for
    different inputs) are called [side-channel
    attacks](http://en.wikipedia.org/wiki/Side_channel_attack).

    Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/02-authentication.tar) and
    access the `sidechannel/` subfolder. Check the source code file
    `sidechannel.py`. The `sidechannel` program authenticates users if
    they enter the correct passphrase, which has the following structure:

    ```text
    <article> <adjective> <noun>
    ```

    The composing words are randomly chosen from the dictionaries in the
    `dict/` directory. The check is done in plaintext and the program
    also reports its execution time (in microseconds). Design and
    implement a side-channel attack to guess the passphrase. Start from
    the `break_sidechannel.py` script.

1. Open the [session task
    archive](http://elf.cs.pub.ro/sis/res/02-authentication.tar) and
    access the `password-breaking/` subfolder. The `passwords.hash` file
    contains a list of SHA-256 password hashes, with varying strengths
    and weaknesses and we have to determine the associated plaintexts.
    Use the Python skeleton scripts in `cracking-scripts/` to crack the
    passwords. The `run-all` script runs them together. The
    `dummy_breaking.py` script is to be used as template.

    Follow the steps:

1. Fill the `dictionary_breaking.py` script for a dictionary
    attack. Use the dictionary in `dict/words` to crack 10
    passwords.

1. Consider the following common substitutions:

    ```text
    a -> @
    e -> 3
    i -> !
    o -> 0
    s -> $
    ```

    Fill the `hybrid_breaking.py` script to re-run the dictionary
    attack, while making all the above substitutions simultaneously.
    An additional 10 passwords will be broken this way.

1. Extend your previous work in the `extended_breaking.py` script
    to add punctuation marks at the end of the password and the
    hybrid password, either `.` or `...` or `!` or `?`. You will
    find 10 additional solutions: 5 solutions for adding
    punctuation marks at the end of the password and 5 solutions
    for adding punctuation marks at the end of the hybrid password.

1. Some entries in the database have a larger size than the others,
    because they also store a salt string, either prefixed:

    ```text
    salt.encode('hex') + hash(salt + actual_password)
    ```

    or suffixed

    ```text
    hash(actual_password + salt) + salt.encode('hex')
    ```

    The convention is that if the database entry has the salt
    prefixed, then the salt was appended at the beginning of the
    password before salting. Similarly, a salt that is stored
    suffixed was appended after the password before hashing.

    Hashes that are above 32 bytes (i.e. 64 hex digits) use a salt.
    These hashes have 74 hex digits, meaning that 10 hex digits
    either at the beginning or the end form the salt. Fill the
    `salt_breaking.py` script to run a salted dictionary attack,
    which will identify 5 suffixed and 5 prefixed passwords.

1. Combine the salting and hybrid attack approach in the
    `extended_salt_breaking.py` script and determine 10 additional
    passwords.

1. Fill the `brute_force_breaking.py` script to generate all the
    possible 4-character passwords and compares their hashes to the
    ones in the database. The charset to consider is composed of all
    the symbols on a standard US keyboard. There are 10 passwords to
    be cracked this way.

1. Finally, run the remaining hashes through a lookup table such as
    [CrackStation.net](https://crackstation.net/).

1. (**bonus**) After all the above, you will be left with one
    uncracked hash. This account belongs to David, who used a
    lowercase space-separated passphrase.
    His Facebook profile is
    littered with the latest internet memes and it appears that he
    is a member in the Tolkien Society. Finally, he frequently uses
    the username `boromir90`. Can you guess his passphrase?

1. (**bonus**) The `5chars-passwords.hash` files contains 8 hashes
    for 5-character passwords using all printable characters. Create
    a copy of the `brute_force_breaking.py` script to crack these
    passwords as well.

## Solutions

Download the [solutions
archive](http://elf.cs.pub.ro/sis/res/02-authentication-sol.tar).