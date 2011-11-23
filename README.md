# Website of the UCLouvain ACM Student Chapter

This project contains the source code of http://uclouvain.acm-sc.be, that is, the
website of the UCLouvain ACM Student Chapter.

## Enhancing/Updating/Adding static content

Most of the static content (texts, menus, etc.) is kept in partial html files 
in views and sub directories (especially in views/activites/*). 

* _.whtml_ denote static html files
* _.wtpl_ denote dynamic html files (for the wlang templating engine)

For updating and fixing typos, your best friend should be _grep_. For adding new
content, simply add directories and files; they will be automatically rendered 
in the master template. The _monkey see, monkey do_ rule applies here.
