(lang dune 3.17)

(name reality_tailwindcss)

(version 1.0.0)

(generate_opam_files true)

(authors "Lomig <lomig@hey.com>")

(maintainers "Lomig <lomig@hey.com>")

(license GPL-3.0-only)

(package
 (name reality_tailwindcss)
 (synopsis "Install and Configure TailwindCSS with Dream")
 (description
  "Download and install TailwindCSS CLI and make it available in an OCaml project; a CLI tool is provided to easily generate a TailwindCSS configuration file to serve the TailwindCSS assets.")
 (depends ocaml containers extunix cohttp-lwt-unix)
 (tags
  ("tailwindcss" "tailwind" "dream" "reality")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
