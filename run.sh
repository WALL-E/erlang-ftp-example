#!/bin/sh
#
#
#第一行 erlc hello.erl 会编译文件 hello.erl ，生成叫做 hello.beam 的代码文件。
#第一个命令拥有三个选项：
#
#-noshell ：启动Erlang而没有交互式shell，此时不会得到Erlang的启动信息来提示欢迎
#-s hello start ：运行函数 hello:start() ，注意使用 -s Mod … 选项时，相关的模块Mod必须已经编译完成了。
#-s init stop ：当我们调用 apply(hello,start,[]) 结束时，系统就会对函数 init:stop() 求值。
#
#命令 erl -noshell … 可以放入shell脚本，所以我们可以写一个shell脚本负责设置路径(使用-pa参数)和启动程序。
#在我们的例子中，我们使用了两个 -s 选项，我们可以在一行拥有多个函数。
#每个 -s 都会使用 apply 语句来求职，而且，在一个执行完成后才会执行下一
#
#


ERL=/usr/bin/erl
ERLC=/usr/bin/erlc

$ERLC ftptools.erl
$ERL -boot start_clean -noshell -smp +S 8 -s ftptools main -s init stop
