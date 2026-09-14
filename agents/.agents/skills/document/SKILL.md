---
name: document
description: |
  Create a documentaton file using the 'showboat' cli tool
  Trigger: /document
---
Read the source and then plan a linear walkthrough of the code that explains how it all works in detail

Then run “uvx showboat –help” to learn showboat - use showboat to create a 
.scratch/walkthroughs/walkthrough_{some_relevant_name}.md file in the 
repo and build the walkthrough in there, 
using `showboat note` for commentary and 
`showboat exec` plus `sed` or `grep` or `cat` or whatever you need to 
include snippets of code you are talking about


