open Containers

let dune_file_content =
  {|

;------------------------------------------------------------------------------
; Reality Tailwind CSS
;------------------------------------------------------------------------------

(rule
 (target tailwindcss)
 (action
  (progn
   (run echo "Downloading Tailwind CSS...")
   (run reality_tailwindcss %{project_root}/bin)
   (run chmod +x %{target})))
 (mode fallback))

(rule
 (target application.css)
 (deps
  (:tailwindcss %{project_root}/bin/tailwindcss)
  (:input %{project_root}/lib/client/stylesheets/application.css)
  (source_tree %{project_root}/lib/client/stylesheets)
  (source_tree %{project_root}/lib/server/templates))
 (action
  (chdir
   %{project_root}/lib
   (progn
    (run echo "Building CSS...")
    (ignore-outputs
     (run
      %{tailwindcss}
      -i
      %{input}
      -o
      %{project_root}/../../static/application.css))
    (run cp %{project_root}/../../static/application.css %{target})))))
|}
;;

let print_step msg =
  Printf.printf "\027[0;34m→\027[0m %s...\n" msg;
  flush stdout
;;

let print_success msg =
  Printf.printf "\027[0;32m✓\027[0m %s\n" msg;
  flush stdout
;;

let print_error msg =
  Printf.printf "\027[0;31m✗\027[0m %s\n" msg;
  flush stdout
;;

let rec find_project_root current_dir =
  let dune_project = Filename.concat current_dir "dune-project" in
  if Sys.file_exists dune_project
  then Some current_dir
  else (
    let parent = Filename.dirname current_dir in
    if String.equal parent current_dir then None else find_project_root parent)
;;

let ensure_directory dir =
  if not (Sys.file_exists dir)
  then (
    print_step (Printf.sprintf "Creating directory %s" dir);
    print_success "Directory created")
;;

let project_root () =
  print_step "Looking for Dune project root";
  match find_project_root (Sys.getcwd ()) with
  | None ->
    print_error "Not in a Dream project (no dune-project file found)";
    exit 1
  | Some project_root ->
    print_success (Printf.sprintf "Found project root at %s" project_root);
    project_root
;;

let check_if_dream_project project_root =
  print_step "Looking for Dream project";
  let regexp =
    Re.seq
      [ Re.str "(depends"
      ; Re.rep1 (Re.alt [ Re.alnum; Re.str " "; Re.str "-"; Re.str "_" ])
      ; Re.str " dream "
      ; Re.rep1 (Re.alt [ Re.alnum; Re.str " "; Re.str "-"; Re.str "_" ])
      ; Re.str ")"
      ]
    |> Re.compile
  in
  let project_file = Filename.concat project_root "dune-project" in
  let file_content = IO.with_in project_file IO.read_all in
  match Re.execp regexp file_content with
  | true -> project_root
  | false ->
    print_error "Not in a Dream project (dune-project does not depend on Dream)";
    exit 1
;;

let append_to_dune project_root =
  print_step "Updating bin/dune configuration";
  let regexp = Re.seq [ Re.start; Re.str "; Reality Tailwind CSS" ] |> Re.compile in
  let dune_file = Filename.concat project_root "bin/dune" in
  let file_content = IO.with_in dune_file IO.read_all in
  (match Re.execp regexp file_content with
   | true -> print_error "Tailwind CSS already installed"
   | false ->
     IO.with_out_a dune_file (fun file -> IO.write_line file dune_file_content);
     print_success "Updated bin/dune configuration");
  project_root
;;

let create_dirs project_root =
  print_step "Creating directories";
  let dirs =
    [ Filename.concat project_root "static"
    ; Filename.concat project_root "lib"
    ; Filename.concat project_root "lib/client"
    ; Filename.concat project_root "lib/client/stylesheets"
    ]
  in
  List.iter ensure_directory dirs;
  print_success "Directories created";
  project_root
;;

let add_css_file project_root =
  print_step "Creating initial CSS file";
  let css_file = Filename.concat project_root "lib/client/stylesheets/application.css" in
  (match Sys.file_exists css_file with
   | true -> print_error "CSS file already exists"
   | false ->
     IO.with_out css_file (fun file -> IO.write_line file "@import \"tailwindcss\";");
     print_success "Created application.css");
  project_root
;;

let install () =
  let _ =
    project_root ()
    |> check_if_dream_project
    |> append_to_dune
    |> create_dirs
    |> add_css_file
  in
  print_success
    "TailwindCSS installation completed successfully! `dune build` to initialize the CSS"
;;
