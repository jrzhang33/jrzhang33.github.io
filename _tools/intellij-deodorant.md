---
title: "IntelliJDeodorant"
collection: tools
permalink: /tools/intellij-deodorant
tool: 'https://github.com/JetBrains-Research/IntelliJDeodorant'
tag: 'An IntelliJ IDEA plugin that detects code smells in Java code and recommends appropriate refactorings to resolve them.'
abstract: "<p><b>IntelliJDeodorant</b> is an IntelliJ IDEA plugin that detects code smells in Java code and recommends appropriate refactorings to resolve them. The tool supports several code smells, namely Feature Envy, Type/State Checking, Long Method, and God Class.</p>
<ul>
<li>Feature Envy occurs when a method uses attributes/methods of another class more than those of the enclosing class. The tool can detect such methods and suggest moving them to a more related class, i.e. perform a Move Method refactoring.</li>
<li>Type Checking relates to cases when an attribute, which determines the outcome of the program, is represented by complicated conditional statements. The tool detects such pieces of code and suggests a Replace Conditional with Polymorphism refactoring.</li>
<li>State Checking relates to cases when a set of conditional statements determine the outcome of the program by comparing the value of a variable representing the current state of an object with a set of named constants. The tool detects sets like this and suggests a Replace Type code with State/Strategy refactoring.</li>
<li>Long Method, as the name suggests, occurs when a method is too long and can be divided into several. For such methods, the tool identifies blocks of code that are responsible for calculating a variable and suggests extracting it into a separate method, i.e. perform an Extract Method refactoring.</li>
<li>God Class is a name given to a large and complex class that contains too many components. The tool identifies sets of attributes and methods in a class that could be moved into a separate class to simplify the understanding of the code, i.e. an Extract Class refactoring can be performed.</li></ul>"
---