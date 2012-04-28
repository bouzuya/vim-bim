bim
==========

*THE CURRENT VERSION IS A BETA VERSION.*

bouzuya's input method for Vim.

Installation
----------

    $ cd
    $ wget http://openlab.ring.gr.jp/skk/dic/SKK-JISYO.L.unannotated.gz
    $ gunzip SKK-JISYO.L.unannotated.gz
    $ iconv -f euc-jp -t utf-8 SKK-JISYO.L.unannotated > SKK-JISYO.L.unannotated.utf8
    $ echo let g:bim = {\'dict_path\': \'~/SKK-JISYO.L.unannotated.utf8\'} >> ~/.vimrc
    $ git clone git://github.com/bouzuya/vim-bim.git ~/.vim/bundle/vim-bim/
    $ echo set runtimepath+=~/.vim/bundle/vim-bim/ >> ~/.vimrc

