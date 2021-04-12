
(*
data = read_file(path)
blob = Blob.new(data)
database.store(blob)
*)

type blob {
  oid: String;
  data: String
};;

let store blo =
  let blo.data.to_string
