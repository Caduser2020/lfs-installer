# Contributing to LFS-installer

The following is a set of guidelines for contributing to LFS-installer and its packages, which are hosted at [LFS-installer](https://github.com/caduser2020/lfs-installer) on GitHub. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

#### Table Of Contents

[Code of Conduct](#code-of-conduct)

[I don't want to read this whole thing, I just have a question!!!](#i-dont-want-to-read-this-whole-thing-i-just-have-a-question)

[How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
  * [Suggesting Enhancements](#suggesting-enhancements)
  * [Your First Code Contribution](#your-first-code-contribution)
  * [Pull Requests](#pull-requests)

[Style guides](#styleguides)
  * [Git Commit Messages](#git-commit-messages)
  * [Documentation Style guide](#documentation-styleguide)

[Additional Notes](#additional-notes)
  * [Issue and Pull Request Labels](#issue-and-pull-request-labels)

## Code of Conduct

This project and everyone participating in it are governed by the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the [project manager.](mailto:iposton73@outlook.com)
## I don't want to read this whole thing, I just have a question!!!

> **Note:** Please don't file an issue to ask a question. You'll get faster results by using the resources below.

We have an official detailed wiki where the community chimes in with helpful advice if you have questions.

* [LFS installer Wiki](https://github.com/Caduser2020/lfs-installer/wiki)

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
checking dynamic linker characteristics... configure: error: Link tests are not allowed after GCC_NO_EXECUTABLES.
Makefile:9590: recipe for target 'configure-zlib' failed
make[1]: *** [configure-zlib] Error 1
make[1]: Leaving directory '/home/usr/scr'
Makefile:876: recipe for target 'all' failed
make: *** [all] Error 2
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instead of 
```
make: *** [all] Error 2
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
    * :green_heart: `:green_heart:` when fixing the CI build
    * :white_check_mark: `:white_check_mark:` when adding tests
    * :lock: `:lock:` when dealing with security
    * :arrow_up: `:arrow_up:` when upgrading dependencies
    * :arrow_down: `:arrow_down:` when downgrading dependencies
    * :shirt: `:shirt:` when removing linter warnings
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