---
title: "PSIMiner"
collection: tools
permalink: /tools/psiminer
tag: 'A tool for processing PSI trees from IntelliJ IDEA and creating a labeled dataset from them.'
pdf: 'https://arxiv.org/abs/2103.12778'
paperurl: 'https://doi.org/10.1109/MSR52588.2021.00014'
tool: 'https://github.com/JetBrains-Research/psiminer'
video: 'https://www.youtube.com/watch?v=isgfJL4-9Yg'
abstract: '<p><b>PSIMiner</b> is a tool for processing PSI trees from IntelliJ IDEA and creating a labeled dataset from them. The purpose of PSIMiner is to simplify working with the IntelliJ Platform’s built-in code processing tools and, in particular, PSI trees. Since there is no obvious way to access PSI trees outside an IDE, we developed PSIMiner as a plugin for IntelliJ IDEA that extracts data from source code and stores it in a convenient format. PSIMiner runs IntelliJ IDEA in the headless mode, without starting the IDE’s GUI. This way our tool can be used from a command-line interface, making it easy to process datasets on remote servers. IntelliJ IDEA runs on JVM, so all of the API in IntelliJ Platform is in Java or Kotlin. We chose Kotlin to implement PSIMiner.</p>'
---