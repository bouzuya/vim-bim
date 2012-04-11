bim
==========

*THE CURRENT VERSION IS A BETA VERSION.*

bouzuya's input method for Vim.

Installation
----------

    curl -O http://openlab.ring.gr.jp/skk/dic/SKK-JISYO.S.gz
    gunzip SKK-JISYO.S.gz
    iconv -f euc-jp -t utf-8 SKK-JISYO.S -o SKK-JISYO.S.utf8
    echo let g:bim = {\'dict_path\': \'~/SKK-JISYO.S.utf8\'} >> ~/.vimrc
    git clone git://github.com/bouzuya/vim-bim.git ~/.vim/bundle/vim-bim/
    echo set runtimepath+=~/.vim/bundle/vim-bim/ >> ~/.vimrc

