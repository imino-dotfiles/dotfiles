# Defined in - @ line 1
function tree --wraps=find\ .\ -print\ \|\ sed\ -e\ \'s\;\[\^/\]\*/\;\|____\;g\;s\;____\|\;\ \|\;g\' --description alias\ tree=find\ .\ -print\ \|\ sed\ -e\ \'s\;\[\^/\]\*/\;\|____\;g\;s\;____\|\;\ \|\;g\'
  find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' $argv;
end
