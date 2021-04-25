open Uchar
open Bytes


(*This database module is supposed to store all our content in .git/objects*)

(*
data = read_file(path)
blob = Blob.new(data)
database.store(blob)
*)

type blob = {
  oid: string;
  content: string;
}

(*Takes a string(file contents), generates an encoded string from the file to be commited and an oid
 * Is create_object (_data) a better name?*)
let store_object data_from_file =
  let en_string = Bytes.of_string data_from_file in
  let content_data = "#" ^ "blob" ^
                "#" ^ string_of_int (length en_string) ^
                "#" ^ Bytes.to_string en_string in
  let oid_new = Sha1.to_hex (Sha1.string content_data) in
  {oid = oid_new; content = content_data}


(*Generate a random string of n letters*)
let gen_random_string n =
  let alphanum =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" in
  let len = String.length alphanum in
  let str = Bytes.create n in
  for i = 0 to n-1 do
      Bytes.set str i alphanum.[Random.int len]
  done;
  Bytes.to_string str
;;

let dir_helper name =
  let _s = name^": No such file or directory" in
  try
          Sys.is_directory name;
  with
  |Sys_error _s -> false

(*Supposed to write the blob contents to object files
 * Consider using temp_file functions from Filename module here instead*)
let write_object obj_path (b: blob) =
  let object_file_path = obj_path ^ "/" ^
                    String.sub b.oid 0 2 ^ "/" ^
                    String.sub b.oid 2 (String.length b.oid - 2) in
  let obj_dir_name = Filename.dirname object_file_path in
  let temp_path = obj_dir_name ^ "/" ^ gen_random_string 6 in
  let flags = [Unix.O_RDWR ; Unix.O_CREAT ; Unix.O_EXCL] in

  match dir_helper obj_dir_name with
  | false -> Unix.mkdir obj_dir_name 0o775
  | true ->
    let file_des = Unix.openfile temp_path flags 0o775 in
    let _ = Unix.write file_des (Bytes.of_string b.content) 0 20000 in
    (*compression step missing, add later; also add bytes length*)
    Unix.close file_des;

    Unix.rename temp_path object_file_path






let a = {oid= "198"; content= "hi"};;

let () =
  let h = store_object a.content in
  print_endline h.oid;
  print_string h.content