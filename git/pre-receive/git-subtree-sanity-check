#!/bin/sh

reject()
{
  rev=$1
  module1=$2
  module2=$3

  echo ".------------------------------------------- Puppet Module Police ---"
  echo "| REJECTED!"
  echo "| Revision: $rev"
  echo "| Module 1: $module1"
  echo "| Module 2: $module2"
  echo "| Citation: Attempt to push commits referencing two seperate modules"
  echo "| Solution: Do not push commits which reference more than one module."
  echo "|           When making changes to multiple modules, make multiple"
  echo "|           commits. Please keep commit messages clean also."
  echo '`--------------------------------------------------------------------'
}

while read oldrev newrev ref; do
  revisions=`git log $oldrev...$newrev --format=oneline | cut -f 1 -d ' '`
  module1=
  for rev in $revisions; do
    echo $rev
    for path in `git diff --name-only ${rev}~1...${rev}`; do
      if [ -z "$module1" ]; then
        module1=`echo $path | sed -n 's/^modules\/[-a-z_]\+\/\(.*\)\/.*/\1/p'`
      else
        module2=`echo $path | sed -n 's/^modules\/[-a-z_]\+\/\(.*\)\/.*/\1/p'`
        if [ ! -z "$module2" -a ! "$module2" = "$module1" ]; then
          reject $rev $module1 $module2
          exit 1
        fi
      fi
    done
  done
done
