open Containers

let help () =
  let help_text =
    {|RealityTailwindCSS - TailwindCSS integration tool for OCaml/Dream projects

USAGE:
  realitytailwindcss [OPTION]

OPTIONS:
  download [path]  Downloads the TailwindCSS CLI to the [path] directory
  install          Sets up TailwindCSS in a project, including configuration
  help             Display this help message

EXAMPLES:
  realitytailwindcss download bin/
  realitytailwindcss install

For more information, visit: https://github.com/Lomig/reality_tailwindcss|}
  in
  print_endline help_text
;;

let () =
  match
    ( Option.map String.lowercase_ascii @@ Array.get_safe Sys.argv 1
    , Array.get_safe Sys.argv 2 )
  with
  | Some "download", Some path -> Lwt_main.run @@ RealityTailwind.download path
  | Some "download", None -> help ()
  | Some "install", _ -> RealityTailwind.install ()
  | _ -> help ()
;;
