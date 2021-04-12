open Arg
open Printf


let () = 
        let ic = Unix.open_process in "pwd" in
        let all_input = ref [] in
        try 
                while true do
                all_input := input_line ic :: !all_input
        done
        with
              End_of_file -> close_in ic;
              List.iter print_endline !all_input
(*
let () =
        let speclist = [("-", Arg.String(get_dir), "arg input");] in
        let ug = "hi" in
        Arg.parse speclist print_endline ug;

(* Input commit id to be checked by Coccinelle
 * TODO : Fetch commit and diff *)
open Arg

let commit_id = ref "."
  
let set_commit_id input_id =                                 
  commit_id := input_id                                 

let () =                                 
begin
  let speclist = [("-c", Arg.String(set_commit_id), "flag to specify commit id");] in
  let usage_msg = "Usage: ./ic [OPTION] [COMMIT ID]" in
  Arg.parse speclist print_endline usage_msg;
  printf "Commit Id: %s\n" !commit_id;
end
*)
