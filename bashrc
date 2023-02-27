edit() {
    docker run --rm -it --hostname vim -v $PWD:$HOME/dev -v \
    $HOME/.vim/undodir:$HOME/.vim/undodir vim dev/$1
}
