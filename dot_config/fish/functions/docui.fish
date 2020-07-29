# Defined in - @ line 1
function docui --wraps='docker run --rm -itv /var/run/docker.sock:/var/run/docker.sock skanehira/docui' --description 'alias docui=docker run --rm -itv /var/run/docker.sock:/var/run/docker.sock skanehira/docui'
  docker run --rm -itv /var/run/docker.sock:/var/run/docker.sock skanehira/docui $argv;
end
