(*open Unix
*)

open Sys
open Printf
open Str

(* add error handling, what if file already exists?*)
(*let init pwd =
        let root_path = pwd;
        let git_path = root_path ^ "/.git";
        Sys.mkdir git_path 700 in
        print_endline git_path
*
* this gives error because there is no in after the statements
* also because there's an in after Sys.mkdir ; maybe because it returns unit, adding a semicolon instead makes it work
* *)


let init inp =
        let root_path = inp in
        let git_path = root_path ^ "/.git" in
        let object_path = git_path ^ "/objects" in
        let ref_path = git_path ^ "/refs" in
        print_endline ("Initialised empty git repository in " ^ git_path);
        Sys.mkdir git_path 0o775;
        Sys.mkdir object_path 0o775;
        Sys.mkdir ref_path 0o775;
        print_endline ref_path;
        print_endline object_path;
        print_endline inp

let list_files path =
        Array.to_list (Sys.readdir path)

(*Checks if file/folder is hidden*)
let is_hidden name =
        match Str.first_chars name 1 with
        | "." -> true
        | _ -> false

let rec files_to_commit l =
        match l with
        | [] -> []
        | hd :: tl ->
                match is_hidden hd with
                | false -> hd :: files_to_commit tl
                | _ ->  files_to_commit tl

let buf = Bytes.create 20000
let pass_blob file path =
        print_endline file;
        let fd = Unix.openfile file [Unix.O_RDONLY] 0o775 in
        let _data = Unix.read fd buf 0 20000 in
        print_endline "okay before here";

        let blo = Git_database.store_object (Bytes.to_string buf) in
        Git_database.write_object path blo


(*com here actually is useless I just don't know yet what to do with argless inputs*)
let commit _com =
        let root_path = Sys.getcwd() in
        let git_path = root_path ^ "/.git" in
        let db_path = git_path ^ "/objects" in
        let all_files = list_files root_path in
        let req_files = files_to_commit all_files in
        let rec fn l =
                match l with
                | [] -> ()
                | hd :: tl -> pass_blob hd db_path; fn tl in
        fn req_files



        (*let fl = Array.map remove_hidden l in
         Array.iter pass_blob (Array.map parse_ohwhy fl) db_path*)



(* helper to catch error becuase can't think of a better way rn
 * also, unless I pass s exactly formatted it doesn't work which is weird
 * it's like the type is also a function and needs just the right string for input which is
 * ....maybe doesn't really help
 *)
let dir_helper name =
        let _s = name^": No such file or directory" in
        try
                Sys.is_directory name;
        with
        |Sys_error _s -> false
(**)

(*Check if it is a directory, else take pwd by default.contents
 *this is probably good for now, but later it should just not default and return error
 *and have a separate option to *)

let get_dir dir_name =
        match dir_helper dir_name with
        |true ->  init dir_name
        |false -> print_endline "Invalid folder name.";
                  init (Sys.getcwd())


let rand inp = print_endline "illegal"; print_endline inp


let () =
        let speclist = [("-init", Arg.String(get_dir), "Initialise git");("-commit", Arg.String(commit), "Show files")] in
        Arg.parse speclist rand "Help menu"



(*
 * an error changed on changing Unix.getcwd -> Unix.getcwd()
 *
 * Using Unix.getcwd() required Unix which was unavailable so I
 * used Sys instead.
 *
 * to make it available I used unix.cma when compiling like
 *     `ocamlc unix.cma -o g try.ml`
 *  which works.
 * I read adding `#load 'unix.cma;;` at the top of file  will also work
 *)
