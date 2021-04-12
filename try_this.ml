let ini p =
        let c = p;
        Sys.mkdir c 700 

let () =
        let ic = Sys.getcwd() ^ "/.git" in
        ini ic
