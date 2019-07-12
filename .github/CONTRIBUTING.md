# Contributing to LFS-installer

The following is a set of guidelines for contributing to LFS-installer and its packages, which are hosted at [LFS-installer](https://github.com/caduser2020/lfs-installer) on GitHub. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

#### Table Of Contents

[Code of Conduct](#code-of-conduct)

[I don't want to read this whole thing, I just have a question!!!](#i-dont-want-to-read-this-whole-thing-i-just-have-a-question)

[What should I know before I get started?](#what-should-i-know-before-i-get-started)
  * [LFS Packages](#linux-from-scratch-packages)

[How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
  * [Suggesting Enhancements](#suggesting-enhancements)
  * [Your First Code Contribution](#your-first-code-contribution)
  * [Pull Requests](#pull-requests)

[Style guides](#styleguides)
  * [Git Commit Messages](#git-commit-messages)
  * [Bash Style Guide](#Bash-Style-Guide)
  * [Documentation Style guide](#documentation-style-guide)

[Additional Notes](#additional-notes)
  * [Issue and Pull Request Labels](#issue-and-pull-request-labels)

## Code of Conduct

This project and everyone participating in it are governed by the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the [project manager.](mailto:iposton73@outlook.com)

## I don't want to read this whole thing, I just have a question!!!

> **Note:** Please don't file an issue to ask a question. You'll get faster results by using the resources below.

We have an official detailed wiki where the community chimes in with helpful advice if you have questions.

* [LFS installer Wiki](https://github.com/Caduser2020/lfs-installer/wiki)

## What should I know before I get started?

### Linux From Scratch Packages
From the [Linux From Scratch website]()

LFS has a list of packages and patches which you should download. Please use the versions which are listed in the book (see the FAQ); these are tested versions which are known to work with each other. There are several ways to download the packages.

#### Hunt and Peck
When a package is not available from the location listed in the book, some other places to try are:

* A search for the full package name in google or your favorite search engine
* Debian Package Search Page
* filemirrors.com
* Sources from your linux distro
* LFS HTTP/FTP Sites
* If the above methods are not available to you, the packages are also available in a tarball and individually on the following ftp and http mirrors. HLFS package tarballs and individual packages are also available on these mirrors.
  * ftp://ftp.lfs-matrix.net/pub/lfs/ (Los Angeles, CA, USA, 200Mbps)
  * http://ftp.lfs-matrix.net/pub/lfs/ (Los Angeles, CA, USA, 200Mbps)
  * ftp://ftp.osuosl.org/pub/lfs/ (Corvallis, OR, USA, 100Mbps)
  * http://ftp.osuosl.org/pub/lfs/ (Corvallis, OR, USA, 100Mbps)
  * http://mirror.jaleco.com/lfs/pub/ (Washington, DC, USA, 1 Gbps)
  * http://mirrors-usa.go-parts.com/lfs (Michigan, USA, 1Gbps)
  * Also available as ftp or rsync: ftp://mirrors-usa.go-parts.com/lfs and [rsync://mirrors-usa.go-parts.com/lfs](rsync://mirrors-usa.go-parts.com/lfs) 



## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for LFS installer. Following these guidelines helps maintainers and the community understand your report :pencil:, reproduce the behavior :computer: :computer:, and find related reports :mag_right:.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report). Fill out [the required template]https://github.com/Caduser2020/lfs-installer/blob/master/.github/ISSUE_TEMPLATE/bug_report.md), the information it asks for helps us resolve issues faster.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before Submitting A Bug Report

* **Check the [debugging guide](https://github.com/Caduser2020/lfs-installer/wiki).** You might be able to find the cause of the problem and fix things yourself. Most importantly, check if you can reproduce the problem [in the latest version of LFS installer](https://github.com/Caduser2020/lfs-installer/tree/lfs-8.4).
* **Check the [LFS installer wiki](https://github.com/Caduser2020/lfs-installer/wiki)** for a list of common questions and problems.
* **Perform an [advanced search](https://github.com/search/advanced?q=)** to see if the problem has already been reported. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/). After you've determined [which repository](#LFS-installer-and-packages) your bug is related to, create an issue on the LFS installer GitHub page and provide the following information by filling in [the template](https://github.com/Caduser2020/lfs-installer/blob/master/.github/ISSUE_TEMPLATE/bug_report.md).

Explain the problem and include additional details to help maintainers reproduce the problem:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **State the exact line in which the problem occurred and the error** in as many details as possible. For example, start by explaining how you started LFS installer, e.g. which command exactly you used in the terminal, or how you started LFS installer otherwise. When stating the line, do not only state the end error. e.g.
```
gcc -DALIASPATH=\"/mnt/lfs/usr/share/locale:.\"
-DLOCALEDIR=\"/mnt/lfs/usr/share/locale\"
-DLIBDIR=\"/mnt/lfs/usr/lib\"
-DINCLUDEDIR=\"/mnt/lfs/usr/include\" -DHAVE_CONFIG_H -I. -I.
-g -O2 -c getopt1.c
gcc -g -O2 -static -o make ar.o arscan.o commands.o dir.o
expand.o file.o function.o getopt.o implicit.o job.o main.o
misc.o read.o remake.o rule.o signame.o variable.o vpath.o
default.o remote-stub.o version.o opt1.o
-lutil job.o: In function `load_too_high':
/lfs/tmp/make-3.79.1/job.c:1565: undefined reference
to `getloadavg'
collect2: ld returned 1 exit status
make[2]: *** [make] Error 1
make[2]: Leaving directory `/lfs/tmp/make-3.79.1'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/lfs/tmp/make-3.79.1'
make: *** [all-recursive-am] Error 2
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instead of 
```
make [2]: *** [make] Error 1
```
* **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem. If you use the keyboard while following the steps, **record the GIF with** [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **If you're reporting that LFS installer crashed**, include a crash report with a stack trace from the operating system. Include the crash report in the issue in a [code block](https://help.github.com/articles/markdown-basics/#multiple-lines), a [file attachment](https://help.github.com/articles/file-attachments-on-issues-and-pull-requests/), or put it in a [gist](https://gist.github.com/) and provide a link to that gist.
* **If the problem is related to performance or memory**, include a CPU profile capture with your report.

Provide more context by answering these questions:

* **Did the problem start happening recently** (e.g. after updating to a new version of LFS installer) or was this always a problem?
* If the problem started happening recently, **can you reproduce the problem in an older version of LFS installer?** What's the most recent version in which the problem doesn't happen? You can download older versions of LFS installer from [the releases page](https://github.com/caduser2020/LFS-installer/releases).
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.
* **Does the problem happen for all drives and Operating Systems or only some?** Does the problem happen only when working with local or remote files (e.g. on network drives), or with specific operating systems? Is there anything else special about the OS you are using?

Include details about your configuration and environment:

* **What's the name and version of the OS you're using**? You can get the exact version by running `hostnamectl` in your terminal. Please give the Kernel and Operating System version.
* **Are you running LFS installer in a virtual machine?** If so, which VM software are you using and which operating systems and versions are used for the host and the guest?
* **Which [packages](#LFS-installer-and-packages) do you have installed?** You can get that list by running `version-check.sh`, after downloading the LFS-installer packages.
* **Are you using LFS installer with multiple cores?** If so, can you reproduce the problem when you use a single core?
* **Which keyboard layout are you using?** Are you using a US layout or some other layout?

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for LFS installer, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion :pencil: and find related suggestions :mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). Fill in [the template](https://github.com/Caduser2020/lfs-installer/blob/master/.github/ISSUE_TEMPLATE/feature_request.md), including the steps that you imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

* **Check the [debugging guide](https://github.com/Caduser2020/lfs-installer/wiki)** for tips — you might discover that the enhancement is already available. Most importantly, check if you're using [the latest version of LFS installer]().
* **Perform an [advanced search](https://github.com/search/advanced?q=)** to see if the enhancement has already been suggested. If the enhancement has already been suggested, add a comment to the existing enhancement instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/). After you've determined [which repository](#LFS installer-and-packages) your enhancement suggestion is related to, create an issue on that repository and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of LFS installer which the suggestion is related to. You can use [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **Explain why this enhancement would be useful** to most LFS installer users.
* **Specify the name and version of the OS you're using.** You can get the exact version by running `hostnamectl` in your terminal.

### Your First Code Contribution

Unsure where to begin contributing to LFS installer? You can start by looking through these `beginner` and `help-wanted` issues:

* [Beginner issues](beginner) - issues which should only require a few lines of code, and a test or two.
* [Help wanted issues](help-wanted) - issues which should be a bit more involved than `beginner` issues.

Both issue lists are sorted by the total number of comments. While not perfect, the number of comments is a reasonable proxy for the impact a given change will have.

#### Local development

LFS installer Core and all packages can be developed locally. For instructions on how to do this, see the following sections in the [LFS installer Wiki]():

* 

### Pull Requests

The process described here has several goals:

- Maintain the quality of LFS installer
- Fix problems that are important to users
- Engage the community in working toward the best possible LFS installer
- Enable a sustainable system for LFS installer's maintainers to review contributions

Please follow these steps to have your contribution considered by the maintainers:

1. Follow all instructions in [the template](PULL_REQUEST_TEMPLATE.md)
2. Follow the [Style guides](#styleguides)
3. After you submit your pull request, verify that all [status checks](https://help.github.com/articles/about-status-checks/) are passing <details><summary>What if the status checks are failing?</summary>If a status check is failing, and you believe that the failure is unrelated to your change, please leave a comment on the pull request explaining why you believe the failure is unrelated. A maintainer will re-run the status check for you. If we conclude that the failure was a false positive, then we will open an issue to track that problem with our status check suite.</details>

While the prerequisites above must be satisfied prior to have your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.

## Style guides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move the cursor to..." not "Moves the cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line
* When only changing documentation, include `[ci skip]` in the commit title
* Consider starting the commit message with an applicable emoji:
    * :art: `:art:` when improving the format/structure of the code
    * :racehorse: `:racehorse:` when improving performance
    * :non-potable_water: `:non-potable_water:` when plugging memory leaks
    * :memo: `:memo:` when writing docs
    * :bug: `:bug:` when fixing a bug
    * :fire: `:fire:` when removing code or files
    * :white_check_mark: `:white_check_mark:` when adding tests
    * :lock: `:lock:` when dealing with security
    * :arrow_up: `:arrow_up:` when upgrading packages
    * :arrow_down: `:arrow_down:` when downgrading packages
    * :shirt: `:shirt:` when removing linter warnings
  
### Bash Style Guide

* The total length of a line (including comment) must not exceed more than 88 characters.
* The indentation of program constructions has to agree with the logic nesting depth.
* Use comments correctly:
  * Every file must be documented with an introductory comment that provides information on the filename and its contents:
    > #!/bin/bash <br> # <br># Builds necessary packages for Linux From Scratch 8.4 on a Red Hat based distribution of linux, such as Fedora, CentOS, or RHEL. <br># Copyright (C) 2019 <br> <br># This program is free software: you can redistribute it and/or modify <br># it under the terms of the GNU Affero General Public License as published <br># by the Free Software Foundation, either version 3 of the License, or <br># (at your option) any later version. <br> <br># This program is distributed in the hope that it will be useful, <br># but WITHOUT ANY WARRANTY; without even the implied warranty of <br># MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the <br># GNU Affero General Public License for more details. <br> <br># You should have received a copy of the GNU Affero General Public License <br># along with this program.  If not, see <https://www.gnu.org/licenses/> 
  * Consecutive line end comments start in the same column. A blank will always follow the introductory
character of the comment `#` to simplify the detection of the beginning of the word.
    ```
    found=0 # count links found
    deleted=0 # count links deleted
    ```
  * If several lines form a section with interlinked instructions, such section must be provided with a section comment.
  * Each function is described by an introductory comment. This comment contains the function name, a short description and the description of the parameters (if any). The name of the author and the date of issue should be added in case of subsequent amendments.
  * For the scope and style of the comments the following applies:
  
    > Short, concise and sufficiently accurate.

    Comprehensive descriptions are a matter of external documentation. The structure or the trick used is described only in exceptional cases. For instructions the following applies:

    > The comment describes the purpose of the instruction.

    The following comment is not particularly helpful as it repeats only what is indicated at the beginning of the line:
    ```
    [ "$logfile" != "" ] && $(> "$logfile") # variable $logfile empty ?
    ```
    The comment below, however, states the intention concisely:
    ```
    [ "$logfile" != "" ] && $(> "$logfile") # empty an existing logfile
    ```
* For variables meaningful, self-documenting names have to be used (such as `inputfile`). In names
the first 31 characters have to be different. Long names are structured by underscores to improve legibility. <br>
If a name is not self-documenting, the meaning and use must be described when it first occurs by a comment.
* No constants must be included
in the program text ! In particular numeral constants do not have another immediate meaning apart from their value. The meaning of the value will only become clear in the specific text context.
* If possible, shell built-ins should be preferred to external utilities. Each call of sed, awk, cut etc. generates a new process. Used in a loop this can extend the execution time considerably.
* <span id="11.1"></span> If a script with Bash call option -n is executed, the script commands are read but not executed:
  ```
  bash -n remove_ps.sh
  ```
  Such calls can be used for syntax check. However, only severe errors will be detected in this way. A mutilated key word (cho instead of echo), for example, will not be detected, since it might also be the name of a program or a function.
* Test with Bash options
  Command line option | set -o option | Meaning
  -------- | -------- | --------
  -n | noexec | Commands are not executed, only syntax check (see <a href="#11.1">above</a>.)
  -v | verbose | Outputs the lines of a script before execution.
  -x | xtrace | Outputs the lines of a script after replacements.


See [Bash Style Guide and Coding Standard - Fritz Mehner](https://lug.fh-swf.de/vim/vim-bash/StyleGuideShell.en.pdf) for more information.


### Documentation Style Guide
* Use [Markdown](https://guides.github.com/features/mastering-markdown/).
* Use [TomDoc Documentation](tomdoc.org) and generate Markdown files using [Tomdoc.sh](https://github.com/tests-always-included/tomdoc.sh).

## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and pull requests.

[GitHub search](https://help.github.com/articles/searching-issues/) makes it easy to use labels for finding groups of issues or pull requests you're interested in. We  encourage you to read about [other search filters](https://help.github.com/articles/searching-issues/) which will help you write more focused queries.

The labels are loosely grouped by their purpose, but it's not required that every issue have a label from every group or that an issue can't have more than one label from the same group.

Please open an issue on [LFS-installer/issues](https://github.com/Caduser2020/lfs-installer/issues) if you have suggestions for new labels, please open an issue on [LFS-installer/issues](https://github.com/Caduser2020/lfs-installer/issues).

#### Type of Issue and Issue State

| Label name | Description |
| --- | --- | --- | --- |
| `enhancement` | Feature requests. |
| `bug` | Confirmed bugs or reports that are very likely to be bugs. |
| `question` | Questions more than bug reports or feature requests (e.g. how do I do X). |
| `feedback` | General feedback more than bug reports or feature requests. |
| `help-wanted` | The LFS installer core team would appreciate help from the community in resolving these issues. |
| `beginner` | Less complex issues which would be good first issues to work on for users who want to contribute to LFS installer. |
| `more-information-needed` | More information needs to be collected about these problems or feature requests (e.g. steps to reproduce). |
| `needs-reproduction` | Likely bugs, but haven't been reliably reproduced. |
| `blocked` | Issues blocked on other issues. |
| `duplicate` | Issues which are duplicates of other issues, i.e. they have been reported before. |
| `won't-fix` | The LFS installer core team has decided not to fix these issues for now, either because they're working as intended or for some other reason. |
| `invalid` | Issues which aren't valid (e.g. user errors). |
| `package-idea` | Feature request which might be good candidates for new packages, instead of extending LFS installer or core LFS installer packages. |

#### Topic Categories

| Label name | Description |
| --- | --- | --- | --- |
| `Fedora` | Related to LFS installer running on Fedora. |
| `CentOS` | Related to LFS installer running on CentOS. |
| `RHEL` | Related to LFS installer running on RHEL. |
| `documentation` | Related to any type of documentation. |
| `performance` | Related to performance. |
| `security` | Related to security. |
| `ui` | Related to visual design. |
| `uncaught-exception` | Issues about uncaught exceptions, normally created from the [Notifications package](https://github.com/LFS installer/notifications). |
| `crash` | Reports of LFS installer completely crashing. |
| `network` | Related to network problems or working with remote systems (e.g. on network drives). |
| `build-error` | Related to problems with building packages from the source. |

#### Pull Request Labels

| Label name | Description |
| --- | --- | --- | --- |
| `work-in-progress`|  Pull requests which are still being worked on, more changes will follow. |
| `needs-review` | Pull requests which need code review, and approval from maintainers or LFS installer core team. |
| `under-review` | Pull requests being reviewed by maintainers or LFS installer core team. |
| `requires-changes` | Pull requests which need to be updated based on review comments and then reviewed again. |
| `needs-testing` | Pull requests which need manual testing. |