# Software Security Assurance

Slides for this session:

- [handout](http://elf.cs.pub.ro/sis/res/09-software-security-assurance-handout.pdf)
  - [handout_4on1_notes](http://elf.cs.pub.ro/sis/res/09-software-security-assurance-handout-4on1-notes.pdf)
  - [handout_8on1](http://elf.cs.pub.ro/sis/res/09-software-security-assurance-handout-8on1.pdf)

Overall problem: We have lots of code and we want to know how safe it is.
The technique used to check the code is called Static Code Analysis.
The main metric is the number of flaws that we find.

Throughout this lab we will gain practical insights that prove that the
problem of securing software is hard. We will approach the problem in
two ways:

- Manual human inspection of code
- Automatic checking using various tools

For an extensive list of static analyzers, grouped by programming
language, consult the following resource:
<https://github.com/analysis-tools-dev/static-analysis>

We will begin with the inspection of a few C code samples to highlight
the points where programmers are prone to creating flaws in the code.
Then we will see how other higher-level languages minimize those risks.

## Challenges

First, install the required static code analyzers with the following
command (relevant for Debian-based systems):
`sudo apt install cppcheck flawfinder clang-tidy clang-format`.

Then download the [session task
archive](http://elf.cs.pub.ro/sis/res/09-code-analysis.tar) that
contains a few C samples to work with.

1. Let\'s first do some code auditing.
    1. The `aplusplus.c` and `weird.c` samples have some undefined
        behavior going on. Can you guess the output of each of them
        prior to actually running them?
    1. Can you reverse engineer the perfect value to feed into
        `this_is_not_possible.c` to get the shell?
    1. Find as many flaws in `hidden-bugs.c` as you can with only
        manual inspection.
2. Run each of the above code samples through static code analyzers.
    Using `hidden-bugs.c` as a benchmark, what percentage of
    false-positives do you get? Use the following syntax to run each of
    the analyzers:
    1. `cppcheck --enable=all --verbose <sourcefile>` and
        `cppcheck --enable=all --verbose --inconclusive <sourcefile>`
    1. `flawfinder <sourcefile>`
    1. `clang-tidy <sourcefile>`
3. Download the project <https://github.com/acornea/picpic>. It
    contains several flaws.
    1. Perform manual analysis of the project.
    1. Run the project through the analyzers and compare the results.
4. (bonus) To get an idea of how analyzers are generally benchmarked
    you can use the NIST Software Assurance Reference Dataset Project
    page: <https://samate.nist.gov/SRD/testsuite.php>
    1. Download just one of the following test cases: **Juliet 1.3
        C/C++**, **Klocwork test suite**, **C Test Suite for Source Code
        Analyzer v2 - Vulnerable**.
    1. Pick a few samples, inspect them manually and then run the
        analyzers against those to see if the problems are discovered.
        Also keep track of the false-positive rate.
5. Moving on to higher-level languages, we will use the following
    repository as a resource of vulnerable code snippets:
    <https://github.com/snoopysecurity/Vulnerable-Code-Snippets>
    1. Inspect the JavaScript snippets
        (<https://github.com/snoopysecurity/Vulnerable-Code-Snippets/search?l=JavaScript>).
        How easy is it to manually spot the issues?
    1. Run the JavaScript snippets through `ESLint`. You can either
        install `ESLint` locally (via `npm`) or use the online demo
        functionality (<https://eslint.org/demo>). Does the tool find
        the flaws?
6. To get a taste of a different higher-level programming language,
    take a look at the following tutorial:
    <https://docs.pylint.org/en/1.6.0/tutorial.html>
    1. Note the difference between the vulnerabilities that C/C++
        analyzers discover and the ones that JavaScript/Python analyzers
        find.
    1. Notice that in the first case, there are a lot more problems
        with the actual **implementation** of ideas, rather than the
        ideas themselves (which are always prone to errors).
    1. In the case of JavaScript/Python, what is more likely to fail is
        the actual **logic**, not the implementation itself.