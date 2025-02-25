open Lwt.Syntax

external detect_os : unit -> string = "caml_detect_os"
external detect_architecture : unit -> string = "caml_detect_architecture"

let system_to_version () =
  match detect_os (), detect_architecture () with
  | "MacOS", "ARM64" -> "tailwindcss-macos-arm64"
  | "MacOS", "x64" -> "tailwindcss-macos-x64"
  | "Linux", "x64" -> "tailwindcss-linux-x64"
  | "Linux", "ARM64" -> "tailwindcss-linux-arm64"
  | "Windows", "x64" -> "tailwindcss-windows-x64.exe"
  | _ -> "tailwindcss-linux-x64"
;;

let rec download_with_redirects ~max_redirects uri target =
  if max_redirects <= 0
  then Lwt.fail_with "Too many redirects"
  else
    let* resp, body = Cohttp_lwt_unix.Client.get uri in
    let code = Cohttp.Response.status resp |> Cohttp.Code.code_of_status in
    match code with
    | 200 ->
      let stream = Cohttp_lwt.Body.to_stream body in
      Lwt_io.with_file ~mode:Lwt_io.output target (fun chan ->
        Lwt_stream.iter_s (Lwt_io.write chan) stream)
    | 301 | 302 | 307 | 308 ->
      (match Cohttp.Header.get (Cohttp.Response.headers resp) "location" with
       | Some location ->
         let new_uri = Uri.of_string location in
         download_with_redirects ~max_redirects:(max_redirects - 1) new_uri target
       | None -> Lwt.fail_with "Redirection response missing Location header")
    | _ -> Lwt.fail_with (Printf.sprintf "Failed to download: HTTP %d" code)
;;

let download target =
  let target = Filename.concat target "tailwindcss" in
  let version = system_to_version () in
  let base_url =
    "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/"
  in
  let uri = Uri.of_string (base_url ^ version) in
  download_with_redirects ~max_redirects:5 uri target
;;

let install = Installation.install
