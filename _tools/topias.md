---
title: "Topias"
collection: tools
permalink: /tools/topias
paperurl: 'https://doi.org/10.1145/3379597.3387451'
pdf: 'https://arxiv.org/abs/2004.01652'
video: 'https://www.youtube.com/watch?v=xsqc4gCTxfA'
tool: 'https://github.com/JetBrains-Research/topias'
tag: 'An IntelliJ IDEA plugin for visualization of VCS changes frequency.'
abstract: '<p><b>Topias</b> is an IntelliJ IDEA plugin for visualization of VCS changes frequency. When a developer opens a project in the IDE, the plugin checks if a version control system is used. If no VCS root directory is found, a warning message is shown, the plugin turns off and remains in this state until a new project is opened or a VCS root is set for the current project.</p><p>All data retrieval from a VCS history is done in the background. The full commit history for a selected time period is only browsed through once when a project is opened for the first time. After that, there is almost no impact on the overall IDE performance. When a new file from a current project is opened in the editor, the plugin queries its data model and builds visual elements for this file’s methods. This is also done in a background thread, and therefore does not affect the editor performance, but it could take an extra half a second for the visual elements to appear, which might annoy some very impatient developers.</p><p>In addition to the visual elements in the IDE’s editor, the plugin also adds a new tool window showing a list of the top 10 most frequently changed methods within this project. By default the list is placed in the bottom IDEA’s tool panel. Clicking on a method in this list allows navigating to this method’s declaration</p>'
---