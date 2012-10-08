-module(ftptools).
-doc([{author, 'zhangz'},
      {title, "use ftp module to sync dir"},
      {keywords,[ftp,home,publish]},
      {date, 20121008}]).
 
-export([publish/5, main/0]).
 
publish(Host, User, Password, LocalDir, RemoteDir) ->
    case ftp:open(Host) of
    {ok, Pid} -> 
        case ftp:user(Pid, User, Password) of
        ok ->
            case ftp:cd(Pid, RemoteDir) of
            ok ->
                case file:list_dir(LocalDir) of
                {ok, Files} ->
                    lists:foreach(fun(I) ->
                           publish(I, LocalDir, Pid)
                       end, Files);
                {error, _} ->
                    exit({bad,local,directory, LocalDir})
                end;
            {error, Reason} ->
                exit({cannot,cd,to,RemoteDir,reason,Reason})
            end;
        {error, Reason} ->
            exit({cannot, login, as, User, reason, Reason})
        end;
    {error, Reason} ->
        exit({cannot,connect,to,Host, reason, Reason})
    end,
    ok.
publish(File, Dir, Pid) ->
    io:format("uploading ~s ... ", [File]),
    LocalFile = Dir ++ "/" ++ File,
    case ftp:send(Pid, LocalFile, File) of
    ok ->
        ok;
    {error, Reason} ->
        exit({cannot,send,file,File,reason,Reason})
    end,
    io:format("ok~n").


main() ->
    ftptools:publish("127.0.0.1","ftp","ftp@123", "/root/t","/pub").
